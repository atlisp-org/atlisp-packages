progressDlg : dialog {
  label = "����";
  
    :row {
    :list_box {
        key = "LIST";
        width = 60;
        height = 15;
        fixed_height = true;
        fixed_width = true;
      }
    }
    
   :ok_button {
    key="OK";
    label="����";
   }

      :cancel_button {
    label="�ر�";
   }
}

aboutDialog : dialog {
  label = "����PSK";
  
    :row {
    :list_box {
        key = "LIST";
        width = 90;
        height = 30;
        fixed_height = true;
        fixed_width = true;
      }
    }
   :cancel_button {
    label="�ر�";
   }
}


ductCreateDialog : dialog {
  label = "��������";
  
    :row {
    :list_box {
        key = "A";
        width = 10;
        height = 15;
        fixed_height = true;
        fixed_width = true;
      }
    :list_box {
        key = "B";
        width = 10;
        height = 15;
        fixed_height = true;
        fixed_width = true;
      }
    }
   :cancel_button {
    label="�ر�";
   }
}