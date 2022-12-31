;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-documents:first ���� Ӧ�ð� at-documents �� ��һ�������� first 
;;(@:define-config 'at-documents:first "���������� at-documents:first ��ֵ" "������������;˵����")
;; (@:get-config 'at-documents:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-documents:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-devmenu  (_"Support") "@ͨ�ú�����" "(at-documents:lib-manager-dialog)" )
(if (findfile "packages/base/base-whole-dev.lsp")
    (load "packages/base/base-whole-dev.lsp")
  (@:down-pkg-file (@:uri) "base/base-whole-dev.lsp" "stable")
  )
(defun at-documents:load-libdoc (/ files fp opt%)
  (setq @:*libdoc* '())
  (setq @:*libdoc-category* '())
  (if (setq files (vl-directory-files (strcat @:*prefix* "packages\\at-documents\\") "*.libdoc" 1))
      (foreach file% files
	       (setq fp (open (strcat @:*prefix* "packages\\at-documents\\" file%) "r"))
	       (while (setq opt% (read-line fp))
		 (if (/= opt% "")
		     (setq @:*libdoc* (append @:*libdoc* (list (read opt%))))))
	       (setq @:*libdoc-category* (append @:*libdoc-category* (list (vl-filename-base file%))))
	       (close fp)))
  (setq @:*libdoc* (vl-sort (vl-remove nil @:*libdoc*) '(lambda (e1 e2) (< (car e1)(car e2)))))
  (setq @:*libdoc-category* (vl-remove nil @:*libdoc-category*))
  )

(defun at-documents:lib-manager-dialog (/ dcl-tmp dcl_fp dcl_id pkg para% libdocs-list curr-page 
				 page-up page-down
				 @:package-callback-accept @:package-callback-libdoc-name
				 list-libdoc-by-category list-libdoc-by-author list-libdoc-by-search
				 toggle-change show-detail show-src init-dialog indent)
  (defun indent (str / curr-ind% res)
    (setq curr-ind% 0)
    (setq res '())
    (foreach char% (vl-string->list str)
	     (cond
	      ((= 40 char%)
		 (setq curr-ind% (1+ curr-ind%)))
	      ((= 41 char%)
	       (setq curr-ind% (1- curr-ind%))))
	     (setq res (cons char% res))
	     (if (= 10 char%)
		 (repeat (* 4 curr-ind%)
			 (setq res (cons 32 res)))))
	       
    (vl-list->string (reverse res))
    )
				 
  (defun page-up ()
    (setq curr-page (1- curr-page))
    (show-libdocs-list))
  (defun page-down ()
    (setq curr-page (1+ curr-page))
    (show-libdocs-list))
  (defun show-detail (number / func-info)
    (setq func-info (nth (+ (* 20 curr-page) (1- number)) libdocs-list))
    (alert (strcat "������:  " (@:to-string(car func-info))
		   "\n����˵��: " (@:to-string(cadr func-info))
		   "\n�÷�:\n  "(@:to-string (caddr func-info))
		   "\n����:\n"(@:to-string(nth 3 func-info))
		   "\n����ֵ:\n   "(@:to-string(nth 4 func-info))
		   "\nʾ��:\n  "(@:to-string (nth 5 func-info))
		   ))
    )
  (defun show-src (number / func-info)
    (setq func-info (nth (+ (* 20 curr-page) (1- number)) libdocs-list))
    (alert (fun:src-code (car func-info)))
    ;; (alert (strcat "������:  " (@:to-string(car func-info))
		;;    "\n----\n"
		;;    (indent
		;;     (strcase
		;;      (@:string-subst
		;;       "\"\n" "\" "
		;;       (@:string-subst
		;;        ")\n" ") "
		;;        (vl-prin1-to-string
		;; 	(cons 'defun
		;; 	     (cons (read(car func-info))
		;; 		   (defun-q-list-ref (read(car func-info))))))))
		;;      T)
		;;     )))
    )
  (defun list-libdoc-by-category ( / i%)
    ;; (set_tile "author" "0")		
    (if (= 0 (atoi (get_tile "category")))
	(setq libdocs-list @:*libdoc*)
	(setq libdocs-list (vl-remove nil (mapcar '(lambda (x) (if (eq
								    (nth (1- (atoi (get_tile "category"))) @:*libdoc-category*)
								    (car (string:to-lst (strcase (car x)  T) ":")))
								   x nil))
						  @:*libdoc*))))
    (setq curr-page 0)
    (show-libdocs-list))
  (defun list-libdoc-by-search ( / i% search-str)
    (setq search-str (strcase (get_tile "search_box") T))
    (setq libdocs-list 
	  (vl-remove nil (mapcar '(lambda (x)
				   (if (or (vl-string-search search-str (strcase (car x) T))
					   (vl-string-search search-str (strcase (cadr x) T))
					   (vl-string-search search-str (strcase (caddr x) T))
					   )
				       x nil))
				 @:*libdoc*)))
    (setq curr-page 0)
    (show-libdocs-list)
    )
  (defun show-libdocs-list ()
    (setq i% 0)
    (repeat (min 20 (- (length libdocs-list) (* 20 curr-page)))
	    (set_tile (strcat "pkgn"(itoa (1+ i%))) (caddr (nth (+ i% (* 20 curr-page)) libdocs-list)))
	    (set_tile (strcat "pkgdesc"(itoa (1+ i%))) (cadr (nth (+ i% (* 20 curr-page)) libdocs-list)))
	    (mode_tile (strcat "pkg"(itoa (1+ i%))) 0)(mode_tile (strcat "pkgs"(itoa (1+ i%))) 0)
	    (setq i% (1+ i%)))
    (while (< i% 20)
      (set_tile (strcat "pkgn"(itoa (1+ i%))) "")
      (set_tile (strcat "pkgdesc"(itoa (1+ i%))) "")
      (mode_tile (strcat "pkg"(itoa (1+ i%))) 1)
      (mode_tile (strcat "pkgs"(itoa (1+ i%))) 1)
      (setq i% (1+ i%)))
    (set_tile "curr_total" (strcat (itoa (1+ curr-page)) "/" (itoa (1+ (/ (1- (length libdocs-list)) 20)))))
    (if (= 0 curr-page) (mode_tile "prev" 1) (mode_tile "prev" 0))
    (if (= (/ (1- (length libdocs-list)) 20) curr-page) (mode_tile "next" 1) (mode_tile "next" 0)))
  (defun init-dialog ()
    (setq libdocs-list @:*libdoc*)
    (setq curr-page 0)
    (show-libdocs-list))
  ;; ��ȡ���б�
  (at-documents:load-libdoc)
  (setq libdocs-list @:*libdoc*)
  (setq curr-page 0)
  ;; ���� dcl �ļ�
  (setq dcl-tmp (strcat @:*tmp-path* "tmp-lib-man.dcl" ))
  ;; (setq dcl-tmp (vl-filename-mktemp nil nil ".dcl" ))
  (setq dcl_fp (open dcl-tmp "w"))
  (write-line (strcat "lib_man : dialog {"
		      "label = \"" (_"Function Library") "\";"
		      ":column {children_alignment=left;:row { "
		      "  :popup_list{label=\""(_"Category")":\";key=\"category\";fixed_width=true;width=30;}"
		      ;; "  :popup_list{label=\""(_"Author")":\";key=\"author\";fixed_width=true;width=30;}"
		      "  :edit_box {key=\"search_box\";action=\"(list-libdoc-by-search)\";}:button{label=\"search\";key=\"searchbtn\";fixed_width=true;width=10;is_default=true;}}}"
		      ": column { ") dcl_fp)
  (write-line (strcat "label=\""(_"base function.") "\";") dcl_fp)
  (write-line (strcat ": row { : text { value=\"          "(_"Name") "\";width=48;fixed_width=true;}"
			 ": text { value=\"          "(_"?") "\";width=10;fixed_width=true;}"
			 " : text { value=\"\t   "(_"Description")"\"; width=85;}} : spacer {}")
	      dcl_fp)
  (setq i% 0)
  (repeat 20
	  (write-line (strcat ":row{"
			      ":text{key=\"pkgn"(itoa (1+ i%))"\";value=\"\";width=48;fixed_width=true;}"
			      ":button{key=\"pkg"(itoa (1+ i%))"\";label=\"Detail\";width=10;fixed_width=true;action=\"(show-detail "(itoa (1+ i%))")\";is_enabled=false;}"
			      ":button{key=\"pkgs"(itoa (1+ i%))"\";label=\"Src\";width=10;fixed_width=true;action=\"(show-src "(itoa (1+ i%))")\";is_enabled=false;}"
			      ":text{key=\"pkgdesc"(itoa (1+ i%))"\";value=\"\";width=85;fixed_width=true;}}")
		      dcl_fp)
	  (setq i% (1+ i%)))
  (write-line ":spacer{}}:spacer{}" dcl_fp)
  (write-line ":row{alignment=centered;children_alignment=centered;:button{label=\"<\";key=\"prev\";is_enabled=false;}:spacer{} :text_part{key=\"curr_total\"; value=\"\";alignment=\"centered\";width=10;}:button{label=\">\";key=\"next\";is_enabled=false;}}"
	      ;;(if (= 0 curr-page) "false" "true")
	      ;;(strcat (itoa (1+ curr-page)) "/" (itoa (1+ (/ (length libdocs-list) 20))))
	      ;;(if (= (/ (length libdocs-list) 20) curr-page) "false" "true")
	      dcl_fp
	  )
  (write-line ":spacer{} ok_cancel; }" dcl_fp)
  (close dcl_fp)
  
  (setq dcl_id (load_dialog dcl-tmp))
  (if (not (new_dialog "lib_man" dcl_id ))
      (exit))
  (start_list "category")
  (add_list "")
  (mapcar 'add_list @:*libdoc-category*)
  (end_list)
  ;; (start_list "author")
  ;; (add_list "")
  ;; (mapcar 'add_list @:*libdoc-author*)
  ;; (end_list)
  (action_tile "category" "(list-libdoc-by-category)")
  ;; (action_tile "author" "(list-libdoc-by-author)")
  (action_tile "searchbtn" "(list-libdoc-by-search)")
  (action_tile "prev" "(page-up)")
  (action_tile "next" "(page-down)")
  (init-dialog)
  ;;(show-libdocs-list)
  (start_dialog)
  ;;(new_dialog "Package-man" dcl_id "(show-libdocs-list)" )
  (unload_dialog dcl_id)
  )
(defun at-documents:gen-libdoc (/ files fp opt%)
  ;; ɾ��ԭ��ʱ
  (while (setq files (vl-directory-files (strcat @:*prefix* "packages\\base\\") "lib-*.to-gendoc.lsp" 1))
    (foreach file% files
	     (vl-file-delete (strcat @:*prefix* "packages\\base\\" file%))))
  (if (setq files (vl-directory-files (strcat @:*prefix* "packages\\base\\") "lib-*.lsp" 1))
      (foreach file% files
	       (dev:gen-doc (strcat @:*prefix* "packages\\base\\" file%))))
  (if (setq files (vl-directory-files (strcat @:*prefix* "packages\\base\\") "lib-*.to-gendoc.lsp" 1))
      (foreach file% files
	       (vl-file-delete (strcat @:*prefix* "packages\\base\\" file%))))
  
  ;; ɾ�����ĵ�
  (if (setq files (vl-directory-files (strcat @:*prefix* "packages\\at-documents\\") "*.libdoc" 1))
      (foreach file% files
	       (if (= 0 (vl-file-size (strcat @:*prefix* "packages\\at-documents\\" file%)))
		   (vl-file-delete (strcat @:*prefix* "packages\\at-documents\\" file%))))
      ))
(defun gen-base-doc () (at-documents:gen-libdoc))

(defun @doc:gen-openai (/ fp)
  (at-documents:load-libdoc)
  (setq fp (open (strcat @:*prefix* "openai.csv") "w"))
  (write-line "��������,��׼����,��׼��������ƶ���ֵ,�����û��ʷ��������##�ָ���,�����˻ش𣨶����##�ָ���,��ͼ���ȼ�,�Ƿ����"
	      fp)
  (write-line (strcat "@lisp������,@lisp������,0.91,,* �ṩ�������"
		      (string:from-lst @:*libdoc-category* "LINE_BREAK")
		      "LINE_BREAK������ ���:* ��ȡ������µĺ�����e.g.  block:* LINE_BREAK"
		      "������ ��������ȡ�ĺ����÷���e.g.  block:insert "
		      ",1,false") fp)
  (foreach category% @:*libdoc-category*
	   (write-line
	    (strcat "@lisp������,"
		    category%":*,"
		    "0.91,"
		    ",";;0.8<eos>1<eos>�ʷ�1##0.8<eos>1<eos>�ʷ�2
		    ;; ���ɸ���ĺ����б��Ȳ�����600  ������ LINE_BREAK
		    (string:from-list
		     (vl-remove
		      nil
		      (mapcar '(lambda (x)
				 (if 
				     (wcmatch x (strcat category% ":*"))
				     x nil))
				 (mapcar 'car @:*libdoc*)))
		     "LINE_BREAK")
		     ",1,false")
	    fp))
  (foreach func-info @:*libdoc*
	   (write-line
	    (strcat "@lisp������,"
		    (string:subst-all
		     "��" ","(@:to-string (car func-info)))","
		    "0.91,"
		    ",";;0.8<eos>1<eos>�ʷ�1##0.8<eos>1<eos>�ʷ�2
		    ;; ���ɸ���ĺ����б��Ȳ�����600  ������ LINE_BREAK
		    ;; ȥ ,
		    (if (member 34 (vl-string->list
				    (setq str
			  (string:subst-all
			   "\"\"" "\""
			   (string:subst-all
			    "LINE_BREAK" "\n"
			    (string:subst-all
			     "��" ","
			     (strcat
			      "�����÷�:\n  "(@:to-string (caddr func-info))
			      "\n* ����˵��:\n  " (@:to-string(cadr func-info))
			      "\n* ����:\n"(@:to-string(nth 3 func-info))
			      "\n* ����ֵ:\n   "(@:to-string(nth 4 func-info))
			      "\n* ʾ��:\n  "(@:to-string (nth 5 func-info))
			      )))))))
			(strcat "\""str"\"")
		      str)
		    ",1,false")
	    fp))  
  (close fp))
(defun @doc:gen-openai-pkg (/ fp)
  (@:package-update)
  (setq fp (open (strcat @:*prefix* "openai-pkg.csv") "w"))
  (write-line "��������,��׼����,��׼��������ƶ���ֵ,�����û��ʷ��������##�ָ���,�����˻ش𣨶����##�ָ���,��ͼ���ȼ�,�Ƿ����"
	      fp)
  (write-line (strcat "CADӦ����,Ӧ���б�,0.91,,* �ṩ��������Ӧ�ã�LINE_BREAK"
		      (string:from-lst @:*pkgs-category* "LINE_BREAK")
		      "LINE_BREAK������ ���:* ��ȡ������µ�Ӧ�á�"
		      ",1,false") fp)
  (foreach category% @:*pkgs-category*
	   (write-line
	    (strcat "CADӦ����,"
		    category%":*,"
		    "0.91,"
		    ",";;0.8<eos>1<eos>�ʷ�1##0.8<eos>1<eos>�ʷ�2
		    ;; ���ɸ���ĺ����б��Ȳ�����600  ������ LINE_BREAK
		    "�÷���������Ӧ�ð���LINE_BREAK"
		    (string:from-list
		     (vl-remove
		      nil
		      (mapcar '(lambda (x)
				 (strcat "* "(@:pkg x ':full-name) "  ID: " (@:pkg x ':name)))
			      (@:package-get-pkgs-by-category category%)))
		     "LINE_BREAK")
		    "LINE_BREAK ������������ID��ȡӦ�ð���Ϣ��"
		    ",1,false")
	    fp))
  (foreach pkg% @:*pkgs*
	   (write-line
	    (strcat "CADӦ����,"
		    (string:subst-all
		     "��" ","(@:pkg pkg% ':name))","
		     "0.91,"
		    "0.8<eos>1<eos>"
		    (@:pkg pkg% ':full-name)
		    ",";;0.8<eos>1<eos>�ʷ�1##0.8<eos>1<eos>�ʷ�2
		    ;; ���ɸ���ĺ����б��Ȳ�����600  ������ LINE_BREAK
		    ;; ȥ ,
		    (if (member 34 (vl-string->list
				    (setq str
			  (string:subst-all
			   "\"\"" "\""
			   (string:subst-all
			    "LINE_BREAK" "\n"
			    (string:subst-all
			     "��" ","
			     (strcat
			      "Ӧ�ð�:\n  "(@:to-string (@:pkg pkg% ':full-name))
			      "\n* ����:\n  "(@:to-string (@:pkg pkg% ':author))
			      "\n* �汾:\n"(@:to-string (@:pkg pkg% ':version))
			      "\n* ���:\n   "(@:to-string (@:pkg pkg% ':DESCRIPTION))
			      "\n������������� http://atlisp.cn/package-info/"
			      (@:pkg pkg% ':name) 
			      )))))))
			(strcat "\""str"\"")
		      str)
		    ",1,false")
	    fp))  
  (close fp))
