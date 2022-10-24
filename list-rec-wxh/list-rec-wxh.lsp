;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'list-rec-wxh:first ���� Ӧ�ð� list-rec-wxh �� ��һ�������� first 
;; (@:get-config 'list-rec-wxh:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'list-rec-wxh:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "ͳ��" "����ͳ�Ʊ�" "(list-rec-wxh:draw)" )
(@:add-menu "ͳ��" "���η�ɫ" "(list-rec-wxh:stat)" )

(defun @:get-lwpoints (en0 / ddlist dd1 tmplist )
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
(defun list-rec-wxh:get-wxh (ent / pts result-pts tmp-pts angle% area% i%)
  "��ȡ��͸ߵ��б�"
  (setq pts (@:get-lwpoints ent))
  ;; ����任ֱ�������С
  (setq i% 0)
  (setq tmp-pts pts)
  (setq result-pts pts)
  (setq area% (* (- (apply 'max (mapcar 'car pts))
		    (apply 'min (mapcar 'car pts))
		    )
		 (- (apply 'max (mapcar 'cadr pts))
		    (apply 'min (mapcar 'cadr pts))
		    )))
  (while (< i% 3)
    (setq angle% (- (angle (nth i% pts)(nth (1+ i%) pts))))
    (setq tmp-pts (mapcar '(lambda (x) (m:coordinate-rotate x angle%)) pts))
    (if  (> area% (* (- (apply 'max (mapcar 'car tmp-pts))
			(apply 'min (mapcar 'car tmp-pts))
			)
		     (- (apply 'max (mapcar 'cadr tmp-pts))
			(apply 'min (mapcar 'cadr tmp-pts))
			)))
	 (progn
	   (setq result-pts tmp-pts)
	   (setq area%  (* (- (apply 'max (mapcar 'car tmp-pts))
			      (apply 'min (mapcar 'car tmp-pts))
			      )
			   (- (apply 'max (mapcar 'cadr tmp-pts))
			      (apply 'min (mapcar 'cadr tmp-pts))
			      )))))
    (setq i% (1+ i%)))
  
  (strcat (rtos (min (- (apply 'max (mapcar 'car result-pts))
			(apply 'min (mapcar 'car result-pts))
			)
		     (- (apply 'max (mapcar 'cadr result-pts))
			(apply 'min (mapcar 'cadr result-pts))
			))
		2 2)
	  "x"
	  (rtos (max (- (apply 'max (mapcar 'car result-pts))
			(apply 'min (mapcar 'car result-pts))
			)
		     (- (apply 'max (mapcar 'cadr result-pts))
			(apply 'min (mapcar 'cadr result-pts))
			))
		2 2))
  )

(defun list-rec-wxh:stat (/ ents recs result-stat res% )
  (@:help (strcat "ͳ����Բ�ǻ򵹽ǵľ��εĳ���������ɫ����"))
  (setq ents (pickset:to-list
	      (ssget '((0 . "LWPOLYLINE")
			(-4  . "<AND")
			(-4 . ">=")(90 . 4)
			(-4 . "<=")(90 . 8)
			(-4 . "AND>")))))
  (setq result-stat
	(vl-sort (stat:stat (mapcar 'list-rec-wxh:get-wxh ents))
		 '(lambda (x y)(> (cdr x)(cdr y)))))
	
  
  (foreach ent% ents
	   (setq res% (list-rec-wxh:get-wxh ent%))
	   (if (> (cdr (assoc res% result-stat)) 1)
	       (entity:putdxf ent% 62 (1+ (vl-position (assoc res% result-stat) result-stat)))))
  result-stat
  )
(defun list-rec-wxh:draw ( / recs en% en0 pts pt1 i% tmp-pts result-pts area% angle%)
  (@:help (strcat "ͳ����Բ�ǻ򵹽ǵľ��εĳ���,�������б�"))
  (setq recs (ssget '((0 . "LWPOLYLINE")
		      (-4  . "<AND")
		      (-4 . ">=")(90 . 4)
		      (-4 . "<=")(90 . 8)
		      (-4 . "AND>"))))
  (setq en% 0)
  (setq pt1 (getpoint "���ȡ�б�λ��: "))
  (entity:make-text 
   (format nil "rectang   width               height  ~%")
   pt1 3.5 0 0.8 0 13)
  (while (< en% (sslength recs))
    (setq en0 (ssname recs en%))
    (setq pts (@:get-lwpoints en0))
    ;; ����任ֱ�������С
    (setq i% 0)
    (setq tmp-pts pts)
    (setq result-pts pts)
    (setq area% (* (- (apply 'max (mapcar 'car pts))
		      (apply 'min (mapcar 'car pts))
		      )
		   (- (apply 'max (mapcar 'cadr pts))
		      (apply 'min (mapcar 'cadr pts))
		      )))
    (while (< i% 3)
      (setq angle% (- (angle (nth i% pts)(nth (1+ i%) pts))))
      (setq tmp-pts (mapcar '(lambda (x) (m:coordinate-rotate x angle%)) pts))
      (if  (> area% (* (- (apply 'max (mapcar 'car tmp-pts))
			  (apply 'min (mapcar 'car tmp-pts))
			  )
		       (- (apply 'max (mapcar 'cadr tmp-pts))
			  (apply 'min (mapcar 'cadr tmp-pts))
			  )))
	   (progn
	     (setq result-pts tmp-pts)
	     (setq area%  (* (- (apply 'max (mapcar 'car tmp-pts))
				(apply 'min (mapcar 'car tmp-pts))
				)
			     (- (apply 'max (mapcar 'cadr tmp-pts))
				(apply 'min (mapcar 'cadr tmp-pts))
				)))))
      (setq i% (1+ i%)))
      
    (entity:make-text 
     (format nil " ~d   ~15f  ~15f ~%"
	     (1+ en%)
	     (min (- (apply 'max (mapcar 'car result-pts))
		     (apply 'min (mapcar 'car result-pts))
		     )
		  (- (apply 'max (mapcar 'cadr result-pts))
		     (apply 'min (mapcar 'cadr result-pts))
		     ))
	     (max (- (apply 'max (mapcar 'car result-pts))
		     (apply 'min (mapcar 'car result-pts))
		     )
		  (- (apply 'max (mapcar 'cadr result-pts))
		     (apply 'min (mapcar 'cadr result-pts))
		     ))
	     )
     (polar pt1 (* 1.5 pi) (* (1+ en%) 5)) 3.5 0 0.8 0 13)
    (entity:make-leader (nth 0 pts) (polar pt1 (* 1.5 pi) (* (1+ en%) 5)))
    (setq en% (1+ en%))
    ))

;; hotkey  
(defun C:TJJX () (list-rec-wxh:draw))
