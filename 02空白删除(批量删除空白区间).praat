form 基于MFA对齐结果的自动标注
	sentence textgrid_Path my_textgrid
	sentence textgrid_Output_Path my_textgrid_converted
endform

textgrid_directory$ = textgrid_Path$
textgrid_output_directory$ = textgrid_Output_Path$

#去除掉MFA对齐后的空白区间
#参考链接https://stackoverflow.com/questions/71403177/praat-script-to-remove-specific-boundaries
strings = Create Strings as file list: "list", textgrid_directory$ + "/*.TextGrid"
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	selectObject: strings
	fileName$ = Get string: ifile
	#读取标注文件的路径和不含后缀名
	Read from file: textgrid_directory$ + "/" + fileName$
	objectName$ = selected$("TextGrid", 1)
	tiers = Get number of tiers
	#遍历各层内的区间标注
	for t from 1 to tiers
		intervals = Get number of intervals: t
		for i from 1 to intervals
			label$ = Get label of interval... 't' 'i'
			#如果某个区间标注为空让该区间与左侧合并
			if label$ = ""
			selection_start = Get start time of interval... 't' 'i'
			selection_end = Get end time of interval... 't' 'i'
				if selection_start <> 0
				Remove boundary at time: 't', selection_start
				intervals = intervals-1
				else
				Remove boundary at time: 't', selection_end
				intervals = intervals-1
				endif
			#删除后区间总数变少需要减1否则索引值会超区间总数
			endif
		endfor
	endfor
	#处理后的文件保存在新文件夹
	Save as text file: textgrid_output_directory$ + "/" + objectName$ + ".TextGrid"
	selectObject: "TextGrid " + objectName$
	Remove
endfor
select all
Remove