package com.studyMate.world.screens.wallpaper
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.utils.MyUtils;
	
	import flash.display.Bitmap;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class WallpaperSp extends Sprite
	{
		
		private var texture:Texture;
		
		private var _wallpaperData:WallpaperData
		
		public function WallpaperSp(bitmap:Bitmap,_wallpaperData:WallpaperData)
		{
			this._wallpaperData = _wallpaperData;
			
			var imgBg:Image = new Image(Assets.getWallpaperAtlasTexture("posBackground"));
			this.addChild(imgBg);
			texture = Texture.fromBitmap(bitmap,false);
			var sp:Sprite = new Sprite();
			this.addChild(sp);
			var img:Image = new Image(texture);
			img.y = 5;
			img.x = 6;
			sp.addChild(img);
			sp.addEventListener(TouchEvent.TOUCH,seeBigPictureHandler);
			showNewLogo();
		}
		
		private function showNewLogo():void
		{
			var _month:String = _wallpaperData.time.substr(4,2);
			var _day:String = _wallpaperData.time.substr(6,2);
			var _nowMonth:String = MyUtils.getTimeFormat().substr(4,2);
			var _nowDay:String = MyUtils.getTimeFormat().substr(6,2);
			var _newLogoImg:Image
			if(_month == _nowMonth)
			{
				if(Number(_nowDay)-Number(_day)<7)
				{
					_newLogoImg = new Image(Assets.getWallpaperAtlasTexture("newLogo"));
					_newLogoImg.x = 5;
					_newLogoImg.y = 5;
					this.addChild(_newLogoImg);
				}
			}else{
				if(Number(_nowDay)<7&&Number(_day)>24)
				{
					if((Number(_nowDay)+Number(_day))>=23)
					{
						_newLogoImg = new Image(Assets.getWallpaperAtlasTexture("newLogo"));
						_newLogoImg.x = 5;
						_newLogoImg.y = 5;
						this.addChild(_newLogoImg);
					}
				}
			}
		}
		
		private var selectBg:Shape;
		private var selectImg:Image;
		public function selectBackgroud():void
		{
			selectBg = new Shape();
			selectImg = new Image(Assets.getWallpaperAtlasTexture("selectLogo"));
			selectImg.x = 60;
			selectImg.y = 30;
			selectBg.graphics.beginFill(0,0.5);
			selectBg.graphics.drawRect(0,0,270,170);
			selectBg.graphics.endFill();
			this.addChild(selectImg);
			this.addChild(selectBg);
		}
		
		public function hideSelectBackground():void
		{
			this.removeChild(selectBg,true);
			this.removeChild(selectImg);
			selectImg = null
			selectBg = null;
		}
		

		
		private function seeBigPictureHandler(event:TouchEvent):void
		{
			if(event.touches[0].phase == "ended")
			{
				Facade.getInstance(CoreConst.CORE).sendNotification(WallpaperViewMediator.PICTUREITEM,_wallpaperData);
			}
		}
	}
}