package com.studyMate.world.screens.chatroom
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	
	import feathers.controls.Label;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class PersonListItem extends Sprite
	{
		private var bg:Image;
		private var name:TextField;
		
		private var perIcon:Image;
		
		public var relatVo:RelListItemSpVO;
		
		public function PersonListItem(relatVo:RelListItemSpVO)
		{
			super();
			
			this.relatVo = relatVo.clone();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			var touchArea:Quad = new Quad(265,72,0xffffff);
			touchArea.alpha = 0;
			addChild(touchArea);
			
			bg = new Image(Assets.getChatViewTexture("chatRoom/perItemSelectBg"));
			bg.touchable = false;
			bg.visible = false;
			addChild(bg);
			
			
			perIcon = new Image(Assets.getChatViewTexture("chatRoom/perIcon"));
			perIcon.x = 48;
			perIcon.y = 10;
			perIcon.touchable = false;
			addChild(perIcon);
			
			
			name = new TextField(135,30,relatVo.realName,"HeiTi",18,0x995528,true);
			name.x = 120;
			name.y = 22;
			name.touchable = false;
			name.vAlign = VAlign.CENTER;
			name.hAlign = HAlign.LEFT;
//			name.border = true;
			addChild(name);
			
//			this.
			
			
			this.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			
//			isOn = Math.random()>0.5 ? true:false;
			isOn = false;
		}
		
		private var _isOn:Boolean=true;
		public function set isOn(val:Boolean):void{
			if(_isOn != val){
				_isOn = val;
				if(!_isOn){		//下线
					
					//头像、名字灰色
					perIcon.color = 0x717171;
					name.color = 0x7a7171;
					
				}else{			//上线
					
					perIcon.color = 0xffffff;
					name.color = 0x995528;
					
					
					
				}
				
			}
			
		}
		public function get isOn():Boolean{
			return _isOn;
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
				TweenLite.delayedCall(Math.random()*0.6,shape);
				
				
			}else{
				
				TweenLite.killDelayedCallsTo(shape);
				TweenLite.killTweensOf(perIcon);
				perIcon.x = 48;
				perIcon.y = 10;
			}
		}
		public function get isTips():Boolean{
			return _isTips;
		}
		
		//抖动方法
		private function shape():void{
			TweenLite.delayedCall(0.9,shape);
			
			TweenMax.to(perIcon,0.15,{x:51,y:13,yoyo:true,repeat:1,ease:Linear.easeNone});
			TweenMax.to(perIcon,0.15,{delay:0.45,x:45,y:13,yoyo:true,repeat:1,ease:Linear.easeNone});
		}
		
		
		
		private var beginY:Number;
		private var endY:Number;
		private var isSameItem:Boolean = false;
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);				
			if(touch){
				if(touch.phase == TouchPhase.BEGAN){
					beginY = touch.globalY;
					
					isSameItem = bg.visible;
					bg.visible = true;
				}else if(touch.phase==TouchPhase.MOVED){
					endY = touch.globalY;
					if(Math.abs(endY-beginY) > 10 && !isSameItem){
						bg.visible = false;
						
					}
					
				}else if(touch.phase == TouchPhase.ENDED){
					if(bg.visible && !isSameItem){
						this.dispatchEvent(new Event("PerItemClick",e.bubbles,e.data));
						
					}
				}
			}		
		}
		public function set isSelect(val:Boolean):void{
			bg.visible = val;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			TweenLite.killDelayedCallsTo(shape);
			TweenLite.killTweensOf(perIcon);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeChildren(0,-1,true);
		}
		
	}
}