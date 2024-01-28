;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-structure:first ���� Ӧ�ð� at-structure �� ��һ�������� first 
;;(@:define-config 'at-structure:first "���������� at-structure:first ��ֵ" "������������;˵����")
;; (@:get-config 'at-structure:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-structure:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "�ṹ����" "��̬�����" "(at-structure:query-steelbar)" )
(@:add-menu "�ṹ����" "��ֽ����" "(at-structure:menu-get-area)" )
(defun at-structure:menu-get-area (/ steelbar-str)
  (@:help "ѡ�иֽ��ַ����ĵ����ı����� %%1328@100,2%%13220+3%%13222 �ȣ����ظֽ������")
  (setq steelbar-str (string:parse-by-lst (cdr (assoc 1 (entget (car (entsel))))) '(";" "��")))
  (foreach x steelbar-str
	   (format t "�ֽ����: ~d"
		   (at-structure:get-steel-area x))))

(defun at-structure:get-steel-area (steelbar-str / steelbar-lst steelbar-to-area gujin-zhishu)
  "����ֽ����ֵõ��ֽ����"
  "Real number"
  (defun steel-to-area (steelbar-str / nxd)
    (setq nxd (string:parse-by-lst steelbar-str '("%%132" "%%130" "%%131"))) ;;�ֽ����
    (if (= 2 (length nxd )) ; nxd = (list ����  ֱ��)
	(cons * (list (if (= "" (car nxd)) 1.0 (atof (car nxd))) 0.25 pi (atof (cadr nxd)) (atof (cadr nxd))))))
  (setq steelbar-str (vl-string-left-trim "GN BTXY&:" steelbar-str)) 
  (if (vl-string-search "@" steelbar-str)
      (progn;; ����/���/ǽ��
	(setq steelbar-lst  (string:parse-by-lst steelbar-str '("@"))) ;; ������
	(setq gujin-steel (string:parse-by-lst (car steelbar-lst) '("/")))
	(if (setq gujin-zhishu 
		  (cadr (string:parse-by-lst (cadr steelbar-lst) '("(" ")"))))
	    (setq gujin-zhishu (atoi gujin-zhishu))
	    (setq gujin-zhishu 1))
	    
	(eval (cons *
		    (cons
		     (cons /
			   (cons (cons +
				       (vl-remove nil (mapcar 'steel-to-area gujin-steel)))
				 (cons (length gujin-steel) (cons (atof (cadr steelbar-lst)) (cons 0.001  nil)))))
		     (cons gujin-zhishu nil)))))
      (progn ;; �ݽ�
	;; ȥ����������
	(setq steelbar-str (string:subst-all "" ")" (string:subst-all "" "(" steelbar-str)))
	(eval (cons +  (vl-remove nil (mapcar 'steel-to-area (string:parse-by-lst steelbar-str '("+" "/"))))))))
  )

(defun at-structure:query-steelbar(/ *error* dxf fx add_background add_box add_text display olderr oldos oldfill ss pd gr pt ent entold)
  "��̬��ֽ������"
  (defun *error* (msg / i%)
    (if ss
	(mapcar 'entdel (pickset:to-entlist ss)))
    (print msg)
    (pop-var)
    (princ)
    )
  (defun dxf(ent i)
    (if (= (type ent) 'ename) 
	(setq ent (entget ent))
	)
    (cdr (assoc i ent))
    )
  (defun fx(ang)
    (cond
      ((>= (/ pi 2) ang 0) (list pi (+ pi (/ pi 2)) 1))
      ((>= pi ang (/ pi 2)) (list 0 (+ pi (/ pi 2)) 1))
      ((>= (+ pi (/ pi 2)) ang pi) (list 0 (/ pi 2) 0))
      ((>= (* 2 pi) ang (+ pi (/ pi 2))) (list pi (/ pi 2) 0))
      )
    )
  (defun add_background(p1 p2 p3 p4) ;; ����
    (entmakex (list (cons 0 "SOLID") (cons 100 "AcDbEntity") (cons 62 8) (cons 100 "AcDbTrace")
                    (cons 10 p1) (cons 11 p4) (cons 12 p2) (cons 13 p3)
		    )))
  (defun add_box( pts / dxfcodes ) ;; �����߿�
    (setq dxfcodes (list (cons 0 "LWPOLYLINE")(cons 100 "AcDbEntity")(cons 100 "AcDbPolyline")(cons 62 2)
			 (cons 90 (length pts)) (cons 70  1) (cons 43 0) (cons 38 0.0) (cons 39 0.0)))
    (foreach pt% pts
	     (setq dxfcodes (append dxfcodes (list (cons 10 pt%) (cons 40 0.0) (cons 41 0.0) (cons 42 0.0) (cons 91 0)))))
    (entmakex (append dxfcodes (list '(210 0.0 0.0 1.0)))))
  ;;(entity:make-pline (list p1 p2 p3 p4) nil 0 1))
  (defun add_text(pt h ang txt style jus) ;; ���ı�
    (entmakex (list (cons 0 "TEXT")
		    (cons 100 "AcDbEntity")
		    (cons 62 2)
		    (cons 100 "AcDbText")
		    (if (= jus 0) (cons 10 pt) (list 10 0.0 0.0 0.0))
		    (cons 40 h)
                    (cons 1 txt)
		    (cons 50 ang)
		    (cons 7 style)
		    (cons 72 (cond ((= jus 0) 0) ((= jus 1) 1) ((= jus 2) 1) ((= jus 3) 2)))
		    (if (= jus 0)
			(list 11 0.0 0.0 0.0) (cons 11 pt))
		    (cons 100 "AcDbText")
		    (cons 73 (cond ((= jus 0) 0) ((= jus 1) 2) ((= jus 2) 3) ((= jus 3) 2)))
		    )))
  (defun display (ent / obj laynm name st1 st2 st3 lst h ang n box-pts text-style )
    (setq text-style "vitalhz")
    (if (null (tblsearch "style" text-style))
	(setq text-style (getvar "textstyle")))
    (setq obj (vlax-ename->vla-object ent))
    (setq laynm (strcat "ͼ��:" (dxf ent 8)))
    (setq name (dxf ent 0)) ;; ͼԪ����
    (cond
      ((or (= name "TEXT")(= name "TCH_TEXT"))
       (setq lst (mapcar '(lambda (x / area )
			   (if (> (setq area (at-structure:get-steel-area x)) 0)
			       (format nil "�ֽ����: ~d" area )
			       "�Ǹֽ�����"))
			 (string:parse-by-lst (dxf ent 1) '(";" "��"))))
       (setq lst (vl-remove nil lst)))
      (T (setq lst (list "������" name )))
      )
    ;;(if ss (mapcar 'entdel (pickset:to-entlist ss)));; ɾ��ԭ��
    (setq ss (ssadd)) ;; ��ʾ��ͼԪ��
    (setq h (/ (getvar "viewsize") 50)) ;; �ָ�Ϊ��Ļ�� 1/40
    (setq ang (fx (angle (getvar "viewctr") pt))) ;; �����ĵ�ĽǶ�
    (setq n (* 1.4 (1+ (/ (apply 'max (mapcar 'strlen lst)) 2.0)))) ; ���
    ;;(setq box-pts (list  pt 
    ;;   (polar pt (car ang) (* n h))
    ;;   (setq st1 (polar pt (cadr ang) (+ h (* 1.8 h (1+(length lst))))))
    ;;    (polar st1 (car ang) (* n h))))
    (setq box-pts (list pt ;; ����
			(setq st1 (polar pt (* 1.5 pi) (+ h (* 1.8 h (1+(length lst)))))) ;;����
			(polar st1 0 (* n h)) ;; ����
			(polar pt 0 (* n h))))
    
    (ssadd (apply 'add_background box-pts) ss)
    (ssadd (add_box box-pts) ss) 
    
    ;;(setq st2 (polar pt (car ang) (/ (* n h) 2)))
    (setq st2 (polar pt 0 (/ (* n h) 2)))
    ;;(if (= (caddr ang) 0)
    ;;	(setq pt (polar pt (/ pi 2) (* 0.4 h)))
    ;;	(setq pt (polar pt (/ pi 2) (+ (* 1.4 h) (* 1.8 h (length lst)))))
    ;;  )
    (setq n -1)
    (repeat (length lst)
	    (ssadd (add_text (setq st2 (polar st2 (* 1.5 pi) (* 1.8 h)))
			     h 0 (nth (setq n (1+ n)) lst)
			     text-style 
			     1)
		   ss)
	    ))

  (push-var nil)  
  (command "ucs" "w")
  (command "_.undo" "_m")
  (prompt "\n***�ƶ�������ֽ����ֲ鿴��***")
  (setvar "osmode" 0)
  (setvar "fillmode" 1)
  (setvar "cmdecho" 0)
  (setq ss (ssadd))
  (while (not pd)
    (while (not (progn
                  (setq gr (grread T 1))
		  (if (= (car gr) 5)
		      (setq pt (cadr gr)
			    ent (nentselp pt)
			    ent (if (and ent (= (type (last (last ent))) 'ename))
				    (last (last ent))
				    (car ent)
				    )
			    )
		      (setq pd T)
		      )
		  ))
      )
    (if (and (not pd) (not (equal ent entold)) (not (ssmemb ent ss)))
	(progn
          (if entold (redraw entold 4))
          (if ss (mapcar 'entdel (pickset:to-entlist ss)))
          (redraw ent 3)
	  (display ent)
	  (setq entold ent)
	  )
	)
    )
  (if entold (redraw entold 4))
  (if ss (mapcar 'entdel (pickset:to-entlist ss)))
  (pop-var)
  (princ)
  )
