(defun @:load-opendcl ()
  (setq ODCLREG (strcat "HKEY_LOCAL_MACHINE\\" (vlax-product-key)
			"\\Applications\\OpenDCL"))
  (if (null dcl_getversionex)  ;;�ж� OPEDCL �����Ƿ����
      (if (setq odcl-full (vl-registry-read ODCLREG "Loader")) ;;ODCL �Ƿ�װ
	  (progn
            (arxload odcl-full)
            (setq ODCLREG nil odcl-full nil)
	    )
	  (progn  ;;��� OPENDCL û�а�װ������ arx �ļ��Ƿ����
	    (defun Load_OdclRuntime (/ vers arxname darx *error* filesize)
              (defun *error* (msg) ;;�����ж���ʾ
		(princ (strcat "\n�������ʧ�ܣ��ļ� " arxname " ȱʧ")) (princ) )
              (setq vers (substr (getvar "acadver") 1 2))
              (setq arxname (strcat "OpenDCL." (if (= (getenv "PROCESSOR_ARCHITECTURE") "AMD64") "x64." "") vers ".arx"))  ;;���� CAD λ
	      (setq filesize (@:get-filesize-from-web (strcat "opendcl/" arxname)))
	      (if (or (null (findfile arxname)) ;; û�� arx �ļ���������
		      (< (vl-file-size (strcat @:*prefix* "packages/opendcl/" arxname))
			 filesize)
		      (< (vl-file-size (findfile arxname))
			 filesize))
		  (progn
		    (@:down-pkg-file (@:uri) (strcat "opendcl/" arxname) "stable")
		    (if (member (getvar "locale") '("CHS" "DEU" "ENU" "ESM" "FRA" "RUS" "ZH"))
			(@:down-pkg-file (@:uri) (strcat "opendcl/" (getvar "locale") "/Runtime.Res.dll") "stable")
			(@:down-pkg-file (@:uri) (strcat "opendcl/ENU/Runtime.Res.dll") "stable"))
		    (alert "Download OpenDCL support file need long time. Please waitting. ")
		    (while (< (vl-file-size (strcat @:*prefix* "packages/opendcl/" arxname))
			      filesize)
		      (sleep 5))
		    (if (= (vl-file-size (strcat @:*prefix* "packages/opendcl/" arxname))
			   filesize)
			(progn
			  (vl-file-copy (strcat @:*prefix* "packages/opendcl/" arxname)
					(strcat @:*prefix* arxname))
			  (if (member (getvar "locale") '("CHS" "DEU" "ENU" "ESM" "FRA" "RUS" "ZH"))
			      (vl-file-copy (strcat @:*prefix* "packages/opendcl/" (getvar "locale") "/Runtime.Res.dll")
					    (strcat @:*prefix* "Runtime.Res.dll"))
			      (vl-file-copy (strcat @:*prefix* "packages/opendcl/ENU/Runtime.Res.dll")
					    (strcat @:*prefix* "Runtime.Res.dll")))))
		    ))
	      (if (and (setq odcl-arx (findfile arxname)) ;; �� opendcl �ļ� 
		       (= (vl-file-size (strcat @:*prefix* "packages/opendcl/" arxname))
			  (vl-file-size odcl-arx)))
		  (if (null (member arxname (arx))) ;; ��û����
		      (arxload odcl-arx))
		  (progn
		    (vl-file-copy (strcat @:*prefix* "packages/opendcl/" arxname)
				  (strcat @:*prefix* arxname))
		    (if (member (getvar "locale") '("CHS" "DEU" "ENU" "ESM" "FRA" "RUS" "ZH"))
			(vl-file-copy (strcat @:*prefix* "packages/opendcl/" (getvar "locale") "/Runtime.Res.dll")
				      (strcat @:*prefix* "Runtime.Res.dll"))
			(vl-file-copy (strcat @:*prefix* "packages/opendcl/ENU/Runtime.Res.dll")
				      (strcat @:*prefix* "Runtime.Res.dll"))))))
            (Load_OdclRuntime) ;;���м��غ���
            (setq Load_OdclRuntime nil) ;;�ͷż��غ���
	    )
	  )
      );;The End of Load ODCL
  )
(@:load-opendcl)
