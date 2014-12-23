package com.studyMate.module.engLearn.ui
{	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * note
	 * 2014-11-17上午10:19:34
	 * Author wt
	 *
	 */	
	
	public class ListenTipUI extends Sprite
	{
		public var listenTip:Image;
		private var rect:Rectangle;
		
		
		public function ListenTipUI()
		{
			super();
			rect = new Rectangle();
			addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler():void
		{
			rect.width = 302;
			rect.height = 302;
			rect.y = -300;
			listenTip = new Image(Assets.readAloudTexture("listenTip"));
			listenTip.pivotY = 300;
			this.addChild(listenTip);
		}
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(value){				
				startMove();
				TweenMax.to(listenTip,0.8,{scaleY:0.95,yoyo:true,repeat:200,ease:Linear.easeInOut});
			}else{
				TweenMax.killTweensOf(listenTip);
				TweenLite.killTweensOf(rect);
			}
		}
		
		override public function dispose():void
		{
			TweenMax.killTweensOf(listenTip);
			TweenLite.killTweensOf(rect);
			super.dispose();
		}
		
		private function startMove():void{
			rect.x = -90;
			TweenLite.to(rect,1,{x:0,onUpdate:updateHandler,onComplete:onCompleteHandler1});
		}
		
		private function updateHandler():void{
			this.clipRect = rect;
		}
		private function onCompleteHandler1():void{
			startMove();
		}
		
	}
}