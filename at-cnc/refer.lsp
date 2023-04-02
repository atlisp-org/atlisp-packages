(defun at-cnc:gen-gcodeb ()
  (@:help '("将曲线生成G-code"))
 (setvar "CMDECHO" 0)
 (setq dnm (getvar "DWGNAME")
          dnm (substr dnm 1 (- (strlen dnm) 4))
          dnmb (strcat dnm "b.cnc")
          dnm (strcat dnm ".cnc"))
 (setq tn (getstring "\nNumber of tools 刀具编号 :"))
 (setq td (getdist "\nDiameter of tools 刀具直径 :"))
 (setq f (strcat " F" (rtos (getreal "\nFeedRate 进给率 :") 2) "\n"))
 (setq hd T)
 (setq n 1)
 (setq pl (list)
          ppl (list (strcat "(" dnm ")\n") '"%\n")
          ppl2 (list (strcat "(" dnmb ")\n") "%\n"))
 (while (or (initget 1 "H ")
          (setq s1 (entsel "\nSelect a slot 选择画好的槽 (H=换刀) :")))
  (if (= s1 "H") (progn
   (setq tn (getstring "\nNumber of tools 刀具编号 :"))
   (setq td (getdist "\nDiameter of tools 刀具直径 :"))
   (setq f (strcat " F" (rtos (getreal "\nFeedRate 进给率 :") 2) "\n"))
   (setq hd T
            pl (cons (strcat "加工编号" stno "-N" (itoa n))))
  )
   (if (and (setq ent (entget(car s1)))
          (or (= (cdr (assoc 0 ent)) "LWPOLYLINE") (= (cdr (assoc 0 ent)) "POLYLINE"))
    (setq pt (getpoint "\nStart Point 起点 :"))
    (setq pc0 (osnap pt "CEN"))) (progn
    (if hd
  (setq ppl (cons (strcat "M06 T" tn "(D="(rtos td 2 2)")\n") ppl)
           ppl2 (cons (strcat "M06 T" tn "(D="(rtos td 2 2)")\n") ppl2)
           ppl (cons "M08\n" ppl)
           ppl2 (cons "M08\n" ppl2)
           ppl (cons "G80 G90 G54 F80\n" ppl)
           ppl2 (cons "G80 G90 G54 F80\n" ppl2)
           ppl (cons "G00 X0.0 Y0.0 M03 S1400\n" ppl)
           ppl2 (cons "G00 X0.0 Y0.0 M03 S1400\n" ppl2)
           ppl (cons "G43 H43 Z5.0\n" ppl)
           ppl2 (cons "G43 H43 Z5.0\n" ppl2)
           ppl (cons "G01 F1500 Z5.0\n" ppl)
           ppl2 (cons "G01 F1500 Z5.0\n" ppl2)
           hd nil
           pl (cons (strcat "刀具大小=" (rtos td 2)) pl)
           stno (strcat "N" (itoa n)))
 )
    (command ".UNDO" "BE")
    (command "explode" (car s1))
    (setq ss (ssget "P"))
    (setq i -1 ss1 (list) j nil k T ang (angle pt pc0))
    (while (= j nil)
     (setq en (ssname ss (setq i (1+ i)))
              ent (entget en))
     (if (= (cdr (assoc 0 ent)) "LINE")
      (setq p1 (cdr (assoc 10 ent)) p2 (cdr (assoc 11 ent)))
      (setq pc (cdr (assoc 10 ent)) r (cdr (assoc 40 ent))
               k (if (< r (/ td 2)) nil k)
               p1 (polar pc (cdr (assoc 50 ent)) r)
               p2 (polar pc (cdr (assoc 51 ent)) r))
     )
     (if (or (equal (distance pt p1) 0.0 0.0001)
             (equal (distance pt p2) 0.0 0.0001)) (setq j i))
    )
    (if k (progn
     (repeat (- (sslength ss) j) (setq ss1 (append ss1 (list (ssname ss i))) i (1+ i)))
     (setq i 0)
     (repeat j (setq ss1 (append ss1 (list (ssname ss i))) i (1+ i)))
     (setq i -1 cf T ppl (cons (strcat "N" (itoa n) "\n") ppl))
     (repeat (length ss1)
      (setq ent (entget (nth (setq i (1+ i)) ss1)))
      (if (= (cdr (assoc 0 ent)) "LINE") (progn
       (setq p1 (cdr (assoc 10 ent)) p2 (cdr (assoc 11 ent)))
       (if cf (progn
     (if (not (equal (distance pt p1) 0.0 0.0001)) (setq ptm p1 p1 p2 p2 ptm))
      (setq pt0 (polar pt ang (/ td 2))
               cf nil
               ppl (cons (strcat "G00 X" (rtos(car pt0) 2 3) " Y" (rtos(cadr pt0) 2 3) "\n" ) ppl)
               ppl (cons "Z-16.0 F1000\n" ppl)
               pt0 (polar pt0 (angle p1 p2) (distance p1 p2))
               ppl (cons (strcat "G01 X" (rtos(car pt0) 2 3) " Y" (rtos(cadr pt0) 2 3) f) ppl))
    )
     (setq pt0 (polar pt0 (angle p1 p2) (distance p1 p2))
              ppl (cons (strcat "G01 X" (rtos(car pt0) 2 3) " Y" (rtos(cadr pt0) 2 3) "\n") ppl))
    )
      ) (progn
    (setq pc (cdr (assoc 10 ent)) r (cdr (assoc 40 ent))
             p1 (polar pc (cdr (assoc 50 ent)) r)
             p2 (polar pc (cdr (assoc 51 ent)) r))
    (if (> r (/ td 2))
     (if cf (progn
      (if (equal (distance pt p1) 0.0 0.0001)
       (setq ccf "G03 X")
       (setq ccf "002 x" ptm p1 p1 p2 p2 ptm)
      )
      (setq pt0 (polar pt ang (/ td 2))
               cf nil
               ppl (cons (strcat "G00 X" (rtos(car pt0) 2 3) " Y" (rtos(cadr pt0) 2 3) "\n") ppl)
               ppl (cons "Z-16.0 F1000\n" ppl)
               pt0 (polar pc ang (- r (/ td 2)))
               ppl (cons (strcat ccf (rtos(car pt0) 2 3) " Y" (rtos(cadr pt0) 2 3) " I"
                     (rtos(car pc) 2 3) " J" (rtos(cadr pc) 2 3) f) ppl))
      (setq pt0 (polar pc ang (- r (/ td 2)))
               ppl (cons (strcat ccf (rtos(car pt0) 2 3) " Y" (rtos(cadr pt0) 2 3) " I"
                     (rtos(car pc) 2 3) " J" (rtos(cadr pc) 2 3) "\n") ppl))
     ))
     (if cf (setq pt0 pc))
    )
      ))
     )
     (setq ppl (cons "G00 Z5.0\n" ppl)
              ppl (cons "M01\n" ppl))
    )
     (princ "r is too small! Con't cut the slot. 半径太小！")
    )
    (command ".UNDO" "E")
    (command "_U")
    (command ".UNDO" "BE")
    (command "OFFSET" (- (/ td 2) 0.25) (cadr s1) (polar pt ang (/ td 2)) "")
    (command "explode" "l")
    (setq ss (ssget "P"))
    (setq i -1 ss1 (list) j nil pt0 (polar pt ang (- (/ td 2) 0.25)))
    (while (= j nil)
     (setq en (ssname ss (setq i (1+ i)))
              ent (entget en)) (princ i)
     (if (= (cdr (assoc 0 ent)) "LINE")
      (setq p1 (cdr (assoc 10 ent)) p2 (cdr (assoc 11 ent)))
      (setq pc (cdr (assoc 10 ent)) r (cdr (assoc 40 ent))
               p1 (polar pc (cdr (assoc 50 ent)) r)
               p2 (polar pc (cdr (assoc 51 ent)) r))
     )
     (if (or (equal (distance pt0 p1) 0.0 0.0001)
             (equal (distance pt0 p2) 0.0 0.0001)) (setq j i))
    )
    (repeat (- (sslength ss) j) (setq ss1 (append ss1 (list (ssname ss i))) i (1+ i)))
    (setq i 0)
    (repeat j (setq ss1 (append ss1 (list (ssname ss i))) i (1+ i)))
    (setq i -1 cf T ppl2 (cons (strcat "N" (itoa n) "\n") ppl2))
    (repeat (length ss1)
     (setq ent (entget (nth (setq i (1+ i)) ss1)))
     (if (= (cdr (assoc 0 ent)) "LINE") (progn
      (setq p1 (cdr (assoc 10 ent)) p2 (cdr (assoc 11 ent)))
      (if cf (progn
    (if (not (equal (distance pt0 p1) 0.0 0.0001)) (setq ptm p1 p1 p2 p2 ptm))
    (setq cf nil
             ppl2 (cons (strcat "G00 X" (rtos(car p1) 2 3) " Y" (rtos(cadr p1) 2 3) "\n" ) ppl2)
             ppl2 (cons "Z-16.0 F1000\n" ppl2)
             ppl2 (cons (strcat "G01 X" (rtos(car p2) 2 3) " Y" (rtos(cadr p2) 2 3) f) ppl2)
             pt0 p2)
   )
    (setq ppl2 (cons (strcat "G01 X" (rtos(car p2) 2 3) " Y" (rtos(cadr p2) 2 3) "\n") ppl2)
             pt0 p2)
   )
     ) (progn
   (setq pc (cdr (assoc 10 ent)) r (cdr (assoc 40 ent))
            p1 (polar pc (cdr (assoc 50 ent)) r)
            p2 (polar pc (cdr (assoc 51 ent)) r))
   (if cf (progn
    (if (equal (distance pt0 p1) 0.0 0.0001)
     (setq ccf "G03 X")
     (setq ccf "002 x" ptm p1 p1 p2 p2 ptm)
    )
    (setq cf nil
             ppl2 (cons (strcat "G00 X" (rtos(car p1) 2 3) " Y" (rtos(cadr p1) 2 3) "\n") ppl2)
             ppl2 (cons "Z-16.0 F1000\n" ppl2)
             pt0 p2
             ppl2 (cons (strcat ccf (rtos(car p2) 2 3) " Y" (rtos(cadr p2) 2 3) " I"
                     (rtos(car pc) 2 3) " J" (rtos(cadr pc) 2 3) f) ppl2))
      )
    (setq pt0 p2
             ppl2 (cons (strcat ccf (rtos(car p2) 2 3) " Y" (rtos(cadr p2) 2 3) " I"
                     (rtos(car pc) 2 3) " J" (rtos(cadr pc) 2 3) "\n") ppl2))
   )
     ))
    )
    (setq ppl2 (cons "G00 Z5.0\n" ppl2)
             ppl2 (cons "M01\n" ppl2))
    (setq n (1+ n))
    (command ".UNDO" "E")
    (command "_U")
   ))
  )
 )
 (if (and (listp pl) (listp ppl) (listp ppl2)) (progn
  (setq pl (cons (strcat "铣槽正面程式" dmm) pl)
           pl (cons (strcat "铣槽反面程式" dnmb) pl)
           pl (reverse pl))
  (setq fp (open dnm "w"))
  (setq ppl (cons "M30\n" ppl))
  (setq ppl2 (cons "M30\n" ppl2))
  (setq ppl (reverse ppl) i -1)
  (repeat (length ppl)
   (princ (nth (setq i (1+ i)) ppl) fp)
  )
  (close fp)
  (setq fp1 (open dnmb "w"))
  (setq ppl2 (reverse ppl2) i -1)
  (repeat (length ppl2)
   (princ (nth (setq i (1+ i)) ppl2) fp1)
  )
  (close fp1)
  (setq pt (getpoint "\nStart Text(s) Point 文字开始点 :"))
  (setq i -1)
  (repeat (length pl)
   (command ".text" pt 3 0 (nth (setq i (1+ i)) pl))
  )
  (command "notepad" dnm)
  (command "notepad" dnmb)
 ))
 (princ)
)
