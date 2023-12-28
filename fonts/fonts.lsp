(setq @:font-dir (@:string-to-list (getenv "ACAD") ";"))

(if (null (member (strcat @:*prefix* "packages\\fonts") @:font-dir))
    (setenv "ACAD" (strcat (vl-string-right-trim ";" (getenv "ACAD"))
			   ";"
			   @:*prefix* "packages\\fonts;")))

(defun fonts:merge (/ date1 date2 font font_obj fontlist fontname n to-shx to-ttf)
  "�鲢������ʽ��"
  (setq date1 (getvar "millisecs"))
  (defun to-shx(shxx shxb / a3)
    (setq a3 (entget (tblobjname "style" font)));ȡ����������ݴ���
    (setq a3 (subst (cons 3 shxx )(assoc 3 a3) a3));���������͸ĳ�������
    (setq a3 (subst (cons 4 shxb )(assoc 4 a3) a3));���������͸ĳ�������
    (entmod a3);��������
    )
  (defun to-ttf(ttf / obj)
    (setq obj (vla-add font_obj font))
    (vla-setFont obj ttf :vlax-false :vlax-false 134 2)
    )
  (setq font_obj (vla-get-TextStyles(vla-get-ActiveDocument(vlax-get-acad-object))))
  (vlax-for sobj font_obj
            (setq fontname (vla-get-name sobj))
            (setq fontlist (vl-remove "" (cons fontname fontlist)))
            )
  (setq n 0)
  (repeat (length fontlist)
          (setq font (nth n fontlist))
          (cond
            ((wcmatch font "*����*")(to-ttf "����"))
            ((wcmatch font "*����*")(to-ttf "����"))
            ((wcmatch font "*����*")(to-ttf "����"))
            (t(to-shx "tssdeng.shx" "hztxt.shx"))
            )
          (setq n (+ n 1))
          )
  (repeat 1 (vl-cmdf "regen"))
  (setq date2 (getvar "millisecs"))
  (princ (strcat "����ʱ" (rtos(/(- date2 date1)1000.000)2 3) "�롣"))
  )

(defun fonts:merge1(/ a1 a2 date1 date2 to-shx to-ttf)
  (setq date1 (getvar "millisecs"))
  (defun to-shx(shxx shxb / a3)
    (setq a3 (entget (tblobjname "style" a2)));ȡ����������ݴ���
    (setq a3 (subst (cons 3 shxx )(assoc 3 a3) a3));���������͸ĳ�������
    (setq a3 (subst (cons 4 shxb )(assoc 4 a3) a3));���������͸ĳ�������
    (entmod a3);��������
    )
  (defun to-ttf(ttf / font_obj obj)
    (setq font_obj (vla-get-TextStyles(vla-get-ActiveDocument(vlax-get-acad-object))))
    (setq obj (vla-add font_obj a2))
    (vla-setFont obj ttf :vlax-false :vlax-false 134 2)
    )
  (setq a1 (tblnext "style" t));��ָ���Ƶ���һ������
  (while a1
    (setq a2 (cdr (assoc 2 a1)));ȡ����������
    (cond
      ((wcmatch a2 "*����*")(to-ttf "����"))
      ((wcmatch a2 "*����*")(to-ttf "����"))
      ((wcmatch a2 "*����*")(to-ttf "����"))
      (t(to-shx "tssdeng.shx" "hztxt.shx"))
      )
    (setq a1 (tblnext "style"));�ҳ���һ������
    )
  (repeat 1 (vl-cmdf "regen"))
  (setq date2 (getvar "millisecs"))
  (princ (strcat "����ʱ" (rtos(/(- date2 date1)1000.000)2 3) "�롣"))
  )
(defun fonts:nulltoFonts(shxx shxb ttf / err font_obj)
  (setq font_obj (vla-get-TextStyles(vla-get-ActiveDocument(vlax-get-acad-object))))
  (vlax-for x font_obj ;�������뺯��ʱ�����¶���font_obj
	    (vla-getfont x 'a 'b 'c 'd 'e)
	    (if (= a "")
		(progn
		  (if (and
		       (not (findfile (vla-get-fontfile x)))
		       (not (findfile (strcat (vla-get-fontfile x) ".shx")))
		       )
		      (vla-put-fontfile x shxx)
		      )
		  (if (and
		       (/= (vla-get-bigfontfile x) "")
		       (not (findfile (vla-get-bigfontfile x)))
		       (not (findfile (strcat (vla-get-bigfontfile x) ".shx")))
		       )
		      (vla-put-bigfontfile x shxb)
		      )
		  )
		(progn
		  (setq err (vl-catch-all-apply 'vla-setfont (list x a b c d e)))
		  (if (vl-catch-all-error-p err)
		      (vla-setfont x ttf b c d e)
		      )
		  )
		)
	    )
  (princ(strcat "\n>>>������ֱ��滻Ϊ" shxx "��" shxb "��" ttf))
  (repeat 1 (vl-cmdf "regen"))
  (princ)
  )

(defun fonts:check (/ lst-missing st)
  "����Ƿ��������ļ�"
  (setq st (tblnext "style" t))
  (setq lst-missing
	(cons (list (cdr (assoc 3 st))(cdr (assoc 4 st)))
	      nil))
  
  (while (setq st (tblnext "style"))
    (setq lst-missing
	  (cons (list (cdr (assoc 3 st))(cdr (assoc 4 st)))
		lst-missing))
    )
  (vl-remove nil
	     (mapcar
	      '(lambda(x)
		(cond
		  ((null(vl-filename-extension x))
		   (if (findfile (strcat x ".shx")) nil x))
		  ((member (strcase (vl-filename-extension x) t) '(".shx"))
		   (if (findfile x) nil x))
		  ((member (strcase (vl-filename-extension x) t) '(".ttf" ".ttc"))
		   (if (findfile (strcat (getenv "windir") "\\Fonts\\" x)) nil x))))
	      (list:remove-duplicates(vl-remove nil  (vl-remove "" (apply 'append lst-missing))))
	      ))
  )
