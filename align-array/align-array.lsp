;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'align-array:first ���� Ӧ�ð� align-array �� ��һ�������� first 
;;(@:define-config 'align-array:first "���������� align-array:first ��ֵ" "������������;˵����")
;; (@:get-config 'align-array:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'align-array:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "�����ͼ" "��������" "(align-array:align-array)" )
;;==========================================================================����˵��
;;������롢�Ⱦ����в��/����ͼ�����ѡ��/ST-2020.03��
;;˫����벻�����У�ˮƽ�������½�xֵ���������У���ֱ�������½�yֵ���µ������С�
;;����˼·��1������Ժ�����Χ9�㺯���ҵ������ƶ����㡣2�����ݶ�����ʽ�����ƶ��յ㡣3���ƶ������������衣
;;ͼ�򡢷�����ֹ����������öԽǵ���Ϊssget ��ѡ�㣬ȫѡͼֽ���ݺ������ƶ������У�ע��߿�Ҫ�ص���������λ��
;;��ͼֽ˵����ͼ��Ϊ���ѡ2������Ĭ�϶���ͬ���飬��ѡͼ���Ҽ���ȫѡ����ͬ���鹴ѡ�����飬������ѡ��ͼ��Ϊ���Ƿ����ѡ3��Ĭ��ͬ��ͬɫ���ο���Կ���ȫѡ�������ԵĴ򹳵�����ѡ�����������û��ֱ����4 �ֶ���ѡͼֽ���ݣ�ûѡһ�λ�һ�����ο�ѡ���Ҽ���������ѡ�߿�Ȼ��Զ����ñ�׼ͼֽ������
;; /ST-2020.03.06���¡�
;;1�����Ӳ�ͼ����򣬸��ݾ��ο����ָ��ͼ��飬�Զ����ž��У���ÿ��ͼ���ʽ��һ��������ֶ�΢��λ�ã�ѡȡ������������ο�����һ����Ĭ��ͼ���ļ��� D��\A2ͼ��MR.dwg ���½�Ϊ����㣬Ҫ���ձ�׼A2ͼ����594x420mm���ߴ���������Ȼ���ű������Եģ�
;;2��������dcl�Ի�����򣬿ɼ����ϴ���ֵ��
;;3�����䴦��������ϵ������ϵ������룻
;;4����Ⱥ���ʱ���ѡ���ͻ��λ��δ�����
;;==========================================================================
;; /ST-2020.03.09���¡�
;;1,������Ⱥ�鵥�����е����⣻2,���ӱ�ͼͼ����룻
;;3,��������,ֻ���˴����Ҵ��ϵ������У�
;;4,���ӵ�����ѡ.
;;==========================================================================
;; /ST-2020.03.11���¡�
;;1,���� �Զ�/��ѡ ˳�����п��أ�2,���Ӹ�������(�Դ�����)��
;;==========================================================================
;; /ST-2020.03.13���¡�ѡȡ��ʽ�����Զ�ʶ��ͼ��
;;��������ͼ��飬���߷ǿ�ľ������ͼ�����ѡ��Ҫȫ�������Աȣ�����ͼֽ������Ҫʹ�ã�ʹ�ò���ͼֽ�ռ��Ӧ�����ⲻ��
;;==========================================================================
;; /ST-2020.03.18���¡��Զ�ʶ��������ѡ��ֱ�ӿ�ѡ���ɱ߿򣬴���ͼ���á�

;;==========================================================================�Ի����ʽ���루���첻��˵��
(defun align-array:align-array (/ DCL dd ucs)
  (if (= (getvar "WORLDUCS" ) 0) (if (tblsearch "ucs" "ucs_old") (command "ucs" "na" "s" "ucs_old" "y" "ucs" "w") 
				     (command "ucs" "na" "s" "ucs_old" "ucs" "w")) (setq ucs 1))
  (setq DCL (load_dialog (make-dcl-pl))) 
  (new_dialog "rect01" DCL) 

  (if (not cp_xx) (setq cp_xx 0))
  (if (not cp_dx) (setq cp_dx 100))
  (if (not YMK_TMP) (setq YMK_TMP 0))
  (if (not BGX_TMP) (setq BGX_TMP 0))
  (if (not CKB_TMP) (setq CKB_TMP 0))
  (if (not SX_TMP) (setq SX_TMP 0))
  (if (not zdSX_TMP) (setq zdSX_TMP 0))
  (if (not LB_TMP) (setq LB_TMP 1))
  
  (if (not tukuang_TMP) (setq tukuang_TMP 1) ) 	
  (if (not t_lujing) (setq t_lujing "D:\\A2ͼ��MR.dwg"))
  
  (if cp_dx1 (setq cp_xx 1 cp_dx cp_dx1 cp_dx1 nil) );�ж��ֶ�������Ƿ���
  (if tk_BLfile  (setq t_lujing tk_BLfile))
  
  (if (not RB_zhenlieFS) (progn (SETQ RB_zhenlieFS 1)));���з�ʽĬ��
  
					;����ж�
  (if (or (= cp_xx 1) (/= LB_TMP 1)) (mode_tile "row_sxdq" 1))
  (if  (= cp_xx 0)  (mode_tile "cp_d" 1))
  (if  (or (= tukuang_TMP 1) (= tukuang_TMP 2))  (progn (mode_tile "k_lujing" 1) (mode_tile "k_liulan" 1)) )
  
  (if (= RB_zhenlieFS 1) (progn (mode_tile "k_shushu" 1)  (mode_tile "k_tog_zhongdian" 0)) (progn (fuzhizhenlie) (mode_tile "k_shushu" 0)  (mode_tile "k_tog_zhongdian" 1)))
  
  
  
  (if (not t_hengju) (setq t_hengju 100))
  (if (not t_hengshu) (setq t_hengshu 3))
  (if (not t_shuju) (setq t_shuju 100))
  (if (not t_shushu) (setq t_shushu 3))
  (if (not RB_zhenliejianju) (setq RB_zhenliejianju 1))
  
  (if t_hengju_dx (setq t_hengju t_hengju_dx t_hengju_dx nil));�ֶ�ѡ��ำֵ���������������
  (if t_shuju_dx (setq t_shuju t_shuju_dx t_shuju_dx nil))
  
  (if (not RB_paixuFS) (setq RB_paixuFS 1));����ʽ  
  
  (if (not t_tog_zhongdian) (setq t_tog_zhongdian 0));���л���Ĭ��0-���½�
  
  
  (setdate)
  ;;ˮƽ
  (action_tile "dtpl1" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 1)")
  (action_tile "dtpl2" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 2)")
  (action_tile "dtpl3" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 3)")
  ;;��ֱ
  (action_tile "dtpl4" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 4)")
  (action_tile "dtpl5" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 5)")
  (action_tile "dtpl6" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 6)")
  ;;˫��
  (action_tile "dtpl7" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 7)")
  (action_tile "dtpl8" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 8)")
  (action_tile "dtpl9" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 9)")
  (action_tile "dtpl10" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 10)")
  (action_tile "dtpl11" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 11)")
  (action_tile "dtpl12" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 12)")
  (action_tile "dtpl13" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 13)")
  (action_tile "dtpl14" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 14)")
  (action_tile "dtpl15" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 15)")
  ;;����	
  (action_tile "dxjj" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 16)"); ���е�ѡ����
  (action_tile "k_liulan" "(S_RECT) (S_PGON) (S_toggle) (setq t_moren 0) (done_dialog 17)");���
  (action_tile "k_ctk" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 18)");��ͼ��ȷ�ϼ�
  
  (action_tile "k_zlqueding" "(S_RECT) (S_PGON) (S_toggle) (if  (or (= t_hengshu 0) (= t_shushu 0)) (alert \"������������\")  (done_dialog 19))");����ȷ������ 
  
  (action_tile "k_bt_dianxuan" "(S_RECT) (S_PGON) (S_toggle) (done_dialog 20)");���е�ѡ����
  
					;--------------------------------------------------------------------------------��done��Ŀ
  (ACTION_TILE "xlb2" "(MODE_TILE \"row_sxdq\" 1)");���	
  (ACTION_TILE "xlb3" "(MODE_TILE \"row_sxdq\" 1)");���
  (ACTION_TILE "xlb4" "(MODE_TILE \"row_sxdq\" 1)");���
  (ACTION_TILE "xlb5" "(MODE_TILE \"row_sxdq\" 1)");���
  (ACTION_TILE "xlb1" "(S_RECT) (if (= cp_xx 0) (MODE_TILE \"row_sxdq\" 0))");�ָ�	
  (action_tile "cp_x" "(S_RECT) (if (= cp_xx 1) (progn (mode_tile \"cp_d\" 0) (mode_tile \"row_sxdq\" 1)) (progn (mode_tile \"cp_d\" 1) (if (= xlb1 1) (mode_tile \"row_sxdq\" 0))))")
  (action_tile "k_moren" "(S_RECT) (mode_tile \"k_lujing\" 1) (mode_tile \"k_liulan\" 1)")
  (action_tile "k_tuzhong" "(S_RECT) (mode_tile \"k_lujing\" 1) (mode_tile \"k_liulan\" 1)")
  (action_tile "k_chawenjian" "(S_RECT) (mode_tile \"k_lujing\" 0) (mode_tile \"k_liulan\" 0)")
					;(action_tile "k_zlqueding" "(S_RECT) (S_PGON) (S_toggle) (if  (= t_hengshu 0) (alert \"������������\") )")
  (action_tile "k_rb_chongpaizhenlie" "(S_RECT) (chongpaizhenlie) (mode_tile \"k_shushu\" 1) (mode_tile \"k_rb_zuoxia\" 0) (mode_tile \"k_tog_zhongdian\" 0) (mode_tile \"k_paixuFS\" 0)")
  (action_tile "k_rb_fuzhizhenlie" "(S_RECT) (fuzhizhenlie) (mode_tile \"k_shushu\" 0) (mode_tile \"k_rb_zuoxia\" 1) (mode_tile \"k_tog_zhongdian\" 1) (mode_tile \"k_paixuFS\" 1)")
					;--------------------------------------------------------------------------------

  (setq dd (start_dialog ))
  (cond
    
    ((= dd 1) (cond ((= LB_TMP 1) (if (= cp_xx 1) (S_PLcx 0 7 9 0) (S_DQcx 0 9)));����
		    ((= LB_TMP 2) (if (= cp_xx 1) (tukuang_BK 0 x 7 9 0) (tukuang_BK 0 9 x x x)));ͼ���
		    ((= LB_TMP 3) (if (= cp_xx 1) (juxing_WL 0 x 7 9 0) (juxing_WL 0 9 x x x)));���ο�
		    ((= LB_TMP 4) (if (= cp_xx 1) (select_SG 0 x 7 9 0) (select_SG 0 9 x x x)));�ֹ�ѡ
		    ((= LB_TMP 5) (if (= cp_xx 1) (zidongshibie_WL 0 x 7 9 0) (zidongshibie_WL 0 9 x x x)));�Զ�ʶ��
		    )) 		
    ((= dd 2) (cond ((= LB_TMP 1) (if (= cp_xx 1) (S_PLcx 0 4 6 0) (S_DQcx 0 5)));����
		    ((= LB_TMP 2) (if (= cp_xx 1) (tukuang_BK 0 x 4 6 0) (tukuang_BK 0 5 x x x)));ͼ���
		    ((= LB_TMP 3) (if (= cp_xx 1) (juxing_WL 0 x 4 6 0) (juxing_WL 0 5 x x x)));���ο�
		    ((= LB_TMP 4) (if (= cp_xx 1) (select_SG 0 x 4 6 0) (select_SG 0 5 x x x)));�ֹ�ѡ
		    ((= LB_TMP 5) (if (= cp_xx 1) (zidongshibie_WL 0 x 4 6 0) (zidongshibie_WL 0 5 x x x)));�Զ�ʶ��
		    ))
    
    ((= dd 3) (cond ((= LB_TMP 1) (if (= cp_xx 1) (S_PLcx 0 1 3 0) (S_DQcx 0 1)));����
		    ((= LB_TMP 2) (if (= cp_xx 1) (tukuang_BK 0 x 1 3 0) (tukuang_BK 0 1 x x x)));ͼ���
		    ((= LB_TMP 3) (if (= cp_xx 1) (juxing_WL 0 x 1 3 0) (juxing_WL 0 1 x x x)));���ο�
		    ((= LB_TMP 4) (if (= cp_xx 1) (select_SG 0 x 1 3 0) (select_SG 0 1 x x x)));�ֹ�ѡ
		    ((= LB_TMP 5) (if (= cp_xx 1) (zidongshibie_WL 0 x 1 3 0) (zidongshibie_WL 0 1 x x x)));�Զ�ʶ��
		    ))
    
    
    
    ((= dd 4) (cond ((= LB_TMP 1) (if (= cp_xx 1) (S_PLcx 1 1 7 (* 0.5 pi)) (S_DQcx 1 1)));����
		    ((= LB_TMP 2) (if (= cp_xx 1) (tukuang_BK 1 x 1 7 (* 0.5 pi)) (tukuang_BK 1 1 x x x)));ͼ���
		    ((= LB_TMP 3) (if (= cp_xx 1) (juxing_WL 1 x 1 7 (* 0.5 pi)) (juxing_WL 1 1 x x x)));���ο�
		    ((= LB_TMP 4) (if (= cp_xx 1) (select_SG 1 x 1 7 (* 0.5 pi)) (select_SG 1 1 x x x)));�ֹ�ѡ
		    ((= LB_TMP 5) (if (= cp_xx 1) (zidongshibie_WL 1 x 1 7 (* 0.5 pi)) (zidongshibie_WL 1 1 x x x)));�Զ�ʶ��
		    ))
    
    ((= dd 5) (cond ((= LB_TMP 1) (if (= cp_xx 1) (S_PLcx 1 2 8 (* 0.5 pi)) (S_DQcx 1 5)));����
		    ((= LB_TMP 2) (if (= cp_xx 1) (tukuang_BK 1 x 2 8 (* 0.5 pi)) (tukuang_BK 1 5 x x x)));ͼ���
		    ((= LB_TMP 3) (if (= cp_xx 1) (juxing_WL 1 x 2 8 (* 0.5 pi)) (juxing_WL 1 5 x x x)));���ο�
		    ((= LB_TMP 4) (if (= cp_xx 1) (select_SG 1 x 2 8 (* 0.5 pi)) (select_SG 1 5 x x x)));�ֹ�ѡ	
		    ((= LB_TMP 5) (if (= cp_xx 1) (zidongshibie_WL 1 x 2 8 (* 0.5 pi)) (zidongshibie_WL 1 5 x x x)));�Զ�ʶ��	
		    ))
    
    ((= dd 6) (cond ((= LB_TMP 1) (if (= cp_xx 1) (S_PLcx 1 3 9 (* 0.5 pi)) (S_DQcx 1 9)));����
		    ((= LB_TMP 2) (if (= cp_xx 1) (tukuang_BK 1 x 3 9 (* 0.5 pi)) (tukuang_BK 1 9 x x x)));ͼ���
		    ((= LB_TMP 3) (if (= cp_xx 1) (juxing_WL 1 x 3 9 (* 0.5 pi)) (juxing_WL 1 9 x x x)));���ο�
		    ((= LB_TMP 4) (if (= cp_xx 1) (select_SG 1 x 3 9 (* 0.5 pi)) (select_SG 1 9 x x x)));�ֹ�ѡ	
		    ((= LB_TMP 5) (if (= cp_xx 1) (zidongshibie_WL 1 x 3 9 (* 0.5 pi)) (zidongshibie_WL 1 9 x x x)));�Զ�ʶ��
		    ))	
    
    ((= dd 7) (S_DQcx 2 7))
    ((= dd 8) (S_DQcx 2 4))
    ((= dd 9) (S_DQcx 2 1))
    ((= dd 10) (S_DQcx 2 8))
    ((= dd 11) (S_DQcx 2 5))
    ((= dd 12) (S_DQcx 2 2))
    ((= dd 13) (S_DQcx 2 9))
    ((= dd 14) (S_DQcx 2 6))
    ((= dd 15) (S_DQcx 2 3))
    
    ((= dd 16) (S_RECT2)) ;;���е�ѡ���
    ((= dd 17) (setq tk_BLfile (getfiled "ѡ��ͼ���ļ�" "C:/Users/Administrator/Desktop/" "dwg" 16)) (c:ent_DQPL))
    ((= dd 18) (cond  ((= tukuang_TMP 1) (chatukuang "D:\\A2ͼ��MR.dwg"))
		      ((= tukuang_TMP 2) (chatukuang_tuzhong))
		      ((= tukuang_TMP 3) (chatukuang t_lujing))))
    
    ((= dd 19)  (if (= RB_zhenlieFS 1) (if (= LB_TMP 1) (cond  ((= RB_zhenliejianju 1) ( zhenlie_DT t_hengju t_shuju t_hengshu 1))
							       ((= RB_zhenliejianju 2) ( zhenlie_DT t_hengju t_shuju t_hengshu 2)))
					   (cond  ((= RB_zhenliejianju 1) ( zhenlie_SS t_hengju t_shuju t_hengshu 1))
						  ((= RB_zhenliejianju 2) ( zhenlie_SS t_hengju t_shuju t_hengshu 3)))
					   );if1
		    (zhenlie_FUZHI t_shushu  t_hengshu  t_shuju  t_hengju)
		    );if2
     
     
     )
    ((= dd 20)	(S_RECT3))	;;���е�ѡ���					
    
    
    );cond
  (if (not ucs) (command "ucs" "na" "r" "ucs_old"))
  (princ)
  )
;;==========================================================================��������
;;��ȡ��ѡ�����ž���ֵ
(DEFUN S_RECT()
  (SETQ cp_dx (ABS (ATOF (GET_TILE "cp_d"))) ;���ֵ
	cp_xx (atoi (GET_TILE "cp_x")) ;���ſ���ֵ
	xlb1  (atoi (GET_TILE "xlb1")));��𿪹�ֵ
					;t_moren  (atoi (GET_TILE "k_moren"));Ĭ��ͼ�򿪹�ֵ
  (COND ((= (GET_TILE "k_moren") "1") (SETQ tukuang_TMP 1))
        ((= (GET_TILE "k_tuzhong") "1") (SETQ tukuang_TMP 2))
	((= (GET_TILE "k_chawenjian") "1") (SETQ tukuang_TMP 3))
	);ͼ�����     
  (setq t_hengju (ATOF (GET_TILE "k_hengju")) 
	t_hengshu (atoi (GET_TILE "k_hengshu"))
        t_shuju (ATOF (GET_TILE "k_shuju"))
	t_shushu (atoi (GET_TILE "k_shushu"))
	)
  (COND ((= (GET_TILE "k_rb_zhongzhong") "1") (SETQ RB_zhenliejianju 1))
        ((= (GET_TILE "k_rb_bianbian") "1") (SETQ RB_zhenliejianju 2))
	
	);���м�෽ʽ 
  (COND ((= (GET_TILE "k_rb_zidong") "1") (SETQ RB_paixuFS 1))
        ((= (GET_TILE "k_rb_xuanxu") "1") (SETQ RB_paixuFS 2))
	
	);����ʽ
  (COND ((= (GET_TILE "k_rb_chongpaizhenlie") "1") (SETQ RB_zhenlieFS 1))
        ((= (GET_TILE "k_rb_fuzhizhenlie") "1") (SETQ RB_zhenlieFS 2))
	
	);���з�ʽ t_tog_zhongdian
  
  (setq t_tog_zhongdian (atoi (GET_TILE "k_tog_zhongdian")));���ж������
  
  )
(defun S_RECT2 (/ pdx1);;ѡ�㶨�ຯ��(����)
  (setq cp_dx1 (distance (setq pdx1(getpoint)) (getpoint pdx1)))
  (c:ent_DQPL)
  )
(defun S_RECT3 (/ pdx1);;ѡ�㶨�ຯ��(����); 
  (setq p1(getpoint "\nѡȡ1�㣺") p2 (getcorner p1"\nѡȡ2��(X��=��࣬Y��=����)��"))
  (setq t_hengju_dx (abs (- (car p1) (car p2))) t_shuju_dx (abs (- (cadr p1) (cadr p2))))
  (c:ent_DQPL)
  )
;; Ժ������ / �����9�����ꣻ�ڴ˳����з��ӹؼ�����
(defun ss9pt (ss n / ss i s1 ll rr box ptn a p1 p2 p3 p4 p5 p6 p7 p8 p9)

  (progn ss
	 (setq i -1)
	 (repeat (sslength ss)
		 (setq s1 (ssname ss (setq i (1+ i))))
		 (vla-GetBoundingBox (vlax-ename->vla-object s1) 'll 'rr)
		 (setq box (list (vlax-safearray->list ll) (vlax-safearray->list rr))
		       ptn (append box ptn)
		       )
		 )
	 (setq a  (mapcar '(lambda (x) (apply 'mapcar (cons x ptn))) (list 'min 'max))
	       p1 (car a)
	       p9 (cadr a)
	       p5 (mapcar '(lambda (x y) (* (+ x y) 0.5)) p1 p9)
	       p2 (list (car p5) (cadr p1))
	       p3 (list (car p9) (cadr p1))
	       p4 (list (car p1) (cadr p5))
	       p6 (list (car p9) (cadr p5))
	       p7 (list (car p1) (cadr p9))
	       p8 (list (car p5) (cadr p9))
	       )
	 (nth (- n 1) (list p1 p2 p3 p4 p5 p6 p7 p8 p9))
	 )
  )
