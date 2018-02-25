#lang racket

(require 2htdp/image 2htdp/universe lens "./fps.rkt")

(struct/lens world [data] #:transparent)

(define TICK-RATE 1/60)
(define SCENE-WIDTH 800)
(define SCENE-HEIGHT 600)
(define SQUARE-SIZE 10)
(define EMPTY-SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))

(define (start)
  (big-bang (world 0)
    (on-tick update-state TICK-RATE)
    (to-draw render-scene)
    (on-key handle-key)
    (stop-when over? handle-over)
    (close-on-stop 1)))

(define (update-state w) w)

;; draw a pixel at the pair p location in the scene s
(define (draw-pair p s)
  (place-image/align
   (square SQUARE-SIZE "solid" (color (random 255) (random 255) (random 255)))
   (car p) (cdr p) "left" "top" s))

(define (random-pair x) (cons (random (- SCENE-WIDTH SQUARE-SIZE)) (random (- SCENE-HEIGHT SQUARE-SIZE))))

(define (render-scene w)
  (add-fps (foldr draw-pair EMPTY-SCENE (build-list (expt 2 (world-data w)) random-pair))))

(define (handle-key w k)
  (let* ([old-data (world-data w)]
         [data (cond [(equal? k "up") (add1 old-data)]
                     [(equal? k "down") (sub1 old-data)]
                     [(equal? k "q") -1]
                     [else old-data])])
    (println (string-append "drawing " (number->string (expt 2 data)) " squares/tick"))
    (lens-set world-data-lens w data)))

(define (over? w) (equal? (world-data w) -1))
(define (handle-over w) EMPTY-SCENE)