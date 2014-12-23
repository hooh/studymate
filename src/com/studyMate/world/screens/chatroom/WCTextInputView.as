package com.studyMate.world.screens.chatroom
{
	import com.greensock.TweenLite;
	import com.studyMate.global.AppLayoutUtils;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.component.weixin.interfaces.ITextInputView;
	
	import flash.text.TextFormat;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	
	public class WCTextInputView extends ChatInputBase implements ITextInputView
	{
		private var changeSpeechBtn:Button;//切换语音
		private var inputImg:Image;
		private var _input:TextFieldHasKeyboard;	
		private var faceBtn:Button;
		private var keyboardBtn:Button;
		
		public function WCTextInputView()
		{
			super();
			
			keyboardBtn = new Button(Assets.getChatViewTexture("chatRoom/input_keyboardBtn"));
			keyboardBtn.x = 1050;
			keyboardBtn.y = -55;
			holder.addChild(keyboardBtn);
			
			inputImg = new Image(Assets.getChatViewTexture("chatRoom/wtalk_inputBg"));
			holder.addChild(inputImg);
			
			
			faceBtn = new Button(Assets.getChatViewTexture("chatRoom/input_faceBtn"));
			faceBtn.x = 1050;
			faceBtn.y = 10;
			holder.addChild(faceBtn);
			
			
			changeSpeechBtn = new Button(Assets.getChatViewTexture("chatRoom/input_speechBtn"));
			changeSpeechBtn.x = 1115;
			changeSpeechBtn.enabled = false;
			holder.addChild(changeSpeechBtn);

//			holder.addChild(dropDownBtn);
						
			
			var tf:TextFormat = new TextFormat("HeiTi",23,0)
			_input = new TextFieldHasKeyboard();
			_input.defaultTextFormat = tf;
			_input.x = 100;
			_input.y = 668;	//30
			_input.maxChars = 60;
			_input.width = 1010; 
			_input.height = 33;
//			_input.border = true;
			AppLayoutUtils.cpuLayer.addChild(_input);
		}
		override public function dispose():void{			
			if(input.parent)
			input.parent.removeChild(input);
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(input);
			super.dispose();
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
		
		override public function defaultState():void
		{
			if(holder.y<636){				
				keyboardBtn.visible = false;
				TweenLite.killTweensOf(holder);
				TweenLite.to(holder,0.3,{y:639});
				TweenLite.to(input,0.3,{y:668});

				super.defaultState();
			}
		}	
		
		
		override public function dropdownState():void{
			if(input.y!=543){		
				keyboardBtn.visible = false;
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(input);
				holder.y = 519;
				input.y = 543;
				super.dropdownState();
			}else{
				defaultState();
			}
			
		}

		
		
		
		public function get switchVoiceDisplayObject():DisplayObject
		{
//			return changeSpeechBtn;
			return null;
		}
	
		public function get faceDisplayObject():DisplayObject
		{
			return faceBtn;
		}
		public function get changeKeyboardDisplayobject():DisplayObject{
			return keyboardBtn;
		}

	}
}