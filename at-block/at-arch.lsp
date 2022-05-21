;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-arch:first ���� Ӧ�ð� at-arch �� ��һ�������� first 
(@:define-config '@block:block-name "����" "�����źŵĿ����ơ�")
(@:define-config '@block:attribute-name "������" "�����źŵĿ������Ե����ơ�")
;; (@:get-config 'at-arch:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-arch:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "��" "�Զ����" "(@block:set-number)")
(defun @block:set-number (/ num1 start ss-list)
  (setq ss-list (pickset:to-entlist (ssget (list (cons 0 "insert")
					    (cons 1 (@:get-config 'at-arch:block-name))))))
  (setq ss-list (vl-sort ss-list
			 '(lambda (en1 en2)
			   (if (> (caddr (assoc 10 (entget en1)))
				  (+ 1000 (caddr (assoc 10 (entget en2)))))
			       T
			       (if (and (< (caddr (assoc 10 (entget en1)))
					   (+ 1000 (caddr (assoc 10 (entget en2)))))
					(> (caddr (assoc 10 (entget en1)))
					   (- (caddr (assoc 10 (entget en2))) 1000))
					(< (cadr (assoc 10 (entget en1)))
					   (cadr (assoc 10 (entget en2)))))
		     T
		     nil)
			       ))))
  (setq start (getint "���������ʼ���<1>:"))
  (if (null start) (setq start 1))
  (setq num1 0)
  ;;(print (length ss-list))
  (foreach en0 ss-list
	   ;;(@:debug "test" "set-tuhao")
	   (block:set-attributes
	    en0
	    (list (cons (@:get-config 'at-arch:attribute-name)
			(strcat (if (< (+ num1 start) 10) "0" "")
				(itoa (+ num1 start))))))
	   (setq num1 (1+ num1))
	   ))
