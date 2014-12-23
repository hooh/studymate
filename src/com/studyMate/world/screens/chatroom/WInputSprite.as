package com.studyMate.world.screens.chatroom
{
	import com.greensock.TweenLite;
	import myLib.myTextBase.GpuTextInput;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.events.FeathersEventType;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class WInputSprite extends Sprite
	{
		
		private var wInputSp:Sprite = new Sprite;	//私聊聊输入框容器
		
		private var input:GpuTextInput;			//输入框
		
		public function WInputSprite()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			wInputSp = new Sprite;
			wInputSp.y = 300;
			addChild(wInputSp);
			
			
			//输入框
			var inputBg:Image = new Image(Assets.getChatViewTexture("chatRoom/wtalk_inputBg"));
			wInputSp.addChild(inputBg);
			
			
			//表情按钮
			var faceBtn:Button = new Button(Assets.getChatViewTexture("chatRoom/input_faceBtn"));
			faceBtn.x = 1050;
			faceBtn.y = 10;
			wInputSp.addChild(faceBtn);
			
			//语音按钮
			var speechBtn:Button = new Button(Assets.getChatViewTexture("chatRoom/input_speechBtn"));
			speechBtn.x = 1115;
			wInputSp.addChild(speechBtn);
			
			
			input = new GpuTextInput();
			input.x = 30;
			input.y = 30;
			input.maxChars = 60;
			input.width = 1010; 
			input.height = 33;
			wInputSp.addChild(input);
			input.setTextFormat(new TextFormat("HeiTi",23,0));
			input.stageTextField.multiline = true;
			input.stageTextField.isEditable = true;
			input.addEventListener(FeathersEventType.FOCUS_IN,inputFocusInHandle);
//			input.addEventListener(FeathersEventType.ENTER,inputHandle);
			
			
			
			
			
		}
		private function inputFocusInHandle(e:Event):void{
			TweenLite.killTweensOf(wInputSp);
			TweenLite.to(wInputSp, 0.1, {y:-218});
			
//			showMore = false;
			
		}
		
		
		
		public function show():void{
			TweenLite.killTweensOf(wInputSp);
			TweenLite.to(wInputSp, 0.1, {y:0});
		}
		public function hide():void{
			wInputSp.y = 300;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
			TweenLite.killTweensOf(wInputSp);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeChildren(0,-1,true);
		}
		
	}
}