;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define a first config item  'road-cross:first for package road-cross 's configitem first 

(@:define-config 'road-cross:first "I'm th default value for road-cross:first" "This Item 's Explain.")
;; (@:get-config 'road-cross:first) 
;; (@:set-config 'road-cross:first  "New Value")
;; Add menu in @lisp panel
(@:add-menu "ʮ��·��" "���Ƶ�·1" "(road-cross:rd)" )
(@:add-menu "ʮ��·��" "���Ƶ�·2" "(road-cross:srd)" )
(@:add-menu "ʮ��·��" "���߲�·" "(road-cross:sld)" )
(@:add-menu "ʮ��·��" "�ݲ��趨" "(road-cross:std)" )
(@:add-menu "ʮ��·��" "�е�·��" "(road-cross:prd)" )
(@:add-menu "ʮ��·��" "����" "(road-cross:help)" )

(defun road-cross:hello ()
  (@:help (strcat "The content can show in user interface .\n"
  	  		  ))
  (alert (strcat "ʮ��·�������� 's first function.\n"
		 "Created a config item road-cross:first .\n"
		 "THe config ietm th family is this item: " (@:get-config 'road-cross:first)
		 ))
  (princ)
  )
(@:define-hotkey  "rd" "(road-cross:rd)" )
(@:define-hotkey "srd" "(road-cross:srd)" )
(@:define-hotkey "sld" "(road-cross:sld)" )
(@:define-hotkey "std" "(road-cross:std)" )
(@:define-hotkey "prd" "(road-cross:prd)" )
