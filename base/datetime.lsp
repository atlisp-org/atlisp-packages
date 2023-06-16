
(defun-q datetime:current-time (str-fmt)
  "��ʽ������ʱ�䣬yyyy �� mo �� dd �� hh ʱ mm �� ss ��"
  "����ʱ���ַ���"
  "(datetime:current-time \"yyyy-mo-dd hh:mm:ss\""
  (menucmd (strcat "M=$(edtime,$(getvar,date)," str-fmt ")")))

(defun-q datetime:get-current-day ()
  "��������"
  (substr (itoa (fix (getvar "CDATE"))) 7 2)
  )
(defun-q datetime:get-current-month ()
  "�����·�"
  (substr (itoa (fix (getvar "CDATE"))) 5 2)
  )
(defun-q datetime:get-current-year ()
  "�������"
  (substr (itoa (fix (getvar "CDATE"))) 1 4)
  )
(defun-q timer:begin ()
  "��ʱ����ʼ"
  (if (> (@:acadver) 20.1)
      (setq *timer* (getvar "millisecs"))
    (setq *timer* (getvar "TDUSRTIMER"))
    ))
(defun-q timer:end (time p / usetime) ;��ʱ������
  "��ʱ��������time ��ʼʱ�� p �Ƿ��ӡ��"
  (if (not time)(setq time *timer*))
  (if (> (@:acadver) 20.1)
      (setq usetime (-  (getvar "millisecs") time))
    (setq usetime (* 86400000(- (getvar "TDUSRTIMER") time))))
  (if p (print(strcat"use time: "(rtos usttime 2 0)"micro second.")))
  usetime
  )
(defun-q datetime:leap-yearp (year)
  "�ж�ĳ���Ƿ�Ϊ���ꡣ"
  (if (= 0 (mod year 100))
      (if (= 0 (mod year 400))
	  T
	  nil)
      (if (= 0 (mod year 4))
	  T
	  nil)))
  
(defun-q datetime:mktime (lst / )
  ;;        '(0 31 28 31  30  31  30  31  31  30  31 30  31))
  "����ĳһʱ��(�б�)��1970��01��01�վ���������,�ʺ�ת��vl-file-systime�Ľ��"
  "Timestamp"
  "(datetime:mktime (vl-file-systime (findfile \"acad.pgp\")))"
  (setq days-of-month
	(if (datetime:leap-yearp (nth 0 lst))
	    '(0 31 60 91 121 152 182 213 244 274 305 335 366)
	    '(0 31 59 90 120 151 181 212 243 273 304 334 365)))
  (+ (* 60.
	(+
	 (* 60.
	    (+
	     (* 24.
		(+ (* (- (nth 0 lst) 1970.) 365.) ;; ����������
		   (fix (/ (- (nth 0 lst) 1970) 4)) ;; ����
		   (nth (1- (nth 1 lst)) days-of-month) ;;�·�֮ǰ������
		   (nth 3 lst)))  ;; ���¾���������
	     (nth 4 lst)
	     (- 8))) ;; Сʱ����ʱ��
	 (nth 5 lst) ))
     (nth 6 lst)))
(defun-q datetime:mktime1900 (timestamp)
  "unix timestamp ת ��1900��01��01�վ���������."
  "real"
  "(datetime:mktime1900 (datetime:mktime (vl-file-systime (findfile \"acad.pgp\"))))"
  (+ (* 22089.0 100000.) 88800.0 timestamp)
  )
