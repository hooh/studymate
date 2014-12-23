package com.studyMate.world.component.SVGEditor.product.display
{
	import com.lorentz.SVG.utils.SVGColorUtils;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	import com.studyMate.world.component.SVGEditor.utils.SVGUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;

	internal class EditSVGPolygon extends EditSVGGraphBase
	{
		private var strokeWidth:Number;
		private var strokeFill:uint;
		private var _isStar:Boolean;
		private var _points:Vector.<String>;
		protected var _side:uint = 5;
		
		public function EditSVGPolygon()
		{
			this.type = EditType.polygon;
			super();
		}
		
		override public function getElementXML():XML
		{
			var xml:XML = <polygon ></polygon >;
			setXML(xml);
			return xml;
		}
		
		override public function draw(xx:Number, yy:Number):void
		{
			if(graphicSP){
				var radius:Number = xx ;//横向移动改变多边形的大小
				if (_isStar) {
					var radius1:Number = radius;
					var radius2:Number = radius * (.3 + _side / 40);//边数越大，内径越接近外径，括号内为系数，一个大概的线性值
				}
				var startAngle:Number = yy  * Math.PI / 360;//纵向移动改变多边形的旋转			
				(graphicSP as Sprite).graphics.clear();
				(graphicSP as Sprite).graphics.lineStyle(2, color);
				var n:int = _isStar?_side * 2 + 1:_side + 1;
				for (var i:int = 0; i < n; i++) {		
					if (_isStar) {
						radius = (radius == radius1)?radius2:radius1;
					}
					var angle:Number = Math.PI * 2 / (n - 1) * i + startAngle;
					var nx:Number = Math.cos(angle) * radius ;
					var ny:Number = Math.sin(angle) * radius ;
					if (i == 0) {					
						(graphicSP as Sprite).graphics.moveTo(nx, ny);
					}else{
						(graphicSP as Sprite).graphics.lineTo(nx, ny);
					}	
				}	
			}					
		}
		
		override protected function render(e:Event=null):void
		{
			if(graphicSP==null){
				graphicSP = new Sprite;
				
				/*graphicSP.x = -0.5;
				graphicSP.y = -0.5;*/
				this.addChild(graphicSP);
			}
			/*graphicSP.graphics.clear();
			graphicSP.graphics.lineStyle(2, color);
			var n:int = _isStar?_side * 2 + 1:_side + 1;
			for (var i:int = 0; i < n; i++) {		
				if (i == 0) {					
					graphicSP.graphics.moveTo(nx, ny);
				}else{
					graphicSP.graphics.lineTo(nx, ny);
				}	
			}*/
			(graphicSP as Sprite).graphics.clear();
			(graphicSP as Sprite).graphics.lineStyle(2, color);
			var pointX:Number;
			var pointY:Number;
			if(_points.length>2){
				(graphicSP as Sprite).graphics.moveTo(Number(_points[0]), Number(_points[1]));
				
				var j:int = 2;
				while(j < _points.length - 1)
					(graphicSP as Sprite).graphics.lineTo(Number(_points[j++]), Number(_points[j++]));
				
				(graphicSP as Sprite).graphics.lineTo(Number(_points[0]), Number(_points[1]));
			}
			super.render(e);
			
			dragRect.width = graphicSP.width;
			dragRect.height = graphicSP.height;
			dragRect.x = pointX;
			dragRect.y = pointY;
			
		}
		override public function setAttribute(name:String, value:Object):void
		{
			super.setAttribute(name, value);
			switch(name){
				case "fill":
					color = SVGColorUtils.parseToUint(String(value));
					break;
				case 'stroke-width':
					strokeWidth = Number(value);
					break;
				case 'stroke':
					strokeFill =  SVGColorUtils.parseToUint(String(value));
					break;
				case "points":
					//_side = String(value).split(',').length-1;
					//trace("_side: "+_side);					
					_points = SVGUtils.splitNumericArgs(String(value));
					break;
				
			}
		}
		
		
	}
}