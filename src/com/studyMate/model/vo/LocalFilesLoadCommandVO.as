package com.studyMate.model.vo
{
	public final class LocalFilesLoadCommandVO
	{
		public var files:Vector.<UpdateListItemVO>;
		public var completeNotice:String;
		public var completeNoticeParameters:Object;
		
		public function LocalFilesLoadCommandVO(files:Vector.<UpdateListItemVO>,completeNotice:String=null,completeNoticeParameters:Object=null)
		{
			this.files = files;
			this.completeNotice = completeNotice;
			this.completeNoticeParameters = completeNoticeParameters;
		}
	}
}