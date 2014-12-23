package com.mylib.game.charater
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.game.charater.item.DialogBox;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.Const;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class DialogBoxShowProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DialogBoxShowProxy";
		
		private var dialogBox:DialogBox;
		
		private var dialogBoxVo:DialogBoxShowCommandVO;
		public var isShow:Boolean;
		 
		override public function onRegister():void
		{
			super.onRegister();
			dialogBox = new DialogBox("HuaKanT");
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
//			dialogBox.dispose();
			dialogBox.removeChildren(0,-1,true);
			
		}
		
		
		public function DialogBoxShowProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function show(dialogBoxShowCommandVO:DialogBoxShowCommandVO):void{
			if(dialogBoxShowCommandVO.holder.getChildIndex(dialogBox) > -1)
				dialogBoxShowCommandVO.holder.removeChild(dialogBox);
			
			if(dialogBox)
				dialogBox.removeFromParent();
			this.dialogBoxVo = dialogBoxShowCommandVO;

//			dialogBox.setStyle(dialogBoxVo.styName);
			dialogBox.text = "";
			dialogBox.text = dialogBoxVo.text;
			dialogBox.x = dialogBoxVo.x;
			dialogBox.y = dialogBoxVo.y;
			dialogBox.scaleX = 0.9;
			dialogBox.scaleY = 0.9;
			dialogBox.alpha = 1;
			
			isShow = true;
			dialogBoxVo.holder.addChild(dialogBox);
			TweenLite.killTweensOf(dialogBox);
			TweenLite.from(dialogBox,0.3,{alpha:0,scaleX:0,scaleY:0,y:dialogBox.y+dialogBox.height,ease:Linear.easeNone,onComplete:showText});
			TweenMax.to(dialogBox,0.1,{delay:0.3,scaleX:1,scaleY:1,yoyo:true,repeat:2,ease:Linear.easeNone});
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,dialogBoxDisappear);
			
			dialogBox.addEventListener(Event.REMOVED_FROM_STAGE,removeHandle);
			
		}
		private function showText():void{
			dialogBox.textField.visible = true;
		}
		private function removeHandle(event:Event):void{
//			trace("移除了！");
			if(isEnter){
				isEnter = false;
				if(dialogBoxVo.enterFunction!=null){
					if(dialogBoxVo.enterFunctionParams!=null)
						dialogBoxVo.enterFunction(dialogBoxVo.enterFunctionParams);
					else
						dialogBoxVo.enterFunction();
				}
			}else{
				if(dialogBoxVo.cancleFunction!=null){
					dialogBoxVo.cancleFunction();
				}
			}
			dialogBox.textField.visible = false;
			isShow = false;
			if(dialogBoxVo){
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,dialogBoxDisappear);
			}
			
			dialogBoxVo = null;
		}
		
		private var isEnter:Boolean;
		private function dialogBoxDisappear(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					if(isShow){
						//点选弹出框
						if(dialogBox.getBounds(dialogBoxVo.holder.stage).contains(touchPoint.globalX,touchPoint.globalY)){
							isEnter = true;
						}
					}
					if(!isEnter){
						dialogBox.removeFromParent();
					}
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(isEnter){
						dialogBox.removeFromParent();
					}
				}
			}
		}
	}
}