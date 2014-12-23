package com.studyMate.world.screens.component
{
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.card.CardValueDisplay;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class NpcListItemRender extends Sprite
	{
		private var hpTxt:TextField;
		
		
		public function NpcListItemRender()
		{
			super();
			
			hpTxt = new TextField(60,30,"","arial",12,0xffffff);
			
			hpTxt.x = 100;
			addChild(hpTxt);
			
			
			
		}
		
		public function set data(_d:GameCharaterData):void{
			
			var valueDisplay:CardValueDisplay = new CardValueDisplay();
			valueDisplay.data=_d.values;
			valueDisplay.refresh();
			
			addChild(valueDisplay.view);
			
			hpTxt.text = "HP:"+_d.fullHP;
			
		}
		
		
	}
}