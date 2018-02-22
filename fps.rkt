#lang racket
(require 2htdp/image 2htdp/universe lens)

(struct/lens fps [update-rate tick-number] #:transparent)
(struct/lens world [pixels fps] #:transparent)

(define world-fps-tick-lens (lens-compose fps-tick-number-lens world-fps-lens))

(define TICK-RATE 1/30)
(define SCENE-WIDTH 800)
(define SCENE-HEIGHT 600)
(define EMPTY-SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))

(define (start tick-rate)
  (define f(fps tick-rate 0))
  (big-bang (world 1 f)
    (on-tick update-state TICK-RATE)
    (to-draw render-scene)
    (on-key handle-key)
    (stop-when over? handle-over)
    (close-on-stop 1)))

;; key idea! use a different world on a different thread for the fps that uses the SAME scene as the original world

(define (update-state w)
  (lens-set world-fps-tick-lens w (add1 (lens-view world-fps-tick-lens w))))

;; draw a pixel at the pair p location in the scene s
(define (draw-pair p s)
  (place-image
   (square 1 "solid" (color (random 255) (random 255) (random 255)))
   (car p)
   (cdr p)
   s))

(define (random-pair x) (cons (random SCENE-WIDTH) (random SCENE-HEIGHT)))

(define (render-scene w)
  (foldr draw-pair EMPTY-SCENE
         (build-list (sqr (world-pixels w)) random-pair)))

(define (handle-key w k)
  (cond [(equal? k "up") (lens-set world-pixels-lens w (add1 (world-pixels w)))]
        [(equal? k "down") (lens-set world-pixels-lens w (sub1 (world-pixels w)))]
        [(equal? k "q") (lens-set world-pixels-lens w 0)]
        [else w]))

(define (over? w) (equal? (world-pixels w) 0))
(define (handle-over w) EMPTY-SCENE)


