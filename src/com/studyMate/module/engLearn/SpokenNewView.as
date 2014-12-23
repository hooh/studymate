package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.studyMate.module.engLearn.ui.SpokenGradeUI;
	import com.studyMate.module.engLearn.ui.SpokenSea;
	import com.studyMate.view.component.GpuTextField.TextFieldToGPU;
	
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.display.Scale9Image;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class SpokenNewView extends Sprite
	{
		private var shipImg:Image;
		public var listScroll:ScrollContainer;

		public var changeModeTxt:starling.text.TextField;
		public var familyGradeUI:SpokenGradeUI;//家长评定按钮界面
		public var recordStartBtn:Button;
		public var recordStopBtn:Button;
		public var contentTxt:flash.text.TextField;
		public var contentGpu:TextFieldToGPU;
		public var changeModeBtn:Button;
		public var recordTimeTxt:starling.text.TextField;
		public var mySoundBtn:Button;
		public var downStandardBtn:Button;
		public var playStandardBtn:Button;
		public var pauseStandardBtn:Button;
		public var slider:Slider;
		public var sizeSlider:Slider;
		public var titleTxt:flash.text.TextField;
		public var titleGpu:TextFieldToGPU;
		public var idTxt:starling.text.TextField;
		
		public function SpokenNewView()
		{
			
		}
		//因为现在是先实例化在加载素材的的。所以不能写在构造函数里
		public function init():void{			
			var spokenSea:SpokenSea = new SpokenSea();//骇浪
			this.addChild(spokenSea);
			
			
			var bg:Image = new Image(Assets.getEgLearnSpokenTexture('spokenBlueBg'));//蓝天
			this.addChild(bg);			
			shipImg = new Image(Assets.getEgLearnSpokenTexture('shipImg'));//大海
			shipImg.x = 1000;
			shipImg.y = 650;
			shipImg.scaleX = 0.1;
			shipImg.scaleY = 0.1;
			this.addChild(shipImg);
			TweenLite.to(shipImg,40,{scaleX:1,scaleY:1,x:1280,y:700,ease:Circ.easeIn});
			
			
			/**------------------------------文本-----------------------------*/
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 2;
			layout.paddingBottom =20;
			listScroll = new ScrollContainer();
			listScroll.x = -50;
			listScroll.y = 100;
			listScroll.paddingLeft = 308;
			listScroll.width = 1330;
			listScroll.height = 570;
			listScroll.layout = layout;
			listScroll.snapScrollPositionsToPixels = true;	
			this.addChild(listScroll);
			
			var myDropFilter:DropShadowFilter = new DropShadowFilter(1, 45, 0xFFFFFF, 1, 1, 1, 10, 1, false, false); 
			var fkFilters:Array = new Array(); 
			fkFilters.push(myDropFilter);
			
			var tf1:TextFormat = new TextFormat("HeiTi",24,0,true);
			tf1.align = TextFormatAlign.CENTER;
			titleTxt = new flash.text.TextField();
			titleTxt.defaultTextFormat = tf1;
			titleTxt.autoSize = TextFieldAutoSize.CENTER;
			titleTxt.wordWrap = true;
			titleTxt.multiline = true;
			titleTxt.embedFonts = true;
			titleTxt.antiAliasType = AntiAliasType.ADVANCED;
			titleTxt.width = 880;
			titleTxt.height = 54;
			titleTxt.filters = fkFilters;
			titleGpu = new TextFieldToGPU();
			titleGpu.x = 200;
			titleGpu.y = 36;
			this.addChild(titleGpu);
			
			
			contentGpu = new TextFieldToGPU();			
			listScroll.addChild(contentGpu);
			var tf:TextFormat = new TextFormat("HeiTi",22,0,false);
			tf.leading = 7;	
			tf.indent = 8;
			tf.letterSpacing = 1;
			tf.leading = 10;
			contentTxt = new flash.text.TextField();
			contentTxt.embedFonts = true;
			contentTxt.autoSize = TextFieldAutoSize.LEFT;
			contentTxt.antiAliasType = AntiAliasType.ADVANCED;
			contentTxt.defaultTextFormat = tf;
			contentTxt.width = 800;
			contentTxt.multiline = true;
			contentTxt.wordWrap = true;			
			contentTxt.filters = fkFilters;
			
			//切换模式
			changeModeBtn = new Button(Assets.getEgLearnSpokenTexture('changModeBtn'));
			changeModeBtn.x = 37;
			changeModeBtn.y = -15;
			this.addChild(changeModeBtn);
			
			//切换模式文本
			changeModeTxt = new starling.text.TextField(125,80,'正常模式','HeiTi',15,0x705AF4,true);
			changeModeTxt.x = 37;
			changeModeTxt.y = 22;
			changeModeTxt.touchable = false;
			this.addChild(changeModeTxt);
			
			//家长评定按钮
			familyGradeUI = new SpokenGradeUI();
			this.addChild(familyGradeUI);
			
			//录音按钮
			recordStartBtn = new Button(Assets.getEgLearnSpokenTexture('recordStartBtn'));
			recordStartBtn.x = 1143;
			recordStartBtn.y = 537;
			this.addChild(recordStartBtn);
			
			
			//结束录音按钮
			recordStopBtn = new Button(Assets.getEgLearnSpokenTexture('recordStopBtn'));
			recordStopBtn.x = 1143;
			recordStopBtn.y = 537;
			recordStopBtn.visible = false;
			this.addChild(recordStopBtn);
			
			recordTimeTxt = new starling.text.TextField(120,50,'','HeiTi',15);
			recordTimeTxt.x = 1120;
			recordTimeTxt.y = 610;
			this.addChild(recordTimeTxt);
			recordTimeTxt.touchable = false;
			
			mySoundBtn = new Button(Assets.getEgLearnSpokenTexture('myRecordBtn'));
			mySoundBtn.x = 1146;
			mySoundBtn.y = 419;
			this.addChild(mySoundBtn);
			//下载录音
			downStandardBtn = new Button(Assets.getEgLearnSpokenTexture('DownStandardBtn'));
			downStandardBtn.x = 208;
			downStandardBtn.y = 686;
			this.addChild(downStandardBtn);
			downStandardBtn.visible = false;
			
			
			
			
			idTxt = new starling.text.TextField(50,24,'',"HeiTi",12);
			idTxt.x = 0;
			idTxt.y = 730;
			this.addChild(idTxt);
			
			
			sizeSlider = new Slider();
			sizeSlider.direction = Slider.DIRECTION_VERTICAL;
			sizeSlider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			sizeSlider.height = 172;
			sizeSlider.width = 13;
			sizeSlider.minimum = 22; sizeSlider.maximum = 40;
			sizeSlider.step = 1;
			sizeSlider.page = 1;
			sizeSlider.value = 25;
			
			sizeSlider.minimumPadding = -2;
			sizeSlider.maximumPadding = -2;
			sizeSlider.x = 38; sizeSlider.y = 275;
			this.addChild(sizeSlider);
			sizeSlider.liveDragging = false;
			sizeSlider.thumbProperties.defaultSkin = new Image(Assets.getEgLearnSpokenTexture("soundThumb"));			
			var minRect:Rectangle = new Rectangle(0,4,12,3);
			var minScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getEgLearnSpokenTexture("minTrackVertical"),minRect);
			sizeSlider.minimumTrackProperties.defaultSkin = new Scale9Image(minScale9Txtur);
			var maxRect:Rectangle = new Rectangle(0,6,12,3);
			var maxScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getEgLearnSpokenTexture("maxTrackVertical"),maxRect);
			sizeSlider.maximumTrackProperties.defaultSkin = new Scale9Image(maxScale9Txtur);			
			sizeSlider.thumbProperties.stateToSkinFunction = null;
			sizeSlider.minimumTrackProperties.stateToSkinFunction = null;
			sizeSlider.maximumTrackProperties.stateToSkinFunction = null;
			sizeSlider.thumbProperties.minWidth = sizeSlider.thumbProperties.minHeight = 18;
			
		}
		//初始化录音功能
		public function initDownStandardBtn():void{
			//播放录音
			playStandardBtn = new Button(Assets.getEgLearnSpokenTexture('playStandardBtn'));
			playStandardBtn.x = 208;
			playStandardBtn.y = 686;
			this.addChild(playStandardBtn);
			playStandardBtn.visible = false;
			//暂停录音
			pauseStandardBtn = new Button(Assets.getEgLearnSpokenTexture('stopStandardBtn'));
			pauseStandardBtn.x = 208;
			pauseStandardBtn.y = 686;
			this.addChild(pauseStandardBtn);
			pauseStandardBtn.visible = false;
			
			slider = new Slider();
			slider.visible = false;
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			slider.width = 600;
			slider.step = 1; slider.page = 2;
			slider.minimum = 0; slider.maximum = 100;
			slider.minimumPadding = -2;
			slider.maximumPadding = -2;
			slider.x = 382; slider.y = 706;
			this.addChild(slider);
			slider.liveDragging = false;
			slider.thumbProperties.defaultSkin = new Image(Assets.getEgLearnSpokenTexture("soundThumb"));			
			var minRect:Rectangle = new Rectangle(4,0,3,12);
			var minScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getEgLearnSpokenTexture("minTrack"),minRect);
			slider.minimumTrackProperties.defaultSkin = new Scale9Image(minScale9Txtur);
			var maxRect:Rectangle = new Rectangle(1,0,3,12);
			var maxScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getEgLearnSpokenTexture("maxTrack"),maxRect);
			slider.maximumTrackProperties.defaultSkin = new Scale9Image(maxScale9Txtur);			
			slider.thumbProperties.stateToSkinFunction = null;
			slider.minimumTrackProperties.stateToSkinFunction = null;
			slider.maximumTrackProperties.stateToSkinFunction = null;
			slider.thumbProperties.minWidth = slider.thumbProperties.minHeight = 18;
		}
		
		
		override public function dispose():void
		{
			TweenLite.killTweensOf(shipImg);
			super.dispose();
		}
		
		
	}
}