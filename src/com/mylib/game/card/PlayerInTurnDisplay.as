package com.mylib.game.card
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class PlayerInTurnDisplay extends Sprite
	{
		public var data:CardGroup;
		
		protected var hpDisplay:TextField;
		
		public var roller:PlayerCardsChooser;
		public var addValue:int;
		
		public function PlayerInTurnDisplay(_data:CardGroup,dir:int)
		{
			this.data = _data;
			hpDisplay = new TextField(100,50,"","HuaKanT",40);
			addChild(hpDisplay);
			
			roller = new PlayerCardsChooser(new CardRollerItem,dir);
			addChild(roller);
			roller.y = 60;
			
		}
		
		public function refresh(_addValue:int=0):void{
			hpDisplay.text = data.hp.toString();
			addValue = _addValue;
			
			roller.refresh(data.values,_addValue);
		}
		
		
		public function set hp(_uint:int):void{
			hpDisplay.text = _uint.toString();
			data.hp = _uint;
		}
		
		public function get hp():int{
			return data.hp;
		}
		
		
	}
}