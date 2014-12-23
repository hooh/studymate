package com.studyMate.world.screens.wordcards
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class UnrememberWordCardMediatorView extends Sprite
	{
		
		private var background:Image;
		private var cloud1:Image;
		private var cloud2:Image;
		private var cloud3:Image;
		
		private var dragonfly:Image;
		private var rainDrop:Raindrop;
		
		
		
		public var studyWordBtn:starling.display.Button;
		public var studyWordResultBtn:starling.display.Button;	
		public var rememberCardBtn:starling.display.Button;
		public var unrememberCardBtn:starling.display.Button;
		public var rivierBackground:RiverBgParallaxSprite;
		public var camera:CameraSprite;
		public var startBtn:starling.display.Button;
		public var backBtn:starling.display.Button;
		public var randomBtn:starling.display.Button
		public var discardHolder:starling.display.Sprite;
		public var cardHolder:starling.display.Sprite;



		private var bgVec:Vector.<flash.display.DisplayObject> ;
		private var showStr:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890[]:'-"


		public var remember:Image;
		public var symbol:TextField;
		public var wordMean:TextField;
		public var wrongNum:TextField;
		public var turnBtn:starling.display.Button;
		public var voiceBtn:starling.display.Button;
		
		override public function dispose():void
		{
			super.dispose();
			TweenLite.killTweensOf(cloud1);
			TweenLite.killTweensOf(cloud2);
			TweenLite.killTweensOf(cloud3);
			TweenLite.killTweensOf(dragonfly);
			TweenLite.killDelayedCallsTo(dropTime);
			TweenLite.killTweensOf(rainDrop);
		}
		
		public function UnrememberWordCardMediatorView()
		{
			
			
			background = new Image(Assets.getTexture("wordBackground"));
			background.blendMode = BlendMode.NONE;
			background.touchable = false;
			addChild(background);
			
			
//			MarkMediator.addMask(null,background);

			
			rivierBackground = new RiverBgParallaxSprite();
			rivierBackground.touchable = false;
			rivierBackground.y = -400;
			
			camera = new CameraSprite(new Rectangle(0,0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			camera.y =300;
			addChild(camera);
			camera.addChild(rivierBackground);
			
			creatRainDrop();
			
			cloud1 = new Image(Assets.getWordCardAtlasTexture("cloud"));
			cloud1.x = 150;
			cloud1.y = 30;
			addChild(cloud1);
			cloud2 = new Image(Assets.getWordCardAtlasTexture("cloud"));
			cloud2.x = 800;
			cloud2.y = 30;
			addChild(cloud2);
			
			cloud3 = new Image(Assets.getWordCardAtlasTexture("cloud3"));
			cloud3.x = 50;
			cloud3.y = 25;
			addChild(cloud3);
			
			dragonfly = new Image(Assets.getWordCardAtlasTexture("dragonfly"));
			dragonfly.x = 1050;
			dragonfly.y = 350;
			addChild(dragonfly);
			
			studyWordBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("studyWord"));
			studyWordBtn.x = 500;
			studyWordBtn.y = 150;
			addChild(studyWordBtn);
			
			studyWordResultBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("studyResultBtn"));
			studyWordResultBtn.x = 20;
			studyWordResultBtn.y = 20;
			addChild(studyWordResultBtn);
			
			rememberCardBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("rememberBtn"));
			rememberCardBtn.x = 1210;
			rememberCardBtn.y = 350;
			rememberCardBtn.alpha = 0;
			addChild(rememberCardBtn);
			
			unrememberCardBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("unrememberBtn"))
			unrememberCardBtn.x = 1150;
			unrememberCardBtn.y = 350;
			unrememberCardBtn.alpha = 0;
			addChild(unrememberCardBtn);
			
			startBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("startBtn"));
			startBtn.x = 560;
			startBtn.y = 150;
			startBtn.alpha = 0;
			startBtn.filter = filter;
			startBtn.touchable = false;
			addChild(startBtn);
			
			backBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("backBtn"));
			backBtn.x = 20;
			backBtn.y = 20;
			backBtn.visible = false;
			addChild(backBtn);

			randomBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("randomBtn"));
			randomBtn.x = 100;
			randomBtn.y = 20;
			randomBtn.visible = false;
			addChild(randomBtn);
			
			cardHolder = new starling.display.Sprite;

			wordCardBg();
			
			discardHolder = new starling.display.Sprite;
			addChild(discardHolder);
			
			camera.addChild(cardHolder);
			
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
		}
		
		private function wordCardBg():void
		{
			turnBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("warningBtn"));
			turnBtn.x = 360;
			turnBtn.y = 20;
			
			voiceBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("playBtn"));
			voiceBtn.x = 105;
			voiceBtn.y = 220;
			voiceBtn.scaleX = 1.1;
			voiceBtn.scaleY = 1.1;
			
			remember = new Image(Assets.getWordCardAtlasTexture("getWord"))
			remember.x = 25;
			remember.y = 100;
			remember.scaleX = 0.8;
			remember.scaleY = 0.8;
			
			symbol = new TextField(200,200,"","arial",32,0,true)
			symbol.x = 155;
			symbol.y = 220;
			symbol.vAlign = VAlign.TOP;
			symbol.hAlign = HAlign.LEFT;
			
			wordMean = new TextField(200,200,"","HeiTi",36,0,true);
			wordMean.hAlign = HAlign.LEFT;
			wordMean.vAlign = VAlign.TOP;
			wordMean.x = 0;
			wordMean.y = -150
			
			wrongNum = new TextField(200,200,"","HeiTi",48,0xe69a92,true)
			wrongNum.hAlign = HAlign.LEFT;
			wrongNum.vAlign = VAlign.TOP;
			wrongNum.x = 270;
			wrongNum.y = 100;
			
			bgVec = new Vector.<flash.display.DisplayObject>;
			
			var wordCardBmp1:Bitmap = new Bitmap(Assets.store["wordCard"].bitmapData);
			wordCardBmp1.name = "bg";
			bgVec.push(wordCardBmp1);
			
			var wordCardBmp2:Bitmap = new Bitmap(Assets.store["wordCarded"].bitmapData);
			wordCardBmp2.name ="green";
			bgVec.push(wordCardBmp2)
			
			BitmapFontUtils.init(showStr,bgVec,new TextFormat("HeiTi",80,0,false,false,null,null,null,"center"));
		}
		
		private function addedToStageHandler():void
		{
			TweenLite.to(cloud3,470,{x:1300});
			TweenLite.to(cloud1,450,{x:1300});
			TweenLite.to(cloud2,150,{x:1300});
			TweenMax.to(dragonfly, 10, {transformAroundCenter:{x:1050, y:350},alpha:1,yoyo:true,repeat:int.MAX_VALUE});
		}		
		
		private var drop:Boolean;
		private function creatRainDrop():void
		{
			rainDrop = new Raindrop();
			rainDrop.x = 0;
			rainDrop.y = -660;
			rainDrop.width = 3500;
			rainDrop.touchable = false;
			camera.addChild(rainDrop);
			TweenLite.delayedCall(30,dropTime);
		}		
		
		private function dropTime():void
		{
			if(!drop){
				TweenLite.to(rainDrop,6,{alpha:0,onComplete:stopDrop});
			}else{
				rainDrop.alpha = 1;
				rainDrop.start();
				drop = false;
				TweenLite.killDelayedCallsTo(dropTime);
				TweenLite.delayedCall(30,dropTime);
			}
		}
		
		private function stopDrop():void
		{
			rainDrop.stop(false);
			drop = true
			TweenLite.killTweensOf(rainDrop);
			TweenLite.killDelayedCallsTo(dropTime);
			TweenLite.delayedCall(20,dropTime);
		}
		
		
	}
}