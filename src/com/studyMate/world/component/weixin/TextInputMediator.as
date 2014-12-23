package com.studyMate.world.component.weixin
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.ToastVO;
	import myLib.myTextBase.utils.KeyBoardConst;
	import myLib.myTextBase.utils.KeyboardType;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.component.sysface.SysFacePanelMediator;
	import com.studyMate.world.component.weixin.interfaces.ITextInputView;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	internal class TextInputMediator extends Mediator
	{
		private static var useSysKeyboard:Boolean;//是否使用系统键盘
		private var NAME:String ;
		private const timeOut:int = 2000;//毫秒，聊天间隔，防止刷屏
		
		public var core:String;
		private var isFirst:Boolean;
		
		public function TextInputMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			NAME = mediatorName;
			super(mediatorName, viewComponent);
		}
		
		override public function onRemove():void{
			if(dropDown) {
				dropDown.removeFromParent(true);
				dropDown = null;
			}
			Facade.getInstance(CoreConst.CORE).removeMediator(NAME);
			TweenLite.killDelayedCallsTo(sougouFouchOut);
			view.input.removeEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			view.input.removeEventListener(FocusEvent.FOCUS_OUT,FOCUS_OUTHandler);
			view.input.removeEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);	
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			Global.stage.focus = null;
//			AppLayoutUtils.gpuLayer.removeChild(view as DisplayObject,true);
			TweenLite.killTweensOf(updateTimes);
			(view as DisplayObject).removeFromParent(true);
			super.onRemove();
		}
		
		protected function removeFromeStageHandler(event:Event):void
		{
			view.input.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromeStageHandler);
			view.defaultState();
		}
		override public function onRegister():void{
			if(!isFirst){
				isFirst = true;
				Facade.getInstance(CoreConst.CORE).registerMediator(this);
				view.core = core;
				AppLayoutUtils.gpuLayer.addChild(view as DisplayObject);
				view.input.addEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler); 
				view.input.addEventListener(Event.REMOVED_FROM_STAGE,removeFromeStageHandler);
				Global.stage.addEventListener(MouseEvent.CLICK,clickHandler,false,5);
				if(!useSysKeyboard){				
					KeyBoardConst.current_Keyboard = KeyboardType.CN_KEYBOARD;
	//				view.input.setFocus();
	//				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.USE_KEYBOARD_CHINESE);//切换中文键盘				
				}else{
					view.input.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
					view.input.addEventListener(FocusEvent.FOCUS_OUT,FOCUS_OUTHandler);
					view.input.useKeyboard = false;
					view.input.needsSoftKeyboard = true;
					view.input.requestSoftKeyboard();
	//				view.input.setFocus();
				}
			}
			
		}
		
		protected function FOCUS_OUTHandler(event:FocusEvent):void
		{
			TweenLite.killDelayedCallsTo(sougouFouchOut);
			TweenLite.delayedCall(0.3,sougouFouchOut);
		}
		private function sougouFouchOut():void{
			view.defaultState();
			Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.NO_KEYBOARD);
		}
		
		protected function focusInHandler(event:FocusEvent):void
		{
			view.userSogouKeyboardState();
			view.input.needsSoftKeyboard = true;
			view.input.requestSoftKeyboard();
			Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.HAS_KEYBOARD);
		}
		private var dropDown:DropDownComponent;
		protected function clickHandler(event:MouseEvent):void
		{
			var isContans:Boolean;
			if(checkTouch(view.faceDisplayObject,event.stageX,event.stageY/Global.heightScale)){
				isContans = true;
				if(!facade.hasMediator(SysFacePanelMediator.NAME))
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SysFacePanelMediator,view.input,SwitchScreenType.SHOW,Global.stage,view.input.x+59,view.input.y-240)]);				
			}else if(checkTouch(view.switchVoiceDisplayObject,event.stageX,event.stageY/Global.heightScale)){
				isContans = true;
				Facade.getInstance(core).sendNotification(SpeechConst.USE_RECORD_OPERATE);
			}else if(checkTouch(view.addDropdownDisplayobject,event.stageX,event.stageY/Global.heightScale)){
				Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
				isContans = true;
				if(dropDown==null){
					dropDown = new DropDownComponent();
					dropDown.core = core;
					view.dropDownViewDisplayobject = dropDown;
				}				
				view.dropdownState();
			}else if(checkTouch(view.changeKeyboardDisplayobject,event.stageX,event.stageY/Global.heightScale)){				
				isContans = true;
				useSysKeyboard = !useSysKeyboard;
				if(!useSysKeyboard){						
					view.input.useKeyboard = true;
					view.input.needsSoftKeyboard = false;
					view.input.setFocus();
					Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.USE_KEYBOARD_CHINESE);//切换中文键盘
					view.input.removeEventListener(FocusEvent.FOCUS_IN,focusInHandler);
					view.input.removeEventListener(FocusEvent.FOCUS_OUT,FOCUS_OUTHandler);
					view.useSoftKeyboardState();
				}else{
					view.input.useKeyboard = false;
					view.input.needsSoftKeyboard = true;
					view.input.requestSoftKeyboard();
					view.input.setFocus();
					view.input.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
					view.input.addEventListener(FocusEvent.FOCUS_OUT,FOCUS_OUTHandler);
					view.userSogouKeyboardState();
					Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
				}
			}
			if(isContans){
				TweenLite.killDelayedCallsTo(sougouFouchOut);
				event.stopImmediatePropagation();
			}
		}
		
		
		private var result:Point=new Point;
		private function checkTouch(displayObject:DisplayObject,globalX:Number,globalY:Number):Boolean{
			if(displayObject &&　displayObject.stage){
				displayObject.globalToLocal(new Point(globalX,globalY),result);
				if( displayObject.hitTest(result)){
					return true;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case SoftKeyBoardConst.HAS_KEYBOARD:
					if(!useSysKeyboard){		
						if(view.input.visible)
							view.useSoftKeyboardState();				
					}
					break;
				case SoftKeyBoardConst.NO_KEYBOARD:
					if(!useSysKeyboard){	
						if(view.input.visible)
							view.defaultState();
					}
					break;
				case SpeechConst.SHOW_EXPLAINATION:
					view.input.visible = false;
					Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
					break;
				case SpeechConst.HIDE_EXPLAINATION:
					view.input.visible = true;
					Global.stage.addEventListener(MouseEvent.CLICK,clickHandler,false,5);
					break;
				
			}
		}
		override public function listNotificationInterests():Array{
			return [
				SoftKeyBoardConst.HAS_KEYBOARD,
				SoftKeyBoardConst.NO_KEYBOARD,
				SpeechConst.SHOW_EXPLAINATION,
				SpeechConst.HIDE_EXPLAINATION
			];
		}
		
		private var talkTimes:int = 3; //说话次数，防刷屏
		private function updateTimes():void{
			
			if(talkTimes < 3 && talkTimes >= 0){
				talkTimes++;
				
				if(talkTimes != 3)
					TweenLite.delayedCall(3,updateTimes);
				
			}
		}
		
		
		private var inputMsg:String;
		private var preTime:int;
		protected function inputKeyDownHandler(event:KeyboardEvent):void{			
			if(event.keyCode == Keyboard.ENTER ){
				inputMsg = StringUtil.trim(view.input.text);
				if(inputMsg!=''){
					//有发言次数，才能发言
					if(talkTimes > 0){
						talkTimes--;
						TweenLite.killTweensOf(updateTimes);
						
						if(talkTimes == 0){
							//刷屏，导致次数为0 ,惩罚至9秒加会次数1
							TweenLite.delayedCall(6,updateTimes);
							
						}else{
							TweenLite.delayedCall(3,updateTimes);
						}
						
						view.input.text = '';
						view.input.setFocus();
						cmdUpMsg(inputMsg);
						
					}else{
						
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("发送消息太快了,送消息的快递员很忙哦"));
						
					}
					
					
					/*if(getTimer()-preTime<timeOut){
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("发送消息太快了,送消息的快递员很忙哦"));
					}else{
						preTime = getTimer();
						view.input.text = '';
						view.input.setFocus();
						cmdUpMsg(inputMsg);
					}*/
				}
			}
		}
		
		//插入聊天记录
		private function cmdUpMsg(mtxt:String=''):void{
			var obj:* = VoicechatComponent.owner(core).configText.insertTextFun.apply(null,[mtxt]);
			if(obj)
			{
				VoicechatComponent.owner(core).addMsgItem(obj);
			}
		}	
	
		public function get view():ITextInputView{
			return getViewComponent() as ITextInputView;
		}
	}
}