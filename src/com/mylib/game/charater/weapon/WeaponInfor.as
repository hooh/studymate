package com.mylib.game.charater.weapon
{
	public class WeaponInfor
	{
		public static const SWORD:uint = 1;
		public static const GUN:uint = 2;
		
		public var id:uint;
		public var type:uint;
		
		public function WeaponInfor(id:uint,type:uint)
		{
			this.id = id;
			this.type = type;
		}
	}
}