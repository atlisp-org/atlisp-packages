(@:define-config 'route-of-hole2shape:offset 3.0 "��·���ԭ����ߵ�ƫ��������Ϊ��ƫ������Ϊ��ƫ��")
(@:define-config 'ROUTE-OF-HOLE2SHAPE:layer  "BBB" "��·������ͼ��")
(@:define-config 'ROUTE-OF-HOLE2SHAPE:color  200 "�½��ĵ�·����ɫ")
(@:define-config 'route-of-hole2shape:c2pl-vertex  4 "Բת����ߵĶ���������ֵ����С��2")
(setq route-of-hole2shape:*show-clockwise* nil)
(layer:make (@:get-config  'ROUTE-OF-HOLE2SHAPE:layer)
	    (@:get-config  'ROUTE-OF-HOLE2SHAPE:color)
	    nil nil)
(@:add-menus
 '(("�׵��ߵ�·"
    ("����" "(route-of-hole2shape:config)")
    ("�ֶ���·" "(route-of-hole2shape:menu-route)")
    ("�Զ���·" "(route-of-hole2shape:auto)")
    ("Բ��PL��" "(route-of-hole2shape:c2pl)")
    ;;("��������" "(route-of-hole2shape:show-clockwise)")
    ("ɾ����·" "(route-of-hole2shape:remove-route)")
    ("PLԲ��ɫ" "(route-of-hole2shape:bianbie)")
    )))

(defun route-of-hole2shape:config (/ res)
  "���̹��������Ϣ"
  (setq res 
	(ui:input "������Ϣ"
		  (mapcar '(lambda (x) (list (strcase (vl-symbol-name (car x)) T)(cadr x)(cddr x)))
			  (vl-remove-if '(lambda (x) (not (wcmatch (vl-symbol-name (car x)) "ROUTE-OF-HOLE2SHAPE:*")))
					(if @:*config.db*
					    @:*config.db* (@:load-config))))))
  (foreach res% res
   	   (@:set-config (read (car res%)) (cdr res%)))
  )
(defun route-of-hole2shape:input-offset (/ res)
  "���̹��������Ϣ"
  (setq res 
	(ui:input "������Ϣ"
		  (mapcar '(lambda (x) (list (strcase (vl-symbol-name (car x)) T)(cadr x)(cddr x)))
			  (vl-remove-if '(lambda (x) (not (wcmatch (vl-symbol-name (car x)) "ROUTE-OF-HOLE2SHAPE:OFFSET")))
					(if @:*config.db*
					    @:*config.db* (@:load-config))))))
  (foreach res% res
   	   (@:set-config (read (car res%)) (cdr res%)))
  )

(defun route-of-hole2shape:menu-route (/ pt-c pt-pl clockwise offset i new-pts ent-shape)
  (push-var)
  (setq pt-c (entity:getdxf (car (entsel "ѡ��Բ��")) 10))
  (setvar "osmode" 16383)
  (setq pt-pl (getpoint pt-c "ѡ������:"))
  (pop-var)
  (setq ent-shape (car(pickset:to-list(ssget pt-pl '((0 . "lwpolyline"))))))
  (setq clockwise (ui:confirm "˳ʱ�뷽���ȷ������ʱ���ȡ��."))
  (route-of-hole2shape:input-offset)
  (setq offset (@:get-config 'route-of-hole2shape:offset))
  (route-of-hole2shape:route pt-c ent-shape clockwise offset nil))

(defun route-of-hole2shape:route (pt-c ent-pl clockwise offset closeto?
				       / ent-shape ent-pts pt-closeto
				       convexity closed?)
  ;; closeto? T Ϊ�����ϵ�����㣬 nil Ϊ�����ϵĶ���
  ;;ѡ������
  ;; ����ͬ ������ͬ
  
  (setq ent-shape (route-of-hole2shape:offset-shape ent-pl))
  (setq closed? (entity:getdxf ent-shape 70))
  ;; ��ʱ����򲻶�
  (if (and (/= (curve:clockwisep ent-shape)
	       clockwise)
	   (= 1 closed?))
      (progn
	(setq ent-shape1 (curve:lwpl-turn-clockwise ent-shape))
	(entdel ent-shape)
	(setq ent-shape ent-shape1
	      ent-shape1 nil)
 	))

  (setq ent-pts (curve:pline-3dpoints ent-shape))
  (setq convexity (curve:pline-convexity ent-shape))
  (if (> (length ent-pts) (entity:getdxf ent-shape 90))
      (if closeto?
	  (setq ent-pts (reverse(cdr(reverse ent-pts))))
	(setq ent-pts (cdr ent-pts))))
  (if (> (length convexity) (entity:getdxf ent-shape 90))
      (setq convexity (reverse(cdr(reverse convexity)))))
  (if (= 1 closed?)
      (if closeto?
	  (setq pt-closeto (route-of-hole2shape:pt-closeto-curve pt-c ent-shape))
	(setq pt-closeto (route-of-hole2shape:pt-closeto-vertex pt-c ent-shape)))
    (if (= 0 closed?)
	(if (< (distance pt-c (car ent-pts))
	       (distance pt-c (last ent-pts)))
	    (setq pt-closeto (car ent-pts))
	  (progn
	    (setq pt-closeto (last ent-pts))
	    (setq ent-pts (reverse ent-pts)))
	  )))
			  
   ;; ������Ƿ��붥���غ�
  (setq i -3)
  (while (and
	  (> (distance (car ent-pts) pt-closeto) 0.00001)
	  (not (curve:pt-in-arc-p
		    pt-closeto
		    (car ent-pts)
		    (cadr ent-pts)
		    (car convexity)))
	  (<= i (length ent-pts)))
    (setq ent-pts (append (cdr ent-pts) (list (car ent-pts))))
    (setq convexity (append (cdr convexity) (list (car convexity))))
    (setq i (1+ i))
    )
  (setq ent-pts (append (cdr ent-pts) (list (car ent-pts))))
  (setq convexity (append (cdr convexity) (list (car convexity))))
  ;; �������������ͬ
  ;; (if (= (car (reverse ent-pts))
  ;; 	 (cadr (reverse ent-pts)))
  ;;     (setq ent-pts (reverse (cdr (reverse ent-pts)))))
  
  ;; ���� ͹��
  (if (equal (apply 'min (mapcar '(lambda(x)(distance x pt-closeto)) ent-pts))
	     0.0 0.0000001)
      (progn
	(princ "�����Ϊ����\n")
	(if (= 1 closed?)
	    (progn
	      (if (equal 0.0 (distance pt-closeto (car ent-pts)) 0.0000001)
		  (progn 
		    (setq ent-pts (append (cdr ent-pts)(list (car ent-pts))))
		    (setq convexity (append (cdr convexity)(list (car convexity)))))
		    )
	      (setq new-convexity (append (list 0) convexity (list 0)))
	      (setq new-pts (append (list pt-c pt-closeto) ent-pts )))
	  (progn 
	    (setq new-convexity (append (list 0) convexity))
	    (setq new-pts (append (list pt-c pt-closeto) (reverse (cdr (reverse ent-pts))))))))
      (progn
	(setq new-convexity
	      (if (= 0 (last convexity))
		  (setq convexity (append (list 0 0) convexity (list 0)))
		(progn 
		  (setq O (curve:bulge2O (last ent-pts)(car ent-pts)(last convexity)))
		  (setq convexity
			(append (list 0)
				(list (* (if (> (last convexity)0) 1 -1)(curve:O2bulge pt-closeto
									   (car ent-pts)
									   O)))
				(reverse(cdr (reverse convexity)))
				(list  (* (if (> (last convexity)0) 1 -1) ;;(if clockwise 1 -1)
					  (curve:O2bulge pt-closeto
							 (last ent-pts)
							 O)))
				(list 0)))
		  )))
	(setq new-pts (append (list pt-c pt-closeto) ent-pts (list pt-closeto)))
	;;(format t "vertexs ~a | ~a" (length new-pts)(length ent-pts))

	))
  ;; (princ "\n")
  ;; (princ convexity)(princ "\n")
  ;; (princ ent-pts)(princ "\n")
  ;; (princ "\n")
  ;; (princ new-convexity)(princ "\n")
  ;; (princ new-pts)(princ "\n")
  ;;(curve:ptoncurve pt ;; ˳ʱ��Ϊ �죬��ʱ��Ϊ
  (push-var)
  (setvar "osmode" 0)
  (entity:putdxf
   (entity:putdxf 
    (entity:make-lwpline-bold
     new-pts new-convexity nil closed? 0)
    62 222);; (if clockwise 1 2))
   8 (@:get-config 'route-of-hole2shape:layer))
  (entdel ent-shape)
  (pop-var)
  (princ)
  )

;; ����ƫ��
(defun route-of-hole2shape:offset-shape (ent / offset )
  (if (= 1 (entity:getdxf ent 70))
      (progn
	(if (curve:clockwisep ent)
	    (setq offset (- (@:get-config 'route-of-hole2shape:offset)))
	  (setq offset (@:get-config 'route-of-hole2shape:offset)))
	(o2e(car (vlax-safearray->list(vlax-variant-value (vla-Offset (e2o ent) offset))))))
    (o2e(vla-copy (e2o ent)))))
  

;; �㵽���ߵ���С�����
(defun route-of-hole2shape:pt-closeto-curve (pt ent)
  (vlax-curve-getclosestpointto (e2o ent) pt))
;; �㵽���ߵ���С�����
(defun route-of-hole2shape:pt-closeto-vertex (pt ent / pts )
  (setq pts (curve:pline-3dpoints ent))
  (car (vl-sort pts '(lambda (x y)
		       (< (distance pt x)(distance pt y))))))
;; ����
;; 1. ���� :offset ����shape; 2. shape ���� hole �ģ����� hole (�����)
(defun route-of-hole2shape:auto (/ clockwise shapes hole-ent offset vertexs)
  (@:help (strcat "�Զ���·:\n"
		  " 1. ѡ��·����˳ʱ�� or ��ʱ��\n"
		  " 2. ����ƫ����\n"
		  " 3. ѡ�� shape "))
  (setq clockwise (ui:confirm "˳ʱ�뷽���ȷ������ʱ���ȡ��."))
  (route-of-hole2shape:input-offset)
  (setq offset (@:get-config 'route-of-hole2shape:offset))
  (setq shapes (pickset:to-list (ssget '((0 . "LWPOLYLINE")(70 . 1)))))
  
  (foreach shape% shapes
	   (if (curve:pline-3dpoints shape%)
	       (progn
		 (setq hole-ent (car (pickset:to-list (ssget "WP" (curve:pline-3dpoints shape%) '((0 . "circle"))))))
		 (if hole-ent
		     (progn
		       (print "�����ڲ���,׼�����ɵ�·")
		       (route-of-hole2shape:route (entity:getdxf hole-ent 10) shape% clockwise offset T))
		   (progn
		     (if (curve:lwpl-is-circle-p shape%)
			 (progn
			   (setq vertexs (curve:pline-3dpoints shape%))
			   (route-of-hole2shape:route (curve:bulge2O (car vertexs)(cadr vertexs)(car (curve:pline-convexity shape%)))
						      shape% clockwise offset T))
		       (princ "û�з����ڲ��ף�������")))
		   )))))


(defun route-of-hole2shape:remove-route ()
  (@:help (strcat "��ѡҪɾ���ĵ�·�ߡ�"))
  (mapcar 'entdel
	  (pickset:to-list
	   (ssget (list '(0 . "lwpolyline")
			(cons 8 (@:get-config 'ROUTE-OF-HOLE2SHAPE:layer))))))
  (princ))
	   
(defun route-of-hole2shape:c2pl (/ circles)
  (@:help (strcat "��Բת��Ϊ����ߡ�\n"))
  (prompt "��ѡ��Ҫ����ת����Բ:")
  (setq circles (pickset:to-list(ssget '((0 . "circle")))))
  (if (< (@:get-config 'route-of-hole2shape:c2pl-vertex) 2)
      (@:set-config 'route-of-hole2shape:c2pl-vertex 4))
  (mapcar '(lambda (x) (curve:circle2lwpl x (fix (@:get-config 'route-of-hole2shape:c2pl-vertex))))  circles)
  (mapcar 'entdel circles)
  (princ)
  )
(defun route-of-hole2shape:show-clockwise ()
  (foreach x  (pickset:to-list
	       (ssget "x" (list '(0 . "lwpolyline")
				(cons 8 (@:get-config 'ROUTE-OF-HOLE2SHAPE:layer)))))
	   
	     ;;(if route-of-hole2shape:*show-clockwise*
	   (progn
	     
	     (if (curve:clockwisep x)
		 (entity:putdxf x 62 1)
	       (entity:putdxf x 62 2)))
	   ;;(setq route-of-hole2shape:*show-clockwise* nil)
		   
	       ;; (progn
	       ;; 	 (entity:putdxf x 62 256)
	       ;; 	 (setq route-of-hole2shape:*show-clockwise* T)
	       ;; 	 )
	       )
  (princ))
(defun ROUTE-OF-HOLE2SHAPE:bianbie ()
  (foreach ent% (pickset:to-list (ssget '((0 . "lwpolyline,circle"))))
	   (cond
	    ((= "CIRCLE" (entity:getdxf ent% 0))
	     (entity:putdxf ent% 62 1))
	    ((= "LWPOLYLINE" (entity:getdxf ent% 0))
	     (entity:putdxf ent% 62 2)))))
