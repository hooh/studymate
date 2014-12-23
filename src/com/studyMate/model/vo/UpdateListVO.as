package com.studyMate.model.vo
{
	public final class UpdateListVO
	{
		
		/**
		 *更新的类型 u:更新 f:全部强制更新 p:部分强制更新
		 */		
		public var updateType:String;
		/**
		 *素材文件类型： SWF0=SWF素材；DEXE=Delphi；BOOK=书籍； 
		 */		
		public var fileType:String;
		public var completeNotice:String;
		public var completeNoticeParameters:Array;
		
		public var list:Vector.<UpdateListItemVO>;
		
		public function UpdateListVO(completeNotice:String="",completeNoticeParameters:Array=null,updateType:String="u",fileType:String="SWF0")
		{
			
			this.completeNotice = completeNotice;
			this.completeNoticeParameters = completeNoticeParameters;
			this.updateType = updateType;
			this.fileType = fileType;
			list = new Vector.<UpdateListItemVO>;
		}
		
		public function clone():UpdateListVO{
			var vo:UpdateListVO = new UpdateListVO(completeNotice,completeNoticeParameters,updateType,fileType);
			return vo;
		}
		
		
	}
}