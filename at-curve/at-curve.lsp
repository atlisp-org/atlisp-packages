;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-curve:first ���� Ӧ�ð� at-curve �� ��һ�������� first 
;;(@:define-config 'at-curve:first "���������� at-curve:first ��ֵ" "������������;˵����")
;; (@:get-config 'at-curve:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-curve:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "����" "˫�߻���" "(at-curve:join)" )
(defun at-curve:join (/ l1 l2 pts1 pts2)
  (@:help "��������������ߣ��ϲ���һ��")
  (setq l1 (car (entsel (@:speak "��ѡ���һ����:"))))
  (setq l2 (car (entsel (@:speak "��ѡ��ڶ�����:"))))
  (setq pts1 (curve:pline-3dpoints l1))
  (setq pts2 (curve:pline-3dpoints l2))
  (if (< (distance (car pts1) (car pts2))
	 (distance (last pts1) (car pts2)))
      (setq pts1 (reverse pts1)))
  (if (> (distance (last pts1) (car pts2))
	 (distance (last pts1) (last pts2)))
      (setq pts2 (reverse pts2)))
  (entdel l1)(entdel l2)
  (entity:make-lwpline-bold
   (append pts1 pts2)
   nil
   nil
   0 0))
  
