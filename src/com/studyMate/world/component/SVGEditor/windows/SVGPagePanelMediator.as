package com.studyMate.world.component.SVGEditor.windows
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import fl.controls.List;
	import fl.controls.ScrollBarDirection;
	import fl.data.DataProvider;
	
	/**
	 * 分页面板
	 * @author wt
	 * 
	 */	
	public class SVGPagePanelMediator extends SVGBasePannelMediator
	{
		public static const NAME:String = "SVGPagePanelMediator";
		
		private var mainSp:Sprite;
//		private var pageList:List;
		
		private var stageWidthTxt:TextField;
		private var stageHeightTxt:TextField;
		private var copyBtn:SimpleButton;
		
		public function SVGPagePanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function onRemove():void
		{
	
			mainSp.removeChildren();
			view.removeChildren();
			super.onRemove();
		}		
		override public function onRegister():void
		{

			
			var pageClass:Class = AssetTool.getCurrentLibClass("SVGPagePannel");
			mainSp = new pageClass;
			view.addChild(mainSp);
			
			/*pageList = mainSp.getChildByName("pageList") as List;
			pageList.horizontalScrollBar.direction =ScrollBarDirection.HORIZONTAL;
			pageList.maxHorizontalScrollPosition = 700;
						
			var myDataProvider:DataProvider = new DataProvider();		
			pageList.dataProvider = myDataProvider;*/
			
			stageWidthTxt = mainSp.getChildByName('stageWidthTxt') as TextField;
			stageHeightTxt = mainSp.getChildByName('stageHeightTxt') as TextField;
			copyBtn = mainSp.getChildByName('copyBtn') as SimpleButton;
			stageWidthTxt.restrict = '0-9';
			stageHeightTxt.restrict = '0-9';
			stageWidthTxt.border = true;
			stageHeightTxt.border = true;
			
			stageWidthTxt.addEventListener(MouseEvent.CLICK,clickHandler);
			stageHeightTxt.addEventListener(MouseEvent.CLICK,clickHandler);
			copyBtn.addEventListener(MouseEvent.CLICK,copyClickHandler);
			stageWidthTxt.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,false,1);
			stageHeightTxt.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,false,1);
			super.onRegister();
		}
		
		protected function copyClickHandler(event:MouseEvent):void
		{
			sendNotification(SVGConst.UPDATE_SVG_DOCUMENT);
			var copy:String = SVGConst.svgXML
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, copy);
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER){
				if(int(stageWidthTxt.text)>0 && int(stageHeightTxt.text)>0){
					SVGConst.stageWidth = int(stageWidthTxt.text);
					SVGConst.stageHeight = int(stageHeightTxt.text);
					sendNotification(SVGConst.UPDATE_STAGE_SCALE);
				}
			}
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			(event.target as TextField).setSelection(0,4);
		}
		
		


	}
}