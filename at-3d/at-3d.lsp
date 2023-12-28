;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-3d:first ���� Ӧ�ð� at-3d �� ��һ�������� first 
(@:define-config 'at-3d:first "���������� at-3d:first ��ֵ" "������������;˵����")
;; (@:get-config 'at-3d:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-3d:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "3D���" "�������" "(at-3d:slice-by-pts)" )

(defun at-3d:slice-by-pts ()
  (@:help '("��һ�������ù�������ƽ������"))
  (@:prompt "��ѡ������")
  (setq surfaces (ssget '((0 . "surface"))))
  
  (@:prompt "��ѡ���������ϵĵ�")
  (setq pts (pickset:to-list(ssget '((0 . "point")))))
  (setq slicesurface (ui:select-multi "��ѡ�����淽ʽ"
				      '("1 ƽ����xy�� " "2 ƽ����yz��" "3 ƽ����zx��" "4 ��ֱ�ڵ�����")))
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
  (if (and (setq route (ssget pt1))
	   (setq firstdiv (vlax-curve-getfirstderiv (e2o route) (vlax-curve-getDistAtPoint (e2o route) pt1))))
      (setq surface-vr (list pt1

			     ))
    (setq surface-vr nil)
    )
			 
  (foreach
   pt% pts
   (push-var)
   (setvar "osmode" 0)
   (command "slice" surfaces "" "3"
	    (setq pt1 (entity:getdxf pt% 10))
	    (mapcar '+ pt1 '(0 100.0 0))
	    (mapcar '+ pt1 '(0 0 100.0))
	    )
   (while (> (getvar "cmdactive") 0)
     (command "")
     )
   (pop-var)
   (if (= "SURFACE" (entity:getdxf (entlast) 0))
       (setq surfaces (ssadd (entlast) surfaces)))
   ))

   ;;(foreach
   ;; surface% surfaces
   ;; (setq pt1 (entity:getdxf pt% 10))
    ;; (setq new-surface
    ;; 	  (vla-slicesolid
    ;; 	   surface%
    ;; 	   (point:to-ax pt1)
    ;; 	   (point:to-ax (mapcar '+ pt1 '(0 100.0 0)))
    ;; 	   (point:to-ax (mapcar '+ pt1 '(0 0 100.0)))
    ;; 	   :vlax-true))
   ;; (setq surfaces (cons new-surface surfaces)))))
     
  
