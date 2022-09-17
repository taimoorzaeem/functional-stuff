#lang racket
(provide (all-defined-out))

;; This assignment should be completed individually.
;;
;; To test this, do:
;; $ raco pkg install rackunit
;; $ raco test racket.rkt

;; These are a series of finger-exercise programs to help you:
;; - learn a bit of Racket
;; - practice with structural recursion and type-based program design

;; This style of programming will be used throughout the course,
;; now is the time to master the style!

;; If you've mastered the style, you can write these programs on auto-pilot.
;; If you haven't, you will struggle.

(module+ test
  (require rackunit))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Numeric functions

;; Natural -> Natural
;; Compute n!
(define (fact n)
  (if (= n 0)
      1
      (* n (fact (- n 1)))))

(module+ test
  (check-equal? (fact 0) 1)
  (check-equal? (fact 1) 1)
  (check-equal? (fact 2) 2)
  (check-equal? (fact 5) 120))

;; Natural -> Natural
;; Compute nth Fibonnaci number
(define (fib n)
  (cond
    [(= n 0) 0]
    [(= n 1) 1]
    [else (+ (fib (- n 1)) (fib (- n 2)))]))


(module+ test
  (check-equal? (fib 0) 0)
  (check-equal? (fib 1) 1)
  (check-equal? (fib 2) 1)
  (check-equal? (fib 3) 2)
  (check-equal? (fib 4) 3)
  (check-equal? (fib 5) 5)
  (check-equal? (fib 6) 8)
  (check-equal? (fib 20) 6765))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; String functions

;; Read up on string functions in Racket to implement these.

;; String String -> String
;; Select the longer of the two strings (or first if same length)
(define (longer s1 s2)
  (if (> (string-length s2) (string-length s1))
      s2
      s1))


(module+ test
  (check-equal? (longer "" "") "")
  (check-equal? (longer "abc" "d") "abc")
  (check-equal? (longer "a" "bcd") "bcd")
  (check-equal? (longer "ab" "cd") "ab"))

;; String -> [Listof String]
;; Explode a string into a list of length-1 strings
(define (explode s)
  (map string (string->list s)))

