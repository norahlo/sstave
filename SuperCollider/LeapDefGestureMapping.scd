(
// l = Left Hand; r = Right Hand; O = open; C = Closed; P = Pitch; R = Roll; Yw = Yaw
// i.e: ~lOY = open left hand Y position; ~rP = right hand Pitch(open or closed);
//0
~l = Bus.control;~lO = Bus.control;~lC = Bus.control;
~r = Bus.control;~rO = Bus.control;~rC = Bus.control;
//6
~lX = Bus.control;~lOX  = Bus.control;~lCX = Bus.control;
~lY = Bus.control;~lOY  = Bus.control;~lCY = Bus.control;
~lZ = Bus.control;~lOZ  = Bus.control;~lCZ = Bus.control;
//15
~lP = Bus.control;~lOP  = Bus.control;~lCP = Bus.control;
~lR = Bus.control;~lOR  = Bus.control;~lCR = Bus.control;
~lYw = Bus.control;~lOYw  = Bus.control;~lCYw = Bus.control;
//24
~rX = Bus.control;~rOX  = Bus.control;~rCX = Bus.control;
~rY = Bus.control;~rOY  = Bus.control;~rCY = Bus.control;
~rZ = Bus.control;~rOZ  = Bus.control;~rCZ = Bus.control;
//33
~rP = Bus.control;~rOP  = Bus.control;~rCP = Bus.control;
~rR = Bus.control;~rOR  = Bus.control;~rCR = Bus.control;
~rYw = Bus.control;~rOYw  = Bus.control;~rCYw = Bus.control;
)

(
//Present
OSCdef(\osclO,{|msg| ~lO.set(msg[1]);~l.set(msg[1])},"/left/open/present");
OSCdef(\osclC,{|msg| ~lC.set(msg[1]);~l.set(msg[1])},"/left/closed/present");
OSCdef(\oscrO,{|msg|  ~rO.set(msg[1]);~r.set(msg[1])},"/right/open/present");
OSCdef(\oscrC,{|msg|~rC.set(msg[1]);~r.set(msg[1])},"/right/closed/present");
//left hand's Position
OSCdef(\osclOX,{|msg| ~lOX.set(msg[1]);~lX.set(msg[1])},"/left/open/posx");
OSCdef(\osclCX,{|msg| ~lCX.set(msg[1]);~lX.set(msg[1])},"/left/closed/posx");
OSCdef(\osclOY,{|msg| ~lOY.set(msg[1]);~lY.set(msg[1])},"/left/open/posy");
OSCdef(\osclCY,{|msg| ~lCY.set(msg[1]);~lY.set(msg[1])},"/left/closed/posy");
OSCdef(\osclOZ,{|msg| ~lOZ.set(msg[1]);~lZ.set(msg[1])},"/left/open/posz");
OSCdef(\osclCZ,{|msg| ~lCZ.set(msg[1]);~lZ.set(msg[1])},"/left/closed/posz");
//right hand's Position
OSCdef(\oscrOX,{|msg| ~rOX.set(msg[1]);~rX.set(msg[1])},"/right/open/posx");
OSCdef(\oscrCX,{|msg| ~rCX.set(msg[1]);~rX.set(msg[1])},"/right/closed/posx");
OSCdef(\oscrOY,{|msg| ~rOY.set(msg[1]);~rY.set(msg[1])},"/right/open/posy");
OSCdef(\oscrCY,{|msg| ~rCY.set(msg[1]);~rY.set(msg[1])},"/right/closed/posy");
OSCdef(\oscrOZ,{|msg| ~rOZ.set(msg[1]);~rZ.set(msg[1])},"/right/open/posz");
OSCdef(\oscrCZ,{|msg| ~rCZ.set(msg[1]);~rZ.set(msg[1])},"/right/closed/posz");
//left hand's Pitch, Roll and Yaw
OSCdef(\osclOP,{|msg| ~lOP.set(msg[1]);~lP.set(msg[1])},"/left/open/pitch");
OSCdef(\osclCP,{|msg| ~lCP.set(msg[1]);~lP.set(msg[1])},"/left/closed/pitch");
OSCdef(\osclOR,{|msg| ~lOR.set(msg[1]);~lR.set(msg[1])},"/left/open/roll");
OSCdef(\osclCR,{|msg| ~lCR.set(msg[1]);~lR.set(msg[1])},"/left/closed/roll");
OSCdef(\osclOYw,{|msg| ~lOYw.set(msg[1]);~lYw.set(msg[1])},"/left/open/yaw");
OSCdef(\osclCYw,{|msg| ~lCYw.set(msg[1]);~lYw.set(msg[1])},"/left/closed/yaw");
//right hand's Pitch, Roll and Yaw
OSCdef(\oscrOP,{|msg| ~rOP.set(msg[1]);~rP.set(msg[1])},"/right/open/pitch");
OSCdef(\oscrCP,{|msg| ~rCP.set(msg[1]);~rP.set(msg[1])},"/right/closed/pitch");
OSCdef(\oscrOR,{|msg| ~rOR.set(msg[1]);~rR.set(msg[1])},"/right/open/roll");
OSCdef(\oscrCR,{|msg| ~rCR.set(msg[1]);~rR.set(msg[1])},"/right/closed/roll");
OSCdef(\oscrOYw,{|msg| ~rOYw.set(msg[1]);~rYw.set(msg[1])},"/right/open/yaw");
OSCdef(\oscrCYw,{|msg| ~rCYw.set(msg[1]);~rYw.set(msg[1])},"/right/closed/yaw");
)

