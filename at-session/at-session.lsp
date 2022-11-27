;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-session:first ���� Ӧ�ð� at-session �� ��һ�������� first 
;; (@:get-config 'at-session:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-session:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵�

(@:add-menus
 '("�Ự����"
   ("�ϰ�" (at-session:goto-work))
   ("�ָ��Ự" (at-session:open))
   ("��ʷ�Ự" (at-session:history))
   ("����Ự" (at-session:save-current))
   ("�رջỰ" (at-session:close))
   ("�°�" (at-session:knock-off))
   ("--" "--")
   ("������dwg" (at-session:save-and-close-all))
   )
 )
(defun align-str (n str / flag)
  (if (null str)(setq str ""))
  (setq flag nil)
  (while (< (string:bytelength str) n)
    (if flag
	  (setq str (strcat " " str))
      (setq str (strcat str " ")))
    (setq flag (not flag)))
  str)
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
  (write-line (vl-prin1-to-string sessions) fp)
  (close fp)
  t
  )

(defun at-session:goto-work (/ fp session docs)
  (@:help '("��������������Ϊ ���°࡯ �ĻỰ��"))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (setq docs nil)
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (setq sessions (at-session:read))
  (while (and sessions
	      (/= "�°�" (cadr sessions)))
    (setq sessions (cdr sessions)))
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
  ;;(setq fp (open (strcat @:*prefix-config* "session") "r"))
  (setq sessions (at-session:read))
  (setq n (apply 'max (mapcar '(lambda(x)(string:bytelength (cadr x))) sessions)))
  (setq res
	(ui:select "��ѡ����ʷ�Ự�����򿪻Ự"
		   (mapcar '(lambda(x)
			      (strcat (car x)
				      " | "
				      (align-str n (cadr x))
				      " | "
				      (itoa (length (cddr x)))
				      "dwgs"
				      ))
			   sessions)))
  (if res
      (progn
	(setq docs nil)
	(vlax-for doc *DOCS*
		  (if (/= "" (vla-get-fullname doc))
		      (setq docs (cons (vla-get-fullname doc) docs))))
	(setq session (assoc (vl-string-trim " " (car (string:to-list res "|"))) sessions))
	(if (cddr session)
	    (progn
	      (foreach doc (cddr session)
		       (if (and (not (member doc docs))
				(findfile doc))
			   (vla-open *DOCS* doc)))
	      (@:log "INFO" "Resume session.")))))
  (princ)
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
	      (cons (rtos (getvar "cdate") 2 6)
		    (cons (cdr (assoc "�Ự��" res))
			  (reverse docs))))
	(at-session:write (cons session sessions))
	(close fp)
	(@:log "INFO" "Save session."))
    (@:log "INFO" "No DWG file were opened.")
    )
  (princ)
  )
(defun at-session:close (/ fp session docs)
  (@:help '("�ر����һ�λỰ��¼�� DWG �ĵ���"))
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
		 (/= (vla-get-fullname doc) (vla-get-fullname *DOC*))
		 )
		(vla-close doc :vlax-true)
	      ))
  (@:log "INFO" "Resume session.")
  (if (and (/= "" (vla-get-fullname *DOC*))
	   (member (vla-get-fullname *DOC*) (cddr session)))
      (progn
	(vla-save *DOC*)(vla-sendcommand *DOC* "close ")))
  (princ)
  )

(defun at-session:save-and-close-all (/ docs)
  (@:help '("���沢�ر������Ѵ򿪵� DWG �ĵ���"))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (setq docs nil)
  (vlax-for doc *DOCS*
	    (if (/= "" (vla-get-fullname doc))
		(setq docs (cons (vla-get-fullname doc) docs))))
  (vlax-for doc *DOCS*
	    (if (and (/= "" (vla-get-fullname doc))
		     (/= (vla-get-fullname *DOC*)(vla-get-fullname doc))
		     )
		(vla-close doc :vlax-true)
	      ))
  (if (and (/= "" (vla-get-fullname *DOC*))
	   )
      (progn
	(vla-save *DOC*)(vla-sendcommand *DOC* "close ")))
  (princ)
  )

(defun at-session:knock-off (/ sessions docs fp *error*)
  (@:help "�°�ǰ��¼��ǰ�򿪵����� dwgͼ�������ر�����dwgͼ����")
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
	(setq sessions
	      (vl-remove-if
	       '(lambda(x)(equal "�°�" (cadr x)))
	       (at-session:read)))
	
	(if (atom (car sessions)) (setq sessions nil))
	(setq session
	      (cons (rtos (getvar "cdate") 2 6)
		    (cons "�°�"
			  (reverse docs))))
	(at-session:write (cons session sessions))
	(@:log "INFO" "Save session."))
    (@:log "INFO" "No DWG file were opened.")
    )
  (at-session:save-and-close-all)
  (vla-quit *ACAD*)
  (princ)
  )
