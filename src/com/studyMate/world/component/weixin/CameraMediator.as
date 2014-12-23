package com.studyMate.world.component.weixin
{
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import fl.controls.Button;
	
	import mycomponent.DrawBitmap;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	/**
	 * note
	 * 2014-5-14下午4:48:18
	 * Author wt
	 *
	 */	
	
	internal class CameraMediator extends Mediator
	{
		private var imgHolder:Sprite;
		public var core:String;
		
		public function CameraMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("CameraMediator", viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case WorldConst.CAMERA_OVER:
					var path:String = notification.getBody() as String;
//					trace('cameraImagePath',path);
					loadPhoto(path);
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.CAMERA_OVER];
		}
		
		override public function onRegister():void
		{
			
		}
		
		override public function onRemove():void
		{
			
			super.onRemove();
			if(imgHolder && imgHolder.parent){
				imgHolder.parent.removeChild(imgHolder);
			}
		}
		
		
		private var loadImagePath:String;
		private function loadPhoto(imagePath:String):void{
			if (imagePath) {
				var loader:Loader = new Loader();
				loadImagePath = imagePath;
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(new URLRequest("file://" + imagePath));
			}
		}
		protected function ioErrorHandler(event:IOErrorEvent):void{			
		}
		
		private var bmp:Bitmap;
		private function LoaderComHandler(event:flash.events.Event):void{
			var loader:Loader = event.target.loader as Loader;
			bmp = new DrawBitmap(loader,Global.stageWidth,Global.stageHeight);
			loader.unload();
			if(imgHolder==null){
				imgHolder = new Sprite();
				Global.stage.addChild(imgHolder);
			}
			imgHolder.addChild(bmp);
			var uploadBtn:Button = new Button();
			uploadBtn.label = "上传";
			uploadBtn.scaleX = uploadBtn.scaleY = 2;
//			uploadBtn.x =  200; uploadBtn.y = 700;
			uploadBtn.x = Global.stageWidth -300; uploadBtn.y = 700;
			uploadBtn.addEventListener(MouseEvent.CLICK,uploadPictureHandler);
			imgHolder.addChild(uploadBtn);
			
			var cancleBtn:Button = new Button();
			cancleBtn.label = "取消";
			cancleBtn.scaleX = cancleBtn.scaleY = 2;
			cancleBtn.x =  200; cancleBtn.y = 700;
//			cancleBtn.x = Global.stageWidth -300; cancleBtn.y = 700;
			cancleBtn.addEventListener(MouseEvent.CLICK,canclePictureHandler);
			imgHolder.addChild(cancleBtn);
			
		}
		
		//压缩图片
		private function compressPicture():void{
			var j:JPEGEncoderOptions=new JPEGEncoderOptions(72);
			var b:ByteArray=new ByteArray();
			var rec:Rectangle = new Rectangle(0,0,bmp.width,bmp.height);
			bmp.bitmapData.encode(rec,j,b);
			var file:File = new File(loadImagePath);
			var fs:FileStream = new FileStream();
			try{
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(b);
				fs.close();
			}catch(e:Error){
//				trace(e.message);
			}
		}
		
		
		private function uploadPictureHandler(event:MouseEvent):void{
			compressPicture();//先压缩图片先
			var file:File = new File(loadImagePath);
			var destination:File = Global.document.resolvePath( Global.localPath+VoicechatComponent.owner(core).configText.imgfolder+'/'+file.name);
			file.moveTo(destination,true);	
			if(imgHolder){
				imgHolder.removeChildren();
			}
			var obj:* = VoicechatComponent.owner(core).configText.insertImgFun.apply(null,[destination]);
			if(obj)
			{
				VoicechatComponent.owner(core).addMsgItem(obj);
			}
		}
		
		private function canclePictureHandler(event:MouseEvent):void{
			if(imgHolder){
				imgHolder.removeChildren();
			}
		}
		

	}
}