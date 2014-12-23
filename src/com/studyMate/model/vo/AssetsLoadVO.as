package com.studyMate.model.vo
{
	public final class AssetsLoadVO
	{
		
		public var assets:Array;
		
		/**
		 *加载成功后的消息通知 
		 */		
		public var completeNotice:String;
		/**
		 *通知的参数 
		 */		
		public var completeNoticePara:Object;
		
		
		
		public function AssetsLoadVO(assets:Array,completeNotice:String,completeNoticePara:Object=null)
		{
			this.assets = assets;
			
			this.completeNotice = completeNotice;
			
			this.completeNoticePara = completeNoticePara;
			
		}
	}
}