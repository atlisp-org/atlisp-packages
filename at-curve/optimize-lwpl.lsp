(@:define-config '@curve:optimize-angle 0.001 "���Ż�����ߵļнǲ")
(defun at-curve:optimize-lwpl (/ optimize-lwpl)
  (@:help '("�Ż�����߶��㡣��������㹲�߻�Բʱ�����ٶ��㡣"))
  (setq tmp-fuzz (@:get-config '@curve:optimize-angle))
  (setq lwpls (pickset:to-list(ssget '((0 . "lwpolyline")))))
  (mapcar 'curve:optimize-lwpl lwpls))

