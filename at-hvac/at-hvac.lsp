(@:add-menus
 '("@暖通"
   ("插入说明" (@hvac:draw-readme))
   ("平面图样例" (@hvac:draw-plan-example))
   ))
(defun @hvac:draw-readme ()
  (@:help '("插入暖通说明。" ))
  (@:load-module 'pkgman)
  (if @::require-down
      (@::require-down "at-hvac/readme-hvac.dwg"))
    
  (if (findfile (strcat @::*prefix* "packages/at-hvac/readme-hvac.dwg"))
      (progn
	(setq readme-hvac
	      (block:insert
	       "readme-hvac"
	       (strcat @::*prefix* "packages/at-hvac/")
	       '(0 0 0)
	       0 1))
	(if (ui:dyndraw readme-hvac '(0 0 0))
	    (if (string-equal "insert" (entity:getdxf readme-hvac 0))
		(progn
		  (vla-explode (e2o readme-hvac))
		  (vla-delete (e2o readme-hvac))))))
      ))
(defun @hvac:draw-plan-example ()
  (@:help '("插入暖通平面图样例。"
	    ))
  (if (findfile (strcat @::*prefix* "packages/at-hvac/example-hvac.dwg"))
      (progn
	(setq example-plan-hvac
	      (block:insert
	       "example-plan-hvac"
	       (strcat @::*prefix* "packages/at-hvac/")
	       '(0 0 0)
	       0 1))
	(ui:dyndraw readme-hvac '(0 0 0))
	)))
