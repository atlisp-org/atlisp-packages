;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define a first config item  'at-dim:first for package at-dim 's configitem first 
(@:define-config 'at-dim:first "I'm th default value for at-dim:first" "This Item 's Explain.")
(@:define-config 'at-dim:scale 100 "��ע����")
;; (@:get-config 'at-dim:first) 
;; (@:set-config 'at-dim:first  "New Value")
;; Add menu in @lisp panel
(@:add-menu "��ע" "ѡ�߱�б��" "(at-dim:menu-dim-slope)" )
(defun at-dim:hello ()
  (@:help (strcat "The content can show in user interface .\n"
  	  		  ))
  (alert (strcat "��ע 's first function.\n"
		 "Created a config item at-dim:first .\n"
		 "THe config ietm th family is this item: " (@:get-config 'at-dim:first)
		 ))
  (princ)
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
  (setq scale1 (@:get-config 'at-dim:scale))
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
(@:add-menu "��ע" "���ñ���" "(at-dim:set-scale)" )
(defun at-dim:set-scale (/ scale1 )
  (setq scale1  (getint (strcat "�������ע���� <" (itoa (@:get-config 'at-dim:scale)) ">: ")))
  (if scale1
      (progn
	(@:set-config 'at-dim:scale scale1)))
  )

;; (defun @dim:dim-box (/ pts box ent-lw)
;;   "��Χ���ܱ߱�ע"
;;   (setq pts (line:get-lwpoints (setq ent-lw (car (entsel "��ѡ������:")))))
;;   (setq box (entity:getbox ent-lw))

;;   ;; x ��
;;   (setq pts-x pts)
;;   (while (> (length pts-x) 1)
;;     (
  

