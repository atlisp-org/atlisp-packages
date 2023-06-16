;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; condition ״��������
;;; ���ļ���Ҫ @lisp ���봦��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq @:*var-stack* nil) ;; ����״̬ջ,������ʱ��ʼ��
(@:define-config
    'base:sysvar
    "autosnap;snapmode;blipmode;cmdecho;clayer;delobj;luprec;orthomode;osmode;plinewid;textstyle;filedia"
  (_"push vars list"))
  
(defun push-var (varlst)
  ;;"��ǰ����״̬��ջ,����֧�֣������ַ��������š�"
  ;;(setq varlst (vl-remove-if 'null (varlst)))
  (if (= 'list (type (car varlst)))
      (setq varlst (car varlst)))
  (if (or (null (car varlst))
	  (null varlst))
      (setq varlst (@:string-to-list (@:get-config 'base:sysvar) ";")))
  (if (null varlst)
      (setq varlst '("autosnap";��׽���
		     "snapmode"; 
		     "blipmode";���ۼ�
		     "cmdecho";��ͨ�������ʾ
		     "clayer";ͼ��
		     "delobj"	;���ƴ�������ʱ�Ƿ���ԭpline��0Ϊ������1Ϊ������
		     "luprec";���Ⱦ���
		     "orthomode";����ģʽ
		     "osmode";��׽ģʽ
		     "plinewid";���߶ο��
		     "textstyle";������ʽ
		     "filedia"
		     )))
  (if (= 'str (type varlst)) (setq varlst (list varlst)))
  (if (= 'sym (type varlst)) (setq varlst (list varlst)))
  (setq varlst (vl-remove-if 'null varlst));;ɾ����Ԫ
  (if (= 'list (type varlst))
      (setq @:*var-stack*
	    (append 
	     (list (mapcar '(lambda (x) (cons x (getvar x))) varlst))
	     @:*var-stack*))))

(defun pop-var ()
  ;;"�ָ�����ı���"
  (mapcar '(lambda (x) (setvar (car x) (cdr x))) (car @:*var-stack*))
  (setq @:*var-stack* (cdr @:*var-stack*)))

;;�ֲ�������ʼ
;; (defun *error* (msg)
;;   (pop-var) ;��ԭϵͳ����
;;   (if (< 18 (atoi (substr (getvar "acadver") 1 2)))  ;�ж�CAD�汾���߰汾��command-s
;;       (command-s "undo" "e") ;CAD�߰汾��
;;       (command "undo" "e")) ;�Ͱ汾��
;;   (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
;;       (princ (strcat "\n** Error: " msg " **")))
;;   (princ)
;;   )
