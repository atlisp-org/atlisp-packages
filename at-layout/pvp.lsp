(@:add-menus
 '("����"
   ("�ӿ���������"(@layout:pvp-v))
   ("�ӿ���������"(@layout:pvp-w))
   ("�ӿڶ���ˢ"(@layout:pvp-ma)))
 )
   
(defun @layout:pvp-v (/ clayout)
  (@:help "�ӿ���������ͼ")
  (setq clayout (getvar "ctab"))
  (foreach layout (layout:list)
	   (setvar "ctab" layout)
	   (setq n (sslength (ssget"x"
				   (list '(0 . "viewport")
					 (cons 410 layout)
					 '(-4 . "<NOT")
					 '(69 . 1)
					 '(-4 . "NOT>")))))
	   (@:cmd "zoom" "a")
	   (setq i 1)(repeat n(@:cmd"mspace")(setvar "cvport" (setq i (1+ i)))(@:cmd"ucs""v")))
  (setvar"ctab" clayout)
  (@:cmd"pspace")
  )

(defun @layout:pvp-w (/ clayout)
  (@:help "�ӿ���������ͼ")
  (setq clayout (getvar "ctab"))
  (foreach layout (layout:list)
	   (setvar "ctab" layout)
	   (setq n (sslength (ssget"x"
				   (list '(0 . "viewport")
					 (cons 410 layout)
					 '(-4 . "<NOT")
					 '(69 . 1)
					 '(-4 . "NOT>")))))
	   (@:cmd "zoom" "a")
	   (setq i 1)(repeat n(@:cmd"mspace")(setvar "cvport" (setq i (1+ i)))(@:cmd"ucs""w")))
  (setvar"ctab" clayout)
  (@:cmd"pspace")
  )
(defun @layout:pvp-ma ()
  (@:help "��ѡ�е��ӿڵĶ���ͼ��ˢ�������ӿ�")
  (@:prompt "��ѡ��Դ�ӿ�:")
  (if (setq src-layout (ssget "_:S:E" '((0 . "VIEWPORT"))))
      (progn
	(setq obj-vflayers
	      (vla-getxdata (e2o (ssname src-layout 0))
			    "" 'xtypeOut 'xdataOut))
	(@:prompt "��ѡ��Ŀ���ӿ�")
	
	(if (setq dist-layouts (ssget '((0 . "VIEWPORT"))))
	    ;;���ԭ���Ķ���״̬
	    (progn
	      (@:cmd "vplayer" "t" "*" "S" dist-layouts "" "")
	      (foreach dst (pickset:to-list dist-layouts)
		       
		       (vla-setXdata (e2o dst)
				     xtypeOut xdataOut)
		       (vla-display (e2o dst) :vlax-false)
		       (vla-display (e2o dst) :vlax-true)
		       ;;(vla-syncmodelview (e2o dst))
		       (vla-update (e2o dst))
		       ))))))

