;;;��лfxsmΪ�����������ת�����ʽΪlisp�����ĳ���
(defun formula->lisp (str / lst format1 format1_1 Fsxm-Apply
			 format2 format3 format4 ln lg sqr ASIN
			 acos tan ctan sin2 cos2 tan2
			 )

;;;����������뺯��
  (defun format1 (str / char funs lastfun lst tmp lastchar)
    (setq lastfun "(")
    (setq funs '("+" "-" "*" "/" "^" "%" "(" ")" " "))
    (setq tmp "")
    (while (/= str "")
      (setq char (substr str 1 1))
      (setq str (substr str 2))
      (if	(and (member char funs)
		     ;;�����ر���
		     (not (and lastfun (/= lastfun ")") (= char "-")))
		     (not (and lastchar (or (= char "-") (= char "+"))))
		     )
	  (progn
	    (setq lst      (vl-list* char tmp lst)
		  tmp      ""
		  lastfun  char
		  lastchar nil
		  )
	    ;;(princ)
	    )
	(progn
	  (setq tmp      (strcat tmp char)
		lastfun  nil
		lastchar (= char "E")
		)
	  ;;"e"��ѧ�������ر���"2.718281828459045"
	  )
	)
      )
    (vl-remove "" (vl-remove " " (reverse (cons tmp lst))))
    )
;;;����������ȼ���������
  (defun format1_1 (lst funs / fun lasta nlst tmp)
    (foreach a lst
	     (cond
	      ((setq tmp (assoc (strcase a) funs))
	       (setq fun (cadr tmp))
	       )
	      ((and (= a "(") fun)
	       (setq nlst (vl-list* fun "(" nlst))
	       (setq fun nil)
	       )
	      ((and (= a "(")
		    (not (member lasta '(nil "+" "-" "*" "/" "^" "%" "(" ")")))
		    )
	       (setq nlst (vl-list* lasta "(" (cdr nlst)))
	       )
	      (t (setq nlst (cons a nlst)))
	      )
	     (setq lasta a)
	     )
    (reverse nlst)
    )
;;;��return��apply
  (defun Fsxm-Apply ($Sym $Lst / $$ return $rt)
    (defun Return (var) (setq Return nil) (setq $$ var) (exit))
    (setq $rt (vl-catch-all-apply $Sym $Lst))
    (if Return
	$rt
      $$
      )
    )
  ;;�ݹ鴦������
  (defun format2 (lst / a i lst2 nlst tmp var)
    (setq i 0)
    (while lst
      (setq a (car lst))
      (setq lst (cdr lst))
      (setq i (1+ i))
      (cond ((= a "(")
	     (setq var (fsxm-apply 'format2 (list lst)))
	     (repeat (car var) (setq lst (cdr lst)))
	     (setq i (+ i (car var)))
	     (setq nlst (cons (cadr var) nlst))
	     (setq tmp (cons (cadr var) tmp))
	     )
	    ((= a ")")
	     (return (list i (reverse tmp)))
	     )
	    (t
	     (setq tmp (cons a tmp))
	     (setq nlst (cons a nlst))
	     )
	    )
      )
    (reverse nlst)
    )
  ;;�ݹ�ת������ʽ��ʽ
  (defun format3 (lst funs / lasta nlst tmp fun)
    (foreach a lst
	     (cond ((setq fun (assoc a funs))
		    (setq tmp (list lasta (cadr fun)))
		    )
		   (t
		    (if (listp a)
			(setq a (format3 a funs))
		      )
		    (if tmp
			(setq lasta (reverse (cons a tmp))
			      nlst	 (cons lasta (cdr nlst))
			      tmp	 nil
			      )
		      (setq lasta a
			    nlst	 (cons lasta nlst)
			    )
		      )
		    )
		   )
	     )
    (reverse nlst)
    )
  ;;�ݹ鴦������������,
  ;;����str->������real ����str->����sym
  (defun format4 (lst)
    (mapcar '(lambda (a / x)
	       (cond ((listp a)
		      (if	(listp (car a))
			  (format4 (car a))
			(format4 a)
			)
		      )
		     ((= (type a) 'str)
		      (or	(setq x (distof a))
				(setq x (read a))
				)
		      x
		      )
		     (t a)
		     )
	       )
	    lst
	    )
    )
;;;��Ȼ����
  (defun ln (d)
    (log d)
    )
;;;����
  (defun lg (d)
    (* 0.4342944819032518276511289189166 (log d))
    )
;;;ƽ������
  (defun sqr (d)
    (* d d)
    )
;;;�����Һ���
  (defun asin (d)
    (atan d (sqrt (- 1 (* d d))))
    )
;;;�����Һ���
  (defun acos (d)
    (atan (sqrt (- 1 (* d d))) d)
    )
;;;���к���
  (defun tan (d)
    (/ (sin d) (cos d))
    )
;;;���к���
  (defun ctan (d)
    (/ (cos d) (sin d))
    )
  (defun sin2 (d)
    (sin (* d (/ pi 180)))
    )
  (defun cos2 (d)
    (cos (* d (/ pi 180)))
    )
  (defun tan2 (d / r)
    (setq r (* d (/ pi 180)))
    (/ (sin r) (cos r))
    )

  ;;Ԥ���� ȥ���ַ�&ת����
  (setq str (vl-string-translate "{[]}\t\n," "(())   " str))
  (setq str (strcase str))
  ;;����������뺯��
  (setq lst (format1 str))
  ;;���������ȼ���������
  ;;(setq lst (format1_1 lst '(("COS" cos2) ("SIN" sin2) ("TAN" tan2))))
  (setq	lst (format1_1 lst
		       '(("LN" ln)
			 ("LG" lg)
			 ("SQR" sqr)
			 ("ASIN" asin)
			 ("ACOS" acos)
			 ("CTAN" ctan)
			 ("TAN" tan)
			 )
		       )
	)
  ;;�ݹ鴦������
  (setq lst (format2 lst))
  ;;���ȼ���  ����
  (setq lst (format3 lst '(("^" expt))))
  ;;�ٴμ���  �� �� ȡģ
  (setq lst (format3 lst '(("*" *) ("/" /) ("%" rem))))
  ;;������ �Ӽ�
  (setq lst (format3 lst '(("+" +) ("-" -))))
  ;;����
  (car (format4 lst))
  )
;; ;;====================���ܲ���1:====================
;; (setq str1 (strcat "(1/(cos(-2)*-3)+"
;; 		   "min(22,abs(-5),0.5,8)"
;; 		   "*(2-5))/3^(sin(pi/5)+2)-1e+2*5"
;; 	   )
;; )
;; (eval (trans_format str1))		;-> -500.201
;; (eval (trans_format "min(22 , abs(-5) , 0.5 , 8)")) ;-> 0.5
;; ;;��min(22,abs(-5),0.5,8) -> 0.5 ������cal��֤���
;; (setq str2 "(1/(cos(-2)*-3)+0.5*(2-5))/3^(sin(pi/5)+2)-1e+2*5")
;; (c:cal str2)				;-> -500.201

;; ;;���ܲ���ͨ��


;; ;;====================Ч�ʲ���====================
;; ;;��ʱ�Ӻ���
;; (defun time0 () (setq t0 (getvar "TDUSRTIMER")))
;; (defun time1 ()
;;   (princ "��ʱ:")
;;   (princ (* (- (getvar "TDUSRTIMER") t0) 86400))
;;   (princ "(S)")
;;   (princ)
;; )
;; (setq str "(1/(cos(-2)*-3)+0.5*(2-5))/3^(sin(pi/5)+2)-1e+2*5")
;; (defun c:t1 (/ t0)			;��CAL�Ա�
;;   (time0)
;;   (repeat 5000 (cal str))
;;   (time1)
;; )
;; (defun c:t2 (/ t0)			;���eval+���trans_format(��cal��)
;;   (time0)
;;   (repeat 5000 (eval (trans_format str)))
;;   (time1)
;; )
;; (defun c:t3 (/ t0)			;���eval+1��trans_format(��cal���)
;;   (time0)
;;   (setq trans_lst (trans_format str))
;;   (repeat 5000 (eval trans_lst))
;;   (time1)
;; )
;; (defun c:t4 (/ t0 test)			;1��eval+1��trans_format(��cal��)
;;   (time0)
;;   (eval (list 'defun 'test nil (trans_format str)))
;;   (repeat 5000 (test))
;;   (time1)
;; )

;; ;;�޺������һ�ַ���
;; ;;(setq wcs (vla-GetInterfaceObject (vlax-get-acad-object) "ScriptControl"))
;; ;;(vlax-put-property wcs "language" "vbs")
;; ;;(vla-eval wcs "1+4+5*2+(5+5)/2+((6+6)/2+(5+5)/2)")  ;���� ->31.0


