package com.studyMate.db.schema
{

	[Bindable]
	public final class ViewConfig
	{
		[Id]
		public var id:int;
		
		public var viewId:String;
		
		[ManyToMany(type="com.studyMate.db.schema.AssetsLib")]
		public var assets:Array;
		
		[ManyToMany(type="com.studyMate.db.schema.ViewDataRequest")]
		public var data:Array;
		
	}
}