(@:add-menu "�ṹ����" "Ӱ��ϵ��amax" "(seismic:menu-amax)")
(@:add-menu "�ṹ����" "��������ֵ" "(seismic:menu-period-of-ground-motion)")
(@:add-menu "�ṹ����" "�������" "(seismic:menu-gap-of-seismic)")
(defun seismic:menu-period-of-ground-motion(/ res)
  (setq res (ui:input "��������ֵ" '(("�������" (1 2 3) "��Ƶ������")("�������" ("I0" "I1" "II" "III" "IV") "�������"))))
  (alert (strcat "������飺�� " (itoa (cdr (assoc "�������" res))) " ��    �������: " (cdr (assoc "�������" res))"\n"
		 "������������ֵΪ: " 
		 (rtos (seismic:period-of-ground-motion
			(cdr (assoc "�������" res))
			(vl-position (cdr (assoc "�������" res))'("I0" "I1" "II" "III" "IV")))
		       2 2)))
   )
(defun seismic:menu-amax(/ res)
  (setq res (ui:input "����Ӱ��ϵ�����ֵ" '(("����Ҷ�" (6 7 7.5 8 8.5 9) "��������Ҷ�")("�Ƿ����" T ))))
  (alert (strcat "��������Ҷȣ�" (rtos (cdr (assoc "����Ҷ�" res)) 2 1) " ��  " (if (cdr (assoc "�Ƿ����" res)) "����" "����")"\n"
		 "����Ӱ��ϵ�����ֵ: "
		 (rtos (seismic:amax
			(cdr (assoc "����Ҷ�" res))
			(cdr (assoc "�Ƿ����" res)))
		       2 2)))
  )
(defun seismic:menu-gap-of-seismic(/ res)
  
  (setq res (ui:input "������ȼ���" '(("�ṹ����" ("��ܽṹ""���-����ǽ�ṹ""����ǽ�ṹ"))
					 ("����Ҷ�" (6 7 8 9) "��������Ҷ�")
					 ("������߶�" 33.0 ))))
  (alert (strcat
	  (cdr (assoc "�ṹ����" res)) "  "
	  (rtos (cdr (assoc "����Ҷ�" res)) 2 1) " ��  �߶�: "
	  (rtos (cdr (assoc "������߶�" res)) 2 3)
	  "\n������ȣ�"
	  (rtos (seismic:gap-of-seismic
		 (cdr (assoc "����Ҷ�" res))
		 (cdr (assoc "�ṹ����" res))
		 (cdr (assoc "������߶�" res))
		 )
		2 2)))
  )



(defun seismic:period-of-ground-motion (group-of-seismic category-of-site / table)
  "��������ֵ, group-of-seismic: 1 2 3 , �������ȡֵ I0 I1 II III IV�� 0 1 2 3 4"
  (setq table '((0.20 0.25 0.35 0.45 0.65)
		(0.25 0.30 0.40 0.55 0.75)
		(0.30 0.35 0.45 0.65 0.90)))
  (if (and (<= 1 group-of-seismic 3)
	   (<= 0 category-of-site 4))
      (nth category-of-site (nth (1- group-of-seismic) table))
    nil))

(defun seismic:amax (liedu duoyu-or-hanyu / table)
  "ˮƽ����Ӱ��ϵ�����ֵ,�������Ҷ� 6 7 7.5 8 8.5 9,�������� T or nil."
  
  (setq table '((0.04 0.08 0.12 0.16 0.24 0.32)
		(0.28 0.50 0.72 0.90 1.20 1.40)))
  (nth (vl-position liedu '(6 7 7.500 8 8.500 9))
       (if duoyu-or-hanyu
	   (car table)
	 (cadr table))))
  
(defun seismic:gap-of-seismic(liedu type-of-stru height / table)
  "������ȣ��������Ҷȣ��ṹ���ͣ�������߶�"
  ""
  (setq table '(("��ܽṹ" . 1)("���-����ǽ�ṹ" . 0.7)("����ǽ�ṹ" . 0.5)))
  (if (cdr (assoc type-of-stru table))
      (max 100
	   (* (cdr (assoc type-of-stru table))
	      (+ 100
		 (* 20
		    (/ (float (- height 15))
		       (float (- 11.0 liedu))))
		 )))
    1000
    ))
  
  
