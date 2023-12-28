;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-3d:first ���� Ӧ�ð� at-3d �� ��һ�������� first 
(@:define-config 'at-3d:first "���������� at-3d:first ��ֵ" "������������;˵����")
;; (@:get-config 'at-3d:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-3d:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "3D���" "ѡ������" "(at-3d:slice-by-pts)")
(@:add-menu "3D���" "·������" "(at-3d:slice-by-route)")

(defun at-3d:slice-by-pts ()
  (@:help '("��һ�������ù�������ƽ������"))
  (@:prompt "��ѡ����Ҫ���е�����:")
  (setq surfaces (ssget '((0 . "surface"))))
  
  (@:prompt "��ѡ���������еĿ��Ƶĵ�:")
  (setq pts (pickset:to-list(ssget '((0 . "point")))))
  (setq slicesurfaces (mapcar 'read (ui:select-multi "��ѡ�����淽ʽ"
				      '("1 ƽ����xy�� " "2 ƽ����yz��" "3 ƽ����zx��" "4 ��ֱ�ڵ�����"))))
  ;;ȡ�����ڵ����ߣ���㵽�������ľ��룬��㴦�����ߣ���㴦�Ĵ��档(vlax-curve-getDistAtPoint curve-obj point)
  ;; (if (and (setq route (ssget pt1))
  ;; 	   (setq firstdiv (vlax-curve-getfirstderiv (e2o route) (vlax-curve-getDistAtPoint (e2o route) pt1))))
  ;;     (setq surface-vr (list pt1

  ;; 			     ))
  ;;   (setq surface-vr nil)
  ;;   )
  (push-var)
  (foreach
   pt% pts
   (setq pt1 (entity:getdxf pt% 10))
   (setq surface-xy (list pt1
			  (mapcar '+ pt1 '(100 0 0))
			  (mapcar '+ pt1 '(0 100 0))))
   (setq surface-yz (list pt1
			  (mapcar '+ pt1 '(0 100 0 ))
			  (mapcar '+ pt1 '(0 0 100 ))))
   (setq surface-zx (list pt1
			  (mapcar '+ pt1 '(0 0 100))
			  (mapcar '+ pt1 '(100 0 0))))
   ;;ȡ�����ڵ����ߣ���㵽�������ľ��룬��㴦�����ߣ���㴦�Ĵ��档(vlax-curve-getDistAtPoint curve-obj point)
   (if (and (setq route (car (pickset:to-list (ssget "c"(polar pt1 0 10) (polar pt1 pi 10) '((0 . "*line"))))))
    	    (setq firstdiv (vlax-curve-getfirstderiv (e2o route) (vlax-curve-getDistAtPoint (e2o route) pt1))))
       (setq surface-vr (list pt1
			      (polar pt1 (+ (* 0.5 pi)(atan (cadr firstdiv)(car firstdiv)))  100)
			      (mapcar '+ pt1 '(0 0 100 ))
    			     ))
      (setq surface-vr nil)
      )
   (setq ent-last (entity:make-point '(0 0 0)))
   (setvar "osmode" 0)
   (if (member 1 slicesurfaces)
       (progn
	 (command "slice" surfaces "" "3"
		  (car surface-xy)
		  (cadr surface-xy)
		  (caddr surface-xy)
		  )
	 (while (> (getvar "cmdactive") 0)
	   (command "")
	   )
	 (if (= "SURFACE" (entity:getdxf (entlast) 0))
	     (setq surfaces (ssadd (entlast) surfaces)))))
   (if (member 2 slicesurfaces)
       (progn
	 (command "slice" surfaces "" "3"
		  (car surface-yz)
		  (cadr surface-yz)
		  (caddr surface-yz)
		  )
	 (while (> (getvar "cmdactive") 0)
	   (command "")
	   )
	 (if (= "SURFACE" (entity:getdxf (entlast) 0))
	     (setq surfaces (ssadd (entlast) surfaces)))))
   
   (if (member 3 slicesurfaces)
       (progn
	 (command "slice" surfaces "" "3"
		  (car surface-zx)
		  (cadr surface-zx)
		  (caddr surface-zx)
		  )
	 (while (> (getvar "cmdactive") 0)
	   (command "")
	   )
	 (if (= "SURFACE" (entity:getdxf (entlast) 0))
	     (setq surfaces (ssadd (entlast) surfaces)))))
   (if (member 4 slicesurfaces)
       (progn
	 (command "slice" surfaces "" "3"
		  (car surface-vr)
		  (cadr surface-vr)
		  (caddr surface-vr)
		  )
	 (while (> (getvar "cmdactive") 0)
	   (command "")
	   )
	 (if (= "SURFACE" (entity:getdxf (entlast) 0))
	     (setq surfaces (ssadd (entlast) surfaces)))))
   
   )
  (entdel ent-last)
  (pop-var)
  (princ)
  )

(defun at-3d:slice-by-route ()
  (@:help '("��һ������������·������"))
  (@:prompt "��ѡ����Ҫ���е�����:")
  (setq surfaces (ssget '((0 . "surface"))))
  
  (@:prompt "��ѡ���������е�·������:")
  (setq route  (car (pickset:to-list (ssget ":S" '((0 . "*line"))))))
  (setq n (getint (@:prompt "������ֶ���:")))
  (setq len-pre (/ (curve:length route) n))
  (setq slicesurfaces (mapcar 'read (ui:select-multi "��ѡ�����淽ʽ"
   				      '("1 ƽ����xy�� " "2 ƽ����yz��" "3 ƽ����zx��" "4 ��ֱ�ڵ�����"))))
  (push-var)
  (setq i 0)
  (repeat
   (1- n)
   (setq pt1 (vlax-curve-getpointatdist (e2o route) (* (setq i (1+ i)) len-pre)))
   (setq surface-xy (list pt1
			  (mapcar '+ pt1 '(100 0 0))
			  (mapcar '+ pt1 '(0 100 0))))
   (setq surface-yz (list pt1
			  (mapcar '+ pt1 '(0 100 0 ))
			  (mapcar '+ pt1 '(0 0 100 ))))
   (setq surface-zx (list pt1
			  (mapcar '+ pt1 '(0 0 100))
			  (mapcar '+ pt1 '(100 0 0))))
   ;;ȡ�����ڵ����ߣ���㵽�������ľ��룬��㴦�����ߣ���㴦�Ĵ��档(vlax-curve-getDistAtPoint curve-obj point)
   (if (and (setq firstdiv (vlax-curve-getfirstderiv (e2o route) (vlax-curve-getDistAtPoint (e2o route) pt1))))
       (setq surface-vr (list pt1
			      (polar pt1 (+ (* 0.5 pi)(atan (cadr firstdiv)(car firstdiv)))  100)
			      (mapcar '+ pt1 '(0 0 100 ))
    			      ))
      (setq surface-vr nil)
      )
   (setq ent-last (entity:make-point '(0 0 0)))
   (setvar "osmode" 0)
   (if (member 1 slicesurfaces)
       (progn
	 (command "slice" surfaces "" "3"
		  (car surface-xy)
		  (cadr surface-xy)
		  (caddr surface-xy)
		  )
	 (while (> (getvar "cmdactive") 0)
	   (command "")
	   )
	 (if (= "SURFACE" (entity:getdxf (entlast) 0))
	     (setq surfaces (ssadd (entlast) surfaces)))))
   (if (member 2 slicesurfaces)
       (progn
	 (command "slice" surfaces "" "3"
		  (car surface-yz)
		  (cadr surface-yz)
		  (caddr surface-yz)
		  )
	 (while (> (getvar "cmdactive") 0)
	   (command "")
	   )
	 (if (= "SURFACE" (entity:getdxf (entlast) 0))
	     (setq surfaces (ssadd (entlast) surfaces)))))
   
   (if (member 3 slicesurfaces)
       (progn
	 (command "slice" surfaces "" "3"
		  (car surface-zx)
		  (cadr surface-zx)
		  (caddr surface-zx)
		  )
	 (while (> (getvar "cmdactive") 0)
	   (command "")
	   )
	 (if (= "SURFACE" (entity:getdxf (entlast) 0))
	     (setq surfaces (ssadd (entlast) surfaces)))))
   (if (member 4 slicesurfaces)
       (progn
	 (command "slice" surfaces "" "3"
		  (car surface-vr)
		  (cadr surface-vr)
		  (caddr surface-vr)
		  )
	 (while (> (getvar "cmdactive") 0)
	   (command "")
	   )
	 (if (= "SURFACE" (entity:getdxf (entlast) 0))
	     (setq surfaces (ssadd (entlast) surfaces)))))
   
   )
  (entdel ent-last)
  (pop-var)
  (princ)
  )

