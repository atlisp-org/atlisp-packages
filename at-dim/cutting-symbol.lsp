(defun at-dim:cutting-symbol (/ *error* code data dcl_re dclname dlg cscale
			      stream tempname cutn loopit  
			      l0
			      cutline1 cuttext1
			      cutline2 cuttext2
			      cutdetail-text
			      cutdetail-l1
			      cutdetail-l2
			      cutdrection-l
			      cutdrection-text
			      )
  (defun *error* (msg)
    (mapcar 'entdel
	    (vl-remove nil
		       (list l0
			     cutline1 cuttext1
			     cutline2 cuttext2
			     cutdetail-text
			     cutdetail-l1
			     cutdetail-l2
			     cutdrection-l
			     cutdrection-text)))
    (princ msg)
    )
  (setq cutmode 1 ;;����ģʽ
	loopit t)
  (setvar "CELTYPE" "BYLAYER")
  (if (null (tblsearch "ltype" "DASHED"))
      (command "-linetype" "L" "DASHED" "" "")
      )
  (if (setq ss (ssget "X" '((0 . "TEXT") (1 . "[A-Z]")
			    (-3 ("CUTNUMBER"))
			    )
		      )
	    )
      (progn
	(setq lst '())
	(repeat (setq i (sslength ss))
		(setq lst (cons (cdr (assoc 1 (entget (ssname ss (setq i (1- i)))))) lst))
		)
	(setq cutn   (chr (1+ (ascii (car (vl-sort lst '>))))))
	)
      (setq cutn  "A")
      )
  (if (null cscale)
      (setq cscale (getvar "DIMSCALE"))
      )
  (while (progn
	   (initget "S")
	   (if (= (setq s (getpoint (strcat "\nָ����������ʼ��,��׽�����,��[����(S)]:")))
		  "S"
		  )
	       (progn
		 (dcl:dialog "cuttingSetting")
		 (dcl:input "txtHeight" "���ָ߶�" "3.5" "")
		 (dcl:input "arrowSize" "��ͷ��С" "3.5" "")
		 (dcl:dialog-end-ok-cancel)
		 (dcl:new "cuttingSetting")
		 (set_tile "txtHeight" (rtos (* cscale 4)))
		 (set_tile "arrowSize" (rtos (* cscale 4)))
		 (action_tile "accept"
			      "(setq cscale ( * 0.25 (atof (get_tile \"txtHeight\"))))(done_dialog )")
		 (dcl:show)
		 )
	       (setq pt0 s)
	       )
	   (= s "S")
	   )
    )
  (if (ssget "c" pt0 pt0)
      (setq pt0 (getpoint pt0 "ָ����㣺"))
      )
  (princ (strcat "\nָ����ͷ����,�����:<" cutn  ">,�Ҽ�����"))
  
  (setq l0
	(entity:putdxf
	 (entity:putdxf 
	  (entity:make-line pt0 pt0)
	  62 8)
	 6 "DASHED"))
  (setq ent0 l0)

  (setq cutline1
	(entity:putdxf
	 (entity:make-lwpolyline
	  (list (polar pt0 (* 0.5 pi) (* cscale 4))
		pt0
		(polar pt0 0 (* cscale 2))
		(polar pt0 0 (* cscale 4))
		)
	  nil
	  (list
	   (* cscale 0.3)
	   0
	   (list (* cscale 0.3) 0))
	  0 0)
	 62 4)
	)
  
  (setq cuttext1
	(entity:make-text cutn   pt0 (* cscale 4)  0 0.8 0  "MM"))
  (xdata:put cuttext1 "CUTNUMBER" cutn)
  
  
  (entmake (cdr (entget cutline1)))
  (setq cutline2 (entlast))
  (entmake (cdr (entget cuttext1)))
  (setq cuttext2 (entlast))
  (while (progn
	   (setq gr (grread t 15 0)
		 code (car gr)
		 data (cadr gr)
		 )
	   (cond
	     ((= code 2)	       ; ��������
	      (redraw)
	      (if (= data 15)
		  (progn
		    (if (= (getvar "ORTHOMODE") 0)
			(progn
			  (prompt "\n<���� ��>")
			  (setvar "orthomode" 1)
			  )
			(progn
			  (prompt "\n<���� ��>")
			  (setvar "orthomode" 0)
			  )
			)
		    )
		  )
	      (setq s (strcase (chr data)))
	      (if (wcmatch s "[A-Z]")
		  (progn
		    (setq cutn  s)
		    (entity:putdxf curttext1 1 cutn)
		    (entity:putdxf curttext2 1 cutn)
		    ;; (entity:putdxf curttext3 1 tex)
		    )
		  )
	      (if (= cutmode 1)
		  (princ (strcat "\nָ����ͷ����,�����:<" cutn  ">,�Ҽ�����"))
		  )
	      (if (= cutmode 3)
		  (princ (strcat "\nָ����ͷ����,�����:<" cutn  ">,�Ҽ�����"))
		  )
	      )
	     ((= code 3)	       ; ������,��������ͼ��
	      (redraw)
	      (cond
		((= cutmode 1)
		 (setq cutmode 2)
		 (entdel l0)
		 (setq cutdetail-text
		       (entity:make-text (strcat cutn "-"cutn ) data (* cscale 4)  0 0.8 0  "MM"))
		 
		 (setq box (text:box cutdetail-text))
		 (setq cutdetail-l1
		       (entity:make-lwpolyline
			(mapcar '(lambda(x)
				  (polar
				   x
				   (* 1.5 pi)
				   (* cscale 0.5)))
				(list (car box)(cadr box)))
			nil
			(* cscale 0.2)
			0 0))
		 (setq cutdetail-l2
		       (entity:make-lwpolyline
			(mapcar '(lambda(x)
				  (polar
				   x
				   (* 1.5 pi)
				   (* cscale 1)))
				(list (car box)(cadr box)))
			nil
			0 
			0 0))
		 
		 )
		((= cutmode 2)
		 (setq loopit nil)
		 )
		((= cutmode 3)
		 (setq cutmode 2)
		 (entdel l0)
		 (setq cutdetail-text
		       (entity:make-text (strcat cutn"-"cutn) data (* cscale 4)  0 0.8 0  "MM"))
		 
		 (setq box (text:box cutdetail-text))
		 (setq cutdetail-l1
		       (entity:make-lwpolyline
			(mapcar '(lambda(x)
				  (polar
				   x
				   (* 1.5 pi)
				   (* cscale 0.5)))
				(list (car box)(cadr box)))
			nil
			(* cscale 0.2)
			0 0))
		 (setq cutdetail-l2
		       (entity:make-lwpolyline
			(mapcar '(lambda(x)
				  (polar
				   x
				   (* 1.5 pi)
				   (* cscale 1.5)))
				(list (car box)(cadr box)))
			nil
			0 
			0 0))
		 )
		)
	      (princ "\nָ�������:")
	      )
	     ((= code 5)   ;; ����ƶ�
	      (if (= (getvar "ORTHOMODE") 1)
		  (progn
		    (setq x0 (car pt0)
			  y0 (cadr pt0)
			  x1 (car data)
			  y1 (cadr data)
			  )
		    (if (> (abs (- x0 x1)) (abs (- y0 y1)))
			(setq pt (list x1 y0))
			(setq pt (list x0 y1))
			)
		    )
		  (setq pt data)
		  )
	      (setq r (angle pt0 pt)
		    rr (* r (/ 180 pi))
		    )
	      (if (= cutmode 1)
		  (progn
		    (entity:putdxf ent0 11 pt)
		    ;;
		    (curve:put-points cutline1
				      (list (polar pt0 r (* cscale 4))
					    nil
					    (polar pt0(m:fix-angle (- r (* 0.5 pi))) (* cscale 2))
					    (polar pt0(m:fix-angle (- r (* 0.5 pi))) (* cscale 4)))

				      )
		    ;; ����λ��
		    (entity:putdxf cuttext1  11
				   ;; (polar  ;; ��������
				   ;;  (point:mid pt0 (polar pt0(m:fix-angle (- r (* 0.5 pi))) (* cscale 4)))
				   ;;  (m:fix-angle(+ pi r))
				   ;;  (* 1.2(entity:getdxf cuttext1 40)))
				   (polar pt0(m:fix-angle (- r (* 0.5 pi))) (* cscale 6)))
		    
		    (entity:putdxf cuttext1 50 (m:fix-angle (- r (* 0.5 pi))))
		    (curve:put-points cutline2
				      (list (polar pt(m:fix-angle(+ r pi)) (* cscale 4))
					    pt
					    (polar pt (m:fix-angle (- r (* 0.5 pi))) (* cscale 2))
					    (polar pt (m:fix-angle (- r (* 0.5 pi))) (* cscale 4)))
				      )
		    (entity:putdxf cuttext2 11
				   (polar pt (m:fix-angle (- r (* 0.5 pi))) (* cscale 6)))
		    (entity:putdxf cuttext2 50(m:fix-angle (- r (* 0.5 pi))))
		    ))
	      (if (= cutmode 2)
		  (progn ;; �ƶ�detail
		    (entity:putdxf cutdetail-text 11 data)
		    (setq box (text:box cutdetail-text))
		    (curve:put-points cutdetail-l1
				      (mapcar '(lambda(x)
						(polar
						 x
						 (* 1.5 pi)
						 (* cscale 0.5)))
					      (list (car box)(cadr box))))
		    (curve:put-points cutdetail-l2
				      (mapcar '(lambda(x)
						(polar
						 x
						 (* 1.5 pi)
						 (* cscale 1.5)))
					      (list (car box)(cadr box))))
		    ))
	      (if (= cutmode 3);;����
		  (progn
		    (entity:putdxf l0 11 pt)
		    (if cutdrection-l
			(curve:put-points
			 cutdrection-l
			 (list pt0
			       (polar
				pt0
				(m:fix-angle(+ pi r))
				(* cscale 8))
			       (polar
				pt0
				(m:fix-angle(+ pi r))
				(* cscale 12)))))
		    (if cutdrection-text
			(progn
			  (entity:putdxf
			   cutdrection-text
			   11
			   (polar
			    (point:mid pt0
				       (polar
					pt0
					(m:fix-angle(+ pi r))
					(* cscale 5)))
			    (+ r (* 0.5 pi))
			    (* cscale 5)
			    ))
			  (entity:putdxf cutdrection-text 50
					 (m:fix-angle r)))
			)
		    ))
	      )
	     ((or(= code 11) (= code 25));; ����һ�
	      (if (= cutmode 1)
		  (progn
		    (princ (strcat "\nָ����ͷ����,�����:<" cutn  ">,�Ҽ�����"))
		    (setq cutmode 3)
		    ;;ɾ������
		    (mapcar '(lambda(x)
			      (if (e2o x)
				  (vla-put-visible
				   (e2o x)
				   :vlax-false)))
			    (list cutline1 cuttext1
				  cutline2 cuttext2))
		    ;;��������
		    (if (and  cutdrection-l cutdrection-text)
			(mapcar '(lambda(x)
				  (if (e2o x)
				      (vla-put-visible
				       (e2o x)
				       :vlax-true)))
				(list cutdrection-l
				      cutdrection-text
				      ))
			(progn
			  (setq cutdrection-l
				(entity:make-lwpolyline
				 (list pt0
				       (polar pt0 pi (* cscale 8))
				       (polar pt0 pi (* cscale 12)))
				 nil
				 (list (* cscale 0.3)
				       (list (* cscale 1) 0))
				 0 0)
				)
			  (setq cutdrection-text
				(entity:make-text (strcat cutn  "��")
						  (polar
						   (point:mid
						    pt0
						    (polar pt0 pi (* cscale 8)))
						   (- (angle
						       pt0
						       (polar pt0 pi (* cscale 6)))
						      (* 0.5 pi))
						   (* cscale 3)
						   )
						  (* cscale 4)  0 0.8 0  "MM"))
			  )))
		  (if (= cutmode 3)
		      (progn
			(princ (strcat "\nָ����ͷ����,�����:<" cutn ">,�Ҽ�����"))
			(setq cutmode 1)
			(mapcar '(lambda(x)
				  (if (e2o x)
				      (vla-put-visible
				       (e2o x)
				       :vlax-false)))
				(list cutdrection-l
				      cutdrection-text
				      ))
			(mapcar '(lambda(x)
				  (if (e2o  x)
				      (vla-put-visible
				       (e2o x)
				       :vlax-true)))
				(list cutline1 cuttext1
				      cutline2 cuttext2))
			))
		  )
	      (if (= cutmode 2)
		  (progn
		    (setq loopit nil)
		    )
		  )
	      (redraw)
	      )
	     )
	   loopit
	   )
    )
  (mapcar
   '(lambda (x)
     (if (and x
	      (e2o x)
	      (= :vlax-false(vla-get-visible (e2o x))))
	 (entdel x)))
   (list l0
	 cutline1 cuttext1
	 cutline2 cuttext2
	 cutdetail-text
	 cutdetail-l1
	 cutdetail-l2
	 cutdrection-l
	 cutdrection-text))
  (princ)
  )
