;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(@:add-menu "�ṹ" "�͸ֽ�������" "(xgjmtxcx:open)" )

(defun xgjmtxcx:open ( / app )
  ;; ��ִ���ļ�·��
  (setq app "bin/xgjmtxcxgj_v1.0.exe")
  (if (null (findfile app))
      ;; ����ѹ����
      (@:down-file "bin/xgjmtxcxgj_v1.0.exe"))
  ;;�����ⲿ��ִ�г���
  (if (findfile app)
      (progn
	(setvar "cmdecho" 0)
	(command "start-bg" (strcat  @:*prefix* app ))
	(setvar "cmdecho" 1)))
  (princ)
  )
