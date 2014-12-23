package com.studyMate.world.component.SVGEditor
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.SVGEditor.controller.SWFLoadCommand;
	import com.studyMate.world.component.SVGEditor.model.SWFLoadProxy;
	import com.studyMate.world.component.SVGEditor.utils.EditSVGTextDrawer;
	import com.studyMate.world.component.SVGEditor.windows.SVGLoadMediator;
	import com.studyMate.world.model.FormulaMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import fl.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class SVGShowMediator extends ScreenBaseMediator
	{
		private var svgDocument:SVGDocument;
		
		public function SVGShowMediator(viewComponent:Object=null)
		{
			super(ModuleConst.SVG_SHOW, viewComponent);
		}
		override public function onRemove():void{	
			SVGConst.svgXML = <svg width="100%" height="100%" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"></svg>
			facade.removeProxy(SWFLoadProxy.NAME);
			facade.removeCommand(SVGConst.LOAD_SWF);
			facade.removeMediator(FormulaMediator.NAME);
			svgDocument.clear();
//			sendNotification(WorldConst.SHOW_MAIN_MENU);
			super.onRemove();
		}
		override public function onRegister():void{	
			facade.registerProxy(new SWFLoadProxy);
			facade.registerCommand(SVGConst.LOAD_SWF,SWFLoadCommand);
			facade.registerMediator(new FormulaMediator);
			
			//sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			
			ProcessExecutor.instance.initialize(view.stage);
			svgDocument = new SVGDocument();
			view.addChild(svgDocument);
			svgDocument.textDrawer = new EditSVGTextDrawer();
			svgDocument.useEmbeddedFonts = true;
			svgDocument.defaultFontName = "HeiTi";
			
			svgDocument.availableWidth = Global.stageWidth;
			svgDocument.availableHeight = Global.stageHeight;
			svgDocument.validateWhileParsing = false;
			
			var btn:Button = new Button();
			btn.label = "导入";
			btn.x = 800;
			view.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGLoadMediator,null,SwitchScreenType.SHOW,view,0,0)]);//cpu层显示
		}		
		
		protected function btnClickHandler(event:MouseEvent):void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGLoadMediator,null,SwitchScreenType.SHOW,view,0,0)]);//cpu层显示
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var byteArr:ByteArray;
			switch(notification.getName()){				
				case SVGConst.CLEAR_ALL_ELEMENT://清理文本
					SVGConst.svgXML = <svg width="100%" height="100%" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"></svg>	;
					svgDocument.clear();
					sendNotification(SVGConst.CHANGE_TAG);
					break;
				case SVGConst.UPDATE_SVG_DOCUMENT://刷新文本
					sendNotification(WorldConst.STOP_ALL_FORMULA);
					svgDocument.clear();
					svgDocument.parse(SVGConst.svgXML);	
					trace("update XML : "+SVGConst.svgXML);
//					svgDocument.clear();
//					svgDocument.parse(SVGConst.svgXML);						
					break;
			}
			
			
		}
		override public function listNotificationInterests():Array{
			return [SVGConst.UPDATE_SVG_DOCUMENT,SVGConst.CLEAR_ALL_ELEMENT];
		}
		
		
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}