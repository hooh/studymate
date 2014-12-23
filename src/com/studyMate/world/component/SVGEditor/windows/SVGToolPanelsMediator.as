package com.studyMate.world.component.SVGEditor.windows
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.utils.ToolType;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * SVG 工具面板
	 * @author wangtu
	 * 
	 */	
	public class SVGToolPanelsMediator extends SVGBasePannelMediator
	{
		public static const NAME:String = "SVGToolPanelsMediator";
		
		private var showBoo:Boolean = true;//默认是显示的
		
		private var mainSp:Sprite;
				
		private var loadSwfBtn:SimpleButton;
		private var selectBtn:SimpleButton;//选择
		private var pencilBtn:SimpleButton;//铅笔
		private var penBtn:SimpleButton;//钢笔
		private var drawBtn:SimpleButton;//画图
		private var editTxtBtn:SimpleButton;//文本
		private var mathBtn:SimpleButton;
		
		private var handMoveBtn:SimpleButton;//移动
		
	//	private var fullScreenBtn:SimpleButton;//全屏
		private var saveBtn:SimpleButton ;//保存
		
		public function SVGToolPanelsMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void
		{			
//			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			saveBtn.removeEventListener(MouseEvent.CLICK,saveHandler);
			drawBtn.removeEventListener(MouseEvent.CLICK,rectHandler);
			selectBtn.removeEventListener(MouseEvent.CLICK,selectHandler);
			editTxtBtn.removeEventListener(MouseEvent.CLICK,editTxtHandler);
			//fullScreenBtn.removeEventListener(MouseEvent.CLICK,fullScreenHandler);
			mainSp.removeChildren();
			view.removeChildren();
			super.onRemove();
		}
		override public function onRegister():void
		{
			/**-------------------水平导航---------------------------*/
			var toolClass:Class = AssetTool.getCurrentLibClass("SVGTools");//键盘按键提示信息
			mainSp = new toolClass;
			view.addChild(mainSp);

			selectBtn = mainSp.getChildByName("selectBtn") as SimpleButton;
			pencilBtn = mainSp.getChildByName("pencilBtn") as SimpleButton;
			penBtn = mainSp.getChildByName("penBtn") as SimpleButton;
			drawBtn = mainSp.getChildByName("drawBtn") as SimpleButton;
			editTxtBtn = mainSp.getChildByName("textBtn") as SimpleButton;
			mathBtn = mainSp.getChildByName("mathBtn") as SimpleButton;
			
			handMoveBtn = mainSp.getChildByName("handMoveBtn") as SimpleButton;
			
			//fullScreenBtn = mainSp.getChildByName("fullScreenBtn") as SimpleButton;
			saveBtn = mainSp.getChildByName("saveBtn") as SimpleButton;
			
			
			selectBtn.addEventListener(MouseEvent.CLICK,selectHandler);
			saveBtn.addEventListener(MouseEvent.CLICK,saveHandler);
			
			drawBtn.addEventListener(MouseEvent.CLICK,rectHandler);
			editTxtBtn.addEventListener(MouseEvent.CLICK,editTxtHandler);
			mathBtn.addEventListener(MouseEvent.CLICK,mathHandler);
			
			handMoveBtn.addEventListener(MouseEvent.CLICK,handMoveHandler);
			
			super.onRegister()
		}
		
		override protected function svg_handleNotification(notification:INotification):void
		{
			switch(notification.getName()){

			}
		}
		override protected function svg_listNotificationInterests():Array
		{
			return [];
		}
		
		
		

		//选择
		private function selectHandler(event:MouseEvent):void{
			SVGConst.currentTool = ToolType.SELECT_HAND;
			sendNotification(SVGConst.REMOVE_REPARE_CREAT_NEW);
		}
		//文本工具
		private function editTxtHandler(event:MouseEvent):void{
			SVGConst.currentTool = ToolType.CREAT_TEXT_TOOL;
			sendNotification(SVGConst.PREPARE_CREAT_NEW);
		}
		//数学工具
		private function mathHandler(e:MouseEvent):void{
			SVGConst.currentTool = ToolType.CREAT_MATH_TOOL;
			sendNotification(SVGConst.PREPARE_CREAT_NEW);
		}
		//画图工具
		private function rectHandler(event:MouseEvent):void{
			switch(SVGConst.currentTool){
				case ToolType.CREAT_RECT_TOOL:
				case ToolType.CREAT_ELLIPSE_TOOL:	
					break;
				default:				
				SVGConst.currentTool = ToolType.CREAT_RECT_TOOL;
				break
			}
			sendNotification(SVGConst.PREPARE_CREAT_NEW);
		}
		//全屏
		/*private function fullScreenHandler(event:MouseEvent):void
		{
			mouseDownX = event.stageX;
			mouseDownY = event.stageY;
			mainSp.startDrag();
		//	fullScreenBtn.addEventListener(MouseEvent.CLICK,svgClickHandler);			
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
		}*/
		
		//拖动面板
		private function handMoveHandler(e:MouseEvent):void{
			//hideHandler();
			/*if(showBoo){
				showBoo = false;
			}*/	
//			sendNotification(SVGConst.HIDE_PANEL);
			sendNotification(SVGConst.MOVE_HAND_BEGIN);							
		}		

		
		//保存
		private function saveHandler(event:MouseEvent):void{
			sendNotification(SVGConst.SAVE_SVG_DOCUMENT);//预备保存
		}
		
		
		
		/**------------------手势控制-------------------------------------*/
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		
		/*protected function stageMouseUpHandler(event:MouseEvent):void
		{
			mainSp.stopDrag();
			if(Math.abs(event.stageX-mouseDownX)>8 || Math.abs(event.stageY-mouseDownY)>8  ){
//				fullScreenBtn.removeEventListener(MouseEvent.CLICK,svgClickHandler);	
				if(showBoo){
					hideHandler();
					showBoo = false;
				}
			}
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);						
		}*/
		
		/*protected function svgClickHandler(event:MouseEvent):void
		{
//			fullScreenBtn.removeEventListener(MouseEvent.CLICK,svgClickHandler);
			showBoo = !showBoo;
			if(showBoo){
				showHandler();
			}else{
				hideHandler();
			}					
		}*/
		/*private function hideHandler():void{
			sendNotification(SVGConst.HIDE_PANEL);
			for(var i:int=0;i<mainSp.numChildren;i++){
				mainSp.getChildAt(i).visible = false;
			}
//			fullScreenBtn.visible = true;
		}*/
		/*private function showHandler():void{
			sendNotification(SVGConst.SHOW_PANEL);
			for(var i:int=0;i<mainSp.numChildren;i++){
				mainSp.getChildAt(i).visible = true;
			}
			mainSp.x = 0;
			mainSp.y = 0;
		}*/

	}
}