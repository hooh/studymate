package com.studyMate.world.component.AndroidGame.GameMarket
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.item.EquipmentItemButton;
	import com.studyMate.world.component.AndroidGame.AndroidGameVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class GameMarketItem extends Sprite
	{
		private static const NAME:String = "GameMarketItem";
		public static const BUY_CLICK:String = NAME + "BuyClick";
		
		public var gameVo:AndroidGameVO;
		
		
		private var itemBtn:Button;
		private var priceTexture:Texture;
		private var buyTexture:Texture;
		
		public function GameMarketItem(_gameVo:AndroidGameVO)
		{
			gameVo = _gameVo;
			
			
			var img:Image = new GameMarketItemIcon(gameVo.bitmap,gameVo.gameName);
			addChild(img);
			
			priceTexture = Assets.getAndroidGameTexture("priceBtn");
			buyTexture = Assets.getAndroidGameTexture("buyBtn");
			
			
			
			
			initBtn(gameVo.gold.toString());
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageHandle);
		}
		
		private function initBtn(_price:String):void{
			itemBtn = new Button(priceTexture,_price,priceTexture);
			itemBtn.fontName = "HuaKanT";
			itemBtn.fontSize = 18;
			itemBtn.name = "price";
			itemBtn.x = 82;
			itemBtn.y = 36;
			
			addChild(itemBtn);
			
			
			itemBtn.addEventListener(Event.TRIGGERED,itemBtnHandle);
			
		}
		
		private function itemBtnHandle():void{
			//价格状态，显示购买
			if(btnState == "price"){
				
				setPricebtnState("buy");
				
				
			}else if(btnState == "buy"){
				//点击购买
				
				trace("购买");
				Facade.getInstance(CoreConst.CORE).sendNotification(BUY_CLICK,gameVo);
				
			}
		}
		private var clickState:String = "";
		private function stageHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.BEGAN){
					if(!itemBtn.stage)
						return;
					if(!itemBtn.getBounds(Starling.current.stage).contains(touch.globalX,touch.globalY)){ //价格按钮区域
						//关闭
						setPricebtnState("price");
						
						clickState = "out";
					}else{
						//点击里面
						trace("点击按钮内部");
						
						
						
						clickState = "in";
						
						
					}
					
					
					
				}
			}
		}
		
		
		private var btnState:String = "price";
		public function setPricebtnState(_state:String):void{
			
			if(btnState != "price" && _state == "price"){
				
				btnState = "price";
				
				itemBtn.upState = priceTexture;
				itemBtn.downState = priceTexture;
				
				itemBtn.text = gameVo.gold.toString();
				
			}else if(btnState != "buy" && _state == "buy"){
				
				btnState = "buy";
				
				itemBtn.upState = buyTexture;
				itemBtn.downState = buyTexture;
				
				itemBtn.text = "";
			}
			
			
			
		}
		

		override public function dispose():void
		{
			super.dispose();
			if(Starling.current.stage.hasEventListener(TouchEvent.TOUCH))
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageHandle);
			if(itemBtn)
				itemBtn.removeEventListener(Event.TRIGGERED,itemBtnHandle);
			
			removeChildren(0,-1,true);
		}
	}
}