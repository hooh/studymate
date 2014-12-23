package com.mylib.game.card
{
	import com.byxb.utils.centerPivot;
	import com.mylib.framework.CoreConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class CardDisplay extends Sprite
	{
		protected var txt:TextField;
		
		protected var _data:CValue;
		
		public var owner:PlayerInTurnDisplay;
		
		public static const CLICK:String = "CardDisplayClicked";
		
		
		public function CardDisplay(_data:CValue,owner:PlayerInTurnDisplay=null)
		{
			data = _data;
			this.owner = owner;
		}
		
		public function set data(_card:CValue):void{
			_data = _card;
			var q:Quad = new Quad(80,100);
			q.color = HeroAttribute.getCardColor(_card.type);
			addChild(q);
			
			txt = new TextField(80,50,_card.value.toString(),"HuaKanT",30);
			txt.touchable = false;
			addChild(txt);
			centerPivot(this);
			
			this.addEventListener(TouchEvent.TOUCH,touchHandle);
		}
		
		public function get data():CValue{
			return _data;
		}
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this,TouchPhase.ENDED);
			if(touch){
				Facade.getInstance(CoreConst.CORE).sendNotification(CLICK,this);
			}
			
		}
		
		
		public function set value(_uint:uint):void{
			_data.value = _uint;
			refreshValue();
		}
		
		public function refreshValue():void{
//			txt.text = _data.value.toString();
		}
		
		
		
	}
}