package com.studyMate.world.component.SVGEditor.product.display
{
	import com.studyMate.world.component.SVGEditor.model.SWFLoadProxy;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	internal class EditSVGSwfImage extends EditSVGGraphBase
	{		
		public function EditSVGSwfImage()
		{
			this.type = EditType.image;
			super();
		}
		
		override public function getElementXML():XML
		{
			var xml:XML = <image></image>;
			xml.@id = id;
			xml.@x = x;
			xml.@y = y;
			if(graphicSP){
				xml.@width = graphicSP.width+"px";
				xml.@height = graphicSP.height+"px";				
			}else{
				xml.@width = getAttribute("width");
				xml.@height = getAttribute("height");
			}
			var xlink:Namespace = new Namespace("http://www.w3.org/1999/xlink");			
			xml.@xlink::href = getAttribute("xlink:href");	
			return xml;
		}
		override public function draw(xx:Number, yy:Number):void
		{
			graphicSP.width = xx;
			graphicSP.height = yy;	
			scaleRect.x = xx;
			scaleRect.y = yy;
		}
		
		override protected function render(e:Event=null):void
		{
			if(graphicSP==null){
				var libStr:String = getAttribute("xlink:href").substr(8);
				var disObj:DisplayObject = SWFLoadProxy.getDisplayObject(libStr);
				if(disObj){
					graphicSP = disObj;
					graphicSP.x = -0.5;
					graphicSP.y = -0.5;
					this.addChild(graphicSP);				
					var width:String = String(getAttribute("width"));
					var height:String = String(getAttribute("height"));		
					
					graphicSP.width = int(width.substring(0,width.indexOf("px")));
					graphicSP.height = int( height.substring(0,height.indexOf("px")));
					
					super.render(e);
				}else{
					setAttribute("xlink:href",'');
				}
			}
		}
		
	}
}