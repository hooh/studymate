package com.studyMate.world.screens.view
{
	import com.studyMate.view.component.GpuTextField.TextFieldToGPU;
	import com.studyMate.world.screens.ui.UserPerDataItemRenderer;
	
	import flash.display.Loader;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.KeyBoardConst;
	import myLib.myTextBase.utils.KeyboardType;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	
	/**
	 * note
	 * 2014-12-11下午4:21:10
	 * Author wt
	 *
	 */	
	
	public class UserPerDataView extends Sprite
	{
		public var playList:List;
		public var listCollection:ListCollection;
		public var input:TextFieldHasKeyboard;//口语

		public var contentTxt:flash.text.TextField;
		public var contentGpu:TextFieldToGPU;
		public var listScroll:ScrollContainer;
		
		
		public var timeTxt:starling.text.TextField;
		
		public function UserPerDataView()
		{
			var bg:Quad = new Quad(1280,752,0);
			bg.alpha = 0.5;
			this.addChild(bg);
			
			var txt:starling.text.TextField = new starling.text.TextField(200,50,"请输入用户id标识:","HeiTi",22);
			txt.x = 910;
			txt.y = 20;
			this.addChild(txt);
			
			timeTxt = new starling.text.TextField(220,50,'',"HeiTi",22);
			timeTxt.x = 30;
			timeTxt.y = 20;
			this.addChild(timeTxt);
			
			var tf:TextFormat = new TextFormat("HeiTi",33,0xFFFFFF);
			input = new TextFieldHasKeyboard();
			input.width = 160;
			input.height = 50;
			input.embedFonts = true;
			input.defaultTextFormat = tf;
			input.x = 1114;
			input.y = 20;
			input.border = true;
			input.maxChars = 15;
			Starling.current.nativeOverlay.addChild(input);
			KeyBoardConst.current_Keyboard = KeyboardType.SIMPLE_KEYBOARD;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.paddingBottom = 100;
			layout.gap = 2;
			playList = new List();
			playList.allowMultipleSelection = false;
			playList.x = 620;
			playList.y = 100;
			playList.width = 760;
			playList.height = 560;
			playList.paddingLeft = 0;
			playList.layout = layout;
			playList.itemRendererType = UserPerDataItemRenderer;
			this.addChild(playList);
			
			
			///////////////////////左侧-口语文本//////////////////////////////////////////
			
			var layout1:VerticalLayout = new VerticalLayout();
			layout1.gap = 2;
			layout1.paddingBottom =20;
			listScroll = new ScrollContainer();
			listScroll.x = 0;
			listScroll.y = 100;
			listScroll.paddingLeft = 0;
			listScroll.width = 610;
			listScroll.height = 560;
			listScroll.layout = layout1;
			listScroll.snapScrollPositionsToPixels = true;	
			this.addChild(listScroll);
			
			
//			var myDropFilter:DropShadowFilter = new DropShadowFilter(1, 45, 0xFFFFFF, 1, 1, 1, 10, 1, false, false); 
//			var fkFilters:Array = new Array(); 
//			fkFilters.push(myDropFilter);
			
			contentGpu = new TextFieldToGPU();			
			listScroll.addChild(contentGpu);
			var tf1:TextFormat = new TextFormat("HeiTi",22,0xFFFFFF,false);
			tf1.leading = 7;	
			tf1.indent = 8;
			tf1.letterSpacing = 1;
			tf1.leading = 2;
			contentTxt = new flash.text.TextField();
			contentTxt.embedFonts = true;
			contentTxt.autoSize = TextFieldAutoSize.LEFT;
			contentTxt.antiAliasType = AntiAliasType.ADVANCED;
			contentTxt.defaultTextFormat = tf1;
			contentTxt.width = 610;
			contentTxt.multiline = true;
			contentTxt.wordWrap = true;			
//			contentTxt.filters = fkFilters;
		}
		
		override public function dispose():void
		{
			super.dispose();
			Starling.current.nativeOverlay.removeChild(input);
		}
		
	}
}