(@:define-config '@curve:optimize-angle 0.0001 "���Ż�����ߵļнǲ")
(defun at-curve:optimize-lwpl (/ optimize-lwpl)
  (@:help '("�Ż�����߶��㡣��������㹲�߻�Բʱ�����ٶ��㡣"))
  (setq lwpls (pickset:to-list(ssget '((0 . "lwpolyline")))))
  (mapcar 'curve:optimize-lwpl lwpls))

