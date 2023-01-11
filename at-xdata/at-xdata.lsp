;; ����ѡ��
(@:define-config '@xdata:filter "*" "��չ���ݹ�����������ѡ����չ���ݵ�ͼԪʱ�����Թ��˵�����Ҫ�ġ�")
;; ��ϵͳ����Ӳ˵� 
(@:add-menus 
  '("��չ���ݹ���"
    ("��ѯ��չ����" (at-xdata:browser))
    ("���ù�����" (at-xdata:set-filter))))

(defun at-xdata:browser (/ gen-mtext order-ent current ss-x cb-next cb-prev 
                         cb-zoomext) 
  (@:help '("������ʾͼԪ����չ����"))
  (setq ss-x (ssget (list (list -3 (list (@:get-config '@xdata:filter))))))
  (if (null ss-x) 
    (setq ss-x (ssget "x" (list (list -3 (list (@:get-config '@xdata:filter)))))))

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
              (setq order-ent (1- (sslengh ss-x))))
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
          (dcl:show))))
    (@:log "INFO" (@:speak "û�з�ƥ���ͼԪ��¼����ȷ�����ڣ������ù�������")))
  (princ))


(defun at-xdata:set-filter (/ ss-x) 
  "��������˵��"
  "��������ֵ"
  (@:help '("������չ���ݹ���ѡ��Է����������"))
  (setq ss-x (ssget "x" '((-3 ("*")))))
  (setq xdata-appids (mapcar 
                       '(lambda (x) 
                          (mapcar 
                            'car
                            (cdr (assoc -3 (entget x '("*"))))))
                       (pickset:to-list ss-x)))
  (setq xdata-appids (list:remove-duplicates 
                       (list:flatten xdata-appids)))
  (if xdata-appids 
    (progn 
      (setq res (ui:select-multi "��ѡ��Ҫƥ�����չ������appid" xdata-appids))

      (if res 
        (@:set-config '@xdata:filter (string:from-list res ","))
        (@:set-config '@xdata:filter "*"))
      (@:log "INFO" "����� @xdata:filter ������"))
      (@:log "INFO" (@:speak"ͼ��û�з��ֺ�����չ���ݵ�ͼԪ������ѡ��ֵû���޸ġ�"))
  
  ))
