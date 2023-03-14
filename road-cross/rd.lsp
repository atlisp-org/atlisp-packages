
;;-------------------------------------------------------------------------
;;����:lee50310  ����:2020�� 10��25�� ��ʼ׫д 
;;               ����:2020�� 11��08�� ���ӻ�����Ѱ·���ʽ draw_line_obj.lsp
;;               ����:2020�� 11��14�� �޸Ĳ�
;;               ����:2020�� 11��16�� �޸Ĳ������
;;               ����:2020�� 11��22�� ���� cad2010�޷�ִ��,��ʵ��ͼ����
;;               ����:2020�� 11��28�� ���� line �ο���ʽ��ʱ���ܶϿ����� 
;;               ����:2020�� 12��15�� ���� ������ú��ǰ���� 
;;��ʽ����: ָ�� rd ��·����  ·�����1,2�����
;;              srd ��·����  ·����������趨
;;		  	    sld ��һ��ȡ�õ�·��(���ڼ��е�·�䲹��һ��·  �����ϵ�·���������С���ȵ�· ִ��wedָ�� ��һ����Խ������·���� �õ��Լ���ȡ��������·��ֵ �ٻ��ƺ���·)
;;			    std �����趨 �趨 ��Բ�� Ĭ��ֵ 3 ,  Ѱ�ҵ�·���������Ϊ·�� �����ֵ  Ĭ��ֵ 0.02
;;
;; ���Ʒ�ʽ ����� ��һ��  ,��ڶ�(���) , �������.....  ���հ׼�����

;;------------------------------------------------------------------------------
;;�����µ�·
;;��·����1,2������ ���Ƶ�·
(defun road-cross:rd()
  
  (setq sno 1 gen 1)          ;sno=1 ��·���ɻ���1,2������������� 
  (Draw_the_road)
  
  );end_defun_rd 
;;-----------------------------------------------------------------------------
;;�����µ�·
					;�����·��,���Ƶ�·
(defun road-cross:srd()
  
  (setq sno 2 gen 1)           ;sno=2 �����·�� 
  (Draw_the_road)
  
  );end_defun_srd
;;-------------------------------------------------------------------------
;;���߲�·
(defun road-cross:sld()

  (setq gen 2 )               ;;���߲�·
  (drl)                       ;;�ڼ��е�·�ϻ�һ��ȡ�����ҵ���·��ֵ
  (Draw_the_road)             ;;���Ƶ�·
  (c:prd)                     ;;�г��ҵ���·���ֱ 
  )

					;----------------------------------------------------------------------------
;;��··���ɻ�����ӫĻ1 ,2 ��������
(defun draw_rd()
  
  (princ)
  (princ "\n  <<<   �����ʼ����·�� ���Ʒ�ʽ: ��·��(���������)�ɻ���1,2����� ��3���������򼰾��� ,����ȷ�����������,��ɵ�·���հ׼�    >>>")
  (setq pt1 (getpoint "\n��·���� ��һ��"))                       ;��һ��
  (setq pt2 (getpoint pt1 "\n��·���� �ڶ���" ))                  ;�ڶ���
  (setq ww (distance pt1 pt2))                           ;1,2�����Ϊmline���
  
  (setq pt3  (polar pt1 (angle pt1 pt2) (* ww 0.5) ))	 ;������
  
  ww                                                     ;���ֵ�ش�
  
  );end_defun_draw_rd 
;;--------------------------------------------------------------------
;;��· ·�������趨
(defun draw_srd( )
  
  (princ)
  (princ "\n  <<<   ��ʼ����·�� ���Ʒ�ʽ: ������·�� ��Enter �� (���������)���ͼ���������򼰾��� ,����ȷ�����������,��ɵ�·���հ׼�    >>>\n")
  (if (= sw nil) (setq sw 10  ) )                                    ;��ȳ��� 10         
  (setq ww (getreal (strcat "Ĭ�Ͽ�Ȱ�[Space/Enter] �� ����·��<" (rtos sw) ">:")))
  (if (= ww nil)
      (progn
        (setq ww sw )
        (princ (strcat "\n<<<   ***   ·��=" (rtos ww 2 1)   "  ��Բ��ֵ=" (rtos kng 2 1) "  ������ӫĻ ��ʼ�� ***   >>>"))
        )
      (progn
        (setq sw ww)
        (princ (strcat "\n<<<   ***   ·��=" (rtos ww 2 1)   "  ��Բ��ֵ=" (rtos kng 2 1) "  ������ӫĻ ��ʼ�� ***   >>>"))
        )
      )
  
  (setq pt3 (getpoint "\n ��·���� ��һ��"))                ;��һ��
  ww                                              ;���ֵ�ش�
  
  )  ;end_defun_draw_srd 
;;---------------------------------------------------------------------------
;;���������趨
;;Ѱ�ҵ�·��������Χֵ�趨
(
 defun c:std()
 (princ "\n ***   Ѱ�ҵ�·����������趨   ***")     
 (if (= zng nil) (setq zng 0.02 ) )                 ;Ĭ�����ֵ 0.02         
 (setq z% (getreal (strcat "\n Ĭ�����ֵ�� Enter �� �������ֵ < " (rtos zng 2 2) " >:")))
 (if (= z% nil)
     (setq z% zng )        
     (setq zng z%)
     )
 

 ;;��·�ߵ�Բ�������趨
 
 (princ "\n ***   ��·�ߵ�Բ��ֵ�趨   ***")     
 (if (= eng nil) (setq eng 3 ) )                 ;��Բ�ǳ��� 3         
 (setq kng (getint (strcat "\n Ĭ�ϵ�Բ�ǰ� Enter �� ���뵹Բ�� < " (rtos eng) " >:")))
 (if (= kng nil)
     (setq kng eng )        
     (setq eng kng)
     )
 
 )  ;end_defun_std
					;------------------------------------------------------------------------------------
;; �����趨
;;Ѱ�ҵ�·��������Χֵ�趨
(defun stda()
  
  (if (= zng nil) (setq zng 0.02 ) )             ;Ĭ�����ֵ 0.02         
  
  (if (= z% nil)
      (setq z% zng )        
      (setq zng z%)
      )
  
  ;;---------------------
  ;;��·�ߵ�Բ�������趨
  
  (if (= eng nil) (setq eng 3 ) )                 ;��Բ�ǳ��� 3         
  
  (if (= kng nil)
      (setq kng eng )        
      (setq eng kng)
      )
  
  )  ;end_defun_std
					;------------------------------------------------------------------------------------	   

