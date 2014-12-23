package com.mylib.game.controller.vo
{
	import com.mylib.game.charater.ICharater;
	

	public class CharaterMenuVO
	{

		public var charater:ICharater;
		public var id:String;
		public var dressList:String;
		public var level:String;
		
		public function CharaterMenuVO(_charater:ICharater,_id:String,_dressList:String,_level:String)
		{
			
			charater = _charater;
			id = _id;
			dressList = _dressList;
			level = _level;
			
		}
	}
}