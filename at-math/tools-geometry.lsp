;; write area value of a close polygon to drawing
;;(@:add-menu "����" "�պ������" "(@:?area)")
(defun @:?area(/ OLDOS PT STA QAREA)
  "��պ���״��������������ͼ���С�����ֵΪ���ֵ��"
;;
  (setq olderr *error*)
  (setq *error* myerr)
  (setvar "CMDECHO" 0)
  (setq oldos (getvar "OSMODE"))
;;
  (SETVAR "OSMODE" 0)
  (SETQ STA (CAR (ENTSEL)))
  (COMMAND "AREA" "E" STA)
  (SETQ QAREA (RTOS (GETVAR "AREA") 2 2))
  (SETQ PT (GETPOINT"\nPick the point you want to write area:"))
  (COMMAND "TEXT" PT "" "" QAREA)
;;  
  (SETVAR "OSMODE" OLDOS)
  (SETVAR "CMDECHO" 1)
  (setq *error* olderr)
  pt
  )
;;; ������ֱ�߶�ʵ��Ľ���
(defun @:?inters2P&L (p1 p2 line / )
  (inters p1 p2 
          (reverse (cdr (reverse (cdr (assoc 10 line)))))
          (reverse (cdr (reverse (cdr (assoc 11 line)))))
          )
  )

;; ��ֱ�߶�ʵ��Ľ���
(defun @:?inters2L (l1 l2 / )
  (inters (reverse (cdr (reverse (cdr (assoc 10 l1)))))
          (reverse (cdr (reverse (cdr (assoc 11 l1)))))
          (reverse (cdr (reverse (cdr (assoc 10 l2)))))
          (reverse (cdr (reverse (cdr (assoc 11 l2))))))
  )
;; Local variables:
;; coding: gb2312
;; End: 
