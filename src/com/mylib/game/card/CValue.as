package com.mylib.game.card
{
	public class CValue
	{
		
		public var value:int;
		public var type:uint;
		
		public function CValue(type:uint=0,value:int=0)
		{
			this.type = type;
			this.value = value;
		}
		
		public function clone():CValue{
			return new CValue(type,value);
		}
		
	}
}