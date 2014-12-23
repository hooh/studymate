package com.studyMate.global
{
	public final class CmdStr
	{
		/**
		 *检查密码 
		 */		
//		public static const CYOPER_CHECKOPERPWD:String = "CYOPER.CheckOperPwd";
		/**
		 *1对N操作 
		 */		
//		public static const CYOPER_LISTOPER:String = "CYOPER.ListOper";
		
//		public static const BOOKCX:String = "BOOKCX.QueryKnow(yy)";
		
		/*[ABLOGIN.ChkPasswd]
		@=登录检查密码
		SrcFName  =snport.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =opcode     #登录帐号
		CmdIStr2  =SHA加密后密码
		CmdIStr3  =上行随机数
		CmdIStr4  =MAC地址
		#WeiYF.20120511 考虑新增如下参数，兼容并原来没有第4个参数的情况。
		CmdIStr4  =nvrparam   #NVR格式的扩展性参数；
		#param[out] 命令字出口:
		CmdOStr0  =000/MMM
		CmdOStr1  =operid,操作员标识#客户端存本地
		CmdOStr2  =opcode,登录帐号
		CmdOStr3  =region,用户分区  #客户端存本地，用于BLOGIN; 
		#第1字节是@表示管理者，否则为使用者
		CmdOStr4  =tokennext,成功登录后生成的，用于下次登录加密的令牌值#客户端存本地
		CmdOStr5  =cntsocket,附加登录次数#客户端内存维护
		CmdOStr6  =realname,真实姓名
		CmdOStr7  =nickname,昵称
		CmdOStr8  =smstelno,可收短信手机号
		CmdOStr9  =logintm1,首次登录时间(YYYYMMDD-hhnnss)
		CmdOStr10 =logincnt,正常登录次数，不包括附加登录#客户端存本地
		CmdOStr11 =lastlogtm,上次登录时间(YYYYMMDD-hhnnss)
		CmdOStr12 =randomDN,下行随机数
		CmdOStr13 =macid,MAC地址ID
		CmdOStr14 =hexserial,注册码
*/
		public static const ABLOGIN_ChkPasswd:String = "ABLOGIN.ChkPasswd";
		
		/**
		 *获得操作员信息 
		 */		
//		public static const CYOPER_GETOPERINFO:String = "CYOPER.GetOperInfo";
		
		//JYOCX.QueryWordList
		/*@=查询要学习的单词列表
			#查询原始词汇表，模拟返回该用户要学习的单词组
			# 返回的单词分为3组，每组约为20个单词；选取有读音的单词
			# 分组代码近似取值为 L=上次学的、T=本次学的、N=下次学的
			# 选取算法如下：
			#     1.有效单词数=有读音的单词总数；定义为常量
			#     2.生成不大于 有效单词数-60 的随机数；
		#     3.返回 单词序号 从该记录数开始的 60个有效单词；
		#     4.顺序依次分组；返回个数可能小于60；但一般为60；
		SrcFName=chaxun.c    #C源码所在文件名
		CmdTypeN=1:N         #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1=OperID
		#param[out] 命令字出口:
		CmdOStr1=分组代码
			CmdOStr2=单词序号
			CmdOStr3=单词串
			CmdOStr4=音标
			CmdOStr5=中文含义
			CmdOStr6=记忆法
			CmdOStr7=发音A数据
		CmdOStr8=发音B数据*/
		
			
		//public static const BOOKCX_QUERYWORDLIST:String = "BOOKCX.QueryWordList(yy)";
		
		public static const USERAS_OBTAINWORDLIST:String = "USERAS.ObtainWordList(gdgz)";

		public static const SNFILE_csDownloadHostFile_FILE182:String = "SNFILE.csDownloadHostFile(@000)";
		
		/**
		 * 获取随机谚语as脚本
		 * 
		 * 
		 * [GetScriptAdage]
@=获取随机谚语as脚本
SrcFName  =useras.c     #C源码所在文件名
CmdTypeN  =1:1          #命令字类型;1:1/N
#param[in] 命令字入口:
CmdIStr1  =operid       #操作员标识
#param[out] 命令字出口:
CmdOStr1  =length       #脚本内容长度
CmdOStr2  =script       #脚本，超长串
		 */		
//		public static const GET_SCRIPT_ADAGE:String = "USERAS.GetScriptAdage(gdgz)";
		
		/**
		 *获取阅读文本 
		 * [ObtainYYRead]
		@=获取英语阅读文本
		SrcFName  =yyread.c     #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =rrl          #主线层级代码
		#param[out] 命令字出口:
		CmdOStr1  =rrl          #主线层级代码
		CmdOStr2  =sizelen      #大小长度
		CmdOStr3  =jsontext     #文本内容,超长串
		#CmdOStr3返回的JSON文本内容格式如下：
		#{
		#  "title":"短文",
		#  "author":"新概念英语",
		#  "content":"#空白#"
		#}
		 */		
//		public static const GET_READING_TEXT:String = "USERAS.ObtainYYRead(gdgz)";
		public static const GET_READING_TEXT:String = "USERAS.ObtainYYReadAs(gdgz)";
		
		/*BOOKYW.SelectWord(gdgz)
		[SelectWord]
		@=查询单词
		SrcFName  =word.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =wordid       #单词id,取值0表示不参与查询
		CmdIStr2  =wordstr      #单词串,当wordid取值0时才参与条件查询
		#param[out] 命令字出口:
		#成功
		CmdOStr1  =wordid       #单词id
		CmdOStr2  =wordstr      #单词串
		CmdOStr3  =wordtype     #单词类型；取值参见 WORD_TYPE 参数；
		CmdOStr4  =wgrpid       #归属编组标识
		CmdOStr5  =wgrpid99     #归属编组99标识
		CmdOStr6  =wgrpid98     #归属编组98标识
		CmdOStr7  =kseqno       #编组内的序号
		CmdOStr8  =kseqno99     #编组99内的序号
		CmdOStr9  =kseqno98     #编组98内的序号
		CmdIStr10 =taglist      #关联标签列表(英文逗号分隔开的 CLASS_TAG 参数)
		CmdIStr11 =source       #来源；从哪本教材来
		CmdOStr12 =soundfn      #单词发音文件名
		CmdOStr13 =soundmark    #音标
		CmdOStr14 =meanbasic    #基本含义
		CmdOStr15 =meanadd      #附加含义
		CmdOStr16 =mmethod      #记忆法
		CmdOStr17 =phrase       #例句
		CmdOStr18 =timestart    #发音开始时间([hh:]mm:ss.nnn)
		CmdOStr19 =timeend      #发音结束时间([hh:]mm:ss.nnn)
		#失败
		CmdOStr0  =errno        #错误代码
		#"M00"=单词不存在
		#"MMM"=其他错误
		CmdOStr1  =errMsg       #失败提示信息*/
		public static const SELECT_WORD:String = "BOOKYW.SelectWord";
//		public static const SUBMIT_TASK:String = "USERAS.SubmitTaskKnow(gdgz)";
		public static const SELECT_WORD_ORIG:String = "BOOKYW.SelectWordOrig";
		
		
		/*[SubmitTaskWord]
		@=提交单词组学习结果
			SrcFName  =word.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #操作员标识
		CmdIStr2  =rrl          #单词分组主线层级
		CmdIStr3  =learnsec     #学习时长(秒数)，由Flash客户端返回
		CmdIStr4  =rightnum     #学习正确数
		CmdIStr5  =errornum     #学习错误数
		CmdIStr6  =totalnum     #学习总数
		CmdIStr7  =wrongidlist  #逗号分的隔错误单词id列表
		CmdIStr8  =rightidlist  #逗号分的隔正确单词id列表
		#param[out] 命令字出口: #2012.03.12新增返回奖励脚本出口
		CmdOStr1  =length       #奖励脚本内容长度
		CmdOStr2  =script       #奖励脚本，超长串；奖励模板为TASK_FINISH*/
		public static const SUBMIT_TASK:String = "USERAS.SubmitTaskWord(gdgz)";
		
		/*[SubmitOneTask]
		@=提交一个任务          #更新 elntask.lnloginval ，
		                        #登记 eudaydeal 及相应明细表，
		                        #将 elrctrl.lntasknum 减1。
		SrcFName  =task.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		CmdIStr2  =rrl          #知识主线层级；取值参见 ROUTE_RANK_LEVEL 参数；
		CmdIStr3  =learnsec     #学习时长(秒数)，由Flash客户端返回
		CmdIStr4  =rightnum     #学习正确数
		CmdIStr5  =errornum     #学习错误数
		CmdIStr6  =totalnum     #学习总数
		CmdIStr7  =wrongidlist  #逗号分的隔错误题目(或单词)id列表
		CmdIStr8  =rightidlist  #逗号分的隔正确题目(或单词)id列表
		#param[out] 命令字出口: #2012.03.12新增返回奖励脚本出口
		CmdOStr1  =rrl       #下一个任务的rrl
		CmdOStr2  =id       #id
		CmdOstr3 = script   #脚本*/
		public static const SUBMIT_ONE_TASK:String = "USERRW.SubmitOneTask(gdgz)";
		
		
		/*[Abandon_Task_YYWord]
		@=提交一个任务          #更新 elntask.lnloginval ，
		#登记 eudaydeal 及相应明细表，
		#将 elrctrl.lntasknum 减1。
		SrcFName  =task.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		CmdIStr2  =rrl          #知识主线层级；取值参见 ROUTE_RANK_LEVEL 参数；
		CmdIStr3  =learnsec     #学习时长(秒数)，由Flash客户端返回
		CmdIStr4  =rightnum     #学习正确数
		CmdIStr5  =errornum     #学习错误数
		CmdIStr6  =totalnum     #学习总数
		CmdIStr7  =wrongidlist  #逗号分的隔错误题目(或单词)id列表
		CmdIStr8  =rightidlist  #逗号分的隔正确题目(或单词)id列表
		#param[out] 命令字出口: #2012.03.12新增返回奖励脚本出口
		CmdOStr1  =rrl       #下一个任务的rrl
		CmdOStr2  =id       #id
		CmdOstr3 = script   #脚本*/
		public static const Abandon_Task_YYWord:String = "USERRW.AbandonTaskYYWord(gdgz)";
		
		public static const Test_YYword:String = "USERRW.TestYWTask(gdgz)";
		
		/*[PlayVideoTime]
		@=获取游戏运行时间
		SrcFName  =task3.c      #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid          #用户标识
		CmdIStr2  =videoids     #视频ids[标识]
		CmdIStr3  =times        #23分钟
		CmdIStr4  =wtimes       #申请时长(分钟)
		CmdIStr5  =rtimes       #实际时长(分钟)
		CmdIStr6  =gamename     #视频名称
		CmdIStr7  =starttime    #开始时间
		CmdIStr8  =endtime      #结束时间
		#param[out] 命令字出口:*/
		public static const SUBMIT_WATCH_VIDEO_INFO:String = "USERRW.PlayVideoTime(gdgz)";
		
		public static const OPERFILE_DOWNLOAD_BINFILE:String = "OPERFILE.DownloadBinFile(gdgz)";
		
		/*@=查询当日主线任务数目
			SrcFName  =useras.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		#param[out] 命令字出口:
		CmdOStr1  =userid       #使用者标识
		CmdOStr2  =bookroute    #课目主线
		CmdOStr3  =title        #主线标题
		CmdOStr4  =tasknum      #主线任务数*/
		public static const LIST_TODAY_RRL:String = "USERAS.ListTodayRrl(gdgz)";
		/*@=获取当日计划任务数据
		SrcFName  =useras.c     #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		#param[out] 命令字出口:
		CmdOStr1  =userid       #使用者标识
		CmdOStr2  =jsondata     #JSON格式的超长串*/
		public static const GET_TODAY_TASKJSON:String = "USERAS.GetTodayTaskJson(gdgz)";
		
		
		/*USERRW.GetTodayTask(gdgz)
		sid                 用户ID   int
		t_type              任务类型 char(4)  'yy.W,  yy.R,  yy.E,  @y.O, ...'	
		出口 (1:N)
		0---状态指示
		1---sid             用户ID
		2---rrl             rrl串，完成任务时用 yy.W.03.002.01 ...
		3---状态            <1000 未完成， >=1000 完成
		4---任务参数        对应任务使用的数据id
		5---附加字段        对应为@y.O 时的标题串*/
		public static const GET_TODAY_TASK:String = "USERRW.GetTodayTask(gdgz)";
		
		
		
		/*@=获取当日未完成的任务
		
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		#param[out] 命令字出口:
		CmdOStr1  = t_type       #任务类型 char(4)  'yy.W,  yy.R,  yy.E,  @y.O, ...'
		CmdOStr2  = num     #未完成的任务数*/
		public static const GET_TODAY_TASKNUM:String = "USERRW.GetTodayTaskNum(gdgz)";
		
		
		
		/*[GetYYOralById]
		@=获取oralid对应文本串
		SrcFName  =task2.c      #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid          #用户标识
		CmdIStr2  =@y.O         #类型
		CmdIStr3  =oralid       #
		#param[out] 命令字出口:
		CmdOStr0  =结果状态码
		CmdOStr1  =sid
		CmdOStr2  =oralid       #
		CmdOStr3  =title        #标题
		CmdOStr4  =wcount       #单词数
		CmdOStr4  =texttype     #文本类别
		CmdOStr5  =text         #文本内容 */
		public static const GET_YYOralById:String = "USERRW.GetYYOralById(gdgz)";
		/*@=获取oralid对应文本串
		SrcFName  =task2.c      #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid          #用户标识
		CmdIStr2  =@y.O         #类型
		CmdIStr3  =oralid       #
		#param[out] 命令字出口:
		CmdOStr0  =结果状态码
		CmdOStr1  =sid
		CmdOStr2  =oralid       #
		CmdOStr3  =title        #标题
		CmdOStr4  =wcount       #单词数
		CmdOStr5  =wbid         #素材标识
		CmdOStr6  =wbname       #素材路径
		CmdOStr7  =texttype     #文本类别
		CmdOStr8  =text         #文本内容*/
		public static const GET_YYOralByIdV2:String = "USERRW.GetYYOralByIdV2(gdgz)";//带录音的
		
		/*口语任务提交
		[USERRW.SubmitTaskYYOral(gdgz)]
		@=提交英语阅读学习结果
		SrcFName  =task3.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		CmdIStr2  =rrl          #单词分组主线层级
		CmdIStr3  =oralid       #对应 book.eyyoral.oralid 
		CmdIStr4  =learnsec     #学习时长(秒数)，由Flash客户端返回
		CmdIStr5  =rightnum     #文章单词数
		CmdIStr6  =errornum     #0
		CmdIStr7  =totalnum     #文章单词数
		CmdIStr8  =rightrate    #学习结果正确率，取值0-100
		CmdIStr9  =timebegin    #开始学习时间(YYYYMMDD-hhnnss)；
		CmdIStr10 =timeend      #结束学习时间(YYYYMMDD-hhnnss)；
		CmdIStr11 =useranswer   #空
		#param[out] 命令字出口:
		CmdIStr0  = 000         #命令执行状态
		CmdIStr1  = nexttask    #下一任务的rrl
		CmdIStr2  = nexttaskid  #下一任务的idstr
		CmdOStr3  = usmoney     #任务获取银币数
		CmdOStr4  = aslen       #提示文本长度
		CmdOStr5  = atext       #提示文本*/
		public static const SUBMIT_TASK_YYORAL:String =  "USERRW.SubmitTaskYYOral(gdgz)";
		
		/*[ApplyYW.URRB]
		@=业务入账处理-URRB=重建当日计划
			SrcFName  =rank.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr0 = USERRW.ApplyYW(gdgz)
		CmdIStr1  ="URRB"       #重建当日计划
		CmdIStr2  =operid       #操作者标识
		CmdIStr3  =opcode       #操作者登录帐号
		CmdIStr4  =menuid       #该业务关联的菜单标识
		CmdIStr5  =mtitle       #对应菜单标题
		CmdIStr6  =userid       #使用者标识
		CmdIStr7  =opcode       #使用者登陆账号
		CmdIStr8  =bookroute    #课目主线
		#param[out] 命令字出口=ApplyYW*/
		public static const APPLY_YW:String = "USERRW.ApplyYW(gdgz)";
			
		public static const REBUILD_ERR:String = "USERRW.BuildTodayTask(gdgz)";
			
		/*@=查询当日任务列表
			SrcFName  =useras.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		CmdIStr2  =bookroute  返回  #课目主线
		#param[out] 命令字出口:
		CmdOStr1  =userid       #使用者标识
		CmdOStr2  =rrl          #主线层级代码
		CmdOStr3  =title        #任务标题
		CmdOStr4  =learnseq     #计划顺序
		CmdOStr5  =eflncode     #有效学习状态码
		CmdOStr6  =lnstatus     #任务状态；A=未开始，R=执行中，Z=已完成*/
		
		public static const LIST_TODAY_TASK:String = "USERAS.ListTodayTask(gdgz)";
		/*@=查询在学主线任务数目  #苹果树展示
			SrcFName  =useras.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		#param[out] 命令字出口:
		CmdOStr1  =userid       #使用者标识
		CmdOStr2  =bookroute    #课目主线
		CmdOStr3  =title        #主线标题
		CmdOStr4  =tasknum      #主线任务数*/
		public static const LIST_LN_RRL:String = "USERAS.ListLnRrl(gdgz)";
		/*@=查询在学主线任务列表  #苹果树展示
			SrcFName  =useras.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		CmdIStr2  =bookroute    #课目主线
		#param[out] 命令字出口:
		CmdOStr1  =userid       #使用者标识
		CmdOStr2  =rrl          #主线层级代码
		CmdOStr3  =title        #任务标题
		CmdOStr4  =fruitpxy     #[frut] 果子位置坐标
		CmdOStr5  =lnloginval   #任务安排阈值
		CmdOStr6  =eflncode     #有效学习状态码
		CmdOStr7  =learncnt     #学习计数
		CmdOStr8  =todaytask    #是否当日计划任务；Y=是当日计划任务，N=不是当日计划任务
		CmdOStr9  =todayfinish  #是否当日完成的任务；Y=当日完成的任务，N=不是当日完成的任务*/
		public static const LIST_LN_TASK:String = "USERAS.ListLnTask(gdgz)";
		/*服务程序 BOOKCX
		[QueryAllPicbook]
		@=查询所有绘本          #提供给as前台获取所有绘本
		SrcFName  =rank.c       #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		#param[out] 命令字出口:
		CmdOStr1  =rankid       #绘本主线层级标识
		CmdOStr2  =rrl          #绘本主线层级代码
		CmdOStr3  =title        #绘本标题，简述*/
		public static const QUERY_ALL_PICBOOK:String = "BOOKCX.QueryAllPicbook(gdgz)";
		
		/*获取所有绘本基本信息********************王途整理
		服务器程序USERWJ
		调用示例 USERWJ.ListUserPicBook
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr5  ="All"    	#书架代码
		#param[out] 命令字出口:
		CmdOStr1  =rankid       #主线层级标识
		CmdOStr2  =rrl          #主线层级代码
		CmdOStr3  =title        #标题，简述
		CmdOStr4  =facepath    #上架分类代码；取值参见 RACK_CLASS 参数*/
		public static const List_User_PicBook:String = "USERWJ.ListUserPicBook(gdgz)";
		
		/*获取绘本要更新的封面信息********************王途整理
		服务器程序USERWJ
		调用示例 USERWJ.ListNewUserPicBook
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr5  ="All"    #书架代码
		#param[out] 命令字出口:
		CmdOStr1  = id     		#素材id
		CmdOStr2  = title        #文件名
		CmdOStr3  = category     #文件类型
		CmdOStr4  =version       #最新版本
		CmdOStr5 = updateFlag    #强制下载标志
		CmdOstr6 = size 		 #文件大小*/
		public static const List_New_User_PicBook:String = "USERWJ.ListNewUserPicBook(gdgz)";
		
		/*获取绘本要更新的封面信息********************王途整理
		服务器程序USERWJ
		调用示例 USERWJ.ListNewUserRrl
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr5  =rrl    		#rrl串
		#param[out] 命令字出口:
		CmdOStr1  = id     		#素材id
		CmdOStr2  = SourcePath   #文件名
		CmdOStr3  = category     #文件类型
		CmdOStr4  =version       #最新版本
		CmdOStr5 = updateFlag    #强制下载标志
		CmdOstr6 = size 		 #文件大小*/
		public static const List_User_Rrl:String = "USERWJ.ListUserRrl(gdgz)";
		
		/*获取绘本要更新的封面信息********************王途整理
		服务器程序USERWJ
		调用示例 USERWJ.ListNewUserRrl
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr5  =rrl    		#rrl串
		#param[out] 命令字出口:
		CmdOStr1  = id     		#素材id
		CmdOStr2  = SourcePath   #文件名
		CmdOStr3  = category     #文件类型
		CmdOStr4  =version       #最新版本
		CmdOStr5 = updateFlag    #强制下载标志
		CmdOstr6 = size 		 #文件大小*/
		public static const List_New_User_Rrl:String = "USERWJ.ListNewUserRrl(gdgz)";		
		
		/*#param[in] 命令字入口:********************王途整理
		CmdIStr0  =USERRW.SubmitTaskPicBook(gdgz)
		CmdIStr1  =userid       #使用者标识
		CmdIStr2  =rrl          #单词分组主线层级
		CmdIStr3  =rrlid        #对应 book.erank.eranid
		CmdIStr4  =learnsec     #学习时长(秒数)，由Flash客户端返回
		CmdIStr5  =timebeg      #开始学习时间(YYYYMMDD-hhnnss)；
		CmdIStr6  =timeend      #结束学习时间(YYYYMMDD-hhnnss)；
		CmdIStr7  =quitpageno   #学习页数(退出时最大页号)
		CmdIStr8  =totalpage    #绘本总页数
		#param[out] 命令字出口:*/
		public static const Submit_Task_Pic_Book:String = "USERRW.SubmitTaskPicBook(gdgz)";
		
		
		/*[applwatchmovice]
		@=学生观看轨迹记录
		SrcFName = markatr.c  #C源码所在文件名
		CmdTypeN = 1:1     	  #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 = sid   			#学生标识
		CmdIStr2 = goodid     #物品标识
		#param[out] 命令字出口:
		#成功
		CmdOStr0 ="000"				#成功代码
		CmdOStr1 = infoinstid #轨迹标识
		CmdOStr2 =msgid				#成功修改
		USERYW*/
		public static const Video_Watch_Sure:String = "USERYW.applwatchmovice(gdgz)";
		
		
		
		/*@=获取游戏运行时间
		SrcFName  =task3.c      #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid          #用户标识
		CmdIStr2  =videoids     #视频ids[标识]
		CmdIStr3  =videoid      #视频id
		CmdIStr4  =wtimes       #申请时长(分钟) 整数
		#param[out] 命令字出口:
		CmdOStr0  = 结果状态码   , 000 正常, 0M1 异常
		CmdOStr1  = 参数         , 容许时长, 提示语句*/
		public static const CHECK_PLAY_VIDEO:String = "USERRW.CheckPlayVideo(gdgz)";

		
		/*#param[in] 命令字入口:********************王途整理
		CmdIStr0  =USERRW.ListAllNewUserRrl(gdgz)
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr5  =rrl    		#rrl串
		#param[out] 命令字出口:
		CmdOStr1  = id     		#素材id
		CmdOStr2  = SourcePath   #文件名
		CmdOStr3  = category     #文件类型
		CmdOStr4  =version       #最新版本
		CmdOStr5 = updateFlag    #强制下载标志
		CmdOstr6 = size 		 #文件大小*/
		public static const List_All_NewUser_Rrl:String = "USERWJ.ListAllNewUserRrl(gdgz)";
								
		/*[USERWJ.QuiryBookStore]:********************王途整理
		@=获取书仓数据信息]
		SrcFName  =bookwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr3  =range        #查询数据范围 100,50 [limit 语法]
		#param[out] 命令字出口:
		CmdOStr1  =rankid       #主键
		CmdOStr2  =rrl          #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
		CmdOStr3  =???          #系列标题；
		CmdOStr4  =title        #标题(书名)
		CmdOStr5  =???          #评级
		CmdOStr6  =???          #价格
		CmdOStr7  =???          #适合年龄
		CmdOStr8  =???          #新书标记
		CmdOStr9  =???          #作者*/
		public static const Quiry_Book_Store:String = "USERWJ.QuiryBookStore(gdgz)";
		
		/*[AddUserBooks]*******************王途整理
		@=给用户书架增加多本书
			SrcFName  =task.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =buserid      #购书者用户id
		CmdIStr2  =bookid       #书id, id1,id2,id3,...
			CmdIStr3  =rrl          #空
		CmdIStr4  =userid       #目标用户id
		CmdIStr5  =shelf        #书架代码
		CmdIStr6  =memo         #备注信息
		#param[out] 命令字出口:*/
		public static const Add_User_Books:String = "USERRW.AddUserBooks(gdgz)";

		/*[ExchgUserBook]********************王途整理
		@=移动用户书架上一本书
			SrcFName  =task.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #用户id
		CmdIStr2  =shelf        #书架代码
		CmdIStr3  =bookid1      #书id1
		CmdIStr4  =rrl1         #book 对应rrl1  原位置书
		CmdIStr3  =bookid2      #书id2
		CmdIStr4  =rrl2         #book 对应rrl2  移动到位置书		
		#param[out] 命令字出口:*/
		public static const Exchg_User_Book:String = "USERRW.ExchgUserBook(gdgz)";
		
		
		/*[DelUserBook]********************王途整理
		@=删除用户书架上一本书
			SrcFName  =task.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #用户id
		CmdIStr2  =shelf        #书架代码
		CmdIStr3  =bookid       #书id
		CmdIStr4  =rrl          #book 对应rrl
		#param[out] 命令字出口
		杨军仓(杨军仓) 15:50:16*/
		public static const Del_User_Book:String = "USERRW.DelUserBook(gdgz)";
		
		
		/*[PlayGameTime]
		@=获取游戏运行时间
			SrcFName  =task3.c      #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid          #用户标识
		CmdIStr2  =gamename     #游戏名称[标识]
			CmdIStr3  =wtimes       #申请时长(秒)
		#param[out] 命令字出口:
		CmdOStr0  =结果状态码
			CmdOStr1  =atimes         #容许时间长度(秒)
		CmdOStr2  =msg            #提示信息*/
		public static const Play_Game_Time:String = "USERRW.PlayGameTime(gdgz)";
		
		/*[OpenGameInfo]
		@=用户开启游戏
		SrcFName  =gameinfo.c     #C源码所在文件名
		CmdTypeN  =1:1            #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =gidstr            #游戏标识
		CmdIStr2  =sid            #用户标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        #错误代码
		#”000”=游戏开启成功
		#"M00"=该游戏已经开启
		#”M01”=游戏不存在
		#”M02”=用户金币不足
		#"MMM"=其他错误
		CmdOStr1  =errMsg       #失败提示信息*/
		public static const Open_Game_Info:String = "USERYW.OpenGameInfo(gdgz)";
		
		/*[QueryGameInfo]
		@=查询游戏信息
			SrcFName  = gameinfocx.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  = title        #游戏名称, 支持(*)匹配
			CmdIStr2  = Fontname   #关联封面素材,支持(*)匹配,取值(*)匹配所有
			CmdIStr3  = APKname   #关联APK安装包素材名称,取值(*)匹配所有
		CmdIStr4  = lastOpt     #最后修改人,取值(*)匹配所有
			CmdIStr5  = begdate    #最后修改起始日期；取值00000000表示不参与条件
		CmdIStr6  = enddate    #最后修改结束日期；取值YYYYMMDD表示不参与条件
		#param[out] 命令字出口:
		CmdOStr1  =gidstr      #游戏标识
		CmdOStr2  =title       #游戏名称
		CmdOStr3  =Fontwbid   #关联封面素材
		CmdOStr4  =Fontname  #关联封面素材名称 
		CmdOStr5  =APKwbid   #关联APK安装包素材
		CmdOStr6  = APKname  #关联APK安装包素材名称
		CmdOStr7  =openpoint #开启该游戏所需要的点数(金币)
		CmdOStr8  =point     #pointtype为单位的消耗点数
		CmdOStr9  =level     # 1~5 评级说明
		CmdOStr10 =lastOpt     #最后修改人
		CmdOStr11 = lasttime      #最后修改时间
		
		CmdOStr12 = apptype     #应用类型*/
		public static const Query_Game_Info:String = "BOOKCX.QueryGameInfo(gdgz)";
		
		
		/*【USERCX】
		[QryUserGameInfo]
		@=查询游戏信息(关联用户)
		SrcFName  =gameinfo.c      #C源码所在文件名
		CmdTypeN  =1:N          	  #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid        			#学生标识
		CmdIStr2  =title       			#游戏名称,支持(*)匹配,取值(*)匹配所有
		#param[out] 命令字出口:
		CmdOStr1  =gidstr       		#游戏标识
		CmdOStr2  =title      			#游戏名称
		CmdOStr3  =Fontwbid  				#关联封面素材
		CmdOStr4  =Fontname  		    #关联封面素材名称 
		CmdOStr5  =APKwbid   				#关联APK安装包素材
		CmdOStr6  =APKname  	    	#关联APK安装包素材名称
		CmdOStr7  =openpoint  			#开启该游戏所需要的点数(金币)
		CmdOStr8  =point      			#pointtype为单位的消耗点数
		CmdOStr9  =level       	    #1~5 评级说明
		CmdOStr10 =IsOpen    			  #该游戏是否已开启 Y 开启 N 未开启
		CmdOStr11 =apptype          #应用类型 */
		public static const Query_User_Game_Info:String = "USERCX.QryUserGameInfo(gdgz)";
		
		
		
		
						
		/*[AddFAQQueInfo]********************王途整理
		@=用户添加FAQ问题
		SrcFName  = faq.c     		#C源码所在文件名
		CmdTypeN  =1:1          	#命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  = sid           	#提交该问题学生标识
		CmdIStr2  = mtitle			#菜单名称
		CmdIStr3  = text     			#FAQ文本内容
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       		#错误代码
		#"MMM"=其他错误
			CmdOStr1  =errMsg       	#失败提示信息
		#成功
		CmdOStr0 ="000"					#成功代码
		CmdOStr1 =sucMsg					#成功提示信息
		CmdIStr2 =faqid						#成功插入后的faqid*/
		public static const Send_FAQ_Info:String = "USERYW.AddFAQQueInfo(gdgz)";
//		public static const Send_FAQ_Info:String = 'USERYW.AddFAQQueInfoNew(gdgz)';
		
		
		/*[InSpecialFAQ]
		@=插入特殊FAQ问题
		SrcFName  = faq.c     		#C源码所在文件名
		CmdTypeN  =1:1          	#命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  = sid          	#提交该问题学生标识
		CmdIStr2  = mtitle				#菜单名称
		CmdIStr3  = status        #状态
		CmdIStr4  = readstatus    #阅读状态
		CmdIStr5  = faqtext     	#FAQ文本内容
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       		#错误代码
		#"MMM"=其他错误
		CmdOStr1  =errMsg       	#失败提示信息
		#成功
		CmdOStr0 ="000"						#成功代码
		CmdOStr1 =sucMsg					#成功提示信息
		CmdIStr2 =faqid						#成功插入后的faqid*/
		public static const SEND_FAQ_TRANSLATION:String = 'USERYW.InSpecialFAQ(gdgz)';
		
		/*USERCX
		[SelectFAQBySid]
		@=用户查看FAQ问题
		SrcFName  =bag.c     		#C源码所在文件名
		CmdTypeN  =1:N          	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  = sid          	#提交问题的学生标识  *参与模糊查询
		CmdIStr2  = count           #返回条数
		CmdIStr3  = beg             #起始号码(以0开始)
		CmdIStr4  = status          #问题状态(N:已回复并未读,空或其它:全部)
		#param[out] 命令字出口:
		CmdOStr1  = faqid			#FAQ问题标识 :全局唯一标识
		CmdOStr2  = sid				#提交该问题学生标识
		CmdOStr3  = mtitle			#菜单名称
		CmdOStr4  = statues			#FAQ疑问状态
		CmdOStr5  = faqoprtime		#问题修改时间
		CmdOStr6  = ansopt			#答复提交人
		CmdOStr7  = ansoprtime		#最后答复时间
		CmdOStr8  = faqtext@&#anstext	#FAQ及答复文本内容*/
		public static const Get_FAQ_Info:String = "USERCX.SelectFAQBySid(gdgz)";

		

		
		
		/*[SelectFAQTreeBySid]
		@=用户查看FAQ问题树
		SrcFName  =bag.c     		#C源码所在文件名
		CmdTypeN  =1:N          	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  = sid          		#提交问题的学生标识 
		#param[out] 命令字出口:
		CmdOStr1  = faqid				#FAQ问题标识 :全局唯一标识
		CmdOStr2  = sid				#提交该问题学生标识
		CmdOStr3  = mtitle			#菜单名称
		CmdOStr4  = statues			#FAQ疑问状态
		CmdOStr5  = faqoprtime		#问题提出时间
		CmdOStr6  = faqtext	      	#FAQ前20个字符
		CmdOStr7  = readstatues		#阅读状态*/
//		public static const Select_FAQ_Tree:String = "USERCX.SelectFAQTreeBySid(gdgz)";		
		
		/*[SelectFAQInfo]
		@=用户查看FAQ问题
		SrcFName  = bag.c     		#C源码所在文件名
		CmdTypeN  =1:1          	#命令字类型;1:1		
		#param[in] 命令字入口:
		CmdIStr1  = faqid           	#问题ID号
		CmdIStr2 = "S";					代表平板
		#param[out] 命令字出口:
		CmdOStr1  = faqid				#FAQ问题标识 :全局唯一标识
		CmdOStr2  = sid				#提交该问题学生标识
		CmdOStr3  = mtitle			#菜单名称
		CmdOStr4  = statues			# FAQ疑问状态
		CmdOStr5  = readstatues		#阅读状态
		CmdOStr6  = faqoprtime		#问题修改时间
		CmdOStr7  = ansopt			#答复提交人
		CmdOStr8  = ansoprtime		#最后答复时间
		CmdOStr9  = faqtext@&# anstext	#FAQ及答复文本内容*/
//		public static const Select_FAQ_Info:String = "USERYW.SelectFAQInfo(gdgz)";

		
		
		/*获取所有上架的绘本列表：
		服务程序：BOOKWJ
		调用示例：BOOKWJ.ListAllPicBook
		[ListAllPicBook]
		@=获取所有上架的绘本列表
		SrcFName  =bookwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr3  =hexserial    #16进制的注册码串;
		CmdIStr4  =regmacno6    #安装注册时绑定的客户端6字节网卡地址，格式: XX-XX-XX-XX-XX-XX;
		CmdIStr5  =rackclass    #上架分类代码；取值(*)匹配所有
		#param[out] 命令字出口:
		CmdOStr1  =rankid       #主线层级标识
		CmdOStr2  =rrl          #主线层级代码
		CmdOStr3  =title        #标题，简述
		CmdOStr4  =rackclass    #上架分类代码；取值参见 RACK_CLASS 参数
		CmdOStr5  =racktime     #上架时间(YYYYMMDD-hhnnss)；
		CmdOStr6  =showtags     #展示关联标签列表(英文逗号分隔开的 CLASS_TAG 参数)
		CmdOStr7  =txtbrief     #文本格式的内容简介*/
//		public static const List_ALL_PICBOOK:String = "BOOKWJ.ListAllPicBook(gdgz)";
		
		/*
		服务程序：BOOKWJ
		调用示例：BOOKWJ.ListAllFaceFile
		[ListAllFaceFile]
		@=强制更新，获取指定主线层级的封面素材文件列表
		SrcFName  =bookwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr3  =hexserial    #16进制的注册码串;
		CmdIStr4  =regmacno6    #安装注册时绑定的客户端6字节网卡地址，格式: XX-XX-XX-XX-XX-XX;
		CmdIStr5  =rankidlist   #逗号分隔的主线层级标识列表
		#param[out] 命令字出口:
		CmdOStr1  =rankid       #主线层级标识
		CmdOStr2  =wbid         #素材文件标识;
		CmdOStr3  =wfname       #带相对（于 WBINFROOT=/home/cpyf/<wbfkind> ）路径的文件名；带扩展名
		CmdOStr4  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
		CmdOStr5  =version      #最新版本号；
		CmdOStr6  =verforce     #需强制更新的最大版本号
		CmdOStr7  =localfsize   #上次上载本地文件大小；
		*/
//		public static const LIST_ALL_FACE:String = "BOOKWJ.ListAllFaceFile(gdgz)";
		
		/*
		服务程序：USERWJ
		调用示例：USERWJ.ListNewerFace
		[ListNewerFace]
		@=获取客户机指定主线层级需要更新的封面素材文件列表
		SrcFName  =userwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr3  =hexserial    #16进制的注册码串;
		CmdIStr4  =regmacno6    #安装注册时绑定的客户端6字节网卡地址，格式: XX-XX-XX-XX-XX-XX;
		CmdIStr5  =rankidlist   #逗号分隔的主线层级标识列表
		#param[out] 命令字出口:
		CmdOStr1  =rankid       #主线层级标识
		CmdOStr2  =wbid         #素材文件标识;
		CmdOStr3  =wfname       #带相对（于 WBINFROOT=/usr1/snet/swf/ ）路径的文件名；带扩展名
		CmdOStr4  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
		CmdOStr5  =version      #最新版本号；
		CmdOStr6  =ynforce      #是否需要强制更新才能运行
		CmdOStr7  =localfsize   #上次上载本地文件大小；*/
//		public static const LIST_NEWER_FACE:String = "USERWJ.ListNewerFace(gdgz)";
		
		
		
		/*强制更新，获取主线层级关联的所有素材文件列表:
		服务程序：BOOKWJ
		调用示例：BOOKWJ.ListAllRrlFile
		[ListAllRrlFile]
		@=强制更新，获取主线层级关联的所有素材文件列表
		SrcFName  =bookwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr3  =hexserial    #16进制的注册码串;
		CmdIStr4  =regmacno6    #安装注册时绑定的客户端6字节网卡地址，格式: XX-XX-XX-XX-XX-XX;
		CmdIStr5  =rrl          #主线层级代码
		#param[out] 命令字出口:
		CmdOStr1  =wbid         #素材文件标识;
		CmdOStr2  =wfname       #带相对（于 WBINFROOT=/usr1/snet/swf/ ）路径的文件名；带扩展名
		CmdOStr3  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
		CmdOStr4  =version      #最新版本号；*/
//		public static const List_ALL_RRL_FILE:String = "BOOKWJ.ListAllRrlFile(gdgz)";
		
		/*获取客户机指定主线层级需要更新的素材文件列表:
		服务程序：USERWJ
		调用示例：USERWJ.ListNewerRrlFile
		[ListNewerRrlFile]
		@=获取客户机指定主线层级需要更新的素材文件列表
		SrcFName  =userwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr3  =hexserial    #16进制的注册码串;
		CmdIStr4  =regmacno6    #安装注册时绑定的客户端6字节网卡地址，格式: XX-XX-XX-XX-XX-XX;
		CmdIStr5  =rrl          #主线层级代码
		#param[out] 命令字出口:
		CmdOStr1  =wbid         #素材文件标识;
		CmdOStr2  =wfname       #带相对（于 WBINFROOT=/usr1/snet/swf/ ）路径的文件名；带扩展名
		CmdOStr3  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
		CmdOStr4  =version      #最新版本号；
		CmdOStr5  =ynforce      #是否需要强制更新才能运行*/
//		public static const List_NEWER_RRL_FILE:String = "USERWJ.ListNewerRrlFile(gdgz)";

		
		
		
		/*服务程序： BOOKYW
		[DownloadASON]
		@=下载主线层级关联ASON脚本文本
		SrcFName  =rank.c       #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =rankid/rrl   #主线层级标识或rrl
		CmdIStr2  =offset       #起始下载位置，取值非零表示是续传；该命令字返回!!!并不表示下载结束。
		CmdIStr3  =step         #一次返回的字节数；最长不超过32KB；一般约定3KB；
		#param[out] 命令字出口:
		#成功
		CmdOStr1  =fsize        #文件总长度
		CmdOStr2  =downlen      #已传文件长度，取值与文件总长度相同，表示下载结束
		CmdOStr3  =retlen       #本次返回内容的长度
		CmdOStr4  =txt          #本次返回的文件内容，超长串
		#失败
		CmdOStr0  =errno        #错误代码
		#"M00"=主线层级不存在
		#"M10"=主线层级关联ASON脚本文本不存在
		#"MMM"=其他错误
		CmdOStr1  =errMsg       #失败提示信息*/
//		public static const DOWN_LOAD_ASON:String = "BOOKYW.DownloadASON(gdgz)";
		
		
		/*[DownHostFile]
		@=下载文件          #命令字功能描述;
		SrcFName=_wftp.c     #C源码所在文件名
		CmdTypeN=1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1=主机文件名，下载时客户端需要先将内容写入到临时文件；
			#下载结束需要检查后台返回的文件长度与本地是否一致，然后再更改正式文件名；
			#（应用逻辑中可能是相对路径文件）
			CmdIStr2=起始下载位置，取值非零表示是续传；该命令字返回!!!并不表示下载结束。
				CmdIStr3=一次返回的字节数；最长不超过32KB；一般约定3KB；
		#param[out] 命令字出口:
		CmdOStr1=文件总长度
		CmdOStr2=已传文件长度，数值CmdOStr2=CmdOStr1时，表示下载结束
		CmdOStr3=本次返回内容的长度
		CmdOStr4=本次返回的文件内容*/
		public static const DOWN_HOST_FILE:String = "SNFILE.DownHostFile(@000)";
		
		/**
		 *[DownPerDataFileFromHost]
		 @=录入人员查看文件
		 SrcFName  = userwj.c 	#C源码所在文件名
		 CmdTypeN  =1:1      	#命令字类型;1:1
		 #param[in] 命令字入口:
		 CmdIStr1  =operid     
		 CmdIStr1  =wfname   	#带相对（于 WBINFROOT=/home/cpyf/userdata/<upoperid> ）路径的文件名；带扩展名
		 CmdIStr2  =offset  		#起始下载位置，取值非零表示是续传；该命令字返回!!!并不表示下载结束。
		 CmdIStr3  =step      	#一次返回的字节数；最长不超过32KB；一般约定3KB；
		 #param[out] 命令字出口:
		 #成功
		 CmdOStr1  =fsize   		#文件总长度
		 CmdOStr2  =downlen   	#已传文件长度，取值与文件总长度相同，表示下载结束
		 CmdOStr3  =retlen  		#本次返回内容的长度
		 CmdOStr4  =txt     		#本次返回的文件内容，超长串
		 #失败
		 CmdOStr0  =errno   		#错误代码
		 #"M00"=用户文件不存在
		 #"MMM"=其他错误
		 CmdOStr1  =errMsg    	#失败提示信息 
		 */		
		public static const DOWN_PERSON_FILE:String = "USERWJ.DownPerDataFileFromHost(gdgz)";
		
		/*@=注册客户机
			SrcFName  =mac.c      #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =regoperid  #安装注册工号标识
		CmdIStr2  =regmacno6  #安装注册时绑定的客户端6字节网卡地址，格式: XX-XX-XX-XX-XX-XX;
		CmdIStr3  =mackindos  #客户机系统类型；取值参见 MAC_KIND_OS 参数
		CmdIStr4  =mactypestr #客户机型号名称；
		CmdIStr5  =foropercode#目标用户的登录帐号；
		CmdIStr6  =forregion  #目标用户归属区域
		#param[out] 命令字出口:
		CmdOStr1  =macid      #客户机标识
		CmdOStr2  =hexserial  #16进制的注册码串;*/
		public static const REGISTER_MAC:String = "OPERYW.RegisterMac";
		
		
		/*flash前台获取客户机需要更新的素材文件列表命令字：
		服务程序：USERWJ
		调用示例：USERWJ.ListNewerBinFile(学生所在区域，如gdgz)
		[ListNewerBinFile]
		@=获取客户机需要更新的素材文件列表
		SrcFName  =userwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr3  =hexserial    #16进制的注册码串;
		CmdIStr4  =regmacno6    #安装注册时绑定的客户端6字节网卡地址，格式: XX-XX-XX-XX-XX-XX;
		CmdIStr5  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
		#param[out] 命令字出口:
		CmdOStr1  =wbid         #素材文件标识;
		CmdOStr2  =wfname       #带相对（于 WBINFROOT=/usr1/snet/swf/ ）路径的文件名；带扩展名
		CmdOStr3  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
		CmdOStr4  =version      #最新版本号；
		CmdOStr5  =ynforce      #是否需要强制更新才能运行*/
		public static const LIST_NEWER_BIN_FILE:String = "USERWJ.ListNewerBinFile(gdgz)";
		
		/*获取服务端素材文件列表命令字：
		服务程序：BOOKWJ
		调用示例：BOOKWJ.ListAllBinFile
			[ListAllBinFile]
			@=强制更新，获取所有素材文件列表
			SrcFName  =bookwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #工号标识；
		CmdIStr2  =macid        #客户机标识
		CmdIStr3  =hexserial    #16进制的注册码串;
		CmdIStr4  =regmacno6    #安装注册时绑定的客户端6字节网卡地址，格式: XX-XX-XX-XX-XX-XX;
		CmdIStr5  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
			#param[out] 命令字出口:
		CmdOStr1  =wbid         #素材文件标识;
		CmdOStr2  =wfname       #带相对（于 WBINFROOT=/usr1/snet/swf/ ）路径的文件名；带扩展名
			CmdOStr3  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
				CmdOStr4  =version      #最新版本号；*/
//		public static const LIST_ALL_BIN_FILE:String = "BOOKWJ.ListAllBinFile(gdgz)";
		public static const LIST_ALL_BIN_FILE:String = "USERWJ.ListAllBinFileForPad(gdgz)";
		
		public static const LIST_ALL_BIN_FILE_AUTO:String = "USERWJ.ListAllBinFileForPadauto(gdgz)";
		
		
		/*flash前台下载素材文件命令字：
		服务程序：USERWJ
		调用示例：USERWJ.DownHostFile(学生所在区域，如gdgz)
			[DownHostFile]
			@=下载素材文件          #命令字功能描述;
		SrcFName  =userwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =macid        #客户端标识
		CmdIStr2  =doperid      #下载工号标识；
		CmdIStr3  =wbid         #素材文件标识;
		CmdIStr4  =version      #ListNewerBinFile命令字返回的最新版本号
		CmdIStr5  =wfname       #带相对（于 WBINFROOT=/usr1/snet/swf/ ）路径的文件名；带扩展名
			#下载时需要先将内容写入到临时文件；下载结束需要检查文件长度
			CmdIStr6  =offset       #起始下载位置，取值非零表示是续传；该命令字返回!!!并不表示下载结束。
			CmdIStr7  =step         #一次返回的字节数；最长不超过32KB；一般约定3KB；
		#param[out] 命令字出口:
		#成功
		CmdOStr1  =fsize        #文件总长度
		CmdOStr2  =downlen      #已传文件长度，取值与文件总长度相同，表示下载结束
		CmdOStr3  =retlen       #本次返回内容的长度
		CmdOStr4  =txt          #本次返回的文件内容，超长串
		#失败
		CmdOStr0  =errno        #错误代码
		#"M00"=素材文件不存在
			#"MMM"=其他错误
			CmdOStr1  =errMsg       #失败提示信息*/

		public static var USERWJ_DOWN_HOST_FILE:String = "USERWJ.DownHostFile(gdgz)";
		
		/*[QueryYYZSTree]
		@=查询英语知识点树形路径
			SrcFName  =zhishi.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =ptreeid      #归属父路径标识；最初从-1开始查询;取值0表示不参与条件
		CmdIStr2  =treekd       #应用路径类型;取值*表示不参与条件
			#param[out] 命令字出口:
		CmdOStr1  =treeid       #树形路径标识；
		CmdOStr2  =treekd       #应用路径类型；
		CmdOStr3  =pathstr      #当前路径串；
		CmdOStr4  =ptreeid      #归属父路径标识；取值-1表示没有父路径
		CmdOStr5  =seqno        #在同一父路径下的显示顺序号
		CmdOStr6  =yyzsid       #关联英语知识点标识;*/
		public static const BOOKCX_QUERY_YYZSTREE:String = "BOOKCX.QueryYYZSTree(gdgz)";
		
		
		/*获取指定单词任务的单词列表命令字：
		调用示例：USERAS.ObtainWordListThe(gdgz)
			[ObtainWordListThe]
			@=获取单词列表
			SrcFName  =word.c       #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid       #操作员标识
		CmdIStr2  =rrl          #单词分组主线层级
		#param[out] 命令字出口:
		CmdOStr1  =rrl          #单词分组主线层级
		CmdOStr2  =grpcode      #分组代码,LExxx
		CmdOStr3  =wordid       #单词标识
		CmdOStr4  =wordstr      #单词串
		CmdOStr5  =soundmark    #音标
		CmdOStr6  =meanbasic    #中文含义
		CmdOStr7  =mmethod      #记忆法
		CmdOStr8  =soundfn      #发音文件标识字母
		CmdOStr9  =starttime    #发音起始毫秒数
		CmdOStr10 =durtime      #发音持续毫秒数
		CmdOStr11 =mean         #匹配汉语含义*/
		public static const OBTAIN_WORD_LIST_THE:String = "USERAS.ObtainWordListThe(gdgz)";
		public static const OBTAIN_WORD_FOR_BROWSE:String = "USERAS.ObtainWord4Browse(gdgz)";
		public static const SUBMIT_WORD_FOR_BROWSE:String = "USERAS.SubmitWord4Browse(gdgz)";

		
		
		/*[BeginOneTask]
		@=开始一个任务
			SrcFName  =task.c       #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid       #使用者标识
		CmdIStr2  =rrl          #主线层级代码
		#param[out] 命令字出口:
		调用示例：USERAS.BeginOneTask(gdgz)*/
		public static const BEGIN_ONE_TASK:String = "USERAS.BeginOneTask(gdgz)";
//		public static const BEGIN_WORD_BROWSE:String = "USERAS.BeginWord4Browse(gdgz)";
		
		//	登陆获取谚语
//		public static const LOGIN_GET_SCRIPT:String = "USERAS.ObtainScript(gdgz)";
		
		
		/*[GetHostDateTime]
		@=取得主机时间   #命令字功能描述;
		SrcFName=file.c  #C源码所在文件名
		CmdTypeN=1:1     #命令字类型;1:1/N
		#param[in] 命令字入口:
		#param[out] 命令字出口:
		CmdOStr1=时
			CmdOStr2=分
			CmdOStr3=秒
			CmdOStr4=年
			CmdOStr5=月
			CmdOStr6=日
			CmdOStr7=星期
			SNFILE.GetHostDateTime(@000)
		o_Str[0].3=000=
		o_Str[1].2=11=
		o_Str[2].2=17=
		o_Str[3].2=26=
		o_Str[4].4=2012=
		o_Str[5].1=2=
		o_Str[6].1=1=
		o_Str[7].1=3=
		i_Str[0].28=SNFILE.GetHostDateTime(@000)=
		*/
		public static const GET_HOST_DATETIME:String = "SNFILE.GetHostDateTime(@000)";
		
		/*[SelectStudent]
		@=查询学生
			SrcFName  =useryw.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =opcode     #学生登录账号
		CmdIStr2  =sid        #学生标识，当opcode取值为空时sid才参与条件查询
		#param[out] 命令字出口:
		CmdOStr1  =operid     #操作员标识
		CmdOStr2  =opcode     #登录帐号;自己注册的;一般选QQ号或者email;
		CmdOStr3  =operst     #操作员状态；取值参见 OPERST 参数;
		CmdOStr4  =nickname   #操作员昵称
		CmdOStr5  =realname   #真实姓名
		CmdOStr6  =smstelno   #可收短信手机号
		CmdOStr7  =logintm1   #首次登录时间(YYYYMMDD-hhmmss)
		CmdOStr8  =logincnt   #正常登录次数，不包括附加登录
		CmdOStr9  =lastlogtm  #上次登录时间(YYYYMMDD-hhnnss)
		CmdOStr10 =lastlogip  #上次登录IP等信息; 格式: SNPORT网内标识~SNPORT守护的IP~SNPORT守护的PORT
		CmdOStr11 =errorcnt   #登录错误计数
		CmdOStr12 =cntsocket  #附加登录次数，正常登录后清零；另外建立socket连接的数目
		CmdOStr13 =birth      #生日(YYYYMMDD)
		CmdOStr14 =mtomrrow   #某主线当日计划生成后，间隔多少分钟(0~1440)，可以生成下一天任务。
		CmdOStr15 =qanswer1   #提问及答案
		CmdOStr16 =lixiang    #理想
		CmdOStr17 =aihao      #爱好
		CmdOStr18 =smile      #心情状态
		CmdOStr19 =school     #所在学校名称
		CmdOStr20 =sclass     #所在班级名称
		CmdOStr21 =lsparent   #家长列表
		CmdOStr22 =lsassist   #辅导员列表
		#失败
		CmdOStr0  =errno      #错误代码
		#"M00"=学生不存在
			#"MMM"=其他错误
			CmdOStr1  =errMsg     #失败提示信息*/
		public static const GET_STUDENT_INFO:String = "USERYW.SelectStudent(gdgz)";
		
		
		/**
		[USERYW.RecordLoginInfo]
		@=记录用户登记信息    #记录用户相关登记经验
		SrcFName  =useryw.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid     #操作员标识
		#param[out] 命令字出口:
		CmdOStr0  =errno      #错误代码
		#"M00"=用户不存在
		#"MMM"=其他错误
		 * */
		public static const RECORD_LOGININFO:String = "USERYW.RecordLoginInfo(gdgz)";
		
		/**
		[UpdateStuSign]
		@=修改学生签名
		SrcFName  =useryw.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid     #操作员标识
		CmdIStr2  =signature  #个性签名
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"M00"=学生不存在
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息
		CmdOStr0  =errno      #错误代码
		#"M00"=学生不存在
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息
		* */
		public static const UPDATE_STU_SIGN:String = "USERYW.UpdateStuSign(gdgz)";
		
		

		
		/**
		 *背包查询命令字如下：
		调用示例：USERYW.SelectBagJson(gdgz)
		[SelectBagJson]
		@=查询用户背包,组织成JSON格式返回
		SrcFName  =bag.c      #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     #用户标识
		CmdIStr2  =bagtype    #归属背包类型；取值参见 book.BAGSACK_TYPE 参数
		#param[out] 命令字出口:
		CmdOStr1  =userid     #用户标识
		CmdOStr2  =bagtype    #归属背包类型；取值参见 book.BAGSACK_TYPE 参数
		CmdOStr3  =goodids    #物品种类数目；占用该背包格子的数目；
		CmdOStr4  =goodcnt    #物品全部数目；不同种类的物品数目累计；
		CmdOStr5  =jsondata   #JSON格式的超长串,例子如下：
                      #GridIndex：背包格子编号
                      #goodid：物品id
                      #goodnum：物品数量 
		 */
//		public static const GET_BAG_ITEM:String = "USERYW.SelectBagJson(gdgz)";
		
		/**
		 * [SelectWallet]
			@=查询用户钱包
			SrcFName  =wallet.c   #C源码所在文件名
			CmdTypeN  =1:1        #命令字类型;1:1/N
			#param[in] 命令字入口:
			CmdIStr1  =userid     #用户标识
			CmdIStr2  =currency   #货币类型;取值参见 book.CURRENCY_CODE 参数;
			#param[out] 命令字出口:
			CmdOStr1  =userid     #用户标识
			CmdOStr2  =currency   #货币类型;取值参见 book.CURRENCY_CODE 参数;
			CmdOStr3  =vipflag    #该钱包VIP标记；普通用户取值0
			CmdOStr4  =value      #货币数目；钱包多少；
			CmdOStr5  =level      #所处等级；通过等级限定用户权限；等级变化不减少value取值
			CmdOStr6  =lastvid    #最新修改异动标识,取值参见 vydtr 表的vid字段;
			CmdOStr7  =opcode     #最后修改人
			CmdOStr8  =opdate     #最后修改时间
		 */
		public static const GET_MONEY:String = "USERYW.SelectWallet(gdgz)";
		
		public static const GET_READING_TASK_ID:String = "USERAS.ListYYReadTaskId(gdgz)";
		
		public static const GET_READING_INFO:String = 'USERRW.ObtainTimuTxt(gdgz)';//根据id串获取详细习题json数据
		
		public static const SUBMIT_READING_TASK:String = "USERAS.SubmitTaskYYRead(gdgz)";
		
		public static const Abandon_Task_YYRead:String = "USERRW.AbandonTaskYYRead(gdgz)";
		
//		public static const GET_CATEGORY_CONTENT:String = "BOOKYW.SelectYYZSText";
		
//		public static const GET_CATEGORY_CONTENT_AS:String = "BOOKYW.SelectYYZSTextAS";
		/**
		 *调用知识点内容之前，预先调用这个命令，判断是否有内容 
		 */
//		public static const SELECT_YYZS:String = "BOOKYW.SelectYYZhiShi";
		
//		public static const GET_EXERCISE:String = "USERAS.ObtainYYExamAs(gdgz)";
		
//		public static const SUBMIT_KNOWLEDGE_TASK:String = "USERRW.SubmitReadPoint(gdgz)";
		
		public static const GET_PRACTICE:String = "BOOKYW.ObtainYYTiMuAS";

		public static const SUBMIT_PRACTICE_TASK:String = "USERRW.SubmitExam(gdgz)";
		public static const AbandomExam:String = 'USERRW.AbandonTaskExam(gdgz)';
		
//		public static const SUBMIT_KNOWLEDGE_POINT_TASK:String = "USERRW.SubmitExpoint(gdgz)";
		
		
		/**
		 * @=传入学生定位信息,返回其他学生定位位置
		 * [USERCX.QryuserlocalInfo]
		 * SrcFName  =userlocatinfo.c   #C源码所在文件名
		 * CmdTypeN  =1:N        #命令字类型;1:1/N
		 * #param[in] 命令字入口:
		 * CmdIStr1  =localid        #场景ID  记录场景ID信息
		 * CmdIStr2  =operid         #操作员ID  
		 * CmdIStr3  =xcoord         #x坐标  
		 * CmdIStr4  =ycoord         #y坐标  
		 * CmdIStr5  =addinfo        #附加信息 
		 * CmdIStr6  =equip          #用户装备信息
		 * #param[out] 命令字出口:
		 * CmdOStr1  =jsontxt       #json超长串信息
		 */
		public static const QRYUSER_LOCALINFO:String = "USERCX.QryuserlocalInfo(gdgz)";
		
		
		
		
		/*[QrySceneUserInfo]
		@=传入一用户位置信息,返回场景内其他用户位置信息
		SrcFName  =userlocatinfo.c   #C源码所在文件名
		CmdTypeN  =1:1               #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =sceneid           #场景标识
		CmdIStr2  =userid            #用户标识
		CmdIStr3  =xcoord            #x坐标
		CmdIStr4  =ycoord            #y坐标
		#param[out] 命令字出口:
		CmdOStr1  =txt               #格式化数据(X:XX,XX;X:X/X,X/X;)*/
		public static const QRY_SCENE_USER_INFO:String = "USERCX.QrySceneUserInfo(gdgz)";
		
		/*[QryLocationInfo]
		@=场景内所有用户的位置
		SrcFName  =userlocatinfo.c   #C源码所在文件名
		CmdTypeN  =1:N               #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sceneid           #场景标识
		CmdIStr2  =userid            #用户标识
		#param[out] 命令字出口:
		CmdIStr1  =userid            #用户标识
		CmdIStr2  =xcoord            #x坐标
		CmdIStr3  =ycoord            #y坐标*/
		public static const QRY_LOCATION_INFO:String = "USERCX.QryLocationInfo(gdgz)";
		
		
		/*{USERCX}
		[QryWorldMessAfId]
		@=显示CmdIStr[1]之后的所有广播
		SrcFName  =message.c    #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =wmesid       #起始标识,（0为默认最新50条）
		#param[out] 命令字出口:
		CmdOStr1  =wmesid       #消息标识
		CmdOStr2  =sedid        #发送者标识
		CmdOStr3  =sedcode      #发送者姓名
		CmdOStr4  =sedtime      #发送时间
		CmdOStr5  =mess         #发送内容*/
		public static const QRY_WORLD_MESS_AFID:String = "USERCX.QryWorldMessAfId(gdgz)";
		
		/*{USERYW}
		[InWorldMess]
		@=插入广播消息
		SrcFName  = faq.c    	    #C源码所在文件名
		CmdTypeN  =1:1           	#命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =wmesid         #消息标识
		CmdIStr2  =sedid          #发送者标识
		CmdIStr3  =sedcode        #发送者名称
		CmdIStr4  =mess           #发送内容
		#param[out] 命令字出口:                
		CmdOStr0  =errno       		#错误代码    
		#"000"=成功                            
		#"MMM"=其他错误                        
		CmdOStr1  =mesid          #命令标识    
		CmdOStr2  =errMsg      		#失败提示信息*/
		public static const IN_WORLD_MESS:String = "USERYW.InWorldMess(gdgz)";
		
		
		
		/**
		 * @=上载素材文件          #命令字功能描述;
		[UpFileToHost]
			@=上载素材文件          #命令字功能描述;
			SrcFName  =userwj.c     #C源码所在文件名
			CmdTypeN  =1:1          #命令字类型;1:1/N
			#param[in] 命令字入口:
			CmdIStr1  =upoperid     #上载工号标识；
			CmdIStr2  =wfname       #带相对（于 WBINFROOT=/home/cpyf/userdata/<upoperid> ）路径的文件名；带扩展名
			CmdIStr3  =fsize        #文件总长度，每次都传输；取值与已传文件长度相同，则表示上载结束；
			CmdIStr4  =uplen        #已传文件长度，取值为0表示开始上载文件；
			CmdIStr5  =length       #本次上传内容长度，用于与CmdStr数组中长度进行校验
			CmdIStr6 =txt          #内容长串，最长32KB
			#param[out] 命令字出口:
			CmdOStr1  =fsize        #文件总长度
			CmdOStr2  =uplen        #已传文件长度
			CmdOStr3  =length       #本次成功上传的长度
			CmdOStr4  =wfname       #带相对（于 WBINFROOT=/home/cpyf/userdata/<upoperid> ）路径的文件名；带扩展名
		 */
		public static const UP_FILE_TO_HOST:String = "USERWJ.UpFileToHost(gdgz)";
		
		/**
		 * [UpPerDataFileToHost]
		 * @=上载个人空间文件        #命令字功能描述;
		 * SrcFName  =userwj.c     #C源码所在文件名
		 * CmdTypeN  =1:1          #命令字类型;1:1/N
		 * #param[in] 命令字入口:
		 * CmdIStr1  =upoperid     #上载工号标识
		 * CmdIStr2  =dememo       #文件描述
		 * CmdIStr3  =wfname       #带相对（于 WBINFROOT=/home/cpyf/userdata/<upoperid> ）路径的文件名；带扩展名
		 * CmdIStr4  =fsize        #文件总长度，每次都传输；取值与已传文件长度相同，则表示上载结束；
		 * CmdIStr5  =uplen        #已传文件长度，取值为0表示开始上载文件；
		 * CmdIStr6  =length       #本次上传内容长度，用于与CmdStr数组中长度进行校验
		 * CmdIStr7  =txt          #内容长串，最长32KB
		 * #param[out] 命令字出口:
		 * CmdOStr1  =fsize        #文件总长度
		 * CmdOStr2  =uplen        #已传文件长度
		 * CmdOStr3  =length       #本次成功上传的长度
		 * CmdOStr4  =wfname       #带相对（于 WBINFROOT=/home/cpyf/userdata/<upoperid> ）路径的文件名；带扩展名
		 */		
		public static const UP_PERSONAL_FILE_TO_HOST:String = "USERWJ.UpPerDataFileToHost(gdgz)";
		
		/**
		 * BOOKWJ
		 [UpFileToHostV1]
		 @=上载素材文件          #命令字功能描述;
		 SrcFName  =bookwj.c     #C源码所在文件名
		 CmdTypeN  =1:1          #命令字类型;1:1/N
		 #param[in] 命令字入口:
		 CmdIStr1  =localmacid   #上载客户端标识
		 CmdIStr2  =upoperid     #上载工号标识；
		 CmdIStr3  =wbfkind      #素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍；
		 CmdIStr4  =wbftype      #素材类别(同一类型素材,不同类别对应不同的硬件): 0=通用；1=类别1；...；N=类别N
		 CmdIStr5  =localftime   #上次上载本地文件时间，供上载程序检查版本判断；
		 CmdIStr6  =ynforce      #是否需要强制更新才能运行
		 CmdIStr7  =wfname       #带相对（于 WBINFROOT=/home/cpyf/<wbfkind> ）路径的文件名；带扩展名
		 CmdIStr8  =fsize        #文件总长度，每次都传输；取值与已传文件长度相同，则表示上载结束；
		 CmdIStr9  =uplen        #已传文件长度，取值为0表示开始上载文件；
		 CmdIStr10 =length       #本次上传内容长度，用于与CmdStr数组中长度进行校验
		 CmdIStr11 =txt          #内容长串，最长32KB
		 #param[out] 命令字出口:
		 CmdOStr1  =fsize        #文件总长度
		 CmdOStr2  =uplen        #已传文件长度
		 CmdOStr3  =length       #本次成功上传的长度
		 CmdOStr4  =wbid         #素材文件标识;上传完成时才返回
		 CmdOStr5  =wfname       #带相对（于 WBINFROOT=/home/cpyf/<wbfkind> ）路径的文件名；带扩展名
		 */
		public static const UPFILETOHOSTV1:String =  "BOOKWJ.UpFileToHostV1";

		
		public static const QUERY_DEALTR:String = "USERCX.QueryDealtr(gdgz)";		
/*		@=查询指定用户任务执行明细
			SrcFName  =usercx.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     #使用者标识，取值0表示不参与条件查询
		CmdIStr2  =yyyymmddb  #起始日志日期(YYYYMMDD)；若无填00000000
		CmdIStr3  =yyyymmdde  #结束日志日期(YYYYMMDD)；若无填YYYYMMDD
		#param[out] 命令字出口:
		CmdOStr1  =userid     #使用者标识
		CmdOStr2  =opcode     #登陆账号
		CmdOStr3  =yyyymmdd   #日志日期(YYYYMMDD)；
		CmdOStr4  =rrl        #知识主线层级；取值参见 ROUTE_RANK_LEVEL 参数；
		CmdOStr5  =timebeg    #开始学习时间(YYYYMMDD-hhnnss)；
		CmdOStr6  =timeend    #结束学习时间(YYYYMMDD-hhnnss)；缺省取值"YYYYMMDD-hhnnss"；
		CmdOStr7  =learnsec   #学习时长(秒数)
		CmdOStr8  =rightnum   #学习正确数
		CmdOStr9  =errornum   #学习错误数
		CmdOStr10 =totalnum   #学习总数*/
		
		public static const MODIFYPASSWORD:String = "USERYW.ModifyPwd(gdgz)";
/*		@=修改用户密码
		SrcFName  =useryw.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =opcode     #操作员登录帐号
		CmdIStr2  =oldpwd     #SHA加密后的旧密码
		CmdIStr3  =newpwd     #SHA加密后的新密码
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"M00"=用户不存在
		#"M10"=密码错误
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		
		public static const MODIFY_STUDENT_INFO:String = "USERYW.UpdateStdCommVal(gdgz)";
		/*[UpdateStdCommVal]
		@=修改学生常用信息
		SrcFName  =useryw.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid     #操作员标识
		CmdIStr2  =nickname   #操作员昵称
		CmdIStr3  =realname   #操作员真实名称
		CmdIStr4  =smstelno   #可收短信手机号
		CmdIStr5  =birthday   #生日
		CmdIStr6  =signature  #个性签名
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"M00"=学生不存在
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		
		public static const QUERYPARENTSBYSTUDENTID:String = "USERCX.QueryParBystd(gdgz)";
/*		@=根据给定学生信息查询对应家长
			SrcFName  =usercx.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid     #学生标识
		#param[out] 命令字出口:
		CmdOStr1  =operid     #家长标识
		CmdOStr2  =opcode     #登录帐号;自己注册的;一般选QQ号或者email;
		CmdOStr3  =pshello    #对应学生称呼  */

		public static const VERFYOPERPASSWORD:String = "USERYW.VerfyOperPwd(gdgz)";
/*		@=检查操作员密码合法性
			SrcFName  =operyw.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =opcode     #登录帐号
		CmdIStr2  =passwd     #SHA加密后密码
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"M00"=被修改者不存在
		#"MMM"=其他错误
		CmdOStr1  =opid       #登录帐号ID
		CmdOStr2  =opcode     #登陆账号
		CmdOStr1  =errMsg     #失败提示信息*/
		
		public static const INSERTTAGETWALL:String = "USERYW.InserttagetWall(gdgz)";
/*		@=插入用户目标墙
			SrcFName  = tagetwall.c      #C源码所在文件名
		CmdTypeN  =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  = pid           #家长标识
		CmdIStr2  = sid           #学生标识
		CmdIStr3  = edate         #目标截止时间  YYYYMMDD
		CmdIStr4  = rwtype        #奖励类型  #A 饮食 B 玩具 C 旅游 D 电子产品 E 其他
		CmdIStr5  = target        #目标内容
		CmdIStr6  = content       #奖励内容
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno         #错误代码
		#"000"=FAQ修改成功
		#"MMM"=其他错误
		CmdOStr1  =errMsg        #失败提示信息*/
		
		public static const QUERYTARGETWALLBYSID:String = "USERCX.QrysidtetagetWall(gdgz)";
/*		@=传入学生标识 返回其对于的目标墙列表
			SrcFName  =tagetwall.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid        #学生标识
		#param[in] 命令字入口:
		CmdIStr1  =targetid        #目标墙ID
		CmdIStr2  =pid             #家长标识
		CmdIStr3  =sid             #学生标识
		CmdIStr4  =sdate           #目标指定时间
		CmdIStr5  =edate           #目标截止时间
		CmdIStr6  =rwtype          #奖励类型
		CmdIStr7  =rwdate          #目标完成时间
		CmdIStr8  =target          #目标内容
		CmdIStr8  =rwcontent       #奖励内容*/
		
		public static const QUERYMESSAGEBYSID:String = "USERCX.SelectMsgBySid(gdgz)";
/*		[SelectMsgBySid]
		@=学生查看提醒信息
			SrcFName =faq.c  	#C源码所在文件名
		CmdTypeN =1:N     		#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1	=sid   		#接受信息的学生标识
		#param[out] 命令字出口:
		CmdOStr1  = msgid			#信息标识 :全局唯一标识
		CmdOStr2  = sid				#接受信息学生标识
		CmdOStr3  = pid				#信息发送者标识
		CmdOStr4  = opercode		#信息发送者名字
		CmdOStr5  =	msgimportant	#信息重要性
		CmdOStr6  = sendtime		#信息发送时间
		CmdOStr7  =	readstatues		#阅读标识
		CmdOStr8  = readtime		#阅读时间
		CmdOStr9  = msgtext			#提醒信息的具体内容*/
		
		public static const UPDATEMESSAGE:String = "USERYW.Updatemessage(gdgz)";
/*		[updatemessage]
		@=学生查看提醒的标识修改		
		SrcFName =faq.c  		#C源码所在文件名
		CmdTypeN =1:1     		#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1	=msgid   	#被查看信息的标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       	#错误代码
		#"MMM"=其他错误
		CmdOStr1  =errMsg       #失败提示信息
		#成功
		CmdOStr0 ="000"			#成功代码
		CmdOStr1 =sucMsg		#成功提示信息
		CmdOStr2 =msgid			#成功修改后的msgid*/

		public static const CHECKTARGETWALL:String = "USERCX.CheckTargetWall(gdgz)";
/*		[CheckTargetWall]
		@=检查目标是否完成
			SrcFName =tagetwall.c  		#C源码所在文件名
		CmdTypeN =1:1     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =sid   	#被查看的学生的ID
		#param[out] 命令字出口:
		#失败
		CmdOStr0 =errno     #错误代码
		CmdOStr1 =errMsg    #失败提示信息*/
		
		public static const SENDMACVERSIONS:String = "USERYW.IntUpaMacvers(gdgz)";
		/*[IntUpaMacvers]
		@=上传平板版本信息
		SrcFName = mac.c   #C源码所在文件名
		CmdTypeN = 1:1     #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 = macid   #平板macid
		CmdIStr2 = operid  #操作员operid
		CmdIStr3 = versionifo #同步信息
		#param[out] 命令字出口:
		#失败
		CmdOStr0 = errno   #错误代码
		#"M00" = 同步的客户机不存在
		#"MMM" = 其他错误
		CmdOStr1 = errMsg  #失败提示信息*/
		
		public static const SENDMACPACKAGELIST:String = "USERYW.IntUpdinstalllist(gdgz)";
		
		public static const QUERYLNDAYINFO:String = "USERCX.QueryLnDayInfo(gdgz)";
		/*[QueryLnDayInfo]
		@=查询学生学习任务天情况
		SrcFName =usercx.c  		#C源码所在文件名
		CmdTypeN =1:N     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1	=sid   		  #学生标识
		CmdIStr2  =sdate      #统计开始时间  YYYYMMDD 默认00000000
		CmdIStr3  =edate      #统计结束时间  YYYYMMDD 默认YYYYMMDD
		#param[out] 命令字出口:
		CmdOStr1  =sid				#学生标识
		CmdOStr2  =tjdate     #统计时间 YYYYMMDD
		CmdOStr3  =ynfinish   #是否当日完成计划 不分课目主线 
		#没有完成为N，完成计划为Y
		CmdOStr5  =elnrightp  #学习成功率百分比 XX.XX*/
		
		public static const QUERYLNDAYDETAIL:String = "USERCX.QueryLnDayDetail(gdgz)";
		/*[QueryLnDayDetail]
		@=查询学生学习任务天情况详细信息
		SrcFName =usercx.c  	#C源码所在文件名
		CmdTypeN =1:N     		#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1	=sid   		#学生标识
		CmdIStr2  =date       	#学习时间  YYYYMMDD 默认00000000
		#param[out] 命令字出口:
		CmdIStr1	=sid   		#学生标识
		CmdOStr2  =rrl       	#主线层级
		CmdOStr3  =status    	#学习完成情况 y 已完成 N 未完成
		CmdOStr4  =startime  	#开始学习时间
		CmdOStr5  =endtime   	#结束学习时间
		CmdIStr6  =date      	#统计时间
		CmdOStr7  =achieve   	#成绩*/
		
		
		
		
		/*
		[QueryMarkframe]
		@=查询商场主架信息
		SrcFName =usercx.c  		#C源码所在文件名
		CmdTypeN =1:N     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =framename  #主架名称 可传空 支持模糊查询 
		CmdIStr2  =goodstype1  #主架类型1 *查询所有 类型分类 如查询电影 则传入 VIDEO 
		CmdIStr3  =goodstype2  #主架类型2 *查询所有
		CmdIStr4  =goodstype3  #主架类型3 *查询所有
		CmdIStr5  =txtbrief   #主架描述 可传空 支持模糊查询 
		CmdIStr6  =maxreturn  #一次返回最大个数
		CmdIStr7  =pageno     #当前页数
		#param[out] 命令字出口:
		CmdOStr1  =allpageno  #总页数
		CmdOStr2  =curpageno  #当前页数
		CmdOStr3  =frameid    #商场主架标识
		CmdOStr4  =framename  #商场主架名称
		CmdOStr5  =attrtype1  #主架所属类型1 默认为空    ITEM_TYPE
		CmdOStr6  =attrtype2  #主架所属类型2 默认为空
		CmdOStr7  =attrtype3  #主架所属类型3 默认为空
		CmdOStr8  =goldcost   #花销金币
		CmdOStr9  =wbidface   #关联素材，取值参见 ebinfile 表wbid字段；不存在则取值-1
		CmdOStr10  =txtbrief  #文本格式的内容简介
		CmdOStr11  =wbidlean  #显示的图标串 二进制存储*/
		public static const QUERY_MARK_FRAME:String = "USERCX.QueryMarkframe(gdgz)";
		public static const NEW_MARK_FRAME:String = "USERCX.QueryMarkframeorder(gdgz)";//倒叙排列歌曲,获取最新歌曲列表
		public static const NEW_MARK_FRAME2:String = "USERCX.QryMarkframeorderMUSIC(gdgz)";
		
		/*#param[in] 命令字入口:
		CmdIStr1  =framename  #主架名称 可传空 支持模糊查询 
		CmdIStr2	=goodstype1  #主架类型1 *查询所有 类型分类 如查询电影 则传入 VIDEO 
		CmdIStr3  =goodstype2  #主架类型2 *查询所有
		CmdIStr4  =goodstype3  #主架类型3 *查询所有
		CmdIStr5  =txtbrief   #主架描述 可传空 支持模糊查询 
		CmdIStr6  =userid     #用户标识
		#param[out] 命令字出口: 同上*/
		public static const NOT_BUY_MUSIC:String = "USERCX.QryMarkframeNotBuyMusic(gdgz)";//@=查询所有未购买信息
		public static const NEW_MARK_MUSIC:String = "USERCX.QryMarkframeordMUSIC(gdgz)";//查询最新
		public static const ALL_MARK_MUISC:String = "USERCX.QryMarkframeMUSICNEW(gdgz)";//查询全部
		
		
		/*[QryMarkframeMUSIC]
		@=查询音乐主架列表信息
		SrcFName =markattr.c
		CmdTypeN  =1:N
		#param[in] 命令字入口
		CmdIStr1  =framename  #主架名称 可传空 支持模糊查询 
		CmdIStr2 =goodstype1  #主架类型1 *查询所有 类型分类 如查询电影 则传入 MUSIC 
		CmdIStr3  =goodstype2  #主架类型2 *查询所有
		CmdIStr4  =goodstype3  #主架类型3 *查询所有
		CmdIStr5  =txtbrief   #主架描述 可传空 支持模糊查询 
		CmdIStr6  =maxreturn  #一次返回最大个数
		CmdIStr7  =pageno     #当前页数
		CmdIStr8  =iuserid    #学生标识
		#param[out] 命令字出口:
		CmdOStr1  =allpageno    #总页数
		CmdOStr2  =curpageno    #当前页数
		CmdOStr3  =frameid      #商场主架标识
		CmdOStr4  =framename    #商场主架名称
		CmdOStr5  =attrtype1    #主架所属类型1 默认为空    ITEM_TYPE
		CmdOStr6  =attrtype2    #主架所属类型2 默认为空
		CmdOStr7  =attrtype3    #主架所属类型3 默认为空
		CmdOStr8  =goldcost     #花销金币
		CmdOStr9  =wbidface     #关联素材，取值参见 ebinfile 表wbid字段；不存在则取值-1
		CmdOStr10  =txtbrief    #文本格式的内容简介
		CmdOStr11  =paycount    #购买个数 0为未购买
		CmdOStr12  =instval1     #播放时长
		CmdOStr13  =instval1      #歌手
		CmdOStr14  =instval1        #专辑
		CmdOStr15  =instval1        #大小*/
		public static const QryMarkframeMUSIC:String = "USERCX.QryMarkframeMUSIC(gdgz)";
		
		/*[QrymarkframeInfo]
		@=查询该商场主架的详细信息
		SrcFName =markattr.c  		#C源码所在文件名
		CmdTypeN =1:N     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =frameid     #商场主架标识
		CmdIStr2  =framename     #主架名称 传* 支持模糊查询
		CmdIStr3  =goodstype1     #主架类型1 *查询所有 类型分类 如查询电影 则传入 VIDEO 
		CmdIStr4  =goodstype2     #主架类型2 *查询所有
		CmdIStr5  =goodstype3     #主架类型3 *查询所有
		#param[out] 命令字出口:
		CmdOStr1  =Display       #显示类型 MARK/MARKINFO
		#如CmdOStr1=MARK 
		CmdOStr2  =frameid       #商场主架标识
		CmdOStr3  =framename     #商场主架名称
		CmdOStr4  =goodstype1    #主架所属类型1 默认为空 
		CmdOStr5  =goodstype2    #主架所属类型2 默认为空 
		CmdOStr6  =goodstype3    #主架所属类型3 默认为空
		CmdOStr7  =wbidface      #关联素材
		CmdOStr8  =txtbrief      #文本格式的内容简介
		CmdOStr9  =goldcost      #花销金币
		CmdOStr10  =begtime       #开始时间
		CmdOStr11  =endtime       #结束时间
		CmdOStr12  =operid        #操作工号标识
		CmdOStr13  =optime        #操作时间
		CmdOStr14  =lastvid       #异动标识
		CmdOStr15  =wbidleanExt   #文件后缀
		CmdOStr16  =wbidlean      #显示图片二进制码
		#如CmdOStr1=MARKINFO 
		CmdOStr2  =relatid       #关联标识
		CmdOStr3  =frameid     #商场主架标识
		CmdOStr4  =goodsid     #物品标识
		CmdOStr5  =goodname    #物品名称 
		CmdOStr6  =seq         #序列
		CmdOStr7  =operid      #操作工号标识
		CmdOStr8  =optime      #操作时间
		CmdOStr9  =lastvid      #异动标识
		CmdOStr10 =goldcost    #花销金币*/
		public static const QUERY_MARK_FRAME_INFO:String = "USERCX.QrymarkframeInfo(gdgz)";
		
		
		/*USERYW.PointUserhasnewframe
		userid     ##学生标识
		type1     ##类型 音乐传MUSIC*/
		public static const USER_HAS_NEWFRAME:String = "USERYW.PointUserhasnewframe(gdgz)";
		
		/*USERYW.ApplyYW(gdgz)
		@=业务购买主架包
		SrcFName  =bag.c      #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  ="UBMF"     #删除用户背包
		CmdIStr2  =operid     #操作者标识
		CmdIStr3  =opcode     #操作者登录帐号
		CmdIStr4  =menuid     #该业务关联的菜单标识
		CmdIStr5  =mtitle     #对应菜单标题
		CmdIStr6  =userid     #用户标识
		CmdIStr7  =frameid    #主架信息
		CmdIStr8  =goodid    #物品标识列表 已,未分割 如果传入空 则表示已主架进行购买
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息
		#金币不足
		CmdOStr0  = "001"     #错误代码
		CmdOStr1  = wallet    #金币数
		CmdOStr2  = "金币不足，购买失败."
		#成功
		CmdOStr0  = "000"     #成功提示信息
		CmdOStr1  = wallet    #剩余钱数
		CmdOStr2  = "购买成功，物品已加入您的背包."
		返回的第二个参数都是金币数（剩余金币数）*/
		public static const MARK_APPLY:String = "USERYW.ApplyYW(gdgz)";

		public static const QUERYALLMESSAGES:String = "USERCX.QueryAllMessage(gdgz)";
		/*@=查看所有消息
		SrcFName = message.c  #C源码所在文件名
		CmdTypeN = 1:N     	  #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 = sid   	  #被查看信息的标识
		#param[out] 命令字出口:
		CmdOStr1 = msgid      #消息标识
		CmdOStr2 = rid  	  #接收者Id
		CmdOStr3 = maketime   #消息创建时间
		CmdOStr4 = readFlag   #消息阅读状态
		CmdOStr5 = readtime   #消息阅读时间
		CmdOStr6 = sid        #消息发送者id
		CmdOStr7 = sopcode    #发送者账号
		CmdOStr8 = msgType    #消息类别
		CmdOStr9 = relaId	  #关联Id
		CmdOStr10= dealFlag   #处理标识
		CmdOStr11= relaInfo   #关联信息
		CmdOStr12= msgText    #消息内容*/
		
		public static const GETNEWMESSAGE:String = "USERYW.GetNewMessage(gdgz)";
		/*@=学生查看最新的一条提醒
		SrcFName = faq.c  		#C源码所在文件名
		CmdTypeN = 1:1     		#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 = sid   		#被查看信息的标识
		CmdIStr2 = msgtype    #消息的类型（为*时匹配所有）
		#param[out] 命令字出口:
		CmdOStr1 = msgid      #消息标识
		CmdOStr2 = rid  	  #接收者Id
		CmdOStr3 = maketime   #消息创建时间
		CmdOStr4 = readFlag   #消息阅读状态
		CmdOStr5 = readtime   #消息阅读时间
		CmdOStr6 = sid        #消息发送者id
		CmdOStr7 = sopcode    #发送者账号
		CmdOStr8 = msgType    #消息类别
		CmdOStr9 = relaId	  #关联Id
		CmdOStr10= dealFlag   #处理标识
		CmdOStr11= relaInfo   #关联信息
		CmdOStr12= msgText    #消息内容*/
		
		public static const QUERYREADGIFT:String = "USERCX.QueryReadGift(gdgz)";
		/*@=查看已读但为领取的礼品信息
		SrcFName = message.c  #C源码所在文件名
		CmdTypeN = 1:N     	  #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 = sid   			#被查看信息的标识
		#param[out] 命令字出口:
		CmdOStr1 = msgid      #消息标识
		CmdOStr2 = rid  			#接收者Id
		CmdOStr3 = maketime   #消息创建时间
		CmdOStr4 = readFlag   #消息阅读状态
		CmdOStr5 = readtime   #消息阅读时间
		CmdOStr6 = sid        #消息发送者id
		CmdOStr7 = sopcode    #发送者账号
		CmdOStr8 = msgType    #消息类别
		CmdOStr9 = relaId			#关联Id
		CmdOStr10= dealFlag   #处理标识
		CmdOStr11= relaInfo   #关联信息
		CmdOStr12= msgText    #消息内容*/
		
		
		/*[QryUsergoodsInfo]
		@=查询该用户购买物品信息
		SrcFName =markattr.c   #C源码所在文件名
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     #商场主架标识
		CmdIStr2  =goodstype1     #主架类型1 *查询所有 类型分类 如查询电影 则传入 VIDEO 
		#param[out] 命令字出口:
		CmdOStr1  =instid       #
		CmdOStr2  =userid       #用户标识
		CmdOStr3  =goodsid      #物品标识
		CmdOStr4  =goodsname    #物品名称
		CmdOStr5  =goodstype1   #类型1
		CmdOStr6  =goodstype2   #类型2
		CmdOStr7  =goodstype3   #类型3
		CmdOStr8  =wbidmain     #素材标识
		CmdOStr9  =wfname       #素材相对路径
		CmdOStr10 =version      #版本号
		CmdOStr11 =localfsize   #大小
		CmdOStr12 =memodesc   #描述
		CmdOStr13 =goodnum   #数量
		CmdOStr14 =goldcost   #花销金币*/
		public static const GET_RESOURCE_LIST:String = "USERCX.QryUsergoodsInfo(gdgz)";//第一个测试命令字，不包含时间设置
		
		/*QryUsergoodsforpad]
		@=查询该用户购买物品信息
		SrcFName =markattr.c   #C源码所在文件名
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     #用户标识
		CmdIStr2  =goodstype1   #主架类型1 *查询所有 类型分类 如查询电影 则传入 VIDEO 
		CmdIStr3  =goodstype2   #主架类型2 *查询所有 类型分类 
		#param[out] 命令字出口:
		CmdOStr1  =instid       #
		CmdOStr2  =userid       #用户标识
		CmdOStr3  =goodsid      #物品标识
		CmdOStr4  =goodsname    #物品名称
		CmdOStr5  =goodstype1   #类型1
		CmdOStr6  =goodstype2   #类型2
		CmdOStr7  =goodstype3   #类型3
		CmdOStr8  =wbidmain     #素材标识
		CmdOStr9  =wfname       #素材相对路径
		CmdOStr10 =version      #版本号
		CmdOStr11 =localfsize   #大小
		CmdOStr12 =intval1     #播放时长
		CmdOStr13 =memodesc     #描述
		CmdOStr14 =goodnum      #数量
		CmdOStr15 =goldcost     #花销金币
		CmdOStr16 =wbidlean     #二进制图标*/
		public static const GET_RESOURCE_LIST2:String = "USERCX.QryUsergoodsforpad(gdgz)";//第一个测试命令字，不包含时间设置
		
		/*[QryUsergoodsMusic]
		@=查询该用户购买物品信息
		SrcFName =markattr.c   #C源码所在文件名
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     #商场主架标识
		CmdIStr2  =goodstype1   #主架类型1 *查询所有 类型分类 如查询电影 则传入 VIDEO 
		CmdIStr3  =goodstype2   #主架类型2 *查询所有 类型分类 
		CmdIStr4  =grpid        #分组标识
		#param[out] 命令字出口:
		CmdOStr1  =instid       #
		CmdOStr2  =userid       #用户标识
		CmdOStr3  =goodsid      #物品标识
		CmdOStr4  =goodsname    #物品名称
		CmdOStr5  =goodstype1   #类型1
		CmdOStr6  =goodstype2   #类型2
		CmdOStr7  =goodstype3   #类型3
		CmdOStr8  =wbidmain     #素材标识
		CmdOStr9  =wfname       #素材相对路径
		CmdOStr10 =version      #版本号
		CmdOStr11 =localfsize   #大小
		CmdOStr12 =memodesc     #描述
		CmdOStr13 =goodnum      #数量
		CmdOStr14 =goldcost     #花销金币
		CmdOStr15 =wbidlean     #二进制图标
		CmdOStr16 =intval1     #播放时长
		CmdOStr17 =intval1     #歌手
		CmdOStr18 =intval1     #专辑
		CmdOStr19 =intval1     #大小*/
		public static const GET_MUSIC_INFO:String = "USERCX.QryUsergoodsMusic(gdgz)";
		
		
		/*[ApplyYW.UMDI]
		@=业务购买主架包
		SrcFName  =markatr.c      #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口1:
		CmdIStr1  ="UMDI"     #删除用户物品
		CmdIStr2  =operid     #操作者标识
		CmdIStr3  =opcode     #操作者登录帐号
		CmdIStr4  =menuid     #该业务关联的菜单标识
		CmdIStr5  =mtitle     #对应菜单标题
		CmdIStr6  =instid     #用户标识		
		#param[in] 命令字入口2:
		@=业务增加分类
		CmdIStr1  ="UMGI"     
		CmdIStr2  =operid     #操作者标识
		CmdIStr3  =opcode     #操作者登录帐号
		CmdIStr4  =menuid     #该业务关联的菜单标识 0 
		CmdIStr5  =mtitle     #对应菜单标题 
		CmdIStr6  =instid     #用户标识
		CmdIStr7  =grpname     #分类名称
		CmdIStr8  =grpval1     #分类归属 音乐MUSIC等
		CmdIStr9  =grpval2     #预留字段 传空
		
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const DEL_RESOURCE:String = "USERYW.ApplyYW(gdgz)";
		
		//将物品归类
		/*[USERYW.Setmarkgoodinstgrp]
		@=设置markgood分类
		SrcFName =markatr.c   #C源码所在文件名
		CmdTypeN =1:1      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =instid      #实例标识
		CmdIStr2 =grpid        #分类标识
		#param[out] 命令字出口:
		#成功
		CmdOStr0 ="000" #成功代码
		#失败
		CmdOStr0 =errno     #错误代码
		CmdOStr1 =errMsg    #失败提示信息*/
		public static const SET_GOODS_CLASSIFY:String = "USERYW.Setmarkgoodinstgrp(gdgz)";
		
		/*/查看分类
		USERCX.QryUsermarkinstgrptype
		#入口
		userid    #用户标识
		grpval1  #分类大类MOVIES MUSIC 
		grpval2  #分类大类2 传*
			#出口 
		grpid  #分类标识
		userid #用户标识
		grpname #分类名称
		grpval1  #分类大类MOVIES MUSIC 
		grpval2  #分类大类2
		operid   #操作员
		optime  #操作时间
		lastvid   #异动标识*/
		public static const GET_ALL_CLASSIFY:String = "USERCX.QryUsermarkinstgrptype(gdgz)";
		
				
		/*USERYW.Delmarkgoodinstgrp(gdgz)
		grpid       #分组标识*/
		public static const DEL_MARK_TYPE:String = "USERYW.Delmarkgoodinstgrp(gdgz)";
		
		
		/*[SelectOpproc]
		@=查询用户入账业务记录
		SrcFName =useryw.c
		CmdTypeN  =1:N
		#param[in] 命令字入口
		CmdIStr1  =opprocid      #查询起始时间 格式 YYYYMMDD-hhmmss
		#param[out] 命令字出口
		CmdOStr1  =sid        #userid,
		CmdOStr2  =sid2       #关联userid
		CmdOStr3  =rid        #rrl id
		CmdOStr4  =rrl        #关联rrl
		CmdOStr5  =opdate     #任务提交时间
		CmdOStr6  =cmd        #提交操作命令字
		CmdOStr7  =cmdcnt     #命令字参数个数
		CmdOStr8  =args       #命令字参数内容 <@Axx>间隔*/
		public static const SELECT_OPPROC:String = "USERYW.SelectOpproc(gdgz)";
		
		/*[InsertMessage]
		@=家长/管理员添加提醒信息		
		SrcFName =faq.c  		#C源码所在文件名
		CmdTypeN =1:1     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =sid   		#接受信息的学生的id
		CmdIStr2 =pid	      #信息发送者的id
		CmdIStr3 =pcode     #信息发送者账号
		CmdIStr4 =msgimportant	#信息重要性标识（取值参见FIX_MSGIMPORTANT）
		CmdIStr5 =Type			#信息类型(M-Message , G-Gift)
		CmdIStr6 =relaid			#关联Id
		CmdIStr7 =relainfo			#关联信息
		CmdIStr8 =text			#信息文本内容，最长4k
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       		#错误代码
		#"MMM"=其他错误
		CmdOStr1  =errMsg       	#失败提示信息
		#成功
		CmdOStr0 ="000"				#成功代码
		CmdOStr1 =sucMsg				#成功提示信息
		CmdOStr2 =msgid				#成功插入后的msgid*/
		public static const SEND_MESSAGE:String = "USERYW.InsertMessage(gdgz)";
		
		/*[RecGiftById]
		@=添加/修改礼包表
		SrcFName  =faq.c   		#C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =gid				#礼包id，0为添加
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        #错误代码
		#"MMM"=添加失败
		CmdOStr1  =errMsg       #失败提示信息*/
		public static const REC_GIFT_BY_MSG:String = "USERYW.RecGiftById(gdgz)";
		
		/*[InsertPromise]
		@=插入用户目标墙
		SrcFName  = tagetwall.c   #C源码所在文件名
		CmdTypeN  =1:1          	#命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  = sid           #学生标识
		CmdIStr2  = parName       #家长名称
		CmdIStr3  = target        #目标内容
		CmdIStr4  = content       #奖励内容
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =proid          #目标墙ID
		CmdOStr2  =errMsg       	#失败提示信息*/
		public static const INSERT_PROMISE:String = "USERYW.InsertPromise(gdgz)";
		
		/*[QryProBySid]
		@=传入学生标识 返回其对于的约定列表
		SrcFName  =tagetwall.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid        #学生标识
		#param[in] 命令字入口:
		CmdIStr1  =proid           #约定id
		CmdIStr2  =sid             #学生标识
		CmdIStr3  =parname         #家长名称
		CmdIStr4  =target          #目标内容
		CmdIStr5  =rwcontent       #奖励内容
		CmdIStr6  =sdate           #约定制定时间
		CmdIStr7  =status          #完成标记
		CmdIStr8  =fdate           #完成时间*/
		public static const QRYPROMISEBYSID:String = "USERCX.QryProBySid(gdgz)";
		
		/*[USERYW.CheckPromise]
		@=检查目标是否完成
		SrcFName =tagetwall.c  		#C源码所在文件名
		CmdTypeN =1:1     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1	=sid   		#被查看的学生的ID
		#param[out] 命令字出口:
		#失败
		CmdOStr0 =errno     #错误代码
		CmdOStr1 =errMsg    #失败提示信息*/
		public static const CHECK_PROMISES:String = "USERYW.CheckPromise(gdgz)";

		
		/*[USERCX.QueryEquipment]
		instid #装备标识  默认传*
		equipcode #装备编码 默认传* 支持模糊查询*/
		public static const QUERY_EQUIPMENT:String = "USERCX.QueryEquipment(gdgz)";
		
		/*[USERYW.IntUpdequipment]
		instid #新增传0
		equipcode #装备编码
		equipname #装备名称
		equipmemo #装备描述
		begtime #开始时间 默认20110101-000001
		endtime #结束时间 默认20991231-235959*/
		public static const INTUPD_EQUIPMENT:String = "USERYW.IntUpdequipment(gdgz)";
		
		/*[USERYW.Delequipment]
		instid #装备标识 可传0 
		equipcode #装备编码 可传空*/
		public static const DEL_EQUIPMENT:String = "USERYW.Delequipment(gdgz)";
		
		/*
		[SelectstdEquip]
		@=取在线用户装备和完成等级列表
		SrcFName =usercx.c      #C源码所在文件名
		CmdTypeN =1:N           #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     	#用户标识列表(以","分隔)
		#param[out] 命令字出口:
		CmdOStr1  =userid     	#用户标识
		CmdOStr2  =equipmemo   	#用户装备列表
		CmdOStr3  =fnlvl        #用户连续完成等级*/
		public static const GET_CHARATER_EQUIPMENT:String = "USERCX.SelectstdEquip(gdgz)";
		
		/*[USERYW.UpdatestdEquip]
		CmdIStr1=operid #工号标识
		CmdIStr2=equipmemo #装备信息 支持超长串*/
		public static const UPDATE_CHARATER_EQUIPMENT:String = "USERYW.UpdatestdEquip(gdgz)";

		/*[QryPromise]
		@=传入学生标识 返回其对于的约定列表
		SrcFName  =tagetwall.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid        #学生标识，"*"为匹配所有
		CmdIStr2	=begtime    #制定约定开始时间 取值00000000表示不参与条件
		CmdIStr3  =engtime    #制定约定结束时间 取值YYYYMMDD表示不参与条件
		CmdIStr4  =status     #约定状态,"*"为匹配所有
		CmdIStr5  =maxreturn  #一次返回最大个数
		CmdIStr6  =pageno     #当前页数
		#param[in] 命令字入口:
		CmdIStr1  =proid           #约定id
		CmdIStr2  =sid             #学生标识
		CmdIStr3  =parname         #家长名称
		CmdIStr4  =target          #目标内容
		CmdIStr5  =rwcontent       #奖励内容
		CmdIStr6  =sdate           #约定制定时间
		CmdIStr7  =status          #完成标记
		CmdIStr8  =fdate           #完成时间
		CmdOStr9  =allpageno       #总页数
		CmdOStr10 =curpageno       #当前页数*/
		public static const QUERY_PROMISE:String = "USERCX.QryPromise(gdgz)";
		
		
		/*[USERYW.InsertStdrelat]
		@=增加好友
		SrcFName  =useryw.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid     #操作员标识
		CmdIStr2  =roperid    #关联学生标识
		CmdIStr3  =relatype   #关联类型
		
		[fix_STDRELATTYPE]
		@=学生关联类型
		CLASSMATE=同学
		FRIENDS=好朋友
		
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"M00"=学生不存在
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const INSERT_STD_RELAT:String = "USERYW.InsertStdrelat(gdgz)";
		
		/*[USERYW.DeleteStdrelat]
		@=删除好友
		SrcFName  =useryw.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid     #操作员标识
		CmdIStr2  =roperid    #关联学生标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const DELETE_STD_RELAT:String = "USERYW.DeleteStdrelat(gdgz)";
		
		/**
		 *[Qrystdrelatlist]
			@=查看好友信息列表
			SrcName =usercx.c
			CmdTypeN =1:N      #命令字类型;1:1/N
			#param[in] 命令字入口:
			CmdIStr1  =userid     #用户标识* 
			#param[out] 命令字出口:
			CmdOStr1  =userid       #用户标识
			CmdOStr2  =rstdid       #关联用户标识
			CmdOStr3  =rstdcode     #关联用户编码
			CmdOStr4  =realname     #真实名字
			CmdOStr5  =relatype     #关联类型
			CmdOStr6  =operst       #操作员状态；取值参见 OPERST 参数;
			CmdOStr7  =nickname     #操作员昵称
			CmdOstr8  =gender       #性别
			CmdOStr9  =goldnum      #金币数
			CmdOStr10 =birth        #生日(YYYYMMDD)
			CmdOStr11 =school       #所在学校名称
			CmdOStr12 =signature    #签名
 * */
		public static const QRY_STD_RELATLIST:String = "USERCX.Qrystdrelatlist(gdgz)";
		
		
		/*[DeleteProGetProNum]
		@=删除目标
		SrcFName =tagetwall.c  		#C源码所在文件名
		CmdTypeN =1:1     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1	=proid   		    #将要删除的约定的id
		CmdIStr2	=opid   		    #要取约定个数的用户id
		#param[out] 命令字出口:
		#失败
		CmdOStr0 =errno     #错误代码
		CmdOStr1 =errMsg    #失败提示信息*/
		public static const DELETE_PRO_GET_PRONUM:String = "USERYW.DeleteProGetProNum(gdgz)";
		
		/*[RewardPromise]
		@=完成奖励
		SrcFName =tagetwall.c  		#C源码所在文件名
		CmdTypeN =1:1     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1	=proid   		    #将要删除的约定的id
		#param[out] 命令字出口:
		#成功
		CmdOStr0 ="000"				#成功代码
		CmdOStr1 =proid       #未完成约定的条数
		#失败
		CmdOStr0 =errno     #错误代码
		CmdOStr1 =errMsg    #失败提示信息*/
		public static const REWARD_PROMISE:String = "USERYW.RewardPromise(gdgz)";
		
		/**
		 * [USERYW.UpdatePromise]
		 @=用户目标墙更新上传文件标识
		 SrcFName  = tagetwall.c   #C源码所在文件名
		 CmdTypeN  =1:1          	#命令字类型;1:1
		 CmdTypeN  =1:1          	#命令字类型;1:1
		 #param[in] 命令字入口:
		 CmdIStr1  = proid         #学生标识
		 CmdIStr2  = fileid        #文件标识
		 #param[out] 命令字出口:
		 #失败
		 CmdOStr0  =errno        	#错误代码
		 #"000"=成功
		 #"MMM"=其他错误
		 CmdOStr1  =proid          #目标墙ID
		 CmdOStr2  =errMsg       	#失败提示信息
		 */
		public static const UPDATE_PROMISE:String = "USERYW.UpdatePromise(gdgz)";

		/*[USERCX.QryUserdaytaskInfo]
		CmdIStr1=userid  
		CmdIStr2 = rrl     *代表全部 这不能传空
		CmdIStr3 = sdate 这也必须传当天时间 (YYYYMMDD)
		#out
		CmdOStr1= userid
		CMdOStr2 =rrl
		CmdOStr3  =S/E 状态 S为未开始 E为结束
		CmdOStr4  =mon 金币数
		CmdOStr5  =level 分数*/
		public static const QRY_USER_DAYTASKINFO:String = "USERCX.QryUserdaytaskInfo(gdgz)";
		
		/*[QryUnReadMessage]
		@=查询所有未读的消息(包括礼物)
		SrcFName = message.c  		#C源码所在文件名
		CmdTypeN = 1:N     				#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 = sid   					#被查看信息的标识
		#param[out] 命令字出口:
		CmdOStr1 = msgid      		#消息标识
		CmdOStr2 = pid  					#消息发送者id
		CmdOStr3 = opercode       #发送者名字
		CmdOStr4 = maketime   		#消息创建时间
		CmdOStr5 = msgType    		#消息类别
		CmdOStr6 = dealFlag   		#处理标识
		CmdOStr7 = messagetext    #消息内容*/
		public static const QRY_UNREAD_MESSAGE:String = "USERCX.QryUnReadMessage(gdgz)";
		
		/*[CheckStudentId]
		@=通过id检查Student是否存在
		SrcName  =useryw.c
		CmdTypeN =1:1      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     #用户标识* 
			#param[out] 命令字出口:
		#成功
		CmdOStr0 ="000"				#成功代码
		CmdOStr1 =sid         #学生标识
		CmdOStr2 =count       #学生id为入口参数的学生个数（1/0）
		#失败
		CmdOStr0  =errno      #错误代码
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const CHECK_STUDENT_ID:String = "USERYW.CheckStudentId(gdgz)";
		
		
		/*[USERRW.QuiUserLevel(gdgz)]
		@获取对应应用用户级别
		SrcFName  =task2.c      #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sid          #用户标识
		CmdIStr2  =rrltype      #yy.W; yy.R; 
		#param[out] 命令字出口:
		CmdOStr0  =结果状态码
		CmdOStr1  =sid
		CmdOStr2  =max_rrl      #最大rrl
		CmdOStr3  =mlevel       #对应级别*/
		public static const QUI_USER_LEVEL:String = "USERRW.QuiUserLevel(gdgz)";
		
		/*[DelMessage]
		@=删除消息
		SrcFName =faq.c  		#C源码所在文件名
		CmdTypeN =1:1     	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1	=msgid   			#被查看信息的标识
		#param[out] 命令字出口:
		#"MMM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const DELETE_MESSAGE:String = "USERYW.DelMessage(gdgz)";
		
		/*[Qryperroom]
		@=查询房间列表信息
		SrcName  =usercx.c
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =roomid      #用户标识 *代表所有
		CmdOStr2  =roomname    #房间名称 支持模糊查询 可传空
		#param[out] 命令字出口:
		CmdOStr1  =roomid      #房间标识
		CmdOStr2  =roomname    #房间名称
		CmdOStr3  =wbidface    #显示素材
		CmdOStr4  =type        #房间类型
		CmdOStr5  =weight      #房间宽度
		CmdOStr6  =offset_y    #房间y位置
		CmdOStr7  =maxstonum   #最大存放数
		CmdOStr8  =price       #单价
		CmdOStr9  =status      #状态
		CmdOStr10 =builtlong   #建造时长
		CmdOStr11 =dealoperid #处理工号
		CmdOStr12 =dealtime    #处理时间*/
		public static const QRY_PER_ROOM:String = "USERGCX.Qryperroom(gdgz)";
		
		/*[IntUpdperroom]
		@=增改空间房间(公有)
		SrcFName  = useryw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =wbidface        #显示素材路径
		CmdIStr2  =roomname        #房间名称
		CmdIStr3  =type            #类型
		CmdIStr4  =weight          #宽度
		CmdIStr5  =offset_y        #y位置
		CmdIStr6  =maxstonum       #最大存放人数
		CmdIStr7  =price           #单价
		CmdIStr8  =status          #状态
		CmdIStr9  =builtlong       #建造时长
		CmdIStr10  =dealoperid     #处理工号
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =roomid          #新增房间标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const INTUPD_PER_ROOM:String = "USERGYW.IntUpdperroom(gdgz)";
		
		/*[Delperroom]
		@=删除空间房间(公有)  //
		SrcFName  = useryw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =wbidface        #显示素材路径
		CmdIStr2  =stdid           #学生标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =roomid          #房间标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const DEL_PER_ROOM:String = "USERGYW.Delperroom(gdgz)";
		
		
		
		
		/*[Qrystdperroom]
		@=查询用户个人空间中房间信息
		SrcName  =usercx.c
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =stdid        #学生标识
		#param[out] 命令字出口:
		CmdOStr1  =relatid      #关联标识
		CmdOStr2  =stdid        #学生标识
		CmdOStr3  =roomid       #房间标识
		CmdOStr4  =roomname     #房间名称
		CmdOStr5  =wbidface     #房间素材
		CmdOStr6  =type         #房间类型
		CmdOStr7  =weight       #宽度
		CmdOStr8  =xlocal       #x坐标
		CmdOStr9  =offset_y     #y位置
		CmdOStr10 =maxstonum   #最大存放个数
		CmdOStr11 =             #预留
		CmdOStr12 =realstonum   #实际存放人数
		CmdOStr13 =price        #单价
		CmdOStr14 =createtime   #购买时间(秒数)
		CmdOStr15 =finishtime   #完成时间(秒数)*/
		public static const QRY_STD_PER_ROOM:String = "USERGCX.Qrystdperroom(gdgz)";
		
		
		
		
		/*[Buystdperroom]
		@=购买个人空间房间
		SrcFName  = useryw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =wbidface         #显示素材路径
		CmdIStr2  =stdid            #学生标识
		CmdIStr3  =xlocal           #x坐标
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =relatid         #新增标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const BUY_STD_PER_ROOM:String = "USERGYW.Buystdperroom(gdgz)";
		
		
		
		
		/*[Updstdperroom]
		@=修改个人空间房间属性
		SrcFName  = useryw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =relatid          
		CmdIStr2  =xlocal           #x坐标
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =relatid         #新增标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const UPD_STD_PER_ROOM:String = "USERGYW.Updstdperroom(gdgz)";
		
		
		/*[Delstdperroom]
		@=删除个人空间房间
		SrcFName  = useryw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =relatid
		CmdIStr2  =stdid            #学生标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =relatid         #新增标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const DEL_STD_PER_ROOM:String = "USERGYW.Delstdperroom(gdgz)";
		
		
		
		/*[USERYW.IntUpdnpcroleinfo]
		@=增改npc角色信息
		SrcFName  = useryw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =rolename    #npc角色名称
		CmdIStr2  =rolemap     #npc贴图
		CmdIStr3  =class       #npc品级
		CmdIStr4  =hpvalue     #血量值
		CmdIStr5  =status      #npc状态 参考RRL_STATCODE 参数 A在用 X停用
		CmdIStr6  =roleattr    #npc角色属性
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =roleid          #新增修改标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const INTUPD_NPC_ROLE_INFO:String = "USERGYW.IntUpdnpcroleinfo(gdgz)";
		
		
		/*[USERCX.Qrynpcroleinfo]
		@=查询npc角色
		SrcName  =usercx.c
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		#param[out] 命令字出口:
		CmdIStr1  =roleid        #npc标识
		CmdIStr2  =rolename      #npc名称
		CmdIStr3  =rolemap       #npc贴图
		CmdIStr4  =class         #npc品级
		CmdIStr5  =hpvalue       #npc血量值
		CmdIStr6  =status        #npc状态 
		CmdIStr7  =roleattr      #属性*/
		public static const QRY_NPC_ROLE_INFO:String = "USERGCX.Qrynpcroleinfo(gdgz)";
		
		
		/*[USERYW.Delnpcroleinfo]
		@=删除npc角色信息
		SrcFName  = useryw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =rolename    #npc角色名称
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =roleid          #新增修改标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const DEL_NPC_ROLE_INFO:String = "USERGYW.Delnpcroleinfo(gdgz)";
		
		/*[USERGCX.Qrystdnpclst]
		@=查询用户个人NPC列表信息
		SrcName  =usergcx.c
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =stdid        #学生标识
		#param[out] 命令字出口:
		CmdIStr1  =stdid        #学生标识
		CmdIStr2  =relatid       #个人房间关联标识
		CmdIStr3  =roleid        #npc标识
		CmdIStr4  =rolename      #npc名称
		CmdIStr5  =rolemap       #npc贴图
		CmdIStr6  =class         #npc品级
		CmdIStr7  =hpvalue       #npc血量值
		CmdIStr8  =status        #npc状态 
		CmdIStr9  =roleattr      #属性*/
		public static const QRY_STD_NPC_LIST:String = "USERGCX.Qrystdnpclst(gdgz)";
		
		/*[USERGYW.IntUpdlandinfo]
		@=增改岛屿信息
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =landname    #岛屿名称
		CmdIStr2  =wbidface    #显示素材名称
		CmdIStr3  =demo        #描述
		CmdIStr4  =type        #类型
		CmdIStr5  =status      #岛屿状态 参考RRL_STATCODE 参数 A在用 X停用
		CmdIStr6  =price       #单价
		CmdIStr7  =tasknum     #游戏任务上限数量
		CmdIStr8  =builtlong   #建造时长(秒)
		CmdIStr9  =dealoperid   #处理工号
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno         #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =roleid          #修改标识
		CmdOStr2  =errMsg         #失败提示信息*/
		public static const INT_UPD_LAND_INFO:String="USERGYW.IntUpdlandinfo(gdgz)";
		
		/*[USERGCX.Qrylandinfo]
		@=查询岛屿列表信息
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		#param[out] 命令字出口:
		CmdOStr1  =landid        #岛屿标识
		CmdOStr2  =landname      #岛屿名称
		CmdOStr3  =demo          #描述
		CmdOStr4  =wbidface      #显示的素材
		CmdOStr5  =type          #类型
		CmdOStr6  =status        #岛屿状态 参考RRL_STATCODE 参数 A在用 X停用
		CmdOStr7  =price         #单价
		CmdOStr7  =tasknum       #游戏任务上限数量
		CmdOStr7  =builtlong     #建造时长(秒)
		CmdOStr7  =dealoperid    #处理工号
		CmdOStr7  =dealtime      #最新处理时间(YYYYMMDD-hhmmss)*/
		public static const QRY_LAND_INFO:String = "USERGCX.Qrylandinfo(gdgz)";
		
		/*[USERGCX.DeleteLandInfo]
		@=删除岛屿信息
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =landname    #岛屿名称
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno         #错误代码
		#"000"=成功
		#"MMM"=其他错误
		#"0M1"=岛屿已被用户购买
		CmdOStr1  =landid          #岛屿标识
		CmdOStr2  =errMsg         #失败提示信息*/
		public static const DELETE_LAND_INFO:String = "USERGYW.DeleteLandInfo(gdgz)";
		
		/**
		 *[IntUpdUserConfig]
		 @=增改用户配置信息
		 SrcFName  =useryw.c    #C源码所在文件名
		 CmdTypeN  =1:1         #命令字类型;1:1
		 #param[in] 命令字入口:
		 CmdIStr1  =sid         #用户id
		 CmdIStr2  =config      #用户配置文本
		 #param[out] 命令字出口:
		 #失败
		 CmdOStr0  =errno       #错误代码
		 #"000"=成功
		 #"MMM"=其他错误
		 CmdOStr1  =sid         #新增修改标识
		 CmdOStr2  =errMsg      #失败提示信息 
		 */		
		public static const SEND_PER_CONFIG:String = "USERYW.IntUpdUserConfig(gdgz)";
		
		/**
		 *[SelectUserConfig]
		 @=查找用户配置信息
		 SrcFName  =useryw.c    #C源码所在文件名
		 CmdTypeN  =1:1         #命令字类型;1:1
		 #param[in] 命令字入口:
		 CmdIStr1  =sid         #用户id
		 #param[out] 命令字出口:
		 CmdOStr1  =sid         #用户id
		 CmdOStr2  =config      #用户配置文本 
		 */		
		public static const GET_PER_CONFIG:String = "USERYW.SelectUserConfig(gdgz)";
		
		/**
		 *[USERCX.QryPerBGMusic]
		 @=查询个人空间文件记录
		 SrcName  =userconfig.c
		 CmdTypeN =1:N         #命令字类型;1:1/N
		 #param[in] 命令字入口:
		 CmdIStr1  =sid        #用户id
		 #param[out] 命令字出口:
		 CmdIStr1  =relid      #关联id
		 CmdIStr2  =sid        #用户id
		 CmdIStr3  =musicid	   #物品id
		 CmdIStr4  =filename   #音乐名称 
		 */		
		public static const QRY_PER_BGMUSIC:String = "USERCX.QryPerBGMusic(gdgz)";
		
		/**
		 * [AddBGMusic]
		 @=添加背景音乐
		 SrcFName  =userconfig.c    #C源码所在文件名
		 CmdTypeN  =1:1         #命令字类型;1:1
		 #param[in] 命令字入口:
		 CmdIStr1  =sid         #用户id
		 CmdIStr2  =musicid		 #音乐id
		 CmdIStr3  =musname		 #音乐名称
		 CmdIStr4  =relpath		 #相对路径
		 #param[out] 命令字出口:
		 CmdOStr0  =errno       #错误代码
		 #"000"=成功
		 #"MMM"=其他错误
		 CmdOStr1  =relid       #关联标识
		 CmdOStr2  =errMsg      #失败提示信息 
		 */		
		public static const ADD_BGMUSIC:String = "USERYW.AddBGMusic(gdgz)";
		
		/**
		 *[DelBGMusic]
		 @=删除背景音乐
		 SrcFName  =userconfig.c    #C源码所在文件名
		 CmdTypeN  =1:1         #命令字类型;1:1
		 #param[in] 命令字入口:
		 CmdIStr1  =sid         #用户id
		 CmdIStr2  =musicid		 #物品id
		 #param[out] 命令字出口:
		 CmdOStr0  =errno       #错误代码
		 #"000"=成功
		 #"MMM"=其他错误
		 CmdOStr1  =musicid     #音乐标识
		 CmdOStr2  =errMsg      #失败提示信息 
		 */		
		public static const DEL_BGMUSIC:String = "USERYW.DelBGMusic(gdgz)";
		
		
		
		
		/**
		 * [IntUpdgametask]
		@=增改游戏任务
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =taskid      #0为新增
		CmdIStr2  =taskname    #名称
		CmdIStr3  =taskmemo    #任务描述
		CmdIStr4  =tasktype    #任务类型 TASKTYPE参数 B 战斗 W 挖矿 D 钓鱼
		CmdIStr5  =script      #相关脚本
		CmdIStr6  =npcnum      #npc参与人数
		CmdIStr7  =spdtime     #花销时长(秒为单位)
		CmdIStr8  =reward      #完成任务赚取金币数
		CmdIStr9  =landlist    #关联岛屿标识串 已,进行分割
		CmdIStr10 =reqtype     #是否必选 Y 必选 N 可选
		CmdIStr11 =ordernum    #任务顺序
		CmdIStr12 =icelongt    #冷却时长(秒为单位)
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =taskid          #修改标识
		CmdOStr2  =errMsg       	 #失败提示信息
		 */
		
		public static const INT_UPD_GAME_TASK:String = "USERGYW.IntUpdgametask(gdgz)";
		
		/**
		 *[USERGCX.QrygametaskInfo]
		 @=查询岛屿列表信息
		 CmdTypeN =1:N      #命令字类型;1:1/N
		 #param[in] 命令字入口:
		 #param[out] 命令字出口:
		 CmdOStr1  =taskid        #任务标识                                                   
		 CmdOStr2  =taskname      #任务名称                                                   
		 CmdOStr3  =taskmemo      #任务描述                                                   
		 CmdOStr4  =tasktype      #任务类型 TASKTYPE参                                        
		 CmdOStr5  =script        #相关脚本                                                   
		 CmdOStr6  =npcnum        #npc参与人数                                                
		 CmdOStr7  =spdtime       #花销时长(秒为单位)                                         
		 CmdOStr8  =reward        #完成任务赚取金币数                                         
		 CmdOStr9  =landlist      #关联岛屿标识串 已
		 CmdOStr10 =reqtype       #冷却时长(秒为单位)                                         
		 CmdOStr11 =ordernum      #任务标识
		 CmdOStr12 =icelongt      #任务标识 
		 */		
		public static const QRY_GAME_TASK_INFO:String = "USERGCX.QrygametaskInfo(gdgz)";
		
		
		/**
		 * [USERGYW.Deletegametask]
		@=删除游戏任务
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =taskid      #任务标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"MMM"=其他错误
		#"0M1"=岛屿已被用户购买
		CmdOStr1  =taskid          #任务标识
		CmdOStr2  =errMsg       	 #失败提示信息
		 */
		public static const DELETE_GAME_TASK:String = "USERGYW.Deletegametask(gdgz)";

		/**
		 * [OPERYW.RegisterOperid]
		 @=注册操作员，返回注册的操作员id
		 SrcFName  =operyw.c   #C源码所在文件名
		 CmdTypeN  =1:1        #命令字类型;1:1/N
		 #param[in] 命令字入口:
		 CmdIStr1  =opcode     #登录帐号
		 CmdIStr2  =region     #用户分区；取值参见 USER_REGION 参数
		 #param[out] 命令字出口:
		 CmdOStr1  =operid     #操作员标识
		 */
		public static const REGISTER_OPER_ID:String = "OPERYW.RegisterOperid";
		
		/*[USERGYW.ApplynpcrolByplayid]
		@=申请随机npc角色
		CmdTypeN =1:1      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =playid   #玩家标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno        	#错误代码
		#"000"=成功
		#"0M1"=个人房间不存在
		#"0M2"=暂没有ncp角色分配
		CmdOStr1  =playid    #玩家标识
		CmdOStr2  =relatid   #个人房间标识
		CmdOStr3  =roleid    #npc角色
		CmdOStr4  =rolename  #npc名称
		CmdOStr5  =rolemap   #mpc贴图
		CmdOStr6  =roleattr  #mpc角色属性*/
		public static const APPLY_NPC_ROL_BYPLAYID:String = "USERGYW.ApplynpcrolByplayid(gdgz)";
		

		/*[USERGYW.Inplayidroomnpc]
		@=npc角色进入到用户房间
		CmdTypeN =1:1      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =playid   #玩家标识
		CmdIStr2 =relatid  #个人房间标识
		CmdOStr3  =roleid  #npc角色
		#param[out] 命令字出口:
		#失败
		#"000"=成功
		#"0M1"=个人房间不存在
		#"0M2"=暂没有ncp角色分配
		CmdOStr1  =instid          #标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const IN_PLAYID_ROOMNPC:String = "USERGYW.Inplayidroomnpc(gdgz)";
		
		/*[USERGYW.Inplayidroomnpc]
		@=npc角色离开用户房间
		CmdTypeN =1:1      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =playid   #玩家标识
		CmdIStr2 =relatid  #个人房间标识
		CmdOStr3  =roleid  #npc角色
		#param[out] 命令字出口:
		#失败
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =instid          #标识
		CmdOStr2  =errMsg       	 #失败提示信息*/
		public static const OUT_PLAYID_ROOMNPC:String = "USERGYW.Outplayidroomnpc(gdgz)";
		

		/**
		 *[InsertStudent]
		 @=插入学生
		 SrcFName  =useryw.c   #C源码所在文件名
		 CmdTypeN  =1:1        #命令字类型;1:1/N
		 #param[in] 命令字入口:
		 CmdIStr1  =operid     #操作员标识
		 CmdIStr2  =opcode     #操作员登录账号
		 CmdIStr3  =nickname   #操作员昵称
		 CmdIStr4  =realname   #真实姓名
		 CmdIStr5  =smstelno   #可收短信手机号
		 CmdIStr6  =passwd     #SHA加密后密码
		 CmdIStr7  =birth      #生日(YYYYMMDD)
		 CmdIStr8  =mtomrrow   #某主线当日计划生成后，间隔多少分钟(0~1440)，可以生成下一天任务。
		 CmdIStr9  =qanswer1   #提问及答案
		 CmdIStr10 =lixiang    #理想
		 CmdIStr11 =aihao      #爱好
		 CmdIStr12 =smile      #心情状态
		 CmdIStr13 =school     #所在学校名称
		 CmdIStr14 =sclass     #所在班级名称
		 CmdIStr15 =father     #父亲列表
		 CmdIStr16 =mother     #母亲列表
		 CmdISrr17 =lsassist   #辅导员列表
		 CmdISrr18 =gender     #学生性别
		 CmdISrr19 =signature  #个性签名
		 CmdIStr20 =grade      #年级
		 #param[out] 命令字出口:
		 #失败
		 CmdOStr0  =errno      #错误代码
		 #"M02"=用户已存在
		 #"MMM"=其他错误
		 CmdOStr1  =errMsg     #失败提示信息
		 */
		public static const REGISTER_STUDENT:String = "USERYW.InsertStudent(gdgz)";
		
		/**
		 *[SelectFormula]
		 @=查看数学公式文本
		 SrcFName  = wrongtitle.c  #C源码所在文件名
		 CmdTypeN  =1:1          	#命令字类型;1:1
		 #param[in] 命令字入口:
		 CmdIStr1  = formid			#公式id
		 #param[out] 命令字出口:
		 CmdOStr1  = formid			#公式id
		 CmdOStr2  = fortext			#答复提交人 
		 */		
		public static const SELECT_MATH_FORMULA:String = "USERYW.SelectFormula(gdgz)";
		
		public static const QRY_MATH_FORMULA:String = "USERCX.Qrymathformula(gdgz)";
		
		/**[QryWrongTitle]
		@=显示错题列表命令字
		SrcFName  = wrongtitle.c     	#C源码所在文件名
		CmdTypeN  =1:N          	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =wrongid        	#错题标识；全局唯一标识，*匹配所有
		CmdIStr2  =stdid            	#学生id，*匹配所有
		CmdIStr3  =subject         	#科目（yw/sx/yy/wl/hx/sw/zz/ls/dl），*匹配所有
		CmdIStr4  =srcdesc        	#素材出处来源描述；小升初、中考、高考、书、网络等
		CmdIStr5  =copcode       	#创建人工号，*匹配所有
		CmdIStr6  =mopcode      	#最后修改人工号，*匹配所有
		CmdIStr7  =modbegintime   	#最后修改开始时间 YYYYMMDD 默认00000000
		CmdIStr8  =modendtime   	#最后修改结束时间 YYYYMMDD 默认YYYYMMDD
		CmdIStr9  =status         	#题目状态，*匹配所有
		#param[out] 命令字出口:
		CmdOStr1  =wrongid        	#错题标识；全局唯一标识
		CmdOStr2  =stdid            	#学生id
		CmdOStr3  =subject         	#科目（yw/sx/yy/wl/hx/sw/zz/ls/dl）
		CmdOStr4  =srcdesc        	#素材出处来源描述；小升初、中考、高考、书、网络等
		CmdOStr5  =copcode       	#创建人工号
		CmdOStr6  =mopcode      	#最后修改人工号
		CmdOStr7  =modtime      	#最后修改时间
		CmdOStr8  =status         	#题目状态 
		CmdOStr9  =anstype        	#答案类型
		CmdOStr10 =answer     		#答案
		CmdOStr11 =qstntype        	#题目类型（图片/文字/脚本）
		CmdOStr12 =question  			#题目*/
		public static const QRY_WRONGTITLE:String = "USERCX.QryWrongTitle(gdgz)";
		
		
		/**USERYW
		[InUpWrongTitle]
		@=增改错题内容
		SrcFName  = wrongtitle.c     	#C源码所在文件名
		CmdTypeN  =1:1          	#命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =wrongid        	#错题标识；全局唯一标识
		CmdIStr2  =stdid             #学生id
		CmdIStr3  =subject         	#科目（yw/sx/yy/wl/hx/sw/zz/ls/dl）
		CmdIStr4  =srcdesc        	#素材出处来源描述；小升初、中考、高考、书、网络等
		CmdIStr5  =copcode       	#创建人工号
		CmdIStr6  =mopcode      	#最后修改人工号
		CmdIStr7  =status         	#题目状态 
		CmdIStr8  =anstype        	#答案类型
		CmdIStr9  =answer     		#答案
		CmdIStr10 =qstntype        	#题目类型（图片/文字/脚本）
		CmdIStr11 =question  			#题目
		#param[out] 命令字出口:
		CmdOStr0  =errno       		#错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  = wrongid        	#错题标识；全局唯一标识
		CmdOStr2  =errMsg      		#失败提示信息*/
		public static const INSERT_WRONGTITLE:String = "USERYW.InUpWrongTitle(gdgz)";

		
		/**SelectWrongTitle]
		@=查找错题内容
		SrcFName  =useryw.c    #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  = wrongid        	#错题标识；全局唯一标识
		#param[out] 命令字出口:
		CmdOStr1  =wrongid        	#错题标识；全局唯一标识
		CmdOStr2  =stdid            #学生id
		CmdOStr3  =subject         	#科目（yw/sx/yy/wl/hx/sw/zz/ls/dl）
		CmdOStr4  =srcdesc        	#素材出处来源描述；小升初、中考、高考、书、网络等
		CmdOStr5  =copcode       	#创建人工号
		CmdOStr6  =mopcode      	#最后修改人工号
		CmdOStr7  =modtime      	#最后修改时间
		CmdOStr8  =status         	#题目状态 
		CmdOStr9  =anstype        	#答案类型
		CmdOStr10 =answer     		#答案
		CmdOStr11 =qstntype        	#题目类型（图片/文字/脚本）
		CmdOStr12 =question  		#题目*/
		public static const SELECT_WRONGTITLE:String  = "USERYW.SelectWrongTitle(gdgz)";

		/**
		 *[SelPerCommand]
		 *@=下载用户命令
		 *SrcFName  = mac.c    	    #C源码所在文件名
		 *CmdTypeN  =1:1           	#命令字类型;1:1
		 *#param[in] 命令字入口:
		 *CmdIStr1  =macid         	#平板标识
		 *CmdIStr2  =stdid          #用户标识
		 *#param[out] 命令字出口:
		 *CmdOStr0  =errno       		#错误代码
		 *#"000"=有记录
		 *#"001"=没有记录
		 *CmdOStr1  =comid          #命令标识
		 *CmdOStr2  =macid          #平板标识
		 *CmdOStr3  =status         #命令状态 U-已上传 D-已下载 S-已停用
		 *CmdOStr4  =udate          #上传时间
		 *CmdOStr5  =opercode       #上载人名称
		 *CmdOStr6  =comcode        #命令 
		 */
		public static const SELECT_PERCOMMAND:String = "USERYW.SelPerCommand(gdgz)";
		
		
		/*[InUpPlayNpcLand]
		@=增改用户、npc、海岛关联记录
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =instid      #实例标识
		CmdIStr2  =playerid    #用户标识
		CmdIStr3  =landid      #岛屿标识
		CmdIStr4  =pnpcid      #玩家npc标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =instid      #修改标识
		CmdOStr2  =errMsg      #失败提示信息*/
		public static const INUP_PLAYNPCLAND:String = "USERGYW.InUpPlayNpcLand(gdgz)";
		
		/*[QryPlayNpcLand]
		@=查询用户、npc、海岛关联信息
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =instid      #实例标识(*匹配所有)
		CmdIStr2  =playerid    #用户标识(*匹配所有)
		CmdIStr3  =landid      #岛屿标识(*匹配所有)
		CmdIStr4  =pnpcid      #玩家npc标识(*匹配所有)
		#param[out] 命令字出口:
		CmdOStr1  =instid      #实例标识
		CmdOStr2  =playerid    #用户标识
		CmdOStr3  =landid      #岛屿标识
		CmdOStr4  =pnpcid      #玩家npc标识*/
		public static const QRY_PLAY_NPC_LAND:String = "USERGCX.QryPlayNpcLand(gdgz)";
		
		
		/*[DelPlayNpcLand]
		@=删除用户、npc、海岛关联记录
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =instid      #实例标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =instid      #修改标识
		CmdOStr2  =errMsg      #失败提示信息*/
		public static const DEL_PLAY_NPC_LAND:String = "USERGYW.DelPlayNpcLand(gdgz)";
		
		

		/*[InUpInstantMess2]
		@=插入一条离线消息
		SrcFName  = faq.c    	    #C源码所在文件名
		CmdTypeN  =1:1           	#命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =mesid          #消息标识 0添加
		CmdIStr2  =sedid          #发送者标识
		CmdIStr3  =sedcode        #发送者名称
		CmdIStr4  =recid          #接受者标识
		CmdIStr5  =reccode        #接受者名称
		CmdIStr6  =type           #类型
		CmdIStr7  =mess           #发送内容
		#param[out] 命令字出口:                
		CmdOStr0  =errno       		#错误代码    
		#"000"=成功                            
		#"MMM"=其他错误                        
		CmdOStr1  =mesid          #命令标识    
		CmdOStr2  =errMsg      		#失败提示信息*/
		public static const INUP_INSTANT_MESS:String = "USERYW.InUpInstantMess2(gdgz)";
		
		/*【USERCX】
		[QryURInsMess2]
		@=显示未读的离线信息
		SrcFName  =message.c    #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =recid        #接受者标识
		#param[out] 命令字出口:
		CmdOStr1  =mesid        #消息标识
		CmdOStr2  =sedid        #发送者标识
		CmdOStr3  =sedcode      #发送者名称
		CmdOStr4  =recid        #接受者标识
		CmdOStr5  =reccode      #接受者名称
		CmdOStr6  =sedtime      #发送时间
		CmdOStr7  =type         #类型
		CmdOStr8  =mess         #发送内容*/
		public static const QRYUR_INS_MESS:String = "USERCX.QryURInsMess2(gdgz)";
		
		
		/*[QryAllInsMess2]
		@=显示所有的离线消息
		SrcFName  =message.c    #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =Aid          #A用户标识(可为*)
		CmdIStr2  =Bid          #B用户标识(可为*)
		#param[out] 命令字出口:
		CmdOStr1  =mesid        #消息标识
		CmdOStr2  =sedid        #发送者标识
		CmdOStr3  =sedcode      #发送者名称
		CmdOStr4  =recid        #接受者标识
		CmdOStr5  =reccode      #接受者名称
		CmdOStr6  =sedtime      #发送时间
		CmdOStr7  =type         #类型
		CmdOStr8  =mess         #发送内容*/
		public static const QRY_ALLINS_MESS:String = "USERCX.QryAllInsMess2(gdgz)";
		
		
		/*[QryAllInsMessByP2]
		@=显示所有的离线消息
		SrcFName  =message.c    #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =Aid          #A用户标识(可为*)
		CmdIStr2  =Bid          #B用户标识(可为*)
		CmdIStr3  =maxreturn    #一次返回最大个数
		CmdIStr4  =pageno       #当前页数
		#param[out] 命令字出口:
		CmdOStr1  =allpageno    #总页数
		CmdOStr2  =curpageno    #当前页数
		CmdOStr3  =mesid        #消息标识
		CmdOStr4  =sedid        #发送者标识
		CmdOStr5  =sedcode      #发送者名称
		CmdOStr6  =recid        #接受者标识
		CmdOStr7  =reccode      #接受者名称
		CmdOStr8  =sedtime      #发送时间
		CmdOStr9  =type         #类型
		CmdOStr10  =mess        #发送内容*/
		public static const QRY_ALLINS_MESS_BYP:String = "USERCX.QryAllInsMessByP2(gdgz)";
		
		
		
		/*[Move2InstMessLog]
		@=将指定离线消息移到Log表中
		SrcFName  =faq.c          #C源码所在文件名
		CmdTypeN  =1:1            #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =mesid          #消息标识(逗号分隔的多个id)
		#param[out] 命令字出口:                
		CmdOStr0  =errno       		#错误代码    
		#"000"=成功                            
		#"MMM"=其他错误                        
		CmdOStr1  =mesid          #命令标识    
		CmdOStr2  =errMsg      		#失败提示信息*/
		public static const MOVE_2_INSTMESSLOG:String = "USERYW.Move2InstMessLog(gdgz)";
		
		
		/*{USERYW}
		[InUpPlayerTask]
		@=增加用户任务关联记录
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =ptid        #玩家任务关联id
		CmdIStr2  =playerid    #玩家id     
		CmdIStr3  =taskid      #任务id
		CmdIStr4  =begtime     #任务开始时间
		CmdIStr5  =endtime     #预计任务完成时间
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =ptid        #玩家任务关联id
		CmdOStr2  =errMsg      #失败提示信息*/
		public static const INUP_PLAYER_TASK:String = "USERGYW.InUpPlayerTask(gdgz)";
		
		/*[DelPlayerTask]
		@=增加用户任务关联记录
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =ptid        #玩家任务关联id
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =ptid        #玩家任务关联id
		CmdOStr2  =errMsg      #失败提示信息*/
		public static const DEL_PLAYER_TASK:String = "USERGYW.DelPlayerTask(gdgz)";
		
		
		/*[QryPlayerTaskById]
		@=查询玩家任务关联信息
		CmdTypeN =1:N      #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =playerid    #玩家id
		#param[out] 命令字出口:
		CmdOStr1  =ptid        #玩家任务关联id
		CmdOStr2  =playerid    #玩家id     
		CmdOStr3  =taskid      #任务id
		CmdOStr4  =begtime     #任务开始时间
		CmdOStr5  =endtime     #预计任务完成时间*/
		public static const QRY_PLAYERTASK_BYID:String = "USERGCX.QryPlayerTaskById(gdgz)";
		
		
		/*{USERGYW}
		[FinPlayerTask]
		@=完成用户任务，获取奖励
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =ptid        #玩家任务关联id
		#param[out] 命令字出口:
		CmdOStr1  =ptid        #玩家任务关联id
		CmdOStr2  =reward      #失败提示信息*/
		public static const FIN_PLAYER_TASK:String = "USERGYW.FinPlayerTask(gdgz)";
		
		
	
		
		
		/*USERGCX}
	[QryEquipment]
	@=查询装备商城信息
	SrcName  =equip.c
	CmdTypeN =1:N          #命令字类型;1:1/N
	#param[in] 命令字入口:
	CmdIStr1  =eqid        #装备标识(*匹配所有)
	CmdIStr2  =eqname      #装备名称(*匹配所有)
	#param[out] 命令字出口:
		CmdOStr1  =eqid        #装备标识
		CmdOStr2  =eqname      #装备名称
		CmdOStr3  =price       #装备价格
		CmdOStr4  =moperid     #最后修改人
		CmdOStr5  =mtime       #最后修改时间
		CmdOStr6  =property    #装备属性
		CmdOStr7  =eqalias     #装备别名
		CmdOStr8  =gprice      #装备金币价格
		CmdOStr9  =description #描述
*/
		public static const QRY_EQUIPMENT:String = "USERGCX.QryEquipment(gdgz)";
		
		/*[QryUserEquip]
		@=查询用户已有装备信息
		SrcName  =equip.c      #代码所在文件
		CmdTypeN =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid      #用户标识
		#param[out] 命令字出口:
		CmdOStr1  =eqid        #装备标识
		CmdOStr2  =eqname      #装备名称*/
		public static const QRY_USER_EQUIP:String = "USERGCX.QryUserEquip(gdgz)";
		
		
		/*{USERGYW}
		[InUpEquipment]
		@=增改装备信息
		SrcFName  =equip.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =eqid        #装备标识(0为增加)
		CmdIStr2  =eqname      #装备名称
		CmdIStr3  =price       #装备价格
		CmdIStr4  =moperid     #最后修改人
		CmdIStr5  =property    #装备属性
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0M1"=eqname已存在
		#"MMM"=其他错误
		CmdOStr1  =eqid        #装备标识*/
		public static const INUP_EQUIPMENT:String = "USERGYW.InUpEquipment(gdgz)";
		
		
		/*[BuyEquipment]
		@=用户购买装备
		SrcFName  =equip.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =userid      #用户标识
		CmdIStr2  =eqid        #装备标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"M00"=金币不足
		#"MMM"=其他错误
		CmdOStr1  =eqid        #装备标识
		CmdOStr2  =eqname      #装备名称
		CmdOStr3  =price       #游戏币价格
		CmdOStr4  =gprice      #学习金币价格*/
		public static const BUY_EQUIPMENT:String = "USERGYW.BuyEquipment(gdgz)";
		
		/*[DelEquipment]
		@=删除装备
		SrcFName  =equip.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =eqid        #装备标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0M1"=eqid不存在
		#"MMM"=其他错误
		CmdOStr1  =eqid        #装备标识*/
		public static const DEL_MARKET_EQUIPMENT:String = "USERGYW.DelEquipment(gdgz)";
		
		
		/*[SelHappyStatus]
		@=获取娱乐状态
		SrcFName  =useryw.c      #C源码所在文件名
		CmdTypeN  =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =code          #参数编码(娱乐岛状态 S_HAPPY_ISLAND_O)
		CmdIStr2  =userId        #用户id
		#param[out] 命令字出口:
		CmdIStr1  =value         #参数取值*/
		public static const SEL_HAPPY_STATUS:String = "USERYW.SelHappyStatus(gdgz)";
		
		
		/*[QryFightByUId]
		@=查询用户正在进行的决斗
		SrcName  =fight.c      #代码所在文件
		CmdTypeN =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid      #装备标识
		#param[out] 命令字出口:
		CmdOStr1  =fid         #挑战标识         
		CmdOStr2  =aid         #挑战者标识 
		CmdOStr3  =aname      
		CmdOStr4  =bid         #被挑战者标识
		CmdOStr5  =bname
		CmdOStr6  =ablood      #A当前血量        
		CmdOStr7  =bblood      #B当前血量  
		CmdOStr8  =fstatus     #挑战状态  
		CmdOStr9  =round       #当前回合数       
		CmdOStr10 =apoint1     #A当前回合第一点数
		CmdOStr11 =apoint2     #A当前回合第二点数
		CmdOStr12 =apoint3     #A当前回合第三点数
		CmdOStr13 =bpoint1     #B当前回合第一点数
		CmdOStr14 =bpoint2     #B当前回合第二点数
		CmdOStr15 =bpoint3     #B当前回合第三点数
		CmdOStr16 =lablood     #A上回合血量
		CmdOStr17 =lbblood     #B上回合血量
		CmdOStr18 =alrpoint1   #A上回合第一点数
		CmdOStr19 =alrpoint2   #A上回合第二点数
		CmdOStr20 =alrpoint3   #A上回合第三点数
		CmdOStr21 =blrpoint1   #B上回合第一点数
		CmdOStr22 =blrpoint2   #B上回合第二点数
		CmdOStr23 =blrpoint3   #B上回合第三点数
		CmdOStr24 =astatus     #A查看状态
		CmdOStr25 =bstatus     #B查看状态*/
		public static const QRY_FIGHT_BY_UID:String = "USERGCX.QryFightByUId(gdgz)";
		
		/*【USERGYW】
		[ChallengeSb]
		@=向某人发起挑战
		SrcFName  =fight.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =aid         #挑战者标识
		CmdIStr2  =aname       #挑战者名称
		CmdIStr3  =bid         #被挑战者标识
		CmdIStr4  =bname       #被挑战者名称
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=挑战成功
		#"0M1"=挑战失败,两人正在决斗中
		#"0M2"=挑战失败,CmdOStr[2]正在进行的战斗场数大于10（最大场数）
		#"MMM"=其他错误
		CmdOStr1  =fid         #挑战标识
		CmdOStr2  =aid         #挑战者标识
		CmdOStr3  =ctrl        #剩余次数*/
		public static const CHALLENGE_SB:String = "USERGYW.ChallengeSb(gdgz)";
		
		/*[RespChanllenge]
		@=回复挑战（接受/拒绝挑战）
		SrcFName  =fight.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =fid         #挑战标识
		CmdIStr2  =uid         #接受挑战者标识
		CmdIStr3  =respond     #回复挑战（Y-接受，N-拒绝）
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =fid         #挑战标识
		CmdOStr2  =ctrl        #剩余次数*/
		public static const RESP_CHANLLENGE:String = "USERGYW.RespChanllenge(gdgz)";
		
		/*[SurrChanllenge]
		@=投降
		SrcFName  =fight.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =fid         #挑战标识
		CmdIStr2  =uid         #投降者标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =fid         #挑战标识*/
		public static const SURR_CHANLLENGE:String = "USERGYW.SurrChanllenge(gdgz)";
		
		/*[GiveOnePoint]
		@=出招
		SrcFName  =fight.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =fid         #挑战标识
		CmdIStr2  =uid         #出招者标识
		CmdIStr3  =point       #出招点数
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =fid         #挑战标识         
		CmdOStr2  =aid         #挑战者标识       
		CmdOStr3  =bid         #被挑战者标识     
		CmdOStr4  =ablood      #A当前血量        
		CmdOStr5  =bblood      #B当前血量
		CmdOStr6  =fstatus     #挑战状态*/
		public static const GIVE_ONE_POINT:String = "USERGYW.GiveOnePoint(gdgz)";
		
		/*【USERGYW】
		[AffFightResult]
		@=确认战斗结果
		SrcFName  =fight.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =fid         #挑战标识
		CmdIStr2  =uid         #出招者标识
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =fid         #挑战标识         
		CmdOStr2  =aid         #挑战者标识*/
		public static const AFF_FIGHT_RESULT:String = "USERGYW.AffFightResult(gdgz)";

		
		
		
		
		

		
		/*[SelTaskStatus]
		@=获取任务完成情况
		SrcFName  =useryw.c      #C源码所在文件名
		CmdTypeN  =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =sid           #学生标识
		#param[out] 命令字出口:
		CmdIStr1  =value         #参数取值*/
		public static const SEL_TASK_STATUS:String = "USERYW.SelTaskStatus(gdgz)";
		
		
		/*【USERWJ】
		[SignDownHostFile]
		@=标记已下载的素材文件
		SrcFName  =userwj.c     #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =macid        #客户端标识
		CmdIStr2  =doperid      #下载工号标识；
		CmdIStr3  =fileinfo     #文件信息,格式 wbid,version,wfname;wbid,version,wfname;
		#wbid      素材文件标识, 
		#version   ListNewerBinFile命令字返回的最新版本号
		#wfname    素材文件名
		#param[out] 命令字出口:
		#成功
		CmdOStr1  =macid        #文件总长度
		CmdOStr2  =doperid      #已传文件长度，取值与文件总长度相同，表示下载结束
		#失败
		CmdOStr0  =errno        #错误代码
		#"M00"=素材文件不存在
		#"MMM"=其他错误
		CmdOStr1  =errMsg       #失败提示信息*/
		public static const SIGN_DOWN_HOST_FILE:String = "USERWJ.SignDownHostFile(gdgz)";
		
		
		/*【USERYW】
		[InUpPadInfo]
		@=增改平板状态信息
		SrcFName  =mac.c         #C源码所在文件名
		CmdTypeN  =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =macid         #平板标识
		CmdIStr2  =sid           #学生标识
		CmdIStr3  =entrance      #入口
		CmdIStr4  =model         #平板型号
		CmdIStr5  =airver        #Air版本号
		CmdIStr6  =stdver        #StudyMate版本号
		CmdIStr7  =eduver        #EduService版本号
		CmdIStr8  =stdper        #StudyMate权限
		CmdIStr9  =eduper        #EduService权限
		CmdIStr10 =space         #存储空间状态
		#param[out] 命令字出口:
		CmdOStr0  =errno         #错误代码
		#"000"=成功                            
		#"MMM"=其他错误                        
		CmdOStr1  =macid         #用户标识
		CmdOStr2  =userid        #失败提示信息*/
		public static const INUP_PAD_INFO:String = "USERYW.InUpPadInfo(gdgz)";
		
		

		/*[DownUserFile]
		@=录入人员查看文件
		SrcFName  = userwj.c 	#C源码所在文件名
		CmdTypeN  =1:1      	#命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =wfname   	#带相对路径的文件名(带扩展名)
		#下载时需要先将内容写入到临时文件；下载结束需要检查文件长度
		#用于校对
		CmdIStr2  =offset  		#起始下载位置，取值非零表示是续传；该命令字返回!!!并不表示下载结束。
		CmdIStr3  =step      	#一次返回的字节数；最长不超过32KB；一般约定3KB；
		#param[out] 命令字出口:
		#成功
		CmdOStr1  =fsize   		#文件总长度
		CmdOStr2  =downlen   	#已传文件长度，取值与文件总长度相同，表示下载结束
		CmdOStr3  =retlen  		#本次返回内容的长度
		CmdOStr4  =txt     		#本次返回的文件内容，超长串
		#失败
		CmdOStr0  =errno   		#错误代码
		#"M00"=用户文件不存在
		#"MMM"=其他错误
		CmdOStr1  =errMsg    	#失败提示信息*/
		public static const DOWN_USER_FILE:String = "USERWJ.DownUserFile(gdgz)";
		
		
		/*【USERWJ】
		[UpVoiceFile]
		@=上载聊天语音文件      #命令字功能描述;
		SrcFName  =pubfile.c    #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sedid        #发送者标识
		CmdIStr2  =sedcode      #发送者姓名
		CmdIStr3  =recid        #接受者标识
		CmdIStr4  =reccode      #接受者标识
		CmdIStr5  =wfname       #带相对(与WVOICEFROOT=/home/cpyf/userdata/pubic/voice/)路径的文件名；带扩展名
		CmdIStr6  =fsize        #文件总长度，每次都传输；取值与已传文件长度相同，则表示上载结束；
		CmdIStr7  =uplen        #已传文件长度，取值为0表示开始上载文件；
		CmdIStr8  =length       #本次上传内容长度，用于与CmdStr数组中长度进行校验
		CmdIStr9  =txt          #内容长串，最长32KB
		#param[out] 命令字出口:
		CmdOStr1  =fsize        #文件总长度
		CmdOStr2  =uplen        #已传文件长度
		CmdOStr3  =length       #本次成功上传的长度
		CmdOStr4  =wfname       #带绝对路径的文件名；带扩展名
		CmdOStr5  =mesid        #聊天标识*/
		public static const UP_VOICE_FILE:String = "USERWJ.UpVoiceFile(gdgz)";
		
		/*【USERGYW】
		[SelGameWallet]
		@=查询游戏钱包
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =playerid    #玩家标识
		CmdIStr2  =type        #游戏币类型		//SYSTEM.GAMEGOLD
		#param[out] 命令字出口:
		#失败
		CmdOStr1  =playerid    #玩家标识
		CmdOStr2  =type        #游戏币类型
		CmdOStr3  =value       #钱币数量*/
		public static const GET_GAME_MONEY:String = "USERGYW.SelGameWallet(gdgz)";
		
		
		/*[SearchStudent]
		@=查找学生
		SrcFName  =usercx.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid     #学生标识    
		CmdIStr2  =opcode     #学生登录账号
		CmdIStr3  =nickname   #学生昵称
		CmdIStr4  =realname   #学生真实姓名
		CmdIStr5  =school     #学校
		#param[out] 命令字出口:
		CmdOStr1  =operid     #操作员标识
		CmdOStr2  =opcode     #登录帐号;自己注册的;一般选QQ号或者email;
		CmdOStr3  =operst     #操作员状态；取值参见 OPERST 参数;
		CmdOStr4  =nickname   #操作员昵称
		CmdOStr5  =realname   #真实姓名
		CmdOstr6  =gender     #性别
		CmdOStr7  =goldnum    #金币数
		CmdOStr8  =birth      #生日(YYYYMMDD)
		CmdOStr9  =school     #所在学校名称
		CmdOStr10 =signature  #签名*/
		public static const SEARCH_STUDENT:String = "USERCX.SearchStudent(gdgz)";


		
		/*[SelFightCtrl]
		@=查询战斗控制
		SrcFName  =fight.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =uid         #玩家标识
		#param[out] 命令字出口:
		CmdOStr1  =uid         #玩家标识
		CmdOStr2  =count       #挑战剩余次数*/
		public static const SEL_FIGHT_CTRL:String = "USERGYW.SelFightCtrl(gdgz)";
		
		/*[InUpFightCtrl]
		@=修改战斗控制
		SrcFName  =fight.c     #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =uid         #玩家标识
		CmdIStr2  =count       #次数
		#param[out] 命令字出口:
		CmdOStr1  =uid         #玩家标识
		CmdOStr2  =count       #挑战剩余次数
		CmdOStr3  =date        #日期*/
		public static const INUP_FIGHT_CTRL:String = "USERGYW.InUpFightCtrl(gdgz)";
		
		
		/*【USERCX】
		[QryRealTimeInf]
		@=查询用户实时信息
		SrcFName =usercx.c
		CmdTypeN =1:1
		#param[in] 命令字入口:
		CmdIStr1 =sid            #学生标识
		#param[out] 命令字出口:                
		CmdOStr1 =inf            #实时信息串
		#实时信息串格式: 9个字节
		#第0个字节按位反映哪些信息存在
		#第1个字节-未读邮件数量
		#第2个字节-未读私聊数量
		#第3个字节-未读世界聊天数量
		#第4个字节-未读FAQ数量
		#第5个字节-...*/
		public static const QRY_REAL_TIME_INF:String = "USERCX.QryRealTimeInf(gdgz)";
		
		
		/*【USERGYW】
		[SelLRFightInf]
		@=获取上一轮战斗信息
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =fid          #战斗标识
		CmdIStr2 =userid       #用户标识
		#param[out] 命令字出口:
		CmdOStr1 =fid          #战斗标识
		CmdOStr2 =rid          #上回合回合数
		CmdOStr3 =lablood      #A上回合血量
		CmdOStr4 =lbblood      #B上回合血量
		CmdOStr5 =alrpoint1    #A上回合第一点数
		CmdOStr6 =alrpoint2    #A上回合第二点数
		CmdOStr7 =alrpoint3    #A上回合第三点数
		CmdOStr8 =blrpoint1    #B上回合第一点数
		CmdOStr9 =blrpoint2    #B上回合第二点数
		CmdOStr10=blrpoint3    #B上回合第三点数*/
		public static const SEL_LRFIGHT_INF:String = "USERGYW.SelLRFightInf(gdgz)";

		/*[QryPlayBrd]
		@=查询需要播放的广播
		SrcFName =message.c   #C源码所在文件名
		CmdTypeN =1:N         #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =operid      #用户标识
		#param[out] 命令字出口:                
		CmdOStr1  =secid      #广播标识
		CmdOStr2  =lev        #广播优先级
		CmdOStr3  =text       #广播文本内容*/
		public static const QRY_PLAY_BRD:String = "USERCX.QryPlayBrd(gdgz)";
		
		/*[InUpBroadcast]
		@=增改广播信息
		SrcFName  =message.c     	#C源码所在文件名
		CmdTypeN  =1:1           	#命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1  =secid          #广播标识(0添加)
		CmdIStr2  =operid         #创建人
		CmdIStr3  =begtime        #开始时间
		CmdIStr4  =endtime        #截止时间
		CmdIStr5  =ctrl           #广播控制
		CmdIStr6  =text           #文本内容
		#param[out] 命令字出口:                
		CmdOStr0  =errno       		#错误代码    
		#"000"=成功                            
		#"MMM"=其他错误                        
		CmdOStr1  =secid          #广播标识    
		CmdOStr2  =errMsg      		#失败提示信息*/
		public static const INUP_BOARD_CAST:String = "USERYW.InUpBroadcast(gdgz)";
		

		/**
		 * [QryRealTimeInfV2]
			@=查询用户实时信息(版本2)
			SrcFName =usercx.c
			CmdTypeN =1:1
			#param[in] 命令字入口:
			CmdIStr1 =sid            #学生标识
			CmdIStr2 =scene          #界面
			#param[out] 命令字出口:             
			CmdOStr1 =count1         #FAQ未读条数
			CmdOStr2 =count2         #邮件未读条数
			CmdOStr3 =count3         #私聊未读条数
			CmdOStr4 =count4         #系统广播(变化)标识
			CmdOStr5 =count5         #命令条数
			CmdOStr6 =count6         #世界聊天的最大ID
			CmdOStr7 =count7         #...
			CmdOStr8 =count8         #...
		 */
		public static const QRY_REALTIMEINFV2:String = "USERCX.QryRealTimeInfV2(gdgz)";
		
		/**★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		 * ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓教室培训专用↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
		/*【USERCX】
		[QryCroomProp]
		@=查询用户相关的教室
		SrcFName =message.c     #C源码所在文件名
		CmdTypeN =1:N           #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =operid        #用户标识(*查所有)
		#param[out] 命令字出口: 
		CmdOStr1 =crid          #教室标识
		CmdOStr2 =crname        #房间名称
		CmdOStr3 =crdes         #房间描述
		CmdOStr4 =tid           #老师标识
		CmdOStr5 =sid           #学生标识
		CmdOStr6 =qtype         #题目类型
		CmdOStr7 =qids          #问题标识串
		CmdOStr8 =coperid       #创建人
		CmdOStr9 =ctime         #创建时间
		CmdOStr10=stime         #开始时间
		CmdOStr11=crstat        #教室状态(U-未辅导、D-已辅导)
		CmdOStr12=cqid          #当前题目标识*/
		public static const QRY_CLASSROOM_PROP:String = "USERCX.QryCroomProp(gdgz)";
		
		/*{USERWJ}
		[UpCrVoiceFileV2]
		@=上载教室聊天语音文件  #命令字功能描述;
		SrcFName  =pubfile.c    #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =crid         #教室标识
		CmdIStr2  =qid          #题目标识
		CmdIStr3  =sedid        #发送者标识
		CmdIStr4  =sedcode      #发送者姓名
		CmdIStr5  =minf         #附加信息
		CmdIStr6  =wfname       #带相对(与WVOICEFROOT=/home/cpyf/userdata/pubic/voice/)路径的文件名；带扩展名
		CmdIStr7  =fsize        #文件总长度，每次都传输；取值与已传文件长度相同，则表示上载结束；
		CmdIStr8  =uplen        #已传文件长度，取值为0表示开始上载文件；
		CmdIStr9  =length       #本次上传内容长度，用于与CmdStr数组中长度进行校验
		CmdIStr10  =txt          #内容长串，最长32KB
		#param[out] 命令字出口:
		CmdOStr1  =fsize        #文件总长度
		CmdOStr2  =uplen        #已传文件长度
		CmdOStr3  =length       #本次成功上传的长度
		CmdOStr4  =wfname       #带绝对路径的文件名；带扩展名
		CmdOStr5  =mesid        #聊天标识*/
//		public static const UP_CRVOICE_FILE:String = 'USERWJ.UpCrVoiceFileV2(gdgz)';
		
		
		/*[UpCrFile]
		@=上载教室文件          #命令字功能描述;
		SrcFName  =pubfile.c    #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =crid         #教室标识
		CmdIStr2  =qid          #题目标识
		CmdIStr3  =sedid        #发送者标识
		CmdIStr4  =sedcode      #发送者姓名
		CmdIStr5  =ftype        #文件类型()   #文件类型(voice-声音,pic-图片)
		CmdIStr6  =minf         #附加信息
		CmdIStr7  =wfname       #带相对(与WVOICEFROOT=/homeyf/userdata/pubicoice/)路径的文件名；带扩展名
		CmdIStr8  =fsize        #文件总长度，每次都传输；取值与已传文件长度相同，则表示上载结束；
		CmdIStr9  =uplen        #已传文件长度，取值为0表示开始上载文件；
		CmdIStr10 =length       #本次上传内容长度，用于与CmdStr数组中长度进行校验
		CmdIStr11 =txt          #内容长串，最长32KB
		#param[out] 命令字出口:
		CmdOStr1  =fsize        #文件总长度
		CmdOStr2  =uplen        #已传文件长度
		CmdOStr3  =length       #本次成功上传的长度
		CmdOStr4  =wfname       #带绝对路径的文件名；带扩展名
		CmdOStr5  =mesid        #聊天标识*/
		public static const UP_CR_FILE:String = 'USERWJ.UpCrFile(gdgz)';
		
		/*【USERYW】
		[InCrInsMess]
		@=插入教室聊天记录
		SrcFName =message.c     #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =crid          #房间标识
		CmdIStr2 =qid           #题目标识
		CmdIStr3 =sedid         #发送人
		CmdIStr4 =sedcode       #发送者姓名
		CmdIStr5 =mtype         #聊天类型
		CmdIStr6 =mtxt          #聊天文本内容(7k)
		#param[out] 命令字出口:
		CmdOStr0  =errno        #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =secid        #记录标识*/
//		public static const IN_CLASSROOM_MESSAGE:String = 'USERYW.InCrInsMess(gdgz)';
		
		/*【USERYW】
		[InCrInsMessV1]
		@=插入教室聊天记录
		SrcFName =message.c     #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =crid          #房间标识
		CmdIStr2 =qid           #题目标识
		CmdIStr3 =sedid         #发送人
		CmdIStr4 =sedcode       #发送者姓名
		CmdIStr5 =mtype         #聊天类型(text\write)
		CmdIStr6 =minf          #附属内容
		CmdIStr7 =mtxt          #聊天文本内容(7k)
		#param[out] 命令字出口:
		CmdOStr0  =errno        #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1  =secid        #记录标识*/
		public static const IN_CLASSROOM_MESSAGE:String = 'USERYW.InCrInsMessV1(gdgz)';
				
		/*[QryCrIMAftNV2]
		@=查询某一个值之后的所有聊天记录
		SrcFName =message.c     #C源码所在文件名
		CmdTypeN =1:N           #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =crid          #教室标识
		CmdIStr2 =operid        #用户标识
		CmdIStr3 =num           #开始消息标识
		#param[out] 命令字出口: 
		CmdOStr1 =secid         #记录标识
		CmdOStr2 =crid          #房间标识
		CmdOStr3 =qid           #题目标识
		CmdOStr4 =sedid         #发送人
		CmdOStr5 =sedcode       #发送者姓名
		CmdOStr6 =sedtime       #发送时间
		CmdOStr7 =mtype         #聊天类型
		CmdOStr8 =minf          #附加信息
		CmdOStr9 =mtxt          #聊天文本内容(7k)
*/
		public static const QRY_CLASSROOM__MESSAGE_AFTER:String = 'USERCX.QryCrIMAftNV2(gdgz)';
		
		
		/*[UpCrCurrenQid]		上传当前id号
		SrcFName =message.c     #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =crid          #教室标识
		CmdIStr2 =tid           #老师标识
		CmdIStr3 =qid           #当前题目标识
		#param[out] 命令字出口:
		CmdOStr0 =errno         #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1 =crid          #教室标识
		CmdOStr1 =qid           #记录标识*/
		public static const UP_CR_CURRENTQID:String = 'USERYW.UpCrCurrenQid(gdgz)';
				
		/*[MarkExplained]
		@=标记已经完成辅导
		SrcFName =message.c     #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =crid          #教室标识
		#param[out] 命令字出口:
		CmdOStr0 =errno         #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1 =assign        #命令字结果(OK/ERROR)*/
		public static const MARK_EXPLAINED:String = "USERYW.MarkExplained(gdgz)";
		
		/*【USERCX】
		[QryElnExamHist]
		@=查询学生习题做题记录(平板用)
		SrcFName =elntask.c
		CmdTypeN =1:N
		#param[in] 命令字入口:
		CmdIStr1 =sid            #学生标识(*匹配所有)
		CmdIStr2 =tid            #题目标识(*匹配所有)
		#param[out] 命令字出口:                
		CmdOStr1 =eid            #记录标识
		CmdOStr2 =atime          #回答时间
		CmdOStr3 =sanswer        #用户答案
		CmdOStr4 =mark           #正确错误标识*/
		public static const USERCX_EXAM_HIST:String = 'USERCX.QryElnExamHist(gdgz)';
		
		/*[SelCrOnlineInf]  教室心跳返回,后台命令
		@=查询个人辅导实时信息
		SrcFName =usercx.c
		CmdTypeN =1:1
		#param[in] 命令字入口:
		CmdIStr1 =sid            #学生标识
		CmdIStr2 ="CrViewName"   #辅导界面名称
		CmdIStr3 =crid           #辅导教室标识
		#param[out] 命令字出口:
		CmdOStr1 =count1         #当前题号
		CmdOStr2 =count2         #最大聊天标识
		CmdOStr3 =count3         #当前在线人员的id串
		CmdOStr4 =count4         #...
		CmdOStr5 =count5         #...
		CmdOStr6 =count6         #...
		CmdOStr7 =count7         #...
		CmdOStr8 =count8         #...*/
		 /** ↑↑↑↑↑↑↑↑↑↑↑↑↑教室培训专用↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
		/**★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★*/
		
		
		/**
		 * USERCX
			[QryEmailList]
			@=按条件分页查看邮件列表
			SrcFName =message.c  	#C源码所在文件名
			CmdTypeN =1:N     	  #命令字类型;1:1/N
			#param[in] 命令字入口:
			CmdIStr1 =sid   	  #学生标识
			CmdIStr2 =mark        #标记(U-未读/R-已读/S-发送/1-收藏夹)
			CmdIStr3 =beg         #开始记录号
			CmdIStr4 =num         #返回记录数
			#param[out] 命令字出口:
			CmdOStr1 =mailid      #邮件标识
			CmdOStr2 =uinf        #发送者/接收者信息
			CmdOStr3 =sdtime      #消息发送时间
			CmdOStr4 =srmark      #收发标识(S-发送,R-接受)
			CmdOStr5 =mark        #标记标识(0-无标记,1-收藏夹)
			CmdOStr6 =rdtime      #阅读时间
			CmdOStr7 =subject     #邮件主题
			CmdOStr8 =totalnum    #记录总数
		 */
		public static const QRYEMAILTREE:String = "USERCX.QryEmailList(gdgz)";
		
		/*[QueryTask]
		@=获取任务列表
		SrcFName  =opertask.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid1      	#操作员ID
		CmdIStr2  =tpye      	#查询类型(S为发出任务人,R为接收任务人,空为所有)
		CmdIStr3  =begdate      	#查询开始日期
		CmdIStr4  =enddate      	#查询结束日期
		CmdIStr5  =pagenum      	#第几页(第一页为0)
		CmdIStr6  =operid1      	#每页记录数
		CmdIStr7  =stat      	#任务状态(2确认完成,1已完成,0未完成,-1已删除,-2确认删除,nodel未删除)
		CmdIStr8  =type      	#任务类型(1计分,0不计分,空为全部)
		CmdIStr9  =ebegdate     #完成开始日期(CmdIStr7=2)			======新添加，统计核算
		CmdIStr10 =eenddate     #完成结束日期(CmdIStr7=2)
		#param[out] 命令字出口:
		CmdOStr1  =taskid      	#任务ID
		CmdOStr2  =origid  		#发起人ID
		CmdOStr3  =realname  		#发起人姓名
		CmdOStr4  =origtime  		#发起时间
		CmdOStr5  =content  		#任务内容
		CmdOStr6  =stat  		#任务状态
		CmdOStr7  =rcvid  		#接受人ID
		CmdOStr8  =realname  		#接受人姓名
		CmdOStr9  =rcvtime		#接受时间
		CmdOStr10  =chgtime  		#任务最后修改时间
		CmdOStr11  =tpage  		#总页数
		CmdOStr12  =type  		#1计分，0不计分
		CmdOStr13  =coins  		#任务分数
		#失败
		CmdOStr0  =errno      #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const QUERY_TASK:String = "OPERTASK.QueryTask";
		
		/**
		 * [MarkEmail4Pad]
			@=平板用户标记邮件
			SrcFName  =message.c     	#C源码所在文件名
			CmdTypeN  =1:1          	#命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1  =uid            #用户标识
			CmdIStr2  =mailid         #邮件标识
			CmdIStr3  =mark           #标记邮件(1-收藏夹)
			#param[out] 命令字出口:
			#失败
			CmdOStr0  =errno        	#错误代码
			#"000"=邮件发送成功
			#"MMM"=其他错误
			CmdOStr1  =errMsg       	#失败提示信息
		 */
		public static const MARKEMAIL4PAD:String = "USERYW.MarkEmail4Pad(gdgz)";
		
		/**
		 * [ReadEmail4Pad]
			@=标记平板用户查看邮件并领取附件
			SrcFName  =message.c     	#C源码所在文件名
			CmdTypeN  =1:1          	#命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1  =uid            #用户标识
			CmdIStr2  =mailid         #邮件标识
			#param[out] 命令字出口:
			#失败
			CmdOStr0  =errno        	#错误代码
			#"000"=邮件发送成功
			#"MMM"=其他错误
			CmdOStr1  =errMsg       	#失败提示信息
		 */
		public static const READEMAIL4PAD:String = "USERYW.ReadEmail4Pad(gdgz)";
		
		/**
		 * [SelEmail4Pad]
			@=平板用户查看邮件
			SrcFName  =message.c  #C源码所在文件名
			CmdTypeN  =1:1        #命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1  =mailid     #邮件标识
			CmdIStr2  =uid        #用户标识
			#param[out] 命令字出口:
			CmdOStr1  =mailid 		#邮件标识
			CmdOStr2  =sdid       #发送者标识
			CmdOStr3  =sdname     #发送者姓名
			CmdOStr4  =recinf 		#接受者信息
			CmdOStr5  =amark      #附件处理标记(发送无效)
			CmdOStr6  =rdtime     #阅读时间(发送无效)
			CmdOStr7  =sdtime 		#发送时间
			CmdOStr8  =subject		#邮件主题
			CmdOStr9  =atment		  #邮件附件
			CmdOStr10 =mailtxt		#邮件文本
		 */
		public static const SELEMAIL4PAD:String = "USERYW.SelEmail4Pad(gdgz)";
		
		/**
		 * 【USERYW】
			[SendItnEmail]
			@=发送邮件
			SrcFName  =message.c     	#C源码所在文件名
			CmdTypeN  =1:1          	#命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1  =sedid          #发送者标识
			CmdIStr2  =sedname        #发送者姓名
			CmdIStr3  =recids         #接受者标识串(','分隔,';'结尾的ID串)
			CmdIStr4  =sdtime         #发送时间
			CmdIStr5  =subject        #邮件主题
			CmdIStr6  =atment         #邮件附件
			CmdIStr7  =mailtxt        #邮件文本
			#param[out] 命令字出口:
			#失败
			CmdOStr0  =errno        	#错误代码
			#"000"=邮件发送成功
			#"MMM"=其他错误
			CmdOStr1  =errMsg       	#失败提示信息
		 */
		public static const SENDITNEMAIL:String = "USERYW.SendItnEmail(gdgz)";
		
		/**
		 * [DelEmail4Pad]
			@=平板用户删除邮件
			SrcFName  =message.c     	#C源码所在文件名
			CmdTypeN  =1:1          	#命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1  =uid            #发送者标识
			CmdIStr2  =mailid         #邮件标识
			CmdIStr3  =srmark         #收发标识(S/R)
			#param[out] 命令字出口:
			#失败
			CmdOStr0  =errno        	#错误代码
			#"000"=邮件发送成功
			#"MMM"=其他错误
			CmdOStr1  =errMsg       	#失败提示信息
		 */
		public static const DELEMAIL4PAD:String = "USERYW.DelEmail4Pad(gdgz)";
		
		public static const  INS_UP_MAP:String="USERGYW.InsUpMap(gdgz)";
		
		/**
		 * [BatDelEmail4P]
			@=平板批量删除邮件
			SrcFName  =message.c     	#C源码所在文件名
			CmdTypeN  =1:1          	#命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1  =uid            #用户标识
			CmdIStr2  =mark           #邮件标识(S/R/1)
			#param[out] 命令字出口:
			#失败
			CmdOStr0  =errno        	#错误代码
			#"000"=邮件发送成功
			#"MMM"=其他错误
			CmdOStr1  =errMsg       	#失败提示信息
		 */
		public static const BATDELEMAIL4P:String = "USERYW.BatDelEmail4P(gdgz)";
		
		
		/**
		 * [BatMarkRead4P]
			@=平板用户批量标为已读
			SrcFName  =message.c     	#C源码所在文件名
			CmdTypeN  =1:1          	#命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1  =uid            #用户标识
			#param[out] 命令字出口:
			#失败
			CmdOStr0  =errno        	#错误代码
			#"000"=邮件发送成功
			#"MMM"=其他错误
			CmdOStr1  =errMsg/gold    #失败提示信息/奖励金币
		 */
		public static const BATMARKREAD4P:String = "USERYW.BatMarkRead4P(gdgz)";
		
		
		/*USERGCX
		[QryRunMap]
		@=查询跑跑地图数据
		SrcName  =usergcx.c      #代码所在文件
		CmdTypeN =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =mapid       #地图ID空或0为选择全部)
		#param[out] 命令字出口:
		CmdOStr1  =mapid      #地图ID
		CmdOStr2  =mapdata    #地图数据
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =Msg     	   #提示信息*/
		public static const QRY_RUN_MAP:String = "USERGCX.QryRunMap(gdgz)";
		
		
		public static const QRY_RUN_DATA:String = "USERGCX.QryRunData(gdgz)";
		
		public static const INS_RUN_DATA:String = "USERGYW.InsRunData(gdgz)";
		
		
		/*[SelFreTaskMark]
		@=查询任务是否刷新的标识
		SrcFName =useryw.c      #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =userid        #用户标识
		#param[out] 命令字出口:
		CmdOStr1 =fretask       #任务刷新时间(缺省YYYYMMDD-hhmmss)*/
		public static const SEL_FRE_TASKMARK:String = "USERYW.SelFreTaskMark(gdgz)";
		
		
		/*BOOKCX
		[QueryGramtagData]
		@=查询语法标签
		SrcFName  = yyread.c    #C源码所在文件名
		CmdTypeN  =1:N             #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  = taglist1           #标签1
		CmdIStr2  = taglist5            #标签5   * 0 1
		CmdIStr3  = recnum            #记录条数
		#param[out] 命令字出口:
		CmdOStr1  = instid           #标签ID
		CmdOStr2  = topicval         #题目
		CmdOStr3  = chineseval         #中文
		CmdOStr4  = sourceval            #来源
		CmdOStr5  = taglist1          #标签1                  
		CmdOStr6  = taglist2          #标签2                  
		CmdOStr7  = taglist3          #标签3                  
		CmdOStr8  = taglist4          #标签4                  
		CmdOStr9  = taglist5          #标签5*/
		public static const QUERY_GRAMTAG_DATA:String = "BOOKCX.QueryGramtagData";
		
		
		/*[UpdGramtagData]
		@=更新语法标签状态
		SrcFName  =yyread.c      #C源码所在文件名                              
		CmdTypeN  =1:1          	  #命令字类型;1:1                                
		#param[in] 命令字入口: 
		CmdIStr1  =instid            #标签ID
		CmdIStr2  =taglist5            #标签状态
		#param[out] 命令字出口:                                                    
		#成功                                                                      
		CmdOStr0  ="000"       		  #成功代码                                    
		#失败
		CmdOStr0  ="0MM"        		#错误代码                                      
		CmdOStr1  =errMsg       	  #失败提示信息     */
		public static const UPD_GRAMTAG_DATA:String = "BOOKYW.UpdGramtagData";
		
		/*[UpIMFile]
		@=上载私聊文件          #命令字功能描述;
		SrcFName  =pubfile.c    #C源码所在文件名
		CmdTypeN  =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =sedid        #发送者标识
		CmdIStr2  =sedcode      #发送者姓名
		CmdIStr3  =recid        #接受者标识
		CmdIStr4  =reccode      #接受者姓名
		CmdIStr5  =ftype        #文件类型(voice-声音,pic-图片)
		CmdIStr6  =wfname       #带相对(与WVOICEFROOT=/home/cpyf/userdata/pubic/voice/)路径的文件名；带扩展名
		CmdIStr7  =fsize        #文件总长度，每次都传输；取值与已传文件长度相同，则表示上载结束；
		CmdIStr8  =uplen        #已传文件长度，取值为0表示开始上载文件；
		CmdIStr9  =length       #本次上传内容长度，用于与CmdStr数组中长度进行校验
		CmdIStr10 =txt          #内容长串，最长32KB
		#param[out] 命令字出口:
		CmdOStr1  =fsize        #文件总长度
		CmdOStr2  =uplen        #已传文件长度
		CmdOStr3  =length       #本次成功上传的长度
		CmdOStr4  =wfname       #带绝对路径的文件名；带扩展名
		CmdOStr5  =mesid        #聊天标识*/
		public static const UP_IM_FILE:String = "USERWJ.UpIMFile(gdgz)";
		
		/*USERGCX
		[GetPlayerData]
		@=查询玩家跑跑数据
		SrcName  =usergcx.c      #代码所在文件
		CmdTypeN =1:1          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =playerid       #用户ID
		#param[out] 命令字出口:
		CmdOStr1  =RunCount      #当日跑跑次数
		CmdOStr2  =gvalue    #游戏金币数
		CmdOStr3  =maxlen    #玩家最大跑跑长度
		CmdOStr4  =FreeTimes    #最大免费次数
		CmdOStr5  =Fee    #每次游戏扣除金币数
		CmdOStr6  =rank    #游戏排名
		CmdOStr7  =mapid     #地图ID
		CmdOStr8  =sexrank    #游戏性别排名
		CmdOStr9  =gender    #用户性别
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =Msg     	   #提示信息*/
		public static const GET_PLAYER_DATA:String = "USERGCX.GetPlayerData(gdgz)";
		
		
		
		/*USERGYW
		[StartRun]
		@=开始跑跑游戏
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =playerid        #玩家id
		#param[out] 命令字出口:
		CmdOStr1 =runcount        #当日跑跑次数(包括当次)
		CmdOStr2 =gvalue        #扣减后游戏金币余额
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =Msg     	   #提示信息*/
		public static const START_RUN:String = "USERGYW.StartRun(gdgz)";
		

		/*[GetPlayerRank]
		@=查询跑跑排名
		SrcName  =usergcx.c      #代码所在文件
		CmdTypeN =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =num       #返回最大记录数
		CmdIStr2  =mapid     #地图ID
		CmdIStr3  =gender    #性别(M:男,F:女,空:全部)
		#param[out] 命令字出口:
		CmdOStr1  =userid      #用户ID
		CmdOStr2  =maxlen    #最大长度
		CmdOStr3  =realname    #玩家姓名
		CmdOStr4  =mapid     #地图ID
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =Msg     	   #提示信息*/
		public static const GET_PLAYER_RANK:String = "USERGCX.GetPlayerRank(gdgz)";

		
		/**
		 * USERCX
			[QryWrongWord]
			@=查询用户错词
			SrcFName =wrongtitle.c  #C源码所在文件名
			CmdTypeN =1:N           #命令字类型;1:1/N
			#param[in] 命令字入口:
			CmdIStr1 =userid        #用户标识
			CmdIStr2 =beg      		#开始记录
			CmdIStr3 =num           #返回记录数
			CmdIStr4 =readmark      #错词复习状态(空:全部,'Y':开启,'N'关闭)
			#param[out] 命令字出口:
			CmdOStr1 =wordid        #单词ID
			CmdOStr2 =wordstr       #单词
			CmdOStr3 =readmark      #错词复习状态('Y':开启,'N'关闭)
			CmdOStr4 =soundmark     #音标
			CmdOStr5 =meanbasic     #基本含义
			CmdOStr6 =meanadd       #附加含义
			CmdOStr7 =soundfn      #发音文件标识字母
			CmdOStr8 =starttime    #发音起始毫秒数
			CmdOStr9 =durtime      #发音结束毫秒数
			CmdOStr10 =learncnt    #已学习数量
			CmdOStr11 =wrongcnt    #学习错误数量
		 */
		public static const QRYWRONGWORD:String = "USERCX.QryWrongWord(gdgz)";
		
		/**
		 * [ChgWrongWordMark]
			@=修改错词复习标记
			SrcFName =wrongtitle.c  #C源码所在文件名
			CmdTypeN =1:1           #命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1 =userid        #用户标识
			CmdIStr2 =topicid       #单词ID
			#param[out] 命令字出口:
			CmdOStr0 =errno         #错误代码
			#"000"=成功
			#"MMM"=其他错误
			CmdOStr1 =readmark      #修改后标记('Y'打开,'N'隐藏);
		 */
		public static const CHGWRONGWORDMARK:String = "USERYW.ChgWrongWordMark(gdgz)";
		
		/**
		 * USERCX
			[SearchWrongWord]
			@=搜索用户已记忆错词
			SrcFName =wrongtitle.c  #C源码所在文件名
			CmdTypeN =1:N           #命令字类型;1:1/N
			#param[in] 命令字入口:
			CmdIStr1 =userid        #用户标识
			CmdIStr2 =wordstr  		#错词字符串(可模糊查找)
			#param[out] 命令字出口:
			CmdOStr1 =wordid        #单词ID
			CmdOStr2 =wordstr       #单词
		 */
		public static const SEARCHWRONGWORD:String = "USERCX.SearchWrongWord(gdgz)";

		
		
		/*[QueryOper]
		@=获取操作员列表
		SrcFName  =opertask.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid      	#操作员ID(为空则选择全部)
		#param[out] 命令字出口:
		CmdOStr1  =operid      	#操作员ID
		CmdOStr2  =realname  		#操作员姓名
		CmdOStr3  =operstat  		#操作员状态
		CmdOStr4  =finish  		#完成任务数
		CmdOStr5  =running  		#正在进行任务数
		CmdOStr6  =unfinish  		#未开始任务数
		CmdOStr7  =tasklist  		#任务列表
		#失败
		CmdOStr0  =errno      #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const QUERY_OPER:String = "OPERTASK.QueryOper";
		
		/*[GetOperTask]
		@=获取操作员任务序列
		SrcFName  =opertask.c   #C源码所在文件名
		CmdTypeN  =1:N        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid1      	#操作员ID
		#param[out] 命令字出口:
		CmdOStr1  =taskid      	#任务ID
		CmdOStr2  =origid  		#发起人ID
		CmdOStr3  =realname  		#发起人姓名
		CmdOStr4  =origtime  		#发起时间
		CmdOStr5  =content  		#任务内容
		CmdOStr6  =stat  		#任务状态
		CmdOStr7  =rcvid  		#接受人ID
		CmdOStr8  =realname  		#接受人姓名
		CmdOStr9  =rcvtime		#接受时间
		CmdOStr10  =chgtime  		#任务最后修改时间
		CmdOStr11  =type  		#1计分，0不计分
		CmdOStr12  =coins  		#任务分数
		#失败
		CmdOStr0  =errno      #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const GET_OPER_TASK:String = "OPERTASK.GetOperTask";
		
		/*[UpPri]
		@=修改任务优先级
		SrcFName  =opertask.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid      	#操作员ID
		CmdIStr2  =tasklist  		#任务序列
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const UP_PRI:String = "OPERTASK.UpPri";
		
		/*[InsTask]
		@=新增任务
		SrcFName  =opertask.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =origid  		#发起人ID
		CmdIStr2  =content  		#任务内容
		CmdIStr3  =rcvid  		#接收人ID
		CmdIStr4  =type  		#1计分，0不计分
		CmdIStr5  =coins  		#任务分数
		#param[out] 命令字出口:
		CmdOStr1  =taskid  		#新增任务ID
		CmdOStr2  =origid  		#发起人ID
		CmdOStr3  =realname  		#发起人姓名
		CmdOStr4  =origtime  		#发起时间
		CmdOStr5  =content  		#任务内容
		CmdOStr6  =stat  		#任务状态
		CmdOStr7  =rcvid  		#接受人ID
		CmdOStr8  =realname  		#接受人姓名
		CmdOStr9  =rcvtime		#接受时间
		CmdOStr10  =type  		#1计分，0不计分
		CmdOStr11  =coins  		#任务分数
		#失败
		CmdOStr0  =errno      #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const INS_TASK:String = "OPERTASK.InsTask";
		
		
		
		
		/*[UpTask]
		@=修改任务
		SrcFName  =opertask.c   #C源码所在文件名
		CmdTypeN  =1:1        #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =taskid      	#任务ID
		CmdIStr2  =operid  		#修改人ID
		CmdIStr3  =content  		#任务内容
		CmdIStr4  =stat  		#任务状态(2确认完成,1已完成,0未完成,-1已删除,-2确认删除)
		CmdIStr5  =rcvid  		#接收人ID
		CmdIStr6  =type  		#1计分，0不计分
		CmdIStr7  =coins  		#任务分数
		CmdIStr8  ==chgtime  		#任务最后修改时间
		CmdIStr9  =origtime  		#任务发起时间
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno      #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =errMsg     #失败提示信息*/
		public static const UP_TASK:String = "OPERTASK.UpTask";
		
		
		
		
		/*[QryEqConfig]
		@=查询装备设置
		SrcFName =usercx.c  #C源码所在文件名
		CmdTypeN =1:N           #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =mcode         #设置标识(空为全部)
		#param[out] 命令字出口:
		CmdOStr1 =mcode        	#设置标识(空为全部)
		CmdOStr2 =mname         #设置说明
		CmdOStr3 =param1        #参数1
		CmdOStr4 =param2        #参数2
		CmdOStr5 =param3        #取值*/
		public static const QRY_EQ_CONFIG:String = "USERCX.QryEqConfig(gdgz)";
		
		
		/*USERGYW
		[SellEquipment]
		@=用户卖出装备
		SrcFName =markatr.c     #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =userid        #用户标识
		CmdIStr2 =eqid          #装备ID
		#param[out] 命令字出口:
		CmdOStr0 =errno         #错误代码
		#"000"=成功
		#"MMM"=其他错误
		CmdOStr1 =eqid          #装备ID
		CmdOStr2 =price         #返回游戏币数
		CmdOStr3 =gprice        #返回学习金币数*/
		public static const SELL_EQUIPMENT:String = "USERGYW.SellEquipment(gdgz)";
		
		/*{USERCX}
		[QryWorldMessAfId]
		@=显示CmdIStr[1]之后的所有广播
		SrcFName  =message.c    #C源码所在文件名
		CmdTypeN  =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =wmesid       #起始标识,（0为默认最新50条）
		#param[out] 命令字出口:
		CmdOStr1  =wmesid       #消息标识
		CmdOStr2  =sedid        #发送者标识
		CmdOStr3  =sedcode      #发送者姓名
		CmdOStr4  =sedtime      #发送时间
		CmdOStr5  =mess         #发送内容*/
		public static const QRY_WORLD_MESS_AFID_NEW:String = "USERCX.QryWorldMessAfIdNew(gdgz)";
		
		
		/*USERYW
		[ReturnLogin]
		@=返回登陆界面标记
		SrcFName =useryw.c  #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =interface     #界面
		#param[out] 命令字出口:
		CmdOStr0 =errno         #错误代码
		#"000"=成功*/
		public static const RETURN_LOGIN:String = "USERYW.ReturnLogin(gdgz)"; 

		/*
		手动杀程序死机的
		USERRW.UserKill(gdgz)
		uid
		macid
		deadTime*/
		public static const USER_KILL:String = 'USERRW.UserKill(gdgz)';

		
		
		/*USERYW
		[SetTimeLimit]
		@=设置用户时间限制
		SrcFName =useryw.c  #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =userid      #用户ID
		CmdIStr2 =begtime     #平日开始时间
		CmdIStr3 =endtime     #平日结束时间
		CmdIStr4 =restbeg     #假日开始时间
		CmdIStr5 =restend     #假日结束时间
		#param[out] 命令字出口:
		CmdOStr0 =errno         #错误代码
		#"000"=成功
		#"MMM"=失败
		CmdOStr1 =msg         #错误信息*/
		public static const SET_TIME_LIMIT:String = "USERYW.SetTimeLimit(gdgz)";
		
		
		
		/*USERCX
		[GetTimeLimit]
		@=取用户当日时间限制
		SrcFName =heartbeat.c  #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =userid        #用户标识
		#param[out] 命令字出口:
		CmdOStr1 =begtime        #开始时间
		CmdOStr2 =endtime        #结束时间*/
		public static const GET_TIME_LIMIT:String = "USERCX.GetTimeLimit(gdgz)";
		
		
		
		
		/*[GetTLimitSet]
		@=取用户时间限制设置
		SrcFName =heartbeat.c  #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1 =userid        #用户标识
		#param[out] 命令字出口:
		CmdOStr1 =begtime        #平日开始时间
		CmdOStr2 =endtime        #平日结束时间
		CmdOStr3 =restbeg        #假日开始时间
		CmdOStr4 =restend        #假日结束时间*/
		public static const GET_TLIMIT_SET:String = "USERCX.GetTLimitSet(gdgz)";
		
		
		/*USERCX
		[QryTLimitList]
		@=查询用户时间限制设置列表
		SrcFName =heartbeat.c  #C源码所在文件名
		CmdTypeN =1:N           #命令字类型;1:1/N
		#param[in] 命令字入口:
		#param[out] 命令字出口:
		CmdOStr1 =userid         #用户标识
		CmdOStr2 =begtime        #平日开始时间
		CmdOStr3 =endtime        #平日结束时间
		CmdOStr4 =restbeg        #假日开始时间
		CmdOStr5 =restend        #假日结束时间*/
		public static const QRY_TLIMIT_LIST:String = "USERCX.QryTLimitList(gdgz)";

		
		/*USERYW
		[DelTimeLimit]
		@=删除用户时间限制
		SrcFName =useryw.c  #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =userid      #用户ID
		#param[out] 命令字出口:
		CmdOStr0 =errno         #错误代码
		#"000"=成功
		#"MMM"=失败
		CmdOStr1 =msg         #错误信息*/
		public static const DEL_TIME_LIMIT:String = "USERYW.DelTimeLimit(gdgz)";
		
		
		/*USERGYW
		[StartDraw]
		@=开始画图游戏
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =operid        #玩家id
		#param[out] 命令字出口:
		CmdOStr1 =runcount        #当日画图次数(包括当次)
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =Msg     	   #提示信息*/
		public static const START_DRAW:String= "USERGYW.StartDraw(gdgz)";
		/*USERCX
		[GetStdFnLvl]
		@=取用户连续完成等级
		SrcFName =usercx.c      #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     	#用户标识
		#param[out] 命令字出口:
		CmdOStr1  =fnlvl        #用户连续完成等级*/
		public static const GET_STD_FNLVL:String = "USERCX.GetStdFnLvl(gdgz)";

		/*USERGYW
		[InsDrawData]
		@=提交画图游戏数据
		SrcFName  =usergyw.c   #C源码所在文件名
		CmdTypeN  =1:1         #命令字类型;1:1
		#param[in] 命令字入口:
		CmdIStr1 =playerid     #玩家id
		CmdIStr2 =relaname     #用户姓名
		CmdIStr3 =picid        #图画id
		CmdIStr4 =picdata      #图画数据
		#param[out] 命令字出口:
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =Msg     	   #提示信息*/
		public static const INS_DRAW_DATA:String = "USERGYW.InsDrawData(gdgz)";
		
		/*USERYW 提交朗读任务
		[SubmitTaskYYDaily]
		@=提交任务结果
		#param[in] 命令字入口:
		CmdIStr1  =userid     	#用户标识
		CmdIStr2  = rrl			#rrl串
		CmdIStr3  = rrl	id		#rrl串录入id
		CmdIStr4 = costTime		#时长
		CmdIStr5 = rate			#准确率
		CmdIStr6 = right		#答对数
		CmdIStr7 = wrong		#答错数
		CmdIStr8 = total		#总数
		CmdIStr9 = startTime	#操作开始时间(YYYYMMDD-hhmmss)
		CmdIStr10= enTime		#操作结束时间
		CmdIStr11= detail		#详细信息 IDS`1`R/E`输入/答案*/
		public static const SUBMIT_YYDaily:String = "USERRW.SubmitTaskYYDaily(gdgz)";
		public static const ANDON_YYDaily:String = "USERRW.AbandonTaskYYDaily(gdgz)";
		
		
		/*USERGCX
		[QryDrawData]
		@=查询玩家画图数据
		SrcName  =usergcx.c      #代码所在文件
		CmdTypeN =1:N          #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =recid       #记录ID(为空查全部)
		#param[out] 命令字出口:
		CmdOStr1  =operid      #玩家ID
		CmdOStr2  =realname    #玩家姓名
		CmdOStr3  =gametime    #游戏时间
		CmdOStr4  =picid       #原图ID
		CmdOStr5  =picdata     #游戏数据
		#失败
		CmdOStr0  =errno       #错误代码
		#"000"=成功
		#"0MM"=其他错误
		CmdOStr1  =Msg     	   #提示信息*/
		public static const QRY_DRAW_DATA:String = "USERGCX.QryDrawData(gdgz)";

		
		
		
		
		
		/*BOOKCX
		[GetReadingTask]
		@=取朗读任务(随机抽取5题)
		SrcFName  =reading.c       	#C源码所在文件名
		CmdTypeN  =1:N          	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =operid          	#用户ID
		CmdIStr2  =tid         		#朗读任务编号
		#param[out] 命令字出口:
		CmdOStr1  =orderid     		#行号
		CmdOStr2  =en     	  		#英文
		CmdOStr3  =cn   	  		#中文
		CmdOStr4  =stime   	  		#开始时间
		CmdOStr5  =etime   	  		#结束时间
		CmdOStr6  =fsize			#文件大小*/
		public static const GETREADING_TASK:String = 'BOOKCX.GetReadingTask(gdgz)';
		
			
		/**
		 * 
		 	USERCX
			[GetStdFnLvl]
			@=取用户连续完成等级
			SrcFName =usercx.c      #C源码所在文件名
			CmdTypeN =1:1           #命令字类型;1:1/N
			#param[in] 命令字入口:
			CmdIStr1  =userid     	#用户标识
			#param[out] 命令字出口:
			CmdOStr1  =fnlvl        #用户连续完成等级
			CmdOStr2  =confndays    #用户已连续完成天数
		 */
		public static const GETSTDFNLVL:String = "USERCX.GetStdFnLvl(gdgz)";
		
		

		/*USERWJ
		[SelectFileList]
		@=录入人员查看文件列表
		SrcFName  = userwj.c     	#C源码所在文件名
		CmdTypeN  =1:N          	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  = wbid          #用户文件标识  *参与查询所有
		CmdIStr2  = wstatues      #用户文件状态  *参与查询所有
		CmdIStr3  = upoperid			#上载工号标识  *参与查询所有
		CmdIStr4  = Blocalftime 	#上载文件起始日期 取值00000000表示不参与条件
		CmdIStr5  = Elocalftime	#上载文件结束日期 取值YYYYMMDD表示不参与条件
		#param[out] 命令字出口:
		CmdOStr1  = wbid					#用户文件状态
		CmdOStr2  = wfname				#用户文件名
		CmdOStr3  = wstatus				#文件状态
		CmdOStr4  = localftime		#文件上传时间
		CmdOStr5  = localfsize		#文件大小
		CmdOStr6  = upoperid			#上载工号*/
		public static const SELECT_FILE_LIST:String = 'USERWJ.SelectFileList(gdgz)';


		/**
		 * BOOKCX
		 * [QryWallpaper]
		@=查询壁纸列表
		SrcFName  =wpaper.c       	#C源码所在文件名
		CmdTypeN  =1:N          	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =status          	#*或空为全部，Y上架，N下架
		CmdIStr2  =wBeg          	#分页开始
		CmdIStr3  =wEnd          	#每页记录数
		#param[out] 命令字出口:
		CmdOStr1  =id     			#壁纸ID
		CmdOStr2  =price   	  		#价格
		CmdOStr3  =orderid   	  	#顺序编号
		CmdOStr4  =file     	  	#壁纸(/home/cpyf/BOOK/wallpaper/)相对路径
		CmdOStr5  =time   	  		#上传时间
		CmdOStr6  =total   	  		#总记录数
		 */
		public static const QRYWALLPAPER:String = "BOOKCX.QryWallpaper";
		
		/**
		 * USERYW
			[BuyWallpaper]
			@=购买壁纸
			SrcFName =markatr.c  #C源码所在文件名
			CmdTypeN =1:1           #命令字类型;1:1
			#param[in] 命令字入口:
			CmdIStr1 =userid      #用户ID
			CmdIStr2 =id      	  #壁纸ID
			#param[out] 命令字出口:
			CmdOStr0 =errno         #错误代码
			#"000"=成功
			#"MMM"=失败
			CmdOStr1 =msg         #错误信息
		 */
		public static const BUYWALLPAPER:String = "USERYW.BuyWallpaper(gdgz)";
		
		/*BOOKCX
		[QryChrPic]
		@=查询壁纸列表
		SrcFName  =binfile.c       	#C源码所在文件名
		CmdTypeN  =1:N          	#命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =type          	#UPLOAD为用户上传，SHOW为已审核，RANDOM为随机取一张
		#param[out] 命令字出口:
		CmdOStr1  =filename     	#文件名(UPLOAD对应目录/home/cpyf/userdata/chrpic/upload/，SHOW对应目录/home/cpyf/userdata/chrpic/show/)
		CmdOStr2  =filesize     	#文件长度
		*/
		public static const CHECK_CHRPIC:String = "BOOKCX.QryChrPic";
		
		public static const SELECTYYREAD:String = "BOOKYW.SelectYYRead(gdgz)";
		
		
		/*USERCX
		[GetCustDataExt]
		@=查询用户生日、性别、手机号、第二手机号
		SrcFName =usercx.c      #C源码所在文件名
		CmdTypeN =1:1           #命令字类型;1:1/N
		#param[in] 命令字入口:
		CmdIStr1  =userid     	#用户标识
		#param[out] 命令字出口:
		CmdIStr1  =birthday     #生日
		CmdOStr2  =gender       #性别
		CmdOStr3  =smstelno     #手机号码
		CmdOStr4  =secsmsno    	#第二手机号码
		CmdOStr5  =school    	#学校*/
		public static const GET_CUST_DATA_EXT:String = "USERCX.GetCustDataExt(gdgz)";
	}
}