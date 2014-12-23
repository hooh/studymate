package com.mylib.game.drawing
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class DrawingBoard extends Sprite
	{
		private var canvas:flash.display.Sprite;
		private var canvasBG:flash.display.Sprite;
		private var isOut:Boolean;
		
		public var color:uint;
		
		
		public function DrawingBoard()
		{
			init();
		}
		
		
		private function init():void{
			canvas = new flash.display.Sprite;
			canvas.mouseChildren = canvas.mouseEnabled = false;
			canvasBG = new flash.display.Sprite;
			
			canvasBG.graphics.beginFill(0xeeeeee);
			canvasBG.graphics.drawRect(0,0,400,400);
			canvasBG.graphics.endFill();

			addChild(canvasBG);
			addChild(canvas);
			
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,beginDrawHandle);
			
		}
		
		public function clean():void{
			
			
			canvas.graphics.clear();
		}
		
		
		public function set enable(_e:Boolean):void{
			
			if(_e){
				Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,beginDrawHandle);
			}else{
				Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,beginDrawHandle);
				canvasBG.removeEventListener(MouseEvent.MOUSE_MOVE,drawHandle);	
				Global.stage.removeEventListener(MouseEvent.MOUSE_UP,endDrawHandle);	
				canvasBG.removeEventListener(MouseEvent.MOUSE_OUT,outHandle);	
			}
			
			
			
		}
		
		
		protected function endDrawHandle(event:MouseEvent):void
		{
			canvasBG.removeEventListener(MouseEvent.MOUSE_MOVE,drawHandle);	
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,endDrawHandle);	
			canvasBG.removeEventListener(MouseEvent.MOUSE_OUT,outHandle);	
		}
		
		protected function drawHandle(event:MouseEvent):void
		{
			
			if(isOut){
				isOut = false;
				canvas.graphics.moveTo(event.localX,event.localY);
			}else{
				canvas.graphics.lineTo(event.localX,event.localY);
			}
			
		}
		
		
		public function get data():Vector.<IGraphicsData>{
			return canvas.graphics.readGraphicsData();
		}
		
		
		
		protected function beginDrawHandle(event:MouseEvent):void
		{
			
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,endDrawHandle);	
			canvasBG.addEventListener(MouseEvent.MOUSE_MOVE,drawHandle);	
			canvasBG.addEventListener(MouseEvent.MOUSE_OUT,outHandle);	
			canvas.graphics.lineStyle(5,color);
			
			isOut = true;
			
			
		}
		
		protected function outHandle(event:MouseEvent):void
		{
			isOut = true;
		}
	}
}