;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define a first config item  'agan-vport-syn:first for package agan-vport-syn 's configitem first 
;; (@:get-config 'agan-vport-syn:first) 
;; (@:set-config 'agan-vport-syn:first  "New Value")
;; Add menu in @lisp panel
(@:add-menu "���ֹ���" "���ʶ�ͼ" "(agan-vport-syn:load)")

(defun agan-vport-syn:load (/ vers filesize)
  (setq vers (substr (getvar "acadver") 1 2))
  (if (< (atoi vers) 18)
      (princ "CAD �汾���ͣ����ʶ�ͼ����֧�ָ�CAD�汾��")
      (progn
	(setq dllname (strcat "aganvportsyn.dll"))
	(setvar "filedia" 0)
	(setvar "cmdecho" 0)
	(if (findfile (strcat "packages/agan-vport-syn/" dllname))
	    (command "netload" (findfile (strcat "packages/agan-vport-syn/" dllname)))
	    (progn
	      (setq filesize (@:get-filesize-from-web (strcat "agan-vport-syn/" dllname)))
	      (@:down-pkg-file (@:uri) (strcat "agan-vport-syn/" dllname) "stable")
	      (while (< (vl-file-size (strcat @:*prefix* "packages/agan-vport-syn/" dllname))
			filesize)
		(sleep 5))
	      (if (= (vl-file-size (strcat @:*prefix* "packages/agan-vport-syn/" dllname))
		     filesize)
		  (command "netload" (findfile (strcat "packages/agan-vport-syn/" dllname)))
		  ))
	    )
	(setvar "filedia" 1)
	(setvar "cmdecho" 1)))
  (vla-sendcommand *DOC* "agdt\n")
  (princ)
  )
;; (agan-vport-syn:load)
