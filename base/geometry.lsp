;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; base : @lisp ������
;;; Author: VitalGG<vitalgg@gmail.com>
;;; Description: ���� AutoLisp/VisualLisp �����Ļ�ͼ���߼�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ��ѧ�� lib-math.lsp
;;; �������ú�����

(defun m:coordinate-rotate (point2d angle1 / x y)
  "������ת"
  (setq x (car point2d))
  (setq y (cadr point2d))
  (list (- (* x (cos angle1)) (* y (sin angle1)))
	(+ (* x (sin angle1)) (* y (cos angle1)))))
(defun m:coordinate-scale (point scale)
  "��������"
  (mapcar '(lambda (a) (* scale a)) point))
(defun m:coordinate (p-base point2d  / x y z)
  "���������任"
  (setq x (car point2d))
  (setq y (cadr point2d))
  (list (+ (car p-base) x)
	(+ (cadr p-base) y)
	(last p-base))
  )

(defun m:coord-chg  (pt-wcs O-ucs O-ang  / pt1a x y z)
  ;;x=x'cost-y'sint+x0,
  ;;y=x'sint+y'cost+y0.
  (setq pt1a (mapcar '- pt-wcs O-ucs))
  (setq x (car pt1a))
  (setq y (cadr pt1a))
  (list (+ (* x (car O-ang)) (* y (cadr O-ang)))
	(- (* y (car O-ang)) (* x (cadr O-ang)))
	0)
  )
(defun geometry:ucs (base angle1)
  (command ".ucs" base (polar base angle1 10000) (polar base (+ (* 0.25 pi) angle1) 25000))
  
  )
(defun geometry:angle (segment / pt1 pt2  dist-o)
  "ֱ��(�߶�)��������xyz�ļн��б�"
  "����ֱ����x y z ��ļн�(����)"
  "(geometry:angel '((0 0 0)(1 1 1)))"
  (setq pt1 (car segment)
	pt2 (cadr segment))
  (setq dist-o
	(sqrt
	 (+ (* (- (car pt2)(car pt1))(- (car pt2)(car pt1)))
	    (* (- (cadr pt2)(cadr pt1))(- (cadr pt2)(cadr pt1)))
	    (* (- (caddr pt2)(caddr pt1))(- (caddr pt2)(caddr pt1))))))
  
  (list (/ (- (car pt2)(car pt1))
	   dist-o)
	(/ (- (cadr pt2)(cadr pt1))
	   dist-o)
	(/ (- (caddr pt2)(caddr pt1))
	   dist-o)))
(defun geometry:segment-by-line (line)
  (list (entity:getdxf line 10)(entity:getdxf line 11)))
(defun geometry:segment-mid (segment)
  "���߶ε��е�����"
  "��ά����ֵ"
  (list (* 0.5 (+ (car (car segment))
		  (car (cadr segment))))
	(* 0.5 (+ (cadr (car segment))
		  (cadr (cadr segment))))
	(if (caddr (car segment))
	    (* 0.5 (+ (caddr (car segment))
		      (caddr (cadr segment))))
	    0)))

(defun geometry:dist-pt-line (pt segment / an )
  "��㵽�߶εľ���"
  "number"
  "(geometry:dist-pt-line '(0 0 0) '((1 0 0)(0 1 0)))"
  (setq an (angle (car segment)(cadr segment)))
  (if (setq inter1
	   (inters
	    (car segment)(cadr segment)
	    pt (polar pt (+ an (* 0.5 pi)) 1000) nil))
      (if (geometry:on-segment inter1 segment)
	  (distance pt inter1)
	(min (distance pt (car segment))
	     (distance pt (cadr segment))))))
(defun geometry:wcs2ucs (pt)
  (m:coord-chg pt (getvar "ucsorg") (getvar "ucsxdir"))
  )
(defun geometry:ucs-angle ()
  (if (equal 0 (car (getvar "ucsxdir")) 1e-8)
      (if (equal 1 (cadr (getvar "ucsxdir")) 1e-8)
	  (* 0.5 pi)
	(* 1.5 pi))
    (if (>= (cadr (getvar "ucsxdir")) 0)
	(atan (/ (cadr (getvar "ucsxdir"))(car (getvar "ucsxdir"))))
	(+ pi (atan (/ (cadr (getvar "ucsxdir"))(car (getvar "ucsxdir")))))
      )))
     
(defun geometry:point-3d->2d (pt)
  (cons (car pt)(cadr pt)))
(defun geometry:on-segment (pt segment)
  "�ж�һ�����߶ι��ߵĵ��Ƿ����߶��ϡ�"
  (and (>= (car pt) (apply 'min (mapcar 'car segment)))
       (<= (car pt) (apply 'max (mapcar 'car segment)))
       (>= (cadr pt) (apply 'min (mapcar 'cadr segment)))
       (<= (cadr pt) (apply 'max (mapcar 'cadr segment)))))
