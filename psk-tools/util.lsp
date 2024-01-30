;; PSK��չ����

;; ��������ϵ�������չ����
(defun xdata-clear (/ ss)
  (princ "\nѡ��Ҫ�����չ���ݵĶ���:")
  (if (setq ss (ssget))
    (progn
      (foreach en (p-ss->enames ss)
	(p-xdata-remove en "*")
      )
    )
  )
)
;; ƥ����չ����
(defun xdata-match (/ en ss xdata)
  (if (and (setq en (car (entsel "\nѡ��Դ����:")))
	   (princ "\nѡ��Ҫƥ����չ���ݵĶ���:")
	   (setq ss (ssget))
      )
    (progn
      (setq xdata (p-xdata-get-inner en "*"))
      (foreach en (p-ss->enames ss)
	(p-xdata-set-inner en xdata)
      )
    )
  )
)
;; ɾ��APPIDΪ"PSK-PATH"�е�ָ������"FRIC"
(defun prop-clear (/ ss)
  (princ "\nѡ��Ҫɾ�����ԵĶ���:")
  (if (setq ss (ssget))
    (progn
      (foreach en (p-ss->enames ss)
	(p-xprop-remove en "PSK-PATH" "FRIC")
      )
    )
  )
)
;; ����ֱͨ��ת��Ϊ"PSK-PATH"����
(defun convert-path (/ ss)
  (princ "\nѡ��Ҫת��Ϊ·���Ķ���:")
  (if (setq ss (ssget '((0 . "LINE"))))
    (progn
      (foreach en (p-ss->enames ss)
	(p-xprop-set
	  en
	  "PSK-PATH"
	  '(
	    (".TYPE" . "PIPE")
	   )
	)
      )
    )
  )
)

(defun exportprop ()
  (setq file (open "C:/1.csv" "w"))
  (foreach e $psk-prop-defination
    (write-line
      (strcat (car e) "," (itoa (cadr e)) "," (caddr e) "," (cadddr e))
      file
    )
  )
  (close file)
)
;;

;; �������ö��������
;;;(setprop '(lambda (en) (p-xprop-set en "PSK-PART" '("FLR" . 500))))
;;;(setprop '(lambda (en) (p-xprop-set en "PSK-EQUIP" '("CLD" . 4.3))))
(defun setprop (fun)
  (if (setq ss (ssget))
    (progn
      (foreach en (p-ss->enames ss)
	(apply fun (list en))
      )
    )
  )
)
;; ����ת�����ʣ����ڰ汾 0.60ǰ�ľ�ͼת����
(defun convertserv ()
  (if (setq ss (ssget))
    (progn
      (foreach en (p-ss->enames ss)
	(if (setq serv (p-get '(("S" . "SA")
				("H" . "RA")
				("X" . "OA")
				("P" . "EA")
				("RS" . "RS")
				("RP" . "RP")
				("PY" . "SE")
				("JY" . "PS")
				("XB" . "MA")
				("P(Y)" . "EA(SE)")
				("S(B)" . "SA(MA)")
			       )
			      (psk-comp-get en "SERV")
		       )
	    )
	  (psk-comp-set en (cons "SERV" serv))
	)
      )
    )
  )
)

;; �����为��
(defun psk-cld-total (/ tot)
  (setq tot 0.)
  (if (setq ss (ssget))
    (progn
      (foreach en (p-ss->enames ss)
	(setq tot (+ tot (p-xprop-get en "PSK-EQUIP" "CLD")))
      )
    )
  )
  (princ tot)
)




;; ���߸������� 2021-4-1
(defun p-groupby (ents sortby / e lst p r)
  (setq	ents (mapcar (function (lambda (e) (list (p-dxf e sortby) e)))
		     ents
	     )
	ents (vl-sort
	       ents
	       (function
		 (lambda (e1 e2) (< (car e1) (car e2)))
	       )
	     )
  )
  ;;  ����
  (while ents
    (setq e (car ents)
	  p (car e)
    )
    (while (equal (car e) p)
      (setq lst	 (cons (cadr e) lst) ;_ ����ͬ��ϲ�
	    ents (cdr ents)
	    e	 (car ents)
      )
    )
    (setq r   (cons (cons p lst) r)
	  lst nil
    )
  )
  r
)
;; ����ֱ�����Ӵ��
;;;(mt-line-interbreak (car (entsel)) (car (entsel)))
(defun mt-line-interbreak (line1 line2 / p)
  (if (and (not (equal line1 line2))
	   (setq p (p-line-getinters line1 line2))
      )
    (progn
      (psk-line-breakat line1 p)
      (psk-line-breakat line2 p)
    )
  )
)
;; ѡ��һ��ֱ�ߣ���ͼ����飬���ÿ��ͼ���е�ֱ�����������Ը���ֱ�߽������Ӵ�ϲ���
(defun mt-lines-interbreak (/ ents)
  (princ "\nѡ��Ҫ���Ӵ�ϵ�ֱ��:")
  (if (setq ents (ssget))
    (progn
      (setq ents (p-ss->enames ents)
	    ents (p-groupby ents 8)
      )

      (foreach lines ents
	(setq lines (cdr lines))
	(if (= (length lines) 2)
	  (progn
	    (mt-line-interbreak (car lines) (cadr lines))
	  )
	)
      )
    )
  )
)

