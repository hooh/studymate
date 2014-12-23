package com.mylib.game.card
{

	public class GameCharaterData
	{
		public var values:Vector.<CValue>;
		public var fullHP:int;
		public var equiment:String;
		public var name:String;
		public var state:String;
		public var charaterClass:String;
		public var id:String;
		public var skeleton:String;
		public var job:uint;
		public var scale:Number;
		public var allotId:String;
		public var hp:int;
		public var attack:int;
		
		public function GameCharaterData()
		{
			hp = fullHP = 200;
		}
		
		
		public function clone():GameCharaterData{
			var cp:GameCharaterData = new GameCharaterData();
			cp.fullHP = fullHP;
			cp.equiment = equiment;
			cp.name = name;
			cp.state = state;
			cp.charaterClass = charaterClass;
			cp.values = new Vector.<CValue>;
			cp.id = id;
			cp.skeleton = skeleton;
			cp.job = job;
			cp.scale = scale;
			cp.hp = hp;
			cp.allotId = allotId;
			for (var i:int = 0; i < values.length; i++) 
			{
				var card:CValue = new CValue(values[i].type,values[i].value);
				cp.values.push(card);
			}
			
			return cp; 
			
			
		}
		
		
	}
}