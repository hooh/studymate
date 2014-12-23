package com.studyMate.world.model.vo
{
	[Bindable]
	public class DressSuitsVO
	{
		
		//name,唯一标识
		public var name:String;
		public var suitType:String;
		public var sex:String;
		public var level:String;
		
		public var equipments:Vector.<DressEquipmentVO>;
		
		//商城用
		public var equipId:String = "";
		/**
		 *游戏币 
		 */		
		public var price:int = 0;	//学习金币
		public var property:String;	//装备属性
		public var hasBuy:Boolean;	//是否已经购买
		public var isShow:Boolean;	//是否显示在货架
		
		/**
		 *学习金币 
		 */		
		public var goldprice:String;	//游戏金币
		public var othername:String;
		public var moperid:String;
		public var desc:String;
		
		
		/**
		 * 标识是否新上架 
		 */		
		public var isNew:Boolean = false;
		
		public function DressSuitsVO()
		{
			equipments = new Vector.<DressEquipmentVO>;
		}
		
		

		
	}
}