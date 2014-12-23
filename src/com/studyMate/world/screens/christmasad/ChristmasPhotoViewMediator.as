package com.studyMate.world.screens.christmasad
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;

	public class ChristmasPhotoViewMediator extends ScreenBaseMediator
	{
		private const NAME:String = "ChristmasAdViewMediator";
		private const yesUploadHandler:String = "yesUploadHandler";
		
		private var camera:Camera;
		private var video:Video;
		private var cpuBackground:flash.display.Sprite;
		private var cameraNames:Array;
		
		private var cameraBtn:starling.display.Button;
		private var tackPhoto:starling.display.Button;
		private var leftBtn:starling.display.Button;
		private var rightBtn:starling.display.Button;
		
		private var cancleBtn:starling.display.Button;
		private var uploadBtn:starling.display.Button;
		
		private var prepareVO:SwitchScreenVO;
		
		private var background:Bitmap;
		private var bmp:Bitmap;
		private var loaders:Loader;
		private var _bmpData:BitmapData;

		
		private var backgroundArr:Array = [];
		private var bgIndex:int = 0;
		private var bgY:int = 155;
		
		public function ChristmasPhotoViewMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return starling.display.Sprite;
		}
		
		public function get view():starling.display.Sprite
		{
			return getViewComponent() as starling.display.Sprite;
		}
		
		override public function onRegister():void
		{
			getAllBackground();
			loaders = new Loader();			
			loaders.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
			loaders.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			camera = Camera.getCamera();
			if (camera) {
				creatBackground();
				connectCamera();
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("你的设备没有摄像头,请按返回键退出",3));
				TweenLite.delayedCall(3,backHapplyIslandHandler);
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("ioerror");
			view.touchable = true;
		}
		
		protected function LoaderComHandler(event:flash.events.Event):void
		{
			if(background!=null)
			{
				cpuBackground.removeChild(background);
			}
			view.touchable = true;
			background = loaders.content as Bitmap;	
			video.x = backgroundArr[bgIndex].substr(backgroundArr[bgIndex].length-7,3);
			video.y = bgY;
			cpuBackground.addChild(background);	
		}
		
		private function getAllBackground():void
		{
			var directory:File = new File(Global.document.resolvePath(Global.localPath+"/Market/ChristmasWallpaper").url);
			if(directory.exists)
			{
				var contents:Array = directory.getDirectoryListing();
				for(var i:int=0;i<contents.length;i++)
				{
					backgroundArr.push(contents[i].nativePath);
				}
			}
			Starling.current.stage.color = 0x000000;
		}		
		
		override public function onRemove():void
		{
			Starling.current.stage.color = 0xffffff;
			if(camera!=null&&video!=null){
				camera = null; 
				video.attachCamera(null);
				AppLayoutUtils.cpuLayer.removeChild(cpuBackground);	
			}
			TweenLite.killDelayedCallsTo(backHapplyIslandHandler);
		}
		
		private function uploadHandler():void
		{
			sendNotification(WorldConst.ALERT_SHOW,new AlertVo("你要花费100金币上传圣诞广告头像吗",true,yesUploadHandler));
		}
		
		private function cancleUploadHandler():void
		{
			cpuBackground.removeChild(bmp);
			openOperationBtn();
		}
		
		private function selectNextBackgroundHandler():void
		{
			if(bgIndex<(backgroundArr.length-1))
			{
				leftBtn.visible  =true;
				bgIndex++;
				loaderBackground(backgroundArr[bgIndex]);
			}
			if(bgIndex==backgroundArr.length-1){
				rightBtn.visible = false
			}
		}
		
		private function selectPreBackgroundHandler():void
		{
			if(bgIndex>0)
			{
				rightBtn.visible  =true;
				bgIndex--;
				loaderBackground(backgroundArr[bgIndex]);
			}
			if(bgIndex == 0)
			{
				leftBtn.visible = false
			}
		
		}
		
		private function selectCameraHandler():void
		{
			if(cameraNames.length>1)
			{
				if(camera.index == 0)
				{
					camera = Camera.getCamera(cameraNames[1]);
				}else{
					camera = Camera.getCamera(cameraNames[0]);
				}
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("你的设备只有一个摄像头~"));
			}
			if(camera){
				connectCamera();
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO(cameraNames[1]));
			}
		}
		
		private function backHapplyIslandHandler():void
		{
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		private function creatBackground():void
		{
			cameraBtn = new starling.display.Button(Assets.getChristmasTexture("changePhoto"));
			cameraBtn.x = 1150;
			cameraBtn.y = 40;
			view.addChild(cameraBtn);
			
			tackPhoto = new starling.display.Button(Assets.getChristmasTexture("takePhotoBtn"));
			tackPhoto.x = 600;
			tackPhoto.y = 600;
			view.addChild(tackPhoto);
			
			leftBtn = new starling.display.Button(Assets.getChristmasTexture("rightBtn"));
			leftBtn.x = 80;
			leftBtn.y = 620;
			leftBtn.scaleX = -1;
			view.addChild(leftBtn);
			
			rightBtn = new starling.display.Button(Assets.getChristmasTexture("rightBtn"));
			rightBtn.x = 180;
			rightBtn.y = 620;
			view.addChild(rightBtn);
			
			cancleBtn = new starling.display.Button(Assets.getChristmasTexture("cancleBtn"));
			cancleBtn.x = 850;
			cancleBtn.y = 620;
			cancleBtn.visible = false;
			view.addChild(cancleBtn);
			
			uploadBtn = new starling.display.Button(Assets.getChristmasTexture("uploadBtn"));
			uploadBtn.x = 1050;
			uploadBtn.y = 620;
			uploadBtn.visible = false
			view.addChild(uploadBtn);
			
			cameraNames = Camera.names;
			if(cameraNames.length <2)
			{
				cameraBtn.visible = false;
			}
			video = new Video();
			creatCpuBackground();
			cameraBtn.addEventListener(starling.events.Event.TRIGGERED,selectCameraHandler);
			tackPhoto.addEventListener(starling.events.Event.TRIGGERED,takePhotoHandler);
			leftBtn.addEventListener(starling.events.Event.TRIGGERED,selectPreBackgroundHandler);
			rightBtn.addEventListener(starling.events.Event.TRIGGERED,selectNextBackgroundHandler);
			cancleBtn.addEventListener(starling.events.Event.TRIGGERED,cancleUploadHandler);
			uploadBtn.addEventListener(starling.events.Event.TRIGGERED,uploadHandler);
		}
		
		private function creatCpuBackground():void
		{
			cpuBackground = new flash.display.Sprite();
			cpuBackground.mouseEnabled = false;
			AppLayoutUtils.cpuLayer.addChild(cpuBackground);
			loaderBackground(backgroundArr[bgIndex]);
			
		}		
		
		private function loaderBackground(path:String):void
		{
			view.touchable = false;
			var _file:File = Global.document.resolvePath(path);
			if(_file.exists){
				loaders.load(new URLRequest(_file.url));
			}	
		}
		
		private function connectCamera():void
		{
			video.x = backgroundArr[bgIndex].substr(backgroundArr[bgIndex].length-7,3)
			video.y = bgY
			video.scaleX = -1.8;
			video.scaleY = 1.6;
			camera.setMode(video.width,video.height,8,false);
			camera.setQuality(0,80);
			video.attachCamera(camera);
			cpuBackground.addChildAt(video,0);
		}
		
		protected function takePhotoHandler():void
		{
			bmp = drawBitmap(cpuBackground,background.width,background.height);
			cpuBackground.addChild(bmp);
			hideOperationBtn();
			
			_bmpData = new BitmapData(800,260,true,0);
			var _matrix:Matrix = new Matrix();
			_matrix.a = 0.625;
			_matrix.d = 0.625;
			_matrix.ty = -155*0.625;
			_bmpData.draw(AppLayoutUtils.cpuLayer,_matrix,null,null,new Rectangle(0,0,1280,416));
		}
		
		private function hideOperationBtn():void
		{
			cameraBtn.visible = false;
			leftBtn.visible = false;
			tackPhoto.visible = false;
			rightBtn.visible = false;
			cancleBtn.visible = true;
			uploadBtn.visible = true;
		}
		
		private function openOperationBtn():void
		{
			cameraBtn.visible = true;
			tackPhoto.visible = true;
			leftBtn.visible = true;
			rightBtn.visible = true;
			cancleBtn.visible = false;
			uploadBtn.visible = false;
			if(bgIndex == backgroundArr.length-1)
			{
				rightBtn.visible = false;
			}else if(bgIndex == 0)
			{
				leftBtn.visible = false;
			}
		}
		
		private function completeHandler():void
		{
			cpuBackground.removeChild(bmp);
			var j:JPEGEncoderOptions=new JPEGEncoderOptions(75);
			var b:ByteArray=new ByteArray();
			var rec:Rectangle = new Rectangle(0,0,800,260);
			_bmpData.encode(rec,j,b);
			var url:String = Global.document.resolvePath(Global.localPath+"Market/ChristmasJPG/"+PackData.app.head.dwOperID+".jpg").url
			var file:File = new File(url);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(b);
			fs.close();
			uploadPhoto();
		}
		
		private function drawBitmap(obj:DisplayObject, thumbWidth:Number, thumbHeight:Number):Bitmap
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(thumbWidth / obj.width, thumbHeight / obj.height);
			var bmpData:BitmapData = new BitmapData(thumbWidth, thumbHeight, true,0);
			bmpData.draw(obj, matrix,null,null,new Rectangle(0,-90,thumbWidth,thumbHeight));			
			var bmp:Bitmap = new Bitmap();
			bmp.bitmapData = bmpData;
			bmp.smoothing = true;
			return bmp;
		}
		
		override public function listNotificationInterests():Array
		{
			return [yesUploadHandler,CoreConst.UPLOAD_SEGMENT_COMPLETE]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case yesUploadHandler:
				{
					completeHandler();
					openOperationBtn();
					break;
				}
				case CoreConst.UPLOAD_SEGMENT_COMPLETE:
				{
					view.touchable = true;
					sendNotification(CoreConst.TOAST,new ToastVO("已发送给圣诞老人了，等他回家查看~",2));
					break;
				}
			}
		}
		
		private function uploadPhoto():void
		{
			view.touchable = false;
			var _file:File = Global.document.resolvePath(Global.localPath+'/Market'+'/ChristmasJPG/'+PackData.app.head.dwOperID+".jpg");
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(_file,"upload/"+_file.name,null,WorldConst.UPLOAD_CHRISTPHOTO));
		}
	}
}