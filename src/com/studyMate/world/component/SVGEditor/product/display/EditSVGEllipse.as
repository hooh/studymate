package com.studyMate.world.component.SVGEditor.product.display
{
	import com.lorentz.SVG.utils.SVGColorUtils;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	
	import flash.display.Sprite;
	import flash.events.Event;

	internal class EditSVGEllipse extends EditSVGGraphBase
	{		
		private var strokeWidth:Number;
		private var strokeFill:uint;
		
		public function EditSVGEllipse()
		{
			this.type = EditType.ellipse;
			super();
		}
		override public function getElementXML():XML
		{
			var xml:XML = <ellipse></ellipse>;
			setXML(xml);
			xml.@id = this.id;
			xml.@cx = this.x
			xml.@cy = this.y;
			if(graphicSP){
				xml.@rx = graphicSP.width/2;
				xml.@ry = graphicSP.height/2;				
			}else{
				xml.@rx = getAttribute("rx");
				xml.@ry = getAttribute("ry");
			}
			if(strokeWidth==0){
				delete xml.@['stroke-width'];
				if(strokeFill){
					delete xml.@stroke;
				}
			}
			
			return xml;
		}
		override public function draw(xx:Number, yy:Number):void
		{
			if(graphicSP){
				(graphicSP as Sprite).graphics.clear();
				if(strokeWidth){				
					(graphicSP as Sprite).graphics.lineStyle(strokeWidth,strokeFill);				
				}
				(graphicSP as Sprite).graphics.beginFill(color);
				(graphicSP as Sprite).graphics.drawEllipse(0,0,xx*2,yy*2);
				(graphicSP as Sprite).graphics.endFill();			
				graphicSP.x = -xx;
				graphicSP.y = -yy;
				
				scaleRect.x = graphicSP.width/2;
				scaleRect.y = graphicSP.height/2;
				
			}
		}
		
		override protected function render(e:Event=null):void
		{
			var width:Number = Number(getAttribute("rx"))*2;
			var height:Number = Number(getAttribute("ry"))*2;
			if(graphicSP==null){
				graphicSP = new Sprite;
				
				graphicSP.x = -width/2;
				graphicSP.y = -height/2;
				this.addChild(graphicSP);
			}else{
				graphicSP.width = width;
				graphicSP.height = height;
				graphicSP.x = -width/2;
				graphicSP.y = -height/2
			}
			(graphicSP as Sprite).graphics.clear();
			if(strokeWidth){				
				(graphicSP as Sprite).graphics.lineStyle(strokeWidth,strokeFill);				
			}
			(graphicSP as Sprite).graphics.beginFill(color);
			(graphicSP as Sprite).graphics.drawEllipse(0,0,width,height);
			(graphicSP as Sprite).graphics.endFill();
			
			super.render(e);

			scaleRect.x = graphicSP.width/2;
			scaleRect.y = graphicSP.height/2;
		}
		
		
		
		override public function setAttribute(name:String, value:Object):void
		{
			super.setAttribute(name, value);
			switch(name){
				case "style":
					color = SVGColorUtils.getColorByName(String(value).substr(5));
					break;
				case "fill":
					color = SVGColorUtils.parseToUint(String(value));
					break;
				case 'stroke-width':
					strokeWidth = Number(value);
					break;
				case 'stroke':
					strokeFill =  SVGColorUtils.parseToUint(String(value));
					break;
				
			}
		}
		
	}
}