;;;��ؾ�����;;;----------------------------------------------------;
;;; ������ģ(����)                                       ;
;;; Vector Norm - Lee Mac                               ;
;;; Args: v - vector in R^n                               ;
;;;----------------------------------------------------;
(defun matrix:norm ( v )
  "������ģ(����)"
  (sqrt (apply '+ (mapcar '* v v)))
)

;;;----------------------------------------------------;
;;; �����˱���(ϵ��)                                       ;
;;; Vector x Scalar - Lee Mac                               ;
;;; Args: v - vector in R^n, s - real scalar               ;
;;;----------------------------------------------------;
(defun matrix:vxs ( v s )
  "�����˱���(ϵ��)"
  (mapcar '(lambda ( n ) (* n s)) v)
)

;;;----------------------------------------------------;
;;; ��λ����                                               ;
;;; Unit Vector - Lee Mac                              ;
;;; Args: v - vector in R^n                               ;
;;;----------------------------------------------------;
(defun matrix:unit ( v )
  "��λ����"
  ( (lambda ( n )
      (if (equal 0.0 n 1e-14)
        nil
        (matrix:vxs v (/ 1.0 n))
      )
    )
    (matrix:norm v)
  )
)

;;;----------------------------------------------------;
;;; �����ĵ��                                         ;
;;; matrix:vxv Returns the dot product of 2 vectors       ;
;;;----------------------------------------------------;
(defun matrix:vxv (v1 v2)
  "�����ĵ��"
  (apply '+ (mapcar '* v1 v2))
)

;;;----------------------------------------------------;
;;; �������Ĳ��                                       ;
;;; Vector Cross Product - Lee Mac                       ;
;;; Args: u,v - vectors in R^3                               ;
;;;----------------------------------------------------;
(defun matrix:v^v ( u v )
  "�������Ĳ��"
  (list
    (- (* (cadr u) (caddr v)) (* (cadr v) (caddr u)))
    (- (* (car  v) (caddr u)) (* (car  u) (caddr v)))
    (- (* (car  u) (cadr  v)) (* (car  v) (cadr  u)))
  )
)

;;;----------------------------------------------------;
;;; ����ת��                                           ;
;;; matrix:trp Transpose a matrix -Doug Wilson-           ;
;;;----------------------------------------------------;
(defun matrix:trp (m)
  "����ת��"
  (apply 'mapcar (cons 'list m))
)

;;;----------------------------------------------------;
;;; �����ľ���任(�����˾���)                         ;
;;; Matrix x Vector - Vladimir Nesterovsky             ;
;;; Args: m - nxn matrix, v - vector in R^n            ;
;;;----------------------------------------------------;
(defun matrix:mxv (m v)
  "�����ľ���任(�����˾���) "
  (mapcar (function (lambda (r) (apply '+ (mapcar '* r v)))) m)
)

;;;----------------------------------------------------;
;;; �㵽����ı任                                     ;
;;;----------------------------------------------------;
(defun matrix:mxp (m p)
  "�㵽����ı任"
  (reverse (cdr (reverse (matrix:mxv m (append p '(1.0))))))
)

;;;----------------------------------------------------;
;;; �������                                           ;
;;; matrix:mxm Multiply two matrices -Vladimir Nesterovsky;
;;;----------------------------------------------------;
(defun matrix:mxm (m q)
  "�������"
  (mapcar (function (lambda (r) (matrix:mxv (matrix:trp q) r))) m)
)
