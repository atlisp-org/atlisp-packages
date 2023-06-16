;;; ͳ�ƽ����Ϊ��Ա�car Ϊ ϵ����cdr Ϊֵ

(defun-q stat:stat (lst / atom% res)
  "ͳ���б� lst �е�Ԫ�ظ�����"
  "Ԫ�غ͸�����ɵĵ�Ա�"
  "(stat:stat '(3 a a 2 2)) => ((3 . 1) (A . 2) (2 . 2))"
  (setq res '())
  (foreach atom% lst
	   (if (assoc atom% res)
	       (setq res (subst (cons atom% (+ 1 (cdr (assoc atom% res))))
				  (assoc atom% res)
				  res))
	       (setq res (append res (list (cons atom% 1))))
	       )
	   )
  res)

(defun stat:mode (stat-res)
  "����"
  (car (vl-sort stat-res (function (lambda (e1 e2)
			   (> (cdr e1)(cdr e2))))))
  )

(defun stat:print ()
  "��ӡ���һ��ͳ�ƵĽ��"
  (foreach n  @:tmp-stat-result
	   (princ  (car n ))(princ (cdr n)) (princ "\n")))
(defun stat:draw ( / n pt )
  "�������һ��ͳ�ƵĽ��"
  (setq pt (getpoint "������Ҫ���Ƶ�λ��:"))
  (setq n 0)
  (table:make pt "ͳ�ƽ��" '("��Ŀ" "����")
	      (mapcar '(lambda (x) (list (car x)(cdr x)))  @:tmp-stat-result))
  ;; (entity:make-text " ��" (m:coordinate pt (list 0 (* n -350))) 250 0 0.8 0 13)
  ;; (entity:make-text (format nil "���� | ") (m:coordinate pt (list 0 (* n -350))) 250 0 0.8 0 33)
  ;; (setq n 1)
  ;; (foreach x  @:tmp-stat-result
  ;; 	   (entity:make-text (format nil "~a" (car x)) (m:coordinate pt (list 0 (* n -350))) 250 0 0.8 0 13)
  ;; 	   (entity:make-text (format nil "~10d | " (cdr x)) (m:coordinate pt (list 0 (* n -350))) 250 0 0.8 0 33)
  ;; 	   (setq n (1+ n))
  ;; 	   )
  )

;; Local variables:
;; coding: gb2312
;; End: 
