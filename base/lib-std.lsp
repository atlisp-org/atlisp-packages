;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; @ base -- @lisp ����������
;;; Author: VitalGG<vitalgg@gmail.com>
;;; Description: ���� AutoLisp/VisualLisp �����Ļ�ͼ���߼�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ������ lib-std.lsp
;;; �������ú�����

(setq
 ;;����VLA���󡢼���
 *ACAD*  (vlax-get-acad-object)
 *DOC*   (vla-get-ActiveDocument *ACAD*)
 *DOCS*  (vla-get-Documents *ACAD*)
 *MS*    (vla-get-modelSpace *DOC*)
 *PS*    (vla-get-paperSpace *DOC*)
 *BLKS*  (vla-get-Blocks *DOC*)
 *LAYS*  (vla-get-Layers *DOC*)
 *LTS*   (vla-get-Linetypes *DOC*)
 *STS*   (vla-get-TextStyles *DOC*)
 *GRPS*  (vla-get-groups *DOC*)
 *DIMS*  (vla-get-DimStyles *DOC*)
 *LOUTS* (vla-get-Layouts *DOC*)
 *VPS*   (vla-get-Viewports *DOC*)
 *VS*    (vla-get-Views *DOC*)
 *DICS*  (vla-get-Dictionaries *DOC*)
 *Layouts* (vla-get-Layouts *doc*)
 *DISPLAY* (vla-get-display (vla-get-preferences (vla-get-application *acad*)))
 )
;; ·������
(defun @:path (path-str)
  "���ַ�����ʽ��·��ת��Ϊ�б��ʽ��"
  (@:string-to-list path-str "\\"))

