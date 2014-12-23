package com.studyMate.view.component
{
	import com.studyMate.global.Global;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.filters.BlurFilter;
	import starling.filters.FragmentFilter;

	public class ScreenShots
	{
		public function ScreenShots()
		{
		}
		
		
		public static function getScreent():Image{
			var thumbWidth:Number = Global.stageWidth>>4;
			var thumbHeight:Number =  Global.stageHeight>>4;
			
			var destination:BitmapData = new BitmapData(Global.stageWidth,Global.stageHeight);
			//绘制gpu层
			trace('01',getTimer());
			Starling.current.stage.drawToBitmapData(destination);
			//绘制cpu层
			trace('02',getTimer());
			destination.draw(Global.stage);
			
			trace('03',getTimer());
			var img1:Bitmap = new Bitmap(destination);
			
			//缩放图片
			var holder:Sprite = new Sprite();
			img1.width = thumbWidth;
			img1.height = thumbHeight;
//			holder.filters =  new Array(new flash.filters.BlurFilter(10,10)   );
			holder.addChild(img1);
			var allBmd:BitmapData = new BitmapData(thumbWidth, thumbHeight);
			allBmd.draw(holder);
			var stage3dImg:Image = Image.fromBitmap(new Bitmap(allBmd));
//			var stage3dImg:Image = Image.fromBitmap(img1);
			trace('04',getTimer());
			stage3dImg.filter = new starling.filters.BlurFilter(80,80,0);
//			trace('05',getTimer());
			stage3dImg.width = Global.stageWidth;
			stage3dImg.height = Global.stageHeight;
			return stage3dImg;
		}
	}
}