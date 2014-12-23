package com.studyMate.module.classroom.view
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
	
	public class CRTextInputView extends CRInputBase implements ITextInputView
	{
		private var changeSpeechBtn:Button;//切换语音
		private var inputImg:Image;
		private var _input:TextFieldHasKeyboard;	
		private var faceBtn:Button;
		private var keyboardBtn:Button;
		
		public function CRTextInputView()
		{
			super();
			
			keyboardBtn = new Button(Assets.getCnClassroomTexture("keyboardBtn"));
			keyboardBtn.x = 492;
			keyboardBtn.y = -36;
			holder.addChild(keyboardBtn);
			
			inputImg = new Image(Assets.getCnClassroomTexture("inputBg"));
			inputImg.x = -1;
			holder.addChild(inputImg);
			
			changeSpeechBtn = new Button(Assets.getCnClassroomTexture('changeSpeechBtn'));
			changeSpeechBtn.x = 503;
			changeSpeechBtn.y = 21;
			holder.addChild(changeSpeechBtn);
			
			
			faceBtn = new Button(Assets.getCnClassroomTexture("faceBtn"));
			faceBtn.x = 455;
			faceBtn.y = 21;
			holder.addChild(faceBtn);
			

			holder.addChild(dropDownBtn);
						
			var tf:TextFormat = new TextFormat("HeiTi",30);
			_input = new TextFieldHasKeyboard();
			_input.defaultTextFormat = tf;
			_input.x = 787;
			_input.y = 685;
			_input.width = 388;
			_input.height = 44;
			_input.maxChars = 300;
//			_input.border = true;
			AppLayoutUtils.cpuLayer.addChild(_input);
		}
		override public function dispose():void{			
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(input);
//			AppLayoutUtils.cpuLayer.removeChild(input);
			if(input.parent){
				input.parent.removeChild(input);
			}
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
				TweenLite.killTweensOf(input);
				TweenLite.to(holder,0.3,{y:374});
				TweenLite.to(input,0.3,{y:374+24});
			
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
				TweenLite.killTweensOf(input);
				TweenLite.to(holder,0.3,{y:320});
				TweenLite.to(input,0.3,{y:320+24});
		
				VoicechatComponent.owner(core).updateHeight(278);
				
				if(_dropDownView && _dropDownView.parent){
					_dropDownView.removeFromParent();
				}
			}
			
		}
		
		override public function defaultState():void
		{
			if(holder.y<660){				
				keyboardBtn.visible = false;
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(input);
				TweenLite.to(holder,0.3,{y:663});
				TweenLite.to(input,0.3,{y:685});

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
			return changeSpeechBtn;
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