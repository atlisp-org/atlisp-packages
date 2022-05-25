;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-stat:first ���� Ӧ�ð� at-stat �� ��һ�������� first 
;;(@:define-config 'at-stat:first "���������� at-stat:first ��ֵ" "������������;˵����")
;; (@:get-config 'at-stat:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-stat:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "ͳ�Ʊ��" "Բ�İ뾶" "(at-stat:stat-circle)" )
(@:add-menu "ͳ�Ʊ��" "����ߵ�����" "(at-stat:stat-lwpl)" )
;;(@:add-menu "ͳ�Ʊ��" "����" "(list-rec-wxh:stat)" )

(defun at-stat:hello ()
  (@:help (strcat "�������������������������ܿ�ʼʱ�����û����й�����ʾ��\n"
		  "����ôʹ�ã�ע������ȡ�\n���û�������ѧϰģʽʱ�����������л򵯴�������ʾ��\n"
		  ))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (alert (strcat "ͳ�Ʊ�� �ĵ�һ������.\n"
		 "������һ�������� at-stat:first .\n"
		 "����������ֵΪ: " (@:get-config 'at-stat:first)
		 ))
  (princ)
  )
(defun at-stat:stat-circle (/ grp-by-y grp% flag)
  ;;һ����������y
  (setq circles
	(vl-sort (pickset:to-list (ssget '((0 . "circle"))))
		 '(lambda (x y)
		    (<= (cadr (entity:getdxf x 10))
		       (cadr (entity:getdxf y 10))))))
  ;;����
  (setq grp-by-y '())
  (setq grp% (cons (car circles) nil))
  (setq flag T)
  (foreach ent% (cdr circles)
	   (if (equal (cadr (entity:getdxf (car grp%) 10))
		      (cadr (entity:getdxf ent% 10))
		      0.001)
	       (setq grp% (cons ent% grp%))
	     (progn
	       (setq grp-by-y (cons
			       (vl-sort grp%
					'(lambda (e1 e2)
					   (if flag
					       (> (car (entity:getdxf e1 10))
						  (car (entity:getdxf e2 10)))
					     (< (car (entity:getdxf e1 10))
						(car (entity:getdxf e2 10))))))
			       grp-by-y))
	       (setq flag (not flag))
	       (setq grp% (cons ent% nil)))))
  (if grp%
      (setq grp-by-y (cons
		      (vl-sort grp%
			       '(lambda (e1 e2)
				  (if flag
				      (> (car (entity:getdxf e1 10))
					 (car (entity:getdxf e2 10)))
				    (< (car (entity:getdxf e1 10))
				       (car (entity:getdxf e2 10))))))
		      grp-by-y)))
  (setq grp-by-y (reverse grp-by-y))
  (setq n 0)
  (foreach grp% grp-by-y
	   (foreach ent% grp%
		    (entity:make-text
		     (itoa (setq n (1+ n)))
		     (entity:getdxf ent% 10)
		     (* 1.5 (entity:getdxf ent% 40))
		     0 0.8 0 "MM")))
  ;; �뾶������
  (setq grp-by-y (apply 'append grp-by-y))
  (table:make (getpoint ) "ͳ��" '("No." "R" "X" "Y")
	      (mapcar '(lambda (x) (list
				    (1+ (- (length grp-by-y)
					   (length (member x grp-by-y))))
				    (entity:getdxf x 40)
				    (car (entity:getdxf x 10))
				    (cadr (entity:getdxf x 10))))
		      grp-by-y))
  )
(defun at-stat:stat-lwpl ()
  (setq pl (car (entsel "��ѡ��һ������ߣ�")));;ѡ�����
  (setq pts (curve:pline-3dpoints pl));;ȡ��
  (setq res '())
  (setq pre-pt (car pts))
  (setq i 100)
  (foreach pt pts
	   (entity:make-text
	    (strcat "J"(itoa (setq i (1+ i)))) pt 300 0 0.8 0 "LB") ;;����
	   (setq res
		 (cons (list
			(strcat "J" (itoa i))
			(car pt)
			(cadr pt)
			(distance pt pre-pt))
		       res))
	   (setq pre-pt pt))
  (setq res (reverse res))
  (table:make (getpoint "��������λ�õ㣺") "���" '("NO" "X" "Y" "L") res)
  )
  
(defun at-stat:get-wxh (ent / pts result-pts tmp-pts angle% area% i%)
  "��ȡ��͸ߵ��б�"
  (setq pts (@:get-lwpoints ent))
  ;; ����任ֱ�������С
  (setq i% 0)
  (setq tmp-pts pts)
  (setq result-pts pts)
  (setq area% (* (- (apply 'max (mapcar 'car pts))
		    (apply 'min (mapcar 'car pts))
		    )
		 (- (apply 'max (mapcar 'cadr pts))
		    (apply 'min (mapcar 'cadr pts))
		    )))
  (while (< i% 3)
    (setq angle% (- (angle (nth i% pts)(nth (1+ i%) pts))))
    (setq tmp-pts (mapcar '(lambda (x) (m:coordinate-rotate x angle%)) pts))
    (if  (> area% (* (- (apply 'max (mapcar 'car tmp-pts))
			(apply 'min (mapcar 'car tmp-pts))
			)
		     (- (apply 'max (mapcar 'cadr tmp-pts))
			(apply 'min (mapcar 'cadr tmp-pts))
			)))
	(progn
	  (setq result-angle angle%)
	  (setq result-pts tmp-pts)
	  (setq area%  (* (- (apply 'max (mapcar 'car tmp-pts))
			     (apply 'min (mapcar 'car tmp-pts))
			     )
			  (- (apply 'max (mapcar 'cadr tmp-pts))
			     (apply 'min (mapcar 'cadr tmp-pts))
			     )))))
    (setq i% (1+ i%)))
  
  (strcat (rtos (min (- (apply 'max (mapcar 'car result-pts))
			(apply 'min (mapcar 'car result-pts))
			)
		     (- (apply 'max (mapcar 'cadr result-pts))
			(apply 'min (mapcar 'cadr result-pts))
			))
		2 2)
	  "x"
	  (rtos (max (- (apply 'max (mapcar 'car result-pts))
			(apply 'min (mapcar 'car result-pts))
			)
		     (- (apply 'max (mapcar 'cadr result-pts))
			(apply 'min (mapcar 'cadr result-pts))
			))
		2 2))
  )

