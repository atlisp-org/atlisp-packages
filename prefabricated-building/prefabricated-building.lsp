;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'prefabricated-building:first ���� Ӧ�ð� prefabricated-building �� ��һ�������� first 
;; (@:get-config 'prefabricated-building:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'prefabricated-building:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(defun prefabricated-building:hello ()
  (@:help (strcat "�������������������������ܿ�ʼʱ�����û����й�����ʾ��\n"
		  "����ôʹ�ã�ע������ȡ�\n���û�������ѧϰģʽʱ�����������л򵯴�������ʾ��\n"
		  ))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (alert (strcat "װ�佨�� �ĵ�һ������.\n"
		 "������һ�������� prefabricated-building:first .\n"
		 "����������ֵΪ: " (@:get-config 'prefabricated-building:first)
		 ))
  (princ)
  )