(defun @:mkdir (dir-list / dir-path dir% )
  "���б��𼶴���Ŀ¼��"
  (setq dir-path "")
  (foreach dir% dir-list
	   (if (= 'STR (type dir%))
	       (cond
		 ((= 58 (last (vl-string->list dir%))) ;; �̷�
		  (setq dir-path (strcat dir-path dir%)))
		 ((> (strlen dir%) 0)
		  (setq dir-path (strcat dir-path "\\" dir%))
		  (vl-mkdir dir-path))))
	   )
  dir-path
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; �ļ���������
(defun @:put-list-to-file ( lst wfp / i  slen w lf )
  "�������з�ʽд���ļ�"
  (setq slen (length lst))
  (setq  i 1 lst '() )
  (setq lf (open wfp "w"))
  (foreach w lst
	   (write-line w lf)
	   )
  (close lf)
  (princ)
  )

;;; ����
(defun @:sort-by-order (mylist order / l m b c)
  "���б��������"
  (setq n (length mylist))
  (setq l 0)
  (setq m 1)
  (while (< l n)
    (setq b (nth l mylist))
    (while (< m n)
      (setq c (nth m  mylist))
      (if (< (atoi (last (@:string-to-list
			  (@:string-subst "-" "��" (cdr (assoc order c))) "-")))
	     (atoi (last (@:string-to-list
			  (@:string-subst "-" "��" (cdr (assoc order b)))"-" ))))
          (progn
            (setq mylist (subst 'aa (nth l mylist) mylist))
            (setq mylist (subst 'bb (nth m mylist) mylist))
            (setq mylist (subst c 'aa mylist))
            (setq mylist (subst b 'bb mylist))
            (setq b c)
            )
          )
      (setq m (1+ m))
      )
    (setq l (1+ l))
    (setq m (1+ l))
    )
  mylist
  )

(defun @:check-consistency (contents order / ti% tmplist)
  "���ĳ��ֵ��Ψһ�ԡ�����ֵΪ������"
  (setq tmplist '())
  (foreach ti% contents 
	   (if (= nil (member (cdr (assoc order ti%)) tmplist))
	       (setq tmplist (append tmplist (list (cdr (assoc order ti%)))))))
  (length tmplist)
  )

(defun @:princ (content)
  (princ (@:to-string content)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ��������
;;; ���ڶ���һЩȫ�ֱ����������������Ҫʹ�õ�ͨ�û�������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun std:acad-object nil
  "����CAD����"
  (eval (list 'defun 'std:acad-object 'nil (vlax-get-acad-object)))
  (std:acad-object)
  )

(defun std:active-document nil
  "���ص�ǰ��ĵ�����"
  (eval (list 'defun 'std:active-document 'nil (vla-get-activedocument (vlax-get-acad-object))))
  (std:active-document)
  )

(defun std:model-space nil
  "����ģ�Ϳռ����"
  (eval (list 'defun 'std:model-space 'nil (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))))
  (std:model-space)
  )

(defun std:layers nil
  "����ͼ�㼯��"
  (eval (list 'defun 'std:layers 'nil (vla-get-Layers (vla-get-activedocument (vlax-get-acad-object)))))
  (std:layers)
  )

(defun std:linetypes nil
  "�������ͼ���"
  (eval (list 'defun 'std:line-types 'nil (vla-get-Linetypes (vla-get-activedocument (vlax-get-acad-object)))))
  (std:line-types)
  )

(defun std:TextStyles ()
  "����������ʽ����"
  (eval (list 'defun 'std:TextStyles 'nil (vla-get-TextStyles (vla-get-activedocument (vlax-get-acad-object)))))
  (std:TextStyles)
  )

(defun std:getinput (promptstr inplist default / inp) 
  "��ȡ���룬���initget��getkword����"
;;;arg:promptstr:��ʾ�ַ���
;;;arg:inplist:�ؼ����б�
;;;arg:default:Ĭ�Ϸ��عؼ��֣����û��Ϊnil
;;;return:�����ַ���
;;;example:(std:getinput "���������" '("Y" "N") "Y")
  (initget (if default 0 1)	(string::from-lst inplist " ")) ;����Ĭ��ֵȷ��initget����
  (if (setq inp 
	    (getkword 
	     (strcat
	      (if promptstr (strcat promptstr " [") "[") ;�����ʾ�ַ�����[]
	      (string::from-lst inplist "/") ;������ʾ�ַ���
	      "]"                  
	      (if (and default (member default inplist)) ;����Ĭ��ֵ
		  (strcat " <" default ">: ")
		  ": ")
	      )
	     )
	    ) 
      inp
      default
      )
  );�˺���δ������� inplist �Ϸ���

(defun std:startundo (doc)
;;;name:std:startundo
;;;desc:��ʼ�������� -- lee mac
;;;arg:doc:��ǰ��ĵ�-(std:active-document)
;;;return:nil
;;;example:(std:startundo (std:active-document))
  (std:endundo doc)
  (vla-startundomark doc)
  )

(defun std:endundo ( doc )
;;;name:std:endundo
;;;desc:�������� -- lee mac
;;;arg:doc:��ǰ��ĵ�-(std:active-document)
;;;return:nil
;;;example:(std:endundo (std:active-document))
  (while (= 8 (logand 8 (getvar 'undoctl)))
    (vla-endundomark doc)
    )
  )

(defun std:protect-assign (syms)
;;;name:std:protect-assign
;;;desc:���ű��� 
;;;arg:syms:�������б�
;;;return:
;;;example:(std:protect-assign '(aaa bbb))
  (eval	(list 'pragma
	      (list 'quote (list (cons 'protect-assign syms)))
	      )
	)
  )

(defun std:unprotect-assign (syms)
;;;name:std:unprotect-assign
;;;desc:���Ž������ 
;;;arg:syms:�������б�
;;;return:
;;;example:(std:unprotect-assign '(aaa bbb))
  (eval
   (list 'pragma
	 (list 'quote (list (cons 'unprotect-assign syms)))
	 )
   )
  )

(defun defconstant (name value)
  "����ȫ�ֳ�����ȫ�ֳ���ͨ���� + ��ʼ�ͽ�β��"
  "һ�����ű����ı���"
  "(defconstant '+aaa+ 2)"
  (setq name (vl-symbol-name name))
  (eval
   (list 'pragma
	 (list 'quote (list (cons 'unprotect-assign name)))
	 )
   )
  ;;(std:unprotect-assign (list (read name)))
  (set (read name) value)
  (eval	(list 'pragma
	      (list 'quote (list (cons 'protect-assign name)))
	      )
	)
  ;;(std:protect-assign (list (read name)))
  )

(defun s:doc-gen (lspfilename / arg description docpath example fbasename ff filepath fpath header lines markdownfile ret subroutine)
  
;;;name:std:doc-gen
;;;desc:�ĵ����ɺ���
;;;arg:lspfilename:Ҫ�����ĵ���lsp�ļ�������ʽΪgetfiled����ֵ�ĸ�ʽ
;;;return:����markdown�ļ�
;;;example:(std:doc-gen "E:\\lisptest.lsp")
  (defun header (filename)
    (write-line  (string:format "# {0}\r\n" filename) markdownfile))
  
  (defun subroutine (str)
    (write-line  (string:format "## {0}\r\n" str) markdownfile))
  
  (defun description (str) 
    (write-line  (string:format "˵����\r\n{0}\r\n\r\n������\r\n" str) markdownfile))
  
  (defun arg (str)
    (setq str (string:to-lst str ":"))
    (write-line 
     (if (> (length str) 1) 
	 (string:format "* {0} - {1}\r\n" str)
	 "* No arguments\r\n"
	 )
     markdownfile
     )
    )
  
  (defun ret (str)
    (write-line (string:format "����ֵ: \r\n{0}\r\n" str) markdownfile)
    )
  
  (defun example (str)
    (write-line (string:format "ʾ��:\r\n```\r\n{0}\r\n ```\r\n" str) markdownfile)
    )
  
  (defun default (str)
    (write-line (string:format " + {0}\r\n" str) markdownfile)
    )
  
  (defun defaultexample (str)
    (write-line (string:format "```\r\n{0}\r\n ```\r\n" str) markdownfile)
    )
  
  (setq filepath (vl-filename-directory lspfilename)
	fbasename (vl-filename-base lspfilename)
	docpath (strcat filepath "\\doc\\")
	)
  (vl-mkdir docpath)
  (setq markdownfile (open (setq fpath (strcat docpath fbasename ".markdown")) "w"))
  (header (strcat (vl-filename-base lspfilename) ".lsp"))
  (setq ff (open lspfilename "r"))
  (while (setq lines (read-line ff))
    (cond 
      ((wcmatch lines ";;;name:*") (subroutine (vl-string-subst "" ";;;name:" lines)))
      ((wcmatch lines ";;;desc:*") (description (vl-string-subst "" ";;;desc:" lines)))
      ((wcmatch lines ";;;arg:*") (arg (vl-string-subst "" ";;;arg:" lines)))
      ((wcmatch lines ";;;return:*") (ret (vl-string-subst "" ";;;return:" lines)))
      ((wcmatch lines ";;;example:*") (example (vl-string-subst "" ";;;example:" lines)))
      ((wcmatch lines ";;;(*") (defaultexample (vl-string-subst "" ";;;" lines)))
      ((wcmatch lines ";;;*") (default (vl-string-subst "" ";;;" lines)))
      )
    )
  
  (close ff)
  (close markdownfile)
  (print (strcat "����markdown�ĵ���ϣ�λ�ã�" fpath ))
  (princ)
  )

(defun std:timer-start ()
  "��ʱ����ʼ����"
  "��ʱ��ȫ�ֱ���"
  (setq @:*timer-prg* (getvar "TDUSRTIMER"))
  )
(defun std:timer-end ()
  "��ʱ����������"
  (princ "\n    ��ʱ")
  (princ (* (- (getvar "TDUSRTIMER") @:*timer-prg*) 86400))
  (princ "��\n")
  (setq @:*timer-prg* nil)
  (princ)
  )
(defun std:e->vla (ename)
;;;name:std:e->vla
;;;desc:�ض���vlax-ename->vla-object����
;;;arg:ename:ͼԪ��
;;;return:vla����
;;;example:(std:e->vla (car (entsel)))
  (vlax-ename->vla-object ename)
  )
(defun std:vla->e (obj)
;;;name:std:vla->e
;;;desc:�ض���vlax-vla-object->ename����
;;;arg:obj:vla������
;;;return:ͼԪ��
;;;example:(std:vla->e obj)
  (vlax-vla-object->ename obj)
  )
(defun std:save-system-variable (a)
;;;desc:����ϵͳ��������,���浱ǰ��ϵͳ����,Ϊ�����ڷ������˳�ʱ�ָ�ϵͳ������
;;;arg:a:ϵͳ��������ɵı�(������  ������ ....)
;;;return:ȫ�ֱ���-*user-system-variable*-ϵͳ��������ֵ��ɵı�((������ . ֵ) (...  ...))
;;;example:(std:save-system-variable '("cmdecho" "osmode" "dimtxt"))
  (setq *user-system-variable* (mapcar 'cons a (mapcar 'getvar a))) 
  )
(defun std:reset-system-variable ()
;;;name:std:reset-system-variable
;;;desc:�ָ�ϵͳ������������std:save-system-variable�ɶ�ʹ��
;;;arg:
;;;return:nil
;;;example:(std:reset-system-variable)
  (mapcar 'setvar (mapcar 'car *user-system-variable*) (mapcar 'cdr *user-system-variable*))
  (setq *user-system-variable* nil)
  )
(defun std:return (value)
  "����ֵ���������ڰ�װ��Ҫ���ص�ֵ����Ҫ���û���Ϊ�˺������ȷ��"
  value)
(defun std:AddSupportPath (lst)
;;;name:std:AddSupportPath
;;;desc:���֧���ļ�����·������·����ӵ����
;;;arg:lst:Ҫ��ӵ�·���б�
;;;return:֧���ļ�����·���ַ���=ACAD��������ֵ
;;;example:(std:AddSupportPath '("C:\\Folder1" "C:\\Folder2" "C:\\Folder3"))
  ((lambda (str lst)
     (if (setq lst
	       (vl-remove-if
		'(lambda ( x )
		  (or (vl-string-search (strcase x) (strcase str))
		   (not (findfile x))
		   )
		  )
		lst
		)
	       )
	 (setenv "ACAD" (strcat str ";" (apply 'strcat (mapcar '(lambda (x) (strcat x ";")) lst))))
	 )
     )
   (vl-string-right-trim ";" (getenv "ACAD"))
   (mapcar '(lambda (x) (vl-string-right-trim "\\" (vl-string-translate "/" "\\" x))) lst)
   )
  )
(defun std:RemoveSupportPath (lst / del str tmp)
;;;name:std:RemoveSupportPath
;;;desc:ɾ��֧���ļ�����·��
;;;arg:lst:Ҫɾ����·���б�
;;;return:֧���ļ�����·���ַ���=ACAD��������ֵ
;;;example:(std:RemoveSupportPath '("C:\\Folder1" "C:\\Folder2" "C:\\Folder3"))
  
  (defun del (old str / pos)
    (if (setq pos (vl-string-search (strcase old) (strcase str)))
	(strcat (substr str 1 pos) (del old (substr str (+ 1 pos (strlen old)))))
	str
	)
    )   
  (setq str (strcat (vl-string-right-trim ";" (getenv "ACAD")) ";")
	tmp str
	)
  (foreach pth lst
	   (setq str (del (strcat (vl-string-right-trim "\\" (vl-string-translate "/" "\\" pth)) ";") str))
	   )
  (if (/= tmp str) (setenv "ACAD" str))
  )


(defun std:CatchApply (fun args / result)
;;;name:std:CatchApply
;;;desc:�ض��� VL-CATCH-ALL-APPLY ��Gu_xl
;;;arg:fun:���� �� distance or 'distance
;;;arg:args:�����Ĳ�����
;;;return:�纯�����д��󷵻�nil,���򷵻غ����ķ���ֵ
;;;example:(std:CatchApply '+ '(1 2 3 4))
  (if
   (not
    (vl-catch-all-error-p
     (setq result
	   (vl-catch-all-apply
	    (if (= 'SYM (type fun))
		fun
		(function fun)
		)
	    args
	    )
	   )
     )
    )
   result
   )
  )

(defun std:RemoveMenuItem (POPName / menubar menuitem)
;;;name:std:RemoveMenuItem
;;;desc:�Ƴ������˵���Gu_xl 
;;;arg:POPName:�����˵�����
;;;return:�ɹ�����T����֮nil
;;;example:(std:RemoveMenuItem "CASS����");�Ƴ� ��CASS���ߡ� �˵�
  (setq MenuBar (vla-get-menubar (vlax-get-acad-object)))
  ;; �Ҳ˵� Item 
  (setq menuitem (std:CatchApply 'vla-item (list MenuBar POPName)))
  (if menuitem (std:CatchApply 'vla-RemoveFromMenuBar (list menuitem)))
  )

(defun std:AddMenu (MenuGroupName POPName PopItems InsertBeforeItem / i menubar menuitem n popupmenu)
;;;name:std:AddMenu
;;;desc:��������˵���Gu_xl
;;;arg:MenuGroupName:Ҫ����Ĳ˵�������
;;;arg:POPName:�����˵�����
;;;arg:PopItems:�����˵��б��� '((��ǩ ���� �����ִ� �μ�����)...) ��Ϊ�����˵��б�ע�������Ҫ��һ���ո�
;;;arg:InsertBeforeItem:�ڸò˵�������֮ǰ���룬���� "������"����Ϊ nil,��������
;;;return:��
;;;example:(std:AddMenu "ACAD" "CASS����" items "������")
  ;;ж��ԭ�в˵�
  (std:RemoveMenuItem POPName)
  
  (setq MenuBar (vla-get-menubar (vlax-get-acad-object)))
  (if InsertBeforeItem
      (progn
	;; ���Ҳ˵��������䡱
	(setq n (vla-get-count MenuBar))
	(setq i (1- n))
	(while
	    (and (>= i 0)      ; û�г�������
		 (/= InsertBeforeItem
		     (vla-get-name (setq menuitem (vla-item MenuBar i)))
		     )        ; �ҵ�"������"�˵���
		 )
	  (setq i (1- i))
	  )
	(if (< i 0)      ; ���û���ļ��˵�, ȡ���һ���˵��˵�
	    (setq i (vla-get-count MenuBar))
	    )
	)
      (setq i (vla-get-count MenuBar)) ;_  ȡ���һ���˵��˵�
      )
  ;;����"CASS����"�˵���
  (if (not
       (setq popupmenu
	     (std:CatchApply
	      'vla-Item
	      (list
	       (vla-get-menus
		(vla-item
		 (vla-get-MenuGroups (vlax-get-acad-object))
		 MenuGroupName ;_ "�������߼�" �˵�������
		 )
		)
	       POPName ;_ "CASS����" �����˵�����
	       )
	      )
	     )
       )
      (setq popupmenu
	    (vla-add
	     (vla-get-menus
	      (vla-item (vla-get-MenuGroups (vlax-get-acad-object))
			MenuGroupName ;_ "�������߼�" �˵�������
			)
	      )
	     POPName ;_ "CASS����" �����˵�����
	     )
	    )
      )
  ;;���Menu����
  (vlax-for popupmenuitem popupmenu
	    (vla-delete popupmenuitem)
	    )
  ;;����"CASS����"�˵���
  (vla-InsertInMenuBar popupmenu i)
  (std:insertPopMenuItems popupmenu PopItems)
  (princ)
  )
(defun std:insertPopMenuItems (popupmenu PopItems / K TMP)
;;;name:std:insertPopMenuItems
;;;desc:�������˵�����Gu_xl
;;;arg:popupmenu:�˵���vla����
;;;arg:PopItems:�����˵��б�,�� '((��ǩ ���� �����ִ� �μ�����)...) ��Ϊ�����˵��б�ע�������Ҫ��һ���ո�
;;;return:�˵����б�
;;;example:(std:insertPopMenuItems popupmenu PopItems)
  (setq k 0)
  ;;����"CASS����"�˵�����Ŀ
  (mapcar
   (function
    (lambda (x / Label cmdstr hlpstr subItems tmp)
     (setq Label    (car x)
	   cmdstr   (cadr x)
	   hlpstr   (caddr x)
	   subItems (cadddr x)
	   )
     (if (= label "--")
	 ;; ����ָ���
	 (vla-AddSeparator
	  popupmenu
	  (setq k (1+ k))
	  )
	 (if (and Label cmdstr)
	     ;; ����˵���
	     (progn
	       (setq tmp
		     (vla-addmenuitem
		      popupmenu
		      (setq k (1+ k))
		      Label
		      cmdstr
		      )
		     )
	       (vla-put-helpstring tmp hlpstr)
	       )
	     ;; ������һ���Ӳ˵�
	     (progn
	       (setq tmp
		     (vla-addsubmenu
		      popupmenu
		      (setq k (1+ k))
		      Label
		      )
		     )
	       (if subItems ;_ ����Ӽ��˵�
		   (std:insertPopMenuItems tmp subItems)
		   )
	       )
	     )
	 )
     )
    )
   ;;'((��ǩ ���� �����ִ� �μ��˵���)) ��Ϊ�˵��ע�������Ҫ��һ���ո�
   PopItems
   )
  )

(defun std:AddToolBars (MENUGROUPNAME TOOLBARITEMS / flyout flyoutbutton helpstring idx items largeiconname left macro menugroupobj name smalliconname toolbar toolbaritem toolbarname toolbars top)
;;;name:std:AddToolBars
;;;desc:��ӹ����� By Gu_xl ����ͨ��
;;;arg:MENUGROUPNAME:�˵�����
;;;arg:TOOLBARITEMS:Ҫ��ӵĹ������б�,��ʽ����:((toolBarName Left Top (Name HelpString Macro SmallIconName [LargeIconName] [FlyoutButton])...)...)
;;;toolBarName ;_ ����������
;;;Left ;_ ����������Ļ�����������
;;;Top ;_ ����������Ļ������������
;;;Name ;_ ��ť����
;;;HelpString ;_ ˵���ִ�
;;;Macro ;_ ����꣬ע�������Ҫ��һ���ո�
;;;SmallIconName ;_ ��ťСͼ��16x16,ͼ���ļ�Ҫ������Ŀ¼�»���DLL��Դ�ļ���
;;;[LargeIconName] ;_ ��ť��ͼ��24x24,ͼ���ļ�Ҫ������Ŀ¼�»���DLL��Դ�ļ���
;;;[FlyoutButton] ;_ ���Ǹ�����ť����Ϊ ������ť�����Ĺ����������ִ�������Ϊnil���ṩ
;;;return:��
;;;example:(std:AddToolBars "ACAD" items)
  
  (if (not (setq menugroupobj
		 (std:CatchApply
		  vla-item
		  (list
		   (vla-get-MenuGroups (vlax-get-acad-object))
		   MenuGroupName ;_ "�������߼�" �˵�������
		   )
		  )
		 )
	   )
      (progn
	(alert (strcat "�˵���\""
		       MenuGroupName
		       "\"�����ڣ��޷����ز˵�����"
		       )
	       )
	(exit)
	)
      )
  (setq toolBars (vla-get-toolbars menugroupobj)) ;_ ������
  (foreach items toolbarItems
	   (setq toolBarName (car items) ;_ ����������
		 Left        (cadr items) ;_ ������ ��Ļλ��
		 Top        (caddr items) ;_ ��������Ļλ��
		 items        (cdddr items)
		 )
	   (if  (setq toolbar
		      (std:CatchApply
		       vla-item
		       (list toolBars toolBarName)
		       )
		      )
		(vla-delete toolbar)
		)
	   (setq toolbar (vla-add toolBars toolBarName))
	   (vla-put-left toolbar left)
	   (vla-put-top toolbar Top)
	   (setq idx 0)
	   (foreach lst items
		    (setq name (car lst)
			  HelpString (cadr lst)
			  Macro (caddr lst)
			  SmallIconName (cadddr lst)
			  LargeIconName (car (cddddr lst))
			  FlyoutButton (cadr (cddddr lst))
			  )
		    (if (not LargeIconName)
			(setq LargeIconName SmallIconName)
			)
		    (if FlyoutButton
			(setq Flyout :vlax-true)
			(setq Flyout :vlax-false)
			)
		    (setq ToolbarItem
			  (std:CatchApply
			   vla-AddToolbarButton
			   (list toolbar idx name HelpString Macro Flyout)
			   )
			  )
		    (std:CatchApply
		     vla-SetBitmaps
		     (list ToolbarItem SmallIconName LargeIconName)
		     )
		    (if FlyoutButton
			(std:CatchApply
			 vla-AttachToolbarToFlyout
			 (list ToolbarItem MENUGROUPNAME FlyoutButton)
			 )
			)
		    (setq idx (1+ idx))
		    )
	   )
  )

(defun std:rgb (red green blue)
  "����RGB��ɫ��Ӧ������ֵ��Red Green Blue ȡֵ��ΧΪ [0,255]��������[0,1)��С����"
  "RGB��ɫֵ"
  "(std:rgb 255 0 0) or (std:rgb 0.999 0 0);��ɫ"
  (cond
    ((and (<= 0 red)(< red 1)
	  (<= 0 green)(< green 1)
	  (<= 0 blue)(< blue 1))
     (+ (fix (* 256 red)) (* 256 (fix (* 256 green))) (* 65536 (fix (* 256 blue)))))
    ((and (<= 0 red 255)
	  (<= 0 green 255)
	  (<= 0 blue 255))
     (+ (fix red) (* 256 (fix green)) (* 65536 (fix blue))))
    (t 
     (+ 255 (* 256 255)(* 65536 255)))))

(setq @:get-eval-code @:get-exec-permit)
(setq @:run-from-web @:load-remote)

;; Local variables:
;; coding: gb2312
;; End: 
