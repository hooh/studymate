package com.studyMate.view.component
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DrawSomething extends Sprite
	{
		
		public var drawShape:String="line";
		public var isFilled:Boolean = false;
		public var strokeColor:uint = 0x00ff00;
		public var fillColor:uint = 0xff0000;
		public var thickness:int = 2;
		
		private var doodleShape:Shape;
		private var startX:Number=0;
		private var startY:Number=0;
		
		/**
		 * 
		 * @param drawShape	: 画图形状，"line","rectangle","circle","ellipse","triangle"
		 * @param isFilled	:	形状是否填充
		 * @param strokeColor	:	边框颜色
		 * @param fillColor	:	填充颜色
		 * @param thickness	:	边框粗细
		 * 
		 */
		public function DrawSomething(drawShape:String="line",isFilled:Boolean=false,strokeColor:uint=0x00ff00,fillColor:uint=0xff0000,thickness:int=2)
		{
			this.drawShape = drawShape;
			this.isFilled = isFilled;
			this.strokeColor = strokeColor;
			this.fillColor = fillColor;
			this.thickness = thickness;
			
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		}
		
		protected function removedFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,beginDoodle);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopDoodle);
			stopDoodle(null);
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,beginDoodle);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopDoodle);
		}
		protected function beginDoodle(event:MouseEvent):void
		{
			doodleShape= new Shape;
			this.addChild(doodleShape);
			startX = event.stageX;
			startY = event.stageY;
			doodleShape.graphics.moveTo(event.stageX,event.stageY);
			doodleShape.graphics.lineStyle(2,0xff0000);
			switch(drawShape){
				case "line":
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,drawingLine);
					break;
				case "triangle":
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,drawingTriangle);
					break;
				case "rectangle":
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,drawingRectangle);
					break;
				case "circle":
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,drawingCircle);
					break;
				case "ellipse":
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,drawingEllipse);
					break;
			}
		}
		protected function drawingEllipse(e:MouseEvent):void
		{
			doodleShape.graphics.clear();
			if(isFilled){
				doodleShape.graphics.beginFill(fillColor,0.5);
			}
			doodleShape.graphics.lineStyle(thickness,strokeColor);
			doodleShape.graphics.drawEllipse(startX,startY,e.stageX-startX,e.stageY-startY);
		}
		protected function drawingCircle(event:MouseEvent):void
		{
			var d1:Number = (event.stageX-startX);
			var d2:Number = (event.stageY-startY);
			var r:Number = Math.sqrt(d1*d1+d2*d2);
			doodleShape.graphics.clear();
			if(isFilled){
				doodleShape.graphics.beginFill(fillColor,0.5);
			}
			doodleShape.graphics.lineStyle(thickness,strokeColor);
			doodleShape.graphics.drawCircle(startX,startY,r);
		}
		protected function drawingRectangle(e:MouseEvent):void
		{
			doodleShape.graphics.clear();
			if(isFilled){
				doodleShape.graphics.beginFill(fillColor,0.5);
			}
			doodleShape.graphics.lineStyle(thickness,strokeColor);
			doodleShape.graphics.drawRect(startX,startY,e.stageX-startX,e.stageY-startY);
		}
		protected function drawingTriangle(event:MouseEvent):void
		{
			var c1:Number = (event.stageX-startX);
			var c2:Number = (event.stageY-startY);
			var r:Number = Math.sqrt(c1*c1+c2*c2);
			
			var d1:Number = Math.sin((Math.PI/180)*30)*r;
			var d2:Number = Math.sin((Math.PI/180)*60)*r;
			
			var vertices:Vector.<Number>=new Vector.<Number>();
			vertices.push(startX,startY-r);
			vertices.push(startX+d2,startY+d1);
			vertices.push(startX-d2,startY+d1);
			
			doodleShape.graphics.clear();
			if(isFilled){
				doodleShape.graphics.beginFill(fillColor,0.5);
			}
			doodleShape.graphics.lineStyle(thickness,strokeColor);
			doodleShape.graphics.drawTriangles(vertices);
			
		}
		protected function drawingLine(event:MouseEvent):void
		{
			doodleShape.graphics.lineTo(event.stageX,event.stageY);
		}
		/*private function polyFunc(x:Number, y:Number, r:Number, n:Number)
		{
		var pai = 2 * Math.PI;
		_target.moveTo(r+x, y);
		for (var i = 0; i<pai/n*(n+1); i += pai/n)
		{
		_target.lineTo(Math.cos(i)*r+x, Math.sin(i)*r+y);
		}
		}*/
		protected function stopDoodle(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,drawingLine);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,drawingTriangle);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,drawingRectangle);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,drawingCircle);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,drawingEllipse);
		}
	}
}