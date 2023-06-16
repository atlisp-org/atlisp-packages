;;;��ȡmac��ַ-32λϵͳ��
(defun-q hdinfo:get-mac (/ i mac s str svr wmi)
  "��ȡmac��ַ����һ�����á�"
  (vl-load-com)
  (setq wmi (vlax-create-object "WbemScripting.SWbemLocator"))
  (setq svr (vlax-invoke wmi 'ConnectServer))
  (setq str "Select * from Win32_NetworkAdapterConfiguration Where IPEnabled=TRUE")
  (setq mac (vlax-invoke svr 'ExecQuery str))
  (vlax-for i mac
	    (setq s (cons (vlax-get i 'macAddress) s))
	    )
  (vlax-release-object mac)
  (vlax-release-object svr)
  (vlax-release-object wmi)       
  (car s)               
  )
;��ȡӲ�����к�
(defun-q hdinfo:get-hd-serial (/ lccon lox objw ret serx sn)
  "��ȡӲ�����к�,��һ�����á�"
  (setq serx '())
  (if (setq objw (vlax-create-object "wbemscripting.swbemlocator"))
      (progn
	(setq lccon (vlax-invoke objw 'connectserver "." "\\root\\cimv2"  ""  ""  ""  ""  128 nil))
	(setq lox (vlax-invoke lccon 'execquery "select serialnumber,tag from win32_physicalmedia"))
	(vlax-for item lox (setq serx (cons (list (vlax-get item 'tag) (vlax-get item 'serialnumber)) serx)))
	(vlax-release-object lox)
	(vlax-release-object lccon)
	(vlax-release-object objw)
	)
    )
  serx
  )
(defun-q hdinfo:get-cpuid (/ Vlist VObj lcom lExecQuery item)
  "��ȡCPU ID,��һ�����á�"
  (vl-load-com)
  (setq Vlist '())
  (if (setq VObj (vlax-create-object "wbemscripting.swbemlocator"))
      (progn
	(SETQ lcom (VLAX-INVOKE
		    VObj       'ConnectServer     "."
		    "\\root\\cimv2"  ""     ""
		    ""       ""  128     nil
		    ) ;_ ����VLAX-INVOKE
	      ) ;_ ����SETQ
	(setq lExecQuery
	      (vlax-invoke
	       lcom
	       'ExecQuery
	       ;;"Select * From Win32_BIOS"
	       "Select * from Win32_Processor"
	       ) ;_ ����vlax-invoke
	      ) ;_ ����setq
	(vlax-for item lExecQuery
		  (setq Vlist (vlax-get item 'ProcessorId) ;_ ����cons
			) ;_ ����setq
		  ) ;_ ����vlax-for
	(vlax-release-object lExecQuery)	
	(vlax-release-object lcom)
	(vlax-release-object Vobj)
	)
    )
  Vlist
  )