(//GUI
~guiLMMaster = Window("Leap Motion GUI",Rect(10,300,220,200)).front;
~xSliders = 2.collect({|i| Slider(~guiLMMaster,Rect(100*i+10,110,100,20))});
~ySliders = 2.collect({|i| Slider(~guiLMMaster,Rect(100*i+10,10,20,100))});
~xnumbers = 2.collect({|i| NumberBox(~guiLMMaster,Rect(100*i+10,132,35,15)).font_(Font(size:9))});
~ynumbers = 2.collect({|i| NumberBox(~guiLMMaster,Rect(100*i+47,132,35,15)).font_(Font(size:9))});

OSCdef(\oscGuiLeftOpenX,{|msg| {~xSliders[0].value_(1-msg[1]);
	~xnumbers[0].value_(msg[1])}.defer},"/left/open/posx");
OSCdef(\oscGuiLeftClosedX,{|msg| {~xSliders[0].value_(1-msg[1]);
	~xnumbers[0].value_(msg[1])}.defer},"/left/closed/posx");
OSCdef(\oscGuiLeftOpenY,{|msg| {~ySliders[0].value_(msg[1]);
	~ynumbers[0].value_(msg[1])}.defer},"/left/open/posy");
OSCdef(\oscGuiLeftClosedY,{|msg| {~ySliders[0].value_(msg[1]);
	~ynumbers[0].value_(msg[1])}.defer},"/left/closed/posy");

OSCdef(\oscGuiRightOpenX,{|msg| {~xSliders[1].value_(msg[1]);
	~xnumbers[1].value_(msg[1])}.defer},"/right/open/posx");
OSCdef(\oscGuiRightClosedX,{|msg| {~xSliders[1].value_(msg[1]);
	~xnumbers[1].value_(msg[1])}.defer},"/right/closed/posx");
OSCdef(\oscGuiRightOpenY,{|msg| {~ySliders[1].value_(msg[1]);
	~ynumbers[1].value_(msg[1])}.defer},"/right/open/posy");
OSCdef(\oscGuiRightClosedY,{|msg| {~ySliders[1].value_(msg[1]);
	~ynumbers[1].value_(msg[1])}.defer},"/right/closed/posy");
)

(
~toMax = NetAddr("127.0.0.1",57125);
~fwToMax = {|path,val| ~toMax.sendMsg(path.asString,val)};
OSCdef(\fwrox,{|msg| ~fwToMax.value(path:"/rposx",val:msg[1])},"/right/open/posx");
OSCdef(\fwrcx,{|msg| ~fwToMax.value(path:"/rposx",val:msg[1])},"/right/closed/posx");
OSCdef(\fwroy,{|msg| ~fwToMax.value(path:"/rposy",val:msg[1])},"/right/open/posy");
OSCdef(\fwrcy,{|msg| ~fwToMax.value(path:"/rposy",val:msg[1])},"/right/closed/posy");
OSCdef(\fwroz,{|msg| ~fwToMax.value(path:"/rposz",val:msg[1])},"/right/open/posz");
OSCdef(\fwrcz,{|msg| ~fwToMax.value(path:"/rposz",val:msg[1])},"/right/closed/posz");
)
