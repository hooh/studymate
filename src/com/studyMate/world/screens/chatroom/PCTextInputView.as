package com.studyMate.world.screens.chatroom
{
	import com.greensock.TweenLite;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.component.weixin.interfaces.ITextInputView;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	public class PCTextInputView extends Sprite implements ITextInputView
	{
		private var changeSpeechBtn:Button;//切换语音
		private var inputImg:Image;
		private var _input:TextFieldHasKeyboard;	
		private var faceBtn:Button;
		private var keyboardBtn:Button;
		
		protected var dropDownBtn:Button;
		protected var holder:Sprite;
		protected var _dropDownView:DisplayObject;
		
		public function PCTextInputView()
		{
			super();
			
			holder = new Sprite();
			holder.x = 325;
//			holder.y = 9;
			holder.y = 649;
			this.addChild(holder);
			
			keyboardBtn = new Button(Assets.getChatViewTexture("chatRoom/input_keyboardBtn"));
			keyboardBtn.x = 797;
			keyboardBtn.y = -55;
			holder.addChild(keyboardBtn);
			
			inputImg = new Image(Assets.getChatViewTexture("chatRoom/ptalk_inputBg"));
			holder.addChild(inputImg);
			
			
			faceBtn = new Button(Assets.getChatViewTexture("chatRoom/input_faceBtn"));
			faceBtn.x = 797;
			faceBtn.y = 10;
			holder.addChild(faceBtn);
			
			
			changeSpeechBtn = new Button(Assets.getChatViewTexture("chatRoom/input_speechBtn"));
			changeSpeechBtn.x = 862;
			holder.addChild(changeSpeechBtn);

			
			
			dropDownBtn = new Button(Assets.getChatViewTexture("chatRoom/input_moreBtn"));
			holder.addChild(dropDownBtn);
						
			
			var tf:TextFormat = new TextFormat("HeiTi",23,0)
			_input = new TextFieldHasKeyboard();
			_input.defaultTextFormat = tf;
			_input.x = 425;
//			_input.y = 30;
			_input.y = 678;
			_input.maxChars = 60;
			_input.width = 680; 
			_input.height = 33;
//			_input.border = true;
			AppLayoutUtils.cpuLayer.addChild(_input);
		}
		
		private var _core:String;
		public function set core(value:String):void
		{
			_core = value;
		}
		
		public function get core():String
		{
			return _core;
		}
		
		public function get input():TextFieldHasKeyboard
		{
			return _input;
		}
		
		public function useSoftKeyboardState():void
		{
			if(holder.y != 374){		
				keyboardBtn.visible = true;
				TweenLite.killTweensOf(holder);
				TweenLite.to(holder,0.3,{y:374});
				TweenLite.to(input,0.3,{y:374+29});
			
				VoicechatComponent.owner(core).updateHeight(318);
				if(_dropDownView && _dropDownView.parent){
					_dropDownView.removeFromParent();
				}
			}
		}
		
		public function userSogouKeyboardState():void
		{
			if(holder.y != 320){	
				keyboardBtn.visible = true;
				TweenLite.killTweensOf(holder);
				TweenLite.to(holder,0.3,{y:320});
				TweenLite.to(input,0.3,{y:320+29});
		
				VoicechatComponent.owner(core).updateHeight(278);
				
				if(_dropDownView && _dropDownView.parent){
					_dropDownView.removeFromParent();
				}
			}
			
		}
		
		public function defaultState():void
		{
			if(holder.y<636){				
				keyboardBtn.visible = false;
				TweenLite.killTweensOf(holder);
				TweenLite.to(holder,0.3,{y:649});
				TweenLite.to(input,0.3,{y:678});

				defaultState1();
			}
		}	
		
		
		public function dropdownState():void{
			if(input.y!=543){		
				keyboardBtn.visible = false;
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(input);
				holder.y = 430;
				input.y = 459;
				dropdownState1();
			}else{
				defaultState();
			}
			
		}
		
		
		private var rect:Rectangle ;	
		public function defaultState1():void{
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			if(VoicechatComponent.owner(core)){
				VoicechatComponent.owner(core).updateHeight(VoicechatComponent.owner(core).configView.viewHeight);
				
			}
									
			if(_dropDownView){
				_dropDownView.removeFromParent();
			}
		}
		public function dropdownState1():void{
			if(!_dropDownView.parent){
				this.addChildAt(_dropDownView,0);
			}
			_dropDownView.x = 326;
			_dropDownView.y = 510;
			VoicechatComponent.owner(core).updateHeight(360);
			rect = holder.getBounds(Starling.current.stage);
			rect.height += _dropDownView.height;
			Global.stage.addEventListener(MouseEvent.CLICK,clickHandler,false,3);
		}
		
		
		protected function clickHandler(event:MouseEvent):void
		{
			
			if(rect.contains(event.stageX,event.stageY)){
				
			}else{
				defaultState();
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//打开下拉菜单按钮
		public function get addDropdownDisplayobject():DisplayObject{
			return dropDownBtn;
		}
		//下拉界面
		public function set dropDownViewDisplayobject(value:DisplayObject):void{
			_dropDownView = value;
		}
		

		
		
		
		public function get switchVoiceDisplayObject():DisplayObject
		{
			return changeSpeechBtn;
		}
	
		public function get faceDisplayObject():DisplayObject
		{
			return faceBtn;
		}
		public function get changeKeyboardDisplayobject():DisplayObject{
			return keyboardBtn;
		}

		
		
		
		override public function dispose():void{		
			if(input.parent){
				input.parent.removeChild(input);
			}
//			AppLayoutUtils.cpuLayer.removeChild(input);
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(input);
			
			
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			if(_dropDownView){
				_dropDownView.removeFromParent(true);
			}
			
			super.dispose();
		}
	}
}