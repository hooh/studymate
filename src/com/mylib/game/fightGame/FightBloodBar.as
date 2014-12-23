package com.mylib.game.fightGame
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class FightBloodBar extends Sprite
	{
		public function FightBloodBar()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private var bloodList:Vector.<Image> = new Vector.<Image>;
		private function init(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);

			
			var blood:Image;
			
			//加红色血
			for(var i:int=0;i<6;i++){
				
				blood = new Image(Assets.getFightGameTexture("fightBloodIcon"));
				
				blood.y = i*11;
				
				addChild(blood);
				bloodList.push(blood);
			}
			
			
			
		}
		
		//更新血槽
		public function updateBar(_nowNum:int,_lrNum:int=0):void{
			if (_nowNum < 0)	_nowNum = 0;
			if (_lrNum < 0)	_lrNum = 0;

			
			//设定红色血
			for(var i:int=0;i<bloodList.length;i++)
				if(bloodList[i])
					bloodList[i].visible = true;
			for(i=0;i<(6-_nowNum);i++)
				if(bloodList[i])
					bloodList[i].visible = false;
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEventListener(Event.ADDED_TO_STAGE,init);
			removeChildren(0,-1,true);
		}
		
		
	}
}