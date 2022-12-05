;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'flange:first ���� Ӧ�ð� flange �� ��һ�������� first 
;;(@:define-config 'flange:first "���������� flange:first ��ֵ" "������������;˵����")
;; (@:get-config 'flange:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'flange:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵�

(defun flange:make (pt-c DN Dw Dd Ds n t1 / ents)
  "pt-c ���ĵ� DN ����ֱ��(�ھ�),Dw�⾶��Dd,��˿���,Ds ��˿ֱ��,n ��˿������t1���"
  (push-var)
  (setvar "osmode" 0)
  (if (tblsearch "block" (strcat "Flange-DN" (itoa DN)))
      (block:insert (strcat "Flange-DN" (itoa DN)) "" pt-c 0 1)
    (progn
      (setq ents nil)
      (setq ents
	    (cons 
	     (entity:make-circle pt-c (* 0.5 Dw)) ents))
      (setq ents
	    (cons 
	     (entity:make-circle pt-c (* 0.5 DN)) ents))
      (setq ang 0)
      (repeat n
	      (setq ents
		    (cons 
		     (entity:make-circle (polar pt-c ang (* 0.5 Dd)) (* 0.5 Ds))
		     ents))
	      (setq ang (+ ang (/ (* 2 pi) n))))
      (mapcar '(lambda (x) (entity:putdxf x 39 t1)) ents)
      (entity:block ents (strcat "Flange-DN" (itoa DN)) pt-c)))
  (pop-var)
  )

(defun flange:draw ()
  (@:help (strcat "�Ӳ������ж������ݣ����Ʒ���"))
  ;;ʵ�ִ���
  ;; ���ز���
  (setq paras nil)
  (if (findfile (strcat (@:package-path "flange") "data.lst"))
      (progn
	(setq fp (open(strcat (@:package-path "flange") "data.lst")"r"))
	(while (setq str-l (read-line fp))
	  (if(/= "#" (substr str-l 1 1))
	      (setq paras (cons 
			   (cdr (string:to-list str-l "\t"))
			   paras))))
	;; ��ʾ���棬ѡ�������
	(setq paras (reverse paras))
	(setq para (assoc 
		    (ui:select "��ѡ���ͺ�"
			       (mapcar 'car paras))
		    paras)
		    )

	(setq pt-c (getpoint "��ѡҪ���Ƶ�λ������:"))
	(setq para (mapcar 'read para))
	(flange:make pt-c (atoi (substr (vl-symbol-name (nth 0 para)) 3)) (nth 1 para) (nth 2 para)(nth 3 para) (nth 4 para)(nth 5 para))
	)))
 
