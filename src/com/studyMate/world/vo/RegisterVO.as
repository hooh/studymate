package com.studyMate.world.vo
{
	public class RegisterVO
	{
		public var operid:int;
		public var loginName:String;
		public var password:String;
		public var realName:String;
		public var nickName:String;
		public var telephone:String;
		public var birthday:String;
		public var sex:int; // 1-男  0-女
		public var entranceDelta:int;
		
		public function RegisterVO(_operid:int, _loginName:String, _password:String,
								_realName:String, _nickName:String, _telephone:String, 
								_birthday:String, _sex:int, _entranceDelta:int){
			operid = _operid;
			loginName = _loginName;
			password = _password;
			realName = _realName;
			nickName = _nickName;
			telephone = _telephone;
			birthday = _birthday;
			sex = _sex;
			entranceDelta = _entranceDelta;
		}
	}
}