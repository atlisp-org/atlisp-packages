
;;(vl-Load-COM)
;�����Ͻ�ȥ�ĳ����·��
;(setq path(try-tuo-path))
;; (defun try-tuo-path-G(/ path str)
;; 	;;;��ȡ��װ·��
;; 	(princ "\n")
;; 	(setq path (getvar "lastprompt"))
;; 	(if (wcmatch (strcase path) "*(LOAD \"*")
;; 		(setq str (vl-string-search "(LOAD \"" path)
;; 			path (substr path (+ str 8) (- (vl-string-search "\")" path) str 7))
;; 		)
;; 	)
;; 	(princ path)
;; 	(princ "\n")
;; 	(if (and path (setq path (vl-string-translate "/" "\\" (vl-filename-directory path))))
;; 		path
;; 	)	
;; 	path
;; )
;���ܣ����cad����·��(ǰ���)��
;������newpathΪ����·����mode��"L"Ϊǰ��"R"Ϊ��
;����ֵ��·���б�
;; (defun xyp-Path-Add (path mode)
;;   (setenv "ACAD"
;; 	  (cond	((or (= mode "R") (not mode))
;; 						(strcat (getenv "ACAD") ";" path )
;; 					)
;; 			(T (strcat path ";" (getenv "ACAD")))
;; 	  )
;;   )
;; )
;; ;;����ʼ
;; (setq path(try-tuo-path-G))
;; (if (= ":"(substr path 2 1))
;; 	(progn
;; 		(xyp-Path-Add path "L")
;; 		(prompt "\n�ɹ��Ϸ�����ļ�֧������·��")
;; 	)
;; 	(prompt "\n������ֻ��ͨ���϶������أ����ֶ�����ļ�֧������·��")	
;; )
;;;******************************************************
;;;******************************************************
;;;OpenDcl��������                                      *
;;;BlockView ͼ��&ͼ��Ԥ������                          *
;;;��ʽ��� ShenHung                                    *
;;;��ʽ����                                             *
;;;2013,04,04 V1.0                                      *
;;;2019-08-22 V2.0 ������ OPENDCL V9.0                  *
;;;******************************************************
;;;����                                                 *
;;;BlockView ͼ�����                                   *
;;;DwgView   ͼ������                                   *
;;------------------------------------------------------*
;;;PGP���趨��������                                    *
;;;BV,           *BlockView                             *
;;;DV,           *DwgView                               *
;;;******************************************************
;;;AUTOCAD ѡ��.֧Ԯ����Ѱ·��.����� V2.0 Ŀ¼·��  
;;;                                          
;; (defun C:B8()(c:DwgVIew));;��ǰdwg�е�ͼ�����
;; (defun C:B7()(c:BlockView));;ѡdwg�ļ����в���
;; (prompt "\n***ָ����: ѡdwg�ļ����в�  B7 ***")
;; (prompt "\n***ָ����: ��ǰdwg�е�ͼ����� B8 ***")
;; (vl-load-com)
;; (setq BVPATH  (vl-filename-directory (findfile "Blockview.lsp")))
;---------------------------------------------------------------------------
;(prompt "\n***ָ����: BlockView ͼ��Insert ***")
;(prompt "\n***ָ����: DwgView   ͼ��Insert ***")
(defun c:BlockView (/ cmdecho)
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	;; (Opendcl:ArxLoad)
	(setvar "CMDECHO" cmdecho)
	(if dcl-form-show
		(progn
			(dcl-Project-Load  (strcat @:*prefix* "packages\\block-view\\BlockView.odcl"))
			(setq intshow (dcl-Form-Show BlockView/Form )) ;intshow Ϊclose �Ի�����.ȡ�õķ���ֵ.BlockView/Form
			)
		(prompt "\n����汾 AutoCad ��֧Ԯ BlockView ����")
		)
	(cond 
		((= intshow 1) (c:dwgview));����ֵΪ1.����ͼ������
		((= intshow 2) (BlockView:insert));����ͼ��
	)      
	(princ)
)
;------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------
;--DWG VIEW ͼ��Ԥ������-------------------------------------------------------------------
;------------------------------------------------------------------------------------------
;Main progeam------------------------------------------------------------------------------
(defun c:DwgVIew (/ cmdecho)
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	;; (Opendcl:ArxLoad)
	(setvar "CMDECHO" cmdecho)
	(if dcl-form-show
		(progn
			(dcl-Project-Load  (strcat  @:*prefix* "packages\\block-view\\BlockView.odcl"))
			(setq intshow (dcl-Form-Show     BlockView/DwgForm)) ;intshow Ϊ�Ի���Close ����ֵ.�� dcl-from-close ��ָ��.
		)                                                    ;(dcl-Form-close     BlockView/DwgForm 1 )  1Ϊ����ֵ~
		(prompt "\n����汾 AutoCad ��֧Ԯ DwgView ����")
	)
	;(if (= intshow 1) (DwgView:insert)) ;����ͼ��.
	(princ)
)
;;BlockView_��ʼ���趨-----------------------------------------------------
(defun c:BlockView/Form#OnInitialize (/)
	(dcl-LISTBOX-CLEAR BlockView/Form/BlockList)
	(setq BlkName_List nil unBlkName_List nil)
	;(dcl-Control-SetEnabled BlockView/Form/PickFile l)
	(if (<= (SUBSTR (GETVAR "ACADVER") 1 2) "18") ;2010����
		(BlockView->stbla-1);ȡ��ͼ��(vla)
		(BlockView->stbla  );ȡ��ͼ��(��ͳ)
	)  
	(setq   BlkName_List (Blockview_trans_list tbl_list))  ;ת��30��1��Ĵ���
	(setq UnBlkName_List (Blockview_trans_list tbl_UnName_List))
	(if (or (= (length   BlkName_List) 0)    ;����1�� Option ������0
				(= (length UnBlkName_List) 0)  
	    )	
		(dcl-Control-SetEnabled BlockView/Form/OptionList nil)  ; �ر�ʵ��/����ѡ��
		(dcl-Control-SetEnabled BlockView/Form/OptionList T)		
	)	
	;(if (= Dwg_page_inx 0) (dcl-Control-SetEnabled BlockView/DwgForm/UpPage1   nil)) ;ҳ����Ϊ0.��һҳ��
	;(if (= Dwg_page_inx (1- Dwg_page_n)) (dcl-Control-SetEnabled BlockView/DwgForm/NextPage1   nil)) ;ҳ����Ϊ����.��һҳ��
	;(if (or(null dwg_page_inx)(zerop dwg_page_inx))
	;	(progn
	;		(dcl-Control-SetEnabled BlockView/DwgForm/UpPage1 nil)
	;		(dcl-Control-SetEnabled BlockView/DwgForm/NextPage1 nil)
	;	)
	;)
	;; �趨BlockName_Value-��ʼ-------------------------------------------------------
	(if (null curBlockName_value)
		(cond ((/= (length BlkName_List) 0)
						(setq curBlockName_value "ʵ��ͼ��")
						(dcl-Control-SetCurrentSelection BlockView/Form/OptionList 0)
						(setq BlkName_all tbl_list)
						(setq block_list_all blkname_list)
					)
		  ((/= (length UNBlkName_List) 0)
				(setq curBlockName_value "����ͼ��")
				(dcl-Control-SetCurrentSelection BlockView/Form/OptionList 1)
				(setq BlkName_all tbl_UnName_list)
				(setq block_list_all UnBlkname_List)
		  )
		)
		(progn
	    (cond ((= CurBlockName_value "ʵ��ͼ��")
							(setq BlkName_all tbl_list)
							(setq block_list_all blkname_list)
						)
				((= CurBlockName_value "����ͼ��")
					(setq BlkName_all tbl_UnName_list)
					(setq block_list_all UnBlkname_List)
				) 
			);cond		  
		)  ;progn
	)
	(dcl-ListBox-Clear      BlockView/Form/BlockList)
	(dcl-LISTBOX-ADDList    BlockView/Form/BlockList BlkName_all)
	(dcl-Control-SetEnabled BlockView/Form/UpPage   nil)
	(dcl-Control-SetEnabled BlockView/Form/NextPage nil)
	(if (null blk_x_sc)     (dcl-Control-SetText BlockView/Form/x-sc "1"))
	(if (null blk_y_sc)     (dcl-Control-SetText BlockView/Form/y-sc "1"))
	(if (null blk_explode ) (setq blk_explode 0))
	;�ֽ�
	(if (= blk_explode 0) ;�ֽⲻ��
		(dcl-Control-SetEnabled BlockView/Form/y-sc T)
		(dcl-Control-SetEnabled BlockView/Form/y-sc nil)
	)
	(if (null CurBlk_name)
		(dcl-Control-SetEnabled BlockView/Form/PreView nil)
		(dcl-Control-SetEnabled BlockView/Form/PreView T)
	)
	(BlockView_image_clear) ; ���image
	(if (or tbl_list tbl_UnName_List);;;;;66
		(BlockView_BlockShow_Start)
		(progn
			(dcl-CONTROL-SetCaption BlockView/Form/error "")
			(dcl-CONTROL-SetCaption BlockView/Form/BlockTile  (strcat "ͼ���б�->Ŀǰͼ��û��ͼ��"))
		)  
	)
)
;;-------------------------------------------------------------------------------------
(defun BlockView_image_clear(/ $i $j key_index)
	(setq $i 0 $J 1) ;��ʼ
	(repeat 30     ;���Image����
		(setq key_index (itoa $j))
		(dcl-CONTROL-SetCaption   (eval (read (strcat "BlockView/Form/Label"     key_index)))  "")
		(dcl-Control-SetBackColor (eval (read (strcat "BlockView/Form/BlockView" key_index))) -22)
		(setq $i (1+ $i) $j (1+ $j))
	)
)  
;;-------------------------------------------------------------------------------------
;;Block_List_pick-----------------------------------����--------Value=�㵽������-------
(defun c:BlockView/Form/BlockList#OnSelChanged (ItemIndexOrCount Value /)
	(setq curBlk_name Value) 
	(setq $bk_Page_inx (/ ItemIndexOrCount 30))
	(setq $bk_list_inx (VL-POSITION value (nth $bk_page_inx block_List_all)))
	(dcl-CONTROL-SetCaption BlockView/Form/error  (strcat "ͼ������: " Value))
	(cond ((= $bk_page_inx block_page_inx) ;��ȡĿǰҳ
					(if old_key_inx (dcl-Control-SetBackColor (eval (read (strcat "BlockView/Form/BlockView" (itoa Old_key_inx)))) -22))
					(dcl-Control-SetBackColor                 (eval (read (strcat "BlockView/Form/BlockView" (itoa (1+ $bk_list_inx))))) 151)
					(setq old_key_inx (1+ $bk_list_inx))
				)	
		(T
			(BlockView_image_clear) ; ���image
			(setq block_page_inx $bk_page_inx)
			(BlockView_BlockShow_Start)
			(if old_key_inx (dcl-Control-SetBackColor (eval (read (strcat "BlockView/Form/BlockView" (itoa Old_key_inx )))) -22))
			(dcl-Control-SetBackColor                 (eval (read (strcat "BlockView/Form/BlockView" (itoa (1+ $bk_list_inx))))) 151)
			(setq old_key_inx (1+ $bk_list_inx))
		)
	)       
)
;;�л�ʵ��ͼ�������ͼ��--------------------------------------------------
(defun c:BlockView/Form/OptionList#OnSelChanged (ItemIndexOrCount Value /)
  (setq curBlk_Name nil) ;�л���.ĿǰBlk_name��Ϊnil
  (dcl-Control-SetEnabled BlockView/Form/PreView nil)
  (dcl-CONTROL-SetCaption BlockView/Form/Error "") ;Error_Tile Clear
  (setq old_curBlockName_Value CurBlockName_value)
  (setq curBlockName_value value)
  (setq curBlockName_Index ItemIndexOrCount)
  (cond ((and (= ItemIndexOrCount 0) (= Old_curBlockName_Value "����ͼ��")) ;ѡ��ʵ��ͼ��
					(BlockView_image_clear) ; ���image
					(setq  block_page_inx 0)
					(dcl-ListBox-Clear   BlockView/Form/BlockList)
					(dcl-LISTBOX-ADDList BlockView/Form/BlockList tbl_List)
					(setq  block_list_all blkname_list)
					(setq BlkName_all Tbl_list)
					(if blkname_list (BlockView_BlockShow_Start))
				)
		((and (= ItemIndexOrCount 1) (= Old_curBlockName_Value "ʵ��ͼ��")) ;ѡ������ͼ��.
			(BlockView_image_clear) ; ���image
			(setq  block_page_inx 0)
			(dcl-ListBox-Clear   BlockView/Form/BlockList)
			(dcl-LISTBOX-ADDList BlockView/Form/BlockList tbl_UnName_List)
			(setq block_list_all unblkname_list)
			(setq BlkName_all Tbl_UnName_list)
			(if unblkname_list (BlockView_BlockShow_Start))
		)
		(T (dcl-CONTROL-SetCaption BlockView/Form/Error "�ظ���ȡ,���л���һ��"))
  )
  (if old_key_inx  (dcl-Control-SetBackColor  (eval (read (strcat "BlockView/Form/BlockView" (itoa old_key_inx ))))   -22)) ;���Image Sel HighLight
)  
;--���밴ť-------------------------------------------------------------------
(defun c:BlockView/Form/ok#OnClicked (/)
  (setq blk_x_sc    (dcl-Control-GetText     BlockView/Form/x-sc))
  (setq blk_y_sc    (dcl-Control-GetText     BlockView/Form/y-sc))
  (setq blk_explode (dcl-Control-GetValue BlockView/Form/Explode)) ;�ٴ�ȡ�÷ֽⰴť��ֵ
  (dcl-Form-close  BlockView/Form 2)   ;���뷵��ֵ��Ϊ 2
)
;(setq curdwg_name   (dcl-DWGPreview-GetDwgName   (eval (read (strcat "BlockView/DwgForm/ViewDwg"   (itoa $$inx)))))) ;����·������
;(setq LabelDwg_name (dcl-Control-getCaption      (eval (read (strcat "BlockView/DwgForm/Label"     (itoa $$inx)))))) ;����
;;;����ͼ��--------------------------------------------------------
(defun BlockView:insert()
  (setvar "cmdecho" 0)
  (if (and curblk_name(/= curblk_name ""));;;����
		(while  (setq ipt (getpoint "\n�����:"))
			(cond ((= CurBlockName_value "����ͼ��")
							(BlockView_MakeInsert)
							(prompt "\n��ת�Ƕ�:")
							(command "rotate" "l" "" ipt pause)
						)
				((or (= blk_explode 0)(= blk_explode nil))
	        (command "-insert" curblk_name ipt blk_x_sc blk_y_sc pause)
				)
				((= blk_explode 1)  ;����
	        (command "-insert" (strcat "*" curblk_name) ipt blk_x_sc "0")
				)
			)
		) ;while
		(DCL-MESSAGEBOX (strcat "***����ѡȡͼ��***") "ͼ��ѡȡ")
  ) ;if 
  (setvar "cmdecho" 1)
  (princ)
)
;-BlockView_MAKE_INSERT-�����������---------------------------
(defun BlockView_MakeInsert()
	(entmake (list (cons 0 "INSERT")
						 (cons 2 Curblk_name)
						 (cons 10 (trans ipt 1 0))
						 (cons 41 (atof Blk_x_sc))
						 (cons 42 (atof Blk_y_sc))
						 (cons 43 1)
					 )
	)
	(ENTMAKE '((0 . "SEQEND")))
)  
;-------------------------------------------------------------
;;--ȡ����ť--------------------------------------------------
(defun c:BlockView/Form/cancel#OnClicked (/)
	(dcl-Form-close  BlockView/Form)
)
;----�ֽⰴť-------------------------------------------------
(defun c:BlockView/Form/Explode#OnClicked (ExpValue /)
  (setq blk_explode ExpValue)
  (if (= blk_explode 0) ;�ֽⲻ��
		(dcl-Control-SetEnabled BlockView/Form/y-sc T)
		(dcl-Control-SetEnabled BlockView/Form/y-sc nil)
  )  
)
;�ȱ�����ť-----------------------------------------------------------------
(defun c:BlockView/Form/same-sc#OnClicked (/)
	(setq blk_x_sc (dcl-Control-GetText BlockView/Form/x-sc))
	(setq blk_y_sc blk_x_sc)
	(dcl-Control-SeTText BlockView/Form/y-sc Blk_y_sc)
)
;--�Ŵ�Ԥ������--------------------------------------------
(defun c:BlockView/Form/PreView#OnClicked (/)  ;open PreView Form
	(dcl-Form-Show     BlockView/PreViewScale)
)  
(defun c:BlockView/PreViewScale#OnInitialize (/)  ; ��ʼ���趨 show blockVIew
	(dcl-BlockView-Clear       BlockView/PreviewScale/blockView)
	(dcl-Control-SetBlockName  BlockView/PreViewScale/BlockView Curblk_name)
	(dcl-CONTROL-SetCaption    BlockView/PreviewScale/Frame (strcat "ͼ������: " curblk_Name))
)
(defun c:BlockView/PreViewScale/cancel#OnClicked (/)  ;close Form
	(dcl-Form-close     BlockView/PreViewScale)
)
;;;ȡ��Ŀǰͼ������ͼ��.��ת����Block Show Ԥ��������̬------
;(WCMATCH tbl_name "`*U*,`*D*,`*X*,`*T*,_*,*|*,A$*")---------
;--vlax-tblsearch--------------------------------------------
; ʵ�� tbl_list  ���� tbl_UnName_list                        
;------------------------------------------------------------
(defun Blockview->stbla ()
  (setq lay nil lays nil)
  (setq tbl_list '() tbl_UnName_list '())
  (while (setq lay (tblnext "block" (not lay)))
		(if (not (wcmatch (cdr(assoc 2 lay)) "`*U*,`*D*,`*X*,`*T*,_*,*|*,`**"))
			(setq tbl_list (append tbl_list (list (cdr (assoc 2 lay)))))
			(if (NOT (WCMATCH (cdr(assoc 2 lay)) "`*D*,`*X*,`*T*,_*,*|*,*PAPER_SPACE,*MODEL_SPACE"))
				(setq tbl_unName_list (append tbl_unName_list (list (cdr (assoc 2 lay)))))
			)  
		)	 
  )
  (if tbl_list (setq tbl_list (acad_strlsort tbl_list)))
  (if tbl_UnName_list (setq tbl_UnName_list (acad_strlsort tbl_UnName_list)))
)
;---------------------------------------------------------------------
(defun BlockView->stbla-1 ( / *acadobj* *dwgobj* *tblobj* tbl_name)
  (setq *acadobj* (vlax-get-acad-object))
  (setq *dwgobj*  (vla-get-activedocument *acadobj*))
  (setq *tblobjs* (vla-get-blocks *dwgobj*))
  (setq tbl_list '() tbl_UnName_list '())
  (vlax-for xobj *tblobjs*
		(setq tbl_name (vla-get-name xobj))
		(IF (NOT (WCMATCH tbl_name "`*U*,`*D*,`*X*,`*T*,*|*,`**"))
			(if (/= tbl_name "") (setq tbl_list (cons tbl_name tbl_list)))
			(if (NOT (WCMATCH (strcase tbl_name) "`*D*,`*X*,`*T*,*|*,*PAPER_*,*MODEL_*"))
		    (setq tbl_UnName_list (cons tbl_name tbl_UnName_list))
			)  
		)  
  )
  (if tbl_list (setq tbl_list (acad_strlsort tbl_list)))
  (if tbl_UnName_list (setq tbl_UnName_list (acad_strlsort tbl_UnName_list)))
)
;---ͼ��ת��Ϊ30��һ��Ĵ���-----------------------------------------------------------
(defun Blockview_trans_list ($list_name / i j bk_lis $block_list_all)
	(if $list_name
		(progn
      (setq i 0 j 0 bk_lis '() $block_list_all '())
      (repeat (length $list_name)
	      (setq en_idx  (nth i $list_name))
	      (setq bk_lis (cons en_idx bk_lis))
	      (if (= j 29)
					(progn
						(setq $block_list_all (cons  (reverse bk_lis) $block_list_all))
						(setq j 0 bk_lis '())
					)
					(setq j (1+ j))
	      )
	      (setq i (1+ i))
      ) ;repeat	
		);progn
  );if 
  (if bk_lis (setq $block_list_all  (REVERSE (cons (reverse bk_lis) $block_list_all))))
  ;(if $block_list_all (REVERSE $block_list_all))
  (if $block_list_all $block_list_all)
)
;---------------------------------------------------
;Show Block to BlockView;---------------------------
;Block_page_n  ҳ�α���
(defun BlockView_BlockShow_Start ()
  (dcl-Control-SetEnabled BlockView/Form/UpPage   T)
  (dcl-Control-SetEnabled BlockView/Form/NextPage T)
  (if (null block_page_inx) (setq block_page_inx 0))
  (setq Block_page_n (length Block_list_all))
  (if (/= Block_page_n 0)
		(progn
      ;30 pcs Block SHow-------------------------------------------------------
      (BlockView_blockShow (nth block_page_inx Block_list_all))
      ;����ҳ��---------------------------------------------------------
      (if (= Block_page_inx 0) (dcl-Control-SetEnabled BlockView/Form/UpPage   nil)) ;ҳ����Ϊ0.��һҳ��
      (if (= Block_page_inx (1- Block_page_n)) (dcl-Control-SetEnabled BlockView/Form/NextPage   nil)) ;ҳ����Ϊ����.��һҳ��
      ;ͼ���б�
      (dcl-CONTROL-SetCaption BlockView/Form/BlockTile (strcat "ͼ���б� ��" (itoa Block_page_n ) "֮" (itoa (1+ Block_page_inx) ) "ҳ          ˫��ͼƬ�ɷŴ�Ԥ��"))
      (if old_key_inx (dcl-Control-SetBackColor  (eval (read (strcat "BlockView/Form/BlockView" (itoa old_key_inx )))) 151))
		) ;progn
  )  
)  
;-BlockView Block SHow                                      
(defun BlockView_BlockShow ($BlkName_List)
	(setq curBlkName_List $BlkName_List)
	(setq $i 0 $J 1)
	(repeat 30
		(setq key_index (itoa $j ))
		(if (< $i (length $BlkName_List))
			(progn
				(dcl-CONTROL-SETBLOCKNAME (eval (read (strcat "BlockView/Form/BlockView" key_index))) (nth $i $BlkName_List))
				(dcl-CONTROL-SetCaption   (eval (read (strcat "BlockView/Form/Label"     key_index))) (nth $i $BlkName_List))
			)
			(progn
				(dcl-BlockView-Clear      (eval (read (strcat "BlockView/Form/BlockView" key_index))) )
				(dcl-CONTROL-SetCaption   (eval (read (strcat "BlockView/Form/Label" key_index)))     "")
			)
		)	 
		(setq $i (1+ $i) $j (1+ $j))
	)
)
;��һҳ--------------------------------------------
(defun c:BlockView/Form/UpPage#OnClicked (/)
	(if old_key_inx  (dcl-Control-SetBackColor  (eval (read (strcat "BlockView/Form/BlockView" (itoa old_key_inx ))))   -22)) ;���Image Sel HighLight
	(setq block_page_inx (1- block_page_inx))
	(BlockView_blockShow (nth block_page_inx Block_list_all))
	(dcl-CONTROL-SetCaption BlockView/Form/BlockTile (strcat "ͼ���б� ��" (itoa Block_page_n ) "֮" (itoa (1+ Block_page_inx) ) "ҳ          ˫��ͼƬ�ɷŴ�Ԥ��"))
  (cond
  	((< 0 block_page_inx)
			(dcl-Control-SetEnabled BlockView/Form/UpPage T)  ;��һҳ��
			(dcl-Control-SetEnabled BlockView/Form/NextPage T);��һҳ��
		)
		((= 0 block_page_inx)
			(dcl-Control-SetEnabled BlockView/Form/UpPage nil)
			(dcl-Control-SetEnabled BlockView/Form/NextPage T)
		)
  )	
)
;��һҳ------------------------------------------
(defun c:BlockView/Form/NextPage#OnClicked (/)
	(if old_key_inx  (dcl-Control-SetBackColor  (eval (read (strcat "BlockView/Form/BlockView" (itoa old_key_inx ))))   -22)) ;���Image Sel HighLight
	(setq block_page_inx (1+ block_page_inx))
	(BlockView_blockShow (nth block_page_inx Block_list_all))
	(dcl-CONTROL-SetCaption BlockView/Form/BlockTile (strcat "ͼ���б� ��" (itoa Block_page_n ) "֮" (itoa (1+ Block_page_inx) ) "ҳ          ˫��ͼƬ�ɷŴ�Ԥ��"))
  (cond
  	((< block_page_inx (1- block_page_n))
			(dcl-Control-SetEnabled BlockView/Form/UpPage T)
			(dcl-Control-SetEnabled BlockView/Form/NextPage T)
		)
		((= block_page_inx (1- block_page_n))
			(dcl-Control-SetEnabled BlockView/Form/UpPage T)
			(dcl-Control-SetEnabled BlockView/Form/NextPage nil)
		)
  )	
)
;Pick Image Hightlight and Show BlockName to ErrorTile-------------------------------
(defun BlockView_ShowName ($$inx)
	(if old_key_inx  (dcl-Control-SetBackColor  (eval (read (strcat "BlockView/Form/BlockView" (itoa old_key_inx ))))   -22))
	(dcl-Control-SetBackColor  (eval (read (strcat "BlockView/Form/BlockView" (itoa $$inx )))) 151)
	(setq old_key_inx $$inx)
	(if (<= $$inx (length curBlkName_List))
		(progn  ;ȡ��blk_name
			(setq curblk_name (nth (1- $$inx) curBlkName_List))
			(dcl-CONTROL-SetCaption BlockView/Form/error  (strcat "ͼ������: " curblk_name))
			(setq $blkName_all_inx (VL-POSITION CurBlk_name BlkName_all))
			(dcl-ListBox-SetCurSel BlockView/Form/BlockList $BlkName_all_inx)
		)
		(progn  ;blockname = nil
			(setq curblk_name nil)
			(dcl-CONTROL-SetCaption BlockView/Form/error  "")
		)
	)
	;�Ŵ�Ԥ������---------
	(if (null CurBlk_name)
		(dcl-Control-SetEnabled BlockView/Form/PreView nil)
		(dcl-Control-SetEnabled BlockView/Form/PreView T)
	)  
)
;;;;;�������-����DwgView-----------------------------------------------
(defun c:BlockView/Form/PIckFile#OnClicked (/)
  (dcl-Form-close BlockView/Form 1)
)
;;BlockView_pick_show
;;0-5-----------------------------------------------------------------
(defun c:BlockView/Form/BlockView1#OnClicked  (/)(BlockView_showName 1))
(defun c:BlockView/Form/BlockView2#OnClicked  (/)(BlockView_showName 2))
(defun c:BlockView/Form/BlockView3#OnClicked  (/)(BlockView_showName 3))
(defun c:BlockView/Form/BlockView4#OnClicked  (/)(BlockView_showName 4))
(defun c:BlockView/Form/BlockView5#OnClicked  (/)(BlockView_showName 5))
;-6-10----
(defun c:BlockView/Form/BlockView6#OnClicked  (/)(BlockView_showName 6))
(defun c:BlockView/Form/BlockView7#OnClicked  (/)(BlockView_showName 7))
(defun c:BlockView/Form/BlockView8#OnClicked  (/)(BlockView_showName 8))
(defun c:BlockView/Form/BlockView9#OnClicked  (/)(BlockView_showName 9))
(defun c:BlockView/Form/BlockView10#OnClicked (/)(BlockView_showName 10))
;-11-15----
(defun c:BlockView/Form/BlockView11#OnClicked (/)(BlockView_showName 11))
(defun c:BlockView/Form/BlockView12#OnClicked (/)(BlockView_showName 12))
(defun c:BlockView/Form/BlockView13#OnClicked (/)(BlockView_showName 13))
(defun c:BlockView/Form/BlockView14#OnClicked (/)(BlockView_showName 14))
(defun c:BlockView/Form/BlockView15#OnClicked (/)(BlockView_showName 15))
;-16-20----
(defun c:BlockView/Form/BlockView16#OnClicked (/)(BlockView_showName 16))
(defun c:BlockView/Form/BlockView17#OnClicked (/)(BlockView_showName 17))
(defun c:BlockView/Form/BlockView18#OnClicked (/)(BlockView_showName 18))
(defun c:BlockView/Form/BlockView19#OnClicked (/)(BlockView_showName 19))
(defun c:BlockView/Form/BlockView20#OnClicked (/)(BlockView_showName 20))
;-20-25----
(defun c:BlockView/Form/BlockView21#OnClicked (/)(BlockView_showName 21))
(defun c:BlockView/Form/BlockView22#OnClicked (/)(BlockView_showName 22))
(defun c:BlockView/Form/BlockView23#OnClicked (/)(BlockView_showName 23))
(defun c:BlockView/Form/BlockView24#OnClicked (/)(BlockView_showName 24))
(defun c:BlockView/Form/BlockView25#OnClicked (/)(BlockView_showName 25))
;-26-30----
(defun c:BlockView/Form/BlockView26#OnClicked (/)(BlockView_showName 26))
(defun c:BlockView/Form/BlockView27#OnClicked (/)(BlockView_showName 27))
(defun c:BlockView/Form/BlockView28#OnClicked (/)(BlockView_showName 28))
(defun c:BlockView/Form/BlockView29#OnClicked (/)(BlockView_showName 29))
(defun c:BlockView/Form/BlockView30#OnClicked (/)(BlockView_showName 30))
(defun c:BlockView/Form/BlockView1#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView2#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView3#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView4#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView5#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView6#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView7#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView8#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView9#OnDblClicked (/) (dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView10#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView11#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView12#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView13#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView14#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView15#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView16#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView17#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView18#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView19#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView20#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView21#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView22#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView23#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView24#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView25#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView26#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView27#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView28#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView29#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))
(defun c:BlockView/Form/BlockView30#OnDblClicked (/)(dcl-Form-Show     BlockView_PreViewScale))

;;�Ի���.��ʼ��~
(defun c:BlockView/DwgForm#OnInitialize (/)		
	(dcl-Control-SetEnabled BlockView/DwgForm/UpPage1 nil)
	(dcl-Control-SetEnabled BlockView/DwgForm/NextPage1 nil)
  (dwgForm_dwg_clear) ;��� image
  (dcl-Control-SetCaption  BlockView/DwgForm/error "")
  (dcl-ListView-AddColumns BlockView/DwgForm/lst (list (list "��������" 0 150) (list "��С" 1 100) (list "����" 1 100)))
	;�����趨 
  (if (null blk_x_sc) (dcl-Control-SetText BlockView/DwgForm/x-sc "1"))
  (if (null blk_y_sc) (dcl-Control-SetText BlockView/DwgForm/y-sc "1"))
  (if (null dwgblk_explode ) (setq dwgblk_explode 1))
	;�ֽ�
	(if (= dwgblk_explode 0) ;�ֽⲻ��
		(dcl-Control-SetEnabled BlockView/DwgForm/y-sc T)
		(dcl-Control-SetEnabled BlockView/DwgForm/y-sc nil)
	)
	(IF (and curdwg_name (/= LabelDwg_name ""))
    (dcl-Control-SetCaption BlockView/DwgForm/error (strcat "ͼ������: " LabelDwg_name ".DWG"))
    (dcl-Control-SetCaption BlockView/DwgForm/error "")
	)
	;init
	(if (null curStrFolder) (setq curstrfolder (vl-string-right-trim "\\" (getvar "dwgprefix"))))
	(dcl-ComboBox-AddPath      BlockView/DwgForm/dir       CurstrFolder)
	(dcl-ComboBox-SelectString BlockView/DwgForm/dir       CurstrFolder)
	(dcl-Control-SetText       BlockView/DwgForm/DiskPath  CurstrFolder)
	(DwgForm_filllist CurstrFolder)
)
;-----------------------------------------------------------------------------------------------
(defun DwgForm_filllist ($strPath / lstFiles lstDir lstDwg)
  (setq dwg_list_all '() dwg_list '())
  (dcl-ListView-Clear BlockView/DwgForm/lst)
  (if (and (setq strPath (DwgForm_check_path $strPath))
				(or (< (strlen strPath) 4) (findfile (vl-string-right-trim "\\" strPath)))
				(setq lstFiles (append (setq lstDir (mapcar 'DwgForm_dir_info  (DwgForm_items_sort (vl-remove "." (vl-remove ".." (vl-remove "System Volume Information" (vl-directory-files strPath "*" -1)))))))
												 (setq lstDwg (mapcar 'DwgForm_file_info (DwgForm_items_sort (vl-directory-files strPath "*.dwg" 1)))))))
    (progn
      ;Dir Show
      (setq lstdir_len (length lstdir))
      (setq lstDwg_len (length lstdwg))
      (IF LstFileS (dcl-listview-filllist BlockView/DwgForm/lst lstFiles)) ;
			;DWG trans data Ϊ Сдdwg
      (setq $dwg_list (vl-directory-files strPath "*.dwg" 1))
      (foreach $dg $dwg_list (setq dwg_list (cons (strcat (vl-filename-base $dg) ".dwg") dwg_list)))
      (setq dwg_list (DwgForm_items_sort (reverse dwg_list))) ;sort
      ;dwg show
      (setq dwg_list_all (dwg_trans_list dwg_list))   ;ת��Ϊ16��1���LIST
      (dcl-Control-SetCaption BlockView/DwgForm/Dir_Tile (strcat  (itoa (length dwg_list)) " ��Dwg ����"))
      (if dwg_list (BlockView_dwgShow_start))
    ); progn
  ); if
); 
;;���View dwg image
(defun dwgForm_dwg_clear( / $i)
	(setq $i 0 old_dwgkey_inx nil)
	(repeat 16
		(dcl-DWGPreview-Clear     (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa (1+ $i))))))
		(dcl-Control-SetCaption   (eval (read (strcat "BlockView/DwgForm/Label"   (itoa (1+ $i))))) "")
		(dcl-Control-SetBackColor (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa (1+ $i))))) -22)
		(setq $i (1+ $i))
	)  
)
;---ͼ��ת��Ϊ16��һ��Ĵ���-----------------------------------------------------------
(defun Dwg_trans_list ($list_name / i j bk_lis $block_list_all )
	(if $list_name
		(progn
      (setq i 0 j 0 bk_lis '() $block_list_all '())
      (repeat (length $list_name)
	      (setq en_idx  (nth i $list_name))
	      (setq bk_lis  (cons  en_idx bk_lis))
	      (if (= j 15)
					(progn
						(setq $block_list_all (cons  (reverse bk_lis) $block_list_all))
						(setq j 0 bk_lis '())
					)
					(setq j (1+ j))
	      )
	      (setq i (1+ i))
			)	
		);progn
  )
  (if bk_lis (setq $block_list_all (reverse (cons (reverse bk_lis) $block_list_all))))
  (if $block_list_all $block_list_all)
)
;;;;
(defun BlockView_dwgShow_start()
  (dcl-Control-SetEnabled BlockView/DwgForm/UpPage1   T)
  (dcl-Control-SetEnabled BlockView/DwgForm/NextPage1 T)
  (if (null dwg_page_inx) (setq dwg_page_inx 0))
  (setq dwg_page_n (length dwg_list_all)) ;����
  (if (/= dwg_page_n 0)
		(progn
      ;16 pcs Block SHow-------------------------------------------------------
      (BlockView_DwgShow (nth Dwg_page_inx Dwg_list_all))
      ;����ҳ��---------------------------------------------------------
      (if (= Dwg_page_inx 0) (dcl-Control-SetEnabled BlockView/DwgForm/UpPage1   nil)) ;ҳ����Ϊ0.��һҳ��
      (if (= Dwg_page_inx (1- Dwg_page_n)) (dcl-Control-SetEnabled BlockView/DwgForm/NextPage1   nil)) ;ҳ����Ϊ����.��һҳ��
      ;ͼ���б�
      (dcl-CONTROL-SetCaption BlockView/DwgForm/DwgTile (strcat "ͼ���б� ˫��ͼƬ�ɷŴ�Ԥ��  ��" (itoa Dwg_page_n ) "֮" (itoa (1+ Dwg_page_inx) ) "ҳ"))
      (if old_Dwgkey_inx (dcl-Control-SetBackColor  (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa old_Dwgkey_inx )))) 151))
		) ;progn
  )  
)  
;;DWG_LIST SHOW          
;dwg_page_inx ;
;dwg_list_all ;
;curdwg_list ;Ŀǰ����list
(defun BlockView_Dwgshow ($curdwg_list)
	(dwgForm_dwg_clear) ;���image
	(setq $i 0)
	(if $curdwg_list
		(progn
			(repeat 16
				(if (< $i (length $curdwg_list))
					(progn
						(setq strCompleteFile (strcat strPath "\\" (setq $dwg_name (nth $i $curdwg_list))))
						(dcl-DWGPreview-LoadDwg (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa (1+ $i))))) strCompleteFile)
						(dcl-Control-SetCaption (eval (read (strcat "BlockView/DwgForm/Label"   (itoa (1+ $i)))))  (vl-filename-base $dwg_name))
					)
					(progn
						(dcl-DWGPreview-Clear   (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa (1+ $i))))))
						(dcl-Control-SetCaption (eval (read (strcat "BlockView/DwgForm/Label" (itoa (1+ $i))))) "") 
					)	 
				)
				(setq $i (1+ $i))
			) ;repeat
		);progn
		(dwgForm_dwg_clear);���image
	);if progn 
)  
;---------------------------------------------------------------------------------
(defun DwgForm_check_path (strPath)
  (if (/= (substr strPath (strlen strPath)) "\\")
    (setq strPath (strcat strPath "\\"))
  ); if
  strPath
)
;---------------------------------------------------------------------------------
(defun DwgForm_items_sort (lstItems)
  (vl-sort lstItems 'DwgForm_items_sortitems)
)
;---------------------------------------------------------------------------------
(defun DwgForm_items_sortitems (strItem1 strItem2)
  (< (strcase strItem1) (strcase strItem2))
)
;---------------------------------------------------------------------------------
(defun DwgForm_dir_info (strFile / strCompleteFile)
  (if (setq strCompleteFile (findfile (strcat strPath strFile)))
    (list (vl-filename-base strFile) 0 "" "")
  ); if
)
;---------------------------------------------------------------------------------
(defun DwgForm_file_info (strFile / strCompleteFile)
  (if (setq strCompleteFile (findfile (strcat strPath strFile)))
    (if (vl-file-directory-p strCompleteFile)
      (list (vl-filename-base strFile) 0 "" "")
      (list (vl-filename-base strFile) 1 (DwgForm_file_size strCompleteFile) (DwgForm_file_date strCompleteFile))
    ); if
  ); if
)
;---------------------------------------------------------------------------------
(defun DwgForm_file_size (strFile / reaSize)
  (setq reaSize (float (vl-file-size strFile)))
  (cond
    ((< reaSize 1024)                           (setq strSize (strcat (rtos reaSize 2 0) " B")))
    ((< (setq reaSize (/ reaSize 1024.0)) 1024) (setq strSize (strcat (rtos reaSize 2 0) " KB")))
    ((< (setq reaSize (/ reaSize 1024.0)) 1024) (setq strSize (strcat (rtos reaSize 2 2) " MB")))
    (   (setq reaSize (/ reaSize 1024.0))       (setq strSize (strcat (rtos reaSize 2 2) " GByte")))
  ); cond
  strSize
)
;---------------------------------------------------------------------------------
;;ͼ������״̬��..FILE-SYSTIME ��ش�NIL
(defun DwgForm_file_date (strFile / lstDate)
  (if (vl-file-systime strFile)
		(progn 
      (setq a strfile)	
      (setq lstDate (mapcar 'DwgForm_check_digit (mapcar 'itoa (vl-file-systime strFile))))
			; ��                 ��                  ��                  ʱ                  ��
			(setq file-date (strcat (nth 0 lstDate) "-" (nth 1 lstDate) "-" (nth 3 lstDate) " " (nth 4 lstDate) ":" (nth 5 lstDate)))
		)
		(setq file-date "Ŀǰͼ���༭��")
	)
	(if file-date file-date)
)
;---------------------------------------------------------------------------------
(defun DwgForm_check_digit (Value)
  (if (= (strlen Value) 1) (strcat "0" Value) Value)
)
;---------------------------------------------------------------------------------
(defun c:BlockView/DwgForm/Dir#OnSelChanged (ItemIndexOrCount Value /)
  (dcl-Control-SetText BlockView/DwgForm/DiskPath Value)
  (DwgForm_filllist Value)
)
;---------------------------------------------------------------------------------
(defun c:BlockView/DwgForm/UpPage#OnClicked (/)
	;���
	(dwgForm_dwg_clear) ;��� image
	(setq curdwg_name nil)
	(dcl-Control-SetCaption BlockView/DwgForm/error "")
	(setq dwg_page_inx 0) ;�ӵ�һҳ��ʼ
	;; 
  ;  (setq strFolder (dcl-ComboBox-GetDir BlockView/DwgForm/dir))  ;old
	(setq strfolder (dcl-Control-GetText BlockView/DwgForm/DiskPath))  ;v9.0 ����
  (if (setq lstChars (reverse (cdr (member 92 (reverse (vl-string->list strFolder))))))
    (progn
			;      (setq strFolder (apply 'strcat (mapcar 'chr lstChars)))
      (setq strfolder (vl-filename-directory (strcat strfolder ".dat"))) ;ȡ��Ŀ¼. ����.dat.ƭ����Ŀ¼Ϊһ��������.
      (dcl-ComboBox-AddPath BlockView/DwgForm/dir strFolder)
      (dcl-ComboBox-SelectString BlockView/DwgForm/dir       strFolder)
      (dcl-Control-SetText       BlockView/DwgForm/DiskPath  strFolder)
      (setq curstrFolder strFolder)
      (DwgForm_filllist strFolder)
    ); progn
  ); if
	; (DCL-MESSAGEBOX strFolder)
)
;;-����ListView-------------------------------------------------------------------
(defun c:BlockView/DwgForm/lst#OnClicked (Row Column / $dwg_pick_inx $dwg_page_inx $dwg_list_inx);555
  (setq Labeldwg_name   (dcl-ListView-GetItemText BlockView/DwgForm/lst Row 0))
  (setq strCompleteFile (findfile (strcat strPath Labeldwg_name ".dwg")))
  (if strCompleteFile
		(progn
      (dcl-Control-SetCaption BlockView/DwgForm/error (strcat "ͼ������: " LabelDwg_name ".DWG"))
      (setq curdwg_name strCompleteFile)
			;ѡ��ͼ��.Image �����л�.
			(setq $dwg_pick_inx (- row lstdir_len)) ;ѡ�������
			(setq $dwg_page_inx (/ $dwg_pick_inx 16)) ;ҳ��
			(if (setq $dwg_List_inx (VL-POSITION (strcat  LabelDwg_name ".dwg") (nth $dwg_page_inx dwg_List_all))) ;Image_inx
				(princ)
				(progn
					(setq dwg_list_all(reverse dwg_List_all))
					(setq $dwg_List_inx (VL-POSITION (strcat  LabelDwg_name ".dwg") (nth $dwg_page_inx dwg_List_all)))
				)
			)		
			; (DCL-MESSAGEBOX (strcat (itoa $dwg_page_inx) "ҳ-" (itoa $dwg_list_inx) "��"))
			(setq dwg_page_inx $dwg_page_inx)
			(BlockView_dwgShow_start)
			(BlockView_DwgForm_HighLight  (1+ $dwg_list_inx))
		)
  )    
)
;-------------------------------------------------------------------
;--˫��ListView box-------------------------------------------------------------------
(defun c:BlockView/DwgForm/Lst#OnDblClicked (Row Column /)
	; (setq strPath (DwgForm_check_path (dcl-ComboBox-GetDir BlockView/DwgForm/dir))) ;old
	(setq strPath (DwgForm_check_path (dcl-Control-GetText BlockView/DwgForm/DiskPath)))  ;v9.0 ����
	; (DCL-MESSAGEBOX strpath)
	(cond
    ((minusp Row) nil)
    ((zerop (dcl-ListView-GetItemImage BlockView/DwgForm/lst Row 0))
			;�㵽Ŀ¼
			(dwgForm_dwg_clear) ;��� image
			(setq curdwg_name nil)
			(dcl-Control-SetCaption BlockView/DwgForm/error "")
			(setq dwg_page_inx 0) ;�ӵ�һҳ��ʼ
			;------------------------------------------------------------------------------------------ 
			(setq strPath (strcat strPath (dcl-ListView-GetItemText BlockView/DwgForm/lst Row 0)))
			;  (DCL-MESSAGEBOX (dcl-ListView-GetItemText BlockView/DwgForm/lst Row 0))
			(setq curStrFolder strPath)
			(dcl-ComboBox-AddPath      BlockView/DwgForm/dir strPath)
			(dcl-ComboBox-SelectString BlockView/DwgForm/dir strPath)
			(dcl-Control-SetText       BlockView/DwgForm/DiskPath CurstrFolder)
			(DwgForm_filllist strPath)
    )
    ((setq Labeldwg_name (dcl-ListView-GetItemText BlockView/DwgForm/lst Row 0))
			;�㵽ͼ��.
			(setq strCompleteFile (findfile (strcat strPath Labeldwg_name ".dwg")))
			(if strcompletefile
				(progn
					(dcl-Control-SetCaption BlockView/DwgForm/error (strcat "ͼ������: " LabelDwg_name ".DWG"))
					(setq curdwg_name strCompleteFile)
					(c:BlockView/DwgForm/ok#OnClicked);;;;;;55
				)
			) 
			
			;(DCL-MESSAGEBOX strCompleteFile "Ŀǰѡȡ�ĵ���") ; ����·��ͼ��.
			; (dcl-Control-SetCaption BlockView/DwgForm/error strpath)
    )
  ) ; cond
)
;--�Ŵ�Ԥ��----------------------------------------------------------------------------
(defun c:BlockView/DwgPreView#OnInitialize (/)  ; ��ʼ���趨 show blockVIew
	(dcl-BlockView-DisplayDwg BlockView/DwgPreView/BlockView curdwg_name)
	(dcl-CONTROL-SetCaption    BlockView/DwgPreView/DwgNameFarme (strcat "ͼ������: " curdwg_Name))
)
;;--------------------------------------------------------------------------------------
(defun c:BlockView/DwgPreView/cancel#OnClicked (/)
	(dcl-Form-close     BlockView/DwgPreView)
)
;getdwgname sublisp--------------------------------------------------------------------
(defun BlockView_DwgForm_GetDWGName($$inx)
  (setq curdwg_name   (dcl-DWGPreview-GetDwgName   (eval (read (strcat "BlockView/DwgForm/ViewDwg"   (itoa $$inx)))))) ;����·������
  (setq LabelDwg_name (dcl-Control-getCaption      (eval (read (strcat "BlockView/DwgForm/Label"     (itoa $$inx)))))) ;����
)
;getdwgname sublisp--------------------------------------------------------------------
(defun BlockView_DwgForm_HighLight($$inx)
  (if old_dwgkey_inx 
		(progn
      (dcl-DWGPreview-Clear     (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa old_dwgkey_inx)))))
      (dcl-Control-SetBackColor (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa old_dwgkey_inx)))) -22)
      (dcl-DWGPreview-LoadDwg   (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa old_dwgkey_inx)))) old_dwg_name)
		)
	)
	(BlockView_DwgForm_GetDWGName $$inx)
	(dcl-DWGPreview-Clear     (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa $$inx)))))
	(dcl-Control-SetBackColor (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa $$inx)))) 151)
	(dcl-DWGPreview-LoadDwg   (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa $$inx))))  curdwg_name) 
	(IF (/= LabelDwg_name "")
		(progn
			(dcl-Control-SetCaption BlockView/DwgForm/error (strcat "ͼ������: " LabelDwg_name ".DWG"))
			(setq $dwg_temp_inx (+ (VL-POSITION  (strcat LabelDwg_name ".dwg") dwg_list) lstdir_len)) ;��ȡimage��.��Ӧ ListView��λ��.
			;(DCL-MESSAGEBOX (itoa $dwg_temp_inx))
			(dcl-ListView-SetCurSel BlockView/DwgForm/lst $dwg_temp_inx)
			(dcl-Control-SetFocus BlockView/DwgForm/lst)
		)
		(dcl-Control-SetCaption BlockView/DwgForm/error "")
	)
	(setq old_dwgkey_inx $$inx)
	(setq old_dwg_name curdwg_name) 
)
;----�ֽⰴť-------------------------------------------------
(defun c:BlockView/DwgForm/Explode#OnClicked (ExpValue /)
  ;(print expValue)
  (setq dwgblk_explode ExpValue)
  (if (= dwgblk_explode 0) ;�ֽⲻ��
		(dcl-Control-SetEnabled BlockView/DwgForm/y-sc T)
		(dcl-Control-SetEnabled BlockView/DwgForm/y-sc nil)
  )  
)
;�ȱ�����ť-----------------------------------------------------------------
(defun c:BlockView/DwgForm/same-sc#OnClicked (/)
	(setq blk_x_sc (dcl-Control-GetText BlockView/DwgForm/x-sc))
	(setq blk_y_sc blk_x_sc)
	(dcl-Control-SeTText BlockView/DwgForm/y-sc Blk_y_sc)
)
;����ť---
(defun c:BlockView/DwgForm/ok#OnClicked (/)
	(setq blk_x_sc (atof (dcl-Control-GetText  BlockView/DwgForm/x-sc)))
	(setq blk_y_sc (atof (dcl-Control-GetText  BlockView/DwgForm/y-sc)))
	(setq dwgblk_explode (dcl-Control-GetValue BlockView/DwgForm/Explode)) ;�ٴ�ȡ�÷ֽⰴť��ֵ
	;(dcl-Form-Close     BlockView/DwgForm 1)     ;����ͼ��
	(DwgView:insert)
)
(defun DwgView:Insert()
	(setvar "cmdecho" 0)
	(setq %curdwg_name (vl-filename-BASE curdwg_name))
	(if (and curdwg_name (/= curdwg_name ""));;����
		(progn
			(setq ipt (getpoint "\n�����:"))
			(cond 
				((and (= dwgblk_explode 0) (tblsearch "block" %curdwg_name)) ;����
					(vl-cmdf "-insert" (strcat %curdwg_name "=" curdwg_name) ipt blk_x_sc blk_y_sc pause)
				) 
				((or (= dwgblk_explode 0) (= dwgblk_explode nil))
					(vl-cmdf "-insert" curdwg_name ipt blk_x_sc blk_y_sc pause)
				)
				((= dwgblk_explode 1)  ;����
					(vl-cmdf "_.insert" (strcat "*" curdwg_name) ipt blk_x_sc "0")
				)
	    )
		);progn 
		(DCL-MESSAGEBOX (strcat "***����ѡȡͼ��***") "ͼ��ѡȡ")
	)  ;if
  (setvar "cmdecho" 1)
  (princ)
)
;ȡ��ť
(defun c:BlockView/DwgForm/cancel#OnClicked (/)
	(dcl-Form-Close     BlockView/DwgForm)
)
;-��һҳ
(defun c:BlockView/DwgForm/UpPage1#OnClicked (/)
	(dcl-ListView-SetCurSel BlockView/DwgForm/lst -1) ;Dwg_formLst UnSelect
	(setq curdwg_name nil old_dwgkey_inx nil )
	(dcl-Control-SetCaption BlockView/DwgForm/error "")
	(if old_dwgkey_inx  (dcl-Control-SetBackColor  (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa old_Dwgkey_inx ))))   -22)) ;���Image Sel HighLight
	(setq Dwg_page_inx (1- Dwg_page_inx))
	(BlockView_DwgShow (nth Dwg_page_inx Dwg_list_all))
	(dcl-CONTROL-SetCaption BlockView/DwgForm/DwgTile (strcat "ͼ���б� ˫��ͼƬ�ɷŴ�Ԥ��  ��" (itoa Dwg_page_n ) "֮" (itoa (1+ Dwg_page_inx) ) "ҳ"))
	(cond
  	((< 0 Dwg_page_inx)
			(dcl-Control-SetEnabled BlockView/DwgForm/UpPage1 T)  ;��һҳ��
			(dcl-Control-SetEnabled BlockView/DwgForm/NextPage1 T);��һҳ��
		)
		((= 0 Dwg_page_inx)
			(dcl-Control-SetEnabled BlockView/DwgForm/UpPage1 nil)
			(dcl-Control-SetEnabled BlockView/DwgForm/NextPage1 T)
		)
	)	
)
;;��һҳ
(defun c:BlockView/DwgForm/NextPage1#OnClicked (/)
  (dcl-ListView-SetCurSel BlockView/DwgForm/lst -1) ;Dwg_formLst UnSelect
  (setq curdwg_name nil old_dwgkey_inx nil )
  (dcl-Control-SetCaption BlockView/DwgForm/error "")
  (if old_Dwgkey_inx  (dcl-Control-SetBackColor  (eval (read (strcat "BlockView/DwgForm/ViewDwg" (itoa old_Dwgkey_inx ))))   -22)) ;���Image Sel HighLight
	(setq Dwg_page_inx (1+ Dwg_page_inx))
	(BlockView_DwgShow (nth Dwg_page_inx Dwg_list_all))
	(dcl-CONTROL-SetCaption BlockView/DwgForm/DwgTile (strcat "ͼ���б� ˫��ͼƬ�ɷŴ�Ԥ��  ��" (itoa Dwg_page_n ) "֮" (itoa (1+ Dwg_page_inx) ) "ҳ"))
  (cond
  	((< Dwg_page_inx (1- Dwg_page_n))
			(dcl-Control-SetEnabled BlockView/DwgForm/UpPage1 T)
			(dcl-Control-SetEnabled BlockView/DwgForm/NextPage1 T)
		)
		((= Dwg_page_inx (1- Dwg_page_n))
			(dcl-Control-SetEnabled BlockView/DwgForm/UpPage1 T)
			(dcl-Control-SetEnabled BlockView/DwgForm/NextPage1 nil)
		)
  )	
)
;;;(defun c:BlockView/DwgForm/PickPathButton#OnClicked (/)
;;; (DCL-MESSAGEBOX "yes")
;;; (dcl_Project_Load  "BlockView.odcl")
;;; (dcl-Form-Show     BlockView_QuickPath)
;;;)
(defun c:BlockView/DwgForm/PickPathButton#OnClicked (/)
  ;(DCL-MESSAGEBOX "To Do: code must be added to event handler\r\nc:BlockView/DwgForm/PickPathButton#OnClicked" "To do")
  (dcl-Project-Load  (strcat @:*prefix* "packages\\block-view\\BlockView.odcl"))
  (dcl-Form-Show     BlockView/QuickPath)
)




;ͼƬ˫������                                                                                                               
;;1-5--
(defun c:BlockView/DwgForm/ViewDwg1#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  1)(graphscr)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg2#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  2)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg3#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  3)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg4#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  4)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg5#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  5)(c:BlockView/DwgForm/ok#OnClicked))
;6-10
(defun c:BlockView/DwgForm/ViewDwg6#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  6)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg7#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  7)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg8#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  8)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg9#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  9)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg10#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 10)(c:BlockView/DwgForm/ok#OnClicked))
;11-15
(defun c:BlockView/DwgForm/ViewDwg11#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 11)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg12#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 12)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg13#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 13)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg14#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 14)(c:BlockView/DwgForm/ok#OnClicked))
(defun c:BlockView/DwgForm/ViewDwg15#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 15)(c:BlockView/DwgForm/ok#OnClicked))
;16
(defun c:BlockView/DwgForm/ViewDwg16#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 16)(c:BlockView/DwgForm/ok#OnClicked))








;ͼƬ˫���Ŵ�                                                                                                               
;;1-5--
;(defun c:BlockView/DwgForm/ViewDwg1#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  1)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg2#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  2)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg3#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  3)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg4#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  4)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg5#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  5)(dcl-Form-Show  BlockView/DwgPreView))
;6-10
;(defun c:BlockView/DwgForm/ViewDwg6#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  6)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg7#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  7)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg8#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  8)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg9#OnDblClicked  (/) (BlockView_DwgForm_GetDwgName  9)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg10#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 10)(dcl-Form-Show  BlockView/DwgPreView))
;11-15
;(defun c:BlockView/DwgForm/ViewDwg11#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 11)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg12#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 12)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg13#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 13)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg14#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 14)(dcl-Form-Show  BlockView/DwgPreView))
;(defun c:BlockView/DwgForm/ViewDwg15#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 15)(dcl-Form-Show  BlockView/DwgPreView))
;16
;(defun c:BlockView/DwgForm/ViewDwg16#OnDblClicked (/) (BlockView_DwgForm_GetDwgName 16)(dcl-Form-Show  BlockView/DwgPreView))
;ͼƬ����                                                                                                                    
;;1-5--
(defun c:BlockView/DwgForm/ViewDwg1#OnClicked  (/) (BlockView_DwgForm_HighLight  1))
(defun c:BlockView/DwgForm/ViewDwg2#OnClicked  (/) (BlockView_DwgForm_HighLight  2))
(defun c:BlockView/DwgForm/ViewDwg3#OnClicked  (/) (BlockView_DwgForm_HighLight  3))
(defun c:BlockView/DwgForm/ViewDwg4#OnClicked  (/) (BlockView_DwgForm_HighLight  4))
(defun c:BlockView/DwgForm/ViewDwg5#OnClicked  (/) (BlockView_DwgForm_HighLight  5))
;6-10
(defun c:BlockView/DwgForm/ViewDwg6#OnClicked  (/) (BlockView_DwgForm_HighLight  6))
(defun c:BlockView/DwgForm/ViewDwg7#OnClicked  (/) (BlockView_DwgForm_HighLight  7))
(defun c:BlockView/DwgForm/ViewDwg8#OnClicked  (/) (BlockView_DwgForm_HighLight  8))
(defun c:BlockView/DwgForm/ViewDwg9#OnClicked  (/) (BlockView_DwgForm_HighLight  9))
(defun c:BlockView/DwgForm/ViewDwg10#OnClicked (/) (BlockView_DwgForm_HighLight 10))
;11-15
(defun c:BlockView/DwgForm/ViewDwg11#OnClicked (/) (BlockView_DwgForm_HighLight 11))
(defun c:BlockView/DwgForm/ViewDwg12#OnClicked (/) (BlockView_DwgForm_HighLight 12))
(defun c:BlockView/DwgForm/ViewDwg13#OnClicked (/) (BlockView_DwgForm_HighLight 13))
(defun c:BlockView/DwgForm/ViewDwg14#OnClicked (/) (BlockView_DwgForm_HighLight 14))
(defun c:BlockView/DwgForm/ViewDwg15#OnClicked (/) (BlockView_DwgForm_HighLight 15))
;16
(defun c:BlockView/DwgForm/ViewDwg16#OnClicked (/) (BlockView_DwgForm_HighLight 16))
(princ)
;-----------------------------------------------------------------------------------------
;-insname Ŀ¼----------------------------------------------------------------------------
(defun insname_path(/ $len path)
	;(vl-filename-directory (GETVAR "INSNAME"))
	(setq $insname (getvar "insname"))
	(if (/= $insname "")
		(progn
			(setq $len (strlen $insname))  
			(while (/= (substr $insname $len 1) "\\")
				(setq $len (1- $len))
				(setq path (substr $insname 1 $len))
			)
			(setq path (substr $insname 1 (1- $len)))
			(if (= (substr path 1 1) "*") (setq path (substr path 2)))
		)
		(setq path "")
	)  
	(if path path) 
)
;;;;QuickPath Funtion------------------------------------------------------------------
;��ʼ������·��---
(defun c:BlockView/QuickPath#OnInitialize (/)
  (setq CurPath_value nil)
  (dcl-Control-SetText BlockView/QuickPath/PathTextBox StrPath)
  (setq QuickPath_TXtName (strcat @:*prefix* "packages\\block-view\\QuickPath.txt"))
  (dcl-Control-SetCaption BlockView/QuickPath/error "")
  (BlockView:Read_Path QuickPath_TxtName)
  (dcl-ListBox-Clear BlockView/QuickPath/ListBox)
  (if QuickPath_list (dcl-ListBox-AddList BlockView/QuickPath/ListBox QuickPath_list))
)
;ok ����------------------------------------------------------------------------------------
(defun c:BlockView/QuickPath/OkButton#OnClicked (/)
  (dcl-Form-close BlockView/QuickPath)
  (if (and
        (/= CurPath_value nil)
        (/= CurStrFolder curPath_value)
      )	
		(progn
      (setq curStrFolder curPath_value)
      (c:BlockView/DwgForm#OnInitialize)
		)
  ) 
)
;--------------------------------------------------------------------------------------
(defun c:BlockView/QuickPath/CancelButton#OnClicked (/)
  (dcl-Form-close BlockView/QuickPath)
)
;˫������·��ListBox--------------------------------------------------------------------
(defun c:BlockView/QuickPath/ListBox#OnDblClicked (/)
  (dcl-Form-close BlockView/QuickPath)
  (if (and
        (/= CurPath_value nil)
        (/= CurStrFolder curPath_value)
      )	
		(progn
      (setq curStrFolder curPath_value)
      (c:BlockView/DwgForm#OnInitialize)
		)
  ) 
)
; ����·��------------------------------------------------------------------------------
(defun c:BlockView/QuickPath/AddPathBotton#OnClicked (/)
	(setq New_strPath (dcl-Control-GetText BlockView/QuickPath/PathTextBox))
	(if (member New_strPath QuickPath_List)
		(dcl-Control-SetCaption BlockView/QuickPath/error "·���Ѿ�����.")
		(progn
			(setq QuickPath_list (cons New_strPath QuickPath_List))
			(setq QuickPath_list (vl-sort QuickPath_List '>))
			(BlockView:add_path QuickPath_List QuickPath_TxtName)
      ;����addList
			(dcl-ListBox-Clear BlockView/QuickPath/ListBox)
			(if QuickPath_list (dcl-ListBox-AddList BlockView/QuickPath/ListBox QuickPath_list))
		)
	)  
)
;;ѡȡ����·��ListBox ------------------------------------------------------------------------
(defun c:BlockView/QuickPath/ListBox#OnSelChanged (ItemIndexOrCount $pathValue /)
	;(DCL-MESSAGEBOX $pathValue)
	(setq curPath_value $PathValue)
	(dcl-Control-SetCaption BlockView/QuickPath/error CurPath_Value)
)
;ɾ��·��-----------------------------------------------------------------------------
(defun c:BlockView/QuickPath/DelPathButton#OnClicked (/)
  (if (null CurPath_value)
		(DCL-MESSAGEBOX "û��ѡȡҪɾ����·��")
		(progn
			(dcl-Control-SetCaption BlockView/QuickPath/error "")
			;�Ƴ�List ��·��
			(setq QuickPath_List (vl-remove curPath_value QuickPath_List))
			; ����д��.
			(BlockView:add_path QuickPath_List QuickPath_TxtName)
			;����addList
			(dcl-ListBox-Clear BlockView/QuickPath/ListBox)
			(if QuickPath_list (dcl-ListBox-AddList BlockView/QuickPath/ListBox QuickPath_list))
			(setq CurPath_value nil)
		)	
  ) 
)
;��д·�ɵ�
;-----------------------------------------------------------
(defun Blockview:add_Path (path_list Fullfile / i)
  (setq $fullfile (open Fullfile "w"))
  (setq i 0)
  (repeat    (length path_list)
		(setq x (nth i path_list))
		(write-line x $fullfile)
		(setq i (1+ i))
  )
  (close $fullfile)
)
;---------------------------------------------------------
;��ȡ·����
(defun Blockview:read_Path (Fullfile / i)
  (setq $fullfile (open Fullfile "r"))
  (setq i 0 QuickPath_list '())
  (setq f_line (read-line $fullfile))
  (while (/= f_line nil)
		(setq QuickPath_list (cons f_line QuickPath_list))
		(setq f_line (read-line $fullfile))
  )
  (close $fullfile)
  (setq QuickPath_list (vl-sort QuickPath_List '>))
)  
;--ARX LOLAD ---------------------------------------
;; (defun Opendcl:ArxLoad()
;; 	(setq *acadver* (SUBSTR (GETVAR "ACADVER") 1 2))
;; 	(if (vl-string-search "(x86)" (getvar "platform"))
;;     (if (>= 30 (atoi *acadver*) 16)
;; 			(if (not dcl-Form-show) (arxload (strcat BVPATH "\\OpenDcl."     *acadver* ".arx")))
;; 			(alert "OpenDcl.��֧Ԯ.����汾��AutoCAD")
;;     )
;;     (if (>= 30 (atoi *acadver*) 16)
;; 			(if (not dcl-Form-show) (arxload (strcat BVPATH "\\OpenDcl.x64." *acadver* ".arx")))
;; 			(alert "OpenDcl.��֧Ԯ.����汾��AutoCAD")
;;     )  
;;   ) ;if
;; );defun
;------------------------------------------------------------------
;(prompt "\n***ָ����: BlockView ͼ��Insert ***")
;(prompt "\n***ָ����: DwgView   ͼ��Insert ***")
(princ)	    
