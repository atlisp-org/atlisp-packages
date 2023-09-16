(@:define-config '@select:blksname "" "ѡ��ʱҪƥ��Ŀ���")
(@:define-config '@select:onboundary 1 "1 ѡ���ڱ߽���ͼԪ; 0 ��ѡ�߽��ϵ�ͼԪ")
(defun @select:setup (/ res) 
  (setq @:tmp-search-str "@SELECT")
  (@:edit-config))
(defun c:ss1 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss1���Է�����������ʹ�á����û��ѡ���Ҹ�����ͼ�Σ������ss1"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss1 ss)
    (if ss1 
      (sssetfirst nil ss1))))
(defun c:ss2 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss2��"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss2 ss)
    (if ss2 
      (sssetfirst nil ss2))))
(defun c:ss3 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss3��"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss3 ss)
    (if ss3 
      (sssetfirst nil ss3))))
(defun c:ss4 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss4��"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss4 ss)
    (if ss4 
      (sssetfirst nil ss4))))
(defun c:ss5 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss5��"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss5 ss)
    (if ss5 
      (sssetfirst nil ss5))))


(defun at-select:select-blk-by-hatch (/ ha res all-outer ss-all all-inter ss-in 
                                      selopt) 
  (@:help '("ѡ��һ����䣬��������ڵĿ顣"))
  (defun boundarypath2pts (bdpath / pts) 
    "�߽�·��ת��ѡ�㼯"
    ;; ���Ƕ���ߵĴ���
    (if (= 0 (boole 1 2 (cdr (assoc 92 bdpath)))) 
      (progn 
        (setq parts (list:split-by bdpath '(lambda (x) (= (car x) 72))))
        (setq parts (mapcar 
                      '(lambda (x) 
                         (cond 
                           ((= 2 (cdr (assoc 72 x)))
                            (list
                            (cons 
                              10
                              (polar 
                                (cdr (assoc 10 x))
                                (* 0.5 (+ (cdr (assoc 50 x)) (cdr (assoc 51 x))))
                                (cdr (assoc 40 x))))))
                           (t x)))
                      parts))
        (setq bdpath (apply 'append parts))))
    (setq pts (list:delsame 
                (mapcar 
                  'cdr
                  (vl-remove-if-not 
                    '(lambda (x) (or (= 10 (car x)) (= 11 (car x))))
                    bdpath))
                0.001)))
  (setq selopt '("cp" "wp"))
  (if (/= 1 (@:get-config '@select:onboundary)) 
      (setq selopt (reverse selopt)))
  (setq hatchs (pickset:to-list (ssget '((0 . "hatch")))))
  (setq ss-all nil)
  (setq ss-in nil)
  (foreach hatch% hatchs
	   (setq ha (entget hatch%))
	   (setq res (cadr (list:split-by ha '(lambda (x) (= (car x) 91)))))
	   (setq res (car (list:split-by res '(lambda (x) (= (car x) 75)))))
	   (setq res (cdr (list:split-by res '(lambda (x) (= (car x) 92)))))
	   ;; (setq res (vl-sort res '(lambda (x y) (> (cdar x) (cdar y)))))
	   ;; �ⲿ�߽�·���е�ͼԪ
	   (setq all-outer (vl-remove-if-not 
			    '(lambda (x) (= 1 (boole 1 1 (cdr (assoc 92 x)))))
			    res))
	   (princ (strcat (itoa (length all-outer)) "���ⲿ�߽�·��"))
	   (foreach outer all-outer 
		    ;; debug (entity:make-lwpolyline (boundarypath2pts outer) nil 0 1 0)
		    (setq blk-all (pickset:to-list 
                    (ssget 
                      (car selopt)
                      (boundarypath2pts outer)
                      (append 
                       (list '(0 . "insert"))
                       (if (/= "" (@:get-config '@select:blksname)) 
                           (list 
                            (cons 2 (@:get-config '@select:blksname))))))))
		    (setq ss-all (list:union ss-all blk-all)))
	   (setq all-inter (vl-remove-if-not 
			    '(lambda (x) (= 0 (boole 1 1 (cdr (assoc 92 x)))))
			    res))
	   (princ (strcat (itoa (length all-inter)) "���ڲ��µ��߽�·��"))
	   ;; �ڲ��µ��߽�·���е�ͼԪ
	   (foreach inter all-inter 
		    (setq blk-in (pickset:to-list 
				  (ssget 
				   (cadr selopt)
				   (boundarypath2pts inter)
				   (append 
				    (list '(0 . "insert"))
				    (if (/= "" (@:get-config '@select:blksname)) 
					(list 
					 (cons 2 (@:get-config '@select:blksname))))))))
		    (if blk-in 
			(setq ss-in (list:union ss-in blk-in)))))
  (setq ss-res (list:difference ss-all ss-in))
  (sssetfirst nil (pickset:from-list ss-res)))

(defun @select:line-to-ss ()
  (@:help "����ָ��ѡ�񼯵��ߡ�")
  (setq pt (getpoint))
  (mapcar 
  '(lambda (x) (entity:make-line pt (entity:getdxf x 10)))
    (vl-remove nil (pickset:to-list (cadr (ssgetfirst)))
)))
