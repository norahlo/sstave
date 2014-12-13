

//NB: Code still in Progress.

//to be used in conjunction with "LeapGestureMapping.scd"

s.boot;



Spec.add(\mixdww, [-1,1, \lin]);
Spec.add(\source1, [0,1, \lin]);
Spec.add(\source2, [0,1, \lin]);
Spec.add(\source3, [0,1, \lin]);

Ndef(\A,{
	arg ddparam = 0.2,gate = 1;
	var adparam,minfreq,maxfreq,knum,sig,sig2,mix;
	adparam = LFNoise2.kr(12).range(0.6,1);
	minfreq = Gendy1.ar(1,1,1,1,20,2060,initCPs:12).range(200,400);
	maxfreq = Gendy1.ar(1,1,1,1,20,2060,initCPs:12).range(2000,4000);
	knum = 1-~rY.kr*10+2;
	sig = {Gendy1.ar(6,6,adparam,ddparam,minfreq,maxfreq,1,0.01,initCPs:12,knum:knum)};
	sig2 = Gendy1.ar(6,6,adparam,ddparam,minfreq,maxfreq,1,0.01,initCPs:12,knum:knum);
	mix = XFade2.ar(sig2,[sig,sig],~rZ.kr);
	mix = mix * EnvGen.kr(Env.adsr,gate,doneAction:2);
	// mix = PitchShift.ar(mix,0.2,pitchRatio:~rYw.kr+1);
	/*mix = mix*(~r.kr+~l.kr).poll.clip(0,1)*/
	mix
});

~setddparam = {|roll|case
	{(roll <= 0.2) && (roll > -0.2)}{Ndef(\aalpha).set(\ddparam, 0.3)}
	{(roll > 0.2) || (roll < -0.4)}{Ndef(\aalpha).set(\ddparam,0.9)}};

Ndef(\N,{
	arg maxFreq = 3800;
	var ampScale,knum,sig;
	ampScale = ~rZ.kr+1*0.4;
	knum = ~rY.kr*10+2;
	sig = Gendy2.ar(3,3,0.1,0.4,1800,maxFreq,ampScale,0.1,12,knum,~rP.kr*2,3,1.4);
	// sig = Pan2.ar(sig,LFBrownNoise1.kr(~rX.kr+1*5).range(-1,1));
	sig
	// mix = mix*(~r.kr+~l.kr).clip(0,1);
});

~setmaxFreq = {|roll|case
	{(roll <= 0.2) && (roll > -0.2)}{Ndef(\bbeta).set(\maxFreq, 1800)}
	{(roll > 0.2) || (roll < -0.4)}{Ndef(\bbeta).set(\maxFreq, 3800)}};



//waveforms occuring randomly
~numSamples = 4096;
~grainBank = 10.collect{Array(~numSamples)};
~stepSize = {0.cauchy(0.1)};
~tempVal = 10.collect{0};
10.do({|ind|
	~numSamples.do({|i|
		if(1.0.rand.coin,
			{~tempVal[ind] = (~tempVal[ind] + ~stepSize.value).fold(-1,1);~grainBank[ind].add(~tempVal[ind])},
			{~tempVal[ind] = (~tempVal[ind] - ~stepSize.value).fold(-1,1);~grainBank[ind].add(~tempVal[ind])})})});
~grainBankLP = ~grainBank.size.collect({|index|
	~grainBank[index].size.collect({|i,num = 40|
	if( i < (~grainBank[index].size-(num-1)),
			{(~grainBank[index][(i..(i+(num-1)))]).sum/num},
			{(~grainBank[index][(i..(~grainBank[index].size-1))]++(~grainBank[index][(0..((num-1)-(~grainBank[index].size-i)))])).sum/num} )})});
10.do({|i| ~grainBankLP[i] = ~grainBankLP[i].normalize(-1,1)});
~grainBufs = ~grainBankLP.size.collect({|i| Buffer.loadCollection(s,~grainBankLP[i])});
);

Ndef(\cgamma,{var freq, randfac,sig;
	randfac = LFBrownNoise1.ar(~lX.kr+1*0.5*20+0.2,4).range(80,230)+0.01;
	freq =~lY.kr.linexp(0.01,1,0.01,1) * randfac;
	sig = Osc.ar(~grainBufs[0],[freq,freq+0.6.rand+~lZ.kr+1*0.5*3]);
	sig = sig * ~l.kr.lag(0.2);
	sig*0.05;
});


Ndef(\MixSources,{
	(Ndef(\aalpha).ar*\source1.kr(1,0))+
	(Ndef(\bbeta).ar*\source2.kr(0,0))+
	(Ndef(\cgamma).ar*\source3.kr(0,0))});

