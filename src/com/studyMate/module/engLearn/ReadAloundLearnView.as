package com.studyMate.module.engLearn
{
	import com.studyMate.global.Global;
	import com.studyMate.module.engLearn.ui.AloundLearnItemRenderer;
	import com.studyMate.module.engLearn.ui.ListExtendEnableUI;
	import com.studyMate.module.engLearn.ui.RecordUI;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.Scroller;
	import feathers.controls.ToggleSwitch;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * 朗读模块第一，二，三阶段界面
	 * 2014-10-21上午9:58:19
	 * Author wt
	 *
	 */	
	
	internal class ReadAloundLearnView extends Sprite
	{
		public var preBtn:Button;
		public var nextBtn:Button;
		public var cnSwitch:ToggleSwitch;//显示中文开关
		
		public var recordUI:RecordUI;//录音模块
		
//		public var soundPlayTip:Image;
		public var list:ListExtendEnableUI;
		
		public function ReadAloundLearnView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler(e:Event):void
		{
			var layout:HorizontalLayout = new HorizontalLayout();	
			layout.useVirtualLayout = true;
			list = new ListExtendEnableUI;
			list.itemRendererType = AloundLearnItemRenderer;
			list.x = 0;
			list.y = 0;
			list.setSize(Global.stageWidth,706);
			list.layout = layout;
			list.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			list.snapToPages = true;
			list.hasHorizonDot = true;
			list.setHorizonDotSkin(Assets.readAloudTexture('dot1'),Assets.readAloudTexture('dot0'),715);
			list.horizontalScrollBarFactory = null;
			list.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			this.addChild(list);
			
			
			nextBtn = new Button(Assets.readAloudTexture("nextPageBtn"));
			nextBtn.x = 1162;
			nextBtn.y = 337;
			this.addChild(nextBtn);
			
			preBtn = new Button(Assets.readAloudTexture("nextPageBtn"));
			preBtn.scaleX = -1;
			preBtn.x = 130;
			preBtn.y = 337;
			this.addChild(preBtn);
			
			cnSwitch = new ToggleSwitch();
			cnSwitch.x = 20; cnSwitch.y = 60;
			this.addChild(cnSwitch);
			var boldFontDescription:FontDescription = new FontDescription("HeiTi",FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
			cnSwitch.defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 11, 0xFFFFFF);
			cnSwitch.onLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 11, 0xFFFFFF);
			cnSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			cnSwitch.onTrackProperties.defaultSkin = new Image(Assets.readAloudTexture("switchTrack"));
			cnSwitch.thumbProperties.defaultSkin =  new Image(Assets.readAloudTexture("switchThumb"));
			cnSwitch.onTrackProperties.stateToSkinFunction = null;
			cnSwitch.thumbProperties.stateToSkinFunction = null;
			cnSwitch.thumbProperties.minWidth = cnSwitch.thumbProperties.minHeight = 21;
			cnSwitch.thumbProperties.minTouchWidth = cnSwitch.thumbProperties.minTouchHeight = 40;
			cnSwitch.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
			
			
			recordUI = new RecordUI();
			recordUI.x = 1178;
			recordUI.y = 534;
			this.addChild(recordUI);
			
			
			
		}
	}
}