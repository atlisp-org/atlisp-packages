;;���ʴʿ�ck
					;��һ������������Լ���Ҫ�޸��������ݣ�
(setq ckml (strcat @:*prefix*  "packages/at-text/" )) ;������Ϊ�ʿ�Ŀ¼ ע��·��Ϊ��б�ܡ�/��
(setq texth 300) ;300Ϊ���ָ߶�
(setq textst "-����") ;����
(setq textlay "WIRE-����") ;WIRE-���� Ϊ����ͼ��
(setq textwh 0.7);0.7Ϊ���ֿ�߱�
(setq textsty "0");Ĭ�ϲ����������� 0Ϊ�������� 1Ϊ��������


;;���²����޸�
(setq suoyin "0")
(setq suoyin2 "0")
(defun c:ck ()
  (setvar "cmdecho" 0)
  (defun xsckdhk();��ʾ�ʿ�Ի���
					;(setq tzbl (getvar "HPSCALE" ));��������
    (setq en nill)
    (setq mulu (list "" ))
    (setq mulu (vl-directory-files ckml "*.txt" ))
    (setq ml mulu)
    (setq mulu (list mulu))
    (setq fname (vl-filename-mktemp nil nil ".dcl" ))
    (setq filen (open fname "w" ))
    (foreach x '(
                 "  dcl_settinsx : default_dcl_settings { audit_level = 3; }" 
                 "  ck : dialog{" 
                 "   label=\"@�ƴʿ� V2.0\";" 
                 " :row {" 
                 "  :column {" 
                 "   :list_box {" 
                 "    key = \"2\" ;" 
                 "    label = \"����Ŀ¼:\" ;" 
                 "				width = 20 ;" 
                 "   }" 
                 "  }" 
                 "  :column {" 
                 "   :list_box {" 
                 "    height = 25 ;" 
                 "    key = \"1\" ;" 
                 "    label = \"��������:\" ;" 
                 "    width = 45 ;" 
                 "   }" 
                 "  }" 
                 " }" 
                 "  :row {"
                 "  :edit_box"
                 "  {"
                 "    label=\"��ӵ��ʿ�\";"
                 "    key=\"bjk\";"
                 "    width = 45 ;"
                 "    height = 1 ;"
                 "    allow_accept=true;"
                 "  }"
                 "  :button{key=\"sq\";label=\"ʰȡ\";}"
                 "  :button{key=\"tj\";label=\"���\";}"
                 "  }" 
                 "	 spacer;"
		 " :row {"
		 " :toggle {"
		 "    label = \"��������\" ;" 
		 "    key = \"3\" ;"
		 "}"
		 "  :button{key=\"gz\";label=\"��ͼ����\";}"
		 "  :button{key=\"op\";label=\"���ļ�\";}"
                 "   cancel_button;" 
		 "  }" 
                 "  }" 
		 );end ;endlist
             (princ x filen)
             (write-line "" filen)
	     );end foreach
    (close filen)
    (setq filen (open fname "r" ))
    (setq dclid (load_dialog fname))
    (while (or (eq (substr (setq lin (vl-string-right-trim "\" filen)" (vl-string-left-trim "(write-line \"" (read-line filen)))) 1 2) "//" ) (eq (substr lin 1 (vl-string-search " " lin)) "" ) (not (eq (substr lin (+ (vl-string-search " " lin) 1) 9) " : dialog" ))))
    (new_dialog (substr lin 1 (vl-string-search " " lin)) dclid)
    (start_list "1" )
    (if (= lst nil);��һ�ζ�ȡ ��һ��txt�ļ�����
        (progn
          (setq text_2 (nth 0 ml))
          (setq file (open (strcat ckml text_2) "r" ))
          (setq txt_t (read-line file) lst (list "" ))
          (while (/= txt_t nil)
            (setq lst (append lst (list txt_t)))
            (setq txt_t (read-line file))
            );end while
          (close file)
          (setq lsti lst)
          (setq lst (list (cdr lst)))
       	  ));end if
    (mapcar 'add_list (car lst))
    (end_list)
    (load_text suoyin 1)
    (start_list "2" )
    (mapcar 'add_list (car mulu))
    (end_list)
    (set_tile "3" textsty)
    (if bjk-txt
	(set_tile "bjk" bjk-txt)
	)
    (action_tile "1" "(new_text $value $reason)" )
    (action_tile "2" "(load_text $value $reason)	(setq suoyin2 (itoa 0))")
    (action_tile "3" "(setq textsty $value)") 
    (action_tile "sq" "(done_dialog 1)")
    (action_tile "op" "(done_dialog 2)")
    (action_tile "gz" "(done_dialog 3)")
    (action_tile "bjk" "(setq bjk-txt $value)")
    (action_tile "tj" "(tjwz)")
    (set_tile "2" suoyin);��ȡ����
    (set_tile "1" suoyin2)
    (action_tile "cancel" "(done_dialog 0)" )
    (setq re (start_dialog))
    (cond
      ((= re 1) (shiqu))
      ((= re 2) (dkwj))
      ((= re 3) (gtzwz))
      )
    (start_dialog)
    (unload_dialog dclid)
    (close filen)
    (vl-file-delete fname)
    (if (/= en nill) ;��̬����
        (progn
	  (princ "\n��ȡλ�û�[ת90��(A)/�Ҽ��˳�]")
	  (setq boolean t)
	  (setq text-jiaodu 0)
	  (while boolean
	    (setq motion (grread T 8));grread ��������һ�������е�һ��Ԫ��˵���������͵Ĵ��룬�ڶ���Ԫ�ؼȿ������������ֿ����ǵ�
	    (setq code (car motion)) ;grread���һ��Ԫ���������͵Ĵ���
	    (setq pt2 (cadr motion)) ;grread��ڶ���Ԫ�� �϶�ģʽ����
	    (cond
	      ((= code 5)   ;����϶�ģʽ
	       (entmod (setq endate (subst (cons 10 pt2) (assoc 10 endate) endate)));��̬����������
	       )
	      ((= code 3)   ;������I����
	       (setq boolean nil)
	       )
	      ((= code 11)
	       (setq boolean nil)
	       (entdel en)
	       )
	      ((= code 25)
	       (setq boolean nil)
	       (entdel en)
	       )
	      ((equal motion '(2 32))
	       (setq boolean nil)
	       )
	      ((equal motion '(2 13))
	       (setq boolean nil)
	       )
	      ((equal motion '(2 27))
	       (setq boolean nil)
	       (entdel en)
	       )
	      ((equal motion '(2 65))
	       (setq text-jiaodu (+ text-jiaodu (/ pi 2)))
	       (entmod (setq endate (subst (cons 50 text-jiaodu) (assoc 50 endate) endate)));��̬�����ֽǶ�
	       )
	      ((equal motion '(2 97))
	       (setq text-jiaodu (+ text-jiaodu (/ pi 2)))
	       (entmod (setq endate (subst (cons 50 text-jiaodu) (assoc 50 endate) endate)));��̬�����ֽǶ�
	       )
	      )
            );end while
	  ));end if
    (princ)
    ) ;end xsckdhk

  (defun load_text (value reason);�Ӻ��� ��ȡtxt����
    (if (= reason 1)
        (progn
          (setq suoyin value)
          (setq text_2 (nth (atoi value) ml))
          (setq file (open (strcat ckml text_2) "r" ))
          (setq txt_t (read-line file) lst (list "" ))
          (while (/= txt_t nil)
            (setq lst (append lst (list txt_t)))
            (setq txt_t (read-line file))
            );end while
          (close file)
          (setq lsti lst)
          (setq lst (list (cdr lst)))
	  ));end if
    (start_list "1" )
    (mapcar 'add_list (car lst))
    (end_list)
    (setq wjm (nth (atoi value) ml))
    (setq filename (strcat ckml wjm))
    );end load_text

  (defun new_text (value reason / ttlen twid)
    (setq text (nth (1+ (atoi value)) lsti))
    (if (= reason 4)
        (progn
          (done_dialog 0);�رնԻ���
          (setq pt (cadr (grread 1)));ȡ�ù������
          (if pt
	      (if (= textsty "0")
                  (progn
                    (entmake (list
                              '(0 . "TEXT" );��������
                              (cons 1 text)
                              (cons 7 textst)
                              (cons 8 textlay)
                              (cons 10 pt)
					;(cons 40 (/ (* tzbl texth) 100))
			      (cons 40 texth)	 
                              (cons 41 textwh)																									 
                              );end list
                             );end entmake
                    (setq en (entlast))
                    (setq endate (entget (entlast)))
		    )
                  (progn
		    (setq ttlen (strlen text))   ;ȡ���ı�����
                    (setq twid (* (* (* texth 0.7) ttlen) (/ tzbl 100)))  ;�����ı����
                    (entmake (list
                              '(0 . "MTEXT" );��������
                              (cons 100 "AcDbEntity")	
                              (cons 100 "AcDbMText")	
                              (cons 1 text)
                              (cons 7 textst)
                              (cons 8 textlay)
                              (cons 10 pt)
					;(cons 40 (/ (* tzbl texth) 100))
			      (cons 40 texth)
                              (cons 41 twid)																								 
                              );end list
                             );end entmake
                    (setq en (entlast))
                    (setq endate (entget (entlast)))
                    )
                  )												
              );end if
          );end progn
	);end if
    (if (= reason 1)
	(setq suoyin2 value)
	)
    );end new_text

					;ʰȡ����
  (defun shiqu (/ ent1)
    (if (setq ent1 (entsel ))
	(progn
	  (setq bjk-txt (cdr (assoc 1 (entget (car ent1)))));��������
	  (xsckdhk)
	  ))
    );end shiqu

					;���ļ�
  (defun dkwj()
    (startapp "notepad" filename)
    ) 
  
					;��ͼ������
  (defun gtzwz (/ sel i ent ob)
    (if (setq sel (ssget '((0 . "TEXT,MTEXT"))))
	(progn
	  (setq i 0)
	  (repeat (sslength sel)
		  (setq ent (ssname sel i))
		  (setq ob (vlax-ename->vla-object ent)) ;ת��
		  (vlax-put-property ob 'TextString text) ;�ı�text����
		  (setq i (1+ i))
		  )
	  ))
    (princ) 
    )
  
					;������ֵ��ʿ�
  (defun tjwz(/ file)
    (if (/= bjk-txt "")
	(progn
	  (setq file (open filename "a"))
	  (write-line bjk-txt file)
	  (close file)
	  (load_text suoyin 1) ;ˢ����������
	  ))
    ) 

  (xsckdhk)
  (setvar "cmdecho" 1)
  (princ)
  );end defun
