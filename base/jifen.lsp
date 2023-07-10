  1.;;;用各种方法求积分的程序
   2.;;;主程序
   3.(vl-load-com)
   4.;;(arxload "geomcal.arx")
   5.(prompt "请输入CCC命令!")
   6.(defun C:ccc (/ F ID N OK X1 X2)
   7.  (setq id (load_dialog "integration.dcl"))
   8.  (setq ok 2)
   9.  (if (new_dialog "dcl_Integration" id)
 10.    (progn
 11.      (action_tile "F" "(setq f $value)") 			;从对话框中得到表达式
 12.      (action_tile "X1" "(setq x1 (myread $value))")		;从对话框中得到下届
 13.      (action_tile "X2" "(setq x2 (myread $value))")		;从对话框中得到上届
 14.      (action_tile "N" "(setq n (myread $value))") 		;从对话框中得到精度
 15.      (action_tile "help" "(choose 1)")				;帮助
 16.      (action_tile "S1" "(Read_DLg_Data x1 x2 n f \"S1\")")
 17.      (action_tile "S2" "(Read_DLg_Data x1 x2 n f \"S2\")")
 18.      (action_tile "S3" "(Read_DLg_Data x1 x2 n f \"S3\")")
 19.      (action_tile "S4" "(Read_DLg_Data x1 x2 n f \"S4\")")
 20.      (setq ok (start_dialog))
 21.    )
 22.  )
 23.  (unload_dialog ID)
 24.  (princ)
 25.)
 26.;;;读数据并求解
 27.(defun Read_DLg_Data (x1 x2 n f key / EPS RET T0 E)
 28.  (if (and x1 x2 n f)
 29.    (progn
 30.      (if (> n 20)
 31.	(setq n 20)
 32.      )
 33.      (setq e (exp 1))
 34.      (setq f (trans_format f))
 35.      (eval (list 'defun 'func (list 'x) f))
 36.      (setq eps (expt 0.1 n))
 37.
 38.      (setq t0 (getvar "TDUSRTIMER"))
 39.      (cond
 40.	((= key "S1")
 41.	 (setq ret (rtos (romberg x1 x2 eps) 2 20))
 42.	 (set_tile "R1" ret)
 43.	 (princ "\n龙贝格积分法为:")
 44.	)
 45.	((= key "S2")
 46.	 (setq ret (rtos (simpson x1 x2 eps) 2 20))
 47.	 (set_tile "R2" ret)
 48.	 (princ "\n辛普森积分法为:")
 49.	)
 50.	((= key "S3")
 51.	 (setq ret (rtos (Atrapezia x1 x2 1e-4 eps) 2 20))
 52.	 (set_tile "R3" ret)
 53.	 (princ "\n自适应积分法为:")
 54.	)
 55.	((= key "S4")
 56.	 (setq ret (rtos (Trapezia x1 x2 eps) 2 20))
 57.	 (princ "\n变步长积分法为:")
 58.	 (set_tile "R4" ret)
 59.	)
 60.      )
 61.      (princ ret)
 62.      (princ "\n用时:")
 63.      (princ (* (- (getvar "TDUSRTIMER") t0) 86400))
 64.      (princ "秒")
 65.      (princ)
 66.    )
 67.    (alert "无效的输入或有空输入!")
 68.  )
 69.)
 70.(defun myread (str / e)
 71.  (setq e (exp 1))
 72.  (eval (trans_format str))
 73.)
 74.;;;帮助说明函数
 75.(defun choose (n)
 76.  (if (= n 1)
 77.    (alert
 78.    "方程式只接受x(小写)为变量,不规范很可能出错!
 79.    "\n龙贝格效率最高，变步长法效率最低(慎用).
 80.       "\n建议不要开始把精度设置很高，特别对于变步长法.
 81.    " \n程序采用多种方法求积,不保证每个方程都有效!
 82.	 "\n有什么问题email: highflybird@qq.com"
 83.    )
 84.    (set_tile "error" "方程式只接受x(小写)为变量.")
 85.  )
 86.)
 87.;;;用方式1定义表达式求值函数
 88.(defun func1 (x)
 89.  (cal f)
 90.)
 91.;;; 龙贝格积分法
 92.(defun Romberg (a b eps / EP H I K M N P Q S X Y Y0)
 93.  (setq h (- b a))
 94.  (setq y nil)
 95.  (setq i 0)
 96.  (repeat 20
 97.    (setq y (cons (cons i 0.0) y))
 98.    (setq i (1+ i))
 99.  )
 100.  (setq y (reverse y))
 101.  (setq y0 (* h (+ (func a) (func b)) 0.5))
 102.  (setq y (cons (cons 0 y0) (cdr y)))
 103.  (setq	m  1
 104.	n  1
 105.	ep (1+ eps)
 106.  )
 107.  (while (and (>= ep eps) (<= m 19))
 108.    (setq p 0.0)
 109.    (setq i 0)
 110.    (repeat n
 111.      (setq x (+ a (* (+ i 0.5) h)))
 112.      (setq p (+ p (func x)))
 113.      (setq i (1+ i))
 114.    )
 115.    (setq p (/ (+ (cdar y) (* h p)) 2.0))
 116.    (setq s 1.0)
 117.    (setq k 1)
 118.    (repeat m
 119.      (setq s (+ s s s s))
 120.      (setq q (/ (- (* s p) (cdr (assoc (1- k) y))) (1- s)))
 121.      (setq y (subst (cons (1- k) p) (assoc (1- k) y) y))
 122.      (setq p q)
 123.      (setq k (1+ k))
 124.    )
 125.    (setq ep (abs (- q (cdr (assoc (1- m) y)))))
 126.    (setq m (1+ m))
 127.    (setq y (subst (cons (1- m) q) (assoc (1- m) y) y))
 128.    (setq n (+ n n))
 129.    (setq h (/ h 2.0))
 130.  )
 131.  q
 132.)
 133.;;; 辛普森积分法
 134.(defun Simpson (a b eps / EP H ITER K N P S1 S2 T1 T2 X)
 135.  (setq n 1)
 136.  (setq h (- b a))
 137.  (setq t1 (* h (+ (func a) (func b)) 0.5))
 138.  (setq s1 t1)
 139.  (setq ep (1+ eps))
 140.  (setq iter 0)
 141.  (while (and (>= ep eps) (< iter 100))
 142.    (setq p 0.0)
 143.    (setq k 0)
 144.    (repeat n
 145.      (setq x (+ a (* (+ k 0.5) h)))
 146.      (setq p (+ p (func x)))
 147.      (setq k (1+ k))
 148.    )
 149.    (setq t2 (/ (+ t1 (* h p)) 2.))
 150.    (setq s2 (/ (- (* 4.0 t2) t1) 3.))
 151.    (setq ep (abs (- s2 s1)))
 152.    (setq t1 t2)
 153.    (setq s1 s2)
 154.    (setq n (+ n n))
 155.    (setq h (/ h 2))
 156.    (setq iter (1+ iter))
 157.  )
 158.  s2
 159.)
 160.;;; 变步长梯形求积分法
 161.(defun Trapezia	(a b eps / H K N P S T1 T2 X iter)
 162.  (setq n 1)
 163.  (setq h (- b a))
 164.  (setq t1 (* h (+ (func a) (func b)) 0.5))
 165.  (setq p (1+ eps))
 166.  (setq iter 0)
 167.  (while (and (>= p eps) (< iter 100))
 168.    (setq s 0)
 169.    (setq k 0)
 170.    (repeat n
 171.      (setq x (+ a (* (+ k 0.5) h)))
 172.      (setq s (+ s (func x)))
 173.      (setq k (1+ k))
 174.    )
 175.    (setq t2 (/ (+ t1 (* h s)) 2.))
 176.    (setq p (abs (- t1 t2)))
 177.    (setq t1 t2)
 178.    (setq n (+ n n))
 179.    (setq h (/ h 2))
 180.    (setq iter (1+ iter))
 181.  )
 182.  t2
 183.)
 184.;;; 步长积分法
 185.(defun trapzd (a b n / DEL IT SUM TNM X)
 186.  (if (= n 1)
 187.    (setq s (* 0.5 (- b a) (+ (func a) (func b))))
 188.    (progn
 189.      (setq it 1)
 190.      (repeat (- n 2)
 191.	(setq it (lsh it 1))
 192.      )
 193.      (setq tnm it)
 194.      (setq del (/ (- b a) tnm))
 195.      (setq x (+ a (* 0.5 del)))
 196.      (setq sum 0.0)
 197.      (repeat it
 198.	(setq sum (+ sum (func x)))
 199.	(setq x (+ x del))
 200.      )
 201.      (setq s (* 0.5 (+ s (/ (* (- b a) sum) tnm))))
 202.    )
 203.  )
 204.)
 205.
 206.;;; 自适应求积分法
 207.(defun Atrapezia (a b d eps / F0 F1 H S T0 TT)
 208.  (setq h (- b a))
 209.  (setq TT '(0. . 0.))
 210.  (setq f0 (func a))
 211.  (setq f1 (func b))
 212.  (setq t0 (* h (+ f0 f1) 0.5))
 213.  (setq s (car (ppp a b h f0 f1 t0 eps d tt)))
 214.)
 215.(defun PPP (x0 x1 h f0 f1 t0 eps d tt / EPS1 EPS2 F G P T1 T2 T3 X X2)
 216.  (setq x (+ x0 (* h 0.5)))
 217.  (setq f (func x))
 218.  (setq t1 (* h (+ f0 f) 0.25))
 219.  (setq t2 (* h (+ f1 f) 0.25))
 220.  (setq p (abs (- t0 t1 t2)))
 221.  (if (or (< p eps) (< (* 0.5 h) d))
 222.    (cons (+ (car tt) t1 t2) (cdr tt))
 223.    (progn
 224.      (setq g (* h 0.5))
 225.      (setq eps1 (/ eps 1.4))
 226.      (setq t3 (ppp x0 x g f0 f t1 eps1 d tt))
 227.      (setq t3 (ppp x x1 g f f1 t2 eps1 d t3))
 228.    )
 229.  )
 230.)






(DEFUN c:SAPI ()
  (setq sapi (vlax-create-object "Sapi.SpVoice"))
  ;;(vlax-invoke sapi "Speak" "Would you like to play Global Thermo Nuclear War ?" 0) ;;;
  (vlax-invoke sapi "Speak" "程序现在开始!" 0)
  (vlax-release-object sapi)
)