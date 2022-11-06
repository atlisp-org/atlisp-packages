(defun @m:get-value (en0)
  (atof (entity:getdxf en0 1)))
(defun @m:align-number (matrix-num)
  "按小数位对齐"
  (mapcar '(lambda (x) (list (strlen (itoa (fix(apply 'max x))))
			     (apply 'max (mapcar '(lambda(m)(- (strlen (vl-string-right-trim "0" (rtos(- m (fix m)) 2 5))) 2))
						 x))))
	  (matrix:trp matrix-num)
  ))
(defun @m:form-matrix (entlist-text / fontsize row column result )
  "选择一组行列文字，形成行列矩阵。"
  (setq fontsize (entity:getdxf (car entlist-text) 40))
  (setq result '() row (list (car entlist-text)))
  (foreach en% (cdr entlist-text)
	   (if (equal (cadr (entity:getdxf (car row) 10))
		      (cadr (entity:getdxf en% 10))
		      fontsize)
	       (setq row (append row (list en% )))
	       (progn ;; 不在同一行，加入列；清行。
		 (setq result (append result (list (mapcar '@m:get-value row))))
		 (setq row (list en%)))))
  (setq result (append result (list (mapcar '@m:get-value row))))
  (if (apply '= (mapcar 'length result))
      result
      (progn (alert "分析失败，请确认行列对齐。") nil)
      )
  )
  
(@:add-menu "数学" "行列计算" "(@m:matrix-cal)") 
(defun @m:sort-by-x (ss-lst)
  (vl-sort ss-lst '(lambda (x y)
		    (> (car (entity:getdxf x 10))
		     (car (entity:getdxf y 10))))))
(defun @m:sort-by-y (ss-lst)
  (vl-sort ss-lst '(lambda (e1 e2)
		    (> (cadr (entity:getdxf e1 10))
		     (cadr (entity:getdxf e2 10))))))
(defun @m:matrix-cal (/ fontsize cal-symble number-matrix ss i% res-matrix)
  (@:help (strcat "选择一组行列对齐的数据，按输入的运算符对每行进行运算，得到结果表。"))
  (initget 1 "+ - * /")
  (setq cal-symble (getkword "请输入运算符 (+ - * /): "))
  (setq entlist-text (pickset:to-entlist (ssget '((0 . "text")))))
  ;; remove non-real&int
  ;; 排序
  (setq fontsize (entity:getdxf (car entlist-text) 40))
  (setq entlist-text
	(vl-sort entlist-text
		 '(lambda (en1 en2)
		   (if (> (cadr (entity:getdxf en1 10))
			  (+ fontsize (cadr (entity:getdxf en2 10))))
		       T
		       (if (and (equal (cadr (entity:getdxf en1 10))
				       (cadr (entity:getdxf en2 10))
				       fontsize)
				(< (car (entity:getdxf en1 10))
				   (car (entity:getdxf en2 10))))
			   T
			   nil)
		       ))))
  (setq number-matrix (@m:form-matrix entlist-text))
  
  (mapcar '(lambda (x) (apply (read cal-symble) x)) number-matrix)
  )
(defun @m:get-entmatrix ()
  (prompt "当选择的数据较多时，数据分析用时较长，请耐心等待...")
  (setq entlist-text (pickset:to-list (ssget '((0 . "text")))))
  ;; remove non-real&int
  ;; 排序
  (setq fontsize (entity:getdxf (car entlist-text) 40))
  (setq entlist-text
	(vl-sort entlist-text
		 '(lambda (en1 en2)
		   (if (> (cadr (entity:getdxf en1 10))
			  (+ fontsize (cadr (entity:getdxf en2 10))))
		       T
		       (if (and (equal (cadr (entity:getdxf en1 10))
				       (cadr (entity:getdxf en2 10))
				       fontsize)
				(< (car (entity:getdxf en1 10))
				   (car (entity:getdxf en2 10))))
			   T
			   nil)
		       )))))
(@:add-menu "数学" "行列运算" "(@m:menu-calc-matrix)") 
(defun @m:menu-calc-matrix (/ *error* result dcl-tmp dcl-fp dcl_id matrix-num num-format column-id)
  "多列计算,自定公式进行计算。"
  (defun *error* (msg)
    (if (= 'file (type dcl-fp)) (close dcl-fp))
    (vl-file-delete dcl-tmp)
    (prin1 msg))
  (defun calc-matrix ()
    (setq result
	  (mapcar '(lambda(xx)
		     (mapcar '(lambda(mm nn)(set mm nn))
			     '(A B C D F G H I J K L M N O P Q R S U V W X Y Z)
			     xx)
		     (eval (formula->lisp (get_tile "formula"))))
		  matrix-num
		  )))
  (setq column-id '(A B C D F G H I J K L M N O P Q R S U V W X Y Z))
  (setq result nil)
  (setq matrix-num (@M:form-matrix(@M:get-entmatrix)))
  (setq num-format (@m:align-number matrix-num))
  (setq dcl-tmp (strcat @:*prefix* "tmp-calc.dcl" ))
  ;;(print "aaa")
  (setq dcl-fp (open dcl-tmp "w"))
  (write-line "calc :dialog{label=\"Calc\";:spacer{}:column{" dcl-fp)
  (foreach str% (list
		 ":edit_box{label=\"公式:\";key=\"formula\";}"
		 ":text{label=\"支持运算符: + - * / ^ %(求余) ( ) [ ] { } \";}"
		 ":text{label=\"支持三角函数: sin cos tan ctan asin acos atan \";}"
		 ":text{label=\"支持高阶函数: ln lg sqr e(自然指数、欧拉数)  \";}"
		 ":text{label=\"示例: sin(A)+B-2*C , A*B-C+2*D \";}"
		 ":text{label=\"    A B C D F 代表列，列号没有 E T ，因为 E 代表欧拉数, T 代表真。  \";}"
		 ":image{ height=0.1; color=1; fixed_height=true;}"
		 ":text{key=\"title\";}"
		 
		 ;; ":row{:button{label=\"sin\";}:button{label=\"cos\";}:button{label=\"log\";}:button{label=\"ln\";}}"
		 ;; ":row{:button{label=\"Calc\";}:button{label=\"Insert to dwg\";}}"
		 ":list_box{key=\"matrix\";width=" (itoa (+ 4 (* 5(length num-format))(apply '+ (mapcar '(lambda(x)(apply '+ x)) num-format))))  ";}"
		 )
	   (write-line str% dcl-fp)
	   )
  (write-line "} :spacer{} ok_cancel;}" dcl-fp)
  (close dcl-fp)
  (setq dcl_id (load_dialog dcl-tmp))
  (if (not (new_dialog "calc" dcl_id "" ));; '(1  1)))
      (exit))
  (action_tile "accept" "(calc-matrix)(done_dialog 1)")
  (set_tile "formula"
	    (string:from-list (mapcar '(lambda(x y) (vl-symbol-name y))
				      num-format
				      column-id)
			      "+"))
  ;;(setq sepa "")
  (set_tile "title"
	    (apply 'strcat (mapcar '(lambda(x y)(string:number-format (vl-symbol-name y) (+ 2 (car x))(+ 2(cadr x)) " "))
				   num-format
				   column-id)))
  (start_list "matrix")
  ;; (add_list  (apply 'strcat (mapcar '(lambda(x y)(string:number-format y (+ 2 (car x))(+ 2(cadr x))))
  ;; 					    num-format
  ;; 					    '("A""B""C""D""F""G""H""I""J""K""L""M""N""O""P""Q""R""S""T""U""V""W""X""Y""Z"))))
  ;; (add_list (repeat (+(* 6(length num-format))(apply '+ (mapcar '(lambda(x)(apply '+ x)) num-format)))
  ;; 		    (setq Sepa (strcat "-" Sepa))))
  (foreach row% matrix-num
	   (add_list (apply 'strcat (mapcar '(lambda(x y)(string:number-format (vl-string-right-trim "0" (rtos y 2 5)) (+ 2 (car x))(+ 2(cadr x)) " "))
					    num-format
					    row%))))
  (end_list)
  (start_dialog)
  (unload_dialog dcl_id)
  (vl-file-delete dcl-tmp)
  (setq @m:*result* result)
  )
(setq @m:*result* nil)
(@:add-menu "数学" "结果写图" "(@m:draw)")
(defun @m:draw (/ pt1)
  (cond
   ((atom @m:*result*)
    (entity:make-text (@:to-string @m:*result*)
		      (getpoint "请输入结果插入点:")
		      350 0 0.8 0 "RB"))
   ((listp @m:*result*)
    (setq pt1 (getpoint "请输入结果插入点:"))
    (foreach atom% @m:*result*
	     (entity:make-text (@:to-string atom%)
			       pt1
			       350 0 0.8 0 "RB")
	     (setq pt1 (polar pt1 (* 1.5 pi) (* 5 (@:get-config '@:draw-scale))))
	     ))
   (t (alert "没有发现计算结果。"))))
