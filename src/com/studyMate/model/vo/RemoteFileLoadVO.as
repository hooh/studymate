package com.studyMate.model.vo
{
	public final class RemoteFileLoadVO
	{
		public static const DOWN_TYPE_PER:String = "PersonalFile";
		public static const DEFAULT:String = "Default";
		public static const USER_FILE:String = "UserFile";
		public static const DOWN_CHRISTMAS:String = "DownChristmas";//圣诞脸谱广告
		public var remotePath:String;
		public var localPath:String;
		public var completeNotice:String;
		public var completeNoticeParameters:Object;
		public var position:Number;
		public var isModified:Boolean;
		public var isEnd:Boolean;
		public var updateVO:IFileVO;
		public var downType:String;
		public var sign:Boolean = true;
		
		public function RemoteFileLoadVO(remotePath:String="", localPath:String="", completeNotice:String="", completeNoticeParameters:Object=null, 
										 updateVO:IFileVO=null, position:Number=0)
		{
			this.remotePath = remotePath;
			this.localPath = localPath;
			this.completeNotice = completeNotice;
			this.completeNoticeParameters = completeNoticeParameters;
			this.position = position;
			this.updateVO = updateVO;
			this.downType = DEFAULT;
		}
	}
}