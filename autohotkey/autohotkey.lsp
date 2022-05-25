;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define a first config item  'autohotkey:first for package autohotkey 's configitem first 
(@:add-menu "�ⲿ����" "AutoHotKey" "(autohotkey:open)" )

(defun autohotkey:open (/ app )
  ;; ��ִ���ļ�·��
  (setq app "bin\\AutoHotKey\\AutoHotkey.exe")
  (if (null (findfile app))
      ;; ����ѹ����
      (@:down-and-unzip "archives/AutoHotKey.zip" "bin"))
  ;;�����ⲿ��ִ�г���
  (if (findfile app)
      (progn
	(setvar "cmdecho" 0)
	(command "start-bg" (strcat  @:*prefix* app ))
	(setvar "cmdecho" 1)))
  (princ)
  )
