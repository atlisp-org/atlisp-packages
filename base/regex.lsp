
(defun string:sort-by-number (lst / b b-a c len maxn str2 str3 str4 xx)
  (defun xx (str n)
    (apply 'strcat (mapcar '(lambda (x) (if (wcmatch x "~*[~0-9]*") (try-bu0 n (atoi x)) x)) (try-StrRegExp str "\\D+|\\d+")))
    )
  (setq
   str2 (mapcar '(lambda (x) (try-StrRegExp x "\\D+|\\d+")) lst)
   str3 (try-lst-nto1 str2)
   str4 (vl-remove-if-not '(lambda (x) (wcmatch x "~*[~0-9]*")) str3)
   len (mapcar 'strlen str4)
   maxn(apply 'max len);Ѱ����������
   b (mapcar '(lambda(x) (xx x maxn)) lst)
   b-a (mapcar 'list b lst)
   c (try-str-sort b-a 0)
   )
  (mapcar 'cadr c)
  )


(defun try-bu0 (n0 num / _000)
  (setq _000 "")
  (repeat(- n0 (strlen(rtos num 2 0)))(setq _000(strcat "0" _000)))
  (strcat _000 (rtos num 2 0))
  )
(defun try-StrRegExp(str1 expr)
  (_Replace str1 expr nil "")
  )
(defun try-lst-nto1(lst / lst1 a)
  (setq lst1 '())
  (if (listp lst)
      (progn
	(foreach x lst
		 (setq a (try-lst-nto1 x))
		 (if (listp a)
		     (setq lst1 (append lst1  a))
		     (setq lst1 (append lst1 (list a)))
		     )
		 )
	)
      (setq lst1 lst)
      )
  lst1
  )

(defun try-str-sort (lst n / a b lst-ret str_ac str_sort strs)
  (setq 
   strs(mapcar '(lambda(x)(nth n x))lst)
   str_ac(mapcar 'cons strs lst)
   str_sort(acad_strlsort strs)
   )
  (if str_sort
      (progn 
	(while(setq a(car str_sort))
	  (setq 
	   str_sort(cdr str_sort)
	   b(assoc a str_ac)
	   n(vl-position b str_ac);Ѱ������
	   str_ac(try-lst-move str_ac n);ɾ������ָ������Ԫ��
	   lst-ret(cons (cdr b)lst-ret)
	   )
	  )
	(reverse lst-ret)
	)
      )
  )
(defun _Replace(str1 str2 bull str3 / lst matchcollect reg)
  (setq lst '())
  (setq reg (vlax-create-object "vbscript.regexp")) ;����������ʽ
  (if (null reg)
      (progn
	(alert "����ϵͳvbscriptû��ע�ᣬ�ֳ��Զ���ע��")
	(command"shell" "copy %systemroot%\\System32\\vbscript.dll %systemroot%\\System\\")
					;(command"shell" "copy C:\\Windows\\System32\\vbscript.dll C:\\Windows\\")
	(command"shell" "regsvr32 vbscript.dll")
	(setq reg (vlax-create-object "vbscript.regexp"))
	(if (null reg) 
	    (progn 
	      (setq file32 "C:\\Windows\\System32\\vbscript.dll"
		    file "C:\\Windows\\System\\vbscript.dll"
		    vbsfile32(findfile file32)
		    vbsfile(findfile file)
		    )
	      (cond 
		((and vbsfile32 (null vbsfile))(vl-file-copy vbsfile32 file))
		((and vbsfile (null vbsfile32))(vl-file-copy vbsfile file32))
		)
	      (command"shell" "regsvr32 vbscript.dll")
	      (setq reg (vlax-create-object "vbscript.regexp"))
	      (if (null reg)(princ "\nvbscript���ע��ʧ�ܣ���������Ŀ¼Ѱ��vbscript.dll�ļ������Ƶ����¼���Ŀ¼��\nC:\\Windows��C:\\Windows\\System32��C:\\Windows\\System��C:\\Windows\\SysWOW64"))
	      (princ)
	      )
	    )
	)
      )
  (vlax-put-property reg 'global -1) ;�Ƿ�ƥ��ȫ�� ��-1�� ��0 ���ǣ�
  (vlax-put-property reg 'Multiline -1);�Ƿ����ƥ�� ��-1�� ��0 ���ǣ�
  (vlax-put-property reg 'IgnoreCase -1);�Ƿ���Դ�Сд ��-1�� ��0 ���ǣ�
  (vlax-put-property reg 'pattern str2);lisp \\
  ;; 	1.(vlax-invoke-method reg 'test str)�ж��ַ����Ƿ���������ʽƥ��
  (if (vlax-invoke-method reg 'test str1)
      ;; 	2.(vlax-invoke-method reg 'Execute str)����ƥ�伯��	  
      (progn (setq matchcollect (vlax-invoke-method reg 'Execute str1))
	     ;; 	3.��ӡƥ���ÿ������Ԫ�ص�value		
	     (vlax-for match_item matchcollect (setq lst(cons(eval (vlax-get-property match_item 'value))lst)))
	     )
      )
	;;; 	4.�滻ƥ���ֵ	(vlax-invoke-method reg 'Replace str "replace")	����str����  	
  (setq lst(reverse lst))
  (if bull
      (setq lst(vlax-invoke-method reg 'Replace str1 str3)))
	;;;  ----------------- end ������ʽ����
  (vlax-release-object reg);�ͷ��ڴ�
  lst
  )
(defun try-lst-move(lst n / i)
  (setq i -1)
  (vl-remove-if '(lambda (x) (= (setq i (1+ i)) n)) lst)
  )
