(setq at-nlp:*verb*
      (mapcar
       '(lambda(x)
	  (cons (car x) (cons (cdr x)
			      'verb)))
      '(("����" . "entity:make-")
	("����" . "entity:make-")
	("ѡ��" . "ssget")
	("ѡ��" . "ssget"))))
(setq at-nlp:*entity*
       (mapcar
	'(lambda(x)
	   (cons (car x) (cons (cdr x) 
			       'entity)))
      '(("Բ��" . "arc")
	("Բ" . "circle")
	("ֱ��" . "line")
	("�߶�" . "line")
	("�����" . "lwpl")
	("����" . "rectange")
	("������" . "rectange")
	)))
(setq at-nlp:*attribute*
       (mapcar
	'(lambda(x)
	   (cons (car x) (cons (cdr x) 
			       'attribute)))
      '(("�뾶" . "rad")
	("Բ��" . "cen")
	("����" . "cen")
	("��" . "long")
	("��" . "width")
	)))
(setq at-nlp:*bool*
             (mapcar
       '(lambda(x)
	  (cons (car x) (cons (cdr x)
			      'compare)))
      '(("����" . "equal")
	("=" . "=")
	("Ϊ" . "=")
	)))
(setq at-nlp:*prep*
      (mapcar
       '(lambda(x)
	  (cons (car x) (cons (cdr x) 
			      'prep)))
      '(("��" . "prep")
	("��" . "prep")
	)))
