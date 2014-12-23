package com.studyMate.world.model.vo
{
	[Bindable]
	public class DressSeriesVO
	{
		
		//name,唯一标识
		public var name:String;
		public var items:Vector.<DressSeriesItemVO>;
		
		public var topLevel:int = 0;
		
		
		public function DressSeriesVO()
		{
			items = new Vector.<DressSeriesItemVO>;
		}
		
		

		
	}
}