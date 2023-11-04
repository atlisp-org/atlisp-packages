(@:add-menus 
 '(("文本"
    ("文本设置" (@text:setup))
    ("文字排版" (@text:multi-text-align))
    ("插入时间戳" (@text:insert-time))
    ("左对齐" (@text:justifytext-left))
    ("右对齐" (@text:justifytext-right))
    ("居中对齐" (@text:justifytext-middle))
    ("属性变文本" (@text:a2t))
    ("单行转多" (@text:to-mtext))
    ("加前后缀" (@text:menu-add-prefix-or-suffix))
    ("批量加序号" (@text:menu-add-order))
    ("点哪加哪" (@text:inc-word))
    ("绘线查找" (@text:find-from-line))
    ("生成表格" (@text:text2table))
    ("格式数字" (@text:menu-format-number))
    ("文本转表格" (@text:string-to-table))
    ("朗读文本" (@text:menu-speak)))
   ("文本2" 
    ("按行合并" (@text:join-in-line))
    ("文本加框" (@text:menu-draw-box))
    ("删文本框" (@text:menu-remove-box))
    ("重排序号" (@text:sort-serial-number))
    ("定位重叠字" (@text:locate-overlay-text))
    ("文字避让" (@text:handle-overlay-text))
    ("定位压线字" (@text:locate-overline-text))
    )))
(@:define-hotkey "tts" "(@text:menu-speak)")
