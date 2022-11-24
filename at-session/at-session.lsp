;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-session:first ���� Ӧ�ð� at-session �� ��һ�������� first 
;; (@:get-config 'at-session:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-session:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵�

(@:add-menus
 '("�Ự����"
   ("�ָ��Ự" (at-session:open))
   ("����Ự" (at-session:save-current))
   ("�رջỰ" (at-session:close)))
 )
(defun at-session:open (/ fp session docs)
  (@:help '("����ʷ�Ự��"))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (setq docs nil)
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (setq fp (open (strcat @:*prefix-config* "session") "r"))
  (setq session (read (read-line fp)))
  (close fp)
  (if session
      (foreach doc (cddr session)
	       (if (and (not (member doc docs))
			(findfile doc))
		   (vla-open *DOCS* doc))))
  (@:log "INFO" "Resume session.")
  (princ)
  )
(defun at-session:save-current (/ docs fp *error*)
  (defun *error* (msg)
    (if (= 'file (type fp)) (close fp))
    (@:*error* msg))
  (@:help '("���浱ǰ�Ự"))
  (setq docs nil)
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (setq res (ui:input "������Ự��" '(("�Ự��"))))
  (setq session
	(cons (@:timestamp)
	      (cons (cdr (assoc "�Ự��" res))
		    (reverse docs))))
  (setq fp (open (strcat @:*prefix-config* "session") "w"))
  (write-line (vl-prin1-to-string session) fp)
  (close fp)
  (@:log "INFO" "Save session.")
  (princ)
  )
(defun at-session:close (/ fp session docs)
  (@:help '("���沢�رջỰ DWG �ĵ���"))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (setq docs nil)
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (setq fp (open (strcat @:*prefix-config* "session") "r"))
  (setq session (read (read-line fp)))
  (close fp)
  (vlax-for doc *DOCS*
	    (if (and
		 (/= "" (vla-get-fullname doc))
		 (member (vla-get-fullname doc) (cddr session))
		 (/= doc *DOC*)
		 )
		(vla-close doc :vlax-true)
	      ))
  (@:log "INFO" "Resume session.")
  (if (/= "" (vla-get-fullname *DOC*))
      (vla-close *DOC* :vlax-true))
  (princ)
  )
  
