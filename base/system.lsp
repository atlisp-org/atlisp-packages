(defun system:explorer (dir-path)
  "����Դ�������д�ָ�����ļ���"
  (startapp (strcat "explorer /e,\""dir-path"\""))
  (princ))
(defun system:dir (str)
  "�ַ���·��Ŀ¼��������β�� \\ "
  (if (= 92 (last (vl-string->list str)))
      str
    (strcat str "\\")))
(defun system:get-folder (msg / WinShell shFolder path catchit)
  "����Windowsͨ��Ŀ¼ѡȡ�Ի���,����ѡ��·��
����: msg-�Ի�����ʾ�ַ���"
  
  (vl-load-com)
  (setq winshell (vlax-create-object "Shell.Application"))
  (setq shFolder (vlax-invoke-method WinShell 'BrowseForFolder 0 msg 1))
  (setq
   catchit (vl-catch-all-apply
            '(lambda ()
              (setq shFolder (vlax-get-property shFolder 'self))
              (setq path (vlax-get-property shFolder 'path))
              )
            )
  )
  (if (vl-catch-all-error-p catchit)
      nil
      path
      )
  )
