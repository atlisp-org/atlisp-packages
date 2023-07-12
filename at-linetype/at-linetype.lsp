;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-linetype:first ���� Ӧ�ð� at-linetype �� ��һ�������� first 
;; (@:define-config 'at-linetype:first "���������� at-linetype:first ��ֵ" "������������;˵����")
;; (@:get-config 'at-linetype:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-linetype:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "@����" "��������" '(at-linetype:reload))
(@:add-menu "@����" "�༭����" '(at-linetype:edit))
(@:add-menu "@����" "�༭��" '(at-linetype:edit-shp))
(defun at-linetype:reload ()
  (@:help '("���¼���@lisp����"
	    ))
  (setvar "filedia" 0)
  (at-linetype:load-shx)
  (command "-linetype" "l" "*" (strcat (@:package-path "at-linetype") "@lisp.lin")
	   )
  (while (> (getvar "cmdactive") 0)
    (command ""))
  (setvar "filedia" 1)
  (princ)
  )
(defun at-linetype:compile-shp ()
  (@:help '("���벢��������ʹ�õ����ļ�"))
  (@:cmd "compile" (strcat (@:package-path "at-linetype")"@lisp.shp"))
  (@:cmd "load"  (strcat (@:package-path "at-linetype")"@lisp.shx")))
(defun at-linetype:load-shx ()
  (if (null (findfile "@lisp.shx"))
      (progn
	(if (null (findfile (strcat (@:package-path "at-linetype")"@lisp.shx")))
	    (@:cmd "compile" (strcat (@:package-path "at-linetype")"@lisp.shp")))
	(vl-file-copy (strcat (@:package-path "at-linetype")"@lisp.shx")
		      (strcat @:*prefix* "@lisp.shx"))
	))
  (@:cmd "load" "@lisp.shx" ""))
(defun at-linetype:edit()
  (@:help '("�༭ @lisp �����ļ�"))
  (@:cmd @:editor  (strcat (@:package-path "at-linetype")"@lisp.lin")))
(defun at-linetype:edit-shp()
  (@:help '("�༭ @lisp ������ص����ļ�"))
  (@:cmd @:editor  (strcat (@:package-path "at-linetype")"@lisp.shp")))