(defun geometry:convexhull-by-jarvis (pts / pfirst p0 p1 pmax1 pmax2 pp)
  "��С͹���㷨: jarvis ��������package wrapping or gift wrapping"
  (cond
    ((= (length pts) 0)
     nil
     )
    ((or nil (= (length pts) 1) (= (length pts) 2))
     (progn
       (alert "������ĵ�Ϊ�����һ��!")
       pts
       )
     )
    (t
     (progn
       ;;����ʸ��֮���,����������ʽֵ֮-----
       (defun det2 (p1 p2)
	 (- (* (car p1) (cadr p2)) (* (car p2) (cadr p1)))
	 )
       ;;�������������ʽ,������֮�����-----
       (defun det (p1 p2 p3)
	 (+ (det2 p1 p2) (det2 p2 p3) (det2 p3 p1))
	 )
       (defun sign (x)
	 (cond ((> x 0) -1.0)
	       ((< x 0) 1.0)
	       (t 0)
	       )
	 )
       ;;����˳ʱ�뷽��ļн�Ϊ��ֵ����֮Ϊ��
       (defun ang (p1 p2 p3 / x)
	 (setq x (abs (- (angle p1 p3) (angle p1 p2))))
	 (if (equal p3 p1 1e-8)
	     (- pi)
	     (if (< (abs (sin x)) 1e-8)
		 (if	(equal (- (distance p2 p3)(+ (distance p1 p2) (distance p1 p3))) 0 1e-8)
			pi
			0
			)
		 (if	(> x pi)
			(* (- (* 2 pi) x) (sign (det p2 p1 p3)))
			(* x (sign (det p2 p1 p3)))
			)
		 )
	     )
	 )
       ;;************************************
       ;;��������****************************
       (defun maxium (pts)
	 (car (vl-sort pts
		       '(lambda (e1 e2)
			 (if (equal (car e1) (car e2) 1e-8)
			     (> (cadr e1) (cadr e2))
			     (> (car e1) (car e2))
			     )
			 )
		       )
	      )
	 )
       ;;����--------------------------------
       (setq p0 (maxium pts))
       (setq p1 p0 pfirst p0 p0 (list (car p0) (+ 1.0 (cadr p0)) (caddr p0)))
       (setq pmax1 p1)
       (setq p1 (mapcar '(lambda (x) (list (ang p1 p0 x) (distance p1 x) x)) pts))
       (setq pmax2 (caddr (maxium p1)))
       (setq pp (cons pmax2 (list pmax1)))
       (while (not (equal pfirst pmax2 1e-8))
	 (setq p1 (mapcar '(lambda (x)(list (ang pmax2 pmax1 x) (distance pmax2 x) x))(mapcar 'caddr p1)))
	 (setq pmax1 pmax2)
	 (setq pmax2 (caddr (maxium p1)))
	 (setq pp (cons pmax2 pp))
	 )
       (reverse (cdr pp))
       )
     )  
    )
  )
