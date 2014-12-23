package com.studyMate.db.schema
{
	[Bindable]
	public final class ViewDataRequest
	{
		[Id]
		public var id:int;
		
		public var cmd:String;
		
		public var parameters:String;
		
		public var cacheId:String;
		
		public var type:String;
		
		public var autoUpdate:Boolean;
		
		public var needOperId:Boolean;
		
		public var initClass:String;
		
		/**
		 *byte or UTF cn-gb
		 */		
		public var encode:String;
		
		
	}
}