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
     
  
