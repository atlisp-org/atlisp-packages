;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; @ base -- @lisp ����������
;;; Author: VitalGG<vitalgg@gmail.com>
;;; Description: ���� AutoLisp/VisualLisp �����Ļ�ͼ���߼�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ������ lib-std.lsp
;;; �������ú�����

;;; �ļ���������

(defun @:check-consistency (contents order / ti% tmplist)
  "���ĳ��ֵ��Ψһ�ԡ�����ֵΪ������"
  (setq tmplist '())
  (foreach ti% contents 
	   (if (= nil (member (cdr (assoc order ti%)) tmplist))
	       (setq tmplist (append tmplist (list (cdr (assoc order ti%)))))))
  (length tmplist)
  )

(setq @:get-eval-code @:get-exec-permit)
(setq @:run-from-web @:load-remote)
