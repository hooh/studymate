package com.studyMate.world.component.SVGEditor.product.display
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditGraph;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	

	internal class EditSVGGraphBase extends EditSVGBase implements IEditGraph
	{
		protected var color:uint;
		protected var scaleRect:Sprite;//缩放滑块
		
		private var _graphicSP:DisplayObject;//绘图对象	
		
		
		public function EditSVGGraphBase()
		{
			super();
		}

		public function get graphicSP():DisplayObject
		{
			return _graphicSP;
		}

		public function set graphicSP(value:DisplayObject):void
		{
			_graphicSP = value;
		}

		override protected function removeStageHandler(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawing);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDraw);
			super.removeStageHandler(event);
		}
		
		public function begin(xx:Number, yy:Number):void { }//开始绘图
		
		public function draw(xx:Number, yy:Number):void { }	//结束绘图，由子类自己去定义
		
		override protected function render(e:Event=null):void
		{
			if(scaleRect==null){
				scaleRect = new Sprite();
				scaleRect.graphics.clear();
				scaleRect.graphics.beginFill(0x123456);
				scaleRect.graphics.drawRect(0,0,15,15);
				scaleRect.graphics.endFill();
				this.addChild(scaleRect);
				scaleRect.addEventListener(MouseEvent.MOUSE_DOWN,scaleMouseDownHandler);
			}
			scaleRect.x = graphicSP.x + graphicSP.width;
			scaleRect.y = graphicSP.x + graphicSP.height;
			
			
			if(dragRect ==null){
				dragRect = new Sprite();
				dragRect.graphics.clear();
				dragRect.graphics.lineStyle(2,0x8080FF);
				
//				trace(this.width);
//				trace(this.height);
				drawDashed(dragRect.graphics,new Point(graphicSP.x,graphicSP.y),new Point(graphicSP.x+graphicSP.width,graphicSP.y));
				drawDashed(dragRect.graphics,new Point(graphicSP.x,graphicSP.y),new Point(graphicSP.x,graphicSP.height+graphicSP.y));
				drawDashed(dragRect.graphics,new Point(graphicSP.x,graphicSP.height+graphicSP.y),new Point(graphicSP.width+graphicSP.x,graphicSP.height+graphicSP.y));
				drawDashed(dragRect.graphics,new Point(graphicSP.x+graphicSP.width,graphicSP.y),new Point(graphicSP.width+graphicSP.x,graphicSP.height+graphicSP.y));
				this.addChild(dragRect);
			}
			
			super.render(e);
		}
		
		protected function scaleMouseDownHandler(event:MouseEvent):void
		{
			this.begin(0,0);
			scaleRect.visible = false
			dragRect.visible = false;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawing);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopDraw);
		}						
		
		private function drawing(e:MouseEvent):void 
		{
			//鼠标移动时，调用绘制对象的draw方法
			if(this.mouseX>1 && this.mouseY>1){
				this.draw(this.mouseX, this.mouseY);
				
				Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);
			}
		}		
		protected function stopDraw(event:MouseEvent):void
		{
			scaleRect.visible = true
			dragRect.visible = true;
			//设置拖动遮罩范围
			dragRect.width = graphicSP.width;
			dragRect.height = graphicSP.height;
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDraw);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawing);
		}
		
		//绘图类重写基类的拖动滑块。
		override protected function setDragFunc():void
		{			
			graphicSP.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);//拖动使用
		}	
		
		protected function drawDashed(graphics:Graphics,p1:Point,p2:Point,length:Number=5,gap:Number=5):void  
		{   
			var max:Number = Point.distance(p1,p2);   
			var l:Number = 0;   
			var p3:Point;   
			var p4:Point;   
			while(l<max)   
			{   
				p3 = Point.interpolate(p2,p1,l/max);   
				l+=length;   
				if(l>max)l=max   
				p4 = Point.interpolate(p2,p1,l/max);   
				graphics.moveTo(p3.x,p3.y)   
				graphics.lineTo(p4.x,p4.y)   
				l+=gap;   
			}   
		} 
	}
}