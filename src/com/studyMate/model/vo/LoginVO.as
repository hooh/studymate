package com.studyMate.model.vo
{
	import flash.utils.ByteArray;

	public final class LoginVO
	{
		public var type:String;
		public var completeNotice:String;
		public var userName:String;
		public var password:String;
		
		public var resendCache:Boolean;
		public var mac:String;
		
		/**
		 *更新的类型 : u:更新 ; f:全部强制更新;  p:部分强制更新;  n:不更新; a:自动更新;
		 */		
		public var updateType:String;
		
		public function LoginVO(_userName:String="",_password:String="",_completeNotice:String="",_type:String="",updateType:String="n",_resendCache:Boolean = false)
		{
			this.type = _type;
			this.completeNotice = _completeNotice;
			this.userName = _userName;
			this.password = _password;
			this.updateType = updateType;
			resendCache = _resendCache;
		}
	}
}