;;;(defun c:p2 ()
;;;  (setq p1 (getpoint "\n1:"))
;;;  (setq p2 (getpoint "\n2:"))
;;;  (p-clipboard-set
;;;    (vl-prin1-to-string
;;;      (list (vl-filename-base (getvar 'dwgname))
;;;	    (list "REF" p1 '(1 0 0) 0)
;;;	    (list "CD" p2 '(1 0 0) 0)
;;;      )
;;;    )
;;;  )
;;;)


(defun c:bb (/)
  (p-commandrun '(mt-lines-interbreak))
)
(defun c:xclear	(/)
  (p-commandrun '(xdata-clear))
)
(defun c:xma (/)
  (p-commandrun '(xdata-match))
)
(defun c:convertpath (/)
  (p-commandrun '(convert-path))
)

(defun c:cldtot (/)
  (p-commandrun '(psk-cld-total))
)

;; ���Խ�����ʾ
;;;(defun run (/ r)
;;;  (pdb-list-clear "LIST")
;;;  (setq r 0)
;;;  (repeat 300000
;;;    (setq r (1+ r))
;;;
;;;    (if	(= 0 (rem r 10000))
;;;      (progn
;;;	(pdb-list-append "LIST" (itoa r))
;;;	(pdb-list-select "LIST" (1- (/ r 10000)))
;;;      )
;;;    )
;;;  )
;;;)
;;;
;;;(defun progress	(/ id r)
;;;  (if (and (>= (setq id (load_dialog (psk-get-filename "\\dialogs.dcl"))) 0)
;;;	   (new_dialog "progressDlg" id)
;;;      )
;;;    (progn
;;;      (action_tile "OK" "(run)")
;;;
;;;      (start_dialog)
;;;      (done_dialog 1)
;;;      (unload_dialog id)
;;;    )
;;;  )
;;;)

;;;(defun psk-create-ductvert (name p1 w h /)
;;;  (command
;;;    "._insert"
;;;    (psk-get-filename (strcat "\\dwg\\" name ".dwg"))
;;;    "NON"
;;;    p1
;;;    w
;;;    h
;;;    0.
;;;  )
;;;)
;;;(defun sav (name / h p1 w)
;;;  (if (and (setq p1 (getpoint "\nָ�������:"))
;;;           (setq w (p-edit-value "������" 1600.))
;;;           (setq h (p-edit-value "����߶�" 400.))
;;;      )
;;;    (psk-create-ductvert name p1 w h)
;;;  )
;;;)
;;;(defun c:sav (/ h p1 w)
;;;  (sav "SAD-V")
;;;)
;;;(defun c:rav (/ h p1 w)
;;;  (sav "RAD-V")
;;;)


;; (psk-csvfile-get "sizes/flange pn.csv" "FL-PL-2.5-15")
;; (("Name" . "FL-PL-2.5-15") ("OD" . 80.0) ("BLTD" . 55.0) ("BLTH" . 11.0) ("BLTN" . "M10") ("BLTA" . 4.0) ("L" . 12.0))
(defun psk-csvfile-get (filename key / csv)
  (if (setq csv (p-csvfile-readcache (psk-get-filename filename) '$psk-csvread-cache))
;;;    (progn
;;;      (setq prop (p-csvread-get1 csv key))
;;;      (p-get1 prop names)
;;;    )
    (p-csvread-get1 csv key)
  )
)

;;(vlax-ldata-put "PSK" "CREATEVALUELAST" nil)


;; �رշ�����ͼ��
(defun psk-ductlayeroff	()
  (command "._-LAYER" "OFF" "M-*��*,M-*��*" "")
)
;; �򿪷�����ͼ��
(defun psk-ductlayeron	()
  (command "._-LAYER" "ON" "M-*��*,M-*��*" "")
)