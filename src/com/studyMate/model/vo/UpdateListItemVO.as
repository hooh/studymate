package com.studyMate.model.vo
{
	import com.studyMate.utils.MyUtils;

	public final class UpdateListItemVO implements IFileVO
	{
		public var wbid:String;
		public var wfname:String;
		public var wbfkind:String;
		public var _version:String;
		
		/**
		 *false 下载这个文件;true 本地不存在时下载 
		 */		
		public var hasLoaded:Boolean;
		private var _type:String;
		public var inneed:Boolean;
		public var size:Number;
		
		public var isUpdate:Boolean;
		public var crc:String;
		
		public function UpdateListItemVO(wbid:String="",wfname:String="",wbfkind:String="",version:String="",inneed:Boolean=false)
		{
			this.wbid = wbid;
			this.wfname = wfname;
			this.wbfkind= wbfkind;
			this._version= version;
			this.inneed = inneed;
		}
		
		public function get path():String
		{
			return this.wfname;
		}

		public function get type():String
		{
			return MyUtils.getFilePathSuffix(wfname);
		}
		
		public function get version():String{
			return this._version;
		}
		
		public function get domain():String{
			return "";
		}

		
	}
}