form 基于MFA对齐结果的自动标注
	sentence textgrid_Path my_textgrid_converted
	sentence textgrid_Output_Path my_textgrid_final
	sentence wavfiles_Path my_wavs
	sentence Table_name 半音映射
endform

textgrid_directory$ = textgrid_Path$
wavfiles_directory$ = wavfiles_Path$
textgrid_output_directory$ = textgrid_Output_Path$

#读取半音值和音符的转换关系写入表格
#Praat中以440HZ为基准的半音值可以完美对应音符标记
#整理好的对应关系我放在了半音映射.txt文件中
#选择的区间为50个半音跨度(从60HZ到1100赫兹)
Read Table from tab-separated file: table_name$ +".txt"
ns = Get number of rows
for r from 1 to ns
	#将半音写入半音$['r']
	#对应的音符写入音符$['r']
	半音$['r'] = Get value: r, "半音"
	音符$['r'] = Get value: r, "音符"
endfor

#创建音高音长连音层
#计算区间半音值转为音高
#根据区间时长填入音长层
strings = Create Strings as file list: "list", textgrid_directory$ + "/*.TextGrid"
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	selectObject: strings
	fileName$ = Get string: ifile
	Read from file: textgrid_directory$ + "/" + fileName$
	#以下部分是根据Opencpop的标注格式
	#把word和phone层更名为音节层和音素层
	#以音节层为基础复制出音高和音长层
	#以音素层为基础复制出连音层
	Set tier name: 1, "音节"
	Set tier name: 2, "音素"
	Duplicate tier: 1, 2, "音高"
	Duplicate tier: 1, 3, "音长"
	Duplicate tier: 4, 5, "连音"
	objectName$ = selected$("TextGrid", 1)
	Extract one tier: 2
	selectObject: "TextGrid 音高"
	Down to Table: "yes", 6, "yes", "yes"
	Extract rows where column (text): "text", "is not equal to", ""
	#通过转表格加筛选的方式提取出音高层中的非空区间
	#记录每个区间的索引序号、区间标注、开始和结束时间
	selectObject: "Table 音高_"
	nr = Get number of rows
	for r from 1 to nr
		index$['r'] = Get value: r, "line"
		text$['r'] = Get value: r, "text"
		tmin$['r'] = Get value: r, "tmin"
		tmax$['r'] = Get value: r, "tmax"
	endfor
	#读取对应的音频文件转为pitch文件
	Read from file: wavfiles_directory$ + "/" + objectName$ + ".wav"
	selectObject: "Sound " + objectName$
	To Pitch: 0, 60, 1100
	selectObject: "Pitch " + objectName$
	#将每个区间的索引序号、开始和结束时间转为数字变量
	#通过结束时间减去开始时间来计算音长层的各区间时长
	for r from 1 to nr
		tmin = number: tmin$['r']
		tmax = number: tmax$['r']
		index = number: index$['r']
		text$ = text$['r']
		duration = tmax - tmin
		selectObject: "TextGrid " + objectName$
		#这里的3指的是时长层 fixed$(duration,6)指保留到六位
		Set interval text: 3, index, fixed$ (duration, 4)
		#如果区间内标注为SP 音高层直接写rest
		if startsWith(text$, "SP")
			selectObject: "TextGrid " + objectName$
			Set interval text: 2, index, "rest"
		#如果区间内标注为AP 音高层直接写rest
		elsif startsWith(text$, "AP")
			selectObject: "TextGrid " + objectName$
			Set interval text: 2, index, "rest"
		#区间内若为其余标记 音高层取区间内半音的均值
		#半音均值进行四舍五入到整数然后在半音映射表格进行配对
		#如果半音均值等于半音$['i']则被替换为对应音符$['i']
		else
			selectObject: "Pitch " + objectName$
			semitone = Get mean: tmin, tmax, "semitones re 440 Hz"
			semitone_new = round(semitone)
			midi$ = fixed$: semitone_new, 0
			#这部分就是匹配半音映射表格中的半音值
			#参照赵彤脚本集http://www.phonetics.org.cn/?p=591
			for i from 1 to ns
				old$ = 半音$['i']
				new$ = 音符$['i']
				if midi$ = old$
				midi_new$ = new$
				endif
			endfor
			selectObject: "TextGrid " + objectName$
			Set interval text: 2, index, midi_new$
		endif
	endfor
	#替换完后保存新文件同时删除新增文件
	Save as text file: textgrid_output_directory$ + "/" + fileName$
	selectObject: "Sound " +  objectName$
	plusObject: "Pitch " +  objectName$
	plusObject: "TextGrid " +  objectName$
	plusObject: "TextGrid 音高"
	plusObject: "Table 音高"
	plusObject: "Table 音高_"
	Remove
endfor
select all
Remove

#现在只剩连音层标注了 根据Opencpop的标注格式
#音节层中如果有连音记号- 连音层要记为1然后其余记0
#我的想法是先把第五层全部换成0
#Down to table 音节层 text is equal to _ 筛选出要标1的区间
#Get interval at time: 5, tmin+(tmax-tmin)/2 返回第五层需要标1的索引序号
#Set interval text: 5, 第五层的index, "1" 按照第五层需要标1的索引序号进行替换

strings = Create Strings as file list: "list", textgrid_output_directory$ + "/*.TextGrid"
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	selectObject: strings
	fileName$ = Get string: ifile
	Read from file: textgrid_output_directory$ + "/" + fileName$
	objectName$ = selected$("TextGrid", 1)
	#首先把连音层全部标成0
	np = Get number of intervals: 5
	for r from 1 to np
		Set interval text: 5, r, "0"
	endfor
	#提取出音节层中的所有区间
	Extract one tier: 1
	Down to Table: "no", 6, "no", "no"
	selectObject: "Table 音节"
	#遍历音节层中的区间并进行判断
	nr = Get number of rows
	for r to nr
		selectObject: "Table 音节"
		tmin = Get value: r, "tmin"
		tmax = Get value: r, "tmax"
		text$ = Get value: r, "text"
		#如果文本含有_就计算区间的中心时点
		#然后找到连音层对应时间点的索引序号
		#把该索引符号对应的连音层标注替换为1
		if startsWith(text$, "_")
			anchor = tmin + (tmax - tmin)/2
			selectObject: "TextGrid " + objectName$
			index = Get interval at time: 5, anchor
			Set interval text: 5, index, "1"
		endif
	endfor
	selectObject: "TextGrid " + objectName$
	Save as text file: textgrid_output_directory$ + "/" + fileName$
	selectObject: "TextGrid " + objectName$
	plusObject: "TextGrid 音节"
	plusObject: "Table 音节"
	Remove
endfor
select all
Remove










