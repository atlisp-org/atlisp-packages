(@:define-config '@lab:disx 300 "X���࣬÷������ʱӦΪ�о��2��")
(@:define-config '@lab:disy 300 "Y���࣬÷������ʱӦΪ�о��2��")
(@:define-config '@lab:r  "10,50" "�뾶���Զ��ŷ�Ϊ��ͬ��Բ")
(defun array-circle (pt-begin pt-end disx disy r)
  "pt-begin �������; pt-end �����յ�;disx,disy X Y��ļ��,r�뾶(�������б�)"
(entity:make-circle 
 (append  ;; ÷��
  (apply
   'append
   (mapcar
    '(lambda(x)
       (mapcar
	'(lambda(y)
	   (list x y))
	(list:range (cadr pt-begin)(cadr pt-end) disy)));;Y�����㣬�յ㣬����
    (list:range (car pt-begin)(car pt-end) disx)));;X�����㣬�յ㣬����
  (apply
   'append
   (mapcar
    '(lambda(x)
       (mapcar
	'(lambda(y)
	   (list x y))
	(list:range (+ (* 0.5 disy)(cadr pt-begin))(cadr pt-end) disy)));;Y�����㣬�յ㣬����
    (list:range  (+ (* 0.5 disx)(car pt-begin))(car pt-end) disx))));;X�����㣬�յ㣬����
 r) ;; �뾶��
)
(defun @lab:array-circle (/ pt-start pt-end disx disy r res)
  (setq res
	(ui:input
	 "������Բ�����"
	 (list
	  (list "disx" (@:get-config '@lab:disx) "X���࣬÷������ʱӦΪ�о��2��")
	  (list "disy"  (@:get-config '@lab:disy) "Y���࣬÷������ʱӦΪ�о��2��")
	  (list "r"  (@:get-config '@lab:r)  "�뾶���Զ��ŷ�Ϊ��ͬ��Բ"))))
  (@:set-config  '@lab:disx (cdr (assoc "disx" res)))
  (@:set-config  '@lab:disy (cdr (assoc "disy" res)))
  (@:set-config  '@lab:r (cdr (assoc "r" res)))
  (setq pt-start (getpoint (@:speak "���������½�:")))
  (setq pt-end (getcorner pt-start (@:speak "���������Ͻ�:")))
  (array-circle pt-start pt-end
		(cdr (assoc "disx" res))
		(cdr (assoc "disy" res))
		(mapcar
		 'atof
		 (string:to-list(cdr (assoc "r" res)) ","))))
