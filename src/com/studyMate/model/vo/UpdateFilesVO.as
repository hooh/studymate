package com.studyMate.model.vo
{
	public class UpdateFilesVO
	{
		
		public var files:Vector.<UpdateListItemVO>;
		public var completeNotice:String;
		public var completeNoticeParameters:Object;
		public var cancelable:Boolean;
		public var doChecking:Boolean;
		
		
		public function UpdateFilesVO(files:Vector.<UpdateListItemVO>,completeNotice:String=null,completeNoticeParameters:Object=null,cancelable:Boolean=false,doChecking:Boolean=false)
		{
			this.files = files;
			this.completeNotice = completeNotice;
			this.completeNoticeParameters = completeNoticeParameters;
			this.cancelable = cancelable;
			this.doChecking = doChecking;
		}
	}
}