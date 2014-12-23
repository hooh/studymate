package com.studyMate.db.schema
{
	import com.studyMate.global.Global;

	public final class Player
	{
		public var id:int;
		public var name:String;
		public var operId:String;
		public var userName:String;
		
		public var type:String;
		
		public var password:String;
		
		public var region:String;
		public var tokennext:String;
		public var logincnt:String;
		public var cntsocket:String;
		public var gameTime:int;
		
		
		public var character:Array;
		
		public var books:Array;
		
		public var lastLoginTime:String;
		
		public var realName:String;
		
		public var savePassword:String = "false"
		
	}
}