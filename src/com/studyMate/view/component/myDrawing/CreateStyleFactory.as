package com.studyMate.view.component.myDrawing
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.view.component.myDrawing.graph.GraphBase;
	import com.studyMate.view.component.myDrawing.styles.StyleBase;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class CreateStyleFactory
	{		
		private var dotArr:Array=[];
		
		private var styleProduct:StyleBase;
		
		private var textField:TextField;
		
		public function CreateStyleFactory(target:TextField)
		{
			textField = target;
			textField.addEventListener(Event.REMOVED_FROM_STAGE,removeToStageHandler);
		}
		
		private function addToStageHandler(e:Event):void{
			textField.stage.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
		}
		private function removeToStageHandler(e:Event):void{
			if(textField.stage.hasEventListener(MouseEvent.MOUSE_DOWN))
				textField.stage.removeEventListener(MouseEvent.MOUSE_DOWN, startDraw);
		}
		
		private function startDraw(e:MouseEvent):void{			
			styleProduct = this.factoryMethodStyle();
			var point:Point = textField.globalToLocal(new Point(e.stageX,e.stageY));			
			
			styleProduct.begin(point.x,point.y);
			if(styleProduct.startChar==-1){
				return;
			}
			
			textField.stage.addEventListener(MouseEvent.MOUSE_UP, stopDraw,false,3);
			textField.stage.addEventListener(MouseEvent.MOUSE_MOVE, drawing);
		}
		
		
		private function drawing(e:MouseEvent):void 
		{
			var point:Point = textField.globalToLocal(new Point(e.stageX,e.stageY));
			styleProduct.draw(point.x,point.y);	
		}
		
		private function stopDraw(e:MouseEvent):void 
		{
			if(styleProduct.flag){
				e.stopImmediatePropagation();
			}
			styleProduct.end();
			
			saveDotPosition();
			
			textField.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraw);
			textField.stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawing);		
		}
		
		private function saveDotPosition():void{
			var str:String = dotArr.join(",");
			var configProxy:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY) as IConfigProxy;
			configProxy.updateValue("DotPosition",str);
		}
		
		
		
		//停止
		public function stop():void{
			removeToStageHandler(null);			
		}
		//启动
		public function start():void{
			addToStageHandler(null);
		}
		//刷新
		public function update():void{
			var configProxy:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY) as IConfigProxy;
			var dotStr:String = configProxy.getValue("DotPosition");//文字大小
			var arr:Array = dotStr.split(",");
			for(var i:* in arr){
				trace("存贮的点阵"+arr[i]);
			}
			
		}
		
		
		/**-----------------------抽象方法(必须在子类中重写)-----------------------------*/   
		protected function factoryMethodDraw():GraphBase {  
			throw new IllegalOperationError("抽象方法必须子类继承，绘图类");  
			return null;  
		} 
		protected function factoryMethodStyle():StyleBase {  
			throw new IllegalOperationError("抽象方法必须子类继承，样式类");  
			return null;  
		} 
	}  
}