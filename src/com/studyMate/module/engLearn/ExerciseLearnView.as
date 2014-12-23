package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.game.beetleGame.WanderBeetle;
	import com.studyMate.global.AppLayoutUtils;
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollText;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	
	public class ExerciseLearnView extends Sprite
	{
		public var input:TextFieldHasKeyboard;
		public var idTxt:TextField;			
		public var titleNumTxt0:TextField;//第几题/一共多少题
		public var titleNumTxt:TextField;//第几题/一共多少题
		public var yesRightImg:Image;
		public var tipHolder:Sprite;
		public var tipTxt:ScrollText;
		public var unknownBtn:Button;
		private var wanderBeetle:WanderBeetle;
		
		private var showBoo:Boolean;
		
		public function ExerciseLearnView()
		{
			
		}
		
		public function init():void{
			var texture:Image = new Image(Assets.getTexture("ExercisesLearn_BG"));
			texture.blendMode = BlendMode.NONE;
			texture.touchable = false;
			this.addChild(texture);	
			
			wanderBeetle = new WanderBeetle(100,30,new Rectangle(0,0,300,50));
			this.addChild(wanderBeetle.view);
			wanderBeetle.start();
			
			unknownBtn = new Button(Assets.getEgAtlasTexture("word/questionMark"));//问号
			unknownBtn.x = 50;
			unknownBtn.y = 440;
			this.addChild(unknownBtn);
			
			var tf:TextFormat = new TextFormat("HeiTi",34);
			input = new TextFieldHasKeyboard();
//			input.border = true;
			input.restrict = "^`\\\\";
			input.softKeyboardRestrict = /[^`\\\\]/;
			input.x = 128;
			input.y = 446;
			input.prompt = '请输入答案'
			input.width = 1085;
			input.height = 60;
			input.maxChars = 100;
			input.defaultTextFormat = tf;
			AppLayoutUtils.cpuLayer.addChild(input);
			
			idTxt = new TextField(77,26,'',"HeiTi")
			idTxt.x = 500;
			idTxt.y = 0;
			idTxt.touchable = false;
			this.addChild(idTxt);
			
			titleNumTxt0 = new TextField(46,25,'','HeiTi',22,0xfe6b12);
			titleNumTxt0.x = 52;
			titleNumTxt0.y = 86;
			titleNumTxt0.touchable = false;
			this.addChild(titleNumTxt0);
			
			titleNumTxt = new TextField(36,25,'','HeiTi',22,0x9D582C);
			titleNumTxt.x = 88;
			titleNumTxt.y = 86;
			titleNumTxt.touchable = false;
			this.addChild(titleNumTxt);
			
			yesRightImg = new Image(Assets.getEgAtlasTexture("word/YesRight"));
			yesRightImg.x = 314;
			yesRightImg.y = 447;
			yesRightImg.alpha = 0;
			yesRightImg.touchable = false;
			this.addChild(yesRightImg);
			
			
			/**
			 * ---------------------提示框信息----------------------*/			 
			tipHolder = new Sprite();
			tipHolder.x = 337;
			tipHolder.y = 695;
			this.addChild(tipHolder);
			
			var tipsImg:Image = new Image(Assets.getEgAtlasTexture("word/exerciseBottom"));
			tipsImg.touchable = false;
			tipHolder.addChild(tipsImg);
			
			tipTxt = new ScrollText();
			tipHolder.addChild(tipTxt);
			tipTxt.width = 545;
			tipTxt.height = 206;
			tipTxt.x = 24;
			tipTxt.y = 64;
			
			tipTxt.isHTML = true;
			tipTxt.textFormat = new TextFormat('HeiTi',20,0x123456);
			tipTxt.embedFonts = true;

			var bottomBtn:Quad = new Quad(133,50,0);
			bottomBtn.x = 224;
			bottomBtn.y = 5;
			bottomBtn.alpha = 0;
			tipHolder.addChild(bottomBtn);	
			bottomBtn.addEventListener(TouchEvent.TOUCH,tipTounchHandler);
		}
		
		private function tipTounchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				if(showBoo){
					hideTip();
				}else{
					showTip();
				}
				
			}
		}
		//显示提示
		public function showTip():void{
			if(showBoo!= true){				
				showBoo = true;
				TweenLite.killTweensOf(tipHolder);
				TweenLite.to(tipHolder,0.4,{y:482});
			}
		}
		//隐藏提示
		public function hideTip():void{
			if(showBoo!= false){				
				showBoo = false;
				TweenLite.killTweensOf(tipHolder);
				TweenLite.to(tipHolder,0.4,{y:695});
			}			
		}
		
		override public function dispose():void
		{
			wanderBeetle.dispose();
			if(input){
				AppLayoutUtils.cpuLayer.removeChild(input);
				
			}
			if(tipHolder){
				TweenLite.killTweensOf(tipHolder);
			}
			super.dispose();
		}
		
	}
}