(defun Draw_the_road (/ dic vl ov LastEntity  ss s1 blk en mb1 mb2 xel )

  (vl-load-com)
  (SaveVars (list "osmode" "cmdecho" "orthomode" "DIMDEC"))  ;;����Ŀǰ��ϵͳ����
  (setvar "osmode" 0)		                       ;; �ر�Ŀ�겶׽״̬
  (setvar "orthomode" 0)                            ;; �رմ�ֱ����  
  (setvar "WHIPARC" 1)                               ;;����Բ��
  
  
  (if (equal (tblobjname "LAYER" "���ε�ò,HTE") nil)   ;ȷ����ǰ�Ƿ��е��ε�ò�Ĳ㣬��û����ִ���������
      (progn
	(BF-Ent-MakeLayer "HDE" 1 "Continuous" )        ;�½�HDE�Ĳ㣬��ɫΪ1������ΪContinuous
	(BF-Ent-MakeLayer "���ε�ò" 8 "Continuous" )   ;�½����ε�ò�Ĳ㣬��ɫΪ8������ΪContinuous
	(vl-cmdf "-layer" "_lw" 0.05 "���ε�ò" "")     ;���ô˲��߿�Ϊ0.05��vl-cmdf����ͬcommand
	)
      (BF-ent-ActiveLayer "���ε�ò")                 ;;;
      )

  (BF-ent-ActiveLayer "���ε�ò")                    ;;"���ε�ò"����Ŀǰ
  
  (set_mline)                                        ;; �趨mline����

  (cond ((= sno 1)(stda)(setq ww (draw_rd)))                  ;;;(ȡ��Բ��ֵ�����ֵ)   (��·����1,2������ ���Ƶ�·)
        ((= sno 2)(stda)(setq ww (draw_srd)))                 ;;;(ȡ��Բ��ֵ�����ֵ)   (�����·��,���Ƶ�·)
        ((t       (stda)(setq ww (draw_rd))))                 ;;;(ȡ��Բ��ֵ�����ֵ)   (������ֵ ��·����1,2������ ���Ƶ�· )
	)
  
  (command "_mline"  "S"  ww "")                      ;�趨mline���
  
  
  
  (mapcar 'setvar vl ov)
  (setq vl '("CMDECHO" "PEDITACCEPT" "QAFLAGS")
        ov (mapcar 'getvar vl))
  (setq LastEntity (entlast))
  
  
  (command "_.mline" pt3)                              
  
  (while (= 1 (logand 1 (getvar 'CMDACTIVE)))
    
    (command pause)
    
    );;end_while
  
  (princ)
  (princ "\n<.....��ʽִ�������Ժ�..........>")
  
  (setq en (entlast))
  (obj_min_box en)                                           ;�����С��Χ�� p1, p2 ��
  (scal_x p1 p2 1.4)                                         ;����Χ�������ԽǾ��� �Ŵ�1.4�� ,�Խ�����: pt1 pt2
  (command "zoom" "w" pt1 pt2)                               ;���Ӵ������������С 


  (mapcar 'setvar vl ov)
  
  (setq en (entlast))
  (command "_.chprop" en ""  "_layer" "���ε�ò" "")    ;����������� "���ε�ò" ��
  
  (command "_EXPLODE" en  "" )                          ;;ը��
  (setq sal  (ssget "_P" (list (cons 8 "���ε�ò")(cons 0 "LINE")))) 
  ;;��ȡ���� sal ��ʱ��������,��ʱδ�������� ���¸��������ٶ�sal���ж�һ��
  (if (= (ssget "_P" (list (cons 8 "���ε�ò")(cons 62 1))) nil) (setq t2 1) (setq t2 0))  ;�ж� sal�Ƿ��к������� t2=1 δ�� ,t2=0 �к�
  (setq ss3 (ssget "C" pt1 pt2 ))                        ;;ѡȡ�����·��+������
  (command "_EXPLODE" ss3  "" )                          ;;ը��
  (setq ss3 (ssget "C" pt1 pt2 ))                        ;;��ѡһ��
  (setq ss4 (ssget "_P" (list (cons 8 "���ε�ò")(cons 0 "LINE")))) ;;��ss3���ٹ���ֻȡ�� *****
  (setq ss1 (ssget "_P" (list (cons 8 "���ε�ò")(cons 62 1))))    ;ѡȡ������	
  
  ;; ע:��������·��·(�޺���·) SAL �� SS4 ������������� , ��һ��·(�к���·)   SS4 > SAL
  ;;    ����б���������������С��ȷ�ϵ��������ֶ���
  ;;    SS4 > SAL ��һ��·(�к���·) �� �� ben=2  ,  ���� SS4 = SAL ������·��·(�޺���·) ben=1
  (if (> (sslength ss4) (sslength sal)) (setq ben 2) (setq ben 1))		
  
  
  (cond 
    
    ((= ben 1)
     
     
     (setq ss (DEL_OBJ sal ss4))    ;;�� ss3ѡ����  ɾ���ں�sal������,ʣ������·��           *****
     
     (setq ssc (DEL_OBJ ss1 sal))                                 ;;����·���˫�� 		                                               
     
     (setq ss3 (ssget "C" pt1 pt2 ))                        ;;ѡȡ�����·��+������
     (setq ss4 (ssget "_P" (list (cons 8 "���ε�ò")(cons 0 "LINE")))) ;;��ss3���ٹ���ֻȡ��(��ִ�жϿ�ʱ�����)
     (setq ss2 (DEL_OBJ ss1 ss4))                           ;;·�����·������ (��������)
     
     )
    
    ((= ben 2)	
     
     (setq ss7 (DEL_OBJ sal ss4))    ;;�� ss4ѡ����  ɾ���ں�sal������,ʣ������·�� (ע:��sal (t2=0)�к�����������ᱻȥ�� )         *****
     (if (= t2 1)(setq ss (DEL_OBJ ss1 ss7))(setq ss ss7))  ;;�� t2=1 ��ȥ��������
     
     (setq ssc (DEL_OBJ ss1 sal))                                 ;;����·���˫�� 
     

     ;;----------------------------------------------�ҳ��벹·���ཻ�ĵ�·��	 
     
     
     (progn
       (setq  obj_a nil) 
       (setq eel (tt ssc ss))                                ;;�����·��˫���������� �Ƿ����ཻ
       (vl-cmdf "_draworder" ssc "" "b")                     ;;������·���˫���������·� (���� "b" ���·� )
       
       
       (setq  obj_a (ssadd))                                 ;;�ɽ��㴮���ҵ����� 
       (foreach  x  eel
		 (setq mm (ssname (ssget "C" x x ) 0))
		 (setq obj_a (ssadd  mm obj_a))		               ;;�������ѡ����
		 
	         )
       
       )

     ;;---------------------------------------------	�ҳ��벹·���ཻ�ĵ�·�� ��obj_a
     
     (setq ss2 (add_obj obj_a ssc))                          ;; �����������ĵ�· ���봿��·�� ��������
     
     )
    ) 
  
  
  
  (break_all ss2)                                        ;;�������·�߶Ͽ�
  
  (sel_obj ss1)                                               ;������ ǰ����ʼ�� pd1 ��ĩ�ν����� pd2		
  (setq pbel  (list pd1 pd2))
  
  
  (setq ss3 (ssget "C" pt1 pt2 ))                        ;;��۳����Ͽ��� ss3,ss2 �����
  (setq ss4 (ssget "_P" (list (cons 8 "���ε�ò")(cons 0 "LINE")))) ;;��ss3���ٹ���ֻȡ��	*****	
  (setq ss2 (DEL_OBJ ss1 ss4))                           ;;��һ��ȡ�� �ο��� SS2 ���
  
  
  
  ;;����������� cent �������ж�  (cent > 3)�ǻ����µ�· ����(cent < 3)�ڻ�õ�·�� ������·��������һ������·	
  (setq cent (Take_inters ss1 ) )                         ;�����߽��� 
  
  
  (cond 
    ((= gen 1)                                             ;;(gen/=2 ������·)    (gen=2 ����ȡ����ֵ)
     (if (and (/= cent nil) (> (length cent) 3))          ;;������·��(cent \= nil)
	 (Add_route_processing)                              ;;�����µ�·�ҳ�ȥ��·�в���Ҫ�߶ε�ѡȡ��                                                        
         (Pull_a_route)                                      ;;��·֮������һ��·�ҳ�ȥ��·�в���Ҫ�߶ε�ѡȡ��                                  
	 
	 ) ;end_if
     )	
    
    
    ((= gen 2)(Pull_a_route))                                ;;�ڼ��еĵ�·�ϻ���ȡ��·��ֵ
    
    )	
  
  
  (command "erase" ss1 "")                               ;ɾ����·������
  
  ;;------------------------------------------
  ;; tel :������������·�߹�ͬ���㴮��	��: tel=((3330.46 497.587 0.0) (3383.14 527.11 0.0) (3360.46 444.06 0.0) (3413.14 473.583 0.0))
  ;;��·���������߻�����ʼ��������ʮ��·���ߵ�4���е�������� ,����ҵ���Щ�����ɽ���·�ڲ���Ҫ����ȥ��

  (del_line tel)                                        ;�����е���·�ж�Ӧ�ĵ��߶� ��ȥ��֮
  
  (setq ss3 (ssget "C" pt1 pt2 ))                       ;;ѡȡ�����·��+������                   
  (setq ss4 (ssget "_P" (list (cons 8 "���ε�ò")(cons 0 "LINE")))) ;;��ss3���ٹ���ֻȡ��	****
  (pj ss4)                                              ;;��ss3ѡ���� line �߽Ӻ�Ϊ pline�� ****
  
  (sel_Fillet "���ε�ò" kng)                            ;ֻ��ָ���Ĳ�� ��Բ��=kng   ����ʽ( sel_Fillet "���ݲ���"  ��Բ��ֵ)
  
  (command "zoom" "p")                                  ;;��ʾǰһ���淶Χ

  (RestoreVars)                                          ;;��ԭ�����ϵͳ����
  (princ)
  (princ (strcat "\n<<< ��·�� = " (rtos ww 2 1) " >>> <<< ��Բ��ֵ = " (rtos kng 2 1)" >>>"))
  (princ)  
  )  ;end_defun_Draw_the_road

(defun road-cross:help ()
  (@:help "<<<  ����·��  ִ��ָ��:rd (·���ɻ�������1,2��) ָ��:srd (·���ɼ�������)  ִ��ָ��:sld ������·�� ����·�䲹һ��· ָ��:std  ��Բ��,Ѱ·�����ֵ �����趨  >>>")
  (princ))



					;******************************************************************************************************************************************************************
					;******************************************************************************************************************************************************************

;;<<<<****  ��������µ�·�� ȥ��·�����в���Ҫ�ߵ�ѡ���е�  ****>>>-----start
(defun Add_route_processing()

  (progn		
    (setq rd_no 1) 
    (setq road (Take_inters ss2 ) )                         ;�����·�߽���        
    (setq ss3 (ssget "C" pt1 pt2 ))                                                            
    (setq ss4 (ssget "_P" (list (cons 8 "���ε�ò")(cons 0 "LINE")))) ;;��ss3���ٹ���ֻȡ��	  ****
    (setq rocen(Take_inters ss4 ) )                         ;�����·��+���������γɵĽ���    ****
    
    
    (setq sel (remove_ab cent rocen))                      ;ȥ��������ʣ�����·��+��������
    (setq tel (remove_ab road sel))                        ;��ȥ�����·�߽�����ʣ�µĵ� ������ʮ��·��Ҫȥ���Ľ���
    (setq  vet (ssadd))
    (foreach  x  pbel
	      (setq mm (ssname (ssget "C" x x ) 0))
	      (setq vet (ssadd  mm vet))		               ;;��ͷβ���˵ķ���߼���ѡ����
	      (command "erase" vet "")                      ;;ɾ��ͷβ��                     
	      )
    
    );end_progn  
  );end_defun_Add_route_processing

;;<<<<****  ��������µ�·�� ȥ��·�����в���Ҫ�ߵ�ѡ���е�  ****>>>-----end
					;------------------------------------------------------------
;;<<<<****  ��������·֮������һ��· ȥ��·�����в���Ҫ�ߵ�ѡ���е�       ****>>>-----start
(defun Pull_a_route()


  (progn                                           
    
    (setq rd_no 2) 
    
    (vl-cmdf "_draworder" ss1 "" "b")                         ;;�������������·� (���� "b" ���·� )
    ;;˵�� �������߷�������ͷβ�ߵ��·� �����¸��������ȷ��ѡ��ͷβ��	  
    
    (foreach  x  pbel                                      ;;pbel=ͷβ�˴��е� ,�ɵ�ȥѡ��ʵ����
	      (setq mm (ssname (ssget "C" x x ) 0))
	      (setq ss1 (ssadd  mm ss1))		               ;;��ͷβ���˵ķ����Ҳ����������ѡ����
	      )
    

    (setq ss3 (ssget "C" pt1 pt2 ))                         ;;ѡȡ�����·��+������                    ;;
    (setq ss4 (ssget "_P" (list (cons 8 "���ε�ò")(cons 0 "LINE"))))       ;;����ֻȡ��
    (setq ss2 (DEL_OBJ ss1 ss4))                           ;;·�����·��������  ss3 �۳� ss1 ���� ***
    
    (break_all ss2)                                        ;;�����н��㴦�߶Ͽ�
    (setq ss3 (ssget "C" pt1 pt2 ))                        ;;��۳����Ͽ��� ss3,ss2 �����  @@@
    (setq ss4 (ssget "_P" (list (cons 8 "���ε�ò")(cons 0 "LINE"))))       ;;����ֻȡ��            ****
    (setq ss2 (DEL_OBJ ss1 ss4))                           ;;������������ȡ�� SS2 ��� @@@@         ****
    
    
    (setq tel (tt ss1 ss2))                                 ;;���·���������·��˫�� �������Ľ��㴮��(��Щ����ɵ���ȥ�����ѡȡ��)
    
    (setq qel (find_rd  tel))                               ;����·�� ������һ��·�ж��м��Խʱ�Ƿ���ʮ��·��  
					;����һ���� �㴮�� tel �貹��·���������´�ֱ���˵� �Դ�����
    (if (/= qel nil)(setq tel qel))                        ;��ʮ��·�� �� ��qel����tel ���� telά�ֲ���
    
    
    );end_progn         

  );end_defun_Pull_a_route

;;<<<<****  ��������·֮������һ��· ȥ��·�����в���Ҫ�ߵ�ѡ���е�       ****>>>-----end


;;-----------------------------------------------------------------------
;; ��������·֮������һ��· 
;; �� e1 �߼������ҳ��� e2 �߼����� �������ཻ��
(defun tt(e1 e2 / i n1 n2 e1 e2 obj1 obj2 ipt)

  (setq lst nil)

  (setq i   0 
        n1  (sslength e1)
        n2  (sslength e2)
	
	)
  (repeat n1 
	  (setq obj1 (vlax-ename->vla-object (ssname e1 i)))
	  (setq j 0)
	  (repeat n2 
		  (setq obj2 (vlax-ename->vla-object (ssname e2 j))
			ipt  (vlax-variant-value (vla-intersectwith obj1 obj2 0))
			)
		  (if (> (vlax-safearray-get-u-bound ipt 1) 0)
		      (progn
			(setq ipt (vlax-safearray->list ipt))
			(while (> (length ipt) 0)
			  (setq lst (cons (list (car ipt) (cadr ipt) (caddr ipt)) lst) ipt (cdddr ipt))
			  )
			)
		      )
		  (setq j (+ j 1))
		  )
	  (setq i (+ i 1))
	  )
  
  (setq lst (Remove_Dup lst))      ;;ȥ���ظ��� 
  lst                        ;;��Ӧ�㴮ֵ
  )

					;----------------------------------- 
;;ȡ�������߶ε���ʼ����ֹ��        
(defun get_cen_line( bb / i ev )

  (setq  i 0  kel nil)
  (repeat (sslength bb)
          (setq ev (cdr(assoc 10 (entget (ssname bb i )))))
          (setq kel (cons ev kel))
	  (setq ev (cdr(assoc 11 (entget (ssname bb i )))))
          (setq kel (cons ev kel))
	  
	  (setq i(+ i 1))

	  )

  kel                                ;;��Ӧ�㴮ֵ
  
  );end_defun

;;----------------------------------
;;�ڵ㴮���и� p��ֵ �ҳ���ӽ��ĵ�
(defun get_start_point(p vv / p s d n)
  (foreach x vv

	   (if (not d)
               (setq d (distance p x)
                     s x
		     )
               (if
		(< (setq n (distance p  x)) d)
		(setq d n
                      s x
		      )
		)
               )
	   
	   )
  s                                        ;��Ӧ�ҵ��ӽ���
  );end_defun


;;-------------------------------------------------------------------
;;ȡ�������ߵ�һ����ʼ��,���һ��������
(defun sel_obj(v1)
  (setq nb nil)  
  (repeat (setq i(sslength v1))
	  (setq na (ssname v1 (setq i (1- i))))
	  (setq nb (cons na nb))
	  
	  )
  (setq pd2 (cdr(assoc 11 (entget(car nb)))))
  (setq pd1 (cdr(assoc 10 (entget(car (reverse nb))))))
  )

;;-------------------------------------------------------------------
;;ȡ�� milne,plineͼԪ�� ���㴮��
;; pline n=10
;; mline n=11
;;�� (setq en (entlast)
;;  (peek en 10)

(defun peek(vr n / obj)

  (setq ptx nil)
  (setq obj (vlax-ename->vla-object vr))
  (progn
    (setq ptx (mapcar 'cdr
		      (vl-remove-if-not '(lambda (x) (= (car x) n)) (entget  vr) )
		      )
	  )
    
    );end_progn
  ptx                    ;��Ӧ�㴮��ֵ
  )

;;-------------------------------------------------------------------
;;ָ����v1 ����ѡ�� v2��
(defun add_obj(v1 v2)
  
  (repeat (setq i(sslength v1))
	  (setq je (ssname v1 (setq i (1- i))))
	  (setq v2 (ssadd je v2))
	  
	  )
  v2
  )

;;-------------------------------------------------------------------
;;ָ����v1 ��ѡ��v2�� �Ƴ�
(defun del_obj(v1 v2)
  
  (repeat (setq i(sslength v1))
	  (setq de (ssname v1 (setq i (1- i))))
	  (setq v2 (ssdel de v2))
	  
	  )
  v2
  )

;;-------------------------------------------------------------------
;;ָ����Ӵ������Ƴ�
(defun del_line(v)
  
  (foreach x1   v
           (setq ee (ssget "C" x1 x1 ))
	   (command "erase" ee "")
	   )
  )

;;-------------------------------------------------------------------
;;ָ����Ӵ������Ƴ�
(defun remove_ab(kk ee)
  (setq wel ee)
  (foreach x   kk
           (setq wel (vl-remove x wel))
	   )
  wel
  )
;;--------------------------------------------------------------------
					;�½�ͼ�� ��ɫ ����
(defun BF-Ent-MakeLayer  (v1 v2 v3 )  

  (vl-cmdf "-layer" "_N" v1 "_C"  v2 v1 "_L" v3 v1 "")

  )
;;--------------------------------------------------------------------
;;��Ϊ������
(defun BF-ent-ActiveLayer (v1)  ;��Ϊ������
  (vl-cmdf "_.-LAYER" "_S" v1 "")
  )



;;--------------------------------------------------------------------
;;��Բ�� 
;;;;��ָ��ͼ����ѡȡ��Χ�ڵ� pline �� ���е�Բ�Ǵ���
;;;;��:  (sel_Fillet "���ε�ò" 3)
;;
(defun sel_Fillet ( v1 v2 / bn sel ent)  
  (and
   (or (/= 4
           (logand 4
                   (cdr (assoc 70 (entget (tblobjname "LAYER" v1))))
		   )
           )
       (alert (strcat "ͼ������< " v1 ">�������� ����������һ��"))
       )
   )
  (setq ssP (ssget "C" pt1 pt2))
  (setq bn -1
        sel (ssget "_P"
                   (list '(0 . "LWPOLYLINE")
                         (cons 8 v1)
                         (cons 410 (getvar 'CTAB))
			 )
		   )
	)
  (setvar 'FILLETRAD v2)
  (repeat (setq i(sslength sel))
	  (setq ent (ssname sel (setq i (1- i))))
	  (command "._fillet" "_P" ent  )
	  
	  )
  (command "-purge" "z")  ;ɾ������Ϊ0����
  )
;;-------------------------------------------------------------------

;;ȡ���������ֵ�������С��Χ��
;; ��:(setq s1 (entlast)
;;     (chack_obj_area)
(defun chack_obj_area ()

  (command "area" "o" s1)                                      ;�����������
  (setq obj_area (getvar "area"))                              ;ȡ���������ֵ
  (setq txt_area (rtos obj_area 2 2))
  
  ;;�󻭳�������������ĵ�
  (setq ptlist nil)
  (vla-GetBoundingBox (vlax-ename->vla-object s1) 'll 'rr)  ;�õ�����İ�Χ��
  (setq box (list (vlax-safearray->list ll) (vlax-safearray->list rr)))  ;ȡ���ο� box=(���µ�,���ϵ�)
  (setq ptlist (append box ptlist))        
  (setq ssbox (mapcar '(lambda (x) (apply 'mapcar (cons x ptlist))) (list 'min 'max))) ;;��(���µ�,���ϵ�)����������ο��ĸ��Խǵ�
  
  (setq p (apply 'mapcar (cons (function (lambda (a b) (/ (+ a b) 2))) ssbox))) ;;������Ͱ�Χ�����ĵ㣬p��
  

  )

;;--------------------------
(defun LM:EntnexttoEnd ( e )
  (if (setq e (entnext e))
      (cons e (LM:EntnexttoEnd e))
      )
  )
;;-----------------------------------------------------------------
;;������İ�Χ��Ŵ� 
;;������ȡ��С��Χ���޷�����ס�����轫���Ǿ������1.4������ ���ܺ�����ѡ�����
;;  ����Ȧѡ��Χ  ���� pw:���ĵ� v1,v2������С��Χ�������(����) ��v3:Ҫ�Ŵ�ı��� 
;; ����Խ�����: pt1 pt2
(defun  scal_x (v1 v2 v3)
  
  (setq ang (angle v1 v2))
  (setq md   (* (distance v1 v2 ) 0.5))                                ;;�����߳���
  (setq pw   (polar v1 (angle v1 v2) md))                              ;;���е�
  (setq ds1  (* (distance v1 v2) v3))                                  ;; 
  (setq pt1  (polar pw   (angle v1 v2) (* ds1 0.5)))                   ;;�����Ҷ��Ŵ�� ds1��2
  (setq pt2  (polar pw   (angle v2 v1) (* ds1 0.5)))
  

  )



;;-----------------------------------------------------------------------------
;;�߽Ӻ�Ϊpline��
(defun PJ (ss / cmde peac ); = Polyline Join

  (setq
   cmde (getvar 'cmdecho)
   peac (getvar 'peditaccept)
   ); end setq
  (setvar 'cmdecho 0)
  (setvar 'peditaccept 1)
  (if ss
      (if (= (sslength ss) 1)
	  (command "_.pedit" ss "_join" "_all" "" ""); then
	  (command "_.pedit" "_multiple" ss "" "_join" "0.0000001" ""); else
	  ); end inner if
      ); end outer if
  (setvar 'cmdecho cmde)
  (setvar 'peditaccept peac)
  (princ)
  ); end defun

					;----------------------------------------------------------------------
;;���������С��Χ�� (���µ�p1,p2���ϵ�)
(defun obj_min_box(en)
  (vla-getboundingbox (vlax-ename->vla-object en) 'p1 'p2)         ;;������ʼ������������С�߽�� ����p1,����p2
  (setq p1 (vlax-safearray->list p1) p2 (vlax-safearray->list p2)) ;;����ʼ���p1,p2 תΪʵ�ʵ�����(���µ�p1,p2���ϵ�)
  (setq pp (list p1 p2))
  )
;;--------------------------------------------------------------------
;;�ָ�MLԭ�趨
(defun stml ()
  (setvar "cmlstyle" "STANDARD")
  )

;;------------------------------------------------------------------------------------ 
;;������س�ʽ
(defun load_Sub_lsp()
  ;; (setvar "SECURELOAD" 0)                            ;;�رհ����뵵����ȫ������ʾѶϢ   0:�ر� 1:��
  (load "./DATA/draw_line_obj.lsp")                  ;;���뻭��ȡ·���ʽ      ִ��ָ��: (drl)   ��Ӧȡ�ص�·����ֵ: uel
  (load "./DATA/set_mline2.lsp")                     ;;����mline�����趨��ʽ   ִ��ָ��: (set_mline)
  (load "./data/Take_inters.lsp")                    ;ȡ�����ཻ��          ִ��ָ��: (Take_inters ss )  ��Ӧֵ: ���㴮�� lst ��
  (load "./data/find_rd.lsp") 	                   ;����·�� ������һ��·�ж��м��Խʱ�Ƿ���ʮ��·�� 
					;����һ���� �㴮�� tel �貹��·���������´�ֱ���˵� �Դ�����
					;ִ��: (find_rd)  ���õ��ĵ㴮�� tel   ��Ӧ: tel (����ʮ��·��tel�Ჹ���´�ֱ��)													  
  (load "./data/breakall.LSP")                       ;��ѡ��line�߶Ͽ���ʽ  ִ��ָ��: (break_all ss1) 
					; ��: (setq ss1 (ssget "X" '((0 . "LINE")(62 . 0))))  (breakall SS1)  ���Զ�ִ��
  ;;(setvar "SECURELOAD" 1)                            ;;�򿪰����뵵����ȫ������ʾѶϢ   0:�ر� 1:��
  (setq load_chack 1)                                ;���������lisp ��ʽ                                   
  ) 

					;-------------------------------------------------------------------------------------
					; ��;: ����Ŀǰ��ϵͳ����
					; ����: Tom 2002/10/01
					; �÷�: (SaveVars (list "cmdecho" .... )) ��Ҫ�����ϵͳ�������� list ��
					; ע������: �˹��ܽ���ֻʹ���� C: ��ͷ��ָ���
					; ������������: #lSysVars
					;-------------------------------------------------------------------------------------
(defun SaveVars( lVars / zVar )
  (setq #lSysVars '())
  (foreach zVar lVars
	   (setq #lSysVars (append #lSysVars (list (cons zVar (getvar zVar)))))
	   )
  )

					;-------------------------------------------------------------------------------------
					; ��;: ��ԭ�����ϵͳ����
					; ����: Tom 2002/10/01
					; �÷�: (RestoreVars)
					; ע������: �˹��ܽ���ֻʹ���� C: ��ͷ��ָ���
					; ʹ�ù�������: #lSysVars  ������ sample.lsp (SaveVars)
					;-------------------------------------------------------------------------------------
(defun RestoreVars( / aVar )
  (foreach aVar #lSysVars
	   (setvar (car aVar) (cdr aVar))
	   )
  )

					;-------------------------------------------------------------------------------------

					;******************************************************************************************************************************************************************
					;******************************************************************************************************************************************************************

					;-------------------------------------------------------------------------------------
;;BY LEE50310  ���� 109 / 10/ 28��
;;ʹ���ڵ�·����
;;mline ������ʽ
;; 1.˫��ʵ������ͷβ��ֱ���
;; 2.�������� ʵ�� ,��ɫ ��ɫ  (ps:��������ɫ��ɫ����� ��ʽ��Ѱ����������)
;; 3.������ʵ(Continuous) ������ĳ�����(HIDDEN) ԭ���������������ཻ,�����ж����߸պô�Խ�����пմ���������г��޽���     
;;----------------------------------------------------------------------------------
(defun set_mline(/ mlDict mlList)
  (if (= nil (member (cons 3 "VENP")(dictsearch (namedobjdict) "ACAD_MLINESTYLE"))) 
      (progn
	(setq mlDict (cdr(assoc -1(dictsearch (namedobjdict) "ACAD_MLINESTYLE"))))
	(setq mlList (list'(0 . "MLINESTYLE")
	                  '(102 . "{ACAD_REACTORS")
			  '(102 . "}")
                          '(100 . "AcDbMlineStyle")
                          (cons 2  "VENP")         ;˫�ߵ�����
			  (cons 70  272)           ;˫�� 0 ͷβ���պ� , 272 ͷβ�պ���
                          (cons 3  "·���߻���")   ;����ʽ������
                          (cons 51  1.5708)        ;��ʼ�� �Ƕ�90��
                          (cons 52  1.5708)        ;��ֹ�� �Ƕ�90��
                          (cons 71  3)
                          (cons 49  0.5)           ;�ϵ���ƫ��
                          (cons 62  256)           ;�ϵ�����ɫ
                          (cons 6  "BYLAYER")      ;�ϵ�������
                          (cons 49  0.0)           ;����ƫ��
                          (cons 62  1)             ;��ɫ:�����ߺ�ɫ
                          (cons 6  "Continuous")   ;����:ʵ��
                          (cons 49  -0.5)          ;�µ���ƫ��         
                          (cons 62  256)           ;�µ�����ɫ
                          (cons 6  "BYLAYER")      ;�µ�������
			  ); end list
	      ); end setq
	(dictadd mlDict "VENP" (entmakex mlList))
	); end progn
      ); end if
  (setvar "cmlstyle" "VENP")           ;;������ʽ ���� "VENP" ��ΪĿǰ
  ); end defun


;;***********************************************************************************************************************************************
;;***********************************************************************************************************************************************

					;--------------------------------------------------------------------------
;;�߽���Ͽ���ʽ  (ȡ�Թ�����վ)
;;(֧Ԯ���� "LINE,ARC,SPLINE,LWPOLYLINE,POLYLINE,CIRCLE,ELLIPSE")
;;
;;-------------------------------------------------------------------------

;;;=======================[ BreakObjects.lsp ]=============================
;;; Author: Copyright?2006-2019 Charles Alan Butler 
;;; Contact @  www.TheSwamp.org    
;;; Version:  2.3  June 6,2019
;;; Purpose: Break All selected objects
;;;    permitted objects are lines, lwplines, plines, splines,
;;;    ellipse, circles & arcs 
;;;                            
;;;  Function  c:BreakAll -      Break all objects selected with each other


(setq Brics (wcmatch  (getvar 'acadver) "*BricsCAD*" )) ; test for BricsCAD 06.06.19

;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;               M A I N   S U B R O U T I N E                   
;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

(defun break_with (ss2brk ss2brkwith self Gap / cmd intpts lst masterlist ss ssobjs
                   onlockedlayer ssget->vla-list list->3pair GetNewEntities oc
                   get_interpts break_obj GetLastEnt LastEntInDatabase ss2brkwithList
                   )
  ;; ss2brk     selection set to break
  ;; ss2brkwith selection set to use as break points
  ;; self       when true will allow an object to break itself
  ;;            note that plined will break at each vertex
  ;;
  ;; return list of enames of new objects
  
  (vl-load-com)
  
  (princ "\nCalculating Break Points, Please Wait.\n")

  ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ;;                S U B   F U N C T I O N S                      
  ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  ;;  return T if entity is on a locked layer
  (defun onlockedlayer (ename / entlst)
    (setq entlst (tblsearch "LAYER" (cdr (assoc 8 (entget ename)))))
    (= 4 (logand 4 (cdr (assoc 70 entlst))))
    )
  
  ;;  return a list of objects from a selection set
  ;;  (defun ssget->vla-list (ss)
  ;;  (mapcar 'vlax-ename->vla-object (vl-remove-if 'listp (mapcar 'cadr (ssnamex ss ))))
  ;;)
  (defun ssget->vla-list (ss / i ename allobj) ; this is faster, changed in ver 1.7
    (setq i -1)
    (while (setq  ename (ssname ss (setq i (1+ i))))
      (setq allobj (cons (vlax-ename->vla-object ename) allobj))
      )
    allobj
    )
  
  ;;  return a list of lists grouped by 3 from a flat list
  (defun list->3pair (old / new)
    (while (setq new (cons (list (car old) (cadr old) (caddr old)) new)
                 old (cdddr old)))
    (reverse new)
    )
  
  ;;=====================================
  ;;  return a list of intersect points  
  ;;=====================================
  (defun get_interpts (obj1 obj2 / iplist)
    (if (not (vl-catch-all-error-p
              (setq iplist (vl-catch-all-apply
                            'vlax-safearray->list
                            (list
                             (vlax-variant-value
                              (vla-intersectwith obj1 obj2 acextendnone)
                              ))))))
	iplist
	)
    )


  ;;========================================
  ;;  Break entity at break points in list  
  ;;========================================
  ;;   New as per version 1.8 [BrkGap] --- This subroutine has been re-written
  ;;  Loop through the break points breaking the entity
  ;;  If the entity is not a closed entity then a new object is created
  ;;  This object is added to a list. When break points don't fall on the current 
  ;;  entity the list of new entities are searched to locate the entity that the 
  ;;  point is on so it can be broken.
  ;;  "Break with a Gap" has been added to this routine. The problem faced with 
  ;;  this method is that sections to be removed may lap if the break points are
  ;;  too close to each other. The solution is to create a list of break point pairs 
  ;;  representing the gap to be removed and test to see if there i an overlap. If
  ;;  there is then merge the break point pairs into one large gap. This way the 
  ;;  points will always fall on an object with one exception. If the gap is too near
  ;;  the end of an object one break point will be off the end and therefore that 
  ;;  point will need to be replaced with the end point.
  ;;    NOTE: in ACAD2000 the (vlax-curve-getdistatpoint function has proven unreliable
  ;;  so I have used (vlax-curve-getdistatparam in most cases
  (defun break_obj (ent brkptlst BrkGap / brkobjlst en enttype maxparam closedobj
                    minparam obj obj2break p1param p2param brkpt2 dlst idx brkptS
                    brkptE brkpt result GapFlg result ignore dist tmppt
                    #ofpts 2gap enddist lastent obj2break stdist
                    )
    (or BrkGap (setq BrkGap 0.0)) ; default to 0
    (setq BrkGap (/ BrkGap 2.0)) ; if Gap use 1/2 per side of break point
    
    (setq obj2break ent
          brkobjlst (list ent)
          enttype   (cdr (assoc 0 (entget ent)))
          GapFlg    (not (zerop BrkGap)) ; gap > 0
          closedobj (vlax-curve-isclosed obj2break)
	  )
    ;; when zero gap no need to break at end points, not closed
    (if (and (zerop Brkgap)(not closedobj)) ; Revision 2.2
	(setq spt (vlax-curve-getstartpoint ent)
              ept (vlax-curve-getendpoint ent)
              brkptlst (vl-remove-if '(lambda(x) (or (< (distance x spt) 0.0001)
                                                  (< (distance x ept) 0.0001)))
                                     brkptlst)
	      )
	)
    (if brkptlst
	(progn
	  ;;  sort break points based on the distance along the break object
	  ;;  get distance to break point, catch error if pt is off end
	  ;; ver 2.0 fix - added COND to fix break point is at the end of a
	  ;; line which is not a valid break but does no harm
	  (setq brkptlst (mapcar '(lambda(x) (list x (vlax-curve-getdistatparam obj2break
						      ;; ver 2.0 fix
						      (cond ((vlax-curve-getparamatpoint obj2break x))
							    ((vlax-curve-getparamatpoint obj2break
											 (vlax-curve-getclosestpointto obj2break x))))))
				   ) brkptlst))
	  ;; sort primary list on distance
	  (setq brkptlst (vl-sort brkptlst '(lambda (a1 a2) (< (cadr a1) (cadr a2)))))
	  
	  (if GapFlg ; gap > 0
	      ;; Brkptlst starts as the break point and then a list of pairs of points
	      ;;  is creates as the break points
	      (progn
		;;  create a list of list of break points
		;;  ((idx# stpoint distance)(idx# endpoint distance)...)
		(setq idx 0)
		(foreach brkpt brkptlst
			 
			 ;; ----------------------------------------------------------
			 ;;  create start break point, then create end break point    
			 ;;  ((idx# startpoint distance)(idx# endpoint distance)...)  
			 ;; ----------------------------------------------------------
			 (setq dist (cadr brkpt)) ; distance to center of gap
			 ;;  subtract gap to get start point of break gap
			 (cond
			   ((and (minusp (setq stDist (- dist BrkGap))) closedobj )
			    (setq stdist (+ (vlax-curve-getdistatparam obj2break
								       (vlax-curve-getendparam obj2break)) stDist))
			    (setq dlst (cons (list idx
						   (vlax-curve-getpointatparam obj2break
									       (vlax-curve-getparamatdist obj2break stDist))
						   stDist) dlst))
			    )
			   ((minusp stDist) ; off start of object so get startpoint
			    (setq dlst (cons (list idx (vlax-curve-getstartpoint obj2break) 0.0) dlst))
			    )
			   (t
			    (setq dlst (cons (list idx
						   (vlax-curve-getpointatparam obj2break
									       (vlax-curve-getparamatdist obj2break stDist))
						   stDist) dlst))
			    )
			   )
			 ;;  add gap to get end point of break gap
			 (cond
			   ((and (> (setq stDist (+ dist BrkGap))
				    (setq endDist (vlax-curve-getdistatparam obj2break
									     (vlax-curve-getendparam obj2break)))) closedobj )
			    (setq stdist (- stDist endDist))
			    (setq dlst (cons (list idx
						   (vlax-curve-getpointatparam obj2break
									       (vlax-curve-getparamatdist obj2break stDist))
						   stDist) dlst))
			    )
			   ((> stDist endDist) ; off end of object so get endpoint
			    (setq dlst (cons (list idx
						   (vlax-curve-getpointatparam obj2break
									       (vlax-curve-getendparam obj2break))
						   endDist) dlst))
			    )
			   (t
			    (setq dlst (cons (list idx
						   (vlax-curve-getpointatparam obj2break
									       (vlax-curve-getparamatdist obj2break stDist))
						   stDist) dlst))
			    )
			   )
			 ;; -------------------------------------------------------
			 (setq idx (1+ IDX))
			 ) ; foreach brkpt brkptlst
		

		(setq dlst (reverse dlst))
		;;  remove the points of the gap segments that overlap
		(setq idx -1
		      2gap (* BrkGap 2)
		      #ofPts (length Brkptlst)
		      )
		(while (<= (setq idx (1+ idx)) #ofPts)
		  (cond
		    ((null result) ; 1st time through
		     (setq result (list (car dlst)) ; get first start point
			   result (cons (nth (1+(* idx 2)) dlst) result))
		     )
		    ((= idx #ofPts) ; last pass, check for wrap
		     (if (and closedobj (> #ofPts 1)
			      (<= (+(- (vlax-curve-getdistatparam obj2break
								  (vlax-curve-getendparam obj2break))
				       (cadr (last BrkPtLst))) (cadar BrkPtLst)) 2Gap))
			 (progn
			   (if (zerop (rem (length result) 2))
			       (setq result (cdr result)) ; remove the last end point
			       )
			   ;;  ignore previous endpoint and present start point
			   (setq result (cons (cadr (reverse result)) result) ; get last end point
				 result (cdr (reverse result))
				 result (reverse (cdr result)))
			   )
			 )
		     )
		    ;; Break Gap Overlaps
		    ((< (cadr (nth idx Brkptlst)) (+ (cadr (nth (1- idx) Brkptlst)) 2Gap))
		     (if (zerop (rem (length result) 2))
			 (setq result (cdr result)) ; remove the last end point
			 )
		     ;;  ignore previous endpoint and present start point
		     (setq result (cons (nth (1+(* idx 2)) dlst) result)) ; get present end point
		     )
		    ;; Break Gap does Not Overlap previous point 
		    (t
		     (setq result (cons (nth (* idx 2) dlst) result)) ; get this start point
		     (setq result (cons (nth (1+(* idx 2)) dlst) result)) ; get this end point
		     )
		    ) ; end cond stmt
		  ) ; while
		
		;;  setup brkptlst with pair of break pts ((p1 p2)(p3 p4)...)
		;;  one of the pair of points will be on the object that
		;;  needs to be broken
		(setq dlst     (reverse result)
		      brkptlst nil)
		(while dlst ; grab the points only
		  (setq brkptlst (cons (list (cadar dlst)(cadadr dlst)) brkptlst)
			dlst   (cddr dlst))
		  )
		)
	      )
	  ;;   -----------------------------------------------------

	  ;; (if (equal  a ent) (princ)) ; debug CAB  
	  
	  (foreach brkpt (reverse brkptlst)
		   (if GapFlg ; gap > 0
		       (setq brkptS (car brkpt)
			     brkptE (cadr brkpt))
		       (setq brkptS (car brkpt)
			     brkptE brkptS)
		       )
		   ;;  get last entity created via break in case multiple breaks
		   (if brkobjlst
		       (progn
			 (setq tmppt brkptS) ; use only one of the pair of breakpoints
			 ;;  if pt not on object x, switch objects
			 (if (not (numberp (vl-catch-all-apply
					    'vlax-curve-getdistatpoint (list obj2break tmppt))))
			     (progn ; find the one that pt is on
			       (setq idx (length brkobjlst))
			       (while (and (not (minusp (setq idx (1- idx))))
					   (setq obj (nth idx brkobjlst))
					   (if (numberp (vl-catch-all-apply
							 'vlax-curve-getdistatpoint (list obj tmppt)))
					       (null (setq obj2break obj)) ; switch objects, null causes exit
					       t
					       )
					   )
				 )
			       )
			     )
			 )
		       )
		   ;; 	;| ;; ver 2.0 fix - removed this code as there are cases where the break point
		   ;; ;; is at the end of a line which is not a valid break but does no harm
		   ;; (if (and brkobjlst idx (minusp idx)
		   ;; 	    (null (alert (strcat "Error - point not on object"
		   ;; 				 "\nPlease report this error to"
		   ;; 				 "\n   CAB at TheSwamp.org"))))
		   ;;     (exit)
		   ;;     )
		   ;; |;
		   ;; (if (equal (if (null a)(setq a (car(entsel"\nTest Ent"))) a) ent) (princ)) ; debug CAB  -------------

		   ;;  Handle any objects that can not be used with the Break Command
		   ;;  using one point, gap of 0.000001 is used
		   (setq closedobj (vlax-curve-isclosed obj2break))
		   (if GapFlg ; gap > 0
		       (if closedobj
			   (progn ; need to break a closed object
			     (setq brkpt2 (vlax-curve-getPointAtDist obj2break
								     (- (vlax-curve-getDistAtPoint obj2break brkptE) 0.00001)))
			     (command "._break" obj2break "_non" (trans brkpt2 0 1)
				      "_non" (trans brkptE 0 1))
			     (and (= "CIRCLE" enttype) (setq enttype "ARC"))
			     (setq BrkptE brkpt2)
			     )
			   )
		       ;;  single breakpoint ----------------------------------------------------
		       ;;  ;|(if (and closedobj ; problems with ACAD200 & this code
		       ;; 		 (not (setq brkptE (vlax-curve-getPointAtDist obj2break
		       ;; 							      (+ (vlax-curve-getDistAtPoint obj2break brkptS) 0.00001))))
		       ;; 		 )
		       ;; (setq brkptE (vlax-curve-getPointAtDist obj2break
		       ;; 						    (- (vlax-curve-getDistAtPoint obj2break brkptS) 0.00001)))
		       
		       ;; 	    )|;
		       (if (and closedobj 
				(not (setq brkptE (vlax-curve-getPointAtDist obj2break
									     (+ (vlax-curve-getdistatparam obj2break
													   ;;(vlax-curve-getparamatpoint obj2break brkpts)) 0.00001))))
													   ;; ver 2.0 fix
													   (cond ((vlax-curve-getparamatpoint obj2break brkpts))
														 ((vlax-curve-getparamatpoint obj2break
																	      (vlax-curve-getclosestpointto obj2break brkpts))))) 0.00001)))))
			   (setq brkptE (vlax-curve-getPointAtDist obj2break
								   (- (vlax-curve-getdistatparam obj2break
												 ;;(vlax-curve-getparamatpoint obj2break brkpts)) 0.00001)))
												 ;; ver 2.0 fix
												 (cond ((vlax-curve-getparamatpoint obj2break brkpts))
												       ((vlax-curve-getparamatpoint obj2break
																    (vlax-curve-getclosestpointto obj2break brkpts))))) 0.00001)))
			   )
		       ) ; endif
		   
		   ;; (if (null brkptE) (princ)) ; debug
		   
		   (setq LastEnt (GetLastEnt))
		   (command "._break" obj2break "_non" (trans brkptS 0 1) "_non" (trans brkptE 0 1))
		   (and *BrkVerbose* (princ (setq *brkcnt* (1+ *brkcnt*))) (princ "\r"))
		   (and (= "CIRCLE" enttype) (setq enttype "ARC"))
		   (if (and (not closedobj) ; new object was created
			    (not (equal LastEnt (entlast))))
		       (setq brkobjlst (cons (entlast) brkobjlst))
		       )
		   )
	  )
	) ; endif brkptlst
    
    ) ; defun break_obj

  ;;====================================
  ;;  CAB - get last entity in datatbase
  (defun GetLastEnt ( / ename result )
    (if (setq result (entlast))
	(while (setq ename (entnext result))
	  (setq result ename)
	  )
	)
    result
    )
  ;;===================================
  ;;  CAB - return a list of new enames
  (defun GetNewEntities (ename / new)
    (cond
      ((null ename) (alert "Ename nil"))
      ((eq 'ENAME (type ename))
       (while (setq ename (entnext ename))
         (if (entget ename) (setq new (cons ename new)))
	 )
       )
      ((alert "Ename wrong type."))
      )
    new
    )

  
  ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ;;         S T A R T  S U B R O U T I N E   H E R E              
  ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  (setq LastEntInDatabase (GetLastEnt))
  (if (and ss2brk ss2brkwith)
      (progn
	(setq oc 0
              ss2brkwithList (ssget->vla-list ss2brkwith))
	(if (> (* (sslength ss2brk)(length ss2brkwithList)) 5000)
            (setq *BrkVerbose* t)
	    )
	(and *BrkVerbose*
             (princ (strcat "Objects to be Checked: "
			    (itoa (* (sslength ss2brk)(length ss2brkwithList))) "\n")))
	;;  CREATE a list of entity & it's break points
	(foreach obj (ssget->vla-list ss2brk) ; check each object in ss2brk
		 (if (not (onlockedlayer (vlax-vla-object->ename obj)))
		     (progn
		       (setq lst nil)
		       ;; check for break pts with other objects in ss2brkwith
		       (foreach intobj  ss2brkwithList
				(if (and (or self (not (equal obj intobj)))
					 (setq intpts (get_interpts obj intobj))
					 )
				    (setq lst (append (list->3pair intpts) lst)) ; entity w/ break points
				    )
				(and *BrkVerbose* (princ (strcat "Objects Checked: " (itoa (setq oc (1+ oc))) "\r")))
				)
		       (if lst
			   (setq masterlist (cons (cons (vlax-vla-object->ename obj) lst) masterlist))
			   )
		       )
		     )
		 )

	
	(and *BrkVerbose* (princ "\nBreaking Objects.\n"))
	(setq *brkcnt* 0) ; break counter
	;;  masterlist = ((ent brkpts)(ent brkpts)...)
	(if masterlist
            (foreach obj2brk masterlist
		     (break_obj (car obj2brk) (cdr obj2brk) Gap)
		     )
	    )
	)
      )
  ;;==============================================================
  (and (zerop *brkcnt*) (princ "\nNone to be broken."))
  (setq *BrkVerbose* nil)
  (GetNewEntities LastEntInDatabase) ; return list of enames of new objects
  )
;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;      E N D   O F    M A I N   S U B R O U T I N E             
;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;           M A I N   S U B   F U N C T I O N S                 
;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;;======================
;;  Redraw ss with mode 
;;======================
(defun ssredraw (ss mode / i num)
  (setq i -1)
  (while (setq ename (ssname ss (setq i (1+ i))))
    (redraw (ssname ss i) mode)
    )
  )

;;===========================================================================
;;  get all objects touching entities in the sscross                         
;;  limited obj types to "LINE,ARC,SPLINE,LWPOLYLINE,POLYLINE,CIRCLE,ELLIPSE"
;;  returns a list of enames
;;===========================================================================
(defun gettouching (sscros / ss lst lstb lstc objl)
  (and
   (setq lstb (vl-remove-if 'listp (mapcar 'cadr (ssnamex sscros)))
         objl (mapcar 'vlax-ename->vla-object lstb)
	 )
   (setq
    ss (ssget "_A" (list (cons 0 "LINE,ARC,SPLINE,LWPOLYLINE,POLYLINE,CIRCLE,ELLIPSE")
                         (cons 410 (getvar "ctab"))))
    )
   (setq lst (vl-remove-if 'listp (mapcar 'cadr (ssnamex ss))))
   (setq lst (mapcar 'vlax-ename->vla-object lst))
   (mapcar
    '(lambda (x)
      (mapcar
       '(lambda (y)
         (if (not
              (vl-catch-all-error-p
               (vl-catch-all-apply
                '(lambda ()
                  (vlax-safearray->list
                   (vlax-variant-value
                    (vla-intersectwith y x acextendnone)
                    ))))))
             (setq lstc (cons (vlax-vla-object->ename x) lstc))
             )
         ) objl)
      ) lst)
   )
  lstc
  )



;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;          E N D   M A I N    F U N C T I O N S                 
;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



;;===============================================
;;   Break all objects selected with each other  
;;===============================================
(defun Break_All ( ss / cmd ss NewEnts AllEnts tmp)

  (command "_.undo" "_begin")
  (setq cmd (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (or Bgap (setq Bgap 0)) ; default

  (setq tmp 0.0000001 Bgap tmp)

  ;;  get objects to break

  (setq NewEnts (Break_with ss ss nil Bgap) ; ss2break ss2breakwith (flag nil = not to break with self)
					; AllEnts (append NewEnts (vl-remove-if 'listp (mapcar 'cadr (ssnamex ss)))
        )

  (setvar "CMDECHO" cmd)
  (command "_.undo" "_end")
  (princ)
  )

					;******************************************************************************************************************************************************************
					;******************************************************************************************************************************************************************

					;------------------------------------------------------------------------------------- 
;; BY LEE50310  ���� 109 / 11/ 08��
;;
;;�ڼ��еĵ�·�ϻ���ȡ����ֵ(·��ֵ)
;;���õ����� (tt v1 v2) �� v1��v2 ���㴮��
;;           (sort-x-min-li pcl))  ���㴮�� �� x����С�ŵ��� 
;; 
;;����ȡ·�� 
					;------------------------------------------------------------------------------------- 
(defun drl( / sst ssa ssb pc1 n i m1 m2 d1)
  
  (princ "\n<<<  �ڼ��еĵ�·�ϻ���ȡ��·��ֵ   >>>")
  
  ;;       (setvar "orthomode" 1)                                       ;�򿪴�ֱ����
  (setq px1 (getpoint "\n����ȡ��·��  ��һ��: "))				
  (setq px2 (getpoint px1 "\n����ȡ��·��  �ڶ���: "))
  (grdraw px1 px2 2 1)
  (redraw)
  
  ;;		(setvar "orthomode" 0)                                           ;�رմ�ֱ����  
  (setq sst (ssget "_f" (list px1 px2) ))                          ;����ȡ��
  
  (command "line" px1 px2 "")
  (setq ssb (ssadd ))
  (setq ssb (ssadd (entlast) ssb))                                  ;��ͼԪתѡ��

  (setq pcl (tt ssb sst))                                           ;�� ssb��ssa���㴮��



  (setq n(length pcl))
  (if (/= (rem n 2) 0)                                                    ;�ж� nֵ�Ƿ�Ϊż��
      (setq n(1- n))                                                  ;���·���߶���ż���ɶ� ��Ϊ������ֵ-1
      ) ;end_if
  
  (setq pcl (sort-x-min-li pcl))                                 ;�� x����С�ŵ���	
  (setq i 0 uel nil)
  (while (/= i n)
    
    (setq m1 (nth i pcl))
    (setq m2 (nth (1+ i) pcl))
    (setq d1 (read(rtos(distance m1 m2) 2 2 )))                    ;����ȡ��С�����һλ
    (setq uel (cons d1 uel))                                       ;����ֵ���� 
    (setq i (+ i 2))                                               ;ˮƽ����·Ϊ�� i=(0,1)Ϊ��· (1,2)Ϊ·��·��������� �� i+2 ,(2,3)Ϊ��·
    
    ) ;end_while
  
  (setq uel (Remove_Dup uel))                                    ;;ȥ���ظ��� 
  (setq uel (reverse uel))                                       				
  
  (command "erase" ssb "")
  
  ) ;end_defun

;;------------------------------------------------------------------
;;�г��ҵ���·��ֵ
(defun road-cross:prd()  
  (if (= (length uel) 0)                 
      (setq uel (cons ww uel))          ; ��uel����Ϊ��ֵ��Ŀǰ��·����·�����uel
      ) 
  (setq nn (length uel) ke "") 
  (foreach x uel
	   (setq ke (strcat ke (rtos x 2 2) "(m)  "))                
	   )
  
  (setq taw (strcat "\n�ҵ���" (rtos nn )  "��·,·��ֵ�ֱ�Ϊ = " ke))
  (princ  taw )
  (prin1)
  )
;;----------------------------------------------------------------------

					;******************************************************************************************************************************************************************
					;******************************************************************************************************************************************************************

					;------------------------------------------------------------------------------------- 
;; BY LEE50310  ���� 109 / 11/ 08��
;;����·�� ������һ��·�ж��м��Խʱ�Ƿ���ʮ��·�� ����һ���� �㴮�� vel �貹��·���������´�ֱ���˵� �Դ����� 
;;������� vel �㴮�� ����ʮ��·����ˮƽ��ʱҲ��������ֱ��
;;��Ѱ�������� �ж�Ϊ·�� ������ �����··���巶Χ  1.5m <= ·�� <= 20m ֮��
					;------------------------------------------------------------------------------------- 
(defun find_rd(vel)

  (if (> (length vel) 7)              ;��������һ����·[(����+ͷβ=6�㽻��)]�� ����ֵ����8 �����ϱ�ʾ�м��к�Խ��·����ʮ��·��   

      (progn
	
	(setq zeb (nth+ 4 vel 0))  ;��㴮�� vel ǰ4��Ϊͷβ�߽��� �ʴӵ�5���Ժ�ʼ��Ѱ ���ܲ���ʮ��·�ڵ���2��
        (setq zeb (sort-x-min-li zeb))  ;���е����� x����С�ŵ���		 
	

	(if (= gen nil)(progn (setq gen 1)(setq ww (getdist "\n ѡȡ·����������������е�·��: "))))

        (setq   mel nil yel nil  rel nil)
	
	
	(cond ((= gen 1)                                                                              ;gen=1 ·��ֵ����ԭ�����Ƶĵ�·��
               
               (setq rd_min (- ww (* ww z%))  rd_max (+ ww (* ww z%)))                 ; ������Χ 
	       (Vertical_point)                                                        ;�ҵ�����ʮ��·��������´�ֱ�� 
	       )
	      
	      ((= gen 2)                                                                             ;gen=2 ��ִ�й������Ҽ���·�� ·��ֵ����uel
	       (if (= (length uel) 0)                 
		   (setq uel (cons ww uel))                                                       ; ��uel����Ϊ��ֵ��Ŀǰ��·����·�����uel
		   )				
	       (foreach  x  uel                                                                ;��:�ҵ�����·�� uel=(10.2 15.6 20)
			 (setq rd_min (- x (* x z%))  rd_max (+ x (* x z%)))                     ;�ڽ��㴮�������������Ϊ·��ʱ����������ΧѰ��
					;��: ʵ��·�� 20  �� 19.6 >= ���������·��ֵ<= 20.4	�ķ�Χ��,�����϶��ǵ�·��					
			 (Vertical_point)                                                        ;���ҵ�������·�����ʮ��·�����ڽ��㴮���в����´�ֱ��
					;���㴮������·��ˮƽ���㼰��ֵ���� �Ϳ������ĵ�ȥ����ʮ��·��,���ֵ�������
			 )
	       
	       )
	      );end_cond
	(setq mel (Remove_Dup mel))                                ;;ȥ���ظ���         @@@@
	;; (setq mel (sort-x-min-li mel))                           ;�� x����С�ŵ���	   @@@@
	(setq vel (append vel mel))                                ;��ʮ��·�ڲ��ϴ�ֱ��
	vel	                                              ;��Ӧֵ	
	
	);end_progn
      
      
      );end_if
  
  )
					;-----------------------------------------------------------------------------
					;�ҵ�����ʮ��·�ڵĿ�Ⱦ���,�ھ�����е�������´�ֱ��
(defun Vertical_point ( / c1 c2 wt)
  (setq i 0)
  (while (/= i (- (length zeb) 1) )
    
    (setq c1 (nth i zeb))
    (setq c2 (nth (+ i 1) zeb ))				 
    (setq wt (distance c1 c2))
    
    (if (setq vv(and (>= wt rd_min )(<= wt rd_max )))           ; ��: 1.5m <= ·�� <= 20m
	(progn                                        ;�ҵ�������ʮ��·��
	  (prod_line c1 c2)
	  (setq wt (distance c1 c2))
	  (setq mel (cons pe1 mel))             ;���ϴ�ֱ�����
	  (setq mel (cons pe2 mel))             ;���´�ֱ�����
	  
	  );end_progn
	
        );end_if	
    (setq i (+ i 1))
    
    );end_while
  
  );end_progn
					;----------------------------------------------------------
					;��ˮƽ·����������е����´�ֱ��
(defun  prod_line(v1 v2 / w g pm wh )
  (setq pe1 nil pe2 nil)  
  (setq u (/ pi 180))                            ;���ֵ���ת�� 
  (setq w (*(distance v1 v2) 0.5))
  (setq g (angle v1 v2))
  (setq pm (polar v1 g w))                       ;ˮƽ�е�
  (setq wh (* ww 0.5))                           ;��ֱ��*0.5 	
  
  (setq pe1 (polar pm (+ g (* pi  0.5)) wh))     ;��ֱ��
  (setq pe2 (polar pm (+ g (* pi -0.5)) wh))     ;��ֱ��
  
  );end_defun

;;------------------------------------------------------------
;;  ��n�� ����
;;  CAB  10/15/2005
;; ���شӵ�n��λ�ÿ�ʼ�����б�Ȼ��
;; ��numָ������Ŀ��
;;ʹ�÷���:
;;  (nth+ 0 '(1 2 3 4 5) 2)  ;��Ӧ> (1 2)  ˵�� �Ӵ������� ��0λ��ʼȡ2λ 
;;  (nth+ 3 '(1 2 3 4 5) 2)  ;��Ӧ> (4 5)  ˵�� �Ӵ������� ��3λ��ʼȡ2λ 
;;  (nth+ 4 '(1 2 3 4 5) 5)  ;��Ӧ> (5)    
;;  (nth+ 6 '(1 2 3 4 5) 2)) ;��Ӧ> nil    
;;  (nth+ 2 '(1 2 3 4 5) 0)) ;��Ӧ> (3 4 5) ˵�� �Ӵ������� ��2λ��ʼȡ����� 
;;�� vel = ((5646.96 539.269 0.0) (5646.64 542.96 0.0) (5570.21 536.454 0.0) (5570.52 532.763 0.0) (5639.97 540.533 0.0) (5572.3 534.773 0.0))
;;Ҫȡ��vel�㴮�е�4�������
;; ִ��: (NTH+ 4 vel 0)      ;��Ӧ> ((5639.97 540.533 0.0) (5572.3 534.773 0.0))
;;------------------------------------------------------------

(defun nth+ (idx               ; start position 0 = first item
             lst               ; list of items
             num               ; number of items to return
					;    0= all remaining items
             / newlst)
  (and (or (numberp num)       ; catch non numbers
           (setq num 0))       ; force all
       (zerop num)             ; if zero
       (setq num (length lst)) ; all
       )
  (repeat num
	  (setq newlst (cons (nth idx lst) newlst)
		idx (1+ idx))
	  )
  (reverse (vl-remove nil newlst))
  )

;;----------------------------------------------------------
;;�ײ�����
					;��: �㴮�� zeb = ((1703.87 1298.93 0.0) (1879.27 1296.67 0.0) (1683.09 1299.2 0.0) (1558.82 1300.81 0.0))
					; 1. X��->��  ��С����
					;    (sort-x-min-li zeb)
					;            ��Ӧ:((1558.82 1300.81 0.0) (1683.09 1299.2 0.0) (1703.87 1298.93 0.0) (1879.27 1296.67 0.0))

(defun sort-x-min-li (lst)
  (vl-sort lst '(lambda (x y) (< (car x)(car y) ) ))
  ) ;x��С����


(defun sort-x-max-li (lst)
  (vl-sort lst '(lambda (x y) (> (car x)(car y) ) ))
  ) ;x�ɴ�С


(defun sort-y-min-li (lst)
  (vl-sort lst '(lambda (x y) (< (cadr x)(cadr y) ) ))
  ) ;Y��С����


(defun sort-y-max-li (lst)
  (vl-sort lst '(lambda (x y) (> (cadr x)(cadr y) ) ))
  ) ;Y�ɴ�С


;;******************************************************************************************************************************************************************
					;******************************************************************************************************************************************************************

;;----------------------------------------------------------------------------------
;;
;;ȡ����+ȥ���ظ��� 
;;
;;-----------------------------------------------------------------------------------


(defun Take_inters ( ss / ipt  n n1 n2 obj1 obj2)
  (setq lst nil)

  (setq n  (sslength ss)
        n1 0
	)
  (while (< n1 (1- n))
    (setq obj1 (vlax-ename->vla-object (ssname ss n1))
          n2   (1+ n1)
	  )
    (while (< n2 n)
      (setq obj2 (vlax-ename->vla-object (ssname ss n2))
            ipt  (vlax-variant-value (vla-intersectwith obj1 obj2 0))
	    )
      (if (> (vlax-safearray-get-u-bound ipt 1) 0)
          (progn
            (setq ipt (vlax-safearray->list ipt))
            (while (> (length ipt) 0)
              (setq lst (cons (list (car ipt) (cadr ipt) (caddr ipt)) lst) ipt (cdddr ipt))
              )
            )
	  )
      (setq n2 (1+ n2))
      )
    (setq n1 (1+ n1))
    )
  
  (setq lst (Remove_Dup lst))      ;;ȥ���ظ��� 
  lst                              ;;��Ӧֵ
  )
;;------------------------------------------------------------
;; ɾ�����ظ�Ԫ�� 
;;ʹ�÷�ʽ: (_RemoveDuplicates  lst)
;;

(defun Remove_Dup ( lst / foo index )
  (defun foo (x)
    (cond
      ((vl-position x index))
      ((null (setq index (cons x index))))
      )
    )
  (vl-remove-if
   'foo
   lst
   )
  )

;;******************************************************************************************************************************************************************
					;******************************************************************************************************************************************************************


