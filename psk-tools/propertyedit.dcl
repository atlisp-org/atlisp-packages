PropertyEdit:dialog
{
	label = "���Ա༭";

	:row {
			:boxed_row {
				label = "�����б�";
				:list_box {
				key = "PROP_LIST";
				fixed_height = true;
				fixed_width =true;
				width = 51;
				height = 25;
				tabs = "25 48";
				tab_truncate = true;
				multiple_select = false;
			}
		}

		:boxed_column {
			label = "ֵ";
			fixed_height = true;
			fixed_width =true;
			alignment = top;
			
			:edit_box {
				key = "VALUE_TEXT";
				width = 30;
			}
			
			:list_box {
				key = "VALUE_LIST";
				fixed_height = true;
				fixed_width =true;
				height = 20;
				width = 30;
			}
			: text {
				key = "VALUE_INFO";
				label="";
				width = 30;
				height = 5;
			}
		}
	}

	:row {
		:button {
			key="OK";
			label="ȷ��(&O)";
			fixed_width = true;
			width = 12;
			is_default = true;
		}
		:button {
			label="ȡ��";
			fixed_width = true;
			width = 12;
			is_cancel = true;
		}
	}
}


psk_createpath:dialog
{
	label = "����·��";

	:row {
			:boxed_row {
				label = "�����б�";
				:list_box {
				key = "PROP_LIST";
				fixed_height = true;
				fixed_width =true;
				width = 51;
				height = 25;
				tabs = "25 48";
				tab_truncate = true;
				multiple_select = false;
			}
		}

		:boxed_column {
			label = "ֵ";
			fixed_height = true;
			fixed_width =true;
			alignment = top;
			
			:edit_box {
				key = "VALUE_TEXT";
				width = 30;
			}
			
			:list_box {
				key = "VALUE_LIST";
				fixed_height = true;
				fixed_width =true;
				height = 20;
				width = 30;
			}
			: text {
				key = "VALUE_INFO";
				label="";
				width = 30;
				height = 5;
			}
		}
	}

	:row {
		:button {
			key="OK";
			label="ȷ��(&O)";
			fixed_width = true;
			width = 12;
			is_default = true;
		}
		:button {
			key="FETCH";
			label="������·����ȡ(&G)";
			fixed_width = true;
			width = 12;
		}
		:button {
			key="DUCTV";
			label="��������";
			fixed_width = true;
			width = 12;
		}
		:spacer_0 {}
		:button {
			label="ȡ��";
			fixed_width = true;
			width = 12;
			is_cancel = true;
		}
	}
}


psk_selectbox:dialog
{
label = "ѡ���б�";

: column {
  : edit_box { key = "FILTER"; width = 40; }
  : list_box {
  key = "LIST";
  fixed_height = true;
  fixed_width =true;
  width = 40;
  height = 25;
  tab_truncate = true;
  multiple_select = false;
  is_default = true;
  }
}

: row {
  :button { key="OK"; label="ȷ��(&O)"; fixed_width = true; width = 12; is_default = true;}
  :button { label="ȡ��"; fixed_width = true; width = 12; is_cancel = true; }
}
}