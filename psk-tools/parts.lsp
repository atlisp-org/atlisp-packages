;; KEY��ΪATTACH �ڹ�����(1�����ӵ�)
;;        INLINE �ڹ�����(2�����ӵ�)
;;        END �ڹܶ�(1�����ӵ�)
;; INLINE���ͱ����ṩLֵ����ָ�ܼ��ڹܵ�������ռ�õĳ���
(("DUCT-STOR"
   ("TYPE" . "INLINE")
   ("KEY" . "DUCT-STOR-{W}x{H}/{D}-{L}")
   ("DESC" . "��Բ�侶")
   ;; ����KEY�������õĲ���
   ("PARAM"
     ("W" 1070 "����ܿ��")
     ("H" 1070 "����ܸ߶�")
     ("D" 1070 "Բ���ֱ��")
     ("L" 1040 "�侶����")
   )
   ;; ��ͼ���õĲ���
   ("DRAWER" (psk-draw-stor "W" "D" "L" $PSK-DUCT-FLEXTEND))
   ("BOM")
 )
  ("AXIAL-FAN"
    ("TYPE" . "INLINE")
    ("KEY" . "AXIAL-FAN-{D}-{L}")
    ("DESC" . "�������")
    ("PARAM"
      ("D" 1040 "���ֱ��")
      ("L" 1040 "�������")
    )
    ("DRAWER" (psk-draw-fan "L" "D"))
  )
  ("FDC"
    ("TYPE" . "INLINE")
    ("KEY" . "FDC-70-{W}x{H}-{L}")
    ("DESC" . "���շ���")
    ("PARAM"
      ("W" 1070 "����ܿ��")
      ("H" 1070 "����ܸ߶�")
      ("L" 1040 "���峤��")
    )
    ("DRAWER" (psk-draw-firedamper-c "L" "W" $PSK-DUCT-FLEXTEND))
  )
  ("FDO"
    ("TYPE" . "INLINE")
    ("KEY" . "FDO-70-{W}x{H}-{L}")
    ("DESC" . "��������")
    ("PARAM"
      ("W" 1070 "����ܿ��")
      ("H" 1070 "����ܸ߶�")
      ("L" 1040 "���峤��")
    )
    ("DRAWER" (psk-draw-firedamper-o "L" "W" $PSK-DUCT-FLEXTEND))
  )
;;;  ("CAP"
;;;    ("TYPE" . "END")
;;;    ("KEY" . "")
;;;    ("DESC" . "ä��")
;;;    ("PARAM"
;;;      ("A" 1070 "��")
;;;      ("B" 1070 "ֱ��")
;;;    )
;;;    ("DRAWER" psk-draw-rectangle ("A" "B"))
;;;  )
  ("DUCT-END"
    ("TYPE" . "END")
    ("KEY" . "")
    ("DESC" . "��ܷ�ͷ")
    ("PARAM"
      ("W" 1070 "����ܿ��")
      ("H" 1070 "����ܸ߶�")
    )
    ("DRAWER" (psk-draw-ductend "W" $PSK-DUCT-FLEXTEND))
  )
  ("CV"
    ("TYPE" . "INLINE")
    ("KEY" . "CV")
    ("DESC" . "ֹ�ط�")
    ("PARAM"
      ("W" 1070 "����ܿ��")
      ("H" 1070 "����ܸ߶�")
      ("L" 1070 "���峤��")
    )
    ("DRAWER" (psk-draw-checkvalve "L" "W" $PSK-DUCT-FLEXTEND))
  )
  ("DAMPERVALVE"
    ("TYPE" . "INLINE")
    ("KEY" . "DAMPERVALVE")
    ("DESC" . "���ڷ�")
    ("PARAM"
      ("W" 1070 "����ܿ��")
      ("H" 1070 "����ܸ߶�")
      ("L" 1070 "���峤��")
    )
    ("DRAWER" (psk-draw-dvalve "L" "W" $PSK-DUCT-FLEXTEND))
  )
  ("DDAMPERVALVE"
    ("TYPE" . "INLINE")
    ("KEY" . "DAMPERVALVE")
    ("DESC" . "��Ҷ���ڷ�")
    ("PARAM"
      ("W" 1070 "����ܿ��")
      ("H" 1070 "����ܸ߶�")
      ("L" 1070 "���峤��")
    )
    ("DRAWER" (psk-draw-ddvalve "L" "W" $PSK-DUCT-FLEXTEND))
  )
  ("ND"
    ("TYPE" . "INLINE")
    ("KEY" . "ND")
    ("DESC" . "������")
    ("PARAM"
      ("W" 1070 "����ܿ��")
      ("H" 1070 "����ܸ߶�")
      ("L" 1070 "����������")
    )
    ("DRAWER" (psk-draw-noisereducer "L" "W" $PSK-DUCT-FLEXTEND))
  )
  ("SS"
    ("TYPE" . "ATTACH")
    ("KEY" . "PSK-SS{A}X{B}")
    ("DESC" . "�����Ҷ���")
    ("PARAM"
      ("A" 1070 "��ڳ���")
      ("B" 1070 "��ڿ��")
    )
    ("DRAWER" (psk-draw-singleshutter "A" "B"))
  )
  ("DS"
    ("TYPE" . "ATTACH")
    ("KEY" . "PSK-DS{A}X{B}")
    ("DESC" . "˫���Ҷ���")
    ("PARAM"
      ("A" 1070 "��ڳ���")
      ("B" 1070 "��ڿ��")
    )
    ("DRAWER" (psk-draw-doubleshutter "A" "B"))
  )
;;;  ("FL-PL"
;;;    ("TYPE" . "INLINE")
;;;    ("KEY" . "FL-PL-{PN}-{DN}")
;;;    ("DESC" . "��ʽƽ������")
;;;    ("SIZEFILE" . "Flange PN.csv")
;;;    ("PARAM"
;;;      ("PN" 1000
;;;	    "����ѹ���ȼ�"
;;;	    ""
;;;	    ("0.25" "1.0" "1.6" "2.5" "4.0")
;;;      )
;;;      ("DN" 1070 "��������ֱ��" "" ())
;;;;;;		    ("OD" "�����⾶")
;;;;;;		    ("L" "�������")
;;;    )
;;;    ("DRAWER" psk-draw-rectangle ("L" "OD"))
;;;  )
)