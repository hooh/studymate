package com.studyMate.world.controller
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display3D.Context3D;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	public class ScreenShotCommand extends SimpleCommand implements ICommand
	{
		public function ScreenShotCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void{
			var r:RenderSupport=new RenderSupport();
			RenderSupport.clear(Starling.current.stage.color,1);
			r.setOrthographicProjection(0,0,Global.stageWidth,Global.stageHeight);
			AppLayoutUtils.gpuLayer.stage.render(r,1);
			r.finishQuadBatch();
			var result:BitmapData=new BitmapData(Global.stageWidth,Global.stageHeight,true);
//			var result:BitmapData=copyAsBitmapData2(MyUtils.gpuLayer);
			Starling.current.context.drawToBitmapData(result);
			result.draw(Global.stage);
			//将图像编码为jpg格式
			var b:ByteArray=new ByteArray();
			b=result.encode(result.rect,new JPEGEncoderOptions(),b);
			
			var file:File = Global.document.resolvePath(Global.localPath+"ScreenShot/"+getTimeFormat()+".jpg");
			var fs:FileStream = new FileStream();
			try{
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(b);
				fs.close();
				trace(file.url)
			}catch(e:Error){
			}
		}
		
		private function getTimeFormat():String {
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyyMMddHHmmss");
			return dateFormatter.format(Global.nowDate);
		}
		
		public static function copyAsBitmapData2(sprite:starling.display.DisplayObject):BitmapData {
			if (sprite == null) return null;
			var resultRect:Rectangle = new Rectangle();
			sprite.getBounds(sprite, resultRect);
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			support.transformMatrix(sprite.root);
			support.translateMatrix( -resultRect.x, -resultRect.y);
			var result:BitmapData = new BitmapData(resultRect.width, resultRect.height, true, 0x00000000);
			support.pushMatrix();
			support.transformMatrix(sprite);
			sprite.render(support, 1.0);
			support.popMatrix();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
		}
		
		public static function copyAsBitmapData(ARG_sprite:DisplayObject):BitmapData {
			
			if ( ARG_sprite == null) {
				return null;
			}
			
			var resultRect:Rectangle = new Rectangle();
			ARG_sprite.getBounds(ARG_sprite, resultRect);
			
			var context:Context3D = Starling.context;
			var scale:Number = Starling.contentScaleFactor;
			
			var nativeWidth:Number = Starling.current.stage.stageWidth;
			var nativeHeight:Number = Starling.current.stage.stageHeight;
			
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0,0,nativeWidth, nativeHeight);
			support.applyBlendMode(true);
			
			if (ARG_sprite.parent){
				support.transformMatrix(ARG_sprite.parent);
			}
			
			support.translateMatrix( -ARG_sprite.x + ARG_sprite.width / 2, -ARG_sprite.y + ARG_sprite.height / 2 );
			
			var result:BitmapData = new BitmapData(nativeWidth, nativeHeight, true, 0x00000000);
			
			support.pushMatrix();
			
			support.blendMode = ARG_sprite.blendMode;
			support.transformMatrix(ARG_sprite);
			ARG_sprite.render(support, 1.0);
			support.popMatrix();
			
			support.finishQuadBatch();
			
			context.drawToBitmapData(result);   
			
			var w:Number = ARG_sprite.width;
			var h:Number = ARG_sprite.height;
			
			if (w == 0 || h == 0) {
				return null;
			}
			
			var returnBMPD:BitmapData = new BitmapData(w, h, true, 0);
			var cropArea:Rectangle = new Rectangle(0, 0, ARG_sprite.width, ARG_sprite.height);
			
			returnBMPD.draw( result, null, null, null, cropArea, true );
			return returnBMPD;
		}
		
	}
}