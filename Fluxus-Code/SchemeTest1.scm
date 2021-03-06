;for use with SuperCollider
;run this in DrRacket IDE
(clear)
(start-audio "supercollider" 1024 44100)
(define pw 28)
(define ph 16)
(define p (build-nurbs-sphere pw ph))
(with-primitive p
(hint-none)
(hint-solid)
(hint-wire)
(hint-anti-alias)
(wire-colour (vector 1 1 1 .5))
(pdata-add "pos" "v")
(pdata-add "norm" "v")
(pdata-copy "p" "pos")
(pdata-copy "n" "norm"))
(blend-mode 'src-alpha 'one-minus-src-alpha)
(define fft-steps 32)
(define fft-matrix (build-list (* fft-steps 16) (lambda (x) 0)))
(define (update-fft-matrix)
(let ([current (map gh (build-list 16 values))])
(set! fft-matrix (list-tail fft-matrix 16))
(set! fft-matrix (append fft-matrix current))))
(define (fft-sphere)
(update-fft-matrix)
(with-primitive p
(pdata-index-map!
(lambda (i p)
(vadd (pdata-ref "pos" i)
(vmul (pdata-ref "norm" i) (list-ref fft-matrix i))))
"p")
(recalc-normals 0)))
(every-frame (fft-sphere))
