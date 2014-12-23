package com.mylib.game.fightGame.popUpBox
{
	import com.byxb.utils.centerPivot;
	import myLib.myTextBase.GpuTextInput;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import feathers.events.FeathersEventType;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class fightInputBox extends Sprite
	{
		
		private var inputTF:GpuTextInput;
		
		public function fightInputBox()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			
			
			var bg:Image = new Image(Assets.getFightGameTexture("popInputBg"));
			bg.y = 24;
			addChild(bg);

			
			inputTF = new GpuTextInput();
			inputTF.x = 40;
			inputTF.y = 93;
			inputTF.maxChars = 3;
			inputTF.restrict = "0-9";
			inputTF.width = 150; 
			inputTF.height = 48;
			addChild(inputTF);
			inputTF.setTextFormat(new TextFormat("HeiTi",23));
			inputTF.prompt = "请输入ID号";
			inputTF.addEventListener(FeathersEventType.ENTER,inputTFHandle);
			
			
			var closeBtn:Button = new Button(Assets.getFightGameTexture("closeBtn"));
			closeBtn.x = 332;
			closeBtn.y = 3;
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			addChild(closeBtn);
			
			var enterBtn:Button = new Button(Assets.getFightGameTexture("applyFightBtn"));
			enterBtn.x = 224;
			enterBtn.y = 81;
			enterBtn.addEventListener(Event.TRIGGERED,enterBtnHandle);
			addChild(enterBtn);
			
			
			
			this.visible = false;
			centerPivot(this);
			x = 640;
			y = 350;
			
			
		}
		private function closeBtnHandle(e:Event):void{
			inputTF.text = "";
			this.visible = false;
			
		}
		private function enterBtnHandle(e:Event):void{
			if(StringUtil.trim(inputTF.text) == "")
				return;
			
			//有进入函数处理
			if(enterFun){
				enterFun(inputTF.text);
			}
			
			inputTF.text = "";
			this.visible = false;
		}
		private function inputTFHandle(e:Event):void{
			enterBtnHandle(null);
			
		}
		
		private var enterFun:Function;
		public function showBox(_enterFun:Function):void{
			
			enterFun = _enterFun;

			this.visible = true;
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			enterFun = null;

			removeChildren(0,-1,true);
		}
	}
}