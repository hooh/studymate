package com.studyMate.model.vo
{
	public final class DataRequestVO
	{
		public var cmd:String;
		public var para:Array
		public var cacheId:String;
		/**
		 *"1" 或"N"
		 */		
		public var type:String;
		public var initClass:Class;
		public var autoUpdate:Boolean;
		public var operId:Boolean;
		
		
		/**
		 * 
		 * @param cmd
		 * @param para
		 * @param cacheId
		 * @param initClass
		 * @param type "1" 或"N"
		 * 
		 */		
		public function DataRequestVO(cmd:String,para:Array,cacheId:String,initClass:Class,type:String="1",autoUpdate:Boolean=false,operId:Boolean=true)
		{
			this.cmd = cmd;
			this.para = para;
			this.cacheId = cacheId;
			this.initClass = initClass;
			this.type=type;
			this.autoUpdate = autoUpdate;
			this.operId = operId;
		}
	}
}