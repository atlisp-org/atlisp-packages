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
  (@:help '("����ůͨ˵����"
	    ))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (if (findfile (strcat @::*prefix* "packages/at-hvac/readme-hvac.dwg"))
      (block:insert
       "readme-hvac"
       (strcat @::*prefix* "packages/at-hvac/")
       (getpoint "��������λ��:")
       0 1))
  )
(defun @hvac:draw-plan-example ()
  (@:help '("����ůͨƽ��ͼ������"
	    ))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (if (findfile (strcat @::*prefix* "packages/at-hvac/example-hvac.dwg"))
      (block:insert
       "example-plan-hvac"
       (strcat @::*prefix* "packages/at-hvac/")
       (getpoint "��������λ��:")
       0 1))
  )
