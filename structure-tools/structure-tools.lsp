(@:add-menu "�ṹ���㹤��" "С��������" "(stru:jiegou-tools \"XiaoHu\")")
(@:add-menu "�ṹ���㹤��" "�ṹ����STR" "(stru:jiegou-tools \"STR\")")
(@:add-menu "�ṹ���㹤��" "�϶��ṹ" "(stru:jiegou-tools \"LaoDong\")")
(@:add-menu "�ṹ���㹤��" "�ṹ����" "(stru:jiegou-tools \"JieGou\")")
(@:add-menu "�ṹ���㹤��" "�ֽṹϸ��" "(stru:jiegou-tools \"steel\")")

(defun stru:jiegou-tools ( file-capital / app-name)
  (setq app-name (strcat "structure-tools/" file-capital "-tools.exe"))
  (if (null (findfile (strcat "packages/" app-name)))
      (progn
	(@:log "INFO" "û�з��� �ļ�����������...\n")
	(@:down-pkg-file (@:uri) app-name edition))
      (command "start" (findfile (strcat "packages/" app-name)))))

  
;; Local variables:
;; coding: gb2312
;; End:
