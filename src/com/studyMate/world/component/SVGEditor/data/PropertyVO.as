package com.studyMate.world.component.SVGEditor.data
{
	public class PropertyVO
	{
		public var attribute:String;
		public var value:Object;
		public var type:int;//0为直接属性，非0为setAttribute属性
		
		public function PropertyVO(attribute:String,value:Object,type:int=0)
		{
			this.attribute = attribute;
			this.value = value;
			this.type = type;
		}
	}
}