Ndef(\F1,{
	arg mixdww = 0;
	var in,sig;
	in = Ndef(\sourcesMix).ar;
	sig = FFT({LocalBuf(2048)}!2,in);
	sig = PV_MagFreeze(sig,~lC.kr);
	sig = IFFT(sig);
	sig = XFade2.ar(in,sig,mixdww);
	sig;
});

Ndef(\eallpass,{
	arg mixdww = -1;
	var in,sig;
	in = Ndef(\dfrez).ar;
	sig = AllpassC.ar(in,0.5,SinOsc.ar(~lY.kr*12+0.2).range(0.02,0.5),0.3);
	sig = XFade2.ar(in,sig,mixdww);
	sig*0.5;});


Ndef(\ffilter,{
	arg mixdww = -1;
	var in,sig;
	in = Ndef(\eallpass).ar;
	sig = BPF.ar(in,(~lY.kr.lag2(0.1)*3000+80),0.2,1.4);
	sig = XFade2.ar(in,sig,mixdww);
	sig;});

Ndef(\gpan,{
	arg mixdww = -1;
	var inl,inr,sigl,sigr;
	inl = Ndef(\ffilter).ar(numChannels:1,offset:0);
	inr = Ndef(\ffilter).ar(numChannels:1,offset:1);
	sigl = Pan2.ar(inl,SinOsc.ar(~lY.kr*2));
	sigr = Pan2.ar(inr,SinOsc.ar(~rY.kr*3,1.75*pi));
	XFade2.ar(Ndef(\ffilter).ar,sigl+sigr,mixdww);
})


Ndef(\dyn, {
	var in;
	in = Ndef(\source1).ar;
	DynKlank.ar(`[{LFNoise2.kr(0.1).range(200, 720)} ! 20 * 2, 0.01, \dec.kr(0.6) ! 20], in)
});

Ndef(\dynQ, {
	var in;
	in = Ndef(\source2).ar;
	DynKlank.ar(`[{LFNoise2.kr(0.1).range(200, 720).midicps.round(1).cpsmidi} ! 20 * 2, 0.01, \dec.kr(0.6) ! 20], in)
});





Ndef(\frez, {
	var in, chain;
	in = Ndef(\source3).ar;
	chain = FFT({LocalBuf(2048)} ! 2, in);
	chain = PV_MagFreeze(chain, 1 - Trig1.kr(Impulse.kr(\rate.kr(1))));
	IFFT(chain);
});


//GUI!!
(
~timergui = Window("Timer",Rect(300,180,300,220)).front;
~timestring = StaticText(~timergui,Rect(0,0,300,180)).string_("Time").font_(Font(size:72,bold:true)).align_(\center);
~pfmCues = StaticText(~timergui,Rect(0,180,300,40)).string_("XXXXXXXXXXXXXX").font_(Font(size:24,bold:true)).align_(\center);
Tdef(\timer,{
	var start = SystemClock.seconds;
	var tophone = NetAddr("169.254.97.75",9000);
	loop({var now = SystemClock.seconds;
		now = now-start;
		{~timestring.string_(now.asTimeString[3..7])}.defer;
		// tophone.sendMsg("/time",now.asTimeString[3..7]);
		1.wait})});

OSCdef(\oscStart,{|msg| msg[1].postln;
	if(msg[1] == 1,{Ndef(\gpan).play;Tdef(\timer).play(quant:0)})},"/right/open/present").oneShot;

OSCdef(\oscrOR2,{|msg|
~setddparam.value(roll:msg[1]);~setmaxFreq.value(roll:msg[1])},"/right/open/roll");
OSCdef(\oscrCR2,{|msg| ~setddparam.value(roll:msg[1]);~setmaxFreq.value(roll:msg[1])},"/right/closed/roll");

MIDIIn.connectAll;

~vols = 0 ! 8;

MIDIdef.cc(\midislids,{|val,num| if(num < 4,{var setvol = val*0.00787;
	Ndef(\sourcesMix).set("source%".format(num+1).asSymbol,setvol);~vols[num] = setvol})});

~effects = [Ndef(\dfrez),Ndef(\eallpass),Ndef(\ffilter),Ndef(\gpan)];

MIDIdef.cc(\midiknobs,{|val,num| if((num > 15) && (num < 24),
	{var setmix = val*0.01574-1;
		~effects[num-16].set(\mixdww,setmix);
		})});

4.do({|i| NdefGui(~effects[i],bounds:Rect(10,170*i+400),)});

NdefGui(Ndef(\sourcesMix),bounds:Rect(10,200));


)


