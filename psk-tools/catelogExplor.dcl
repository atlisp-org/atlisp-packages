catelogExplor : dialog {
  label = "�����豸";
  :row {
    :popup_list {
      label = "Ŀ¼�ļ�";
      key = "CATELOG";
      edit_width = 24;
      fixed_width = true;
    }
  }
  :boxed_column {
    :row {
    :list_box {
        key = "KEYLIST";
        width = 120;
        height = 25;
        fixed_height = true;
        fixed_width = true;
        tabs = "10 20 30 40 50 60 70 80 90 100 110 120";
        tab_truncate = true;
      }
    }
  }
  :row {
   :ok_button {
    key="OK";
    label="ȷ��(&O)";
   }
   :cancel_button {
    key="CANCEL";
    label="ȡ��";
   }
  }
}

catelogExplor2 : dialog {
  label = "�����豸";
  :row {
    :popup_list {
      label = "Ŀ¼�ļ�";
      key = "CATELOG";
      edit_width = 40;
      fixed_width = true;
    }
  }
  :row {
  :boxed_column {
    label = "�����б�";
    :list_box {
        key = "KEYLIST";
        width = 30;
        height = 25;
        fixed_height = true;
        fixed_width = true;
      }
   }
  :boxed_column {
    label = "��ϸ����";
    :list_box {
        key = "PROPLIST";
        width = 55;
        height = 15;
        fixed_height = true;
        fixed_width = true;
        tabs = "20";
        tab_truncate = true;
        }
    :image {
        key = "IMG";
        color = 0;
        width = 30;
        height = 10;
        fixed_height = true;
        fixed_width =true;
        }
    }
  }
  :row {
   :ok_button {
    key="OK";
    label="����(&I)";
   }
   :cancel_button {
    key="CANCEL";
    label="ȡ��";
   }
  }
}