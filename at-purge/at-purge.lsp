;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���������� 'at-purge:first ���� Ӧ�ð� at-purge �� ��һ�������� first 
;; (@:get-config 'at-purge:first) ;; ��ȡ���ö���ֵ
;; (@:set-config 'at-purge:first  "�����ֵ") ;; �������ö���ֵ
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "ʵ��"  "����DGN" "(at-purge:remove-dgn)")
(defun at-purge:remove-dgn (/)
  (vl-load-com)
  (if (dictremove (namedobjdict) "ACAD_DGNLINESTYLECOMP")
      (princ "������ DGN���� ���⣬������ purge �����ļ���")
      (princ "��ͼû�� DGN ����"))
  ;;;(command "purge" "" "a" "" "N" "")
  (princ)
  )

(@:add-menu "ʵ��" "�ֽ��ؿ�" "(@:explode-minsert)")
(defun @:explode-minsert (/ en ent)
  "�ֽ���ز���� "
  (vlax-for blk *blks* (if(=""(vla-get-name blk)) (vla-put-name blk "ttt")))
  
  (setq en (entsel "n��ѡ����ز����:"))
  (if en
      (if (= (cdr (assoc 0 (setq ent (cdr (entget (setq en (car en)))))))
	     "INSERT"
	     )
	  (progn
	    (setq ent (entmakex
		       (list '(0 . "INSERT")
			     
			     (assoc 2 ent)
			     (assoc 10 ent)
			     )
		       )
		  )
	    (command "_.explode" (entlast))
	    (entdel en)
	    )
	  )
    )
  (princ "\nOK���ֽ�ɹ���")
  (princ)
  )

