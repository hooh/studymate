package com.studyMate.module.engLearn
{
	import com.studyMate.module.engLearn.ui.AloudExamFillUI;
	import com.studyMate.module.engLearn.ui.ListenTipUI;
	
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * 朗读考核界面
	 * 2014-10-21上午11:47:56
	 * Author wt
	 *
	 */	
	
	internal class ReadAloudExamView extends Sprite
	{
		
		public var container:Sprite;
		
		
		public var bgImg:Scale9Image;
		public var soundBtn:Button;
		public var fillUI:AloudExamFillUI;

		public var listenTip:ListenTipUI;
		
		public function ReadAloudExamView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			
			

		}
		private function addToStageHandler(e:Event):void
		{
			var bg:Quad = new starling.display.Quad(880,56,0x4FC8F6);
			bg.x = 10;
			bg.width = 120;
			bg.height = 50;
			bg.touchable = false;
			this.addChild(bg);
			
			listenTip = new ListenTipUI();
			listenTip.x = 537;
			listenTip.y = 427;
			this.addChild(listenTip);
			
			bgImg = new Scale9Image(new Scale9Textures(Assets.readAloudTexture('blackBoardImg'),new Rectangle(250,200,400,40)));
			bgImg.touchable = false;
			bgImg.x = 172;
			bgImg.y = 57;
			this.addChild(bgImg);
			
			container = new Sprite();
			this.addChild(container);
			container.visible = false;
			
			
			
			soundBtn = new Button(Assets.readAloudTexture("soundBtn"));
			soundBtn.x = 146;
			soundBtn.y = 57;
			container.addChild(soundBtn);
			
			fillUI = new AloudExamFillUI();
			container.addChild(fillUI);
		
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		
		
	}
}