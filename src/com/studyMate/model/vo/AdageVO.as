package com.studyMate.model.vo
{
	public final class AdageVO
	{
		public var fromWhere:String;
		public var language:String;
		public var soundInfo:String;
		public var content:String;
		
		//第一个是验证符号CmdOStr0=000
		/*CmdOStr1=出处   #出自哪里，名人的名字或者名著
		CmdOStr2=C/E      #中文/英文
		CmdOStr3=语音信息  #若无语音信息，取值空格
		CmdOStr4=谚语内容  #超长串
		*/
		public function AdageVO(vec:Array)
		{
			fromWhere = vec[1];
			language = vec[2];
			soundInfo = vec[3];
			content = vec[4];
			
		}
	}
}