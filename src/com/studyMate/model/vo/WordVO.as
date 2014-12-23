package com.studyMate.model.vo
{
	
	import flash.filesystem.File;

	public final class WordVO
	{
		public var book:String;
		public var knowid:String;
		public var rrl:String;
		public var grpcode:String;//LE005、LEAO1等
		public var wordid:uint;
		public var wordstr:String;
		public var soundmark:String;
		public var meanbasic:String;
		public var mmethod:String;
		public var starttime:uint;
		public var durtime:uint;
		public var fileLetter:String;
		public var mean:String;
		
		//第一个是验证符号000
/*     CmdOStr1  =book         #课目
		CmdOStr2  =knowid       #知识点标识
		CmdOStr3  =grpcode      #分组代码
		CmdOStr4  =wordid       #单词标识
		CmdOStr5  =wordstr      #单词串
		CmdOStr6  =soundmark    #音标
		CmdOStr7  =meanbasic    #中文含义
		CmdOStr8  =mmethod      #记忆法
		CmdOStr9  =soundfn      #发音文件标识字母
		CmdOStr10 =starttime    #发音起始毫秒数
		CmdOStr11 =durtime      #发音持续毫秒数
		CmdOStr12 =mean         #匹配汉语含义
*/
		
		
		public function WordVO(source:Array)
		{
			// for test
//			word = source[1];
//			spell = source[3];
//			mean = source[4];
			//
			
			
//			book = source[1];
//			knowid = source[2];
			rrl = source[1];
			grpcode = source[2];
			wordid = uint(source[3]);
			wordstr = source[4];
			soundmark = source[5];
			meanbasic = source[6];
			mmethod = source[7];
			fileLetter = source[8];
			starttime = uint(source[9]);
			durtime = uint(source[10]);
			mean = source[11].replace(/\./g,"");
			mean = mean.replace(/…/g,"");
			mean = mean.replace(/\s/g,"");;
//			trace(mean);
			
		}

	}
}