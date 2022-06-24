;;;duotu007 ver1.0 2012/9/6(ԭ��)
;;;1028695446   ver2.0 2019/4/4(�޸�)
(defun @lab:dyn-adjust (/ bl_update bl_update_time_batch boolean_typeofss ent error_do main_process main_process_batch ss_first text_update color text textent)
  ;;���ܼ����Ӻ�����
  ;; (if (/= (TYPE test_load ) 'SUBR) 	;�ж�testload�����Ƿ��ѱ����أ�����ǣ���ʾ�Ѿ��������Ӻ����ļ���
  ;;     (PROGN
  ;;      (c:add) 	;�����Ӻ����ļ���
  ;;      )
  ;;   )
  ;;���ô�����֮�󣬵����޷���ѡ���ִ�У�����ԭ�򻹲��ö�֪��
  ;;(error_init 'error_do 1)
  (defun error_do()
    (redraw)
    (if text (entdel text));ɾ����ʱ����
    (princ)
    )
  (defun bl_update(oba bl);;�Ӻ���,���±���Ϊ����ֵbl
    (cond
     ((or (= oba "REGION") (= oba "LWPOLYLINE") (= oba "LINE") (= oba "CIRCLE") (= oba "ARC"))
      (vla-put-LinetypeScale obj bl);;�趨���ͱ���
      )
     ((= oba "HATCH")
      (vla-put-PatternScale obj bl);;�趨������
      )
     ((= oba "INSERT")
      (vla-put-xscalefactor obj bl);;�趨ͼ�����x
      (vla-put-yscalefactor obj bl);;�趨ͼ�����y
      (vla-put-zscalefactor obj bl);;�趨ͼ�����z
      )
     ((or (= oba "TEXT")(= oba "MTEXT"))
      (vla-put-Height obj bl)
      )
     ((wcmatch oba "*DIMENSION")
      (vla-put-ScaleFactor obj bl)
      )
     )
    )
  (defun bl_update_time_batch(list_ent list_bl bl / oba);;�Ӻ���,��ѡ���ڵ�ͼԪ���������±���Ϊԭʼ������bl��
    (setq oba (cdr (assoc 0 (entget (nth 0 list_ent)))))
    (cond
     ((or (= oba "REGION") (= oba "LWPOLYLINE") (= oba "LINE") (= oba "CIRCLE") (= oba "ARC"))
      
      (mapcar '(lambda (x y) (vla-put-LinetypeScale (vlax-ename->vla-object x) (* y bl))) list_ent list_bl)
      )
     ((= oba "HATCH")
      
      (mapcar '(lambda (x y) (vla-put-PatternScale (vlax-ename->vla-object x) (* y bl))) list_ent list_bl)
      )
     ((= oba "INSERT")
      
      (mapcar '(lambda (x y) (vla-put-xscalefactor (vlax-ename->vla-object x) (* y bl))) list_ent (nth 0 list_bl))
      (mapcar '(lambda (x y) (vla-put-yscalefactor (vlax-ename->vla-object x) (* y bl))) list_ent (nth 1 list_bl))
      (mapcar '(lambda (x y) (vla-put-zscalefactor (vlax-ename->vla-object x) (* y bl))) list_ent (nth 2 list_bl))
      
      )
     ((or (= oba "TEXT")(= oba "MTEXT"))
      (mapcar '(lambda (x y) (vla-put-Height (vlax-ename->vla-object x) (* y bl))) list_ent list_bl)
      )
     ((wcmatch oba "*DIMENSION")
					;(vla-put-ScaleFactor obj bl)
      (mapcar '(lambda (x y) (vla-put-ScaleFactor (vlax-ename->vla-object x) (* y bl))) list_ent list_bl)
      )
     )
    )
  (defun text_update(str / );;�Ӻ���,������ʱ����
    (if color(princ)(setq color 1))
    
					;(setq str (rtos bl))
    (if text;������ʾ
	(progn
	  (setq textent (subst (cons 1 str)   (assoc 1  textent) textent))
	  (setq textent (subst (cons 62 color)(assoc 62 textent) textent))
	  (setq textent (subst (cons 40 (/ (getvar "viewsize") 30))(assoc 40 textent) textent))
					;����ƶ���ʱ�򣬸������꣬ʹ���������ƶ����û����̵�ʱ�򣬲���������
	  (if (= a 5) (setq textent (subst (cons 10 aa)(assoc 10 textent) textent)))
					;(if flag_dynamic (setq textent (subst (cons 10 aa)(assoc 10 textent) textent)));���ö�̬����
	  (entmod textent)
	  );�ڶ�������,�޸�����
      (progn
	(entmake (list '(0 . "TEXT")
		       (cons 1 str)
					;����ƶ���ʱ�򣬸������꣬ʹ���������ƶ����������������ΪͼԪ������
		       (if (= a 5) (cons 10 aa)(cons 10 pt0))
					;(if flag_dynamic (cons 10 aa)(cons 10 pt0))
		       (cons 40 (/ (getvar "viewsize") 30));;�����С,ͬ��ͼ�������
		       (cons 41 0.7) ;;�ָ�
		       (cons 50 0);;����ת�Ƕ�
		       (cons 62 color)
		       )
		 )
	(setq text (entlast) textent (entget text))
	);��һ�����ֲ�����������
      )
    )
					;�ж�ѡ���Ƿ��ΪͬһͼԪ����
  (defun boolean_typeOfSs(ss str_type / ent flag index oba)
    (setq flag T)
    (setq index 0)
    (while (and flag (setq ent (ssname ss index)))
      (setq oba (cdr (assoc 0 (entget ent))))
      (if (not
	   (if (= str_type "*DIMENSION")
	       (wcmatch oba "*DIMENSION")
	     (= oba str_type)
	     )
	   )
	  (setq flag nil)
	)
      (setq index (1+ index))
      )
    flag
    )
					;��Ե�һͼԪ�Ĵ�������
  (defun main_process(ent pt0 / a aa bl color elist flag_circulate flag_dynamic flag_secondclick mouse oba obj point_base)
    (setq elist (entget ent))
    (setq oba (cdr (assoc 0 elist)))
    (setq obj (vlax-ename->vla-object ent))
    (setq flag_dynamic nil);;Ĭ�����ö�̬����
    (setq flag_secondClick nil) ;�ڶ�������������������
    (cond
					;��ñ�ע��ȫ�ֱ���
     ((wcmatch oba "*DIMENSION")
      (if (= (setq bl (vla-get-ScaleFactor (vlax-ename->vla-object ent))) nil) (setq bl 1))
      )
     ((= oba "TEXT") 			 (if (= (setq bl (cdr (assoc 40 elist))) nil) (setq bl 1)))	;ȡ���ָ߶�ֵ��Ϊʵ�ʱ���
     ((= oba "MTEXT") 			 (if (= (setq bl (cdr (assoc 40 elist))) nil) (setq bl 1)))
     ((= oba "REGION")      (if (= (setq bl (cdr (assoc 48 elist))) nil) (setq bl 1)))
     ((= oba "LWPOLYLINE")  (if (= (setq bl (cdr (assoc 48 elist))) nil) (setq bl 1)))
     ((= oba "LINE")        (if (= (setq bl (cdr (assoc 48 elist))) nil) (setq bl 1)))
     ((= oba "CIRCLE")      (if (= (setq bl (cdr (assoc 48 elist))) nil) (setq bl 1)))
     ((= oba "ARC")         (if (= (setq bl (cdr (assoc 48 elist))) nil) (setq bl 1)))
     ((= oba "HATCH")       (setq bl (cdr (assoc 41 elist)))(setq flag_dynamic nil));;ע��,��Ҫ�ر�,��Ϊ��ʼ����Ϊ0
     ((= oba "INSERT")      (setq bl (cdr (assoc 41 elist)))(setq flag_dynamic nil));;ע��,��Ҫ�ر�,��Ϊ��ʼ����Ϊ0
     (t (alert "\nѡ�����..."))
     )
    (if bl
	(progn
	  (setq flag_circulate T)
	  (while flag_circulate
	    (setq mouse (grread T 12 0))
	    (setq a (car mouse) aa (cadr mouse))
	    (cond
					;����d����D�ָ�����һ��
	     ((and (= 2 a) (or (= 100 aa) (= 68 aa)))	;2��ʾ��������,'(2 100)��ʾd��,'(2 68)��ʾD��
	      (setq flag_dynamic nil);;�رն�̬����
	      (setq bl (* bl 2))
	      
	      (bl_update oba bl)
	      
	      (text_update (rtos bl));;��������
	      
	      )
					;����w����W�ָ���Сһ��
	     ((and (= 2 a) (or (= 120 aa) (= 88 aa)))	;2��ʾ��������,'(2 120)��ʾx��,'(2 88)��ʾX��
	      (setq flag_dynamic nil);;�رն�̬����
	      (setq bl (/ bl 2))
					;(if(= oba "INSERT")(if (< 0 (1- bl))(setq bl (1- bl)))(setq bl (/ bl 2)));;�鵥������,�Ӽ�������
					;(if (< bL 0.01)(setq bL 0.01));;��ֹ����Ϊ̫��****************************************
	      (bl_update oba bl)
	      (text_update (rtos bl));;��������
	      )
					;����e����Eָ������
	     ((and (= 2 a) (or (= 101 aa) (= 69 aa)))
	      (setq flag_dynamic nil);;�رն�̬����
	      (setq bl (getreal "\nָ�����ű���:"))
	      (bl_update oba bl)
	      (text_update (rtos bl));;��������
	      )
	     ((and(= a 5) flag_dynamic);����ƶ������ö�̬����
	      (redraw)
	      (grdraw point_base aa 1);������
	      (setq bl(distance point_base aa))
	      (cond
	       ((and(< 0 bl)(< bl 0.1))
		(setq bl(* (fix (/ bl 0.01)) 0.01) color 1);�淶0~1֮��ȡֵ,ģ��=0.1
		)
	       ((and(<= 0.1 bl)(< bl 1))
		(setq bl(* (fix (/ bl 0.1)) 0.1) color 2);�淶0~1֮��ȡֵ,ģ��=0.1
		)
	       ((and(<= 1 bl)(< bl 10))
		(setq bl(* (fix (/ bl 0.5)) 0.5) color 3);�淶1~10֮��ȡֵ,ģ��=0.5
		)
	       ((and(<= 10 bl)(< bl 20))
		(setq bl(fix bl) color 4);�淶10~20֮��ȡֵ,ģ��=1
		)
	       ((and(<= 20 bl)(< bl 100))
		(setq bl(* (fix (/ bl 5)) 5) color 4);�淶20~100֮��ȡֵ,ģ��=5
		)
	       ((<= 100 bl)
		(setq bl(* (fix (/ bl 10)) 10) color 6);�淶20~100֮��ȡֵ,ģ��=10
		)
	       ((= 0 bl) (setq bl 1 color 6))
	       )
					;(if (/= bl_last bl);;�������б仯
					;	(progn
					;		(setq bl_last bl)
					;		(bl_update oba bl);;���±���
					;	)
					;)
	      (bl_update oba bl);;���±���
	      (text_update (rtos bl));;��������
	      )
	     ((and(= a 5) (not flag_dynamic));����ƶ�,�����ö�̬����
	      (text_update (strcat "��ǰ������" (rtos bl 2 2) "\n���Ŵ�(D)/��С(X)/ָ��(E)/��̬(���)/�˳�(�ո�)��"));;��������
	      )
	     ((= a 3)	;������,���ö�̬����
	      (setq flag_dynamic T)
	      (setq point_base aa)
	      (if (= flag_secondClick nil)	;ʶ��ڶ��ε��������
		  (setq flag_secondClick T)
		(setq flag_circulate nil)
		)
	      )
	     ((or
	       (= 25 a) (= 11 a) ;�Ҽ�
	       (and (= a 2) (= aa 13));�س�
	       (and (= a 2) (= aa 32));��ո�
	       )
	      (setq flag_circulate nil)
	      )
	     )
	    )
	  )
      (alert "\n��������Ϊ0")
      )
    (redraw)
    (if text (entdel text));ɾ����ʱ����
    (princ)
    )
					;��ѡ�񼯵�������������Ե����ű���Ϊ��׼
  (defun main_process_batch(ss pt0 / a aa bl color flag_circulate flag_dynamic flag_secondclick list_bl list_ent mouse oba point_base)
    (setq list_ent (pickset_2list ss))
    
    (setq oba (cdr (assoc 0 (entget (nth 0 list_ent)))))
    (cond
     ((or (= oba "REGION") (= oba "LWPOLYLINE") (= oba "LINE") (= oba "CIRCLE") (= oba "ARC"))
      
      
      (setq list_bl (mapcar '(lambda (x) (vla-get-LinetypeScale(vlax-ename->vla-object x))) list_ent) )
      )
     ((= oba "HATCH")
      
      
      (setq list_bl (mapcar '(lambda (x) (vla-get-PatternScale(vlax-ename->vla-object x))) list_ent) )
      )
     ((= oba "INSERT")
      
      (setq list_bl (list 
		     (mapcar '(lambda (x) (vla-get-xscalefactor(vlax-ename->vla-object x))) list_ent)
		     (mapcar '(lambda (x) (vla-get-yscalefactor(vlax-ename->vla-object x))) list_ent)
		     (mapcar '(lambda (x) (vla-get-zscalefactor(vlax-ename->vla-object x))) list_ent)
		     ))
      
      )
     ((or (= oba "TEXT")(= oba "MTEXT"))
      (setq list_bl (mapcar '(lambda (x) (vla-get-Height(vlax-ename->vla-object x))) list_ent) )
      )
     ((wcmatch oba "*DIMENSION")
					;(vla-put-ScaleFactor obj bl)				
      (setq list_bl (mapcar '(lambda (x) (vla-get-ScaleFactor(vlax-ename->vla-object x))) list_ent) )
      )
     )
    
    
    (setq flag_dynamic nil);;Ĭ�����ö�̬����
    (setq flag_secondClick nil) ;�ڶ�������������������
    (setq bl 1)
    (setq flag_circulate T)
    (while flag_circulate
      (setq mouse (grread T 12 0))
      (setq a (car mouse) aa (cadr mouse))
      (cond
					;����q����Q�ָ�����һ��
       ((and (= 2 a) (or (= 100 aa) (= 68 aa)))	;2��ʾ��������,'(2 100)��ʾd��,'(2 68)��ʾD��
	(setq flag_dynamic nil);;�رն�̬����
	(setq bl (* bl 2))
	
	(bl_update_time_batch list_ent list_bl bl)
	(text_update (rtos bl));;��������
	)
					;����w����W�ָ���Сһ��
       ((and (= 2 a) (or (= 120 aa) (= 88 aa)))	;2��ʾ��������,'(2 120)��ʾx��,'(2 88)��ʾX��
	(setq flag_dynamic nil);;�رն�̬����
	(setq bl (/ bl 2))
					;(if(= oba "INSERT")(if (< 0 (1- bl))(setq bl (1- bl)))(setq bl (/ bl 2)));;�鵥������,�Ӽ�������
					;(if (< bL 0.01)(setq bL 0.01));;��ֹ����Ϊ̫��****************************************
	(bl_update_time_batch list_ent list_bl bl)
	(text_update (rtos bl));;��������
	)
					;����e����Eָ������
       ((and (= 2 a) (or (= 101 aa) (= 69 aa)))
	(setq flag_dynamic nil);;�رն�̬����
	(setq bl (getreal "\nָ�����ű���:"))
	(bl_update_time_batch list_ent list_bl bl)
	(text_update (rtos bl));;��������
	)
       ((and(= a 5) flag_dynamic);����ƶ������ö�̬����
	(redraw)
	(grdraw point_base aa 1);������
	(setq bl(distance point_base aa))
	(cond
	 ((and(< 0 bl)(< bl 0.1))
	  (setq bl(* (fix (/ bl 0.01)) 0.01) color 1);�淶0~1֮��ȡֵ,ģ��=0.1
	  )
	 ((and(<= 0.1 bl)(< bl 1))
	  (setq bl(* (fix (/ bl 0.1)) 0.1) color 2);�淶0~1֮��ȡֵ,ģ��=0.1
	  )
	 ((and(<= 1 bl)(< bl 10))
	  (setq bl(* (fix (/ bl 0.5)) 0.5) color 3);�淶1~10֮��ȡֵ,ģ��=0.5
	  )
	 ((and(<= 10 bl)(< bl 20))
	  (setq bl(fix bl) color 4);�淶10~20֮��ȡֵ,ģ��=1
	  )
	 ((and(<= 20 bl)(< bl 100))
	  (setq bl(* (fix (/ bl 5)) 5) color 4);�淶20~100֮��ȡֵ,ģ��=5
	  )
	 ((<= 100 bl)
	  (setq bl(* (fix (/ bl 10)) 10) color 6);�淶20~100֮��ȡֵ,ģ��=10
	  )
	 ((= 0 bl) (setq bl 1 color 6))
	 )
	(bl_update_time_batch list_ent list_bl bl);;���±���
	(text_update (rtos bl));;��������
	)
       ((and(= a 5) (not flag_dynamic));����ƶ�,�����ö�̬����
	(text_update (strcat "��ǰ�仯������" (rtos bl 2 2) "\n���Ŵ�(D)/��С(X)/ָ��(E)/��̬(���)/�˳�(�ո�)��"));;��������
	)
       ((= a 3)	;������,���ö�̬����
	(setq flag_dynamic T)
	(setq point_base aa)
	(if (= flag_secondClick nil)	;ʶ��ڶ��ε��������
	    (setq flag_secondClick T)
	  (setq flag_circulate nil)
	  )
	)
       ((or
	 (= 25 a) (= 11 a) ;�Ҽ�
	 (and (= a 2) (= aa 13));�س�
	 (and (= a 2) (= aa 32));��ո�
	 )
	(setq flag_circulate nil)
	)
       )
      )
    (redraw)
    (if text (entdel text));ɾ����ʱ����
    (princ)
    )
  
  
  (if (setq ss_first (ssget "I"))
					;Ԥ��ѡ������
      (progn
					;����һ�䣬�Ų�Ӱ�����ʹ��ssget����
	(sssetfirst nil)
	(if (= 1 (sslength ss_first))
	    (progn
	      (main_process (ssname ss_first 0) '(0 0 0))
	      )
	  (progn
	    (if (or
		 (boolean_typeOfSs ss_first "*DIMENSION")
		 (boolean_typeOfSs ss_first "TEXT")
		 (boolean_typeOfSs ss_first "MTEXT")
		 (boolean_typeOfSs ss_first "REGION")
		 (boolean_typeOfSs ss_first "LWPOLYLINE")
		 (boolean_typeOfSs ss_first "LINE")
		 (boolean_typeOfSs ss_first "CIRCLE")
		 (boolean_typeOfSs ss_first "ARC")
		 (boolean_typeOfSs ss_first "HATCH")
		 (boolean_typeOfSs ss_first "INSERT")
		 )
		(main_process_batch ss_first '(0 0 0))
	      (main_process (ssname ss_first 0) '(0 0 0))
	      )
	    )
	  )
	)
					;��Ԥ��ѡ������
    (progn
      (if (setq ent (entsel "\nѡ��Ҫ�޸ı�����ͼԪ[���ͱ���][��������][������]/<�˳�>..."))
	  (progn
					;��һ������ΪͼԪ�����ڶ�������Ϊ����ѡ������λ��
	    (main_process (car ent) (cadr ent))
	    )
	)
      )
    )
  
  
					;(error_end)
  )
