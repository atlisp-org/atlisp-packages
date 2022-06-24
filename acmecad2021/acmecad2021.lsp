;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file was created by @lisp DEV-tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define a first config item  'kml2dxf:first for package kml2dxf 's configitem first 
(@:add-menu "�ⲿ����" "acmecad2021" "(acmecad2021:open)" )

(defun acmecad2021:open (/ vm )
  (setq vm "bin\\AcmeCAD2021.exe")
  (if (null (findfile vm))
      (@:down-and-unzip "archives/AcmeCAD2021.zip" "bin"))
  
  (if (findfile vm)
      (command "start-bg" (strcat  @:*prefix* vm )))
  (princ)
  )