(defun geometry:convexhull-by-graham-scan (pts / d i p0)
  "graham-scan�㷨����㼯͹��
����: pts:���"
  "͹�����"
  "(geometry:convexhull-by-graham-scan '(pt1 pt2 pt3 ...))"
  ;;�㼯�� yx ��������
  (setq pts
	(vl-sort
	 pts
	 '(lambda (p1 p2)
	   (cond
	     ((< (cadr p1) (cadr p2)))
	     ((equal (cadr p1) (cadr p2) 1e-8)
	      (< (car p1) (car p2))
	      ))))) 
  (setq p0 (car pts)) ;��������������ѡȡYֵ��С��ͬʱX��С�ĵ���Ϊ͹���ĵ�һ����
  ;;����������
  (setq pts
	(vl-sort
	 (cdr pts)
	 (function
	  (lambda (p1 p2 / m n)
           (cond
	     ((< (setq m (angle p1 p0)) (setq n (angle p2 p0))))
	     ((equal m n 1e-8)
	      (< (distance p1 p0) (distance p2 p0))
	      ))))))
  ;;����͹���㷨
  (setq pt-hull (list (cadr pts) (car pts) p0)) ;������ʼ͹���㼯
  (foreach curpt (cddr pts)  ;����ʣ���
	   (setq pt-hull (cons curpt pt-hull))  ;��ǰ����ջ   
	   (while (and (caddr pt-hull)
		       (geometry:turn-right-p (caddr pt-hull) (cadr pt-hull) curpt))
	     (setq pt-hull (cons curpt (cddr pt-hull))) ;�ж���ʱ���͹��ǰ�����Ƿ���ת���������ת�����ڶ���ɾ��
	     )
	   )
  )
(defun-q geometry:turn-right-p (pt1 pt2 pt3 / det2 det x)
  "�ж������ת�Ƿ���"
  "˳ʱ�뷽��ļн�Ϊ��ֵ����֮Ϊ��, 0Ϊֱ�ߡ�"
  (defun det2 (p1 p2)
    "ʸ�����"
    (- (* (car p1) (cadr p2)) (* (car p2) (cadr p1)))
    )
  
  (defun det (p1 p2 p3)
    "�������������ʽ,������֮�����"
    (+ (det2 p1 p2) (det2 p2 p3) (det2 p3 p1))
    )
  (setq x (abs (- (angle pt1 pt3) (angle pt1 pt2))))
  (if (equal pt3 pt1 1e-8)
      (- pi)
    (if (< (abs (sin x)) 1e-8)
	(if (equal (- (distance pt2 pt3)(+ (distance pt1 pt2) (distance pt1 pt3))) 0 1e-8)
	    pi
	  0
	  )
      (if (> x pi)
	  (* (- (* 2 pi) x) (m:sign (det pt2 pt1 pt3)))
	(* x (m:sign (det pt2 pt1 pt3)))
	)
      )
    )
  )
(defun-q geometry:turn-left-p (pt1 pt2 pt3 / det2 det x)
  "�ж������ת�Ƿ���"
  "˳ʱ�뷽��ļн�Ϊ��ֵ����֮Ϊ��, 0Ϊֱ�ߡ�"
  (defun det2 (p1 p2)
    "ʸ�����"
    (- (* (car p1) (cadr p2)) (* (car p2) (cadr p1)))
    )
  
  (defun det (p1 p2 p3)
    "�������������ʽ,������֮�����"
    (+ (det2 p1 p2) (det2 p2 p3) (det2 p3 p1))
    )
  (setq x (abs (- (angle pt1 pt3) (angle pt1 pt2))))
  (if (equal pt3 pt1 1e-8)
      (- pi)
    (if (< (abs (sin x)) 1e-8)
	(if (equal (- (distance pt2 pt3)(+ (distance pt1 pt2) (distance pt1 pt3))) 0 1e-8)
	    pi
	  0
	  )
      (if (> x pi)
	  (* (- (* 2 pi) x) (m:sign (det pt2 pt1 pt3)))
	(* x (m:sign (det pt2 pt1 pt3)))
	)
      )
    )
  )
