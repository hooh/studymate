package com.studyMate.world.component.SVGEditor.windows
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.display.base.SVGContainer;
	import com.lorentz.SVG.display.base.SVGElement;
	import com.lorentz.SVG.utils.DisplayUtils;
	import com.lorentz.processing.ProcessExecutor;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.model.EditSVGProxy;
	import com.studyMate.world.component.SVGEditor.utils.EditSVGTextDrawer;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 *渲染面板,
	 * 只负责，新建、导入、读取等。
	 * 并为编辑面板和工具面板提供数据 
	 * @author wangtu
	 * 
	 */	
	public class SVGDrawCanvasMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SVGDrawCanvasMediator";
				
		private var svgDocument:SVGDocument;		
		private var selectedElement:SVGElement;
		
		private var editProxy:EditSVGProxy;
				
		public function SVGDrawCanvasMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}				
		override public function onRemove():void{	
			editProxy = null;
			view.removeEventListener(MouseEvent.CLICK, svgGroup_clickHandler);//渲染去舞台点击
			selectedElement = null;
			svgDocument.clear();
			SVGConst.stageWidth = 1280;
			SVGConst.stageHeight = 752;
			super.onRemove();
		}			
		override public function onRegister():void{																	  			
			editProxy = facade.retrieveProxy(EditSVGProxy.NAME) as EditSVGProxy;
			ProcessExecutor.instance.initialize(view.stage);
			svgDocument = new SVGDocument();
			view.addChild(svgDocument);
			svgDocument.textDrawer = new EditSVGTextDrawer();
			svgDocument.useEmbeddedFonts = true;
			svgDocument.defaultFontName = "HeiTi";
			
//			svgDocument.availableWidth = SVGConst.stageWidth;
//			svgDocument.availableHeight = SVGConst.stageHeight;
			svgDocument.validateWhileParsing = false;
			
//			view.graphics.clear();
//			view.graphics.lineStyle(1,0);
//			view.graphics.beginFill(0xFFFFFF);
//			view.graphics.moveTo(0,0);
//			view.graphics.lineTo(SVGConst.stageWidth,0);
//			view.graphics.lineTo(SVGConst.stageWidth,SVGConst.stageHeight);
//			view.graphics.lineTo(0,SVGConst.stageHeight);
//			view.graphics.lineTo(0,0);
//			view.graphics.endFill();		
			updateStageScale();
			view.addEventListener(MouseEvent.CLICK, svgGroup_clickHandler);//渲染去舞台点击		
		}		
		
		public function updateStageScale():void{
			svgDocument.availableWidth = SVGConst.stageWidth;
			svgDocument.availableHeight = SVGConst.stageHeight;
			
			view.graphics.clear();
			view.graphics.lineStyle(1,0);
			view.graphics.beginFill(0xFFFFFF);
			view.graphics.moveTo(0,0);
			view.graphics.lineTo(SVGConst.stageWidth,0);
			view.graphics.lineTo(SVGConst.stageWidth,SVGConst.stageHeight);
			view.graphics.lineTo(0,SVGConst.stageHeight);
			view.graphics.lineTo(0,0);
			view.graphics.endFill();	
			
			view.x = (1280-SVGConst.stageWidth)/2;
			view.y = (752-SVGConst.stageHeight)/2;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var byteArr:ByteArray;
			switch(notification.getName()){
				case SVGConst.CLEAR_ALL_ELEMENT://清理文本
					SVGConst.svgXML = <svg width="100%" height="100%" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"></svg>	;
					selectedElement = null;
					svgDocument.clear();
					sendNotification(SVGConst.CHANGE_TAG);
					break;
				case SVGConst.UPDATE_SVG_DOCUMENT_COMPLETE://刷新文本
					sendNotification(WorldConst.STOP_ALL_FORMULA);
					selectedElement = null;
					svgDocument.clear();
					svgDocument.parse(SVGConst.svgXML);	
					SVGConst.isEditState = false;
					trace("update XML : "+SVGConst.svgXML);
					sendNotification(SVGConst.CHANGE_TAG);//修改标签
					break;
				
				case SVGConst.SELECT_TAG://选择标签	,传入id			
					var id:String = notification.getBody() as String;
					if(svgDocument.numElements<1) return;
					var root:SVGContainer = (svgDocument.getElementAt(0) as SVGContainer)
					for (var i:int = 0; i < root.numElements; i++) 
					{
						if(id==root.getElementAt(i).id){
							selectedElement = root.getElementAt(i);
							editProxy.changToEdit(selectedElement);
							if(selectedElement.parent)
								selectedElement.parent.removeChild(selectedElement);
							selectedElement = null;
							break;
						}
					}
					break;
				case SVGConst.UPDATE_STAGE_SCALE:
					this.updateStageScale();
					
					break;				
			}
		}
		override public function listNotificationInterests():Array{
			return [
					SVGConst.UPDATE_STAGE_SCALE,
					SVGConst.UPDATE_SVG_DOCUMENT_COMPLETE,
					SVGConst.CLEAR_ALL_ELEMENT,
					SVGConst.SELECT_TAG];
		}

		protected function svgGroup_clickHandler(e:MouseEvent):void {	
			selectedElement = DisplayUtils.getSVGElement(e.target as DisplayObject);
			if(selectedElement){
				if(!SVGConst.isEditState){
					editProxy.changToEdit(selectedElement);
					if(selectedElement.parent)
						selectedElement.parent.removeChild(selectedElement);
					selectedElement = null;
				}				
			}
		}	
		
		
	
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}		
	}
}