;;ѡ��=>>����
(defun SStoLST (ss / i entname lst)
  (setq i -1)
  (if ss
      (while (setq entname (ssname ss(setq i(1+ i))))
	(setq lst (cons entname lst))))
  (reverse lst)
  )

(defun setdate ();;����dcl����ֵ 
  (set_tile "cp_x" (rtos cp_xx 2 2))
  (set_tile "cp_d" (rtos cp_dx 2 2))
  (set_tile "toggle_ymk" (rtos YMK_TMP 2 2))
  (set_tile "toggle_bgx" (rtos BGX_TMP 2 2))
  (set_tile "toggle_ckb" (rtos CKB_TMP 2 2)) 
  (set_tile "toggle_sx" (rtos SX_TMP 2 2))
  (set_tile "toggle_sx2" (rtos zdSX_TMP 2 2))
  
  (cond  ((= LB_TMP 1) (set_tile "xlb1" "1"))
	 ((= LB_TMP 2) (set_tile "xlb2" "1"))
	 ((= LB_TMP 3) (set_tile "xlb3" "1"))
	 ((= LB_TMP 4) (set_tile "xlb4" "1"))
	 ((= LB_TMP 5) (set_tile "xlb5" "1"))
	 )
  (cond  ((= tukuang_TMP 1) (set_tile "k_moren" "1"))
	 ((= tukuang_TMP 2) (set_tile "k_tuzhong" "1"))
	 ((= tukuang_TMP 3) (set_tile "k_chawenjian" "1"))		     
	 )
  (set_tile "k_lujing" t_lujing)

  (set_tile "k_hengju" (rtos t_hengju 2 2))
  (set_tile "k_hengshu" (rtos t_hengshu 2 0))
  (set_tile "k_shuju" (rtos t_shuju 2 2))
  (set_tile "k_shushu" (rtos t_shushu 2 0))
  (cond  ((= RB_zhenliejianju 1) (set_tile "k_rb_zhongzhong" "1"))
	 ((= RB_zhenliejianju 2) (set_tile "k_rb_bianbian" "1"))		    
	 );���м�෽ʽ
  (cond  ((= RB_paixuFS 1) (set_tile "k_rb_zidong" "1"))
	 ((= RB_paixuFS 2) (set_tile "k_rb_xuanxu" "1"))		    
	 );����ʽ
  (cond  ((= RB_zhenlieFS 1) (set_tile "k_rb_chongpaizhenlie" "1"))
	 ((= RB_zhenlieFS 2) (set_tile "k_rb_fuzhizhenlie" "1"))		    
	 );���з�ʽ
  (set_tile "k_tog_zhongdian" (rtos t_tog_zhongdian 2 2));���ж������-Ĭ�����½�
  
  )

