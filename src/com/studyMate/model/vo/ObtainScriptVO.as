package com.studyMate.model.vo
{
	public final class ObtainScriptVO implements IStrResultVO
	{
		
		public var length:int;
		private var _str:String;
		
		
		/*CmdOStr1  =operid,operno#操作员标识,获取类型编码
			CmdOStr2  =length       #脚本内容长度
		CmdOStr3  =script       #脚本，超长串*/
		public function ObtainScriptVO(vec:Array)
		{
			length = vec[2];
			str = vec[3];
		}

		public function get str():String
		{
			return _str;
		}

		public function set str(value:String):void
		{
			_str = value;
		}

	}
}