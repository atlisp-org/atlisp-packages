;; ֱ�߿�ȱ��

;; ѡ��ʼֱ��L��ֱ�߶˵�Ĵ�ֱ�� L2.
;; L �˵�����pt-l , L2 ���Ϊ������pta-l2~pt-a, pt-b~ptb-l2.
;; ���� pt-l~pt-a,pt-l~pt-b
(defun at-curve:notch ()
  (setq lst-line (pickset:to-list (ssget '((0 . "line")))))
  (foreach line% lst-line
	   (setq pts (curve:get-points line%))
	   ;; pt-a
	   (setq pt-a (car pts))
	   (setq pt-b (cadr pts))
	   (if (> (sslength (setq ss (ssget "c" pt-a pt-a '((0 . "line"))))) 1)
	       (progn
		 (entity:putdxf line% 10
				(polar pt-a
				       (angle pt-a pt-b)
				       50))
		 (setq ss (ssdel line% ss))
		 (setq l2 (ssname ss 0))
		 (entity:make-line
		  (entity:getdxf l2 10)
		  (polar pt-a
			 (angle pt-a (entity:getdxf l2 10))
			 40))
		 (entity:make-line
		  (entity:getdxf l2 11)
		  (polar pt-a
			 (angle pt-a (entity:getdxf l2 11))
			 40))
		 (entity:make-line
		  (polar pt-a
			 (angle pt-a (entity:getdxf l2 10))
			 40)
		  (polar pt-a
			 (angle pt-a pt-b)
			 50))
		 (entity:make-line
		  (polar pt-a
			 (angle pt-a (entity:getdxf l2 11))
			 40)
		  (polar pt-a
			 (angle pt-a pt-b)
			 50))
		 (entdel l2)
		 ))
	   ;; pt-b
	   (if (> (sslength (setq ss (ssget "c" pt-b pt-b '((0 . "line"))))) 1)
	       (progn
		 (entity:putdxf line% 11
				(polar pt-b
				       (angle pt-b pt-a)
				       50))
		 (setq ss (ssdel line% ss))
		 (setq l2 (ssname ss 0))
		 (entity:make-line
		  (entity:getdxf l2 10)
		  (polar pt-b
			 (angle pt-b (entity:getdxf l2 10))
			 40))
		 (entity:make-line
		  (entity:getdxf l2 11)
		  (polar pt-b
			 (angle pt-b (entity:getdxf l2 11))
			 40))
		 (entity:make-line
		  (polar pt-b
			 (angle pt-b (entity:getdxf l2 10))
			 40)
		  (polar pt-b
			 (angle pt-b pt-a)
			 50))
		 (entity:make-line
		  (polar pt-b
			 (angle pt-b (entity:getdxf l2 11))
			 40)
		  (polar pt-b
			 (angle pt-b pt-a)
			 50))
		 (entdel l2)
		 ))
	   ))
			
		    
