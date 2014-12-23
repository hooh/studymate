package com.studyMate.world.screens.ui.setSound
{
	import com.studyMate.world.screens.ui.video.VideoBitmapFontItemRender;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.List;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;
	import feathers.display.Scale9Image;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class SetSoundView extends Sprite
	{
		public var bgtswitch:ToggleSwitch;
		public var sefftswitch:ToggleSwitch;
		public var softKeySoundSwitch:ToggleSwitch;
		public var slider:Slider;
		public var playList:List;//列表组件
		
		public function SetSoundView()
		{
				
		}
		
		public function init():void{
			var img:Image = new Image(Assets.getTexture("soundSetBg"));
			this.addChild(img);
			
			slider = new Slider();
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			slider.width = 540;
			slider.step = 1; slider.page = 2;
			slider.minimum = 0; slider.maximum = 100;
			slider.x = 260; slider.y = 18;
			this.addChild(slider);
			slider.liveDragging = false;
			slider.thumbProperties.defaultSkin = new Image(Assets.getAtlasTexture("set/soundSet/soundThumb"));			
			var minRect:Rectangle = new Rectangle(4,0,3,12);
			var minScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getAtlasTexture("set/soundSet/minTrack"),minRect);
			slider.minimumTrackProperties.defaultSkin = new Scale9Image(minScale9Txtur);
			var maxRect:Rectangle = new Rectangle(1,0,3,12);
			var maxScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getAtlasTexture("set/soundSet/maxTrack"),maxRect);
			slider.maximumTrackProperties.defaultSkin = new Scale9Image(maxScale9Txtur);			
			slider.thumbProperties.stateToSkinFunction = null;
			slider.minimumTrackProperties.stateToSkinFunction = null;
			slider.maximumTrackProperties.stateToSkinFunction = null;
			slider.thumbProperties.minWidth = slider.thumbProperties.minHeight = 18;
			
			var switchTrack:Scale9Image = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchTrack"),new Rectangle(0,0,61,21)));
			var switchThumb:Scale9Image = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchThumb"),new Rectangle(0,0,23,26)));
			
			bgtswitch = new ToggleSwitch();
			bgtswitch.x = 877; bgtswitch.y = 77;
			this.addChild(bgtswitch);
			setStyle(bgtswitch);//设定样式
			
			sefftswitch = new ToggleSwitch();
			sefftswitch.x = 877; sefftswitch.y = 137;
			this.addChild(sefftswitch);
			setStyle(sefftswitch);
			
			softKeySoundSwitch = new ToggleSwitch();
			softKeySoundSwitch.x = 877; softKeySoundSwitch.y = 196;
			this.addChild(softKeySoundSwitch);
			setStyle(softKeySoundSwitch);

			
		}
		public function initList():void{
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 51;		
			layout.paddingBottom =100;
			playList = new List();
			playList.allowMultipleSelection = false;
			playList.x = 2;
			playList.y = 310;
			playList.width = 976;
			playList.height = 415;
			playList.layout = layout;
			playList.itemRendererType = SetSoundBitmapItemRenderer;
			this.addChild(playList);
		}
		
		private function setStyle(togle:ToggleSwitch):void{
			var boldFontDescription:FontDescription = new FontDescription("HeiTi",FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
			togle.defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 11, 0xFFFFFF);
//			togle.defaultLabelProperties.embedFonts = true;
			togle.onLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 11, 0xFFFFFF);
//			togle.onLabelProperties.embedFonts = true;
			togle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			togle.onTrackProperties.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchTrack"),new Rectangle(0,0,61,21)));
			togle.thumbProperties.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchThumb"),new Rectangle(0,0,23,26)));
			togle.onTrackProperties.stateToSkinFunction = null;
			togle.thumbProperties.stateToSkinFunction = null;
			togle.thumbProperties.minWidth = togle.thumbProperties.minHeight = 21;
			togle.thumbProperties.minTouchWidth = togle.thumbProperties.minTouchHeight = 40;
			togle.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
		}
	}
}