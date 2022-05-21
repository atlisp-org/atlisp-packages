;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'qrencode:first ���� Ӧ�ð� qrencode �� ��һ�������� first 
(@:define-config 'qrencode:scale 100 "��ά����Ʊ�����")
;; (@:get-config 'qrencode:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'qrencode:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "�ı�" "���ɶ�ά��" "(qrencode:draw)" )
(defun qrencode:hello ()
  (@:help (strcat "�������������������������ܿ�ʼʱ�����û����й�����ʾ��\n"
		  "����ôʹ�ã�ע������ȡ�\n���û�������ѧϰģʽʱ�����������л򵯴�������ʾ��\n"
		  ))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (princ)
  )
(if (null (findfile (strcat @:*prefix* "bin\\QRencodeForLisp.exe")))
    (@:down-file "bin/QRencodeForLisp.exe"))
(defun qrencode:draw ()
  (@:help "ѡ����������QR��ά��")
  (if (setq str (text:get-mtext (car (entsel "��ѡ��һ���ı�:"))))
      (progn
	(setq str (text:remove-fmt str))
	(qrencode:make str)
	)
    (princ "not select text"))
  (princ)
  )
(defun qrencode:mkpline(pt col)
  (entmake (list '(0 . "LWPOLYLINE")
		 '(100 . "AcDbEntity")
		 '(100 . "AcDbPolyline")
		 (cons 420 col)
		 (cons 90 2)
		 (cons 10 pt)
		 (cons 10 (polar pt 0 (@:get-config 'qrencode:scale)))
		 (cons 43 (@:get-config 'qrencode:scale))))
  (entlast)
  )
(defun qrencode:make(str / wscript stdout wsreturn outstr pt n k lst ptbase ents pt-ins)
  (if (null (findfile (strcat @:*prefix* "bin\\QRencodeForLisp.exe")))
      (progn
	(@:down-file "bin/QRencodeForLisp.exe")
	(alert "�������� QRencode ,���Ժ�...")
	(sleep 10)
	))
  (setq WScript (vlax-get-or-create-object "WScript.Shell"))
  (setq WSreturn (vlax-invoke WScript 'exec (strcat "\"" @:*prefix* "bin\\QRencodeForLisp.exe\" \"" str "\"")))
  (setq stdout (vlax-get WSreturn 'StdOut))
  (setq outstr (vlax-invoke stdout 'Readall))
  (setq lst(read outstr))
  (if lst
      (progn
	(setq ents nil)
	(setq ptbase (getpoint "�������ά�����λ��:"))
	(setq ents (cons 
		    (entity:make-rectangle (setq pt-ins (polar ptbase (* 0.5 pi) (* (@:get-config 'qrencode:scale) 0.5)))
					   (polar (polar ptbase (* 1.75 pi) (* (@:get-config 'qrencode:scale) (length (car lst)) (sqrt 2.0)))
						  (* 0.5 pi)(* (@:get-config 'qrencode:scale) 0.5)))
		    ents))
	(foreach n lst
		 (setq pt ptbase)
		 (foreach k n
			  (setq ents (cons 
				      (if (= k 1)
					  (qrencode:mkpline pt 0) (qrencode:mkpline pt 16777215))
				      ents))
			  (setq pt (polar pt 0 (@:get-config 'qrencode:scale)))
			  )
		 (setq ptbase(polar ptbase (* pi 1.5) (@:get-config 'qrencode:scale)))
		 )
	(entity:block ents (strcat "qr-" (@:timestamp)) pt-ins)
	;; draw box 
	)
    )
  (princ)
  )
