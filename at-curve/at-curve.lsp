;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(@:add-menus
 '("���߹���"
   ("˫�߻���" (at-curve:join))
   ("�Ż������" (at-curve:optimize-lwpl))
   ("ƽ��·��" (at-curve:fillet-road))
   ("�������" (at-curve:area))
   ("���߳���" (at-curve:length))
   ("ÿ�γ���" (at-curve:per-length))
   ("����ȱ��" (at-curve:notch))
   ("���߶˵�" (at-curve:link-end))
   ("ͳ���߳�" (at-curve:stat))
   ("���߱�˫" (at-curve:dualline))

   ))
(@:define-config
 '@curve:types
 "*POLYLINE,circle,arc,ellipse,spline,region"
 "�ɲ��������ߵ�ͼԪ����")
(defun at-curve:join (/ l1 l2 pts1 pts2)
  (@:help "ѡ�������ߣ�������˵����ӳ�һ��.")
  (setq curves (pickset:to-list (ssget '((0 . "*line")))))
  (setq pts1 (curve:pline-3dpoints (car curves)))
  (setq pts2 (curve:pline-3dpoints (cadr curves)))
  (if
      (<
       (distance (car pts1) (car pts2))
       (distance (last pts1) (car pts2)))
      (setq pts1 (reverse pts1)))
  (if
      (>
       (distance (last pts1) (car pts2))
       (distance (last pts1) (last pts2)))
      (setq pts2 (reverse pts2)))
  (entdel (car curves))
  (entdel (cadr curves))
  (entity:make-lwpline-bold
   (append pts1 pts2)
   nil
   nil
   0
   0))


(defun at-curve:area (/ lst-curve pts)
  (@:help '("��ע���ߵĵıպ����"))
  (@:prompt "��ѡ��պ�����:")
  (setq lst-curve (pickset:to-list
                   (ssget (list (cons 0 (@:get-config '@curve:types))))))
  (foreach curve lst-curve
           (entity:putdxf
            (entity:make-text
             (rtos (vla-get-area (e2o curve)) 2 3)
             (point:2d->3d (point:centroid (curve:get-points curve)))
             (* 2.5 (@:get-config '@:draw-scale))
             0
             0.72
             0
             "mm")
            62
            1))
  (princ))
(defun at-curve:length (/ lst-curve pts)
  (@:help '("�����ߵ��е�,��ע���ߵĳ���"))
  (@:prompt "��ѡ������:")
  (setq lst-curve (pickset:to-list
                   (ssget (list (cons 0 (@:get-config '@curve:types))))))
  (foreach curve lst-curve
           (entity:putdxf
            (entity:make-text
             (rtos (curve:length (e2o curve)) 2 3)
             (point:2d->3d (curve:midpoint curve))
             (* 2.5 (@:get-config '@:draw-scale))
             0
             0.72
             0
             "mb")
            62
            1))
  (princ))
(defun at-curve:per-length (/ lst-curve pts)
  (@:help '("��ע���ߵ�ÿ�γ���"))
  (@:prompt "��ѡ������:")
  (setq lst-curve (pickset:to-list
                   (ssget (list (cons 0 (@:get-config '@curve:types))))))
  (foreach curve lst-curve
	   (cond
	    ((= "LWPOLYLINE" (entity:getdxf curve 0))
	     (setq i 0)
	     (setq bulges (curve:pline-convexity curve))
	     (repeat (curve:subsegments curve)
		     (entity:putdxf
		      (entity:make-text
		       (rtos (curve:subsegment-length
			      curve
			      (car (curve:subsegment-points curve i))
			      (cadr (curve:subsegment-points curve i)))
			     2 3)
		       (point:2d->3d
			(if (= 0 (nth i bulges))
			    (point:mid
			     (car (curve:subsegment-points curve i))
			     (cadr (curve:subsegment-points curve i)))
			  (polar
			   (point:mid
			    (car (curve:subsegment-points curve i))
			    (cadr (curve:subsegment-points curve i)))
			   (-(angle  (car (curve:subsegment-points curve i))
				     (cadr (curve:subsegment-points curve i)))
			     (* 0.5 pi)
			     )
			   (* (nth i bulges) 0.5
			      (distance 
			       (car (curve:subsegment-points curve i))
			       (cadr (curve:subsegment-points curve i)))))
			  ))
		       
		       (* 2.5 (@:get-config '@:draw-scale))
		       (angle  (car (curve:subsegment-points curve i))
			       (cadr (curve:subsegment-points curve i)))
		       0.72
		       0
		       "mb")
		      62
		      1)
		     (setq i (1+ i))
		     ))
	    (t
             (entity:putdxf
              (entity:make-text
               (rtos (curve:length (e2o curve)) 2 3)
               (point:2d->3d (curve:midpoint curve))
               (* 2.5 (@:get-config '@:draw-scale))
               0
               0.72
               0
               "mb")
              62
              1)

	     )))
  (princ))
(defun at-curve:dualline ()
  (@:help '("������˫��ƫ�Ƴ�˫�ߡ�"))
  (if (null (member "DASHDOT" (tbl:list "linetype")))
      (vla-load *LTS* "DASHDOT" (findfile "acasiso.lin")))
  (or *dualline-width* (setq *dualline-width* 120))
  (setq dualline-width (getdist (strcat"\n"(@:speak"������")"<"(rtos *dualline-width* 2 3)">��")))
  (if dualline-width (setq *dualline-width* dualline-width))
  (setq lst-curve (pickset:to-list
                   (ssget (list (cons 0 (@:get-config '@curve:types))))))
  (foreach curve lst-curve
	   (vla-offset (e2o curve) (* 0.5 *dualline-width*))
	   (vla-offset (e2o curve) (* 0.5 *dualline-width* -1))
	   (entity:putdxf curve 6 "DASHDOT")
	   (entity:putdxf curve 62 1)
    )
  (princ)
  )
