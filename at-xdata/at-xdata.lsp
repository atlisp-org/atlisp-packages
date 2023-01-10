;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-xdata:first ���� Ӧ�ð� at-xdata �� ��һ�������� first 
;; (@:get-config 'at-xdata:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-xdata:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "��չ���ݹ���" "��ѯ��չ����" '(at-xdata:browser))

(defun at-xdata:browser () 
  (setq ss-x (ssget "x" '((-3 ("*")))))

  (@:log "INFO" (strcat "������" (itoa (sslength ss-x)) "������չ���ݵ�ͼԪ"))
  (setq order-ent 0)
  (if (setq current (ssname ss-x order-ent)) 
    (progn 
      (pickset:zoom current)
      (sssetfirst nil (ssadd current))))
  (dcl:dialog "xdata")
  (dcl:mtext "xdata" 8 50)
  (dcl:button "next" "Next" "")
  (dcl:dialog-end-ok-cancel)
  (defun cb-next (/ current) 
    (setq order-ent (1+ order-ent))
    (if (>= order-ent (sslength ss-x))
      (setq order-ent 0))
    (if (setq current (ssname ss-x order-ent)) 
      (progn 
        (pickset:zoom current)
        (dcl:set-mtext 
          "xdata"
          (strcat 
            "�� " (itoa (1+ order-ent)) " ������ " (itoa (sslength ss-x)) " ��\n"
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

        (sssetfirst nil (ssadd current)))
      (setq order 0)))
  (dcl:new "xdata")
  (dcl:set-mtext 
    "xdata"
    (strcat 
      "�� " (itoa (1+ order-ent)) " ������ " (itoa (sslength ss-x)) " ��\n"
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
  (set_tile "title" "��չ���ݲ鿴")
  (dcl:show)
  (princ))