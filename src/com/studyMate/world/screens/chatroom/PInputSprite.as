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
	
	public class PInputSprite extends Sprite
	{
		
		private var pInputSp:Sprite = new Sprite;	//私聊输入框容器
		private var moreSp:Sprite;					//更多选项面板
		
		private var input:GpuTextInput;			//输入框
		
		public function PInputSprite()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			pInputSp = new Sprite;
			pInputSp.y = 300;
			addChild(pInputSp);
			
			//更多面板
			moreSp = new Sprite;
			moreSp.y = -250;
			var clipSp:Sprite = new Sprite;
			clipSp.y = 78;
			clipSp.addChild(moreSp);
			clipSp.clipRect = new Rectangle(0,0,944,237);
			pInputSp.addChild(clipSp);
			
			//更多面板背景
			var morebg:Image = new Image(Assets.getChatViewTexture("chatRoom/input_moreBg"));
			moreSp.addChild(morebg);
			
			//拍照按钮
			var photoBtn:Button = new Button(Assets.getChatViewTexture("chatRoom/input_photoBtn"));//chatRoom/input_pictureBtn
			photoBtn.x = 20;
			photoBtn.y = 20;
			moreSp.addChild(photoBtn);
			
			//图片按钮
			var pictureBtn:Button = new Button(Assets.getChatViewTexture("chatRoom/input_pictureBtn"));
			pictureBtn.x = 130;
			pictureBtn.y = 20;
			moreSp.addChild(pictureBtn);
			
			
			
			//输入框
			var inputBg:Image = new Image(Assets.getChatViewTexture("chatRoom/ptalk_inputBg"));
			pInputSp.addChild(inputBg);
			
			//更多按钮
			var moreBtn:Button = new Button(Assets.getChatViewTexture("chatRoom/input_moreBtn"));
			moreBtn.addEventListener(Event.TRIGGERED,moreBtnHandle);
			pInputSp.addChild(moreBtn);
			
			//表情按钮
			var faceBtn:Button = new Button(Assets.getChatViewTexture("chatRoom/input_faceBtn"));
			faceBtn.x = 800;
			faceBtn.y = 10;
			pInputSp.addChild(faceBtn);
			
			//语音按钮
			var speechBtn:Button = new Button(Assets.getChatViewTexture("chatRoom/input_speechBtn"));
			speechBtn.x = 865;
			speechBtn.addEventListener(Event.TRIGGERED,test);
			pInputSp.addChild(speechBtn);
			
			
			input = new GpuTextInput();
			input.x = 100;
			input.y = 30;
			input.maxChars = 60;
			input.width = 680; 
			input.height = 33;
			pInputSp.addChild(input);
			input.setTextFormat(new TextFormat("HeiTi",23,0));
			input.stageTextField.multiline = true;
			input.stageTextField.isEditable = true;
			input.addEventListener(FeathersEventType.FOCUS_IN,inputFocusInHandle);
//			input.addEventListener(FeathersEventType.ENTER,inputHandle);
			
			
			
			
			
		}
		private function inputFocusInHandle(e:Event):void{
			TweenLite.killTweensOf(pInputSp);
			TweenLite.to(pInputSp, 0.1, {y:-218});
			
//			showMore = false;
			
		}
		private function test():void{
			TweenLite.killTweensOf(pInputSp);
			TweenLite.to(pInputSp, 0.1, {y:-218});
			
			showMore = false;
		}
		
		
		//更多选择
		private var showMore:Boolean = false;
		private function moreBtnHandle():void{
			TweenLite.killTweensOf(pInputSp);
			TweenLite.killTweensOf(moreSp);
			
			if(!showMore){
				//显示更多
				
				TweenLite.to(pInputSp, 0.2, {y:-218});
//				moreSp.visible = true;
				TweenLite.to(moreSp, 0.1, {y:0});
				
			}else{
				//隐藏
				
				TweenLite.to(pInputSp, 0.2, {y:0});
//				moreSp.visible = false;
				TweenLite.to(moreSp, 0.1, {y:-250});
			}
			
			showMore = !showMore;
		}
		
		
		
		public function show():void{
			TweenLite.killTweensOf(pInputSp);
			TweenLite.to(pInputSp, 0.1, {y:0});
		}
		public function hide():void{
			pInputSp.y = 300;
			showMore = false;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
			TweenLite.killTweensOf(pInputSp);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeChildren(0,-1,true);
		}
		
	}
}