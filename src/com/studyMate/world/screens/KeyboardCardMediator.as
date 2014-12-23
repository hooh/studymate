package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import views.closeButton;
	
	internal class KeyboardCardMediator extends ScreenBaseMediator
	{
		private static var instance:KeyboardCardMediator;
		public static var NAME:String = "KeyboardCardMediator";
		private var keys:String;
		private var controlBar:Sprite;
		private var keyboardVisible:Boolean = false;
		
		public function KeyboardCardMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			view.addEventListener(MouseEvent.CLICK,viewClickHandler);
			view.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,mouseFocusChangeHandler);
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case WorldConst.WORD_LEARN_KEYBOARD:
					keys = notification.getBody() as String;
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.WORD_LEARN_KEYBOARD];
		}
		
		private function upsetString(str:String):String{
			var r:int;
			var len:int = str.length;
			var result:String = "";
			for(var i:uint = 0; i < len; i++){ // 打乱字符排序
				r = int(Math.random() * str.length);
				result += str.charAt(r);
				str = str.substring(0,r) + str.substring(r+1,str.length);
			}
			result.toLowerCase();
			str = result;
			result = "";
			for(i = 0; i < len; i++){ // 去重复字符
				for(var j:int = 0; j < result.length; j++){
					if(result.charAt(j) == str.charAt(i)) break;
				}
				if(j == result.length){
					result += str.charAt(i);
				}
			}
			return result;
		}
		
		private function viewClickHandler(event:MouseEvent):void{
			if(!keyboardVisible){
				keys = upsetString(keys).toLowerCase();
				controlBar = new Sprite();
				var h:int = 60 + 68*Math.ceil(keys.length/6);
				controlBar.graphics.beginFill(0xCCCCCC,0.6);
				controlBar.graphics.drawRect(0,0,600,h);
				controlBar.graphics.endFill();
				controlBar.x = 0;
				
				if(h <= 260) controlBar.y = 450;
				else controlBar.y = 710 - h;
				view.stage.addChild(controlBar);
				
				var myFormat:TextFormat = new TextFormat();
				myFormat.size = 25;
				
				var key:Button = new Button();
				key.width = 67;
				key.height = 26;
				key.label = "Del";
				controlBar.addChild(key);
				key.x = 496;
				key.y = 14;
				key.addEventListener(MouseEvent.CLICK, delKeyButtonClickHandler);
				
				key = new Button();
				key.width = 67;
				key.height = 26;
				key.label = "←";
				controlBar.addChild(key);
				key.x = 36;
				key.y = 14;
				key.addEventListener(MouseEvent.CLICK, closeButtonHandler);
				
				for(var i:int=0; i<keys.length; i++){
					key = new Button();
					key.width = 67;
					key.height = 57;
					key.label = keys.charAt(i);
					controlBar.addChild(key);
					key.x = 36 + (i % 6) * (67 + 25);
					key.y = 51 + int(i / 6) * (57 + 11);
					key.setStyle("textFormat",myFormat);
					key.addEventListener(MouseEvent.CLICK, keyButtonClickHandle);
				}
				keyboardVisible = true;
				
			}
		}
		
		private function closeButtonHandler(e:MouseEvent):void{
			closeKeyboard();
		}
		
		private function closeKeyboard():void{
			if(keyboardVisible){
				view.stage.removeChild(controlBar);
				keyboardVisible = false;
			}
		}
		
		private function mouseFocusChangeHandler(event:FocusEvent):void{
			
		}
		
		private function delKeyButtonClickHandler(e:MouseEvent):void{
			if(view.text.length > 0){
				var caret:int = view.selectionBeginIndex;
				if(view.selectionBeginIndex == view.selectionEndIndex && view.caretIndex != 0){
					view.text = view.text.slice(0,view.caretIndex - 1) + view.text.slice(view.caretIndex, view.text.length);
					caret = caret - 1;
				}else if(view.selectionBeginIndex != view.selectionEndIndex){
					view.text = view.text.slice(0,view.selectionBeginIndex) + view.text.slice(view.selectionEndIndex,view.text.length);
				}
				view.stage.focus = view;
				view.setSelection(caret, caret);
			}
		}
		
		private function keyButtonClickHandle(e:MouseEvent):void{
			view.replaceSelectedText(e.target.label);
			view.stage.focus = view;
			view.setSelection(view.selectionBeginIndex + 1, view.selectionBeginIndex + 1);
		}
		
		override public function onRemove():void{
			view.stage.removeChild(controlBar);
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():LearnWordCardTextField{
			return getViewComponent() as LearnWordCardTextField;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}