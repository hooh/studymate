package com.studyMate.module.engLearn.ui
{
	import com.greensock.TweenLite;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	
	import starling.events.Event;
	
	
	/**
	 * 切换本框
	 * 2014-11-14上午10:08:23
	 * Author wt
	 *
	 */	
	
	public class ChangeEffectLabel extends Label
	{
		private var rect:Rectangle;
		private var value:String;
		
		private var direct:int = 0;
		

		public function ChangeEffectLabel()
		{
			
			rect = new Rectangle();
			
			this.textRendererFactory = function():ITextRenderer{
				return new TextFieldTextRenderer;
			}
			this.textRendererProperties.textFormat = new TextFormat( "HeiTi", 26, 0xffffff,true );
			this.textRendererProperties.embedFonts = true;
			this.wordWrap = true;
			this.maxWidth = 800;
			
			
			this.addEventListener(Event.RESIZE,flatenHandler);
			
			
		}
		
		private function flatenHandler(e:Event):void
		{
			rect.x =0;
			rect.y= 0;
			rect.width = this.width+20;
			rect.height = this.height+20;	
		}
		
		public function updateChange(value:String=null,direct:int=0):void{
			this.value = value;
			this.direct = direct;
			rect.y = 0;
			rect.x = 0;
			if(direct==0){				
				TweenLite.to(rect,0.5,{y:-rect.height,onUpdate:updateHandler,onComplete:onCompleteHandler1});
			}else{
				TweenLite.to(rect,0.5,{x:rect.width,onUpdate:updateHandler,onComplete:onCompleteHandler1});
			}
		}
		
		
		private function updateHandler():void{
			this.clipRect = rect;
		}
		
		override public function dispose():void
		{
			TweenLite.killTweensOf(rect);
			super.dispose();
		}
		
		private function onCompleteHandler1():void{
			if(value)
				text = value;
			if(direct==0){	
				rect.x = 0;
				rect.y = rect.height;
				TweenLite.to(rect,0.5,{y:0,onUpdate:updateHandler});
			}else{
				rect.y = 0;
				rect.x = -rect.width;
				TweenLite.to(rect,0.5,{x:0,onUpdate:updateHandler});
			}

		}
	}
}