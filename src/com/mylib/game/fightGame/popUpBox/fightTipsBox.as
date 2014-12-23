package com.mylib.game.fightGame.popUpBox
{
	import com.byxb.utils.centerPivot;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class fightTipsBox extends Sprite
	{
		
		private var textField:TextField;
		
		public function fightTipsBox()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			
			
			var bg:Image = new Image(Assets.getFightGameTexture("popTipsBg"));
			addChild(bg);
			
			textField = new TextField(277,80,"","HeiTi",20,0x6e421b,true);
			textField.x = 30;
			textField.y = 40;
			textField.hAlign = HAlign.CENTER;
			textField.vAlign = VAlign.CENTER;
//			textField.nativeFilters = [new DropShadowFilter(1,90,0xffffff,0.75,0,0,10)];
			textField.nativeFilters = [new GlowFilter(0xffffff,1,5,5,20)];
//			textField.border = true;
			addChild(textField);
			
			
			closeBtn = new Button(Assets.getFightGameTexture("closeBtn"));
			closeBtn.x = 87;
			closeBtn.y = 126;
			closeBtn.visible = false;
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			addChild(closeBtn);
			
			yesBtn = new Button(Assets.getFightGameTexture("yesBtn"));
			yesBtn.x = 186;
			yesBtn.y = 126;
			yesBtn.addEventListener(Event.TRIGGERED,yesBtnHandle);
			addChild(yesBtn);
			
			
			this.visible = false;
			centerPivot(this);
			x = 640;
			y = 350;
			
			
		}
		private var yesBtn:Button;
		private var closeBtn:Button;
		private function closeBtnHandle(e:Event):void{
			
			this.visible = false;
			
		}
		private function yesBtnHandle(e:Event):void{
			
			//有进入函数处理
			if(enterFun){
				if(enterFunParams)
					enterFun(enterFunParams);
				else
					enterFun();
			}
			
			this.visible = false;
		}
		
		private var enterFun:Function;
		private var enterFunParams:*;
		public function showBox(_text:String,_enterFun:Function = null,_enterFunParams:* = null):void{
			
			textField.text = _text;
			enterFun = _enterFun;
			enterFunParams = _enterFunParams;
			
			//有进入函数，则有2个按钮，否则1个按钮
			if(enterFun) setBtn(true);
			else	setBtn(false);
			
			this.visible = true;
		}
		private function setBtn(_hasEnter:Boolean):void{
			if(_hasEnter){
				closeBtn.visible = true;
				yesBtn.x = 186;
			}else{
				closeBtn.visible = false;
				yesBtn.x = 136;
			}
			
			
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