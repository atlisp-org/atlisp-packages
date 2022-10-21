;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ʹ�ÿ������� dev-tools �Զ������ĳ���Դ�ļ� 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ��ϵͳ����Ӳ˵� 
(@:add-menu "@������" "��Ȼ���Խ���" '(at-nlp:about))
(defun at-nlp:about ()
  (@:help (strcat "ʹ����Ȼ������ CAD ���н������� ��ͼ���޸���ɫ��\n"
		  "NLP�ĳ�ʼ���ԡ�\n"
		  "ʾ��:\n ���ư뾶Ϊ10��Բ\n"
		  "����ֱ��Ϊ10��Բ\n"
		  "ѡ�����а뾶����5��Բ\n"
		  "�޸�ֱ��Ϊ20\n"
		  "�޸�Ϊ��ɫ\n"
		  ))
  ;; ���²���Ϊ��Ϊʵ��ĳһ��������д�Ĵ��롣
  (princ)
  )
(defun at-nlp:parse-corpus (lst-str )
  "����ֶβ�ע����"
  (defun flatten (lst / lst1)
    "����ά�б�չƽΪһά�����򲭡�"
    "list"
    "(list:flatten '(a (b c)
      (d (e))))"
    (foreach x lst
	     (cond ((or (and
			 x
			 (atom x)
			 (/= "" x))
			(p:dotpairp x)
			(and (listp x)
			     (= (length x) 1)
			     (atom (car x))
			     (/= "" (car x))
			     ))
		    (setq lst1 (append lst1 (list x))))
		   ((listp x)
		    (setq lst1 (append lst1 (flatten x))))
		   )))
  (flatten
  (mapcar '(lambda (x / res)
	      (if (and x (/= "" x))
		  (progn
		    ;;(setq res (list str))
		    (setq flag nil)
		    (setq res x)
		    (foreach
		     verb (append at-nlp:*verb* at-nlp:*entity*
				  at-nlp:*attribute* at-nlp:*color*
				  at-nlp:*bool* at-nlp:*prep*)
		     (if (null flag)
		     (cond
		      ((= (car verb) x)
		       (setq flag t)
		       (setq res (cons (car verb) (cdr verb))))
		      ((vl-string-search (car verb) x)
		       (setq lst-str (string:to-list x (car verb)))
		       (setq flag t)
		       (if (> (length lst-str) 1)
			   (progn
			     (setq res
				   (list (at-nlp:parse-corpus (list(car lst-str)))
					 (cons (car verb) (cdr verb))
					 (at-nlp:parse-corpus (cdr lst-str)))))
			 (setq res x)))
		      ;; ((null (vl-string-search (car verb) x))
		      ;;  (setq res x))
		      )))
		    res)
		x))
	  lst-str))
  )
  
(defun at-nlp:gen-code (res-corpus / res)
  (setq res (mapcar '(lambda(x)
		       (if (cddr x)
			   (cons (cddr x)
				 (cadr x))
			 x)
			 )
		    res-corpus))
  (princ res)
  (defun parse-attribute (att / lst-att )
    (while (setq att (member (assoc 'attribute att) att))
      (if (and (= 'compare (car (nth 1 att)))
	       (null (cadr (nth 2 att))))
	  (setq lst-att
		(cons
		 (cons (cdr (assoc 'attribute att))
		       (read (car (nth 2 att))))
		 lst-att))
	(setq lst-att
	      (cons 
	       (cons (cdr (assoc 'attribute att))
		     (read (car (nth 1 att))))
	       lst-att))
	)
      (setq att (cddr att))
      )
    lst-att)
		  
  (print (parse-attribute res))
  (cond
   ((= (read (cdr (assoc 'verb res))) 'ssget)
    (list
     'sssetfirst
     nil
     (append
      (list 'ssget)
      (if (= "x" (cdr (assoc 'prep res)))
	  (list (cdr (assoc 'prep res))))
      (list 
       (cons 'quote
	     (list
	      (append
	       (if (cdr (assoc 'entity res))
		   (list (cons 0 (cdr (assoc 'entity res)))))
	       (if (cdr (assoc 'color res))
		   (list (cons 62 (cdr (assoc 'color res)))))
	       (parse-attribute res)
	       ))))))
    )))
