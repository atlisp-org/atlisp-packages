(("FL-PL"
   ("TYPE" . "INLINE")
   ("KEY" . "FL-PL-{PN}-{DN:0}")
   ("DESC" . "��ʽƽ������")
   ("SIZEFILE" . "sizes\\Flange PN.csv")
   ("PARAM"
     ("PN" 1000
           "����ѹ���ȼ�"
           ""
           ("2.5" "6" "10" "16" "25" "40")
     )
     ("DN" 1070 "��������ֱ��" "" ())
     ("OD" "�����⾶")
     ("L" "�������")
   )
   ("DRAWER" (psk-draw-rectangle "L" "OD"))
 )
  ("GV41T-16"
    ("TYPE" . "INLINE")
    ("KEY" . "GV41T-16-{DN:0}")
    ("DESC" . "������ֹ�� J41T-16")
    ("SIZEFILE" . "sizes\\J41T-16.csv")
    ("DRAWER" (psk-draw-global-valve-top "L" "D" "D0"))
  )
  ("BV71X-16"
    ("TYPE" . "INLINE")
    ("KEY" . "BV71X-16-{DN:0}")
    ("DESC" . "�����Լе��� D71X-16")
    ("SIZEFILE" . "sizes\\D71X-16.csv")
    ("DRAWER" (psk-draw-global-valve-top "L" "D" "L0"))
  )
)