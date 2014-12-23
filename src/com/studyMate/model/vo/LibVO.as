package com.studyMate.model.vo
{
	import com.studyMate.model.AssetsDomain;

	/**
	 *swf库文件类 
	 * @author HooH
	 * 
	 */	
	public final class LibVO implements IFileVO
	{
		private var _path:String;
		/**
		 *脚本在后台对应的命令字参数 
		 */	
		public var cmd:String;
		/**
		 *脚本的类名 
		 */		
		public var scriptClass:String;
		
		
		/**
		 * 
		 * @param path 库的文件路径
		 * @param cmd 脚本在后台对应的命令字参数 
		 * @param scriptClass 脚本的类名 
		 * 
		 */		
		public function LibVO(path:String,cmd:String=null,scriptClass:String=null)
		{
			this.path = path;
			this.cmd = cmd;
			this.scriptClass = scriptClass;
		}

		public function get path():String
		{
			return _path;
		}

		public function set path(value:String):void
		{
			_path = value;
		}
		
		public function get type():String{
			return "swf";
		}
		
		public function get version():String{
			return "0";
		}
		
		public function get domain():String{
			return AssetsDomain.CHILD;
		}

	}
}