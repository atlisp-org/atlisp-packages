;; ��ϵͳ����Ӳ˵� 
(@:add-menu "��չ���ݹ���" "��ѯ��չ����" '(at-xdata:browser))
;; (@:add-menu "��չ���ݹ���" "�����չ����" '(at-xdata:check))
(defun at-xdata:browser () 
  (@:help '("������ʾͼԪ����չ����"))
  (setq ss-x (ssget '((-3 ("*")))))
  (if (null ss-x) 
    (setq ss-x (ssget "x" '((-3 ("*"))))))
  (if ss-x 
    (progn 
      (@:log "INFO" (strcat "������" (itoa (sslength ss-x)) "������չ���ݵ�ͼԪ"))
      (setq order-ent 0)
      (if (setq current (ssname ss-x order-ent)) 
        (progn 
          (pickset:zoom current)
          (sssetfirst nil (ssadd current))
          (dcl:dialog "xdata")
          (dcl:mtext "xdata" 8 50)
          (dcl:begin-cluster "row" "����")
          (progn
            (dcl:button "prev" "Prev" "")
            (dcl:button "Zoomext" "zoomExt" "")
            (dcl:button "next" "Next" ""))
          (dcl:end-cluster)
          (dcl:dialog-end-ok-cancel)
          (defun gen-mtext () 
            (strcat 
              "�� "
              (itoa (1+ order-ent))
              " ������ "
              (itoa (sslength ss-x))
              " ��\n"
              "ͼԪ����:"
              (entity:getdxf current 0)
              "\n"
              (if (wcmatch (entity:getdxf current 0) "INSERT") 
                (strcat "����:" (block:get-effectivename current) "\n")
                "")
              "��չ����\n"
              (string:from-list 
                (mapcar 
                  '(lambda (x) 
                     (strcat 
                       "APPID:"
                       (car x)
                       "\n"
                       (vl-prin1-to-string (cdr x))))
                  (cdr (assoc -3 (entget current '("*")))))
                "\n")))
          (defun cb-zoomext ()
           (vla-ZoomExtents *ACAD*))
          (defun cb-prev (/ current) 
            (setq order-ent (1- order-ent))
            (if (< order-ent 0) 
              (setq order-ent (1-(sslengh ss-x))))
            (if (setq current (ssname ss-x order-ent)) 
              (progn 
                (pickset:zoom current)
                (dcl:set-mtext "xdata" (gen-mtext))
                (sssetfirst nil (ssadd current)))
              (setq order 0)))
          (defun cb-next (/ current) 
            (setq order-ent (1+ order-ent))
            (if (>= order-ent (sslength ss-x)) 
              (setq order-ent 0))
            (if (setq current (ssname ss-x order-ent)) 
              (progn 
                (pickset:zoom current)
                (dcl:set-mtext "xdata" (gen-mtext))
                (sssetfirst nil (ssadd current)))
              (setq order 0)))
          (dcl:new "xdata")
          (dcl:set-mtext "xdata" (gen-mtext))
          (set_tile "title" "��չ���ݲ鿴")
          (dcl:show)
          (princ))))))