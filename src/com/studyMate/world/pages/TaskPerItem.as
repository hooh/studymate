package com.studyMate.world.pages
{
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class TaskPerItem extends Sprite
	{
		private var bg:Image;
		private var textField:TextField;
		private var starNum:int;
		
		private var onTouchBeginX:int;
		private var onTouchEndX:int;
		
		public function TaskPerItem(rrl:String,timeBegin:String,learnSec:String,rightNum:String,totalNum:String){
			bg = new Image(Assets.getAtlasTexture("task/bg"));
			addChild(bg);
			textField = new TextField(185,26,rrl,"HK",26,0xff9c00);
			textField.y = 60;
			addChild(textField);
			textField = new TextField(185,26,rightNum+" / "+totalNum,"HK",26,0xff9c00);
			textField.y = 106;
			starNum = 3;
			var star:Image;
			for(var i:int=0; i<starNum; i++){
				star = new Image(Assets.getAtlasTexture("task/star"));
				star.x = 40*i+36;
				star.y = bg.height-26;
				addChild(star);
			}
			addEventListener(TouchEvent.TOUCH,touchHandle);
		}
		
		private function touchHandle(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.target as DisplayObject);
//			var touch:Touch = e.touches()[0];
			
			if(touch.phase == TouchPhase.BEGAN){
				onTouchBeginX = touch.globalX;
			}
			if(touch.phase == TouchPhase.ENDED){
				onTouchEndX = touch.globalX;
				if(Math.abs(onTouchBeginX - onTouchEndX) < 10){
					trace("Touch Me !");
				}
			}
			
/*			if(e.getTouch(this,TouchPhase.BEGAN)){
				onTouchX = e.target.
			}else if(e.getTouch(this,TouchPhase.MOVED)){
			}else if(e.getTouch(this,TouchPhase.ENDED)){
				trace("You TOUCH me!");
			}*/
/*			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.STATIONARY){
				trace("1");
			}*/
		}
	}
}