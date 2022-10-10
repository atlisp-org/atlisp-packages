;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(@:add-menu "����" "˫�߻���" "(at-curve:join)" )
(defun at-curve:join (/ l1 l2 pts1 pts2)
  (@:help "ѡ�������ߣ�������˵����ӳ�һ��.")
  (setq curves (pickset:to-list(ssget '((0 . "*line")))))
  (setq pts1 (curve:pline-3dpoints (car curves)))
  (setq pts2 (curve:pline-3dpoints (cadr curves)))
  (if (< (distance (car pts1) (car pts2))
	 (distance (last pts1) (car pts2)))
      (setq pts1 (reverse pts1)))
  (if (> (distance (last pts1) (car pts2))
	 (distance (last pts1) (last pts2)))
      (setq pts2 (reverse pts2)))
  (entdel (car curves))(entdel (cadr curves))
  (entity:make-lwpline-bold
   (append pts1 pts2)
   nil
   nil
   0 0))
  
