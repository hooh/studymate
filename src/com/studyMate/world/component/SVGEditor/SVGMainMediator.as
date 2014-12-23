package com.studyMate.world.component.SVGEditor
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.SVGEditor.controller.InitializeSVGCommand;
	import com.studyMate.world.component.SVGEditor.data.PropertyVO;
	import com.studyMate.world.component.SVGEditor.windows.SVGCoordChangeMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGDrawCanvasMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGEditCanvasMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGLoadMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGPagePanelMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGPropertiesPanelMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGTagPanelMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGToolPanelsMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGTopPanelMediator;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SVGMainMediator extends ScreenBaseMediator
	{
		
		private const yesQuitHandler:String = NAME + "yesQuitHandler";
		private var svgDraw:SVGDrawCanvasMediator;
		private var svgEdit:SVGEditCanvasMediator;
		
				
		public function SVGMainMediator(viewComponent:Object=null)
		{
			super(ModuleConst.SVG_MAIN, viewComponent);
		}
		override public function onRemove():void
		{
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,false);
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true);
			//Global.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpGroupHandler);   
//			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,quit);
			System.disposeXML(SVGConst.svgXML);
			SVGConst.svgXML = null;
			SVGConst.currentTool = null;
			SVGConst.isEditState = false;
			sendNotification(SVGConst.REMOVE_SVG);
			super.onRemove();
		}
		
		override public function onRegister():void
		{	
			
			SVGConst.isEditState = false;
			SVGConst.svgXML = <svg width="100%" height="100%" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"></svg>	;
			facade.registerCommand(SVGConst.INITIALIZE_SVG,InitializeSVGCommand);
			sendNotification(SVGConst.INITIALIZE_SVG);
			
			//渲染面板
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGDrawCanvasMediator,null,SwitchScreenType.SHOW,view,0,0)]);//cpu层显示
			//编辑面板
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGEditCanvasMediator,null,SwitchScreenType.SHOW,view,0,0)]);//cpu层显示
			//顶部面板
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGTopPanelMediator,null,SwitchScreenType.SHOW,view,0,0)]);//cpu层显示
			//工具面板
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGToolPanelsMediator,null,SwitchScreenType.SHOW,view,0,82)]);//cpu层显示
			//属性面板
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGPropertiesPanelMediator,null,SwitchScreenType.SHOW,view,0,25)]);//cpu层显示
			//分页面板
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGPagePanelMediator,null,SwitchScreenType.SHOW,view,0,724)]);//cpu层显示
			//标签和库窗口
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGTagPanelMediator,null,SwitchScreenType.SHOW,view,1126,84)]);//cpu层显示	
			
			backHandle = quit;
//			Global.stage.focus = view;
			
			svgDraw = facade.retrieveMediator(SVGDrawCanvasMediator.NAME) as SVGDrawCanvasMediator;
			svgEdit= facade.retrieveMediator(SVGEditCanvasMediator.NAME) as SVGEditCanvasMediator;
			
			
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,false,0);
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true,0);
			
			//Global.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpGroupHandler);  
			  

		}

		//组合键
		/*private function keyUpGroupHandler(event:KeyboardEvent):void {   
			if(event.keyCode==Keyboard.S && event.ctrlKey){   
				trace("您按下了Ctrl+S") ;
				event.preventDefault();
				event.stopImmediatePropagation();
			}   
		}*/
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.BACK || event.keyCode==Keyboard.ESCAPE)
				event.preventDefault();
				/*if(event.keyCode == event.ctrlKey){
					
					event.stopImmediatePropagation();
				}*/
		}
		private function quit():void{
			sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n您确定退出编辑器吗?",true,yesQuitHandler));
		}

		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SVGConst.LOAD__SVG_DOCUMENT://导入					
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGLoadMediator,null,SwitchScreenType.SHOW,view,0,0)]);//cpu层显示
					break;
				case yesQuitHandler://弹出框暂时不能用
					sendNotification(WorldConst.POP_SCREEN);
					break;
				case SVGConst.ZOOM_STAGE://缩放
					var percent:Number = Number(notification.getBody());					
					svgDraw.view.scaleX = svgEdit.view.scaleX = percent;
					svgDraw.view.scaleY = svgEdit.view.scaleY = percent;
//					svgDraw.view.x = svgEdit.view.x = (1-percent)*SVGConst.stageWidth/2;
//					svgDraw.view.y = svgEdit.view.y = (1-percent)*SVGConst.stageHeight/2;	
					svgDraw.view.x = svgEdit.view.x = (1280-SVGConst.stageWidth*percent)/2;
					break;
				case SVGConst.COORD_CHANGE://调整坐标
					var propertyVO:PropertyVO = notification.getBody() as PropertyVO;
					svgDraw.view[propertyVO.attribute] = (svgDraw.view[propertyVO.attribute] + Number(propertyVO.value));
					svgEdit.view[propertyVO.attribute] = (svgEdit.view[propertyVO.attribute]+ Number(propertyVO.value));
//					svgDraw.view.y +=  Number(propertyVO.value);
//					trace("变动的值:"+ svgEdit.view[propertyVO.attribute] +"   |    "+propertyVO.value);
					break;
				case SVGConst.SHOW_MOVE_VIEW:
					if(!facade.hasMediator(SVGCoordChangeMediator.NAME))
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGCoordChangeMediator,null,SwitchScreenType.SHOW,view,0,0)]);//cpu层显示
					break;
				case SVGConst.RESET_COORD:
					svgDraw.view.scaleX = 1;
					svgDraw.view.scaleY = 1;
					svgDraw.view.x = svgEdit.view.x = (1280-SVGConst.stageWidth)/2;
//					svgDraw.view.y = svgEdit.view.y = 0;	
					break;
			}
		}
		

		override public function listNotificationInterests():Array
		{
			return [yesQuitHandler,
					SVGConst.LOAD__SVG_DOCUMENT,
					SVGConst.ZOOM_STAGE,
					SVGConst.SHOW_MOVE_VIEW,
					SVGConst.RESET_COORD,
					SVGConst.COORD_CHANGE];
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}