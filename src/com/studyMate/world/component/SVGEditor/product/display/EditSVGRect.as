package com.studyMate.world.component.SVGEditor.product.display
{
	import com.lorentz.SVG.utils.SVGColorUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	
	internal class EditSVGRect extends EditSVGGraphBase
	{
		private var strokeWidth:Number;
		private var strokeFill:uint;
		
		public function EditSVGRect()
		{
			this.type = EditType.rect;
			super();			
		}
		
		override public function getElementXML():XML
		{
			var xml:XML = <rect></rect>;
			setXML(xml);
			if(graphicSP){
				xml.@width = graphicSP.width;
				xml.@height = graphicSP.height;				
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
				(graphicSP as Sprite).graphics.drawRect(0,0,xx,yy);
				(graphicSP as Sprite).graphics.endFill();
				scaleRect.x = xx;
				scaleRect.y = yy;
			}
		}
		
		override protected function render(e:Event=null):void
		{
			var width:Number = Number(getAttribute("width"));
			var height:Number = Number(getAttribute("height"));
			if(graphicSP==null){
				graphicSP = new Sprite;
				
				graphicSP.x = -0.5;
				graphicSP.y = -0.5;
				this.addChild(graphicSP);
			}else{

				graphicSP.width = width;
				graphicSP.height = height;
			}
			
			(graphicSP as Sprite).graphics.clear();
			if(strokeWidth){								
				(graphicSP as Sprite).graphics.lineStyle(strokeWidth,strokeFill);					
				
			}
			
			(graphicSP as Sprite).graphics.beginFill(color);
			(graphicSP as Sprite).graphics.drawRect(0,0,width,height);
			(graphicSP as Sprite).graphics.endFill();
			
			super.render(e);
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
					
			}
		}
		
	}
}