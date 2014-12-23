package com.mylib.game.card
{
	public class HeroAttribute
	{
		public static const GOLD:uint = 1;
		public static const WOOD:uint = 2;
		public static const WATER:uint = 3;
		public static const FIRE:uint = 4;
		public static const EARTH:uint = 5;
		
		public static const cardColor:Vector.<uint> = Vector.<uint>([
			0xf7e629,
			0xa1ef1a,
			0x55aef3,
			0xf54e1b,
			0xd69d24
		]);
		
		
		public static function getCardColor(type:uint):uint{
			
			if(type<1){
				return 0;
			}
			
			return cardColor[type-1];
		}
		
		
	}
}