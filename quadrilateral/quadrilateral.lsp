;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define a first config item  'quadrilateral:first for package quadrilateral 's configitem first 
;; (@:define-config 'quadrilateral:first "I'm th default value for quadrilateral:first" "This Item 's Explain.")
;; (@:get-config 'quadrilateral:first) 
;; (@:set-config 'quadrilateral:first  "New Value")
;; Add menu in @lisp panel
(@:define-config 'quadrilateral:scale 1  "��ͼ����")
(@:define-config 'quadrilateral:evalcode "" "ִ����")
(@:add-menu "�ı��α�ע" "$�ı��α�ע" "(quadrilateral:dim)" )

(defun quadrilateral:dim (/ eval-code)
  (@:help (strcat "��ע��4��ֱ�߶���ɵ��ı��εı߳��ͶԽǳ���\n"
		  "��������������������ϵ����ʾ�����ֻ�ܱ�ע6���ı��Ρ�\n"
		  "��ʾ��ִ����Ϊ DEMO ��"
  	  	  ))
  (if (or (= "" (@:get-config 'quadrilateral:evalcode))
	  (= "DEMO" (@:get-config 'quadrilateral:evalcode)))
      (if (= (setq eval-code (getstring "������ִ����, ��ʾ������<DEMO>:"))
	     (@:get-eval-code  "quadrilateral"))
	  (@:set-config 'quadrilateral:evalcode eval-code)
	  (if (= "DEMO" eval-code)
	      (@:set-config 'quadrilateral:evalcode "DEMO")
	      (progn
		(princ "ִ�������! ")
		(@:set-config 'quadrilateral:evalcode ""))
	      ))
      )
  (if (/= "" (@:get-config 'quadrilateral:evalcode))
      (@:run-from-web "quadrilateral" quadrilateral:dim-backend))
  (princ)
  )
