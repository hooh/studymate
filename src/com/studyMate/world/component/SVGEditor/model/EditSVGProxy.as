package com.studyMate.world.component.SVGEditor.model
{
	import com.lorentz.SVG.data.style.StyleDeclaration;
	import com.lorentz.SVG.display.SVGEllipse;
	import com.lorentz.SVG.display.SVGImage;
	import com.lorentz.SVG.display.SVGPolygon;
	import com.lorentz.SVG.display.SVGText;
	import com.lorentz.SVG.display.base.SVGElement;
	import com.lorentz.SVG.utils.DisplayUtils;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.data.EditSVGVO;
	import com.studyMate.world.component.SVGEditor.product.display.Creator;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditGraph;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditText;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	import com.studyMate.world.component.SVGEditor.utils.SVGLayer;
	import com.studyMate.world.component.SVGEditor.utils.SVGUtils;
	import com.studyMate.world.component.SVGEditor.utils.ToolType;
	import com.studyMate.world.component.SVGEditor.windows.SVGDrawCanvasMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGPropertiesPanelMediator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class EditSVGProxy extends Proxy
	{
		public static const NAME:String = "EditSVGProxy";
		
				
		public function EditSVGProxy(proxyName:String=null)
		{
			super(NAME);
		}
		override public function onRemove():void
		{
			super.onRemove();
		}
		/**------------根据点击渲染面板中不同的Element，创建相应的可编辑对象-------------------*/
		public function changToEdit(selectedElement:SVGElement):void{
			var bounds:Rectangle = DisplayUtils.safeGetBounds(selectedElement, selectedElement.document);
			var style:StyleDeclaration = selectedElement.finalStyle;
			var editSvg:IEditBase = null;
			var editSVGVO:EditSVGVO = new EditSVGVO();
			editSVGVO.id = selectedElement.id;
			editSVGVO.styleDeclaration._attributes = style.propertiesValues;					
			switch(selectedElement.type){
				case EditType.text:
					editSVGVO.x = bounds.x;
					editSVGVO.y = bounds.y;
					if((selectedElement as SVGText).svgX){
						editSVGVO.x = Number((selectedElement as SVGText).svgX);
					}
					if((selectedElement as SVGText).svgY){
						editSVGVO.y = Number((selectedElement as SVGText).svgY);
					}
					editSVGVO.text = String((selectedElement as SVGText).getTextElementAt(0));
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,(selectedElement as SVGText).svgWidth);
					editSvg = creatSVGText(editSVGVO);
					break;
				case EditType.rect:
					editSVGVO.x = bounds.x
					editSVGVO.y = bounds.y;
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,bounds.width);
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.HEIGHT,bounds.height);			
					editSvg = creatSVGRect(editSVGVO);
					break;
				case EditType.image:
					editSVGVO.x = bounds.x
					editSVGVO.y = bounds.y;
					var link:String = (selectedElement as SVGImage).svgHref;
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.XLINK,link);
					if((selectedElement as SVGImage).svgX){
						editSVGVO.x = Number((selectedElement as SVGImage).svgX);
					}
					if((selectedElement as SVGImage).svgY){
						editSVGVO.y = Number((selectedElement as SVGImage).svgY);
					}					
					if(link.indexOf("library")==0){						
						if((selectedElement as SVGImage).svgWidth){
							editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,(selectedElement as SVGImage).svgWidth);
						}else{
							editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,bounds.width+'px');
						}
						if((selectedElement as SVGImage).svgHeight){
							editSVGVO.styleDeclaration.setAttribute(SVGUtils.HEIGHT,(selectedElement as SVGImage).svgHeight);
						}else{
							editSVGVO.styleDeclaration.setAttribute(SVGUtils.HEIGHT,bounds.height+'px');
						}
						editSvg = creatSWFImage(editSVGVO);
					}else if(link.indexOf("formula")==0){						
						editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,(selectedElement as SVGImage).svgWidth);
						editSVGVO.styleDeclaration.setAttribute(SVGUtils.HEIGHT,(selectedElement as SVGImage).svgHeight);
						editSVGVO.styleDeclaration.setAttribute('content',(selectedElement as SVGImage).formula);
						editSvg = creatMath(editSVGVO);
					}			
					
					break;
				case EditType.ellipse:
					editSVGVO.styleDeclaration.setAttribute('cx',Number((selectedElement as SVGEllipse).svgCx));
					editSVGVO.styleDeclaration.setAttribute('cy',Number((selectedElement as SVGEllipse).svgCy));
					editSVGVO.styleDeclaration.setAttribute('rx',Number((selectedElement as SVGEllipse).svgRx));
					editSVGVO.styleDeclaration.setAttribute('ry',Number((selectedElement as SVGEllipse).svgRy));
					editSvg = creatSVGCircle(editSVGVO);
					break;		
				case EditType.polygon://多边形
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.POINTS,(selectedElement as SVGPolygon).points.join(' '));
					editSvg = creatSVGPolygon(editSVGVO);
					break;
			}
			if(editSvg){
				sendNotification(SVGConst.MODIFIY_ELEMENT,editSvg);
				editSvg = null;
			}
		}
		
		/**-------------------------创建新的舞台对象---------------------------------*/
		public function creatNewEdit(point:Point,swfRecive:String = null):IEditBase{
			point = SVGLayer.svgDrawCanvasView.globalToLocal(point);
			var obj:EditSVGVO = (facade.retrieveMediator(SVGPropertiesPanelMediator.NAME) as SVGPropertiesPanelMediator).propertyUI.propertyObject;
			var editSvg:IEditBase = null;
			var editSVGVO:EditSVGVO = new EditSVGVO();
			if(obj){
				editSVGVO.styleDeclaration._attributes = obj.styleDeclaration._attributes;				
			}
			switch(SVGConst.currentTool){
				case ToolType.CREAT_TEXT_TOOL:
					editSVGVO.x = point.x;
					editSVGVO.y = point.y;
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,"200");
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.FONT_FAMILY,"HeiTi");
					editSVGVO.text = "请输入文本";
					editSvg = creatSVGText(editSVGVO);												
					break;
				case ToolType.CREAT_SWFIMAGE_TOOL:					
					editSVGVO.x = point.x;
					editSVGVO.y = point.y;
					
					var disObj:DisplayObject = SWFLoadProxy.getDisplayObject(swfRecive);
					if(disObj){
						var sp:DisplayObject = disObj;
						editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,sp.width+'px');
						editSVGVO.styleDeclaration.setAttribute(SVGUtils.HEIGHT,sp.height+'px');
						editSVGVO.styleDeclaration.setAttribute(SVGUtils.XLINK,"library:"+swfRecive);
						editSvg = creatSWFImage(editSVGVO);
						sp = null;
					}					
					break;
				case ToolType.CREAT_RECT_TOOL:
					editSVGVO.x = point.x;
					editSVGVO.y = point.y;
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,4);
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.HEIGHT,4);
					editSvg = creatSVGRect(editSVGVO);
					break;
				case ToolType.CREAT_ELLIPSE_TOOL:
					editSVGVO.styleDeclaration.setAttribute('cx',point.x);
					editSVGVO.styleDeclaration.setAttribute('cy',point.y);
					editSVGVO.styleDeclaration.setAttribute('rx','4');
					editSVGVO.styleDeclaration.setAttribute('ry','4');
					editSvg = creatSVGCircle(editSVGVO);
					break;
				case ToolType.CREAT_MATH_TOOL:
					editSVGVO.x = point.x;
					editSVGVO.y = point.y;
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.WIDTH,'100px');
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.HEIGHT,'100px');
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.XLINK,"formula:"+'请粘贴公式');
					editSvg = creatMath(editSVGVO);
					break;
				case ToolType.CREAT_POLYGON_TOOL://多边形
					editSVGVO.x = point.x;
					editSVGVO.y = point.y;
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.POINTS,'350, 75 379,161 469,161 397,215 423,301 350,250 277,301 303,215 231,161 321,161');
					editSvg = creatSVGPolygon(editSVGVO);
					break;
			}						
			obj = null;
			return editSvg;
		}
		
		
		
		
		
		
		/**-----------------------------创建编辑文本----------------------------*/
		private function creatSVGText(svgVO:EditSVGVO):IEditText{
			var svgText:IEditText = Creator.creatText();						
			svgText.id = svgVO.id;
			svgText.x  = svgVO.x;
			svgText.y = svgVO.y;
			for(var key:String in svgVO.styleDeclaration._attributes){
				svgText.setAttribute(key,svgVO.styleDeclaration.getAttribute(key));
			}
			
			svgText.text = svgVO.text;			
			return svgText;
		}
		
		
		/**----------------------------创建swf图片-----------------------*/
		private function creatSWFImage(svgVO:EditSVGVO):IEditGraph{
			var svgImage:IEditGraph = Creator.creatSwfImage();
			svgImage.id = svgVO.id;
			svgImage.x = svgVO.x;
			svgImage.y = svgVO.y;
			for(var key:String in svgVO.styleDeclaration._attributes){
				svgImage.setAttribute(key,svgVO.styleDeclaration.getAttribute(key));
			}
			return svgImage;
		}
		/**----------------------------创建Math图片-----------------------*/
		private function creatMath(svgVO:EditSVGVO):IEditText{
			var svgMath:IEditText = Creator.creatMath();
			svgMath.id = svgVO.id;
			svgMath.x = svgVO.x;
			svgMath.y = svgVO.y;
			for(var key:String in svgVO.styleDeclaration._attributes){
				svgMath.setAttribute(key,svgVO.styleDeclaration.getAttribute(key));
			}
			return svgMath;
		}
		
		/**----------------------------创建Rect形状-----------------------*/
		private function creatSVGRect(svgVO:EditSVGVO):IEditGraph{
			var svgRect:IEditGraph = Creator.creatRect();
			svgRect.id = svgVO.id;
			svgRect.x = svgVO.x;
			svgRect.y = svgVO.y;
			for(var key:String in svgVO.styleDeclaration._attributes){
				svgRect.setAttribute(key,svgVO.styleDeclaration.getAttribute(key));
			}
			return svgRect;
		}
		/**----------------------------创建圆形-----------------------*/
		private function creatSVGCircle(svgVO:EditSVGVO):IEditGraph{
			var svgCircle:IEditGraph = Creator.creatEllipse();
			svgCircle.id = svgVO.id;
			for(var key:String in svgVO.styleDeclaration._attributes){
				svgCircle.setAttribute(key,svgVO.styleDeclaration.getAttribute(key));
			}
			svgCircle.x = Number(svgVO.styleDeclaration.getAttribute('cx'));
			svgCircle.y = Number(svgVO.styleDeclaration.getAttribute('cy'));
			return svgCircle;
		}
		
		/**----------------------------创建多边形-----------------------*/
		private function creatSVGPolygon(svgVO:EditSVGVO):IEditGraph{
			var svgPolygon:IEditGraph = Creator.creatPolygon();
			svgPolygon.id = svgVO.id;
			svgPolygon.x = svgVO.x;
			svgPolygon.y = svgVO.y;
			for(var key:String in svgVO.styleDeclaration._attributes){
				svgPolygon.setAttribute(key,svgVO.styleDeclaration.getAttribute(key));
			}
			return svgPolygon;
		}
	}
}