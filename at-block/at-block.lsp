;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-arch:first ���� Ӧ�ð� at-arch �� ��һ�������� first 
(@:define-config '@block:block-name "����" "�����źŵĿ����ơ�")
(@:define-config '@block:attribute-name "������" "�����źŵĿ������Ե����ơ�")
(@:define-config '@block:attribute-prefix "" "�����źŵĿ�������ֵǰ׺��")
(@:define-config '@block:attribute-suffix "" "�����źŵĿ�������ֵ��׺��")
(@:define-config '@block:xref-layer "xref-lock" "���ڷ����ⲿ���յ�ͼ������")
(@:define-config '@block:sort-order "xY" "�������xyXY�����������,����yX,y��ǰ��ʾy�������ȣ���X��ʾ���ҵ�������")
(@:define-config '@block:sort-fuzz "10,10" "��λ������ʱ��������ݲ�������ڷָ���ͬ����ݲ")
;; (@:get-config 'at-arch:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-arch:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵�
(@:add-menu "�����" "��-����" "(@block:config)")
(@:add-menu "�����" "���滻" "(@block:subst)")
(@:add-menu "�����" "���Զ����" "(@block:set-number)")
(@:add-menu "�����" "�������" "(@block:set-any-block-number)")
(@:add-menu "�����" "��������" "(@block:setup)")
(@:add-menu "�����" "��Ϊ�ɷֽ�" "(@block:explodable)")
(@:add-menu "�����" "�費�ֽܷ�" "(@block:explode-disable)")
(@:add-menu "�����" "�Ŀ����" '(@block:menu-change-base))
(@:add-menu "�����" "�����п�" "(@block:insert-all)")
;; (@:add-menu "�����" "�������" "(@block:menu-inserts)")
(@:get-config 'sym)
(defun @block:config (/ res)
  "�����������Ϣ"
  (setq res 
	(ui:input "������Ϣ"
		  (mapcar '(lambda (x) (list (strcase (vl-symbol-name (car x)) T)(cadr x)(cddr x)))
			  (vl-remove-if '(lambda (x) (not (wcmatch (vl-symbol-name (car x)) "`@BLOCK:*")))
					(if @:*config.db*
					    @:*config.db* (@:load-config))))))
  (foreach res% res
   	   (@:set-config (read (car res%)) (cdr res%)))
  )
(defun @block:setup (/ block-name attribute-name en0 lst-att i% opt% initget% )
  "����Ҫ���б�ŵ�ͼ�飬ѡ��һ��ͼ�飬����Ҫ�����ͼ��."
  (setq en0 (car (entsel "���ѡһ�����Կ�:")))
  (if (and (= "INSERT" (entity:getdxf en0 0))
	   (block:get-effectivename en0) ;; ����
	   (= 1 (entity:getdxf en0 66))) ;; ���Կ�
            (progn
	      ;; ����Ƿ���������ԡ�
	      (setq lst-att (block:get-attributes en0))
	      (cond
		((= 1 (length lst-att))
		 (@:set-config '@block:block-name (block:get-effectivename en0))
		 (@:set-config '@block:attribute-name (car (car lst-att))))
		((< 1 (length lst-att))
		 (@:set-config '@block:block-name (block:get-effectivename en0))
		 (if (and (setq attribute-name
				(ui:select "��ѡ��Ҫ���б�ŵ�����:" (mapcar 'car lst-att)))
			  (assoc attribute-name lst-att))
		     (@:set-config '@block:attribute-name attribute-name)
		     (alert "����������������ǵ�ǰѡ�еĿ�����ԡ�")))
		)
	      (alert (strcat "��ǰҪ���б�ŵ����Կ�Ϊ \n  " (@:get-config '@block:block-name) " \n"
			     "��ǰҪ���б�ŵ�������Ϊ \n  " (@:get-config '@block:attribute-name) 
			     ))
	      (princ)
	      )
	    (progn ;; ����ͼ�����
	      (alert "��ѡ��ͼԪ���ǿ飬����Ϊ������������Կ飬�����㱾����Ҫ��")
	      (setq blk-name  (getstring (strcat "������Ҫ���б�ŵ�ͼ���� <" (@:get-config '@block:block-name) ">: ")))
	      (if (/= "" blk-name)
		  (progn
		    (@:set-config '@block:block-name blk-name)
      		    (alert (strcat "��ǰ���̹����ͼ���������Ϊ \n"  (@:get-config '@pm:tukuang) " ��"
				   "\n ��Ϊ���ֶ�����ģ��п��ܲ��������Ҫ��"))
		    (if (/= "" (setq attribute-name (getstring (strcat "������Ҫ���б�ŵ�ͼ��������� < " (@:get-config '@block:attribute-name) " >: "))))
			(@:set-config '@block:attribute-name attribute-name))
	      (princ))))
  
	    ))

(defun @block:set-number (/ num1 start ss-list ss1 fuzz)
  
  (if (= "" (@:get-config '@block:block-name))
      (@block:setup))
  (if (progn
	(setq ss1 (ssget (list '(0 . "insert")'(66 . 1)
			       '(-4 . "<or")
			       (cons 2 (@:get-config '@block:block-name))
			       (cons 2 "`**")
			       '(-4 . "or>"))
			 ))
	(setq ss-list
	      (vl-remove-if-not
	       '(lambda(x)
		  (= (block:get-effectivename x)
		     (@:get-config '@block:block-name)))
	       (pickset:to-list ss1))))
      (progn
	;; ����
	(sssetfirst nil (pickset:from-list ss-list))
	(setq fuzz (mapcar 'atof (string:to-list (@:get-config '@block:sort-fuzz)",")))
	(setq ss-list (pickset:sort ss-list (@:get-config '@block:sort-order) fuzz))
	(setq start (getint "���������ʼ���<1>:"))
	(if (null start) (setq start 1))
	(setq num1 0)
	(foreach en0 ss-list
		 (block:set-attributes
		  en0
		  (list (cons (@:get-config '@block:attribute-name)
			      (strcat
			       (@:get-config '@block:attribute-prefix)
			       (if (< (+ num1 start) 10) "0" "")
			       (itoa (+ num1 start))
			       (@:get-config '@block:attribute-suffix)
			       ))))
		 (setq num1 (1+ num1))
		 ))
      (progn
	(alert "δѡ�����õ�ͼ�顣������Ҫ���в�����ͼ�顣")
	(@block:setup))))

(defun @block:set-any-block-number (/ num1 start ss-list ss1 )
  (@:help "������ţ����и������Ե�������š�")
  (if (= "" (@:get-config '@block:block-name))
      (@block:setup))
  (if (setq ss1 (ssget ;; "_C" pt1 (getcorner pt1 "\nѡ�����:")
		 (list (cons 0 "insert"))))
      (progn
	(setq ss-list (pickset:to-entlist ss1))
	(setq ss-list
	      (vl-sort ss-list
		       '(lambda (en1 en2)
			 (if (> (caddr (assoc 10 (entget en1)))
				(+ (@:scale 10) (caddr (assoc 10 (entget en2)))))
			     T
			     (if (and (equal (caddr (assoc 10 (entget en1)))
					     (caddr (assoc 10 (entget en2)))
					     (@:scale 10))
				      (< (cadr (assoc 10 (entget en1)))
					 (cadr (assoc 10 (entget en2)))))
				 T
				 nil)
			     ))))
	(setq start (getint "���������ʼ���<1>:"))
	(if (null start) (setq start 1))
	(setq num1 0)
	(foreach en0 ss-list
		 (if (member (@:get-config '@block:attribute-name)
			     (mapcar 'car (block:get-attributes en0)))
		     (progn
		       (block:set-attributes
			en0
			(list (cons (@:get-config '@block:attribute-name)
				    (strcat
				     (@:get-config '@block:attribute-prefix)
				     (if (< (+ num1 start) 10) "0" "")
				     (itoa (+ num1 start))
				     (@:get-config '@block:attribute-suffix)
				     ))))
		       (setq num1 (1+ num1))))
		 ))
      (progn
	(alert "δѡ�����õ�ͼ�顣������Ҫ���в�����ͼ�顣")
	(@block:setup))))

(defun @block:subst ()
  (@:help (strcat "��Ŀ����滻��Դ��. \n"
		  "����: \n"
		  "      1. ��ѡԴ�飻\n"
		  "      2. ��ѡĿ��顣"))
  
  (setq blk-src (car (entsel "��ѡ��Դ��: ")))
  (princ "\n")
  (prompt "��ѡ��Ŀ���:")
  ;; ѡ��鲢��ѡ��ת��Ϊ��ͼԪ�б�
  (setq blks-target (pickset:to-list (ssget '((0 . "insert"))))) 
  ;; ȡԴ���dxf ���� 2 ��ֵ��������ֵ ����Ŀ�������� 2 ��ֵ.
  (mapcar '(lambda (x) (entity:putdxf x 2
			(entity:getdxf blk-src 2)))
	  blks-target))
		  
(defun @block:explodable (/ blk )
  (@:help (strcat "��Ŀ�������Ϊ�ɷֽ�. \n"
		  "����: \n"
		  "      1. ��ѡ����Ϊ�ɷֽ�Ŀ飻\n"))
  
  (setq blk (car (entsel "��ѡ���: ")))
  (if (= "INSERT" (entity:getdxf blk 0))
      (vla-put-explodable
       (vla-item *BLKS* (block:get-effectivename blk))
       :vlax-true)
  ))
		  
(defun @block:explode-disable (/ blk )
  (@:help (strcat "��Ŀ�������Ϊ���ɷֽ�. \n"
		  "����: \n"
		  "      1. ��ѡ����Ϊ���ɷֽ�Ŀ飻\n"))
  
  (setq blk (car (entsel "��ѡ���: ")))
  (if (= "INSERT" (entity:getdxf blk 0))
      (vla-put-explodable
       (vla-item *BLKS* (block:get-effectivename blk))
       :vlax-false)
      ))
(defun @block:get-corner (blk)
  (entity:getbox blk 0)
  )
(@:add-menu "�����" "����ͼ�л�" "(@block:outline-dialog)")
(defun @block:outline-dialog (/ dcl_fp dcl-tmp dcl_id pkg para% menu%
			   frames curr-page per-page after-panel-cmd
			   zoom-w
			   run-function after-panel corner
			   page-up page-down *error*)
  "���Կ��٣����ڿ����л�����ͼ"
  (@:help "���Կ��٣����ڿ����л�����ͼ\n ")
  (defun *error* (msg)
    ;; ���������� 
    (if (= 'file (type dcl_fp))
	(close (dcl_fp)))
    (princ (strcat msg ))
    (princ))
  (setq frames (pickset:to-list (ssget "x" (list '(0 . "insert")
						 (cons 2 (@:get-config '@block:block-name))))))
  (setq frames (vl-sort
		frames
		'(lambda (x y)
		  (< 
		   (cdr (assoc (@:get-config '@block:attribute-name) (block:get-attributes x)))
		   (cdr (assoc (@:get-config '@block:attribute-name) (block:get-attributes y)))))))
  (setq per-page (@:get-config '@:outline-per-page))
  (if (<= (length frames) per-page)
      (setq curr-page 0)
      (setq curr-page (@:get-config '@:outline-curr-page)))
  (defun zoom-w (corner)
    (command "zoom" "w" (car corner) (cadr corner)))
  (defun after-panel ( func )
    (if (= 'str (type func))
	(eval (read func))))
  (defun page-up ()
    (setq curr-page (1- curr-page))
    (@:set-config '@:outline-curr-page curr-page)
    (done_dialog 10)
    (setq after-panel-cmd "(@block:outline-dialog)"))
  (defun page-down ()
    (setq curr-page (1+ curr-page))
    (@:set-config '@:outline-curr-page curr-page)
    (done_dialog 10)
    (setq after-panel-cmd "(@block:outline-dialog)"))
  (defun run-function (corner)
    ;; (princ func)
    (done_dialog 10)
    (setq after-panel-cmd corner))
  (if frames
      (progn
	;; ���� dcl �ļ�
	(setq dcl-tmp (strcat @:*tmp-path* "tmp-outline-panel.dcl" ))
	(setq dcl_fp (open dcl-tmp "w"))
	(write-line (strcat "panel : dialog {"
			    "label = \"���Կ��л�\"; ")
		    dcl_fp)
	(setq i% 0)(setq bt-width 38)
	(write-line ":image{ height=0.1; color=250; fixed_height=true;}:row{label=\"\";" dcl_fp)
	(setq c% 0)(setq j% 0)
	;;(setq bt-menu-column (nth (+ c% (* per-page curr-page)) menus-list))
	;; һ������
	(foreach blk%  frames
		 (if (= 0 (rem j% per-page))
		     (progn
		       (setq flag-col T)
			 (write-line (strcat ":column{label=\"\";children_alignment=top;fixed_width=true;children_fixed_width=true;width="
					     (itoa bt-width) ";" )
				     dcl_fp)))
		   (setq r% 0)
		   (progn
		     (write-line (strcat ":button{ fixed_width=true;children_fixed_width=true;children_alignment=left;width="
					 (itoa bt-width)
					 ";fixed_height=true;"
					 " key=\"c""_"(itoa (setq j% (1+ j%)))"\"; "
					 "label=\""
					 ;; ��ʾ�������ı�
					 (cdr (assoc (@:get-config '@block:attribute-name) (block:get-attributes blk%)))
					 "\"; "
					 " action=\"(run-function \\\"(zoom-w '"
					 (@:string-subst "\\\\\\\"" "\"" (vl-prin1-to-string (@block:get-corner blk%)))
					 ")\\\")\";is_enabled=true;}")
				 dcl_fp)
		     (setq r% (1+ r%)))
		   ;;(write-line "}" dcl_fp)
		   (setq c% (1+ c%))(setq i% (1+ i%))
		   (if (or (and flag-col  (= 0 (rem j% per-page)))
			   (= j% (length frames)))
		       (progn 
			 (write-line "}" dcl_fp)
			 (setq flag-col nil)))
		   )
	(write-line "}" dcl_fp)
	(write-line ":image{ height=0.1; color=250; fixed_height=true;}" dcl_fp)
	;;��ҳ
	;; (if (> (length frames) per-page)
	;;      (write-line ":row{alignment=centered;children_alignment=centered;:button{label=\"<\";key=\"prev\";is_enabled=false;}:spacer{} :text_part{key=\"curr_total\"; value=\"\";alignment=\"centered\";width=10;}:button{label=\">\";key=\"next\";is_enabled=false;}}"
	;;  		dcl_fp))
	(write-line " :spacer {} ok_cancel; }" dcl_fp)
	(close dcl_fp)
	
	(setq dcl_id (load_dialog dcl-tmp))
	(if (not (new_dialog "panel" dcl_id))
	    (exit))
	
	(action_tile "accept" "(done_dialog 1)")
	(action_tile "prev" "(page-up)")
	(action_tile "next" "(page-down)")
	(if (= 0 curr-page) (mode_tile "prev" 1) (mode_tile "prev" 0))
	(if (= (/ (1- (length frames)) per-page) curr-page) (mode_tile "next" 1) (mode_tile "next" 0))
	(start_dialog)
	(unload_dialog dcl_id)
	(vl-file-delete dcl-tmp)
	(after-panel after-panel-cmd))
      ))
(@:add-menu "�����" "����ѡ" "(@block:select-same)")
(defun @block:select-same (/ blk blks)
  (@:help (strcat "ѡ��һ���飬Ȼ��ѡ�����е�ͬ���顣"))
  (setq blk (car (entsel "��ѡ��һ����:")))
  (setq blks (pickset:to-list (ssget "x" '((0 . "INSERT")))))
  
  (setq blks (vl-remove-if '(lambda (x) (/= (block:get-effectivename blk)
					 (block:get-effectivename x)))
			   blks))
  (sssetfirst nil (pickset:from-entlist blks))
  (princ))
(defun @block:rename-noname (/ name newname i)
  (setq name "atlisp.cn")
  (setq i 0)
  (while (tblsearch "block" (strcat name (itoa (setq i (1+ i))))))
  
  (setq newname (strcat name (itoa i)))
  
  (vlax-for blk *BLKS*
	    (if (= "" (vla-get-name blk))
		(vla-put-name blk newname)))
  )


(defun @block:menu-change-base(/ blkref blkname pt ) 
  (setq blkref (car (entsel "��ѡ��Ҫ�ı����Ŀ�:")))
  (setq blkname (entity:getdxf blkref 2))

  (setq pt (getpoint (entity:getdxf blkref 10) "��ѡ��Ŀ�����:"))
  ;;TODO ���� 210 220 230
  ;; (if (< (apply 'min (mapcar 'last (entity:getdxf blkref '(210 220 230)))) 0)
  ;;     (alert "ͼ�����췽�����󣬲�����ȷ���û��㡣"))
  (setq pt (mapcar '(lambda (x y z)
		      (/ (- x y) z))
		   pt (entity:getdxf blkref 10)
		   (entity:getdxf blkref '(41 42 43))
		   ))
  (princ "aaa")
  (print blkname)
  (print pt)
  (@block:change-base blkname pt))
  
(defun @block:change-base (blkname pt-nb / blkobj)
  (vlax-for blk *BLKS*
	    (if (= (vla-get-name blk) blkname)
		(setq blkobj blk)))
  (vla-put-origin
   blkobj
   (vlax-3d-point
    (mapcar
     '+
     pt-nb
     (vlax-safearray->list
      (vlax-variant-value (vla-get-origin blkobj)))
     )))
  (command "regen")
  )
(defun @block:menu-inserts ( )
  "�������"
  ;; ѡ�������
  
  )
