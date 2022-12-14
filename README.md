### 歌曲干声自动标注 revised版（Opencpop格式）

在新的词典和音素系统以及推理逻辑出来前，本项目致力于采用Opencpop原生词典，结合MFA的自动对齐功能和Praat脚本，完成跟Opencpop格式一致的自动标注。在有音频文件和对应抄本srt或者lyc文件的情况下，可以使用本项目的轮子进行标注以加快速度。项目中包含了训练好的MFA声学模型，Opencpop词典和Praat批量标注脚本。

新版歌曲标注工作流如下所示：带lyrics歌词的歌曲→lyrics转为带时间戳的srt文件→歌曲经过UVR处理(在线版的人声分离网站也可)→根据srt时间戳批量截取音频和对应歌词→储存为同名wav和txt→pypinyin将歌词txt转为不带声调的汉语音节→MFA自动对齐得到双层标注→在Praat中按顺序自动打开wav和同名textgrid→进行人工修正和添加SPAP和转音符号→自动标注出音高层(midi层)音长层和连音层

目前这个工作流主要是四个轮子的配合，一个是根据srt时间戳批量截取音频和对应歌词 (我改的Github现成轮子)，一个是用pyinyin把歌词转为pinyin (这个很容易实现)，一个是MFA批量标注(项目中已给出训练共300轮的声学模型和词典)，一个是人工修改更新和自动生成midi层音长层和转音层标注 (基于Praat脚本实现)。感觉前面可以对接小狼发现的音频自动识别srt时间戳的google colab，这样就可以直接从歌曲干声开始标注，甚至连对应lyc或srt都没有都行。(2022.09.25已实现whisper配合MFA对齐，用户只需上传音频，即使没有对应文本也可以拿到textgrid)

最近可能得暂停更新段时间，我得去准备论文，后续会考虑在B站以录屏形式，更新下歌曲干声自动标注流程，当然我也很期待有整合式的全流程标注软件出现。Diffsinger的合成效果蛮不错，Openvpi项目组在丰富Diffsinger原项目上做出了很大跨越。我觉得用自己喜欢的歌手或者Vup合成自己想要的歌曲，是可期待在未来实现的事，只要我们不懈努力。我赶着把简陋版自动标注项目做出来，主要是因为目前还没有看到Diffsinger用在新的歌曲干声上，再加上新学期开始后很多ddl到来，所以做的确实有些着急，就当是抛砖引玉。
