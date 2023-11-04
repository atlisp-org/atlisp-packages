(setq at-nlp:*tangent*
      (mapcar
       '(lambda(x)
	  (cons (car x) (cons (cdr x) 
			      'entity)))
       '(
	 ("������ע" . "TCH_DIMENSION*")
	 ("�Ŵ�" . "TCH_OPENING")
	 ("ǽ��" . "TCH_WALL")
	 ("ǽ" . "TCH_WALL")
	 ("��" . "TCH_COLUMN")
	 ("¥��"  . "TCH_MULTISTAIR")
	 ("����" . "TCH_SPACE")
	 ("���" . "TCH_ELEVATION")
	 )))
(setq at-nlp:*tangent-attribute*
      (mapcar
       '(lambda(x)
	  (cons (car x) (cons (cdr x) 
			      'attribute)))
       '(
	 ("ǽ��" . 39)
	 ("����" . 149)
	 ("����" . 47)
	 )))
