package com.studyMate.world.screens.chatroom
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import feathers.controls.Label;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class PersonListRootItem extends Sprite
	{
		private var bg:Image;
		private var icon:Image;
		private var nameLabel:Label;
		
		private var title:String;
		private var label:TextField;
		private var itemsp:Sprite;
		
		public var type:String;
		
		public function PersonListRootItem(type:String)
		{
			super();
			
			this.type = type;
			switch(type){
				case "F":	this.title = "我的好友";	break;
				case "S":	this.title = "陌生人";	break;
				default:	this.title = "其他";		break;
			}
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			bg = new Image(Assets.getChatViewTexture("chatRoom/rootItemBg"));
			bg.x = 13;
			addChild(bg);
			
			itemsp = new Sprite;
			addChild(itemsp);
			
			icon = new Image(Assets.getChatViewTexture("chatRoom/rootItemArrow"));
			centerPivot(icon);
			icon.x = 40;
			icon.y = 32;
			icon.touchable = false;
			itemsp.addChild(icon);
			
			
			label = new TextField(190,30,title+"[0/0]","HeiTi",18,0xffffff,true);
			label.x = 53;
			label.y = 17;
			label.touchable = false;
			label.vAlign = VAlign.CENTER;
			label.hAlign = HAlign.LEFT;
//			label.border = true;
			itemsp.addChild(label);
			
			
			bg.addEventListener(TouchEvent.TOUCH,itemClickHandle);
		}
		
		/**
		 * 设置分组当前人数 
		 * @param numOn
		 * @param numTotal
		 * 
		 */		
		public function updateNum(numOn:int, numTotal:int):void{
			label.text = title + "[" + numOn.toString() + "/" + numTotal.toString() + "]";
			
			
		}
		
		
		
		
		
		private var beginY:Number;
		private var endY:Number;
		private function itemClickHandle(e:TouchEvent):void{
			var touch:Touch = e.getTouch(this.bg);				
			if(touch){
				if(touch.phase == TouchPhase.BEGAN){
					beginY = touch.globalY;
					
				}else if(touch.phase==TouchPhase.MOVED){
					
				}else if(touch.phase == TouchPhase.ENDED){
					
					endY = touch.globalY;
					if(Math.abs(endY - beginY) <= 10){
						
						
						this.dispatchEvent(new Event("RootItemClick",e.bubbles,e.data));
					}
					
//					isTips = !isTips;
					
				}
				
			}		
		}
		
		public function showRoot():void{
			TweenLite.to(icon,0.15,{rotation:Math.PI/2});
		}
		public function closeRoot():void{
			TweenLite.to(icon,0.15,{rotation:0});
		}
		
		
		
		
		
		private var _isTips:Boolean;
		public function set isTips(val:Boolean):void{
			if(_isTips == val)
			{
				return;
			}
			
			_isTips = val;
			
			//提醒
			if(_isTips){
				/*shape();*/
				TweenLite.delayedCall(Math.random()*0.6,flashItem);
				
				
			}else{
				
				TweenLite.killDelayedCallsTo(flashItem);
				TweenLite.killTweensOf(itemsp);
				itemsp.alpha = 1;
			}
		}
		public function get isTips():Boolean{
			return _isTips;
		}
		
		private function flashItem():void{
			
			TweenMax.to(itemsp,0.3,{alpha:0,yoyo:true,repeat:int.MAX_VALUE});
			
		}
		
		
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			TweenLite.killDelayedCallsTo(flashItem);
			TweenLite.killTweensOf(itemsp);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeChildren(0,-1,true);
		}
		
	}
}