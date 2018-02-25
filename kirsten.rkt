;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname kirsten) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;#lang racket

; example sum 5 = 5 + 4 + 3 + 2 + 1 = 15
; example sum 3 = 3 + 2 + 1 = 6
; example sum 2 = 2 + 1 = 3
; example sum 0 = 0

(define (sum x)
  (cond [(zero? x) 0]
        [else (+ x (sum (sub1 x)))]))

(sum 5)
(sum 3)
(sum 2)
(sum 0)