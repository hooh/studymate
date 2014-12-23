package com.mylib.game.charater.item
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.model.vo.DressSuitsVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class EquipmentItemButton extends Button
	{
		public static const ITEM_CLICK:String = "ItemClick";
		public static const BUY_CLICK:String = "BuyClick";
		public var dressSuitsVo:DressSuitsVO;
		
		private var price:String;
		private var priceBtn:Button;
		
		private var priceTexture:Texture;
		private var buyTexture:Texture;
		
		public function EquipmentItemButton(upState:Texture, text:String="", downState:Texture=null, _price:String=null)
		{
			super(upState,text,upState);
			
			
			
			if(_price){
				price = _price;
				
				priceTexture = Assets.getDressSeriesTexture("DressMarket/priceBtn");
				buyTexture = Assets.getDressSeriesTexture("DressMarket/buyBtn");
				
				initBtn(_price);
				
				addEventListener(TouchEvent.TOUCH,itemClickHandle);
				
				Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageHandle);
			}
		}
		
		
		private var beginY:Number;
		private var endY:Number;
		private function itemClickHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endY = touchPoint.globalY;
					if(Math.abs(endY-beginY) < 10){
						
						if(clickState == "out"){
							
//							trace("点击了item");
							
							Facade.getInstance(CoreConst.CORE).sendNotification(ITEM_CLICK,dressSuitsVo);
							
						}
						
					}
				}
			}
		}
		
		
		
		
		
		
		
		private function initBtn(_price:String):void{
			priceBtn = new Button(priceTexture,_price,priceTexture);
			priceBtn.fontName = "HuaKanT";
			priceBtn.name = "price";
			priceBtn.x = 35;
			priceBtn.y = 90;
			
			addChild(priceBtn);
			
			
			priceBtn.addEventListener(Event.TRIGGERED,priceBtnHandle);
			
		}
		
		private function priceBtnHandle():void{
			//价格状态，显示购买
			if(btnState == "price"){
				
				setPricebtnState("buy");
				
				
			}else if(btnState == "buy"){
				//点击购买
				
				trace("购买");
				Facade.getInstance(CoreConst.CORE).sendNotification(BUY_CLICK,dressSuitsVo);
				
			}
		}
		private var clickState:String = "";
		private function stageHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.BEGAN){
					
					if(!priceBtn.getBounds(Starling.current.stage).contains(touch.globalX,touch.globalY)){ //价格按钮区域
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
			
			if(_state == "price"){
				
				btnState = "price";
				
				priceBtn.upState = priceTexture;
				priceBtn.downState = priceTexture;
				
				priceBtn.text = price;

			}else if(_state == "buy"){
				
				btnState = "buy";
				
				priceBtn.upState = buyTexture;
				priceBtn.downState = buyTexture;
				
				priceBtn.text = "";
			}
			
			
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(Starling.current.stage.hasEventListener(TouchEvent.TOUCH))
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageHandle);
			if(priceBtn)
				priceBtn.removeEventListener(Event.TRIGGERED,priceBtnHandle);
			
			removeChildren(0,-1,true);
		}
		
	}
}