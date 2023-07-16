(defun at-curve:stat (/ curves res classname dxfno)
  (@:help "����������ߵĳ��ȡ�")
  (setq curves (pickset:to-list (ssget '((0 . "*line,lwpolyline,arc,circle")))))
  (setq classname (ui:select "��ѡ�������Ŀ" '("ͼ��""��ɫ��" "����" "���߱���" "ָ������")))
  (if (= classname "ָ������")
      (setq dxfno (cdr (assoc "�����" (ui:input "������Ҫͳ�Ƶ� dxf �����" '(("�����" 8 "Ҫ���з���ͳ�Ƶ������")))))))
  (print dxfno)
  (if classname
      (progn
	(setq lst-class (list '("ͼ��" . entity:get-layer)
			  '("��ɫ��" . entity:get-color)
			  '("����" . entity:get-linetype)
			  '("���߱���" . (lambda(x)(entity:getdxf x 40)))
			  (cons "ָ������" '(lambda(x)(entity:getdxf x dxfno)))
			  ))
	(setq res (mapcar '(lambda(x)(cons
				      ((eval (cdr (assoc classname lst-class))) x)
				      (curve:length x)))
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
					      
