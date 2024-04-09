(@:add-menus
 '("@����"
   ("����˵��" (@elec:draw-readme))
   ("��������" (@elec:draw-plan-example))
   ))
(defun @elec:draw-readme ()
  (@:help '("����ůͨ˵����" ))
  (if (findfile (strcat @::*prefix* "packages/at-elec/readme-elec.dwg"))
      (progn
	(setq readme-elec
	      (block:insert
	       "readme-elec"
	       (strcat @::*prefix* "packages/at-elec/")
	       (getpoint "��������λ��:")
	       0 1))
	(if (string-equal "insert" (entity:getdxf readme-elec 0))
	    (progn
	      (vla-explode (e2o readme-elec))
	      (vla-delete (e2o readme-elec))))))
	
  )
(defun @elec:draw-plan-example ()
  (@:help '("����ůͨƽ��ͼ������"
	    ))
  (if (findfile (strcat @::*prefix* "packages/at-elec/example-elec.dwg"))
      (progn
	(setq example-plan-elec
	      (block:insert
	       "example-plan-elec"
	       (strcat @::*prefix* "packages/at-elec/")
	       (getpoint "��������λ��:")
	       0 1))
	)))
