;to be used in conjunction with "LeapCode.scd"
;Make sure Leap is connected
;run this in DrRacket IDE


(clear)
(start-audio "supercollider" 1024 44100)
(hint-none)
(hint-wire)
(hint-points)
(define (oax)
(scale 0.5)
(for ([i '(1 2 3 4 5 6 7 8)])
(clear-colour (/ 0.5(gh 14)))
(colour(vector (* 1(sin(time))) (* -0.5(cos(time))) (* 0.25(cos(time)))))
(translate(vector (/ 32(gh 10)) 0 0))
(rotate(vector (* (gh 9)(time)) 0 0))
(point-width (* 4(gh 4)))
(draw-sphere)
(with-state
(colour(vector (* 0.5(sin(time))) (* -1(cos(time))) (* 0.5(cos(time)))))
(translate(vector 0 0 (* 10(sin(time)))))
(rotate(vector (* 360(time)) 0 0))
(line-width (* (gh 11)(tan(time))))
(wire-colour(rndvec))
(draw-sphere)
)
(with-state
(colour(vector (* 1(sin(time))) (* -1(cos(time))) (* 1(cos(time)))))
(translate(vector 0 0 (* 4(cos(time)))))
(rotate(vector (* 360(time)) 0 0))
(line-width (* 20(sin(time))))
(wire-colour (vector (* 1(sin(time))) (* 1(sin(time))) (* 1(sin(time)))))
(draw-sphere)
)
)
)
(blur 0.9)
(every-frame (oax))