(defun fuzhizhenlie ();�㸴������ѡ���Ҵ��� 
  (mode_tile "k_no1" 1)	
  (mode_tile "k_no2" 1)
  (mode_tile "k_shuipingduiqi" 1)
  (mode_tile "k_chuizhiduiqi" 1)
  (mode_tile "k_dengju,dianxuan" 1)
					;(mode_tile "k_zlqueding" 1)
  (mode_tile "row_sxdq" 1)
  )
(defun chongpaizhenlie ();����������ѡ��������� 
  (S_PGON) (S_RECT)	
  (mode_tile "k_no1" 0)	
  (mode_tile "k_no2" 0)
  (mode_tile "k_shuipingduiqi" 0)
  (mode_tile "k_chuizhiduiqi" 0)
  (mode_tile "k_dengju,dianxuan" 0)	
					;(mode_tile "k_zlqueding" 0)
  (if (and (= LB_TMP 1) (= cp_xx 0)) (mode_tile "row_sxdq" 0))
  )
;;==========================================================================��������
;;�������������,/ H-S=0��ˮƽ / H-S=1����ֱ / H-S=2:˫�� / 9NB:�ƶ����� /
(defun S_DQcx (H-S 9NB / ang entdate entname gpname gpname_lst gpss_lst gx_list i nb nb0 p0 p1 p1a p2 pick_date ss ss_gp ss_gp_temp ss-9 ssall sslst sslst_px)
  (command "undo" "be");������ʼ�㣬���������������ó������ã���Ȼһ�������˺��鷳��
  (prompt "\nѡ�����:"); ssget ���治�ܴ�����˵��������ǰ������ prompt ������ʾ��

  
  (if (= SX_TMP 1)
      (progn (setq  pick_date (entget (car (entsel "\n��ѡԴ����:"))) GX_list '())
	     
	     (if (= (cdr (assoc 0 pick_date)) "INSERT")  
		 (setq  GX_list (list (assoc 0 pick_date) (assoc 2 pick_date)));ͼ����
		 (progn (setq  GX_list (list (assoc 0 pick_date) (assoc 8 pick_date))) (if (assoc 62 pick_date) (setq GX_list (cons  (assoc 62 pick_date) GX_list))));������
		 
		 );;�ռ���������
	     
	     (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
	     (if (not (setq ssall (ssget GX_list))) (setq ssall (ssget "x"  GX_list)));;����ѡ��(ͬ�㡢ͬɫ)
	     
	     (sssetfirst nil ssall)
	     (setq  ss_gp (ssadd) ss (ssadd))
	     
	     );progn
      
      (setq ssall (ssget) ss_gp (ssadd) ss (ssadd)));if ;ss_gp:ȫ������Ⱥ���Ա��ѡ��
  
  ;;�ж�Ⱥ��
					;����������������������������������������������������������������������������������������������������������������
  (setq i -1 GPname_lst '()) 
  (while (setq entname (ssname ssall (setq i (1+ i))))	  
    (if (= (cdr (assoc 102 (setq entdate (entget entname)))) "{ACAD_REACTORS") (progn (setq GPname (cdr (assoc 330 entdate))) (setq ss_gp (ssadd entname ss_gp))) (setq ss (ssadd entname ss)))
    (if (not (member GPname GPname_lst)) (setq GPname_lst (cons GPname GPname_lst)));Ⱥ�����ı�
    );while 
					;(sssetfirst nil ss);����ss
					;����������������������������������������������������������������������������������������������������������������
  ;; ����ssѡ������
  (setq p0 (getpoint "\nѡ��������<�˳�>: "));getpoint �Ⱥܶຯ��������Խ�˵����\n ���кţ������лỻһ������ʾ��
  (setq i -1);Ϊ��������� ssname ������ı�������һ��������Ϊ 0��������Ϊ -1��
  (while (setq entname (ssname ss (setq i (1+ i))));while ��ѡ��ȫ��������ѭ������Ҳ������ repeat ����������
    (setq ss-9 (ssadd) ss-9 (ssadd entname ss-9))
    (setq  p1 (ss9pt ss-9 9NB));9NB�Ǵ˺�������֮һ�����Ƕ����9��֮һ���ƶ�����p1�������ݶ�����ʽѡȡ��
    (cond ((= H-S 0) (setq p2 (list (car p1) (cadr p0))));H-SҲ�ǲ���֮һ���������������ƶ���Ŀ��� p2
	  ((= H-S 1) (setq p2 (list (car p0) (cadr p1))))
	  ((= H-S 2) (setq p2 p0));˫�����ʱ��ѡ�ĵ�p0����Ŀ���p2
	  )
    (command "MOVE" entname "" "non" p1 "non" p2);�ƶ��������
    );while
					;����������������������������������������������������������������������������������������������������������������
  ;;Ⱥ�������
  (if ss_gp (progn 
	      (setq GPss_lst '());GPss_lst-�������ѡ�� �б� 
	      (foreach x GPname_lst
		       (setq i -1 ss_gp_temp (ssadd)) ;ss_gp_temp-��ʱѡ�� 
		       (while (setq entname (ssname ss_gp (setq i (1+ i))))      
			 (if (equal (cdr (assoc 330  (entget entname))) x) (setq ss_gp_temp (ssadd entname ss_gp_temp)))				
			 );while
		       (setq GPss_lst (cons ss_gp_temp GPss_lst))			
		       );foreach1																			
	      
	      (foreach x GPss_lst
		       
		       (if (/= (sslength x) 0)
			   (progn (setq  p1 (ss9pt x 9NB)) 
				  (cond ((= H-S 0) (setq p2 (list (car p1) (cadr p0)))) 
					((= H-S 1) (setq p2 (list (car p0) (cadr p1))))
					((= H-S 2) (setq p2 p0)) 
					)
				  (command "MOVE" x "" "non" p1 "non" p2) ))
		       
		       );foreach2	
	      
	      );progn
      );if
					; ����������������������������������������������������������������������������������������������������������������	
  (command "undo" "e");���������㣬�뿪ʼ��֮��Ĳ���һ���������
  (princ);����Ǳ����
  );����
;;==========================================================================
;;��������������,/ H-S=0��ˮƽ / H-S=1����ֱ / ang:ˮƽ0����ֱ90�� / NB:�����ƶ����� / NB0: �ƶ�Ŀ���(ѡȡ���ʵ�9��֮һ������)
(defun S_PLcx (H-S NB NB0 ang / entname i p0 p1a ss sslst sslst_px ss-9)
  (command "undo" "be");ͬ��
  
  (if (= SX_TMP 1)
      (progn (setq  pick_date (entget (car (entsel "\n��ѡԴ����:"))) GX_list '())
	     
	     (if (= (cdr (assoc 0 pick_date)) "INSERT")  
		 (setq  GX_list (list (assoc 0 pick_date) (assoc 2 pick_date)));ͼ����
		 (progn (setq  GX_list (list (assoc 0 pick_date) (assoc 8 pick_date))) (if (assoc 62 pick_date) (setq GX_list (cons  (assoc 62 pick_date) GX_list))));������
		 
		 );;�ռ���������
	     
	     (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
	     (if (not (setq ssall (ssget GX_list))) (setq ssall (ssget "x"  GX_list)));;����ѡ��(ͬ�㡢ͬɫ)
	     
	     (sssetfirst nil ssall)
	     (setq  ss_gp (ssadd) ss (ssadd))
	     
	     );progn
      
      (setq ssall (ssget) ss_gp (ssadd) ss (ssadd)));if ;ss_gp:ȫ������Ⱥ���Ա��ѡ��
  
  ;;�ж�Ⱥ��
					;����������������������������������������������������������������������������������������������������������������	 
  (setq i -1 GPname_lst '()) 
  (while (setq entname (ssname ssall (setq i (1+ i))))	  
    (if (= (cdr (assoc 102 (setq entdate (entget entname)))) "{ACAD_REACTORS") (progn (setq GPname (cdr (assoc 330 entdate))) (setq ss_gp (ssadd entname ss_gp))) (setq ss (ssadd entname ss)))
    (if (not (member GPname GPname_lst)) (setq GPname_lst (cons GPname GPname_lst)));Ⱥ�����ı�
    );while
					;����������������������������������������������������������������������������������������������������������������
  ;; ����ssѡ������		
  (setq p0 (getpoint "\nѡ��������<�˳�>: "));���е����
  (setq sslst (SStoLST ss));;ѡ��ת�ɱ��Ա������������
					;�Ⱦ�������ʵ������������ԭ��һ��������Ҫ��ѡ����������һ�£���Ȼ���ң���Ϊ������ƶ��յ��Ǹ���ǰ�������ģ�������ֻҪ�����Լ���λ������С�
  
  ������������������������������������������������������������������������
  (if (= RB_paixuFS 1) (cond ((= H-S 0) (setq sslst_px (vl-sort sslst '(lambda (a b) (< (car (car (enbox a))) (car (car (enbox b))))))));;����ʱ������1���xֵС�������򣬵õ��±�
		             ((= H-S 1) (setq sslst_px (vl-sort sslst '(lambda (a b) (< (cadr (car (enbox a))) (cadr (car (enbox b))))))));;����ʱ������1���yֵС�������򣬵õ��±�
	                     );cond  �Զ�����
      
      (setq sslst_px sslst);;��ѡ��˳������
      );if
  
  
  ������������������������������������������������������������������������	
  (setq i 0);����ѭ�����i��0��������-1��һ��Ч�������Ǵӱ��0��ʼ
  (repeat (length sslst_px);��������repeat������ע����������Ǳ��Ա�һ������ while �Ķ�����ѡ�����ᷢ��ԭ��һ�������õ��ĺ�����һ��
	  (setq entname (nth i sslst_px)) 
	  (setq ss-9 (ssadd) ss-9 (ssadd entname ss-9)
		p1a (ss9pt ss-9 NB));�ƶ�����
	  
	  (command "MOVE" entname "" "non" p1a "non" p0);�ƶ�����
					;(if (not cp_dx1) (setq cp_dx1 cp_dx));���ǶԻ����һЩ����
	  
	  (setq p0 (polar (ss9pt ss-9 NB0) ang cp_dx) i (1+ i))	;�����Ǽ�����һ��������ƶ��յ�(p0���¸�ֵ��ѭ��ʹ��)
	  );repeat
					;����������������������������������������������������������������������������������������������������������������
  ;;Ⱥ�������
  (if ss_gp (progn 	 																	
	      (setq GPss_lst '());GPss_lst-�������ѡ�� �б� 
	      
	      (foreach x GPname_lst
		       (setq i -1 ss_gp_temp (ssadd)) ;ss_gp_temp-��ʱѡ�� 
		       (while (setq entname (ssname ss_gp (setq i (1+ i))))      
			 (if (equal (cdr (assoc 330  (entget entname))) x) (setq ss_gp_temp (ssadd entname ss_gp_temp)))				
			 );while
		       (if (/= (sslength ss_gp_temp) 0) (setq GPss_lst (cons ss_gp_temp GPss_lst)))			
		       );foreach1																			
	      
	      (cond ((= H-S 0) (setq sslst_px (vl-sort GPss_lst '(lambda (a b) (< (car (ss9pt a 1)) (car (ss9pt b 1)))))));;����ʱ������1���xֵС�������򣬵õ��±�
		    ((= H-S 1) (setq sslst_px (vl-sort GPss_lst '(lambda (a b) (< (cadr (ss9pt a 1)) (cadr (ss9pt b 1)))))));;����ʱ������1���yֵС�������򣬵õ��±�
	            );cond
	      (princ GPss_lst	) (princ)
	      (setq i 0) 
	      (repeat (length sslst_px)
		      (setq entname (nth i sslst_px))			               
		      (if (/= (sslength entname) 0)      
			  (progn (setq  p1a (ss9pt entname NB)) 		
		                 (command "MOVE" entname "" "non" p1a "non" p0) 
				 (setq p0 (polar (ss9pt entname NB0) ang cp_dx)));progn
			  );if
		      (setq i (1+ i))
		      );repeat														
	      );progn
      );if
					;����������������������������������������������������������������������������������������������������������������			
  (command "undo" "e");ͬ��
					;(setq cp_dx1 nil);���ǶԻ����
  (princ)
  )


;; ���²������0303 ��������������������������������������������������������������������������������������������������������������������������������

;;==========================================================================��������
(DEFUN S_PGON () ;;���ѡ����
  (COND ((= (GET_TILE "xlb1") "1") (SETQ LB_TMP 1))
	((= (GET_TILE "xlb2") "1") (SETQ LB_TMP 2))
	((= (GET_TILE "xlb3") "1") (SETQ LB_TMP 3))
	((= (GET_TILE "xlb4") "1") (SETQ LB_TMP 4))
	((= (GET_TILE "xlb5") "1") (SETQ LB_TMP 5))
	)	
  )

(DEFUN S_toggle () ;;��ѡ�������顢�����ԡ������ ��ѡ���غ��� 
  (COND ((= (GET_TILE "toggle_ymk") "1") (SETQ YMK_TMP 1))
	((= (GET_TILE "toggle_ymk") "0") (SETQ YMK_TMP 0))
	
	) 
  (COND ((= (GET_TILE "toggle_bgx") "1") (SETQ BGX_TMP 1))
	((= (GET_TILE "toggle_bgx") "0") (SETQ BGX_TMP 0))
	)
  (COND ((= (GET_TILE "toggle_ckb") "1") (SETQ CKB_TMP 1))
	((= (GET_TILE "toggle_ckb") "0") (SETQ CKB_TMP 0))
	)
  (COND ((= (GET_TILE "toggle_sx") "1") (SETQ SX_TMP 1))
	((= (GET_TILE "toggle_sx") "0") (SETQ SX_TMP 0))
	)
  (COND ((= (GET_TILE "toggle_sx2") "1") (SETQ zdSX_TMP 1))
	((= (GET_TILE "toggle_sx2") "0") (SETQ zdSX_TMP 0))
	)
  )

(defun enbox (ename / ll ur);�������Խǵ㺯�� 
  (vla-getboundingbox (vlax-ename->vla-object ename) 'll 'ur)
  (mapcar 'vlax-safearray->list (list ll ur)))

(defun DQ_BK (SS_lst H-S 9NB / i p0 p1 p2 ss-name ss-9);ѡ�����-���뺯��
  (setq p0 (getpoint "\nѡ��������<�˳�>: "))
  (command "-layer" "u" (setq suo_str (layer_suo_str)) "");����
  (setq i -1)	
  (while (setq ss-name (car (nth (setq i (1+ i)) SS_lst)));��ȡ��Ԫ���е� ѡ��
    (setq ss-9 (ssadd) ss-9 (ssadd (caddr (nth i SS_lst)) ss-9))
    (setq  p1 (ss9pt ss-9 9NB));9NB�Ǵ˺�������֮һ�����Ƕ����9��֮һ���ƶ�����p1�������ݶ�����ʽѡȡ��
    (cond ((= H-S 0) (setq p2 (list (car p1) (cadr p0))));H-SҲ�ǲ���֮һ���������������ƶ���Ŀ��� p2
	  ((= H-S 1) (setq p2 (list (car p0) (cadr p1))))
	  ((= H-S 2) (setq p2 p0));˫�����ʱ��ѡ�ĵ�p0����Ŀ���p2
	  )
    (command "MOVE" ss-name "" "non" p1 "non" p2);�ƶ��������
    );while 	
  (command "-layer" "lo"  suo_str  "");������	
  )

(defun PL_BK (SS_lst H-S NB NB0 ang / i p0 p1a ss-name ss-9);ѡ�����-���к���
  (setq p0 (getpoint "\nѡ��������<�˳�>: "))
  (command "-layer" "u" (setq suo_str (layer_suo_str)) "");����	
  (setq i -1)	
  (while (setq ss-name (car (nth (setq i (1+ i)) SS_lst)));��ȡ��Ԫ���е� ѡ��
    (setq ss-9 (ssadd) ss-9 (ssadd (caddr (nth i SS_lst)) ss-9))
    (setq  p1a (ss9pt ss-9 NB))
    
    (command "MOVE" ss-name "" "non" p1a "non" p0);�ƶ��������
    
					;(if (not cp_dx1) (setq cp_dx1 cp_dx));���ǶԻ����һЩ����
    
    (setq p0 (polar (ss9pt ss-9 NB0) ang cp_dx))	;�����Ǽ�����һ��������ƶ��յ�(p0���¸�ֵ��ѭ��ʹ��)
    );while 
  (command "-layer" "lo"  suo_str  "");������	
  (princ)	
  )

(defun mid_pt (p1 p2);;���ĺ���
  (mapcar'*(mapcar'+ p1 p2)'(0.5 0.5 0.5))
  )

(defun ckb_rec (p1 p2 / p1x p1y p2x p2y p3 rec ss-9);;�ֹ�ѡ��ѡ����ȴ�����κ���
  (setq p1x (car p1) p1y (cadr p1)
	p2x (car p2) p2y (cadr p2)
	)
  (if (<= (abs (/ (- p2x p1x) 420)) (abs (/ (- p1y p2y) 297)))
      (setq p3 (polar (polar p1 0 (abs (* (/ (- p1y p2y) 297) 420))) (* 1.5 pi) (abs(- p1y p2y))))
      (setq p3  (polar (polar p1 0 (abs(- p2x p1x))) (* 1.5 pi) (abs (/ (* (- p2x p1x) 297) 420))))	
      );if	
  (command "RECTANG" "non" p1 "non" p3 "CHANGE" (setq rec (entlast)) "" "p" "c" 224 "")	
  (setq ss-9 (ssadd) ss-9 (ssadd rec ss-9))	
  (command "MOVE" rec "" "non" (ss9pt ss-9 5) "non" (mid_pt p1 p2))
  rec	
  )

(defun layer_suo_str (/ laylst_suo lays_jh str);;����ͼ�������ַ������
  (setq lays_jh (vla-get-layers (vla-get-activedocument (vlax-get-Acad-Object))));�ĵ�ͼ�㼯��
  (vlax-for x lays_jh
	    (if (= (vla-get-lock x) :vlax-true)		
		(SETQ laylst_suo (APPEND laylst_suo (LIST (vla-get-Name x)))));������ͼ������
	    )
  (setq str "")
  (foreach x laylst_suo
	   (setq str (strcat "," x str))
	   )
  (substr str 2)
  )

(defun chatukuang (tk_blfile / entname gx_list i pick_date pt scale ss_tk ss-9 ss-9a );;��ͼ��������
  (command "undo" "be")
					;(setq tk_BLfile (getfiled "ѡ��ͼ���ļ�" "" "dwg" 8))
  (setvar "INSUNITS" 4)
  (setq  pick_date (entget (car (entsel "\n��ѡ���ο�:"))) GX_list '() GX_list (list (assoc 0 pick_date) (assoc 8 pick_date) (assoc 70 pick_date))) (if (assoc 62 pick_date) (setq GX_list (cons  (assoc 62 pick_date) GX_list)))
  (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
  (if (not (setq ss_tk (ssget GX_list))) (setq ss_tk (ssget "x"  GX_list)))
  (setq i -1) 
  (while (setq entname (ssname ss_tk (setq i (1+ i))))
    (setq ss-9 (ssadd) ss-9 (ssadd entname ss-9) pt (ss9pt ss-9 1))
    (if (<= (/ (distance (ss9pt ss-9 1) (ss9pt ss-9 3)) (distance (ss9pt ss-9 1) (ss9pt ss-9 7))) (/ 594. 420)) (setq scale (/ (distance (ss9pt ss-9 1) (ss9pt ss-9 7)) 420.))  (setq scale (/ (distance (ss9pt ss-9 1) (ss9pt ss-9 3)) 594.)));if
    (command "INSERT" tk_BLfile "non" pt scale "" 0  "move" (setq ss-9a (ssadd) ss-9a (ssadd (entlast) ss-9a)) "" "non" (ss9pt ss-9a 5) "non" (ss9pt ss-9 5))
    (entdel entname)
    );while	
  (command "undo" "e")
  (princ)
  )

(defun chatukuang_tuzhong (/ entname gx_list i pick_date pt5a pt5b scale ss_tk ss-9 tukuang_block);;��ͼ��������-ͼ�п�
  (command "undo" "be")
  (setq tukuang_block (ssget ":s" (list '(0 . "insert"))) pt5a (ss9pt tukuang_block 5))
  (sssetfirst nil tukuang_block) 
  (setq  pick_date (entget (car (entsel "\n��ѡ���ο�:"))) GX_list '() GX_list (list (assoc 0 pick_date) (assoc 8 pick_date) (assoc 70 pick_date))) 
  (sssetfirst nil nil)
  (if (assoc 62 pick_date) (setq GX_list (cons  (assoc 62 pick_date) GX_list)))
  (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
  (if (not (setq ss_tk (ssget GX_list))) (setq ss_tk (ssget "x"  GX_list))) 
  (setq i -1) 
  (while (setq entname (ssname ss_tk (setq i (1+ i))))
    (setq ss-9 (ssadd) ss-9 (ssadd entname ss-9) pt5b (ss9pt ss-9 5) scale (/ (distance (ss9pt ss-9 1) (ss9pt ss-9 9)) (distance (ss9pt tukuang_block 1) (ss9pt tukuang_block 9) )))		
    (command "COPY" tukuang_block "" "non" pt5a  "non" pt5b  "SCALE" (entlast) "" "non" pt5b  scale)
    (entdel entname)
    );while	
  (command "undo" "e")
  (princ)
  
  
  
  
  )


					;==========================================================================��������

;;��ͼ����������
(defun tukuang_BK (H-S 9NB NB NB0 ang / all_lst all_lst_px entname i ss_tk suo_str tk+tz tk+tz+jdpt_lst tkname) 
  (command "undo" "be")
  (if (= YMK_TMP 0)
      (progn (setq tkname (cdr (assoc 2 (entget (setq entname (car (entsel "\n��ѡͼ���:")))))))
	     (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
	     (if (not (setq ss_tk (ssget (list (cons 0 "INSERT") (cons 2 tkname))))) (setq ss_tk (ssget"x"  (list (cons 0 "INSERT") (cons 2 tkname)))));;ͼ���ѡ��(ͬ����)
	     )
      (setq ss_tk (ssget (list (cons 0 "INSERT"))));ͼ���ѡ��(������)
      );if 
  (sssetfirst nil ss_tk)
  (setq i -1 tk+tz+jdpt_lst '() ALL_lst '()) 
  (while (setq entname (ssname ss_tk (setq i (1+ i))))
    
    (setq 	tk+tz (ssget "c" (car (enbox entname)) (cadr (enbox entname))));����ͼֽѡ��
    (setq tk+tz+jdpt_lst	(list tk+tz (car (enbox entname)) entname));;����ͼֽѡ��+���½ǵ�+��ͼ���� �ı�
    (setq ALL_lst (cons tk+tz+jdpt_lst ALL_lst));;����С��ϲ������
    
    );while
  ������������������������������������������������������������������������	
  (if (= RB_paixuFS 1) (cond ((= H-S 0) (setq ALL_lst_px (vl-sort ALL_lst '(lambda (a b) (< (car (cadr a)) (car (cadr b)))))));;����ʱ������1���xֵС�������򣬵õ��±�
		             ((= H-S 1) (setq ALL_lst_px (vl-sort ALL_lst '(lambda (a b) (< (cadr (cadr a)) (cadr (cadr b)))))));;����ʱ������1���yֵС�������򣬵õ��±�
	                     );cond
      (setq ALL_lst_px (reverse ALL_lst));ѡ��˳������
      );if
  ������������������������������������������������������������������������	
  (if (= cp_xx 0) (DQ_BK ALL_lst_px H-S 9NB) (PL_BK ALL_lst_px H-S NB NB0 ang))	
  (command "undo" "e")
  (princ)	
  )

					;--------------------------------------------------------------------------------
;;���ο���������
(defun juxing_WL (H-S 9NB NB NB0 ang / all_lst all_lst_px entname gx_list i pick_date ss_tk suo_str tk+tz tk+tz+jdpt_lst) 
  (command "undo" "be")
  (if (= BGX_TMP 0)
      (progn (setq  pick_date (entget (car (entsel "\n��ѡ���ο�:"))) GX_list '() GX_list (list (assoc 0 pick_date) (assoc 8 pick_date) (assoc 70 pick_date))) (if (assoc 62 pick_date) (setq GX_list (cons  (assoc 62 pick_date) GX_list)))
	     (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
	     (if (not (setq ss_tk (ssget GX_list))) (setq ss_tk (ssget "x"  GX_list)));;���ο�ѡ��(ͬ�㡢ͬɫ)
	     )
      (setq ss_tk (ssget (list (cons 0 "LWPOLYLINE") (cons 70 1))));���ο�ѡ��(������)
      );if 
  (sssetfirst nil ss_tk)

  (setq i -1 tk+tz+jdpt_lst '() ALL_lst '()) 
  (while (setq entname (ssname ss_tk (setq i (1+ i))))
    
    (setq 	tk+tz (ssget "c" (car (enbox entname)) (cadr (enbox entname))));����ͼֽѡ��
    (setq tk+tz+jdpt_lst	(list tk+tz (car (enbox entname)) entname));;����ͼֽѡ��+���½ǵ�+��ͼ���� �ı�
    (setq ALL_lst (cons tk+tz+jdpt_lst ALL_lst));;����С��ϲ������
    
    );while
  ������������������������������������������������������������������������
  (if (= RB_paixuFS 1) (cond ((= H-S 0) (setq ALL_lst_px (vl-sort ALL_lst '(lambda (a b) (< (car (cadr a)) (car (cadr b)))))));;����ʱ������1���xֵС�������򣬵õ��±�
		             ((= H-S 1) (setq ALL_lst_px (vl-sort ALL_lst '(lambda (a b) (< (cadr (cadr a)) (cadr (cadr b)))))));;����ʱ������1���yֵС�������򣬵õ��±�
	                     );cond
      (setq ALL_lst_px (reverse ALL_lst));ѡ��˳������
      );if
  ������������������������������������������������������������������������
  (if (= cp_xx 0) (DQ_BK ALL_lst_px H-S 9NB) (PL_BK ALL_lst_px H-S NB NB0 ang))	
  (command "undo" "e")
  (princ)	
  )

					;--------------------------------------------------------------------------------
;;�ֹ�ѡ����������
(defun select_SG (H-S 9NB NB NB0 ang / all_lst all_lst_px entname i p1 p2 rec ss_tk suo_str tk+tz tk+tz+jdpt_lst)
  (command "undo" "be")
  (setq ss_tk (ssadd))
  (prompt "\nÿ��ѡһ��Ϊһ��ͼ���Ҽ�����ѡ��")	
  (if (= CKB_TMP 0)
      (while (setq p1 (getpoint "\n��1��"))
	(setq p2 (getcorner p1 "\n��2��"))
	(command "RECTANG" "non" p1 "non" p2 "CHANGE" (setq rec (entlast)) "" "p" "c" 224 "")
	(setq ss_tk (ssadd rec ss_tk))
	);while
      (while (setq p1 (getpoint "\n��1��"))
	(setq p2 (getcorner p1 "\n��2��"))
	(setq ss_tk (ssadd (ckb_rec p1 p2) ss_tk))
	)		
      );if
  
  (sssetfirst nil ss_tk)	
  (setq i -1 tk+tz+jdpt_lst '() ALL_lst '()) 
  (while (setq entname (ssname ss_tk (setq i (1+ i))))
    
    (setq 	tk+tz (ssget "c" (car (enbox entname)) (cadr (enbox entname))));����ͼֽѡ��
    (setq tk+tz+jdpt_lst	(list tk+tz (car (enbox entname)) entname));;����ͼֽѡ��+���½ǵ�+��ͼ���� �ı�
    (setq ALL_lst (cons tk+tz+jdpt_lst ALL_lst));;����С��ϲ������
    
    );while
  ������������������������������������������������������������������������
  (if (= RB_paixuFS 1) (cond ((= H-S 0) (setq ALL_lst_px (vl-sort ALL_lst '(lambda (a b) (< (car (cadr a)) (car (cadr b)))))));;����ʱ������1���xֵС�������򣬵õ��±�
		             ((= H-S 1) (setq ALL_lst_px (vl-sort ALL_lst '(lambda (a b) (< (cadr (cadr a)) (cadr (cadr b)))))));;����ʱ������1���yֵС�������򣬵õ��±�
	                     );cond
      (setq ALL_lst_px (reverse ALL_lst));ѡ��˳������
      );if
  ������������������������������������������������������������������������	
  (if (= cp_xx 0) (DQ_BK ALL_lst_px H-S 9NB) (PL_BK ALL_lst_px H-S NB NB0 ang))		
  (command "undo" "e")
  (princ)	
  )

					;--------------------------------------------------------------------------------
;;�Զ�ʶ��ͼ�򻭾��ο�-����������
(defun zidongshibie_WL (H-S 9NB NB NB0 ang / all_lst all_lst_px entname gx_list i pick_date ss_tk suo_str tk+tz tk+tz+jdpt_lst) 
  (command "undo" "be")
  
  (setq ss_tk (maketukuangxian) ss_tk (quchongfu ss_tk));;�Զ�ʶ��ͼ�򻭿�
  (sssetfirst nil ss_tk)	
  
  (setq i -1 tk+tz+jdpt_lst '() ALL_lst '()) 
  (while (setq entname (ssname ss_tk (setq i (1+ i))))
    
    (setq 	tk+tz (ssget "c" (car (enbox entname)) (cadr (enbox entname))));����ͼֽѡ��
    (setq tk+tz+jdpt_lst	(list tk+tz (car (enbox entname)) entname));;����ͼֽѡ��+���½ǵ�+��ͼ���� �ı�
    (setq ALL_lst (cons tk+tz+jdpt_lst ALL_lst));;����С��ϲ������
    
    );while
  ������������������������������������������������������������������������
  (if (= RB_paixuFS 1) (cond ((= H-S 0) (setq ALL_lst_px (vl-sort ALL_lst '(lambda (a b) (< (car (cadr a)) (car (cadr b)))))));;����ʱ������1���xֵС�������򣬵õ��±�
		             ((= H-S 1) (setq ALL_lst_px (vl-sort ALL_lst '(lambda (a b) (< (cadr (cadr a)) (cadr (cadr b)))))));;����ʱ������1���yֵС�������򣬵õ��±�
	                     );cond
      (setq ALL_lst_px (reverse ALL_lst));ѡ��˳������
      );if
  ������������������������������������������������������������������������
  (if (= cp_xx 0) (DQ_BK ALL_lst_px H-S 9NB) (PL_BK ALL_lst_px H-S NB NB0 ang))	
  (command "undo" "e")
  (if (= LB_TMP 5) (command "ERASE" ss_tk ""))
  (princ)	
  )



;; �����������д���0309 ��������������������������������������������������������������������������������������������������������������������������������

(defun zhenlie_PX (lst / zlpx_list);�����Ҵ��ϵ�������
  (setq ZLPX_list (vl-sort (vl-sort lst '(lambda (s1 s2) (> (cadadr s1) (cadadr s2)))) 
			   '(lambda (s3 s4) (if(equal (cadadr s3) (cadadr s4) 0.6)(< (caadr s3) (caadr s4))))
			   )
	
	)
  ZLPX_list
  )


(defun zuo>>you_pl (lst pt d flag / ent_pt entname entname1 i);�����Һ������Ӻ���
  (command "undo" "be") 
  (setq i -1)
  (repeat (length lst)
	  (cond ((= flag 1) (setq entname (car (nth  (setq i (1+ i)) lst)) ent_pt (cadr (nth i lst))))
		((= flag 2) (setq entname (car (nth  (setq i (1+ i)) lst)) ent_pt (cadr (nth i lst))))
		((= flag 3) (setq entname (car (nth  (setq i (1+ i)) lst)) ent_pt (cadr (nth i lst))) (setq entname1 (caddr (nth i lst))))
		
		);cond
	  (command "move" entname "" "non" ent_pt  "non" pt)
	  (cond ((= flag 1) (setq pt (polar pt 0 d))) ;��>��
		((= flag 2) (setq pt (polar pt 0 (+ d (- (car (cadr (enbox entname))) (car (car (enbox entname))))) )))	;��>��(����)
		((= flag 3) (setq pt (polar pt 0 (+ d (- (car (cadr (enbox entname1))) (car (car (enbox entname1))))) )))	;��>��(ѡ��)
		
		);cond
	  )
  (command "undo" "e") 
  )

(defun zhenlie_DT (ZL_w ZL_h ZL_nb JJ_x / all_lst all_lst_px entname entname+jdpt_lst enx gx_list i ii iii p0 pick_date ss ssall x_lst);;��������������

  (command "undo" "be") 
					;==========================================================================
					;����ѡ��ʽ����
  (cond   ((= LB_TMP 1)
	   (if (= SX_TMP 1)		    
	       (progn (setq  pick_date (entget (car (entsel "\n��ѡԴ����:"))) GX_list '())
		      
		      (if (= (cdr (assoc 0 pick_date)) "INSERT")  
			  (setq  GX_list (list (assoc 0 pick_date) (assoc 2 pick_date)));ͼ����
			  (progn (setq  GX_list (list (assoc 0 pick_date) (assoc 8 pick_date))) (if (assoc 62 pick_date) (setq GX_list (cons  (assoc 62 pick_date) GX_list))));������
			  
			  );;�ռ���������
		      
		      (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
		      (if (not (setq ssall (ssget GX_list))) (setq ssall (ssget "x"  GX_list)));;����ѡ��(ͬ�㡢ͬɫ)
		      
		      (sssetfirst nil ssall)
		      (setq    ss ssall)
		      
		      );progn							
	       (setq ssall (ssget)  ss ssall)))
	  );cond		
					;==========================================================================		
					;(setq ss (ssget))
  (setq i -1 entname+jdpt_lst '() ALL_lst '()) 
  (if (= t_tog_zhongdian 0)
      (progn (while (setq entname (ssname ss (setq i (1+ i))))			  
	       (setq entname+jdpt_lst	(list entname (car (enbox entname))));;��������+���½ǵ� ��С��
	       (setq ALL_lst (cons entname+jdpt_lst ALL_lst));;����С��ϲ������      		
	       );while
	     (if (= RB_paixuFS 1) 
		 (setq ALL_lst_px (zhenlie_PX ALL_lst));;�Զ��������ܱ�
		 (setq ALL_lst_px (reverse ALL_lst));ѡ��˳������
		 );if	
	     (setq p0 (getpoint "\nѡ���������<�˳�>: "))
	     
	     (setq ii -1 iii 0) 	
	     (repeat (fix (+ (/ (length ALL_lst_px) (float ZL_nb)) 0.9))
		     (setq X_lst '())
		     (repeat ZL_nb 
			     (if  (setq enx (nth  (setq ii (1+ ii)) ALL_lst_px))
				  (setq X_lst  (cons enx X_lst))
				  )
			     );repeat1
		     (setq X_lst (reverse X_lst))
		     (cond ((= JJ_x 1) (zuo>>you_pl X_lst p0 ZL_w 1) (setq p0 (polar p0  (* 1.5 pi) ZL_h)));;����һ��С�����ټ�����һ��С���Ż���--��>�� �ľ���
			   ((= JJ_x 2) (zuo>>you_pl X_lst p0 ZL_w 2) (if  (nth  (setq iii  (+ iii ZL_nb)) ALL_lst_px) (setq p0 (polar p0  (* 1.5 pi) (+ ZL_h (- (cadr (cadr (enbox (car (nth  iii ALL_lst_px))))) (cadr (car (enbox (car (nth  iii ALL_lst_px)))))))))));��>�� �ľ���
			   
			   );cond			
		     );repeat2
	     );progn-���½ǻ���
      
      
      (progn (while (setq entname (ssname ss (setq i (1+ i))))
	       
	       (setq ss-9 (ssadd) ss-9 (ssadd entname ss-9))	 
	       (setq entname+jdpt_lst	(list entname (ss9pt ss-9 5)));;��������+���ĵ� ��С��
	       (setq ALL_lst (cons entname+jdpt_lst ALL_lst));;����С��ϲ������      		
	       );while
	     (if (= RB_paixuFS 1) 
		 (setq ALL_lst_px (zhenlie_PX ALL_lst));;�Զ��������ܱ�
		 (setq ALL_lst_px (reverse ALL_lst));ѡ��˳������
		 );if	
	     (setq p0 (getpoint "\nѡ���������<�˳�>: "))
	     
	     (setq ii -1 iii 0) 	
	     (repeat (fix (+ (/ (length ALL_lst_px) (float ZL_nb)) 0.9))
		     (setq X_lst '() H0 (/ (- (cadr (cadr (enbox (car (nth  iii ALL_lst_px))))) (cadr (car (enbox (car (nth  iii ALL_lst_px)))))) 2))
		     (repeat ZL_nb 
			     (if  (setq enx (nth  (setq ii (1+ ii)) ALL_lst_px))
				  (setq X_lst  (cons enx X_lst))
				  )
			     );repeat1
		     (setq X_lst (reverse X_lst))
		     (cond ((= JJ_x 1) (zuo>>you_pl X_lst p0 ZL_w 1) (setq p0 (polar p0  (* 1.5 pi) ZL_h)));;����һ��С�����ټ�����һ��С���Ż���--��>�� �ľ���
			   ((= JJ_x 2) (zuo>>you_pl X_lst p0 ZL_w 2) (if  (nth  (setq iii  (+ iii ZL_nb)) ALL_lst_px) (setq p0 (polar p0  (* 1.5 pi) (+ (+ ZL_h (/ (- (cadr (cadr (enbox (car (nth  iii ALL_lst_px))))) (cadr (car (enbox (car (nth  iii ALL_lst_px)))))) 2) )  H0)))));��>�� �ľ���
			   
			   );cond			
		     );repeat2
	     );progn-���Ļ���
      
      
      )
  (command "undo" "e")
  (princ)		
  )

(defun zhenlie_SS (ZL_w ZL_h ZL_nb JJ_x / all_lst all_lst_px entname enx gx_list i ii iii p0 p1 p2 pick_date rec ss ss_tk tk+tz tk+tz+jdpt_lst tkname x_lst);;ѡ������������
  (command "undo" "be") 
					;==========================================================================
					;�����ѡ����
  (cond   ((= LB_TMP 2)
	   (if (= YMK_TMP 0)
	       (progn (setq tkname (cdr (assoc 2 (entget (setq entname (car (entsel "\n��ѡͼ���:")))))))
		      (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
		      (if (not (setq ss_tk (ssget (list (cons 0 "INSERT") (cons 2 tkname))))) (setq ss_tk (ssget"x"  (list (cons 0 "INSERT") (cons 2 tkname)))));;ͼ���ѡ��(ͬ����)
		      )
	       (setq ss_tk (ssget (list (cons 0 "INSERT"))));ͼ���ѡ��(������)
	       );if 
	   (setq ss ss_tk)
	   (sssetfirst nil ss)											
	   );ͼ�����
	  
	  ((= LB_TMP 3)   
	   (if (= BGX_TMP 0)
	       (progn (setq  pick_date (entget (car (entsel "\n��ѡ���ο�:"))) GX_list '() GX_list (list (assoc 0 pick_date) (assoc 8 pick_date) (assoc 70 pick_date))) (if (assoc 62 pick_date) (setq GX_list (cons  (assoc 62 pick_date) GX_list)))
		      (prompt "\nѡ��Ҫ������� / ȫѡ<�ո�>��")
		      (if (not (setq ss_tk (ssget GX_list))) (setq ss_tk (ssget "x"  GX_list)));;���ο�ѡ��(ͬ�㡢ͬɫ)
		      )
	       (setq ss_tk (ssget (list (cons 0 "LWPOLYLINE") (cons 70 1))));���ο�ѡ��(������)
	       );if 
	   (setq ss ss_tk)
	   (sssetfirst nil ss)	
	   );���ο����
	  
	  ((= LB_TMP 4)    
	   (setq ss_tk (ssadd))
	   (prompt "\nÿ��ѡһ��Ϊһ��ͼ���Ҽ�����ѡ��")	
	   (if (= CKB_TMP 0)
	       (while (setq p1 (getpoint "\n��1��"))
		 (setq p2 (getcorner p1 "\n��2��"))
		 (command "RECTANG" "non" p1 "non" p2 "CHANGE" (setq rec (entlast)) "" "p" "c" 224 "")
		 (setq ss_tk (ssadd rec ss_tk))
		 );while
	       (while (setq p1 (getpoint "\n��1��"))
		 (setq p2 (getcorner p1 "\n��2��"))
		 (setq ss_tk (ssadd (ckb_rec p1 p2) ss_tk))
		 )		
	       );if
	   (setq ss ss_tk)
	   (sssetfirst nil ss)	
	   );�ֹ���ѡ���	
	  
	  ((= LB_TMP 5)   
					;(maketukuangxian)
	   (setq ss (maketukuangxian) ss (quchongfu ss))
	   (sssetfirst nil ss)	
	   );�Զ�ʶ�����
	  
	  );cond
					;==========================================================================		
					;(setq ss (ssget))
  (setq i -1 tk+tz+jdpt_lst '() ALL_lst '()) 
  (while (setq entname (ssname ss (setq i (1+ i))))
    (setq 	tk+tz (ssget "c" (car (enbox entname)) (cadr (enbox entname))));ͼ��,ͼֽ����ѡ��		
    (setq tk+tz+jdpt_lst	(list tk+tz (car (enbox entname)) entname));;ͼ��,ͼֽ����ѡ��+���½ǵ�+ͼ��ͼԪ�� �ĵ���С��
    (setq ALL_lst (cons tk+tz+jdpt_lst ALL_lst));;����С��ϲ������      		
    );while
  
  (if (= RB_paixuFS 1) 
      (setq ALL_lst_px (zhenlie_PX ALL_lst));;�Զ��������ܱ�
      (setq ALL_lst_px (reverse ALL_lst));ѡ��˳������
      );if
  (setq p0 (getpoint "\nѡ���������<�˳�>: "))
  (command "-layer" "u" (setq suo_str (layer_suo_str)) "");����
  (setq ii -1 iii 0) 	
  (repeat (fix (+ (/ (length ALL_lst_px) (float ZL_nb)) 0.999))
	  (setq X_lst '())
	  (repeat ZL_nb 
		  (if  (setq enx (nth  (setq ii (1+ ii)) ALL_lst_px))
		       (setq X_lst  (cons enx X_lst))
		       )
		  );repeat1
	  (setq X_lst (reverse X_lst))
	  (cond ((= JJ_x 1) (zuo>>you_pl X_lst p0 ZL_w 1) (setq p0 (polar p0  (* 1.5 pi) ZL_h)));;����һ��С�����ټ�����һ��С���Ż���--��>�� �ľ���
		((= JJ_x 3) (zuo>>you_pl X_lst p0 ZL_w 3) (if (nth  (setq iii (+ iii ZL_nb)) ALL_lst_px) (setq p0 (polar p0  (* 1.5 pi) (+ ZL_h (- (cadr (cadr (enbox (caddr (nth  iii ALL_lst_px))))) (cadr (car (enbox (caddr (nth  iii ALL_lst_px)))))))))));��>�� �ľ���			
		);cond			
	  );repeat2	
  (command "undo" "e")
  (command "-layer" "lo"  suo_str  "")
  (if (= LB_TMP 5) (command "ERASE" ss "")) 
  (princ)		
  )

(defun zhenlie_FUZHI (ZL_nby ZL_nbx ZL_h ZL_w / lastent pt0 pt1 ss);;��������������
  (command "undo" "be")	
  (setq ss (ssget) pt0 (ss9pt ss 5) pt1 (getpoint "\nѡȡ�������/ԭλ<�ո�>��"))
  (if (= RB_zhenliejianju 2) (setq ZL_h (if (>= ZL_h 0) (+ ZL_h (distance (ss9pt ss 1) (ss9pt ss 7))) (- ZL_h (distance (ss9pt ss 1) (ss9pt ss 7)))) ZL_w (if (>= ZL_w 0) (+ ZL_w (distance (ss9pt ss 1) (ss9pt ss 3))) (- ZL_w (distance (ss9pt ss 1) (ss9pt ss 3)))))) 	 
  (if pt1 (command "move" ss "" "non" pt0 "non" pt1))	
  (command "ARRAY" ss "" "r" ZL_nby ZL_nbx ZL_h ZL_w)
  (command "undo" "e")
  (princ)	
  )


(defun maketukuangxian (/ bound e entx gx_list i lastent lst pick_date rects ss ss_last);;�Զ�ʶ��ͼ�򻭾��ο��Ӻ���

  (if (= zdSX_TMP 0) (progn (setq  pick_date (entget (car (entsel "\n��ѡͼ������߿�:"))) GX_list '() GX_list (list (assoc 0 pick_date) (assoc 8 pick_date) ))
			    (setq ss (ssget GX_list)));progn
      (setq ss (ssget '((0 . "LWPOLYLINE,INSERT"))))
      );if
  
  (repeat (setq i (sslength ss))
	  (setq e (ssname ss (setq i (1- i))))
	  (setq lst (cons (ebox e) lst)) ;_��ȡ�߽�Խǵ㣬����������
	  )
  (setq lst (vl-sort lst '(lambda (x1 x2) (> (area x1) (area x2))))) ;_�������С����
  (while lst
    (setq rects (cons (car lst) rects)) ;_���ζԽǵ㼯
    (setq bound (pt4 (car lst))) ;_���α߽�
    (setq lst (vl-remove-if '(lambda (x) (and (PtInPoly (car x) bound) (PtInPoly (cadr x) bound))) (cdr lst))) ;_�Ƴ�����α߽��ڵ�С����
    )
  (setq lastent (entlast) ss_last (ssadd))
  (mapcar '(lambda (x) (command "rectang" (car x) (cadr x))) rects) ;_�������ɾ���
  (while (setq entx (entnext lastent))
    (setq ss_last (ssadd entx ss_last) lastent entx)
    )
  
  (command "CHANGE" ss_last "" "p" "c" 224 "")
  ss_last 
  )

(defun ebox (e / pa pb)
  (and (= 'ename (type e)) (setq e (vlax-ename->vla-object e)))
  (vlax-invoke-method e 'GetBoundingBox 'pa 'pb)
  (setq pa (trans (vlax-safearray->list pa) 0 1)
        pb (trans (vlax-safearray->list pb) 0 1)
	)
  (list pa pb)
  )
(defun area (pts) (apply '* (cdr (reverse (apply 'mapcar (cons '- pts)))))) ;_�����
(defun pt4 (pt2)
  (list (car pt2) (list (caadr pt2) (cadar pt2)) (cadr pt2) (list (caar pt2) (cadadr pt2)))
  ) ;_�Խǵ������Ľǵ�
(defun PtInPoly (pt pts)
  (equal pi
         (abs
          (apply '+ (mapcar '(lambda (x y) (rem (- (angle pt x) (angle pt y)) pi)) (cons (last pts) pts) pts))
          )
         1e-6
	 )
  ) ;_���Ƿ���͹������ڣ��Ƕȷ���

(defun quchongfu (ss / ent ent1 i ii pt pt1) 
  (setq i -1 ss1 (ssadd)) 
  (while (setq ent (ssname ss (setq i (1+ i))))		
    (setq DJ_lst (ebox ent))	  
    (setq ii i) 
    (while (setq ent1 (ssname ss (setq ii (1+ ii))))
      (setq DJ_lst1 (ebox ent1))
      (if (equal DJ_lst DJ_lst1  0.01) (setq ss1 (ssadd ent1 ss1)))		
      );while	 
    );while
  (command "ERASE" ss1 "")
  ss
  )



;;;=================================================================*
;;;�������ڣ�20200318.175218
;;;���ļ��ɳ����Զ����ɡ�                                           *
;;;����������ɺ��轫�����롰*.lsp���ļ��е�����е�     *
;;; (load_dialog ˫����*.Dcl˫����)��Ϊ(load_dialog (make-dcl)) ������            *
;;;�޸ĺ�Ĵ���ɱ༭����LISP���������                                                                 *
;;;=================================================================*
;;;Ϊ���ö���б��������ɵ�DCL.lsp����ͬʱʹ�ã����ɳ����Ӧ���Ի����� (make-dcl)����   *
;;;�����޸������ط���һ��Ϊ���صĵط�(load_dialog (������-make-dcl)) ����һ��Ϊ       *
;;;�Ի�����������(defun ������-make-dcl    ��һ��Ҫһ��                      *
;;;ʾ����(make-dcl)                                                 *
(defun make-dcl-pl  (/ lst_str str file f)
  (setq lst_str '(
		  "/*������ListDCL @ fsxm.mjtd.com������*/"
		  ""
		  "rect01:dialog {"
		  "    label = \"������/����/ͼ���Ű桿ST0318\" ;"
		  "    :spacer {}"
		  "    :row {"
		  "        :boxed_column {"
		  "            key = \"k_paixuFS\" ;"
		  "            label = \"����ʽ\" ;"
		  "            :radio_button {"
		  "                key = \"k_rb_zidong\" ;"
		  "                label = \"�Զ�\" ;"
		  "            }"
		  "            :radio_button {"
		  "                key = \"k_rb_xuanxu\" ;"
		  "                label = \"ѡ��\" ;"
		  "            }"
		  "        }"
		  "        :boxed_column {"
		  "            label = \"ѡȡ��ʽ\" ;"
		  "            :row {"
		  "                key = \"k_no1\" ;"
		  "                :spacer {"
		  "                    width = 1.5 ;"
		  "                }"
		  "                :radio_button {"
		  "                    key = \"xlb1\" ;"
		  "                    label = \"����\" ;"
		  "                }"
		  "                :spacer {}"
		  "                :radio_button {"
		  "                    key = \"xlb2\" ;"
		  "                    label = \"��ͼ��\" ;"
		  "                }"
		  "                :spacer {}"
		  "                :radio_button {"
		  "                    key = \"xlb3\" ;"
		  "                    label = \"���ο�\" ;"
		  "                }"
		  "                :spacer {}"
		  "                :radio_button {"
		  "                    key = \"xlb4\" ;"
		  "                    label = \"�ֹ�ѡ\" ;"
		  "                }"
		  "                :spacer {}"
		  "                :radio_button {"
		  "                    key = \"xlb5\" ;"
		  "                    label = \"�Զ�\" ;"
		  "                }"
		  "            }"
		  "            :row {"
		  "                key = \"k_no2\" ;"
		  "                :spacer {"
		  "                    width = 1.5 ;"
		  "                }"
		  "                :toggle {"
		  "                    key = \"toggle_sx\" ;"
		  "                    label = \"��ѡ\" ;"
		  "                }"
		  "                :spacer {}"
		  "                :toggle {"
		  "                    key = \"toggle_ymk\" ;"
		  "                    label = \"������\" ;"
		  "                }"
		  "                :spacer {}"
		  "                :toggle {"
		  "                    key = \"toggle_bgx\" ;"
		  "                    label = \"�ǹ���\" ;"
		  "                }"
		  "                :spacer {}"
		  "                :toggle {"
		  "                    key = \"toggle_ckb\" ;"
		  "                    label = \"�߿��\" ;"
		  "                }"
		  "                :spacer {}"
		  "                :toggle {"
		  "                    key = \"toggle_sx2\" ;"
		  "                    label = \"��ѡ\" ;"
		  "                }"
		  "            }"
		  "        }"
		  "    }"
		  "    :image {"
		  "        color = 1 ;"
		  "        height = 0.12 ;"
		  "    }"
		  "    :spacer {}"
		  "    :row {"
		  "        :column {"
		  "            :row {"
		  "                :row {"
		  "                    key = \"row_sxdq\" ;"
		  "                    label = \"˫�����\" ;"
		  "                    :column {"
		  "                        :button {"
		  "                            key = \"dtpl7\" ;"
		  "                            label = \"�X\" ;"
		  "                        }"
		  "                        :button {"
		  "                            key = \"dtpl8\" ;"
		  "                            label = \"�d\" ;"
		  "                        }"
		  "                        :button {"
		  "                            key = \"dtpl9\" ;"
		  "                            label = \"�^\" ;"
		  "                        }"
		  "                    }"
		  "                    :column {"
		  "                        :button {"
		  "                            key = \"dtpl10\" ;"
		  "                            label = \"�j\" ;"
		  "                        }"
		  "                        :button {"
		  "                            key = \"dtpl11\" ;"
		  "                            label = \"�p\" ;"
		  "                        }"
		  "                        :button {"
		  "                            key = \"dtpl12\" ;"
		  "                            label = \"�m\" ;"
		  "                        }"
		  "                    }"
		  "                    :column {"
		  "                        :button {"
		  "                            key = \"dtpl13\" ;"
		  "                            label = \"�[\" ;"
		  "                        }"
		  "                        :button {"
		  "                            key = \"dtpl14\" ;"
		  "                            label = \"�g\" ;"
		  "                        }"
		  "                        :button {"
		  "                            key = \"dtpl15\" ;"
		  "                            label = \"�a\" ;"
		  "                        }"
		  "                    }"
		  "                }"
		  "                :column {"
		  "                    key = \"k_shuipingduiqi\" ;"
		  "                    label = \"ˮƽ����\" ;"
		  "                    :button {"
		  "                        key = \"dtpl1\" ;"
		  "                        label = \"��\" ;"
		  "                    }"
		  "                    :button {"
		  "                        key = \"dtpl2\" ;"
		  "                        label = \"��\" ;"
		  "                    }"
		  "                    :button {"
		  "                        key = \"dtpl3\" ;"
		  "                        label = \"��\" ;"
		  "                    }"
		  "                }"
		  "                :column {"
		  "                    key = \"k_chuizhiduiqi\" ;"
		  "                    label = \"��ֱ����\" ;"
		  "                    :button {"
		  "                        key = \"dtpl4\" ;"
		  "                        label = \"��\" ;"
		  "                    }"
		  "                    :button {"
		  "                        key = \"dtpl5\" ;"
		  "                        label = \"��\" ;"
		  "                    }"
		  "                    :button {"
		  "                        key = \"dtpl6\" ;"
		  "                        label = \"��\" ;"
		  "                    }"
		  "                }"
		  "            }"
		  "            :spacer {"
		  "                height = 0.5 ;"
		  "            }"
		  "            :row {"
		  "                height = 1 ;"
		  "                key = \"k_dengju,dianxuan\" ;"
		  "                :column {"
		  "                    :toggle {"
		  "                        alignment = centered ;"
		  "                        key = \"cp_x\" ;"
		  "                        label = \"�Ⱦ�����\" ;"
		  "                    }"
		  "                }"
		  "                :column {"
		  "                    :edit_box {"
		  "                        alignment = top ;"
		  "                        key = \"cp_d\" ;"
		  "                        label = \"���:\" ;"
		  "                    }"
		  "                }"
		  "                :column {"
		  "                    :button {"
		  "                        alignment = top ;"
		  "                        key = \"dxjj\" ;"
		  "                        label = \"��ѡ����\" ;"
		  "                    }"
		  "                }"
		  "                :spacer {}"
		  "            }"
		  "        }"
		  "        :column {"
		  "            :row {"
		  "                label = \"����\" ;"
		  "                :column {"
		  "                    :row {"
		  "                        :text {"
		  "                            label = \"��ʽ:\" ;"
		  "                        }"
		  "                        :radio_button {"
		  "                            key = \"k_rb_chongpaizhenlie\" ;"
		  "                            label = \"��������\" ;"
		  "                        }"
		  "                        :radio_button {"
		  "                            key = \"k_rb_fuzhizhenlie\" ;"
		  "                            label = \"��������\" ;"
		  "                        }"
		  "                    }"
		  "                    :row {"
		  "                        :edit_box {"
		  "                            key = \"k_hengju\" ;"
		  "                            label = \"���:\" ;"
		  "                        }"
		  "                        :edit_box {"
		  "                            key = \"k_hengshu\" ;"
		  "                            label = \"����:\" ;"
		  "                        }"
		  "                    }"
		  "                    :row {"
		  "                        :edit_box {"
		  "                            key = \"k_shuju\" ;"
		  "                            label = \"����:\" ;"
		  "                        }"
		  "                        :edit_box {"
		  "                            key = \"k_shushu\" ;"
		  "                            label = \"����:\" ;"
		  "                        }"
		  "                    }"
		  "                    :spacer {}"
		  "                    :row {"
		  "                        :text {"
		  "                            label = \"�㷨:\" ;"
		  "                        }"
		  "                        :radio_button {"
		  "                            key = \"k_rb_zhongzhong\" ;"
		  "                            label = \"��<->��\" ;"
		  "                        }"
		  "                        :spacer {}"
		  "                        :radio_button {"
		  "                            key = \"k_rb_bianbian\" ;"
		  "                            label = \"��<->��\" ;"
		  "                        }"
		  "                        :spacer {}"
		  "                    }"
		  "                    :row {"
		  "                        :text {"
		  "                            label = \"����:\" ;"
		  "                        }"
		  "                        :toggle {"
		  "                            key = \"k_tog_zhongdian\" ;"
		  "                            label = \"�е�\" ;"
		  "                        }"
		  "                        :button {"
		  "                            key = \"k_bt_dianxuan\" ;"
		  "                            label = \"ѡ��\" ;"
		  "                        }"
		  "                        :button {"
		  "                            key = \"k_zlqueding\" ;"
		  "                            label = \"ȷ��\" ;"
		  "                        }"
		  "                    }"
		  "                }"
		  "            }"
		  "        }"
		  "    }"
		  "    :spacer {}"
		  "    :column {"
		  "        label = \"��ͼ��\" ;"
		  "        :row {"
		  "            :spacer {}"
		  "            :radio_button {"
		  "                key = \"k_moren\" ;"
		  "                label = \"Ĭ��ͼ��\" ;"
		  "            }"
		  "            :radio_button {"
		  "                key = \"k_tuzhong\" ;"
		  "                label = \"ͼ��ѡ��\" ;"
		  "            }"
		  "            :radio_button {"
		  "                key = \"k_chawenjian\" ;"
		  "                label = \"����ļ� >>>\" ;"
		  "            }"
		  "            :button {"
		  "                key = \"k_liulan\" ;"
		  "                label = \"���\" ;"
		  "            }"
		  "            :button {"
		  "                alignment = right ;"
		  "                key = \"k_ctk\" ;"
		  "                label = \"��ͼ��\" ;"
		  "            }"
		  "        }"
		  "        :text {"
		  "            alignment = left ;"
		  "            key = \"k_lujing\" ;"
		  "        }"
		  "        :spacer {}"
		  "    }"
		  "    :row {"
		  "        :text {"
		  "            value = \"ע:1,ͼ���ܽ���.  2, �����ͼ���ļ��ߴ�:594x420mm.\" ;"
		  "        }"
		  "        cancel_button;"
		  "    }"
		  "}"
		  )
	)
  (setq file (vl-filename-mktemp "DclTemp.dcl"))
  (setq f (open file "w"))
  (foreach str lst_str
	   (princ "\n" f)
	   (princ str f)
	   )
  (close f)
  ;;����
  file
  )
