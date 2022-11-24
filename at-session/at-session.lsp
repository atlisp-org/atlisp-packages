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
   ("��ʷ�Ự" (at-session:history))
   ("����Ự" (at-session:save-current))
   ("�رջỰ" (at-session:close)))
 )

(defun at-session:read (/ sessions)
  (if (findfile (strcat @:*prefix-config* "session"))
      (read (@:get-file-contents (strcat @:*prefix-config* "session"))
	    )))
(defun at-session:write (sessions / *error* fp)
  (defun *error* (msg)
    (if (= 'file (type fp)) (close fp))
    (@:*error* msg)
    nil)
  (setq fp (open (strcat @:*prefix-config* "session") "w"))
  (write-line (vl-prin1-to-string session) fp)
  (close fp)
  t
  )

(defun at-session:open (/ fp session docs)
  (@:help '("���������ĻỰ��"))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (setq docs nil)
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (setq session (car (at-session:read)))
  (if (cddr session)
      (progn
	(foreach doc (cddr session)
		 (if (and (not (member doc docs))
			  (findfile doc))
		     (vla-open *DOCS* doc)))
	(@:log "INFO" "Resume session.")))
  (princ)
  )
(defun at-session:history (/ sessions res)
  (@:help "��ʾ��ʷ�Ự")
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (setq fp (open (strcat @:*prefix-config* "session") "r"))
  (setq sessions (read (read-line fp)))
  (setq res
	(ui:select "��ѡ����ʷ�Ự�����򿪻Ự"
		   (mapcar '(lambda(x)
			      (strcat (car x)
				      " | "
				      (itoa (length (cddr x)))
				      "dwgs"
				      ))
			   sessions)))
  
  )
(defun at-session:save-current (/ sessions docs fp *error*)
  (defun *error* (msg)
    (if (= 'file (type fp)) (close fp))
    (@:*error* msg))
  (@:help '("���浱ǰ�Ự"))
  (setq docs nil)
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (if docs
      (progn
	(setq res (ui:input "������Ự��" '(("�Ự��"))))
	(setq sessions (at-session:read))
	(if (atom (car sessions)) (setq sessions nil))
	(setq session
	      (cons (@:timestamp)
		    (cons (cdr (assoc "�Ự��" res))
			  (reverse docs))))
	(setq fp (open (strcat @:*prefix-config* "session") "w"))
	(write-line (vl-prin1-to-string (cons session sessions)) fp)
	(close fp)
	(@:log "INFO" "Save session."))
    (@:log "INFO" "No DWG file were opened.")
    )
  (princ)
  )
(defun at-session:close (/ fp session docs)
  (@:help '("���沢�رջỰ DWG �ĵ���"))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (setq docs nil)
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (setq session (car (at-session:read)))
  (vlax-for doc *DOCS*
	    (if (and
		 (/= "" (vla-get-fullname doc))
		 (member (vla-get-fullname doc) (cddr session))
		 (/= doc *DOC*)
		 )
		(vla-close doc :vlax-true)
	      ))
  (@:log "INFO" "Resume session.")
  (if (and (/= "" (vla-get-fullname *DOC*))
	   (member (vla-get-fullname doc) (cddr session)))
      (vla-close *DOC* :vlax-true))
  (princ)
  )
  
