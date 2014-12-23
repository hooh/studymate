package com.studyMate.world.model.vo
{
	public class DressEquipmentVO
	{
		public var x:int;
		public var y:int;
		public var order:int;
		public var data:String;
		public var type:String;
		public var bone:String;
		public var name:String;
		public var color:Number;
		public var equipmentType:String;
		
		public var goldprice:String;
		public var othername:String;
		
		public var items:Vector.<EquipmentItemVO>;
		
		public static var STATIC:String = "s";
		public static var DYNAMIC:String = "d";
		public static var PACK:String = "p";
		
		
		public function DressEquipmentVO()
		{
			items = new Vector.<EquipmentItemVO>;
		}
	}
}