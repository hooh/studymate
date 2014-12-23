package com.studyMate.world.component.SVGEditor.model
{
	import com.studyMate.global.Global;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.windows.SVGDrawCanvasMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGEditCanvasMediator;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class MoveStageProxy extends Proxy
	{
		public static const NAME:String = "MoveStageProxy";
		
		private var dragUI:Sprite;
		
		public function MoveStageProxy()
		{
			super(NAME);
		}
		
		override public function onRemove():void
		{
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMoveUpHandler);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownBackHandler,true);
			if(dragUI){
				dragUI.stopDrag();
				Global.stage.removeChild(dragUI);
				dragUI =null;
			}
			super.onRemove();
		}
		
		public function startMove():void{
			if(dragUI==null){
				sendNotification(SVGConst.UPDATE_SVG_DOCUMENT);	
				dragUI = new Sprite();
				dragUI.graphics.beginFill(0,0.2);
				dragUI.graphics.drawRect(0,0,SVGConst.stageWidth,SVGConst.stageHeight);
				dragUI.graphics.endFill();
				dragUI.x = (1280-SVGConst.stageWidth)/2;
				Global.stage.addChild(dragUI);
				dragUI.doubleClickEnabled = true;
				dragUI.addEventListener(MouseEvent.DOUBLE_CLICK,dragDoubleHandler,false,0,true);
				dragUI.addEventListener(MouseEvent.MOUSE_DOWN,dragMouseDownHandler,false,0,true);						
				Global.stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
				
				Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownBackHandler,true,2);
			}
		}
		
		protected function keyDownBackHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE || event.keyCode == Keyboard.BACK){
				event.preventDefault();
				event.stopImmediatePropagation();
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownBackHandler,true);
				Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
				if(dragUI){
					dragUI.stopDrag();
					Global.stage.removeChild(dragUI);
					dragUI =null;
				}
				facade.retrieveMediator(SVGDrawCanvasMediator.NAME).getViewComponent().x = (1280-SVGConst.stageWidth)/2;
				facade.retrieveMediator(SVGDrawCanvasMediator.NAME).getViewComponent().y = (752-SVGConst.stageHeight)/2;
				facade.retrieveMediator(SVGEditCanvasMediator.NAME).getViewComponent().x = (1280-SVGConst.stageWidth)/2;
				facade.retrieveMediator(SVGEditCanvasMediator.NAME).getViewComponent().y = (752-SVGConst.stageHeight)/2;
				sendNotification(SVGConst.SHOW_PANEL);
			}
		}
		
		protected function dragDoubleHandler(event:MouseEvent):void
		{
			dragUI.removeEventListener(MouseEvent.DOUBLE_CLICK,dragDoubleHandler);
			dragUI.removeEventListener(MouseEvent.MOUSE_DOWN,dragMouseDownHandler);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			Global.stage.removeChild(dragUI);
			dragUI = null;
			
		}
		
		protected function stageMouseUpHandler(event:MouseEvent):void
		{
			dragUI.stopDrag();
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMoveUpHandler);
		}
	
		
		
		protected function stageMoveUpHandler(event:MouseEvent):void
		{
			facade.retrieveMediator(SVGDrawCanvasMediator.NAME).getViewComponent().x = dragUI.x;
			facade.retrieveMediator(SVGDrawCanvasMediator.NAME).getViewComponent().y = dragUI.y;
			facade.retrieveMediator(SVGEditCanvasMediator.NAME).getViewComponent().x = dragUI.x;
			facade.retrieveMediator(SVGEditCanvasMediator.NAME).getViewComponent().y = dragUI.y;
		}
		
		protected function dragMouseDownHandler(event:MouseEvent):void
		{
			dragUI.startDrag();
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMoveUpHandler);
		}
	}
}