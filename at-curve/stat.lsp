(defun at-curve:stat (/ curves res classname)
  (@:help "����������ߵĳ��ȡ�")
  (setq curves (pickset:to-list (ssget '((0 . "line,lwpolyline,arc,circle")))))
  (setq classname (ui:select "��ѡ�������Ŀ" '("ͼ��""��ɫ��" "����")))
  (if classname
      (progn
	(setq lst-class '(("ͼ��" . entity:get-layer)
			  ("��ɫ��" . entity:get-color)
			  ("����" . entity:get-linetype)
			  ))
	(setq res (mapcar '(lambda(x)(cons
				      ((eval (cdr (assoc classname lst-class))) x)
				      (vla-get-length (e2o x))))
			  curves))
	(if res
	    (table:make (getpoint (@:speak "�����������:"))
			"���Ȼ��ܱ�"
			(list classname "�ܳ�")
			(mapcar '(lambda(x)
				   (list (car x)(cdr x)))
				(vl-sort (stat:classify res)
					 '(lambda(x y)
					    (> (cdr x)
					       (cdr y))))
				))))))
					      