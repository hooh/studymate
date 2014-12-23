package com.studyMate.db.schema
{
	import com.mylib.framework.utils.DBTool;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public final class GameInfo
	{
		[Id]
		public var id:int;
		
		public var apkName:String;

		public var appName:String;
		
		public var packageName:String;
		
		public var imgPath:String;
	}
}