;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-cnc:first ���� Ӧ�ð� at-cnc �� ��һ�������� first 
(@:define-config '@cnc:U-axis 1  "�Ƿ���U��")
(@:define-config '@cnc:r  6.0  "ϳ��ֱ��")
(@:define-config '@cnc:f 100  "��������")
(@:define-config '@cnc:motor-speed 1000 "���ת��")
(@:define-config '@cnc:to-origin 1  "��ɺ��Ƿ�ؿ�")
(@:define-config '@cnc:thickness 10.0 "Ҫ�ӹ������ĺ��")
(@:define-config '@cnc:candle "" "Candle �ļ�·��")

;; (@:get-config 'at-cnc:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-cnc:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menus '("@CNC"
	       ("����G����" (at-cnc:gen-gcode))
	       ("����@CNC" (at-cnc:setup))
	       ("ɾ����·" (at-cnc:remove-route))
	       ("��Candle" (at-cnc:open-candle))))
(defun at-cnc:setup (/ res)
  "���̹��������Ϣ"
  (setq @:tmp-search-str "@CNC")
  (@:edit-config)
  )
(defun at-cnc:motor-on (speed)
  (write-line (strcat "M3 S" (itoa(fix speed))) fp-cnc)
  )
(defun at-cnc:motor-off ()
  (write-line "M5 " fp-cnc)
  )

(defun at-cnc:open-candle ()
  (@:help '("�� Candle ����CAM"))
  (if (= "" (@:get-config '@cnc:candle))
    (if (setq path (getfiled "Candle �ļ�" "D:\\" "exe" 8))
      (@:set-config '@cnc:candle path))
  )
  (if (findfile(@:get-config '@cnc:candle))
    (startapp (@:get-config '@cnc:candle) (strcat @:*prefix* "at.nc"))))
(defun at-cnc:remove-route ()
  (mapcar 'entdel (pickset:to-list (ssget "x" '((0 . "circle,lwpolyline,line")(62 . 2)))))
  )

(defun at-cnc:lwpl2gcode (ent / pts bulges route)
  (vla-offset (e2o ent)
	      (* 0.5 (@:get-config '@cnc:r)
		 (if (curve:clockwisep ent) 1 -1)
		 )
	      )
  (setq route (entlast))
  (entity:putdxf route 62 2)
  (setq bulges(curve:pline-convexity route))
  (setq pts (curve:get-points route))
  ;; ���
  
  ;;����
  (setq pt0 (mapcar '- (car pts) at-cnc:pt-base))
  (write-line
   (strcat "G90 G00 "
	   "X" (rtos (car pt0) 2 3) " "
	   "Y" (rtos (cadr pt0) 2 3) " ")
   fp-cnc)
  (write-line (strcat "G90 G00 Z-"
		      (if (and (entity:getdxf route 39)
			       (/= (entity:getdxf route 39) 0))
			  (rtos (abs (entity:getdxf route 39)) 2 3)
			(rtos (@:get-config '@cnc:thickness) 2 3)))
	      fp-cnc)
  (setq pre-pt pt0)
  (foreach pt% (cdr pts)
	   (setq pt (mapcar '- pt% at-cnc:pt-base))
	   (if (= 0 (car bulges))
	       (write-line
		(strcat "G90 G00 "
			"X" (rtos (car pt) 2 3) " "
			"Y" (rtos (cadr pt) 2 3) " "
			)
		fp-cnc)
	     (progn
	       (setq co (curve:bulge2o pre-pt pt (car bulges)))
	       (setq ij (mapcar '- co pre-pt))
	       (write-line
		(strcat "G90 G0"
			(if (< (car bulges) 0) "2 " "3 ")
			"X" (rtos (car pt) 2 3) " "
			"Y" (rtos (cadr pt) 2 3) " "
			"I" (rtos (car ij) 2 3)" "
			"J" (rtos (cadr ij) 2 3)" "
			"F200"
			)
		fp-cnc))
	     )
	   (setq pre-pt pt)
	   (setq bulges (cdr bulges))
	   )
  (if (= 1 (entity:getdxf route 70))
      (if (= 0 (car bulges))
	  (write-line
	   (strcat "G90 G00 "
		   "X" (rtos (car pt0) 2 3) " "
		   "Y" (rtos (cadr pt0) 2 3) " "
		   )
	   fp-cnc)
	(progn
	  (setq co (curve:bulge2o pre-pt pt0 (car bulges)))
	  (setq ij (mapcar '- co pre-pt))
	  (write-line
	   (strcat "G90 G0"
		   (if (< (car bulges) 0) "2 " "3 ")
		   "X" (rtos (car pt0) 2 3) " "
		   "Y" (rtos (cadr pt0) 2 3) " "
		   "I" (rtos (car ij) 2 3)" "
		   "J" (rtos (cadr ij) 2 3)" "
		   "F200"
		   )
	   fp-cnc))
	)
    )
  ;;����
  (write-line "G90 G00 Z0" fp-cnc)
  )
(defun at-cnc:circle2gcode (ent / pts bulges route)
  (vla-offset (e2o ent)
	      (* -0.5 (@:get-config '@cnc:r)
		 )
	      )
  (setq route (entlast))
  (entity:putdxf route 62 2)
  (if (= 1 (@:get-config '@cnc:U-axis))
      (progn
	;; U ��
	;;����
	(setq pt (mapcar '- (entity:getdxf route 10)  at-cnc:pt-base))
	(write-line
	 (strcat "G90 G00 "
		 "X" (rtos (car pt) 2 3) " "
		 "Y" (rtos (cadr pt) 2 3) " ")
	 fp-cnc)
	(write-line (strcat "G01 U"
			    (rtos (entity:getdxf route 40) 2 3)
			    " Z-"
			    (if (and (entity:getdxf route 39)
				     (/= (entity:getdxf route 39) 0))
				(rtos (abs(entity:getdxf route 39)) 2 3)
			      (rtos (@:get-config '@cnc:thickness) 2 3)))
		    fp-cnc)
	)
    (progn ;; ��U��
      (setq pt (mapcar '- (entity:getdxf route 10)  at-cnc:pt-base))
      (setq pt-arc0 (polar pt 0 (entity:getdxf route 40)))
      (setq pt-arc1 (polar pt pi (entity:getdxf route 40)))
      (write-line
       (strcat "G90 G00 "
		 "X" (rtos (car pt-arc0) 2 3) " "
		 "Y" (rtos (cadr pt-arc0) 2 3) " ")
       fp-cnc)
      (write-line (strcat "G90 G00 Z-"
			  (if (and (entity:getdxf route 39)
				   (/= (entity:getdxf route 39) 0))
			      (rtos (abs(entity:getdxf route 39)) 2 3)
			    (rtos (@:get-config '@cnc:thickness) 2 3)))  
		  fp-cnc)
      (write-line
       (strcat "G90 G02 "
		 "X" (rtos (car pt-arc1) 2 3) " "
		 "Y" (rtos (cadr pt-arc1) 2 3) " "
		 "I-"(rtos (entity:getdxf route 40) 2 3)
		 "F200"
		 )
       fp-cnc)
      (write-line
       (strcat "G90 G02 "
		 "X" (rtos (car pt-arc0) 2 3) " "
		 "Y" (rtos (cadr pt-arc0) 2 3) " "
		 "I"(rtos (entity:getdxf route 40) 2 3)
		 "F200"
		 )
       fp-cnc)
      ))
  ;;����
  (write-line "G90 G00 Z0" fp-cnc)
  )


(defun at-cnc:gen-gcode (/ *error* curves fp-cnc)
  (defun *error* (msg)
    (if (= 'file (type fp-cnc))(close fp-cnc))
    (@:*error* msg))
  (setq curves (pickset:to-list (ssget '((0 . "line,lwpolyline,circle")))))
  (setq at-cnc:pt-base (append (car (pickset:getbox curves 0)) (list 0)))
  (setq fp-cnc (open (strcat @:*prefix* "at.nc")"w"))
  ;; �������
  (at-cnc:motor-on (@:get-config '@cnc:motor-speed))
  (foreach curve curves
	   (cond
	    ((= "LWPOLYLINE" (entity:getdxf curve 0))
	     (at-cnc:lwpl2gcode curve))
	    ((= "CIRCLE" (entity:getdxf curve 0))
	     (at-cnc:circle2gcode curve))
	    )
	   )
  ;; ����
  (at-cnc:motor-off)
  (if (= 1 (@:get-config '@cnc:to-origin))
      (write-line "G90 G00 X0 Y0 Z50" fp-cnc))
  (close fp-cnc)
  (@:prompt "����G�����ļ� at.nc")
  (princ)
  )
