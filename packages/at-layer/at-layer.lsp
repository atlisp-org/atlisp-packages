;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; vitaltools -- Ψ�����߼�
;;; Author: VitalGG<vitalgg@gmail.com>
;;; Description: ���� AutoLisp/VisualLisp �����Ļ�ͼ���߼�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ͼ�㹤�߼�

(defun @:get-layer-by-object(ss / layer ti% ename e  )
  "������ѡ��������ͼ���"
  (setq layer nil )
  (setq ti% 0)
  (if (/= ss nil)
      (progn 
        (while
            (<= ti% (- (sslength ss) 1))
          (setq ename (ssname ss ti%))
          (setq e (entget ename ))
          (if (=  (member (cdr (assoc 8 e)) layer) nil)
              (progn
                (if (= layer nil)
                    (setq layer (list (cdr (assoc 8 e))))
                  (setq layer (append layer (list (cdr (assoc 8 e)))))
                  )
                )
            )
          (setq ti%(+ 1 ti%))
          )))
  layer
  )
(@:add-menu "ͼ��" "�ر�����" "(@:layer-off-other)")
(defun @:layer-off-other( /  ss  layer  lay-act-list )
  "�ر�����ͼ��"
  (setq lay-act-list "")
  (setq ss (ssget ))
  (foreach layer (layer:list)
           ;;; �����ǰͼ�㲻�� ��ѡ�����У��赱ǰ��Ϊ��һ����ǰ�����
           (if (= (member (getvar "clayer")  (@:get-layer-by-object ss)) nil)
               (setvar "clayer" (car  (@:get-layer-by-object ss)) )
             )
           (if (= (member layer (@:get-layer-by-object ss)) nil)
               (if (= lay-act-list "")
                   (setq lay-act-list layer)
                 (setq lay-act-list (strcat lay-act-list "," layer)
             )
           )))
  (command "-layer" "off" lay-act-list "")
  )
(@:add-menu "ͼ��" "��������" "(@:layer-frozen-other)")
(defun @:layer-frozen-other( /  ss  layer  lay-act-list )
  "��������ͼ��"
  (setq lay-act-list "")
  (setq ss (ssget ))
  (foreach layer (layer:list)
           ;;; �����ǰͼ�㲻�� ��ѡ�����У��赱ǰ��Ϊ��һ����ǰ�����
           (if (= (member (getvar "clayer")  (@:get-layer-by-object ss)) nil)
               (setvar "clayer" (car  (@:get-layer-by-object ss)) )
             )
           (if (= (member layer (@:get-layer-by-object ss)) nil)
               (if (= lay-act-list "")
                   (setq lay-act-list layer)
                 (setq lay-act-list (strcat lay-act-list "," layer)
             )
           )))
  (command "-layer" "f" lay-act-list "")
  )

(@:add-menu "ͼ��" "��������" "(@:layer-lock-other)")
(defun @:layer-lock-other( /  ss  layer  lay-act-list )
  "��������ͼ��"
  (setq lay-act-list "")
  (setq ss (ssget ))
  (foreach layer (layer:list)
           ;;; �����ǰͼ�㲻�� ��ѡ�����У��赱ǰ��Ϊ��һ����ǰ�����
           (if (= (member (getvar "clayer")  (@:get-layer-by-object ss)) nil)
               (setvar "clayer" (car  (@:get-layer-by-object ss)) )
             )
           (if (= (member layer (@:get-layer-by-object ss)) nil)
               (if (= lay-act-list "")
                   (setq lay-act-list layer)
                 (setq lay-act-list (strcat lay-act-list "," layer)
             )
           )))
  (command "-layer" "lo" lay-act-list "")
  )

(@:add-menu "ͼ��" "����ȫ��" "(@:layer-unlock)")
(defun @:layer-unlock( /  ss  layer  lay-act-list )
   "����ȫ��ͼ��"
  (setq lay-act-list "")
  (foreach layer (layer:list)
           (if (= lay-act-list "")
                   (setq lay-act-list layer)
                 (setq lay-act-list (strcat lay-act-list "," layer)
             )
           ))
  (command "-layer" "u" lay-act-list "")
  )

(@:add-menu "ͼ��" "�ⶳȫ��" "(@:layer-thaw)")
(defun @:layer-thaw( /  layer  lay-act-list )
  "�ⶳȫ��ͼ��"
  (setq lay-act-list "")
  (foreach layer (layer:list)
           (if (= lay-act-list "")
                   (setq lay-act-list layer)
                 (setq lay-act-list (strcat lay-act-list "," layer)
             )
           ))
  (command "-layer" "t" lay-act-list "")
  )
(@:add-menu "ͼ��" "ͼ��ȫ��" "layon")

;; Local variables:
;; coding: gb2312
;; End: 
