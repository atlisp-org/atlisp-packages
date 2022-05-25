;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(@:define-config 'block-update:path "D:\\block" "Ҫ���¿��Ŀ¼.")
(@:define-config 'block-update:number 5 "Ҫ���¿������.")
(@:add-menu "�����" "���¿�" "(block-update:update)" )
(defun block-update:update (/ blks n%)
  (alert "Ҫ���µ�ͼ���ļ�������CAD�д��ڴ�״̬����ѡ����رպ�ʹ�á�")
  (setq blks
	(vl-directory-files (@:get-config 'block-update:path) "*.dwg"))
  (vl-sort blks '(lambda (x y)
		  (> (datetime:mktime(vl-file-systime (strcat  (@:get-config 'block-update:path) "\\" x)))
		   (datetime:mktime(vl-file-systime (strcat  (@:get-config 'block-update:path) "\\" y))))))
  (setvar "attreq" 0)
  (setq n% 0)
  (while (or (< n%  (@:get-config 'block-update:number))
	     (< n%  (length blks)))
    (command "-insert" (strcat (vl-filename-base (nth n% blks))"="(@:get-config 'block-update:path) "\\"
			       (nth n% blks)) '(0 0 0) "1" "1" 0)
    (entdel (entlast))
    (setq n% (1+ n%)))
  (setvar "attreq" 1)
  (princ)
  )
(@:add-menu "�����" "���ø��¿�" "(block-update:setup)" )
(defun block-update:setup ()
  (@:set-config 'block-update:path
		(system:get-folder "��ѡ��Ҫ���µĿ��ļ���Ŀ¼��"))
  (@:set-config 'block-update:number
		(getint (strcat "��ѡ��Ҫ���µĿ������ <"(itoa (@:get-config 'block-update:number))">��")))
  (alert (strcat "Ŀ¼:"(@:get-config 'block-update:path)"\n����:" (itoa(@:get-config 'block-update:number))))
 
  (princ)
  )
(defun c:rb () (block-update:update))
(defun c:rbb () (block-update:setup))
