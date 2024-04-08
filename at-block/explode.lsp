;; 取块剪裁范围点，两点为矩形

(defun @block:explode-cliped (blk / pts)
  (if (setq pts(entity:getdxf(entity:getdxf (entity:getdxf (entity:getdxf blk 360) 360)360) 10))
      (progn
	(setq ent0 (entlast))
	(setq ents-x nil);;炸开的块图元
	(vla-explode (e2o blk))
	(while (setq ent0 (entnext ent0));;不能跳出问题
	  (setq ents-x (cons ent0 ents-x)))
	(mapcar 'vla-update (mapcar 'e2o ents-x))
	;; 删除原块引用
	(vla-delete (e2o blk))
	;;绘制剪裁范围框，用于人工核查
	(entity:putdxf 
	 (entity:make-rectangle
	  (car pts)(cadr pts))
	 62 1)
	;; 取剪裁范围的图元
	(setq ents-in (pickset:to-list (ssget "c" (car pts)(cadr pts))))
	;; 去掉不在范围内的图元
	(mapcar '(lambda(x)
		  (if (not(member x ents-in))
		      (entdel x)))
		ents-x))))
 
(defun @block:menu-explode-cliped ()
  (@:prompt "当前版本只能删除剪裁框以外的图形，不能删除与剪裁框相交的图形的以外部分")
  (mapcar '@block:explode-cliped
	  (pickset:to-list (ssget '((0 . "insert")))))

  )