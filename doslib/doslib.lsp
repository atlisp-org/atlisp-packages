(defun doslib:load (/ vers arxname darx *error* filesize)
  (defun *error* (msg) ;;�����ж���ʾ
    (princ (strcat "\n�������ʧ�ܣ��ļ� " arxname " ȱʧ")) (princ) )
  
  (setq vers (substr (getvar "acadver") 1 2))
  (setq arxname (strcat "DOSLib" vers (if (= (getenv "PROCESSOR_ARCHITECTURE") "AMD64") "x64" "") ".arx")) 
  (if (or(null (findfile arxname)) ;; û�� arx �ļ������С��һ��������
	 (and (setq filesize (@:get-filesize-from-web (strcat "doslib/" arxname)))
	  (< (vl-file-size (strcat @:*prefix* "packages/doslib/" arxname))
	     filesize)))
      (progn
	(@:down-pkg-file (@:uri) (strcat "doslib/" arxname) "stable")
	(prin1 "Download DOSLib support file need long time. Please waitting. ")
	(while (< (vl-file-size (strcat @:*prefix* "packages/doslib/" arxname))
		  filesize)
	  (sleep 5))
	(if (= (vl-file-size (strcat @:*prefix* "packages/doslib/" arxname))
	       filesize)
	    (progn
	      (vl-file-copy (strcat @:*prefix* "packages/doslib/" arxname)
			    (strcat @:*prefix* arxname))
	      ))
	(if (and (setq doslib-arx (findfile arxname)) ;; �� doslib �ļ� 
		 (= (vl-file-size (strcat @:*prefix* "packages/doslib/" arxname))
		    (vl-file-size doslib-arx)))
	    (if (null (member arxname (arx))) ;; ��û����
		(arxload doslib-arx))
	  (progn
	    (vl-file-copy (strcat @:*prefix* "packages/doslib/" arxname)
			  (strcat @:*prefix* arxname))
	    (if (null (member arxname (arx))) ;; ��û����
		(arxload doslib-arx))
	    )))
      (arxload arxname)))
(doslib:load)
