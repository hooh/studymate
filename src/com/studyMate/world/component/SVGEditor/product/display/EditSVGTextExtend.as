package com.studyMate.world.component.SVGEditor.product.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 对原有文本进行扩展.使其可以有边框
	 * @author wt
	 * 
	 */	
	internal class EditSVGTextExtend extends EditSVGText
	{
		protected var scaleRect:Sprite;//缩放滑块
		
		public function EditSVGTextExtend()
		{
			super();
		}
		override protected function removeStageHandler(event:Event):void
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawing);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDraw);
			super.removeStageHandler(event);

		}
		
		override protected function render(e:Event=null):void
		{
			super.render(e);
			
			if(scaleRect==null){
				scaleRect = new Sprite();
				scaleRect.graphics.clear();
				scaleRect.graphics.beginFill(0x123456);
				scaleRect.graphics.drawRect(0,0,15,15);
				scaleRect.graphics.endFill();
				this.addChild(scaleRect);
				scaleRect.addEventListener(MouseEvent.MOUSE_DOWN,scaleMouseDownHandler);
			}
			scaleRect.x = textField.width;
			scaleRect.y = 0;
		}
		protected function scaleMouseDownHandler(event:MouseEvent):void
		{
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
				
				//Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);
			}
		}		
		protected function stopDraw(event:MouseEvent):void
		{
			scaleRect.visible = true
			dragRect.visible = true;
			//设置拖动遮罩范围
			dragRect.width = textField.width;
			dragRect.height = textField.height;
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDraw);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawing);
		}
		
		
		public function draw(xx:Number, yy:Number):void
		{
			if(textField){
				textField.width = xx;
//				textField.height = yy;
//				trace("宽度："+width);
				
				scaleRect.x = xx;
				scaleRect.y = 0;
			}
		}
	}
}