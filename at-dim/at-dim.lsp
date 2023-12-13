;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define a first config item  'at-dim:first for package at-dim 's configitem first 

(@:define-config '@dim:layer "dim-coor" "��עͼ�㣬Ϊ��ʱΪ��ǰͼ��")
(@:define-config '@dim:arrow "" "��ͷ��ʽ")
(@:define-config '@dim:units 3 "��ע���ȣ�С��λ")
(@:define-config '@dim:text-units "m" "��ע��λ��m�ף�mm����")
(@:define-config '@dim:draw-units "mm" "��ͼ��λ��m�ף�mm����")
(@:define-config '@dim:scale 100 "��ע����")
(@:define-config '@dim:textheight 2.5 "��ע���ָ߶�")
(@:define-config '@dim:coordinate-position 0 "�����עλ�ã�0 �Զ���1 �ֶ�")
(@:define-config '@dim:prefix "XY" "��ע��ʽ����ѡ XY,AB,NE")
(@:define-config '@dim:elevation 1 "��ע��ߣ�0����ע��ߣ�1��ע���")
(@:define-config '@dim:switch-xy 0 "XY���껥����0 ��������1 ����")
;; (@:get-config 'at-dim:first) 
;; (@:set-config 'at-dim:first  "New Value")
;; Add menu in @lisp panel
(@:add-menu "��ע" "��ע����" "(@dim:setup)" )
(@:add-menu "��ע" "ѡ�߱�б��" "(at-dim:menu-dim-slope)" )
(@:add-menu "��ע" "�����ע" "(at-dim:menu-zbbz)" )
(@:add-menu "��ע" "���ñ���" "(at-dim:set-scale)" )

(defun @dim:setup (/ res)
  (setq res 
	(ui:input "������Ϣ"
		  (mapcar '(lambda (x) (list (strcase (vl-symbol-name (car x)) T)(cadr x)(cddr x)))
			  (vl-remove-if '(lambda (x) (not (wcmatch (vl-symbol-name (car x)) "`@DIM:*")))
					(if @:*config.db*
					    @:*config.db* (@:load-config))))))
  (foreach res% res
   	   (@:set-config (read (car res%)) (cdr res%)))
  )
(defun at-dim:set-env (/ obj-st obj-dimst ent-dimst)
  (if (null (tblsearch "layer" "�¶ȱ�ע"))
      (layer:make "�¶ȱ�ע" 1 nil nil))
  (setvar "clayer"  "�¶ȱ�ע" )
  (if (null  (tblsearch "style" "�¶ȱ�ע"))
      (progn
	(setq obj-st (vla-add *STS* "�¶ȱ�ע"))
	(vla-put-fontfile obj-st "complex")))
  ;;(setvar "textstyle"  "�����ע" )
  (if (null  (tblsearch "dimstyle" "�¶ȱ�ע"))
      (entmakex '((0 . "DIMSTYLE") (100 . "AcDbSymbolTableRecord") (100 . "AcDbDimStyleTableRecord") (2 . "�¶ȱ�ע") (70 . 0) (3 . "") (41 . 5.0) (42 . 0.625) (43 . 3.75) (44 . 1.25) (73 . 0) (74 . 0) (77 . 1) (78 . 8) (140 . 5.0) (141 . 2.5) (143 . 0.0393701) (147 . 0.625) (171 . 3) (172 . 1) (271 . 0) (272 . 0) (274 . 3) (278 . 44) (283 . 0) (284 . 8))))
  ;;(setvar "cdimstyle"  "�����ע" )
  ;; (setq ent-dimst (std:vla->e (setq obj-dimst (vla-add *DIMS* "�����ע"))))
  ;; (entity:putdxf ent-dimst 3 "m")
  
  )
(defun at-dim:menu-dim-slope ()
  (at-dim:set-env)
  (prompt "��ѡ��Ҫ��עб�ʵ�ֱ�߻�����:")
  (setq ss1 (pickset:to-list (ssget '((0 . "*line")))))
  (foreach ent% ss1
	   (at-dim:dim-slope ent%)))

(defun at-dim:dim-slope (ent1 / pts pt-mid len1 ent-text angle-arrow  angle-text scale1)
  ;; (setq ent1 (car (entsel "��ѡ��һ������ߣ�")))
  (setq scale1 (@:get-config '@dim:scale))
  (setq pts (curve:pline-2dpoints ent1))
  (setq i% 0)
  (while (< i% (1- (length pts) ))
    (setq angle-text (angle (nth i% pts) (nth (1+ i%) pts)))
    (cond
      ((and (> angle-text  (* 0.5 pi)) (< angle-text pi))
       (setq angle-text (+ angle-text pi)))
      ((and (>= angle-text  pi) (< angle-text (* 1.5 pi)))
       (setq angle-text (- angle-text pi))))

    (setq ent-text
	  (entity:make-text (strcat "1:" (rtos (abs (/ (- (car (nth i% pts))
							  (car (nth (1+ i%) pts)))
						       (- (cadr (nth i% pts))
							  (cadr (nth (1+ i%) pts)))))
					       2 2))
			    (setq pt-mid (polar  (nth i% pts) (angle (nth i% pts) (nth (1+ i%) pts))
						 (* 0.5 (distance (nth i% pts) (nth (1+ i%) pts)))))
			    (* scale1 2.5)
			    angle-text
			    0.8 0 23))
    (setq angle-arrow (angle (nth i% pts) (nth (1+ i%) pts)))
    (if (< angle-arrow pi) (setq angle-arrow (+ pi angle-arrow)))
    (entity:putdxf (entity:make-leader (polar pt-mid  angle-arrow
					      (* 0.2 (distance (nth i% pts) (nth (1+ i%) pts))))
				       (polar pt-mid  (- angle-arrow pi)
					      (* 0.2  (distance (nth i% pts) (nth (1+ i%) pts))))
				       )
		   62 1)
    (setq i% (1+ i%))
    )
  )
(defun at-dim:set-scale (/ scale1 )
  (setq scale1  (getint (strcat "�������ע���� <" (itoa (@:get-config '@dim:scale)) ">: ")))
  (if scale1
      (progn
	(@:set-config '@dim:scale scale1)))
  )
(defun at-dim:menu-zbbz (/ pt-b  pt-c  txtx txty txth line th unit1)
  (@:help "��עѡ��������꼰���")
  (if (and (/= "" (@:get-config '@dim:layer))
	   (null(tblsearch "layer"  (@:get-config '@dim:layer))))
      (layer:make  (@:get-config '@dim:layer) 2 nil nil))
      
  (setq pt-b (getpoint "ѡ�������:"))
  (setq th (* (@:get-config '@dim:textheight)(@:get-config '@dim:scale)))
  (cond
    ((= (@:get-config '@dim:draw-units)(@:get-config '@dim:text-units))
     (setq unit1 1.0))
    ((and (= (@:get-config '@dim:draw-units) "mm")
	  (= (@:get-config '@dim:text-units) "m"))
     (setq unit1 0.001))
    ((and (= (@:get-config '@dim:draw-units) "m")
	  (= (@:get-config '@dim:text-units) "mm"))
     (setq unit1 1000))
    (t (setq unit1 1.0))
    )

    
  (setq ss (ssget pt-b))
  ;;relative position
  (setq ang-rel (angle (point:centroid (pickset:getbox ss 0)) pt-b))
  ;;����
  (if(= 0 (@:get-config '@dim:coordinate-position))
     (cond
       ((< ang-rel (* 0.5 pi))
	(setq txt-ang 0)
	(setq pt-c (polar pt-b (* 0.25 pi) (* th 4))))
       ((< (* 0.5 pi) ang-rel pi)
	(setq txt-ang pi)
	(setq pt-c (polar pt-b (* 0.75 pi) (* th 4))))
       ((< pi ang-rel (* 1.5 pi))
	(setq txt-ang pi)	
	(setq pt-c (polar pt-b (* 1.25 pi) (* th 4))))
       ((< (* 1.5 pi) ang-rel (* 2 pi))
	(setq txt-ang 0)
	(setq pt-c (polar pt-b (* 1.75 pi) (* th 4)))))
     (progn
       (setq pt-c (getpoint pt-b "����λ��:"))
       (setq txt-ang (getangle pt-c "���ַ���:"))
       ))
  (setq txt-ang1 (if (> txt-ang (* 0.5 pi))
		     (- txt-ang pi)
		     txt-ang))
  (if (< txt-ang  (* 0.5 pi))
      (setq  txtdq "LB")
      (setq txtdq "RB"))
  (if(> (strlen (@:get-config '@dim:prefix))1)
     (progn
       (setq prefix-x (substr (@:get-config '@dim:prefix) 1 1))
       (setq prefix-y (substr (@:get-config '@dim:prefix) 2 1)))
     (progn
       (setq prefix-x "X")
       (setq prefix-y "Y"))
     )
  (setq txtx
	(entity:make-text (strcat prefix-x "=" (rtos(* unit1 (car pt-b)) 2 (@:get-config '@dim:units))) pt-c
			  th
			  txt-ang1 0.8 0 txtdq))
  (setq txty
	(entity:make-text (strcat prefix-y "=" (rtos (* unit1(cadr pt-b)) 2 (@:get-config '@dim:units)))
			  (polar pt-c  (+ txt-ang1 (* 1.5 pi)) (* 1.2 th))
			  th
			  txt-ang1 0.8 0 txtdq))
  (setq ents (list txtx txty))
  (if (= 1 (@:get-config '@dim:elevation))
      (progn
	(setq txth
	      (entity:make-text (strcat "H=" (rtos (* unit1(caddr pt-b)) 2 (@:get-config '@dim:units))) (polar pt-c (+ txt-ang1 (* 1.5 pi)) (* 2.4 th)) th txt-ang1 0.8 0 txtdq))
	(setq ents (cons txth ents))))
  (apply 'max
	 (mapcar '(lambda(x / box)
		   (setq box (text:box x))
		   (distance (car box)(cadr box)))
		 ents))
  (setq line
	(entity:make-lwpolyline
	 (list pt-b
	       pt-c
	       (polar pt-c txt-ang (apply 'max
					  (mapcar '(lambda(x / box)
						    (setq box (text:box x))
						    (distance (car box)(cadr box)))
						  (list txtx txty txth)))))
	 nil 0 0 0))
  (entity:putdxf line 38 (caddr pt-b))
  (setq ents (cons line ents))
  (if (/= "" (@:get-config '@dim:layer))
      (mapcar '(lambda (x)
		(entity:putdxf x 8 (@:get-config '@dim:layer)))
	      ents))
       
  ;; ����
  (group:make ents (strcat "XY" (@:timestamp)))
  )

	 
