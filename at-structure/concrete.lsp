(defun concrete:fck ( level / ac1 ac2)
  "���������Ŀ�ѹǿ�ȱ�׼ֵ"
  "Real"
  (setq ac1 (cond ((<= level 50) 0.76)
		  ((>= level 80) 0.82)
		  ;; �м��ֵ
		  (t
		   (+ 0.76 (* (- 0.82 0.76)
			      (/ (- level 50.) 30.))))
		  ))
  (setq ac2 (cond ((<= level 40) 1.0)
		  ((>= level 80) 0.87)
		  ;; �м��ֵ
		  (t
		   (+ 1.0 (* (- 0.87 1.0)
			     (/ (- level 40.) 40.))))
		  ))

  (* 0.88 ac1 ac2 level))

(defun concrete:ftk (level / ac2 delta fcuk ftk i)
  "���������Ŀ���ǿ�ȱ�׼ֵ, �Ǳ�׼ǿ�ȱ�Ű�ֱ�߲�ֵ���㡣"
  "Real"
  ;; (setq delta 0.159620
  ;; 	level (float level))
  ;; (setq ac2 (cond ((<= level 40) 1.0)
  ;; 		  ((>= level 80) 0.87)
  ;; 		  ;; �м��ֵ
  ;; 		  (t
  ;; 		   (+ 1.0 (* (- 0.87 1.0)
  ;; 			     (/ (- level 40.) 40.))))
  ;; 		  ))
  ;; (* 0.88 0.395 (expt level 0.55)
  ;;    (expt (- 1. (* 1.645 delta)) 0.45)
  ;;    ac2)
  (setq fcuk '(15 20 25 30 35 40 45 50 55 60 65 70 75 80 100))
  (setq ftk '(1.27 1.54 1.78 2.01 2.20 2.39 2.51 2.64 2.74 2.85 2.93 2.99 3.05 3.11 4.0))
  (setq i 0)
  (while (and (<= level 80)
	      (>=  level (nth i fcuk)))
    (setq i (1+ i)))
  (setq i (1- i))
  (+ (nth i ftk)
     (* (- (nth (1+ i) ftk) (nth i ftk))
	(float(- level (nth i fcuk)))
	0.2))
  )
(defun concrete:fc (level)
  "���������Ŀ�ѹǿ�����ֵ"
  "Real"
  (/ (concrete:fck  level)1.4))
(defun concrete:ft (level)
  "���������Ŀ���ǿ�����ֵ"
  "Real"
  (/ (concrete:ftk level) 1.4))
(defun concrete:ec (level)
  "����������ģ��"
  "Real"
  (/ 1e5 (+ 2.2 (/ 34.7 level))))
(defun concrete:Gc (level)
  "����������ģ��"
  "Real"
  (* 0.4 (concrete:ec level)))

