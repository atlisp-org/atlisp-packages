(@:add-menus
 '("@����ˮ"
   ("����ˮ˵��" (@wsad:draw-readme))
   ("����ˮͼ��" (@wsad:draw-legend-example))
   ("����ˮƽ������" (@wsad:draw-plan-example))
   ("����ˮϵͳ����" (@wsad:draw-system-example))
   ("����ˮ��ͼ����" (@wsad:draw-detail-example))
   ))
(defun @wsad:draw-readme ()
  (@:help '("�������ˮ˵����" ))
  (if (findfile (strcat @::*prefix* "packages/at-wsad/readme-wsad.dwg"))
      (progn
	(setq readme-wsad
	      (block:insert
	       "readme-wsad"
	       (strcat @::*prefix* "packages/at-wsad/")
	       (getpoint "��������λ��:")
	       0 1))
	(if (string-equal "insert" (entity:getdxf readme-wsad 0))
	    (progn
	      (vla-explode (e2o readme-wsad))
	      (vla-delete (e2o readme-wsad))))))
	
  )
(defun @wsad:draw-plan-example ()
  (@:help '("�������ˮƽ��ͼ������"
	    ))
  (if (findfile (strcat @::*prefix* "packages/at-wsad/example-wsad-plan.dwg"))
      (progn
	(setq example-plan-wsad
	      (block:insert
	       "example-wsad-plan"
	       (strcat @::*prefix* "packages/at-wsad/")
	       (getpoint "��������λ��:")
	       0 1))
	)))
(defun @wsad:draw-system-example ()
  (@:help '("�������ˮϵͳͼ������"
	    ))
  (if (findfile (strcat @::*prefix* "packages/at-wsad/example-wsad-system.dwg"))
      (progn
	(block:insert
	 "example-wsad-system"
	 (strcat @::*prefix* "packages/at-wsad/")
	 (getpoint "��������λ��:")
	 0 1))
      ))
(defun @wsad:draw-legend-example ()
  (@:help '("�������ˮͼ��������"
	    ))
  (if (findfile (strcat @::*prefix* "packages/at-wsad/example-wsad-legend.dwg"))
      (progn
	(block:insert
	 "example-wsad-legend"
	 (strcat @::*prefix* "packages/at-wsad/")
	 (getpoint "��������λ��:")
	 0 1))
      ))
(defun @wsad:draw-detail-example ()
  (@:help '("�������ˮͼ��������"
	    ))
  (if (findfile (strcat @::*prefix* "packages/at-wsad/example-wsad-detail.dwg"))
      (progn
	(block:insert
	 "example-wsad-detail"
	 (strcat @::*prefix* "packages/at-wsad/")
	 (getpoint "��������λ��:")
	 0 1))
      ))
