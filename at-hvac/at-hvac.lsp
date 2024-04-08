;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-hvac:first ���� Ӧ�ð� at-hvac �� ��һ�������� first 
;; (@:define-config 'at-hvac:first "���������� at-hvac:first ��ֵ" "������������;˵����")
;; (@:get-config 'at-hvac:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-hvac:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menus
 '("@ůͨ"
   ("����˵��" (@hvac:draw-readme))
   ("ƽ��ͼ����" (@hvac:draw-plan-example))
   ))
(defun @hvac:draw-readme ()
  (@:help '("����ůͨ˵����" ))
  (if (findfile (strcat @::*prefix* "packages/at-hvac/readme-hvac.dwg"))
      (progn
	(setq readme-hvac
	      (block:insert
	       "readme-hvac"
	       (strcat @::*prefix* "packages/at-hvac/")
	       (getpoint "��������λ��:")
	       0 1))
	(if (string-equal "insert" (entity:getdxf readme-hvac 0))
	    (progn
	      (vla-explode (e2o readme-hvac))
	      (vla-delete (e2o readme-hvac))))))
	
  )
(defun @hvac:draw-plan-example ()
  (@:help '("����ůͨƽ��ͼ������"
	    ))
  (if (findfile (strcat @::*prefix* "packages/at-hvac/example-hvac.dwg"))
      (progn
	(setq example-plan-hvac
	      (block:insert
	       "example-plan-hvac"
	       (strcat @::*prefix* "packages/at-hvac/")
	       (getpoint "��������λ��:")
	       0 1))
	)))
