;;; @:add-menu ����˵��
;;; 1. һ���˵� hello
;;; 2. �����˵� helloworld
;;; 3. �˵�ִ�е����� (helloworld)
(@:add-menu "Hello" "helloworld" '(helloworld))
(defun helloworld ()
  (@:help "���hello world �������м��Ի�����ʾ��")
  (princ "hello world.\n")
  (alert "hello world.")
  (princ)
)