(module+ test
  (check-equal? (explode "") '())
  (check-equal? (explode "a") '("a"))
  (check-equal? (explode "abc") '("a" "b" "c")))

;; String -> [Listof [List String String]]
;; Compute list of bigrams (pairs of adjacent letters) in a string
(define (bigrams s)
  (match (explode s)
    ['() '()]
    [(list a) '()]
    [(cons x xs) (append (list (list x (car xs)))
                         (bigrams (string-join xs "")))]))


(module+ test
  (check-equal? (bigrams "") '())
  (check-equal? (bigrams "a") '())
  (check-equal? (bigrams "ab") '(("a" "b")))
  (check-equal? (bigrams "abc") '(("a" "b") ("b" "c"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple list functions

;; Follow this template for functions on lists of numbers where appropriate.
;; [Listof Number] ... -> ...
#;
(define (lon-template ls ...)
  (match ls
    ['() ...]
    [(cons n ls) (... n (lon-template ls ...) ...)]))

;; [Listof Number] -> Natural
;; Compute the length of given list of numbers
(define (length-lon ls)
  (match ls
    ['() 0]
    [(cons n ls) (+ 1 (length-lon ls))]))

(module+ test
  (check-equal? (length-lon '()) 0)
  (check-equal? (length-lon '(1)) 1)
  (check-equal? (length-lon '(2)) 1)
  (check-equal? (length-lon '(1 2)) 2))

;; [Listof Number] -> Number
;; Compute the sum of given list of numbers
(define (sum ls)
  (match ls
    ['() 0]
    [(cons n ls) (+ n (sum ls))]))

(module+ test
  (check-equal? (sum '()) 0)
  (check-equal? (sum '(1)) 1)
  (check-equal? (sum '(2)) 2)
  (check-equal? (sum '(1 2)) 3))

;; [Listof Number] [Listof Number] -> [Listof Number]
;; Compute the pairwise sum of given list of numbers
;; ASSUME: lists have equal length
(define (zip-add ls1 ls2)
  (match ls1
    ['() '()]
    [(cons n1 ls1) (append (list (+ n1 (car ls2))) (zip-add ls1 (cdr ls2)))]))

(module+ test
  (check-equal? (zip-add '() '()) '())
  (check-equal? (zip-add '(1) '(2)) '(3))
  (check-equal? (zip-add '(1 3) '(2 4)) '(3 7)))

;; [Listof Number] [Listof Number] -> [Listof [List Number Number]]
;; Compute the pairwise list of given list of numbers
;; ASSUME: lists have equal length
(define (zip-lon ls1 ls2)
  (match ls1
    ['() '()]
    [(cons n1 ls1) (append (list (list n1 (car ls2))) (zip-lon ls1 (cdr ls2)))]))


(module+ test
  (check-equal? (zip-lon '() '()) '())
  (check-equal? (zip-lon '(1) '(2)) '((1 2)))
  (check-equal? (zip-lon '(1 3) '(2 4)) '((1 2) (3 4))))

;; [Pairof Real [Listof Real]] -> Real
;; Compute max element of non-empty list of numbers
(define (max-lon xs)
  (match xs
    [(cons x '()) x]
    [(cons x xs)
      #:when (> x (max-lon xs))
      x]
    [(cons x xs) (max-lon xs)]))


(module+ test
  (check-equal? (max-lon '(1)) 1)
  (check-equal? (max-lon '(1 2)) 2)
  (check-equal? (max-lon '(2 1)) 2)
  (check-equal? (max-lon '(2 3 1)) 3))

;; [Listof Real] -> [Listof Real]
;; Sort list into ascending order
;; HINT: do insertion sort by writing and using the helper below
(define (sort-asc xs)
  (match xs
    ['() '()]
    [(cons x xs) (insert-asc x (sort-asc xs))]))

(module+ test
  (check-equal? (sort-asc '()) '())
  (check-equal? (sort-asc '(1)) '(1))
  (check-equal? (sort-asc '(1 2)) '(1 2))
  (check-equal? (sort-asc '(2 1)) '(1 2))
  (check-equal? (sort-asc '(2 3 1)) '(1 2 3)))

;; Real [Listof Real] -> [Listof Real]
;; Insert number into sorted list
;; ASSUME: given list is sorted in ascending order
(define (insert-asc n xs)
    (match xs
        ['() (list n)]
        [(list x) (if (> n x) (append (list x) (list n)) (cons n (list x)))]
        [(cons x xs) 
            #:when (> n x)
            (cons x (insert-asc n xs))]
        [(cons x xs)
            (cons n (cons x xs))]))

(module+ test
  (check-equal? (insert-asc 5 '()) '(5))
  (check-equal? (insert-asc 5 '(7)) '(5 7))
  (check-equal? (insert-asc 5 '(3)) '(3 5)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Polymorphic list functions

;; ∀ (α) (α -> Real) [Pairof α [Listof α]] -> α
;; Find element that minimizes the given measure (take first if more than one)
(define (minimize f xs)
  (min-iter (f (car xs)) (car xs) f (cdr xs)))

;; Helper function
(define (min-iter fx x f xs)
  (cond
    [(= (length-lon xs) 0) x]
    [(<= fx (f (car xs))) (min-iter fx x f (cdr xs))]
    [else (min-iter (f (car xs)) (car xs) f (cdr xs))]))
      
(module+ test
  (check-equal? (minimize abs '(1 -2 3)) 1)
  (check-equal? (minimize string-length '("abc" "d" "efg")) "d")
  (check-equal? (minimize string-length '("abc" "d" "ef" "g")) "d"))

;; ∀ (α) (α α -> Boolean) [Listof α] -> [Listof α]
;; Sort list in ascending order according to given comparison
;; ENSURE: result is stable
(define (sort < xs)
  (match xs
    ['() '()]
    [(cons n ls) (append (sort < (for/list ([i ls] #:when (< i n)) i))
                         (list n)
                         (sort < (for/list ([i ls] #:when (not (< i n))) i)))]))

(module+ test
  (check-equal? (sort < '(1 -2 3)) '(-2 1 3))
  (check-equal? (sort string<? '("d" "abc" "efg")) '("abc" "d" "efg"))
  (check-equal?
   (sort (λ (s1 s2)
           (< (string-length s1) (string-length s2)))
         '("efg" "d" "abc")) '("d" "efg" "abc")))

;; ∀ (α β) [Listof α] [Listof β] -> [Listof [List α β]]
;; Zip together lists into a list of lists
;; ASSUME: lists are the same length
(define (zip as bs)
  (match as
    ['() '()]
    [(cons a as) (append (list (list a (car bs))) (zip as (cdr bs)))]))

(module+ test
  (check-equal? (zip '() '()) '())
  (check-equal? (zip '(1) '(2)) '((1 2)))
  (check-equal? (zip '(1 3) '(2 4)) '((1 2) (3 4)))
  (check-equal? (zip '(1 3) '("a" "b")) '((1 "a") (3 "b"))))

;; ∀ (α) (Listof (α -> α)) -> (α -> α)
;; Compose a list of functions into a single function
;; ((pipe (list f1 f2 f3)) x) ≡ (f1 (f2 (f3 x)))
(define (pipe fs)
  (apply compose fs))

(module+ test
  (check-equal? ((pipe (list number->string sqr add1)) 5) "36")
  (check-equal? ((pipe (list number->string add1 sqr)) 5) "26")
  (check-equal? ((pipe (list string-length number->string add1 sqr)) 5) 2))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Peano numbers

;; Unary encoding of the natural numbers

;; type N = (Z) | (S N)

;; We will represent Peano numbers in racket with structures.
(struct Z ()      #:transparent)
(struct S (N)     #:transparent)   
;; this structure 'S' should be recursive - 
;; it's parameter should be another Peano Number 

;; Natural -> N
;; Convert natural to Peano
(define (nat->peano n)
  (if (= n 0) (Z) (S (nat->peano (- n 1)))))

(module+ test
  (check-equal? (nat->peano 0) (Z))
  (check-equal? (nat->peano 1) (S (Z)))
  (check-equal? (nat->peano 2) (S (S (Z))))
  (check-equal? (nat->peano 3) (S (S (S (Z))))))

;; N -> Natural
;; Convert Peano to natural
(define (peano->nat n)
  (match n
    [(Z) 0]
    [(S N) (+ 1 (peano->nat N))]))

(module+ test
  (check-equal? (peano->nat (Z)) 0)
  (check-equal? (peano->nat (S (Z))) 1)
  (check-equal? (peano->nat (S (S (Z)))) 2)
  (check-equal? (peano->nat (S (S (S (Z))))) 3))

;; Do not use conversions to implement the following functions

;; N N -> N
;; Add two Peano numbers together
(define (plus n1 n2)
  (match n1
    [(Z) n2]
    [(S N) (S (plus N n2))]))

(module+ test
  (check-equal? (plus (Z) (Z)) (Z))
  (check-equal? (plus (Z) (S (Z))) (S (Z)))
  (check-equal? (plus (S (Z)) (Z)) (S (Z)))
  (check-equal? (plus (S (Z)) (S (Z))) (S (S (Z)))))

;; N N -> N
;; Multiply two Peano numbers together
(define (mult n1 n2)
  (match n2
    [(Z) (Z)]
    [(S N) (plus n1 (mult n1 N))]))


(module+ test
  (check-equal? (mult (Z) (Z)) (Z))
  (check-equal? (mult (Z) (S (Z))) (Z))
  (check-equal? (mult (S (Z)) (Z)) (Z))
  (check-equal? (mult (S (Z)) (S (Z))) (S (Z))))

;; ∀ (α) N (α -> α) -> (α -> α)
(define (iter n f)
  (match n
    [(Z) (lambda (a) a)]
    [(S N) (compose (lambda (a) (f a)) (iter N f))]))

(module+ test
  ;; Natural -> Natural
  (define (succ n) (+ n 1))

  (check-equal? ((iter (Z) succ) 0) 0)
  (check-equal? ((iter (S (Z)) succ) 0) 1)
  (check-equal? ((iter (S (S (Z))) succ) 0) 2)

  ;; Boolean -> Boolean
  (define (neg b) (not b))

  (check-equal? ((iter (Z) neg) #t) #t)
  (check-equal? ((iter (S (Z)) neg) #t) #f)
  (check-equal? ((iter (S (S (Z))) neg) #t) #t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Binary trees of numbers

;; Write test cases for each function (before writing code!).

;; type BTNumber =
;; | (leaf)
;; | (node Number BTNumber BTNumber)

;; We will represent Binary trees in racket with structures.
(struct leaf ()             #:transparent)
(struct node (n left right) #:transparent)   
;; this structure 'node' should be recursive - 
;; it's last two parameters should be binary trees 

;; Follow this template for functions on binary trees.
;; bt ... -> ...
#;
(define (btn-template n)
  (match n
    [(leaf) ...]
    [(node n left right)
     (... n
          (btn-template left ...)
          (btn-template right ...) ...)]))


;; BTNumber -> Natural
;; Compute the height of a binary tree (leaf has height 0)
(define (btn-height bt)
  (match bt
    [(leaf) 0]
    [(node n left right) (+ 1 
                            (max (btn-height left)
                                 (btn-height right)))]))

(module+ test
  (check-equal? (btn-height (leaf)) 0)
  (check-equal? (btn-height (node 5 (leaf) (leaf))) 1)
  (check-equal? (btn-height (node 5 (node 1 (leaf) (leaf)) (leaf))) 2))

;; BTNumber -> Natural
;; Count the nodes of a binary tree
(define (btn-count bt)
  (match bt
    [(leaf) 0]
    [(node n left right) (+ 1 
                            (btn-count left) 
                            (btn-count right))]))

(module+ test
  (check-equal? (btn-count (leaf)) 0)
  (check-equal? (btn-count (node 5 (leaf) (leaf))) 1)
  (check-equal? (btn-count (node 5 (node 1 (leaf) (leaf)) (leaf))) 2))

;; BTNumber -> BTNumber
;; Compute the mirror image of binary tree
(define (btn-mirror bt)
  (match bt
    [(leaf) (leaf)]
    [(node n left right) (node n right left)]))

(module+ test
  (check-equal? (btn-mirror (leaf)) (leaf))
  (check-equal? (btn-mirror (node 5 (leaf) (leaf))) (node 5 (leaf) (leaf)))
  (check-equal? (btn-mirror (node 5 (node 1 (leaf) (leaf)) (leaf)))
                (node 5 (leaf) (node 1 (leaf) (leaf)))))

;; BTNumber -> Number
;; Sum the numbers of a binary tree
(define (btn-sum bt)
  (match bt
    [(leaf) 0]
    [(node n left right) (+ n 
                            (btn-sum left)
                            (btn-sum right))]))

(module+ test
  (check-equal? (btn-sum (leaf)) 0)
  (check-equal? (btn-sum (node 5 (leaf) (leaf))) 5)
  (check-equal? (btn-sum (node 5 (node 1 (leaf) (leaf)) (leaf))) 6))

;; Natural Number -> BTNumber
;; Generate a full bt of height h containing given number n at each node
(define (btn-gen-full h n)
  (match h
    [0 (leaf)]
    [h (node n (btn-gen-full (- h 1) n) (btn-gen-full (- h 1) n))]))

(module+ test
  (check-equal? (btn-gen-full 0 8) (leaf))
  (check-equal? (btn-gen-full 1 8) (node 8 (leaf) (leaf)))
  (check-equal? (btn-gen-full 2 8) (node 8 (node 8 (leaf) (leaf)) (node 8 (leaf) (leaf)))))

;; BTNumber Number -> Boolean
;; Does the bt contain number n?
(define (btn-contains? bt n)
  (match bt
    [(leaf) #f]
    [(node num left right) (if (= n num) 
                               #t 
                               (or (btn-contains? left n)
                                   (btn-contains? right n)))]))

(module+ test
  (check-equal? (btn-contains? (leaf) 8) #f)
  (check-equal? (btn-contains? (node 8 (leaf) (leaf)) 8) #t)
  (check-equal? (btn-contains? (node 5 (leaf) (leaf)) 8) #f)
  (check-equal? (btn-contains? (node 5 (leaf) (node 8 (leaf) (leaf))) 8) #t))

;; BTNumber -> [Listof Number]
;; Generate the list of numbers in bt in preorder
;; HINT: append is a function that might be helpful
(define (btn-preorder btn)
  (match btn
    [(leaf) '()]
    [(node n left right) (append (list n)
                                 (btn-preorder left)
                                 (btn-preorder right))]))

(module+ test
  (check-equal? (btn-preorder (leaf)) '())
  (check-equal? (btn-preorder (node 5 (leaf) (leaf))) '(5))
  (check-equal? (btn-preorder (node 5 (node 8 (leaf) (leaf)) (node 9 (leaf) (leaf))))
                '(5 8 9)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Representing expressions

;; Here is a datatype definition for representing expressions in a small
;; functional programming language:

;; type SExpr =
;; | Integer
;; | Boolean
;; | Variable
;; | (list e1 e2)
;; | (list 'lambda (list (? symbol? x)) e) 

;; type Variable = Symbol

;; Some examples of valid programs:
;; 34
;; #t
;; 'x
;; '((lambda (x) x) 17)

;; The above definition is easy to read, but can be troublesome to work with.
;; Instead of using the SExpr representation, we will transform it into a
;; more structured representation (this will be our AST).

;; type Expr =
;; | (Int Integer)
;; | (Bool Boolean)
;; | (Var Variable)
;; | (App Expr Expr)
;; | (Lam Variable Expr)

;; type Variable = Symbol

;; We will be using these structures:
(struct Int  (i)      #:transparent)
(struct Bool (b)      #:transparent)
(struct Var  (v)      #:transparent)
(struct App  (e1 e2)  #:transparent)
(struct Lam  (x e)    #:transparent)

;; After converting the above SExpr programs into Expr representation:
;; (Int 34)
;; (Bool #t)
;; (Var 'x)
;; (App (Lam 'x (Var 'x)) (Int 17))

;; We already wrote a helper function to put SExpr programs into this 
;; new representation. Feel free to play around with this in your REPL.
;; SExpr -> Expr
(define (sexpr->expr s)
  (match s
    [(? integer? s)     (Int s)]
    [(? boolean? b)     (Bool b)]
    [(? symbol? v)      (Var v)]
    [(list e1 e2)       (App (sexpr->expr e1) (sexpr->expr e2))]
    [(list 'lambda (list (? symbol? x)) e) 
                        (Lam x (sexpr->expr e))]))

;; Below is a template of how to traverse this AST:

#;
(define (expr-template e)
  (match e
    [(Int i) ...]
    [(Bool b) ...]
    [(Var v) ...]
    [(App e1 e2)
     (... (expr-template e1)
          (expr-template e2) ...)]
    [(Lam x e)
     (... x (expr-template e) ...)]))


;; Note: for each of the following functions, the order of elements
;; and whether repetitions occur is left unspecified and up to you.
;; The tests are written using this function to take this in to
;; account.

(module+ test
  ;; [Listof a] [Listof a] -> Boolean
  ;; Are the two lists equal up to re-ordering and repetition?
  (define (list-set-equal? xs ys)
    (equal? (list->set xs) (list->set ys)))

  (check-equal? (list-set-equal? '() '()) #t)
  (check-equal? (list-set-equal? (list 1 2) (list 2 1)) #t)
  (check-equal? (list-set-equal? (list 1 1 2) (list 2 2 1)) #t)
  (check-equal? (list-set-equal? (list 1 1 2) (list 2 3 2 1)) #f))


;; Expr -> [Listof Integer]
;; Computes a list of all integer literals that appear in the expression
(define (expr-integers e)
  (match e
    [(Int i) (list i)]
    [(Bool b) '()]
    [(Var v) '()]
    [(App e1 e2)
     (append (expr-integers e1)
          (expr-integers e2))]
    [(Lam x e)
     (append (expr-integers e) '())]))

(module+ test
  (check list-set-equal? (expr-integers (sexpr->expr 123)) '(123))
  (check list-set-equal? (expr-integers (sexpr->expr 'x)) '())
  (check list-set-equal? (expr-integers (sexpr->expr '((lambda (x) x) 123))) '(123))
  (check list-set-equal? (expr-integers (sexpr->expr '((lambda (x) 42) 123))) '(123 42)))

;; Expr -> [Listof Variable]
;; Compute a list of all lambda-bound variables in the expression
(define (expr-lambda-vars e)
  (match e
    [(Int i) '()]
    [(Bool b) '()]
    [(Var v) '()]
    [(App e1 e2) (append (expr-lambda-vars e1)
                         (expr-lambda-vars e2))]
    [(Lam x e) (append (list x)
                       (expr-lambda-vars e))]))

(module+ test
  (check list-set-equal? (expr-lambda-vars (sexpr->expr 123)) '())
  (check list-set-equal? (expr-lambda-vars (sexpr->expr 'x)) '())
  (check list-set-equal? (expr-lambda-vars (sexpr->expr '((lambda (x) x) 123))) '(x))
  (check list-set-equal? (expr-lambda-vars (sexpr->expr '((lambda (x) 42) 123))) '(x)))

;; Expr -> [Listof Variable]
;; Compute a list of all free variables, i.e. variables which occur outside
;; of any lambda that binds them.
(define (expr-free-vars e)
  (match e
    [(Int i) '()]
    [(Bool b) '()]
    [(Var v) (list v)]
    [(App e1 e2) (append (expr-free-vars e1)
                         (expr-free-vars e2))]
    [(Lam x e) (remove* (list x)
                       (expr-free-vars e))]))

(module+ test
  (check list-set-equal? (expr-free-vars (sexpr->expr 123)) '())
  (check list-set-equal? (expr-free-vars (sexpr->expr 'x)) '(x))
  (check list-set-equal? (expr-free-vars (sexpr->expr '((lambda (x) x) 123))) '())
  (check list-set-equal? (expr-free-vars (sexpr->expr '((lambda (x) 42) 123))) '()))