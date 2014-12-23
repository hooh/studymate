package com.studyMate.model.vo
{

	public class ReadTextVO
	{
		public var completeNotification:String;
		public var completeNotificationParameters:Object;
		public var text:String;
		public var pitch:Number;
		public var speechRate:Number;
		/**
		 * 
		 * @param text 要读的文本
		 * @param pitch 音调
		 * @param speechRate 读音速度
		 * @param completeNotification 完成通知
		 * @param completeNotificationParameters
		 * 
		 */		
		public function ReadTextVO(text:String,pitch:Number=1,speechRate:Number=1,completeNotification:String=null,completeNotificationParameters:Object=null)
		{
			this.text = text;
			this.pitch = pitch;
			this.speechRate = speechRate;
			this.completeNotification = completeNotification;
			this.completeNotificationParameters = completeNotificationParameters;
		}
	}
}