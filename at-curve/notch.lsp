;; ֱ�߿�ȱ��

;; ѡ��ʼֱ��L��ֱ�߶˵�Ĵ�ֱ�� L2.
;; L �˵�����pt-l , L2 ���Ϊ������pta-l2~pt-a, pt-b~ptb-l2.
;; ���� pt-l~pt-a,pt-l~pt-b
;; TODO: ��ɫ ͼ�� ���ͣ���� ͬԭ��
(@:define-config '@curve:notch-type 0 "����ȱ�ڵ�Ĭ�����ͣ�0 Ш�Σ�1 Բ��")
(@:define-config '@curve:notch-width 100 "����ȱ�ڵ�Ĭ�Ͽ��")
(@:define-config '@curve:notch-height 40 "����ȱ�ڵ�Ĭ�����")


(defun at-curve:notch (/ args)
  (@:help '("�ڶ����߽��㴦����ȱ�ڡ�"))
  (if (setq args (ui:input
	      "ȱ�ڲ���"
	      (list
	       (list "ȱ�ڿ��" (@:get-config '@curve:notch-width))
	       (list "ȱ�����" (@:get-config '@curve:notch-height)))))
  (progn
    (setq width (cdr (assoc "ȱ�ڿ��" args)))
    (setq height (cdr (assoc "ȱ�����" args)))
    (@:set-config '@curve:notch-width width)
    (@:set-config '@curve:notch-height height)
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
				       height))
		 (setq ss (ssdel line% ss))
		 (setq l2 (ssname ss 0))
		 (entity:make-line
		  (entity:getdxf l2 10)
		  (polar pt-a
			 (angle pt-a (entity:getdxf l2 10))
			 (* 0.5 width)))
		 (entity:make-line
		  (entity:getdxf l2 11)
		  (polar pt-a
			 (angle pt-a (entity:getdxf l2 11))
			 (* 0.5 width)))
		 (entity:make-line
		  (polar pt-a
			 (angle pt-a (entity:getdxf l2 10))
			 (* 0.5 width))
		  (polar pt-a
			 (angle pt-a pt-b)
			 height))
		 (entity:make-line
		  (polar pt-a
			 (angle pt-a (entity:getdxf l2 11))
			 (* 0.5 width))
		  (polar pt-a
			 (angle pt-a pt-b)
			 height))
		 (entdel l2)
		 ))
	   ;; pt-b
	   (if (> (sslength (setq ss (ssget "c" pt-b pt-b '((0 . "line"))))) 1)
	       (progn
		 (entity:putdxf line% 11
				(polar pt-b
				       (angle pt-b pt-a)
				       height))
		 (setq ss (ssdel line% ss))
		 (setq l2 (ssname ss 0))
		 (entity:make-line
		  (entity:getdxf l2 10)
		  (polar pt-b
			 (angle pt-b (entity:getdxf l2 10))
			 (* 0.5 width)))
		 (entity:make-line
		  (entity:getdxf l2 11)
		  (polar pt-b
			 (angle pt-b (entity:getdxf l2 11))
			 (* 0.5 width)))
		 (entity:make-line
		  (polar pt-b
			 (angle pt-b (entity:getdxf l2 10))
			 (* 0.5 width))
		  (polar pt-b
			 (angle pt-b pt-a)
			 height))
		 (entity:make-line
		  (polar pt-b
			 (angle pt-b (entity:getdxf l2 11))
			 (* 0.5 width))
		  (polar pt-b
			 (angle pt-b pt-a)
			 height))
		 (entdel l2)
		 ))
	   )))
  )
			
		    
