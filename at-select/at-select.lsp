(@:define-config '@select:blksname "" "ѡ��ʱҪƥ��Ŀ���")
(defun @select:setup (/ res) 
  (setq @:tmp-search-str "@SELECT")
  (@:edit-config))
(defun c:ss1 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss1���Է�����������ʹ�á����û��ѡ���Ҹ�����ͼ�Σ������ss1"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss1 ss)
    (if ss1 
      (sssetfirst nil ss1))))
(defun c:ss2 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss2��"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss2 ss)
    (if ss2 
      (sssetfirst nil ss2))))
(defun c:ss3 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss3��"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss3 ss)
    (if ss3 
      (sssetfirst nil ss3))))
(defun c:ss4 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss4��"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss4 ss)
    (if ss4 
      (sssetfirst nil ss4))))
(defun c:ss5 (/ ss) 
  (@:help '("��¼��ǰ��ѡ���ͼ�� Ϊss5��"))
  (setq ss (cadr (ssgetfirst)))
  (if ss 
    (setq ss5 ss)
    (if ss5 
      (sssetfirst nil ss5))))

(defun at-select:select-blk-by-hatch (/ ha res) 
  (@:help '("ѡ������ڵĿ顣˵����ѡ��һ����䣬��������ڵĿ顣"))
  (setq ha (entget (car (entsel))))
  (setq res (cadr (list:split-by ha '(lambda (x) (= (car x) 91)))))
  (setq res (car (list:split-by res '(lambda (x) (= (car x) 75)))))
  (setq res (cdr (list:split-by res '(lambda (x) (= (car x) 92)))))
  (setq res (vl-sort res '(lambda (x y) (> (cdar x) (cdar y)))))
  (setq all-outer (vl-remove-if-not 
                    '(lambda (x) (= 1 (boole 1 1 (cdr (assoc 92 x)))))
                    res))
  (setq ss-all nil)
  (foreach outer all-outer 
    (setq pts-outer (mapcar 
                      'cdr
                      (vl-remove-if-not '(lambda (x) (or (= 10  (car x))(= 11 (car x)))) outer)))
    (entity:make-lwpolyline (list:delsame pts-outer 0) nil  0 1 0)
    (setq blk-all (pickset:to-list 
                    (ssget 
                      "cp"
                      (list:delsame pts-outer 0)
                      (append 
                        (list '(0 . "insert"))
                        (if (/= "" (@:get-config '@select:blksname)) 
                          (list 
                            (cons 2 (@:get-config '@select:blksname))))))))
    (setq ss-all (list:union ss-all blk-all)))
  (setq all-inter (vl-remove-if-not 
                    '(lambda (x) (= 0 (boole 1 1 (cdr (assoc 92 x)))))
                    res))
  ;;(princ all-inter)
  (setq ss-in nil)
  (foreach inter all-inter 
    (setq pts-inter (mapcar 
                      'cdr
                      (vl-remove-if-not '(lambda (x) (or (= 10 (car x))(= 11 (car x)))) inter)))
    (entity:putdxf 
    (entity:make-lwpolyline (list:delsame pts-inter 0) nil  0 1 0) 62 3)
    (setq blk-in (pickset:to-list 
                   (ssget 
                     "cp"
                     (list:delsame pts-inter 0)
                     (append 
                       (list '(0 . "insert"))
                       (if (/= "" (@:get-config '@select:blksname)) 
                         (list 
                           (cons 2 (@:get-config '@select:blksname))))))))
    (if blk-in 
      (setq ss-in (list:union ss-in blk-in))))
  (setq ss-res (list:difference ss-all ss-in))
  (sssetfirst nil (pickset:from-list ss-res)))