;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define a first config item  'alt-run:first for package alt-run 's configitem first 
;; (@:get-config 'alt-run:first) 
;; (@:set-config 'alt-run:first  "New Value")
;; Add menu in @lisp panel

(@:add-menu "�ⲿ����" "ALTRun" "(alt-run:open)" )
(defpackage :alt-run 
  (:use :cl)
  (:export :open)
  )
(defun alt-run:open ( / app )
  ;; ��ִ���ļ�·��
  (setq app "bin\\ALTRun\\ALTRun.exe")
  (if (null (findfile app))
      ;; ����ѹ����
      (@:down-and-unzip "archives/ALTRun.zip" "bin"))
  ;;�����ⲿ��ִ�г���
  (if (findfile app)
      (progn
	(setvar "cmdecho" 0)
	(command "start-bg" (strcat  @:*prefix* app ))
	(setvar "cmdecho" 1)))
  (princ)
  )
