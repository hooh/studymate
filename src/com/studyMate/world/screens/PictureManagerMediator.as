package com.studyMate.world.screens
{
	import com.edu.AirImagePicker;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import mycomponent.DrawBitmap;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class PictureManagerMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "PictureManagerMediator";
		private var paths:Array;
		private var _pathIndex:int;
		private var container:ScrollContainer;
		private var layout:VerticalLayout;
		
		public function PictureManagerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		public function get isSeleteAll():Boolean
		{
			return _isSeleteAll;
		}

		public function set isSeleteAll(value:Boolean):void
		{
			_isSeleteAll = value;
			if(value){
				selectedAllBtn.label = "全不选";
			}else{
				selectedAllBtn.label = "全选";
			}
		}

		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		private var selectedAllBtn:Button;
		
		private function datainit():void{
			paths = new Array();
			seleFilesArr = new Array();
			paths.push({path:Global.document.resolvePath(Global.localPath + "snapshot/" + Global.user), name:"个人相册"});
			paths.push({path:Global.document.resolvePath(Global.localPath + "CameraCapture"), name:"个人相册New"});
			paths.push({path:Global.document.resolvePath("ScreenCapture"), name:"三星系统截图"});
			paths.push({path:Global.document.resolvePath("Screenshots"), name:"华硕系统截图"});
		}
		
		private var currentPath:TextField;
		
		override public function onRegister():void{
			datainit();
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0xffffff);
			view.addChild(quad);
			
			var changeListBtn:Button = new Button();
			changeListBtn.label = "切换目录";
			changeListBtn.x = 60; changeListBtn.y = 10;
			changeListBtn.addEventListener(starling.events.Event.TRIGGERED,changeListHandler);
			view.addChild(changeListBtn);
			
			currentPath = new TextField(220, 40, "", "HuaKanT", 20, 0xe18242, true);
			currentPath.hAlign = HAlign.LEFT; currentPath.vAlign = VAlign.CENTER;
			currentPath.autoScale = true;
			currentPath.x = 160; currentPath.y = 10;
			view.addChild(currentPath);
			
			selectedAllBtn = new Button();
			selectedAllBtn.label = "全选";
			selectedAllBtn.x = 650; selectedAllBtn.y = 10;
			selectedAllBtn.addEventListener(starling.events.Event.TRIGGERED,selectedAllHandler);
			view.addChild(selectedAllBtn);
			
			var delSelectedBtn:Button = new Button();
			delSelectedBtn.label = "删除所选";
			delSelectedBtn.x = 760; delSelectedBtn.y = 10;
			delSelectedBtn.addEventListener(starling.events.Event.TRIGGERED,delSelectedHandler);
			view.addChild(delSelectedBtn);
			
			var cameraBtn:Button = new Button();
			cameraBtn.label = "拍照";
			cameraBtn.x = 1100; cameraBtn.y = 10;
			cameraBtn.addEventListener(starling.events.Event.TRIGGERED,cameraBtnHandler);
			view.addChild(cameraBtn);
			
			layout = new VerticalLayout();
			layout.gap = 5;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			
			container = new ScrollContainer();
			container.layout = layout;
			container.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			container.snapScrollPositionsToPixels = true;
			container.x = 0; container.y = 80;
			container.width = Global.stageWidth; container.height = Global.stageHeight - 100;
			view.addChild(container);
			
			pathIndex = 0;
			
		}
		
		private function changeListHandler(event:starling.events.Event):void{
			pathIndex = (pathIndex+1) % paths.length;
		}
		
		private var _isSeleteAll:Boolean;
		
		private function selectedAllHandler(event:starling.events.Event):void{
			var i:int;
			if(isSeleteAll){
				isSeleteAll = false;
				for(i = 0; i < container.numChildren; i++){
					((container.getChildAt(i) as Sprite).getChildAt(2) as Check).isSelected = false;
				}
			}else{
				isSeleteAll = true;
				for(i = 0; i < container.numChildren; i++){
					((container.getChildAt(i) as Sprite).getChildAt(2) as Check).isSelected = true;
				}
			}
		}
		
		private function delSelectedHandler(event:starling.events.Event):void{
			for(var i:int = 0; i < seleFilesArr.length; i++){
				var file:File = new File(seleFilesArr[i]);
				if(file.exists){
					file.deleteFile();
				}
				container.removeChild(container.getChildByName(seleFilesArr[i]));
			}
			seleFilesArr = [];
		}
		
		private function cameraBtnHandler(event:starling.events.Event):void{
			AirImagePicker.getInstance().displayCamera(onImagePicked);
		}
		
		protected function onImagePicked(path:String):void{
			if (path) {
				/*var proportion:Number = image.height / image.width;
				var tmp:Bitmap = new Bitmap(image);
				picture = new Image(Texture.fromBitmap(tmp,false));
				picture.pivotX = picture.width >> 1; picture.pivotY = picture.height >> 1;
				picture.x = Global.stageWidth >> 1; picture.y = Global.stageHeight >> 1;
				if(picture.height * 0.8 >= 762){
					picture.scaleX = 0.64; picture.scaleY = 0.64;
				}else{
					picture.scaleX = 0.8; picture.scaleY = 0.8;
				}
				bg = new Quad(Global.stageWidth,Global.stageHeight,0x000000);
				bg.alpha = 0.3;
				view.addChild(bg);
				view.addChild(picture);
				TweenLite.from(bg,0.4,{alpha:0});
				TweenLite.from(picture,0.6,{scaleX:0.1,scaleY:0.1,onComplete:addEventHandler});*/
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(new URLRequest("file://" + path));
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		private function frushContainer():void{
			container.removeChildren(0,-1,true);
			currentPath.text = "当前目录: " + paths[_pathIndex].name;
			var file:File = paths[_pathIndex].path;
			if(!file.exists){
				file.createDirectory();//不存在该目录则创建该目录
			}
			var files:Array = file.getDirectoryListing();
			files = files.filter(fileFilter);
			for each(var obj:* in files){
				var str:String = obj.nativePath;
				var sp:Sprite = makeSpItem(str);
				container.addChild(sp);
			}
		}
		
		private function fileFilter(item:File, index:int, array:Array):Boolean{
			if(item.name.charAt(0) == "."){
				return false;
			}
			return true;
		}
		
		private var seleFilesArr:Array;
		private function makeSpItem(str:String):Sprite{
			var sp:Sprite = new Sprite;
			sp.name = str;
			
			var bg:Quad = new Quad(1200, 35);
			bg.alpha = 0;
			sp.addChild(bg);  //0
			
			var fileURL:TextField = new TextField(600, 35, str, "comic", 15, 0xe18242);
			fileURL.autoScale = true;
			fileURL.hAlign = HAlign.LEFT; fileURL.vAlign = VAlign.CENTER;
			fileURL.x = 0; fileURL.y = 0;
			sp.addChild(fileURL);  //1
			
			var check:Check = new Check();
			check.isSelected = false;
			check.label = "";
			check.x = 620; check.y = (bg.height - check.height)>>1;
			check.addEventListener(starling.events.Event.CHANGE, changeCheckHandler);
			sp.addChild(check);  //2
			
			var dele:Button = new Button();
			dele.label = "删除"; dele.height = 30;
			dele.x = 730; dele.y = 2.5;
			dele.addEventListener(starling.events.Event.TRIGGERED,deleOneHandler);
			sp.addChild(dele);  //3
			
			var look:Button = new Button();
			look.label = "查看"; look.height = 30;
			look.x = 830; look.y = 2.5;
			look.addEventListener(starling.events.Event.TRIGGERED,lookOneHandler);
			sp.addChild(look);  //4
			
			var upload:Button = new Button();
			upload.label = "上传"; upload.height = 30;
			upload.x = 930; upload.y = 2.5;
			upload.addEventListener(starling.events.Event.TRIGGERED,uploadHandler);
			sp.addChild(upload);  //5
			
			return sp;
		}
		
		private var uploadFile:String;
		private function uploadHandler(event:starling.events.Event):void{
			var str:String = (event.target as Button).parent.name;
			uploadFile = str;
			var file:File = new File(str);
			if(file && file.exists){
				(event.target as Button).touchable = false;
				sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,file.name));
			}
		}
		
		private function changeCheckHandler(event:starling.events.Event):void{
			var check:Check = event.currentTarget as Check;
			var str:String = check.parent.name;
			var index:int = seleFilesArr.indexOf(str);
			if(check.isSelected){
				if(index == -1){
					seleFilesArr.push(str);
				}
			}else{
				if(index != -1){
					seleFilesArr.splice(index,1);
				}
			}
		}
		
		private function lookOneHandler(event:starling.events.Event):void{
			var sp:Sprite = (event.currentTarget as Button).parent as Sprite;
			var file:File = new File(sp.name);
			var loader:Loader = new Loader();
			loader.load(new URLRequest("file://" + sp.name));
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
		}
		
		private var picture:Image;
		private var bg:Quad;
		
		private function LoaderComHandler(event:flash.events.Event):void{
			var loader:Loader = event.target.loader as Loader;
			var tmp:Bitmap = new DrawBitmap(loader,loader.width * 610 / loader.height,610);
			picture = new Image(Texture.fromBitmap(tmp,false));
			bg = new Quad(Global.stageWidth,Global.stageHeight,0x000000);
			bg.alpha = 0.3;
			view.addChild(bg);
			picture.pivotX = picture.width >> 1; picture.pivotY = picture.height >> 1;
			picture.x = Global.stageWidth >> 1; picture.y = Global.stageHeight >> 1;
			view.addChild(picture);
			TweenLite.from(bg,0.4,{alpha:0});
			TweenLite.from(picture,0.6,{scaleX:0.1,scaleY:0.1,onComplete:addEventHandler});
		}
		
		private function addEventHandler():void{
			view.addEventListener(TouchEvent.TOUCH, touchStagehandler);
		}
		
		private function touchStagehandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				view.removeEventListener(TouchEvent.TOUCH, touchStagehandler);
				TweenLite.to(bg,0.4,{alpha:0});
				TweenLite.to(picture,0.4,{scaleX:0.1,scaleY:0.1,onComplete:closeBmp});
			}
		}
		
		private function closeBmp():void{
			view.removeChild(picture);
			view.removeChild(bg);
			bg.dispose();
			picture.dispose();
		}
		
		private function deleOneHandler(event:starling.events.Event):void{
			var sp:Sprite = (event.currentTarget as Button).parent as Sprite;
			var file:File = new File(sp.name);
			var index:int = seleFilesArr.indexOf(sp.name);
			if(index != -1){
				seleFilesArr.splice(index,1);
			}
			file.deleteFile();
			container.removeChild(sp);
		}
		
		private function deleUploaded():void{
			if(uploadFile){
				var file:File = new File(uploadFile);
				if(file.exists){
					file.deleteFile();
					container.removeChild(container.getChildByName(uploadFile));
				}
			}
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){	
				case CoreConst.UPLOAD_COMPLETE:
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,647,352, deleUploaded,"上传图片成功，确定删除本地文件吗？"));
					break;
				
			}
		}
		
		public function get pathIndex():int{
			return _pathIndex;
		}
		
		public function set pathIndex(value:int):void{
			_pathIndex = value;
			seleFilesArr = [];
			isSeleteAll = false;
			frushContainer();
		}
		
		override public function listNotificationInterests():Array{
			return [CoreConst.UPLOAD_COMPLETE];
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}