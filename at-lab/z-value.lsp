(@:add-menu "@������" "���ָ�z" '(at-lab:set-z))
(@:define-config '@lab:zblkname "A$C*" "׮������֧��ͨ���")
(defun at-lab:set-z ()
  ;; 1��ѡ������ ����̨����*" ���֣�ȡ���ֵ��
  (@:prompt "���ѡ��̨��������")
  (setq lst-txtz(pickset:to-list (ssget '((0 . "text")(1 . "��̨����*")))))
  (foreach
   txtz lst-txtz
   ;; ȡ���ֵ
   (setq value-z (last (string:auto-split (entity:getdxf txtz 1))))
   ;; 2��������ͼԪ�²�һ����Χ�� A$C* ���ƵĿ顣�������ֿ��²������������� һ���ĸ߶ȷ�Χ��
   (setq pt-lb (car (entity:getbox txtz 0)))
   (setq zhuang
	 (pickset:to-list
	  (ssget "c" pt-lb
		 (mapcar '+ pt-lb '(3300 -2600 0))
		 (list '(0 . "insert")
		       (cons 2 (@:get-config '@lab:zblkname))))))
   ;; 3����鷶Χ�ڵ� D��ͷ�����֣�����ZֵΪ ���ֵ���ɡ�����ͼԪ��Χ��)
   (if zhuang
       (foreach
	zhuang% zhuang
	(setq zbox
	      (entity:getbox zhuang% 0))
	(setq txt-d
	      (pickset:to-list
	       (ssget "w"
		      (car zbox)
		      (cadr zbox)
		      '((0 . "text")(1 . "D*")))))
	(foreach
	  txt-d%
	  txt-d
	  (entity:putdxf
	   txt-d%
	   10
	   (list 
	    (car (entity:getdxf txt-d% 10))
	    (cadr (entity:getdxf txt-d% 10))
	    (atof value-z)))
	  (@:log "INFO" (strcat (entity:getdxf txt-d% 1)
				" z =>"
				value-z))
	  
	  ))))
  (princ)
  )

       
  
