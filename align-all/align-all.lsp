;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'align-all:first ���� Ӧ�ð� align-all �� ��һ�������� first 
(@:define-config 'align-all:hangju 2000.0 "����ͼ��ʱ��Ĭ���оࡣ")
;; (@:get-config 'align-all:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'align-all:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "�����ͼ" "����ͼ��" "(align-all:entity)")

;;�����о�hj ֧��CAD���֡��������кͶ������֡�ͼ�顢�����֡�������ߡ�cad���cad�ߴ�
;;(setq BGhangju nil)
(defun align-all:entity (/ *error* a all b c e hangju1 hangju2 l m n p snap x x0 xyz 
                         xyz_new y y0 z) 
  (defun *error* (msg)  ;��������
    (pop-var)
    ;; (if snap (setvar "osmode" snap)) ;�ָ���׽
    (if (< 18 (atoi (substr (getvar "acadver") 1 2)))  ;�ж�CAD�汾���߰汾��command-s
      (command-s "undo" "e") ;CAD�߰汾��
      (command "undo" "e") ;�Ͱ汾��
    )
    ;;(setvar "cmdecho" 1) ;����������ʾ
    (princ msg))
  (push-var)

  (if 
    (setq a (ssget 
              (list 
                (cons 0 "*TEXT,DIMENSION,INSERT,ATTDEF,ACAD_TABLE,TCH_ELEVATION"))))
    (progn 
      (setq n (sslength a))
      (setq m 0)
      (while (< m n) 
        (setq all (append all (list (entget (ssname a m)))))
        (setq m (1+ m)))
      (setq l 0) ;��y���꽵������
      (setq m 1)
      (while (< l n) 
        (setq b (nth l all))
        (while (< m n) 
          (setq c (nth m all))
          (if (> (nth 2 (assoc '10 c)) (nth 2 (assoc '10 b))) 
            (progn 
              (setq all (subst 'aa (nth l all) all))
              (setq all (subst 'bb (nth m all) all))
              (setq all (subst c 'aa all))
              (setq all (subst b 'bb all))
              (setq b c)))
          (setq m (1+ m)))
        (setq l (1+ l))
        (setq m (1+ l)))
      (setq p (cdr (assoc '10 (car all))))
      ;;(setq hangju2 2000) ;Ĭ���о�Ϊ2000�������޸�
      (setvar "osmode" 16383)
      (setq hangju2 (getdist 
                      (strcat 
                        "\n�����о� ֧������ѡ <"
                        (rtos (@:get-config 'align-all:hangju) 2 2)
                        ">��")))
      (if (and (= 'real (type hangju2)) (> hangju2 0)) 
        (@:set-config 'align-all:hangju hangju2)
        (setq hangju2 (@:get-config 'align-all:hangju)))
      (setq x0 (car p))
      (setq y0 (cadr p))
      (setq m 0)
      (setvar "cmdecho" 0) ;�ر���������ʾ
      (vl-cmdf "undo" "be") ;���ʼ���
      (setvar "osmode" 0) ;�رղ�׽
      (while (< m n) 
        (setq b (nth m all))
        (setq e (cdr (assoc -1 b))) ;ͼԭ��
        (setq z (nth 3 (assoc 10 b)))
        (setq x (nth 1 (assoc 10 b)))
        (setq y (nth 2 (assoc 10 b)))
        (setq xyz (list x y z)) ;������
        (setq xyz_new (list x0 y0 z)) ;������
        (vl-cmdf "move" e "" xyz xyz_new) ;�ƶ�
        (setq y0 (- y0 hangju2))
        (setq m (1+ m)))
      ;; (setvar "osmode" snap) ;�򿪲�׽
      (vl-cmdf "undo" "e") ;����������
      (setvar "cmdecho" 1) ;����������ʾ
    ))
  (pop-var)
  (princ))
