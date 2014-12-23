package com.studyMate.view.component.myDrawing
{
	import com.studyMate.controller.ConfigProxy;
	import com.studyMate.view.component.myDrawing.graph.GraphBase;
	import com.studyMate.view.component.myDrawing.graph.ToolPanel;
	import com.studyMate.view.component.myDrawing.helpFile.LineInfo;
	import com.studyMate.view.component.myDrawing.helpFile.UnionPoint;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import spark.core.SpriteVisualElement;
	
	public class CreateDrawFactory extends SpriteVisualElement
	{
		private var ww:Number;//画布宽，转位图时使用
		private var hh:Number;//画布高，同上
					
		private var color:uint;//当前颜色
		
		private var canvas:Sprite;//所有绘制对象都加载在canvas里，方便整体操作
		public static var backBmp:Bitmap;//backCanvas里的Bitmap,供橡皮擦擦除使用tempProduct
		private var backBmd:BitmapData;//backCanvas里的BitmapData
		private var allCanvas:Sprite;//包含canvas和backCanvas，用于保存图片时draw位图
		
		private var _textField:TextField;
		
		private var startChar:int;//因为上下滑动。starChar可变
		private var tempStarChar:int;//为鼠标第一次店家的坐标索引
		private var startLine:int;//begin开始行
		private var currentLine:int=-1;//当前处理行
		private var endChar:int;		
		private var dotArr:Array=[];//数据存储
		
		private var tempProduct:GraphBase;		
		private var endY:Number;
								
		public function CreateDrawFactory(textfield:TextField,color:uint=0){
			textField = textfield;
			this.color = color;
			this.ww = textField.width;
			this.hh = textField.height;
			
			textField.addEventListener(Event.REMOVED_FROM_STAGE,removeToStageHandler);
			
			allCanvas = new Sprite();//初始化backCanvas
			this.addChild(allCanvas);
			backBmd = new BitmapData(ww, hh, true, 0);
			backBmp = new Bitmap(backBmd);
			allCanvas.addChild(backBmp);
			
			//设置遮罩，将画在画布外的东西隐藏起来
			var maskSprite:Shape = new Shape();
			maskSprite.graphics.beginFill(0);
			maskSprite.graphics.drawRoundRect(2, 2, ww-4, hh-4, 10, 10);
			maskSprite.graphics.endFill();
			allCanvas.addChild(maskSprite);
			canvas = new Sprite();
			allCanvas.addChild(canvas);
			canvas.mask = maskSprite;	
		}
		
		private function addToStageHandler(e:Event):void{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
		}
		private function removeToStageHandler(e:Event):void{
			if(stage.hasEventListener(MouseEvent.MOUSE_DOWN)){
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			}
			backBmp.bitmapData.dispose();
			backBmp.bitmapData = null;
			backBmp = null;
		}
		
		private function startDraw(e:MouseEvent):void{											
			startChar = textField.getCharIndexAtPoint(this.mouseX,this.mouseY);
			if(startChar != -1){
				tempStarChar = startChar;
				startLine = textField.getLineIndexOfChar(startChar);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, stopDraw,false,3);
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, drawing);
			}		
		}
						
		private function drawing(e:MouseEvent):void {//鼠标移动时，调用绘制对象的draw方法					
			var currentChar:int = textField.getCharIndexAtPoint(this.mouseX,this.mouseY);			
			if(currentChar != endChar && currentChar != -1){//滑动的是字符 && 字符不是老字符，则进入画线
				if(currentChar<tempStarChar){	
					endChar = tempStarChar;
					startChar = currentChar;						
				}else{
					endChar = currentChar;//则赋值
				}
				
				var tempLine:int = textField.getLineIndexOfChar(currentChar);//当前行
				if(tempLine != currentLine){//当前行不是老行，进入生产新的绘图sprite						
					/**--------------------------上一个绘制对象--------------------------------------*/
					if(tempProduct){//上一个绘制sprite，补满原先的
						var oldStart:int = textField.getLineOffset(currentLine);
						var oldtRect:Rectangle = textField.getCharBoundaries(oldStart);
						if(currentChar<tempStarChar){	//如果是向上画线
							tempProduct.draw(2,ToolPanel.getEndY(oldtRect));
						}else{
							tempProduct.draw(textField.width,ToolPanel.getEndY(oldtRect));
						}							
					}						
					
					currentLine = tempLine;//则赋值,当前行
					
					/**--------------------------新的绘制对象--------------------------------------*/
					tempProduct = this.factoryMethodDraw(color);//这是生产方法
					canvas.addChild(tempProduct);
					
					var tempRect:Rectangle = textField.getCharBoundaries(currentChar);
					endY = ToolPanel.getEndY(tempRect);					
											
					if(tempLine==startLine){//如果是第一行
						tempProduct.begin(this.mouseX,ToolPanel.getStartY(tempRect));
					}else{//否则非第一行
						var tempStart:int = textField.getLineOffset(tempLine);//该行第一个字符索引
						var startRect:Rectangle;
						if(currentChar<tempStarChar){	//如果是向上画线
							var lineLength:int = textField.getLineLength(tempLine);//改行长度
							startRect = textField.getCharBoundaries(tempStart+lineLength-2);//括号内为--改行最后一个字符索引
						}else{
							startRect = textField.getCharBoundaries(tempStart)
						}
						
						tempProduct.begin(startRect.x,ToolPanel.getStartY(startRect));
					}						
				}else{////当前行是老行，进入直接进行绘图sprite
					if(tempProduct){
						tempProduct.draw(this.mouseX,endY);
					}						
				}
			}
		}
		
		private function stopDraw(e:MouseEvent):void {
			tempProduct = null;
			saveDotPosition();
			stopDrawUpdate();
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraw);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawing);		
		}						
		private function saveDotPosition():void{
			var dotObj:Object={type:ToolPanel.currentTool,data:{startChar:startChar,endChar:endChar}};
			dotArr.push(dotObj);
			var str:String = JSON.stringify(dotArr);
			//trace(str);
			var configProxy:ConfigProxy = Facade.getInstance(ApplicationFacade.CORE).retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			configProxy.updateValue("DotPosition",str);
		}
		private function stopDrawUpdate():void{
			var vec:Vector.<LineInfo> = UnionPoint.coordSys(textField,startChar,endChar);
			while (canvas.numChildren > 0) {
				canvas.removeChildAt(0);
			}	
			for each(var point:LineInfo in vec){
				if(point){
					var product:GraphBase = this.factoryMethodDraw(color);//这是生产方法 
					product.begin(point.startPoint.x,point.startPoint.y);
					product.draw(point.endPoint.x,point.endPoint.y);
					canvas.addChild(product);
				}
				
			}
			setBitmap();
		}
				
		//清除
		public function clear(evt:MouseEvent = null):void {
			while (canvas.numChildren > 0) {
				canvas.removeChildAt(0);
			}			
			
			backBmd = new BitmapData(ww, hh, true, 0);//清掉backCanvas的内容					
			backBmp.bitmapData = backBmd;
		}
		
		
		//停止
		public function stop():void{
			if(stage.hasEventListener(MouseEvent.MOUSE_DOWN)){
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			}			
		}
		//启动
		public function start():void{
			addToStageHandler(null);
		}
		//颜色
		public function setGraph(cc:uint):void {
			color = cc;
		}
		
		//刷新
		public function update():void{
			clear();
			var configProxy:ConfigProxy = Facade.getInstance(ApplicationFacade.CORE).retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var dotStr:String = configProxy.getValue("DotPosition");//文字大小
			
			var dotObj:Object = JSON.parse(dotStr);
			for each(var obj:Object in dotObj){
				ToolPanel.currentTool = obj.type;
				var vec:Vector.<LineInfo> = UnionPoint.coordSys(textField,obj.data.startChar,obj.data.endChar);
				
				for each(var point:LineInfo in vec){
					if(point){												
						var product:GraphBase = this.factoryMethodDraw(color);//这是生产方法 
						product.begin(point.startPoint.x,point.startPoint.y);
						product.draw(point.endPoint.x,point.endPoint.y);						
						//trace("start = " + "(" + point.startPoint.x + " , "+ point.startPoint.y + ")");
						//trace("end = " + "(" + point.endPoint.x + " , "+ point.endPoint.y + ")");
						canvas.addChild(product);
					}					
				}		
			}	
			setBitmap();
		}
				
		private function setBitmap():void{			
			backBmd = new BitmapData(ww, hh, true, 0);//把backCanvas的内容draw到位图中		
			backBmd.draw(allCanvas);
			backBmp.bitmapData = backBmd;
			while (canvas.numChildren > 0) {
				canvas.removeChildAt(0);
			}
			
			
			/*var rect:Rectangle = new Rectangle(0,0,150,200);
			backBmp.bitmapData.fillRect(rect,0);*/
		}
		
		
		//抽象方法(必须在子类中重写)   
		protected function factoryMethodDraw(c:uint = 0):GraphBase { 			
			var ClassReference:Class = ToolPanel.getClassByTool(ToolPanel.currentTool);
			return new ClassReference(color) as GraphBase;
		}  
		
		public function get textField():TextField{
			return _textField;
		}		
		public function set textField(value:TextField):void{
			_textField = value;
			this.ww = _textField.width;
			this.hh = _textField.height;
		}
		
		
	}  
}