(defun @layout:ssgetx (layout)
  "ѡ�񲼾��г����ӿڸ�������ͼԪ"
  (ssget "x" (list (cons 410 layout)
		   '(-4 . "<NOT")'(-4 . "<AND")
		   '(0 . "viewport")'(69 . 1)
		   '(-4 . "AND>")'(-4 . "NOT>"))))
(defun @layout:merge-selelected (/ merge-layout)
  "�ϲ�ѡ�еĲ������ݵ�ѡ�еĵ�һ�������С�"
  (defun merge-layout (x / ss bref box)
    (if(and (setq ss (@layout:ssgetx x))
	    (setq box (pickset:getbox ss 0))
	    (setq bname (strcat x "-" (@:timestamp))))
	(progn
	  (entity:block ss bname (car box))
	  (setq bref (vla-InsertBlock (vla-get-block layout1)
				      (point:to-ax pt-lb)
				      bname
				      1 1 1 0))
	  (vla-explode bref)
	  (vla-delete bref)
	  (setq pt-lb (polar pt-lb 0(* 1.1 (- (caadr box) (caar box)))))
	  )))
  (setq layouts (layout:vla-list))
  (setq layoutnames (mapcar 'vla-get-name layouts))
  (setq layouts-sel (reverse(ui:select-multi"��ѡ��Ҫ�ϲ��Ĳ���"layoutnames)))
  
  (setq layoutname1 (car layouts-sel))
  
  (setq layout1 (car (vl-remove-if-not '(lambda(x)
				    (= (vla-get-name x)
				     layoutname1))
				  layouts)))
  (if(and (setq ss(@layout:ssgetx layoutname1))
	  (setq box (pickset:getbox ss 0)))
     (progn
       (setq pt-lb (polar (car box) 0 (* 1.1 (- (caadr box) (caar box))))))
     (setq pt-lb (list 0.0 0.0 0.0)))
  (foreach
   layout% (cdr layouts-sel)
   (merge-layout layout%))
  (vla-purgeall *DOC*)
  
  ;; �������ӿ�
  (setq ss (ssget "x"
		  (list '(0 . "viewport")
			'(-4 . "<NOT")'(69 . 1)'(-4 . "NOT>"))))
  (mapcar '(lambda(x)
	    (vla-put-viewporton x :vlax-true))
	  (pickset:to-vlalist ss))
  (setvar "ctab" layoutname1)
  (princ))
(defun @layout:merge (/ merge-layout)
  "�ϲ��������ݵ���һ�������С�"
  (defun merge-layout (x / ss bref box)
    (if(and (setq ss (@layout:ssgetx x))
	    (setq box (pickset:getbox ss 0))
	    (setq bname (strcat x "-" (@:timestamp))))
	(progn
	  (entity:block ss bname (car box))
	  (setq bref (vla-InsertBlock (vla-get-block layout1)
				      (point:to-ax pt-lb)
				      bname
				      1 1 1 0))
	  (vla-explode bref)
	  (vla-delete bref)
	  (setq pt-lb (polar pt-lb 0(* 1.1 (- (caadr box) (caar box)))))
	  )))
  (setq layouts (layout:vla-list))
  (setq layout1 (car layouts))
  (setq layoutnames (mapcar 'vla-get-name layouts))
  (setq layoutname1 (car layoutnames))
  (if(and (setq ss(@layout:ssgetx layoutname1))
	  (setq box (pickset:getbox ss 0)))
     (progn
       (setq pt-lb (polar (car box) 0 (* 1.1 (- (caadr box) (caar box))))))
     (setq pt-lb (list 0.0 0.0 0.0)))
  (foreach
   layout% (cdr layoutnames)
   (merge-layout layout%))
  (vla-purgeall *DOC*)
  
  ;; �������ӿ�
  (setq ss (ssget "x"
		  (list '(0 . "viewport")
			'(-4 . "<NOT")'(69 . 1)'(-4 . "NOT>"))))
  (mapcar '(lambda(x)
	    (vla-put-viewporton x :vlax-true))
	  (pickset:to-vlalist ss))
  (setvar "ctab" layoutname1)
  (princ))

(defun @layout:merge-next (/ merge-layout)
  (@::help '("����ǰ���ֺ������ڵĵ�һ�����������Ƶ���ǰ�����С�"))
  (defun merge-layout (x / ss bref box)
    (if(and (setq ss (@layout:ssgetx x))
	    (setq box (pickset:getbox ss 0))
	    (setq bname (strcat x "-" (@:timestamp))))
	(progn
	  (entity:block ss bname (car box))
	  (setq bref (vla-InsertBlock (vla-get-block layout1)
				      (point:to-ax pt-lb)
				      bname
				      1 1 1 0))
	  (vla-explode bref)
	  (vla-delete bref)
	  (setq pt-lb (polar pt-lb 0(* 1.1 (- (caadr box) (caar box)))))
	  )))
  (setq layouts (layout:vla-list))
  (setq layoutnames (member (getvar "ctab") (mapcar 'vla-get-name layouts)))
    
  (setq layoutname1 (car layoutnames))
  
  (if (setq layoutname2 (cadr layoutnames))
      (progn
	(setq layout1 (car (vl-remove-if-not '(lambda(x)
					       (= (vla-get-name x)
						layoutname1))
					     layouts)))
	
	(if(and (setq ss(@layout:ssgetx layoutname1))
		(setq box (pickset:getbox ss 0)))
	   (progn
	     (setq pt-lb (polar (car box) 0 (* 1.1 (- (caadr box) (caar box))))))
	   (setq pt-lb (list 0.0 0.0 0.0)))
	(merge-layout layoutname2)
	(vla-purgeall *DOC*)
	
	;; �������ӿ�
	(setq ss (ssget "x"
			(list '(0 . "viewport")
			      '(-4 . "<NOT")'(69 . 1)'(-4 . "NOT>"))))
	(mapcar '(lambda(x)
		  (vla-put-viewporton x :vlax-true))
		(pickset:to-vlalist ss))
	(setvar "ctab" layoutname1)))
  (princ))
