#lang racket

; Chapter 1

(define atom? (lambda (x) (and (not (pair? x)) (not (null? x)))))

; Chapter 2

(define lat? (lambda (l) (or (null? l) (and (atom? (car l)) (lat? (cdr l))))))

(define member?
  (lambda (a lat)
    (cond
      [(null? lat) #f]
      [else (or (eq? (car lat) a) (member? a (cdr lat)))])))

; Chapter 3

(define firsts
  (lambda (l)
    (cond
      [(null? l) empty]
      [else (cons (caar l) (firsts (cdr l)))])))

(define subst2
  (lambda (new o1 o2 lat)
    (cond
      [(null? lat) empty]
      [(or (eq? (car lat) o1) (eq? (car lat) o2)) (cons new (cdr lat))]
      [else (cons (car lat) (subst2 new o1 o2 (cdr lat)))])))

(define multirember
  (lambda (a lat)
    (cond
      [(null? lat) empty]
      [(eq? (car lat) a) (multirember a (cdr lat))]
      [else (cons (car lat) (multirember a (cdr lat)))])))

(define multiinsertR
  (lambda (new old lat)
    (cond
      [(null? lat) empty]
      [(eq? (car lat) old)
       (cons (car lat) (cons new (multiinsertR new old (cdr lat))))]
      [else (cons (car lat) (multiinsertR new old (cdr lat)))])))

(define multiinsertL
  (lambda (new old lat)
    (cond
      [(null? lat) empty]
      [(eq? (car lat) old)
       (cons new (cons old (multiinsertL new old (cdr lat))))]
      [else (cons (car lat) (multiinsertL new old (cdr lat)))])))

(define multisubst
  (lambda (new old lat)
    (cond
      [(null? lat) empty]
      [(eq? (car lat) old) (cons new (multisubst new old (cdr lat)))]
      [else (cons (car lat) (multisubst new old (cdr lat)))])))

; Chapter 4
(define add1 (lambda (n) (+ n 1)))
(define sub1 (lambda (n) (- n 1)))

(define add (lambda (a b) (if (zero? b) a (add (add1 a) (sub1 b)))))

(define sub (lambda (a b) (if (zero? b) a (sub1 (sub a (sub1 b))))))

(define addtup
  (lambda (tup)
    (cond
      [(null? tup) 0]
      [else (add (car tup) (addtup (cdr tup)))])))

(define mult (lambda (a b) (if (zero? b) 0 (+ (mult a (sub1 b)) a))))

(define tup+
  (lambda (tup1 tup2)
    (if (and (null? tup1) (null? tup2))
        empty
        (cons (+ (car tup1) (car tup2)) (tup+ (cdr tup1) (cdr tup2))))))

(define >
  (lambda (a b)
    (cond
      [(zero? a) #f]
      [(zero? b) #t]
      [else (> (sub1 a) (sub1 b))])))

(define <
  (lambda (a b)
    (cond
      [(zero? b) #f]
      [(zero? a) #t]
      [else (< (sub1 a) (sub1 b))])))

(define =
  (lambda (a b)
    (cond
      [(zero? b) (zero? a)]
      [(zero? a) #f]
      [else (= (sub1 a) (sub1 b))])))

(define exp (lambda (a b) (if (zero? b) 1 (mult (exp a (sub1 b)) a))))

(define div
  (lambda (a b)
    (cond
      [(< a b) 0]
      [else (add1 (div (sub a b) b))])))

(define length (lambda (lat) (if (null? lat) 0 (add1 (length (cdr lat))))))

(define pick
  (lambda (n lat)
    (cond
      [(zero? (sub1 n)) (car lat)]
      [else (pick (sub1 n) (cdr lat))])))

(define no-nums
  (lambda (lat)
    (cond
      [(null? lat) empty]
      [(number? (car lat)) (no-nums (cdr lat))]
      [else (cons (car lat) (no-nums (cdr lat)))])))

(define all-nums
  (lambda (lat)
    (cond
      [(null? lat) empty]
      [(number? (car lat)) (cons (car lat) (all-nums (cdr lat)))]
      [else (all-nums (cdr lat))])))

(define eqan?
  (lambda (a1 a2)
    (cond
      [(and (number? a1) (number? a2)) (= a1 a2)]
      [(or (number? a1) (number? a2)) #f]
      [else (eq? a1 a2)])))

(define occur
  (lambda (a lat)
    (cond
      [(null? lat) 0]
      [(eq? (car lat) a) (add1 (occur a (cdr lat)))]
      [else (occur a (cdr lat))])))

(define one? (lambda (n) (= n 1)))

(define rempick
  (lambda (n lat)
    (cond
      [(one? n) (cdr lat)]
      [else (cons (car lat) (rempick (sub1 n) (cdr lat)))])))

; Chapter 5

(define rember*
  (lambda (a l)
    (cond
      [(null? l) '()]
      [(eq? a (car l)) (rember* a (cdr l))]
      [(atom? (car l)) (cons (car l) (rember* a (cdr l)))]
      [else (cons (rember* a (car l)) (rember* a (cdr l)))])))

(define insertR*
  (lambda (new old l)
    (cond
      [(null? l) '()]
      [(atom? (car l))
       (cond
         [(eq? (car l) old) (cons old (cons new (insertR* new old (cdr l))))]
         [else (cons (car l) (insertR* new old (cdr l)))])]
      [else (cons (insertR* new old (car l)) (insertR* new old (cdr l)))])))

(define occur*
  (lambda (a l)
    (cond
      [(null? l) 0]
      [(eq? a (car l)) (add1 (occur* a (cdr l)))]
      [(atom? (car l)) (occur* a (cdr l))]
      [else (+ (occur* a (car l)) (occur* a (cdr l)))])))

(define subst*
  (lambda (new old l)
    (cond
      [(null? l) '()]
      [(atom? (car l))
       (cond
         [(eq? (car l) old) (cons new (subst* new old (cdr l)))]
         [else (cons (car l) (subst* new old (cdr l)))])]
      [else (cons (subst* new old (car l)) (subst* new old (cdr l)))])))

(define insertL*
  (lambda (new old l)
    (cond
      [(null? l) '()]
      [(atom? (car l))
       (cond
         [(eq? (car l) old) (cons new (cons old (insertL* new old (cdr l))))]
         [else (cons (car l) (insertL* new old (cdr l)))])]
      [else (cons (insertL* new old (car l)) (insertL* new old (cdr l)))])))

(define member*
  (lambda (a l)
    (cond
      [(null? l) #f]
      [(atom? (car l))
       (cond
         [(eq? a (car l)) #t]
         [else (member* a (cdr l))])]
      [else (or (member* a (car l)) (member* a (cdr l)))])))

(define leftmost
  (lambda (l)
    (cond
      [(atom? (car l)) (car l)]
      [else (leftmost (car l))])))

(define equal?
  (lambda (s1 s2)
    (cond
      [(and (atom? s1) (atom? s2)) (eqan? s1 s2)]
      [(or (atom? s1) (atom? s2)) #f]
      [else (eqlist? s1 s2)])))

(define eqlist?
  (lambda (l1 l2)
    (cond
      [(and (null? l1) (null? l2)) #t]
      [(or (null? l1) (null? l2)) #f]
      [else (and (equal? (car l1) (car l2)) (eqlist? (cdr l1) (cdr l2)))])))

(define rember
  (lambda (s l)
    (cond
      [(null? l) empty]
      [(equal? (car l) s) (cdr l)]
      [else (cons (car l) (rember s (cdr l)))])))

; Chapter 6
(define numbered?
  (lambda (s)
    (cond
      [(atom? s) (number? s)]
      [(eq? (operator s) '+)
       (and (numbered? (1st-sub-exp s)) (numbered? (2nd-sub-exp s)))]
      [(eq? (operator s) 'x)
       (and (numbered? (1st-sub-exp s)) (numbered? (2nd-sub-exp s)))]
      [(eq? (operator s) 'exp)
       (and (numbered? (1st-sub-exp s)) (numbered? (2nd-sub-exp s)))])))

(define 1st-sub-exp (lambda (aexp) (car aexp)))

(define 2nd-sub-exp (lambda (aexp) (caddr aexp)))

(define operator (lambda (aexp) (cadr aexp)))

(define sero? (lambda (n) (null? n)))

(define edd1 (lambda (n) (cons empty n)))

(define zub1 (lambda (n) (cdr n)))


; Chapter 7

(define set?
  (lambda (lat)
    (cond
      [(null? lat) #t]
      [(member? (car lat) (cdr lat)) #f]
      [else (set? (cdr lat))])))

(define makeset
  (lambda (lat)
    (cond
      [(null? lat) empty]
      [else (cons (car lat) (makeset (multirember (car lat) (cdr lat))))])))

(define subset?
  (lambda (set1 set2)
    (cond
      [(null? set1) #t]
      [else (and (member? (car set1) set2) (subset? (cdr set1) set2))])))

(define eqset?
  (lambda (set1 set2) (and (subset? set1 set2) (subset? set2 set1))))

(define intersect?
  (lambda (set1 set2)
    (cond
      [(null? set1) #f]
      [else (or (member? (car set1) set2) (intersect? (cdr set1) set2))])))

(define intersect
  (lambda (set1 set2)
    (cond
      [(null? set1) empty]
      [(member? (car set1) set2) (cons (car set1) (intersect (cdr set1) set2))]
      [else (intersect (cdr set1) set2)])))

(define union
  (lambda (set1 set2)
    (cond
      [(null? set1) set2]
      [(member? (car set1) set2) (union (cdr set1) set2)]
      [else (cons (car set1) (union (cdr set1) set2))])))

(define difference
  (lambda (set1 set2)
    (cond
      [(null? set1) empty]
      [(member? (car set1) set2) (difference (cdr set1) set2)]
      [else (cons (car set1) (difference (cdr set1) set2))])))

(define intersectall
  (lambda (l-set)
    (cond
      [(null? (cdr l-set)) (car l-set)]
      [else (intersect (car l-set) (intersectall (cdr l-set)))])))

(define a-pair?
  (lambda (x)
    (cond
      [(atom? x) #f]
      [(null? x) #f]
      [(null? (cdr x)) #f]
      [(null? (cdr (cdr x))) #t]
      [else #f])))

(define first car)

(define second cadr)

(define third caddr)

(define build
  (lambda (sl s2)
    (cond
      [else (cons sl (cons s2 empty))])))

(define fun? (lambda (rel) (set? (firsts rel))))

(define revpair (lambda (pair) (build (second pair) (first pair))))

(define revrel
  (lambda (rel)
    (cond
      [(null? rel) empty]
      [else (cons (revpair (car rel)) (revrel (cdr rel)))])))

(define seconds
  (lambda (l)
    (cond
      [(null? l) empty]
      [else (cons (cadar l) (seconds (cdr l)))])))

(define fullfun? (lambda (fun) (set? (seconds fun))))

(define one-to-one? (lambda (fun) (fun? (revrel fun))))

; Chapter 8

(define eq?-c (lambda (a) (lambda (x) (eq? x a))))

(define rember-f
  (lambda (test?)
    (lambda (a l)
      (cond
        [(null? l) empty]
        [(test? (car l) a) (cdr l)]
        [else (cons (car l) ((rember-f test?) a (cdr l)))]))))

(define insertL-f
  (lambda (test?)
    (lambda (new old l)
      (cond
        [(null? l) empty]
        [(test? (car l) old) (cons new (cons old (cdr l)))]
        [else (cons (car l) ((insertL-f test?) new old (cdr l)))]))))

(define insertR-f
  (lambda (test?)
    (lambda (new old l)
      (cond
        [(null? l) empty]
        [(test? (car l) old) (cons old (cons new (cdr l)))]
        [else (cons (car l) ((insertR-f test?) new old (cdr l)))]))))

(define seqL (lambda (new old l) (cons new (cons old l))))

(define seqR (lambda (new old l) (cons old (cons new l))))

(define insert-g
  (lambda (seq)
    (lambda (new old l)
      (cond
        [(null? l) empty]
        [(eq? (car l) old) (seq new old (cdr l))]
        [else (cons (car l) ((insert-g seq) new old (cdr l)))]))))

(define insertL (insert-g seqL))

(define insertR (insert-g seqR))

(define seqS (lambda (new old l) (cons new l)))

(define subst (insert-g seqS))

(define atom-to-function
  (lambda (x)
    (cond
      [(eq? x '+) add]
      [(eq? x 'x) mult]
      [else exp])))

(define value1
  (lambda (nexp)
    (cond
      [(atom? nexp) nexp]
      [else
       ((atom-to-function (operator nexp)) (value1 (1st-sub-exp nexp))
                                           (value1 (2nd-sub-exp nexp)))])))

(define multirember-f
  (lambda (test?)
    (lambda (a lat)
      (cond
        [(null? lat) empty]
        [(test? a (car lat)) ((multirember-f test?) a (cdr lat))]
        [else (cons (car lat) ((multirember-f test?) a (cdr lat)))]))))

(define multirember-eq? (multirember-f eq?))

(define eq?-tuna (eq?-c (quote tuna)))

;(define rember-f
;  (lambda (test?)
;    (lambda (a l)
;      (cond
;        [(null? l) (quote ())]
;        [(test? (car l) a) (cdr l)]
;        [else (cons (car l) ((rember-f test?) a (cdr l)))]))))

;(define insertL*
;  (lambda (new old l)
;    (cond
;      [(null? l) '()]
;      [(atom? (car l))
;       (cond
;         [(eq? (car l) old) (cons new (cons old (insertL* new old (cdr l))))]
;         [else (cons (car l) (insertL* new old (cdr l)))])]
;      [else (cons (insertL* new old (car l)) (insertL* new old (cdr l)))])))

;(define insertL
;  (lambda (test?)
;    (lambda (new old lat)
;      (cond
;        [(null? lat) '()]
;        [(test? (car lat) old) (cons new (cons old (cdr lat)))]
;        [else (cons (car lat) ((insertL test?) new old (cdr lat)))]))))

;(define insertR
;  (lambda (test?)
;    (lambda (new old lat)
;      (cond
;        [(null? lat) '()]
;        [(test? (car lat) old) (cons old (cons new (cdr lat)))]
;        [else (cons (car lat) ((insertR test?) new old (cdr lat)))]))))

; (define seqL (lambda (a b c) (cons a (cons b c))))

; (define seqR (lambda (a b c) (cons b (cons a c))))

;(define insert-g
;  (lambda (seq)
;    (lambda (new old lat)
;      (cond
;        [(null? lat) '()]
;        [(eq? (car lat) old) (seq new old (cdr lat))]
;        [else (cons (car lat) ((insert-g seq) new old (cdr lat)))]))))

(define seqCarl (lambda (a b c) (cons a c)))

;(define atom-to-function
;  (lambda (x)
;    (cond
;      [(eq? x '+) +]
;      [(eq? x '*) *]
;      [else expt])))

; (define operator car)

(define value!
  (lambda (nexp)
    (cond
      [(atom? nexp) nexp]
      [else
       ((atom-to-function (operator nexp)) (value! (cadr nexp))
                                           (value! (caddr nexp)))])))

;(define multirember-f
;  (lambda (test?)
;    (lambda (a lat)
;      (cond
;        [(null? lat) (quote ())]
;        [(test? (car lat) a) ((multirember-f test?) a (cdr lat))]
;        [else (cons (car lat) ((multirember-f test?) a (cdr lat)))]))))

(define multiremberT
  (lambda (f lat)
    (cond
      [(null? lat) '()]
      [(f (car lat)) (multiremberT f (cdr lat))]
      [else (cons (car lat) (multiremberT f (cdr lat)))])))

;(define multiinsertL
;  (lambda (new old lat)
;    (cond
;      [(null? lat) (quote ())]
;      [(eq? (car lat) old)
;       (cons new (cons old (multiinsertL new old (cdr lat))))]
;      [else (cons (car lat) (multiinsertL new old (cdr lat)))])))

;(define multiinsertR
;  (lambda (new old lat)
;    (cond
;      [(null? lat) (quote ())]
;      [(eq? (car lat) old)
;       (cons old (cons new (multiinsertR new old (cdr lat))))]
;      [else (cons (car lat) (multiinsertR new old (cdr lat)))])))

(define multiinsertLR
  (lambda (new oldL oldR lat)
    (multiinsertL new oldL (multiinsertR new oldR lat))))

(define mlr
  (lambda (new oldL oldR lat col)
    (cond
      [(null? lat) (col '() 0 0)]
      [(eq? oldL (car lat))
       (mlr new
            oldL
            oldR
            (cdr lat)
            (lambda (newlat L R)
              (col (cons new (cons oldL newlat)) (add1 L) R)))]
      [(eq? oldR (car lat))
       (mlr new
            oldL
            oldR
            (cdr lat)
            (lambda (newlat L R)
              (col (cons oldR (cons new newlat)) L (add1 R))))]
      [else
       (mlr new
            oldL
            oldR
            (cdr lat)
            (lambda (newlat L R)
              (col (cons (car lat) newlat) L R)))]))) ; ; Empty result.

; (mlr 'x 1 2 '(3 2 1 4) (lambda (a b c) (list b c a))) ; '(1 1 (3 2 x x 1 4))

(define banana* (lambda (l) 'banana))

(define evens-only*
  (lambda (l)
    (cond
      [(null? l) empty]
      [(and (atom? (car l)) (even? (car l)))
       (cons (car l) (evens-only* (cdr l)))]
      [(atom? (car l)) (evens-only* (cdr l))]
      [else (cons (evens-only* (car l)) (evens-only* (cdr l)))])))

; (evens-only* '(1 2 (2 5 3 4 (2 2 2 3) (0 2 1) (())) 7))

; Chapter 9

(define looking (lambda (a lat) (keep-looking a (pick 1 lat) lat)))

(define keep-looking
  (lambda (a i lat)
    (cond
      [(equal? a i) #t]
      [(number? i) (keep-looking a (pick i lat) lat)]
      [else #f])))

(define keep-looking2
  (lambda (a sorn lat)
    (cond
      [(number? sorn) (keep-looking2 a (pick sorn lat) lat)]
      [else (eq? sorn a)])))

; (looking 'cookies '(2 4 cookies 7))

(define shift
  (lambda (l)
    (cond
      [(atom? (car l)) l]
      [else
       (shift (cons (car (car l))
                    (cons (cons (pick 2 (car l)) (cdr l)) '())))])))

(define shift2
  (lambda (l)
    (cond
      [(atom? (first l)) l]
      [else
       (shift2 (build (first (first l))
                      (shift2 (build (second (first l)) (second l)))))])))

(define countargs
  (lambda (pora)
    (cond
      [(atom? pora) 1]
      [else (+ (countargs (first pora)) (countargs (second pora)))])))

(define will-stop?
  (lambda (f)
    (begin
      (f '())
      #t)))

(define eternity (lambda (x) (eternity x))) ; ; Empty result.

;((lambda (length)
;   (lambda (l)
;     (cond
;       [(null? l) 0]
;       [else (add1 (length (cdr l)))])))
; eternity)
;
;(((lambda (length)
;    (lambda (l)
;      (cond
;        [(null? l) 0]
;        [else (add1 (length (cdr l)))])))
;  ((lambda (length)
;     (lambda (l)
;       (cond
;         [(null? l) 0]
;         [else (add1 (length (cdr l)))])))
;   ((lambda (length)
;      (lambda (l)
;        (cond
;          [(null? l) 0]
;          [else (add1 (length (cdr l)))])))
;    eternity)))
; '(1 2))

;(((lambda (mk-length) (mk-length mk-length))
;  (lambda (mk-length)
;    (lambda (l)
;      (cond
;        [(null? l) 0]
;        [else (add1 (mk-length (cdr l)))]))))
; '(a))


(define filter
  (lambda (f lat)
    (cond
      [(null? lat) '()]
      [(not (f (car lat))) (filter f (cdr lat))]
      [(cons (car lat) (filter f (cdr lat)))])))

(define nnot (lambda (f) (lambda (x) (not (f x)))))

(define comp (lambda (f g) (lambda (x) (f (g x)))))


(((lambda (mk-length) (mk-length mk-length))
  (lambda (mk-length)
    (lambda (l)
      (cond
        [(null? l) 0]
        [else (add1 ((mk-length mk-length) (cdr l)))]))))
 '(a b c))

(((lambda (mk-length) (mk-length mk-length))
  (lambda (mk-length)
    ((lambda (length)
       (lambda (l)
         (cond
           [(null? l) 0]
           [else (add1 (length (cdr l)))])))
     (lambda (x) ((mk-length mk-length) x)))))
 '(a b c))

(define Y
  (lambda (g) ((lambda (f) (f f)) (lambda (f) (g (lambda (x) ((f f) x)))))))

(define YY (lambda (f) ((lambda (x) (f (x x))) (lambda (x) (f (x x))))))

(((lambda (g) ((lambda (f) (f f)) (lambda (f) (g (lambda (x) ((f f) x))))))
  (lambda (length)
    (lambda (l)
      (cond
        [(null? l) 0]
        [else (add1 (length (cdr l)))]))))
 '(1 2 3))


; Chapter 10

'((a b c) (1 2 1))

(define new-entry build)

(define lookup-in-entry
  (lambda (name entry entry-f)
    (lookup-in-entry-help name (first entry) (second entry) entry-f)))

(define lookup-in-entry-help
  (lambda (name names values entry-f)
    (cond
      [(null? names) (entry-f name)]
      [(eq? name (first names)) (first values)]
      [else (lookup-in-entry-help name (cdr names) (cdr values) entry-f)])))

(lookup-in-entry 'c '((a b c) (1 1 1)) (lambda (x) x))

(define extend-table cons)

(define lookup-in-table
  (lambda (name table table-f)
    (cond
      [(null? table) (table-f name)]
      [else
       (lookup-in-entry
        name
        (car table)
        (lambda (name) (lookup-in-table name (cdr table) table-f)))])))

(lookup-in-table 'g '(((a b c) (1 2 3)) ((d e f) (4 5 6))) (lambda (x) x))

(define atom-to-action
  (lambda (e)
    (cond
      [(number? e) *const]
      [(eq? e #t) *const]
      [(eq? e #f) *const]
      [(eq? e (quote cons)) *const]
      [(eq? e (quote car)) *const]
      [(eq? e (quote cdr)) *const]
      [(eq? e (quote null?)) *const]
      [(eq? e (quote eq?)) *const]
      [(eq? e (quote atom?)) *const]
      [(eq? e (quote zero?)) *const]
      [(eq? e (quote add1)) *const]
      [(eq? e (quote sub1)) *const]
      [(eq? e (quote number?)) *const]
      [else *identifier])))

(define list-to-action
  (lambda (l)
    (cond
      [(eq? (car l) 'quote) *quote]
      [(eq? (car l) 'lambda) *lambda]
      [(eq? (car l) 'cond) *cond]
      [else *application])))

(define *const
  (lambda (e table)
    (cond
      [(number? e) e]
      [(eq? e #t) #t]
      [(eq? e #f) #f]
      [else (build (quote primitive) e)])))

(define *quote (lambda (e table) (text-of e)))

(define text-of (lambda (e) (cadr e)))

(define *identifier (lambda (e table) (lookup-in-table e table initial-table)))

(define initial-table (lambda (name) (car '())))

(define *lambda (lambda (e table) (build 'non-primitive (cons table (cdr e)))))

(define expression-to-action
  (lambda (e)
    (cond
      [(atom? e) (atom-to-action e)]
      [else (list-to-action e)])))

(define meaning (lambda (e table) ((expression-to-action e) e table)))

(define value (lambda (e) (meaning e (quote ()))))

(define table-of first)
(define formals-of second)
(define body-of third)

(define evcon
  (lambda (lines table)
    (cond
      [(else? (question-of (car lines)))
       (meaning (answer-of (car lines)) table)]
      [(meaning (question-of (car lines)) table)
       (meaning (answer-of (car lines)) table)]
      [else (evcon (cdr lines) table)])))

(define else? (lambda (x) (eq? x 'else)))

(define question-of first)
(define answer-of second)

(define *cond (lambda (e table) (evcon (cdr e) table)))

(define evlis
  (lambda (args table)
    (cond
      [(null? args) '()]
      [else (cons (meaning (car args) table) (evlis (cdr args) table))])))

(define *application
  (lambda (e table)
    (apply (meaning (function-of e) table) (evlis (arguments-of e) table))))

(define function-of car)
(define arguments-of cdr)

(define primitive? (lambda (l) (eq? (first l) 'primitive)))

(define non-primitive? (lambda (l) (eq? (first l) 'non-primitive)))

(define apply
  (lambda (fun vals)
    (cond
      [(primitive? fun) (apply-primitive (second fun) vals)]
      [(non-primitive? fun) (apply-closure (second fun) vals)])))

(define apply-primitive
  (lambda (name vals)
    (cond
      [(eq? name 'cons) (cons (first vals) (second vals))]
      [(eq? name (quote car)) (car (first vals))]
      [(eq? name (quote cdr)) (cdr (first vals))]
      [(eq? name (quote null?)) (null? (first vals))]
      [(eq? name (quote eq?)) (eq? (first vals) (second vals))]
      [(eq? name (quote atom?)) (:atom? (first vals))]
      [(eq? name (quote zero?)) (zero? (first vals))]
      [(eq? name (quote add1)) (add1 (first vals))]
      [(eq? name (quote sub1)) (sub1 (first vals))]
      [(eq? name (quote number?)) (number? (first vals))])))

(define :atom?
  (lambda (x)
    (cond
      [(atom? x #t)]
      [(null? x #f)]
      [(eq? (car x) (quote primitive)) #t]
      [(eq? (car x) (quote non-primitive)) #t]
      [else #f])))

; (meaning (fancy-thing (second (second fun)) vals (third (second fun))) table)))))

(define apply-closure
  (lambda (closure vals)
    (meaning (body-of closure)
             (extend-table (new-entry (formals-of closure) vals)
                           (table-of closure)))))
