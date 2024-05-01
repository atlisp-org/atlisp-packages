;; ͼ�򼰼ӳ�1 1/4,1/2,3/4,1 1.25 1.5 �Ŀ�߱�
(setq @plot:ratio-of-w/h
      '(1.41429 1.76786 2.12143 2.4750 2.82857 3.18214 3.53571))
(setq @plot:frame-type2
      '("" "+1/4" "+1/2" "+3/4" "+1" "+5/4" "+3/2"))
;; ���ͼ��߶� A4~A0
(setq @plot:height-of-frame
      '(210 297 420 594 841))
(setq @plot:frame-type '("A4" "A3" "A2" "A1" "A0"))

(setq @plot:*frames* '()) ; ͼ��ʶ��������
(@:add-menu "ͨ�ô�ӡ" "����" "(@plot:setup)")
(defun @plot:setup (/ res)
  "ͨ�ô�ӡ������Ϣ"
  (setq res 
	(ui:input "������Ϣ"
		  (mapcar '(lambda (x) (list (strcase (vl-symbol-name (car x)) T)(cadr x)(cddr x)))
			  (vl-remove-if '(lambda (x) (not (wcmatch (vl-symbol-name (car x)) "`@PLOT:*")));;��д
					(if @:*config.db*
					    @:*config.db* (@:load-config))))))
  (foreach res% res
   	   (@:set-config (read (car res%)) (cdr res%)))
  )

(@:add-menu "ͨ�ô�ӡ" "AIʶ��ͼ��" "(@plot:frame-recognition)")
(defun @plot:frame-recognition ()
  (@plot:delete-mark)
  (@plot:frame-recognition-by-polyline)
  ;; (@plot:frame-recognition-by-line)
  (@plot:mark-frames)
  (@:prompt (strcat "AI ��ʶ���� "
		 (itoa (length @plot:*frames*))
		 " ��ͼ��\n"))
  (princ)
  )
(defun @plot:get-frame-type (w h)
  "ʶ��ͼ���С"
  )
(@:add-menu "ͨ�ô�ӡ" "ʶ��PLͼ��" "(@plot:frame-recognition-by-polyline)")
;; 
(defun @:get-rec-points (en0 / ddlist dd1 tmplist )
  "���ɶ���ߵĵ���"
  (setq ddlist nil) 
  (setq tmplist (entget en0))
  (repeat 
   (cdr (assoc 90 (entget en0))) ;;����ڵ���
   (setq dd1 (cdr (assoc 10 tmplist))) ;;ȡ��������
   (setq tmplist (member (assoc 10 tmplist) tmplist))
   (setq tmplist (cdr tmplist))
   (setq ddlist (append ddlist (list dd1) )) ;;��һ������
   )
  )
(defun @plot:init ()
  "ͼ��ʶ���ʼ��"
  (if (tblsearch "layer" "temp-frames")
      T
    (entity:make-layer "temp-frames" 3 "DASHED" nil))
  (layer:plotable '("temp-frames") nil)
  )
(defun @plot:get-height (frame-pts)
  "��ȡͼ��߶�"
  (- (cadr (cadr frame-pts))(cadr (car frame-pts))))
(defun @plot:get-width (frame-pts)
  "��ȡͼ����"
  (- (car (caddr frame-pts))(car (car frame-pts))))
(defun @plot:get-ratio (w h)
  "��ȡͼ���߱�"
  (setq w (float w))
  (setq h (float h))
  (if (/= 0 (min w h))
      (/ (max w h)(min w h))))
(defun @plot:load-config ()
    ;; ���ر�������
  (if (findfile (strcat @:*prefix-config* "frames-scale.db"))
      (setq @plot:scale-of-frame
	    (append @plot:scale-of-frame
		    (vl-remove
		     nil
		     (mapcar 'read 
			     (string:to-lst (@:get-file-contents (strcat @:*prefix-config* "frames-scale.db")) "\n")))))
    )
  (if (findfile (strcat @:*prefix-config* "frames-ratio.db"))
      (setq @plot:ratio-of-w/h
	    (append @plot:ratio-of-w/h
		    (vl-remove nil
			       (mapcar 'read 
				       (string:to-lst (@:get-file-contents (strcat @:*prefix-config* "frames-ratio.db")) "\n")))))
    ))
(defun @plot:frame-length? (len / i j k scale ratio flag-hit)
  "���Գ����Ƿ����ͼ��Ҫ��"
  (setq @plot:scale-of-frame
	(mapcar 'atof
		(string:parse-by-lst (@:get-config '@plot:scale-of-frame) '("," " "))))
  ;; ���ر�������
  (@plot:load-config)
  (setq flag-hit nil)
  (setq i 0)
  ;;��С����ж�
  (if (< (* (apply 'min @plot:height-of-frame)
	    (apply 'min @plot:scale-of-frame))
	 len 
	 (* (apply 'max @plot:height-of-frame)
	    (apply 'max @plot:scale-of-frame)
	    (apply 'max @plot:ratio-of-w/h)))
      (while (and (null flag-hit)
		  (< i (length @plot:height-of-frame)))
	(setq j 0)
	(while (and (null flag-hit)
		    (< j (length @plot:scale-of-frame)))
	  (if (equal len
		     (* (nth i @plot:height-of-frame)
			(nth j @plot:scale-of-frame))
		     (* 0.001 len))
	      (setq flag-hit T)    
	    (progn 
	      (setq k 0) 
	      (while (and (null flag-hit)
			  (< k (length @plot:ratio-of-w/h)))
		(if (equal len
			   (* (nth i @plot:height-of-frame)
			      (nth j @plot:scale-of-frame)
			      (nth k @plot:ratio-of-w/h))
			   (* 0.0019 len))
		    (setq flag-hit T))
		
	    (setq k (1+ k))
	    )))
	  (setq j (1+ j)))
	(setq i (1+ i))))
  flag-hit)
;;(princ "test\n")
(defun @plot:framep (frame-pts / test-ratio height flag-hit i j)
  "�����Ƿ�����ͼ�����ݾ��θ߶ȺͿ�߱ȣ�"
  (if (>= (length frame-pts) 4)
      (progn
	(setq @plot:scale-of-frame
	      (mapcar 'atof
		      (string:parse-by-lst (@:get-config '@plot:scale-of-frame) '("," " "))))
	(@plot:load-config)
	(setq frame-pts
	      (vl-sort
	       frame-pts
	       '(lambda (pt1 pt2)
		 (or (< (car pt1)(car pt2))
		  (and (equal (car pt1)(car pt2) 0.001)
		   (< (cadr pt1)(cadr pt2)))))))
	(setq flag-hit nil)
	(setq test-ratio nil)
	;;���͵� 1 3 �� y ֵ�Ƿ�һ��
	(if (equal (car (car frame-pts))
	     (car (cadr frame-pts))
	     0.001)
	    (progn
	      (setq height (min (@plot:get-height frame-pts)
				(@plot:get-width frame-pts)))
	      ;; ���Գ����
	      (setq i 0)
	      (while (and (null test-ratio)
			  (< i (length @plot:ratio-of-w/h)))
		(if (equal (@plot:get-ratio (@plot:get-height frame-pts)
					    (@plot:get-width frame-pts))
			   (nth i @plot:ratio-of-w/h)
			   0.002)
		    (setq test-ratio T))
		(setq i (1+ i)))))
	;; ���Ը߶�
	(if test-ratio
      (progn
	(setq flag-hit nil)
	(foreach
	 h
	 @plot:height-of-frame
	 (foreach
	  scale @plot:scale-of-frame
	  (if (equal height
		     (* h scale)
		     (* 0.001 height))
	      (setq flag-hit T))
	  ))))
	flag-hit)))
(defun @plot:frame-recognition-by-polyline (/ frames total)
  "ʶ�����߾���ͼ��"
  ;; ʶ������
  ;; (@:help (strcat "ʶ�����߾���ͼ��"))
  (setq total (length @plot:*frames*))
  (if (setq frames (ssget "x" (list '(0 . "*POLYLINE")
				    '(90 . 4)
				    '(70 . 1)
				    '(60 . 0)
				    (cons 8 (@:get-config '@plot:layers))
				    '(-4 . "<NOT")
				    '(8 . "temp-frames")
				    '(-4 . "NOT>"))
			  ))
      (progn
	(setq frames (pickset:to-list frames))
	;; ȥ���Ǿ���
	(setq frames (mapcar
		      '(lambda (x) (cons (@:get-rec-points x)(entity:getdxf x 410)))
		      frames))
	(setq frames (vl-remove-if-not
		      '(lambda (y / x)
			 (setq x (car y))
			 (and 
			  (equal (distance (car x)(caddr x))
				 (distance (cadr x)(cadddr x))
				 (* 0.001 (distance (car x)(caddr x))))
			  (/= (distance (car x)(caddr x))
			      (@plot:get-width x))
			  (/= (distance (car x)(caddr x))
			      (@plot:get-height x))
			  ))
		      frames))
	;; (print frames)
	(setq frames
	      (vl-remove-if-not
	       '(lambda (y / x)
		  (setq x (car y))
		  (@plot:framep x))
	       (mapcar '(lambda (y / x)
			  ;; ��������
			  (setq x (car y))
			  (cons 
			   (vl-sort 
			    x
			    '(lambda (pt1 pt2)
			       (if (and (equal (car pt1)(car pt2) 0.001)
					(< (cadr pt1)(cadr pt2)))
				   T
				 (if (< (car pt1)(car pt2))
				    T
				   nil))
			       ))
			   (cdr y)
			   ))
		       frames)))
	(setq @plot:*frames* frames)
	(@:prompt (strcat "ʶ���� "
			  (itoa (-(length @plot:*frames*)
				  total))
			  " ������߾���ͼ��\n"))))
  (princ)
  )

(@:add-menu "ͨ�ô�ӡ" "ʶ��ֱ�߿�" "(@plot:frame-recognition-by-line)")
(defun @plot:frame-lines? (bm tp lt rt / fuzz)
  "����4���߶��Ƿ�Ϊ���ο�"
  (setq fuzz 0.01)
  (and
   (equal (car (line:mid bm)) (car (line:mid tp)) fuzz)
   (equal (cadr (line:mid lt)) (cadr (line:mid rt)) fuzz)
   (> fuzz (distance
	    (polar (line:mid bm)
		   (* 0.5 pi)
		   (* 0.5 (distance (line:mid bm)(line:mid tp))))
	    (polar (line:mid lt)
		   0
		   (* 0.5 (distance (line:mid lt)(line:mid rt))))))
   (equal (line:length bm) (line:length tp) fuzz)
   (equal (line:length lt) (line:length rt) fuzz)
   (equal (distance (line:mid lt) (line:mid rt))
    	  (line:length bm)
	  fuzz)
   (equal (distance (line:mid bm) (line:mid tp))
    	  (line:length lt)
	  fuzz)
   ;; ;; ��߱�
   (@plot:framep (vl-sort 
    		  (append (entity:getdxf bm '(10 11))
			  (entity:getdxf tp '(10 11)))
		  '(lambda (pt1 pt2)
		     (or (< (car pt1)(car pt2))
			 (and (equal  (car pt1)(car pt2) 0.001)
			      (< (cadr pt1)(cadr pt2)))))))
   ))
(defun @plot:frame-recognition-by-line
    (/ frames segments frame-length?
       seg-v seg-h ent-first frame got-tk
       total frame-pts
       )
  "ʶ����4���߶���ɵľ���ͼ��"
  ;; ʶ������
  (@:log "INFO" "ѡ���ų�����...")
  (std:timer-start)
  (setq total (length @plot:*frames*))
  (setq segments (pickset:to-list
		  (ssget "x" (list '(0 . "LINE")
				   (cons 8 (@:get-config '@plot:layers))
				   '(-4 . "<NOT")
				   '(8 . "temp-frames")
				   '(-4 . "NOT>")))))
  (@:log "INFO" (strcat "���� " (itoa(length segments)) "���ߡ�"))
 
  (setq segments (vl-remove-if-not
		  '(lambda (x)(@plot:frame-length? (line:length x)))
		  segments))
  (@:log "INFO" (strcat (itoa (length segments)) "���߷���ͼ��ߴ硣"))
  (@:log "INFO" "���ڷ���߿���...\n")
  (setq seg-h (vl-remove-if-not
	       '(lambda (x / ang)
		  (setq ang (apply 'angle (entity:getdxf x '(10 11))))
		  (while (>= ang pi)
		    (setq ang (- ang pi)))
		  (or 
		   (equal ang  0 0.001)
		   (equal ang  pi 0.001)))
	       segments))
  
  (@:log "INFO" (strcat "seg-h: "(itoa (length seg-h)) ))
  (@:log "INFO" "���ڽ��б߿�������...")
  (setq seg-h
	(vl-sort seg-h
		 '(lambda (ent1 ent2) (< (cadr (entity:getdxf ent1 10))
				       (cadr (entity:getdxf ent2 10))))))
  ;; (setq seg-v
  ;; 	(vl-sort seg-v
  ;; 		 '(lambda (ent1 ent2) (< (car (entity:getdxf ent1 10))
  ;; 				       (car (entity:getdxf ent2 10))))))
  (@:log "INFO" "��ֱ��ͼԪ��ʶ����ο�\n")
  (setq bm% 0)(setq got-tk nil)
  (while  (< bm% (- (length seg-h) 1))
    (setq tp% (1+ bm%))
    (while  (< tp% (length seg-h))
      ;; �� seg-v ��ȡ��ӦͼԪ���ӱ����Ƴ�
      ;; ��� bm% tp% �������Ƿ����ͼ��Ҫ��
      (if (@plot:framep
	   (append
	    (entity:getdxf (nth bm% seg-h) '(10 11))
	    (entity:getdxf (nth tp% seg-h) '(10 11))))
	  (progn
	    (setq got-tk T)
	    (setq frame (list (nth bm% seg-h)
			      (nth tp% seg-h)
			      ))
	    (setq frame-pts 
		  (vl-sort 
		   (append (entity:getdxf (car frame) '(10 11))
				 (entity:getdxf (cadr frame) '(10 11)))
		   '(lambda (pt1 pt2)
		      (or (< (car pt1)(car pt2))
			  (and (equal (car pt1)(car pt2) 0.001)
			       (< (cadr pt1)(cadr pt2)))))))
	    ;; ��֤��ˮƽ�ߡ�
	    (setq seg-v1 
		  (ssget "F" (entity:getdxf (car frame) '(10 11))
			 ;;frame-pts
			 (list '(0 . "LINE")
			       (cons 8 (@:get-config '@plot:layers))
			       '(-4 . "<NOT")
			       '(8 . "temp-frames")
			       '(-4 . "NOT>"))))
	    (if (= 'pickset (type seg-v1))
		(progn
		  (setq  seg-v1
			 (vl-remove-if-not
			  '(lambda (x / ang)
			     (setq ang (apply 'angle (entity:getdxf x '(10 11))))
			     (while (>= ang pi)
			       (setq ang (- ang pi)))
			     (equal ang (* 0.5 pi) 0.001))
			  (pickset:to-list seg-v1)))
		  (if (and seg-v1 (>= (length seg-v1) 2)
			   )
		      (setq @plot:*frames*
			    (append @plot:*frames* (list (cons frame-pts  (entity:getdxf (car seg-v1) 410)) )))
		  
		    ))))
	)
      (setq tp% (1+ tp%)))
    (setq bm% (1+ bm%))
    )
  (princ "\n")
  (@:prompt (strcat "ʶ���� "
		    (itoa (-(length @plot:*frames*)
			    total))
		    " ��ֱ��ͼ��"))
  (std:timer-end)
  (princ)
  )

(@:add-menu "ͨ�ô�ӡ" "ʶ���ͼ��" "(@plot:frame-recognition-by-block)")

(defun @plot:frame-recognition-by-block ()
  (setq blknames (block:list))
  (setq frameblknames (vl-remove-if-not
		       '(lambda(x) (@pm:frame-p x))
		       blknames))
  (setq frameblkrefs
	(ssget "x" (list '(0 . "insert")
			 (cons 2 (string:subst-all "`*" "*" (string:from-list frameblknames ","))))))

  (sssetfirst nil frameblkrefs)
  )

