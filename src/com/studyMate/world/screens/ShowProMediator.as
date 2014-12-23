package com.studyMate.world.screens
{
	import com.edu.AirImagePicker;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.PromiseVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.utils.ByteArray;
	
	import feathers.controls.Button;
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	
	import mycomponent.DrawBitmap;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class ShowProMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ShowProMediator";
//		public static const CHECK_PROMISE:String = NAME + "CheckPromises";
		public static const SHOW_ALL:String = NAME + "ShowAllPromises";
		public static const SHOW_UNFINISH:String = NAME + "ShowUnfinishPro";
		public static const SHOW_FINISH:String = NAME + "ShowFinishedPro";
		public static const DELETE_PROMISE:String = NAME + "DeletePromiseByProid";
		public static const CONFIRM_PROMISE:String = NAME + "ConfirmPromise";
		public static const GET_PROMISE_BY_PAGE:String = NAME + "GetPromisesByPage";
		public static const GET_PRO_FIRST:String = NAME + "GetProFirst";
		
		private var containerSp:starling.display.Sprite;
		private var status:String = "*";
		private var currentPage:int = 0;
		private var totalPage:int = 0;
		
		private var vo:SwitchScreenVO;
		private var proData:Vector.<PromiseVO>;
		private var makeProBtn:starling.display.Button;
		private var pageIndex:starling.text.TextField;
		private var textureList:Vector.<Texture>;
		
		private var LOCAL_PIC_PATH:String = Global.localPath + "userdata/" + Global.player.operId.toString() + "/promise/";
		private var REMOTE_PIC_PATH:String = "promise/";
		private var isThisUpload:Boolean;
		
		public function ShowProMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}

		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.CHECK_PROMISE);
		}
		
		override public function onRegister():void{
//			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.HIDE_MENU_BUTTON);
			textureList = new Vector.<Texture>;
			/*sendNotification(WorldConst.HIDE_MAIN_MENU);*/
			initBackGround();
			addButtons();
			addProHolder();
			dealThemeTwoData();
			
			trace("@VIEW:ShowProMediator:");
		}
		
		override public function onRemove():void{
			sendNotification(WorldConst.SHOW_MENU_BUTTON);
			clearTexture();
			if(tabs){
				tabs.removeEventListener( starling.events.Event.CHANGE, tabs_changeHandler );
				tabs.removeEventListeners();
			}
			if(proData){
				proData.length=0;
				proData = null;
			}if(proPicArray) {
				proPicArray.length = 0;
				proPicArray = null;
			}
			view.removeChildren(0,-1,true);
			if(queue){
				queue.unload();
				queue.dispose();
				queue = null;
			}
			this.vo.data = null;
			this.vo = null;
			TweenMax.killTweensOf(makeProBtn);
			makeProBtn= null;
			sendNotification(WorldConst.SHOW_MENU_BUTTON);
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			/*sendNotification(WorldConst.SHOW_MAIN_MENU);*/
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.CHECK_PROMISE_OVER :
					firstGetData();
					break;
				case GET_PROMISE_BY_PAGE : 
					if(!result.isEnd){
						proData.push(new PromiseVO(PackData.app.CmdOStr[1],
							PackData.app.CmdOStr[2],
							PackData.app.CmdOStr[3],
							PackData.app.CmdOStr[4],
							PackData.app.CmdOStr[5],
							PackData.app.CmdOStr[6],
							PackData.app.CmdOStr[7],
							PackData.app.CmdOStr[8],
							PackData.app.CmdOStr[11],
							PackData.app.CmdOStr[12]));
						totalPage = parseInt(PackData.app.CmdOStr[9]);
						currentPage = parseInt(PackData.app.CmdOStr[10]);
					}else{
						tabs.addEventListener( starling.events.Event.CHANGE, tabs_changeHandler );
						dealThemeTwoData();
					}
					break;
				case GET_PRO_FIRST :
					if(!result.isEnd){
						proData.push(new PromiseVO(PackData.app.CmdOStr[1],
							PackData.app.CmdOStr[2],
							PackData.app.CmdOStr[3],
							PackData.app.CmdOStr[4],
							PackData.app.CmdOStr[5],
							PackData.app.CmdOStr[6],
							PackData.app.CmdOStr[7],
							PackData.app.CmdOStr[8],
							PackData.app.CmdOStr[11],
							PackData.app.CmdOStr[12]));
						totalPage = parseInt(PackData.app.CmdOStr[9]);
						currentPage = parseInt(PackData.app.CmdOStr[10]);
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
				case DELETE_PROMISE : 
					if(!result.isErr){
						Global.myPromiseInf.unFinishCount = parseInt(PackData.app.CmdOStr[2]);
						Global.myPromiseInf.minTarget = parseInt(PackData.app.CmdOStr[3]);
						if(proData.length > 1){
							getProByPage(currentPage);
						}else{
							getProByPage(currentPage - 1);
						}
					}
					break;
				case CONFIRM_PROMISE : 
					if(!result.isErr){
						hasConfirm();
					}
					break;
				case CoreConst.UPLOAD_COMPLETE:
					if(isThisUpload){
						
						var uploadvo:UpLoadCommandVO = notification.getBody() as UpLoadCommandVO;
						fileid = uploadvo.fileid;
						updatePromiseAtFileid();
						isThisUpload = false;
					}
					break;
				case UPDATE_PROMISE_FILEID :
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,647,352, deleUploaded,"上传图片成功，点击确认删除本地文件！",confirmOrFrush));
					break;
				case DOWNLOAD_COMPLETE :
					var proid:String = notification.getBody() as String;
					trace(proid);
					loadPhoto(proid);
					break;
			}
		}
		
		private var UPDATE_PROMISE_FILEID:String = NAME + "UpdatePromiseFileid";
		private function updatePromiseAtFileid():void{
			if(cameraId!=null){				
				PackData.app.CmdIStr[0] = CmdStr.UPDATE_PROMISE;
				PackData.app.CmdIStr[1] = cameraId.toString();
				PackData.app.CmdIStr[2] = fileid.toString();
				PackData.app.CmdInCnt = 3;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(UPDATE_PROMISE_FILEID));
			}
		}
		
		private function hasConfirm():void{
			for(var i:int = 0; i < proData.length; i++){
				if(proData[i].proid == confirmProid.toString()){
					proData[i].rwstatus = "Y";
					break;
				}
			}
			dealThemeTwoData();
			addConfirmTips();
//						getProByPage(currentPage);
		}
		
		private var fileid:int;
		
		override public function listNotificationInterests():Array{
			return [WorldConst.CHECK_PROMISE_OVER,GET_PROMISE_BY_PAGE,DELETE_PROMISE,CONFIRM_PROMISE,
				CoreConst.UPLOAD_COMPLETE,UPDATE_PROMISE_FILEID,DOWNLOAD_COMPLETE,GET_PRO_FIRST];
		}
		
		private function initBackGround():void{
			var bgImage:Image = new Image(Assets.getTexture("showPro"));
			bgImage.touchable = false;
			view.addChild(bgImage);
		}
		
		
		private var tabs:TabBar;
		private function addButtons():void{
			makeProBtn = new starling.display.Button(Assets.getAtlasTexture("targetWall/makePro"));
			makeProBtn.x = 40; makeProBtn.y = 595;
			view.addChild(makeProBtn);
			makeProBtn.addEventListener(starling.events.Event.TRIGGERED, makeProBtnHandler);
			TweenMax.to(makeProBtn, 1, {x:45, y:590, yoyo:true,repeat:int.MAX_VALUE});
			
			tabs = new TabBar();
			tabs.dataProvider = new ListCollection(
				[
					{label: "未完成"},
					{label: "已完成"},
					{label: "全   部"}
				]);
			tabs.x = 96; tabs.y = 339;
			view.addChild(tabs);
			tabs.addEventListener( starling.events.Event.CHANGE, tabs_changeHandler );
			setTabBarTheme(tabs);
			
			//初始化tab
			status = "N";
			totalPage = 0; currentPage = 0;
//			getProByPage(1);
		}

		private function addProHolder():void{
			var holderBg:Image = new Image(Assets.getTexture("proHolder"));
			view.addChild(holderBg);
			holderBg.x = 258; holderBg.y = 41;
			
			var texture:Texture = Assets.getAtlasTexture("flip/zuo");
			var preBtn:starling.display.Button;
			var nextBtn:starling.display.Button;
			preBtn = new starling.display.Button(texture);
			preBtn.x = 647; preBtn.y = 675;
			preBtn.addEventListener(starling.events.Event.TRIGGERED,preBtnHandle);
			view.addChild(preBtn);
			
			nextBtn = new starling.display.Button(texture);
			nextBtn.x = 840 + nextBtn.width; nextBtn.y = 675 + nextBtn.height;
			nextBtn.rotation = Math.PI;
			nextBtn.addEventListener(starling.events.Event.TRIGGERED, nextBtnHandle);
			view.addChild(nextBtn);
			
			pageIndex = new starling.text.TextField(140,45,currentPage + "/" + totalPage,"HuaKanT",28);
			pageIndex.x = 700;
			pageIndex.y = 675;
			view.addChild(pageIndex);
			
			containerSp = new starling.display.Sprite();
			containerSp.x = 300;
			containerSp.y = 81;
			view.addChild(containerSp);
		}
		
		private function makeProBtnHandler(event:starling.events.Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MakeProMediator,null,SwitchScreenType.SHOW,null)]);
		}
		
		private function tabs_changeHandler( event:starling.events.Event ):void{
			if(tabs.selectedIndex == 0){
				status = "N";
			}else if(tabs.selectedIndex == 1){
				status = "Y";
			}else if(tabs.selectedIndex == 2){
				status = "*";
			}
			totalPage = 0; currentPage = 0;
			getProByPage(1);
		}
		
		private function setTabBarTheme(tabs:TabBar):void{
			tabs.width = 176; tabs.gap = 0;
			tabs.direction = TabBar.DIRECTION_VERTICAL;
			tabs.customTabName = "ShowPromiseTabBar";
			tabs.tabFactory = tabButtonFactory;
			tabs.tabProperties.stateToSkinFunction = null;
			
//			tabs.tabProperties.@defaultLabelProperties.textFormat = new TextFormat("HuaKanT", 38, 0xffffff, false);
//			tabs.tabProperties.@defaultLabelProperties.embedFonts = true;
//			
//			tabs.tabProperties.@defaultSelectedLabelProperties.textFormat = new TextFormat("HuaKanT", 38, 0x835e45, false);
//			tabs.tabProperties.@defaultSelectedLabelProperties.embedFonts = true;
			
			var boldFontDescription:FontDescription = new FontDescription("HuaKanT",FontWeight.NORMAL,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
			tabs.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 38, 0xffffff);
			tabs.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription, 38, 0x835e45)

			
		}
		
		private function tabButtonFactory():feathers.controls.Button{
			var tab:ToggleButton = new ToggleButton();
			tab.defaultSkin = new Image(Assets.getAtlasTexture("targetWall/unSelectBtn"));
			tab.defaultSelectedSkin = new Image(Assets.getAtlasTexture("targetWall/selectBtn"));
			tab.downSkin = new Image(Assets.getAtlasTexture("targetWall/selectBtn"));
			return tab;
		}
		
		private function getProByPage(pageNumber:int):void{
			proData = null;
			proData = new Vector.<PromiseVO>;
			PackData.app.CmdIStr[0] = CmdStr.QUERY_PROMISE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "00000000";
			PackData.app.CmdIStr[3] = "YYYYMMDD";
			PackData.app.CmdIStr[4] = status;
			PackData.app.CmdIStr[5] = "4";
			PackData.app.CmdIStr[6] = pageNumber.toString();
			PackData.app.CmdInCnt = 7;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_PROMISE_BY_PAGE));
			tabs.removeEventListener( starling.events.Event.CHANGE, tabs_changeHandler );
		}
		
		private function firstGetData():void{
			proData = new Vector.<PromiseVO>;
			PackData.app.CmdIStr[0] = CmdStr.QUERY_PROMISE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "00000000";
			PackData.app.CmdIStr[3] = "YYYYMMDD";
			PackData.app.CmdIStr[4] = "N";
			PackData.app.CmdIStr[5] = "4";
			PackData.app.CmdIStr[6] = "1";
			PackData.app.CmdInCnt = 7;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_PRO_FIRST));
		}
		
		private var proPicArray:Array;
		private var queue:LoaderMax;
		
		private function getPictureArray():void{
			var file:File = Global.document.resolvePath(LOCAL_PIC_PATH);
			if(file.exists){
				proPicArray = file.getDirectoryListing();
			}else{
				file.createDirectory();
			}
		}
		
		private function dealThemeTwoData():void{
			containerSp.removeChildren(0, -1, true);
			if(proData.length == 0){
				totalPage = 0; currentPage = 0;
				pageIndex.text = currentPage + "/" + totalPage;
				if(status == "*"){
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,647,352, null,"还没有约定？点击左下角闪烁按钮可以制定约定哟！(*^__^*)嘻嘻"));
				}
				return;
			}
			getPictureArray();
			queue = new LoaderMax({name:"mainQueue", onComplete:loadCompleteHandler});
			for(var j:int = 0; j < proData.length ; j++){
				var smallUrl:String = searchUrl(proData[j].proid + "small.jpg");
				if(smallUrl != null){   //有照片
					proData[j].hasImage = true;
					proData[j].imageURL = smallUrl;
					var obj:Object = {name:proData[j].proid,onComplete:imageCompleteHandler};
					var loader:ImageLoader = new ImageLoader(smallUrl,obj);
					queue.append(loader);
				}
			}
			queue.load();
		}
		
		private function clearTexture():void{
			if(textureList){
				for(var i:int=0;i<textureList.length;i++){
					textureList[i].dispose();
				}
				textureList.length = 0 ;
				textureList = null;
			}
		}
		
		private function imageCompleteHandler(event:LoaderEvent):void{
//			clearTexture();			
			var _width:Number = 102; var _height:Number = 77;
			if(event.target.content.height > event.target.content.width){
				_width = 77; _height = 102;
			}
			var tmpData:BitmapData = new BitmapData(_width,_height);
			tmpData.draw(event.target.content);
			for(var i:int = 0; i < proData.length; i++){
				if(proData[i].proid == event.target.name){
					var texture:Texture = Texture.fromBitmapData(tmpData,false);
					proData[i].image = new Image(texture);
					textureList.push(texture);
					return;
				}
			}
		}
		
		private function loadCompleteHandler(event:LoaderEvent):void{
			for(var i:int = 0; i < proData.length ; i++){
				var sp:PromiseItem = new PromiseItem();
				sp.promise = proData[i];
				sp.deleteBtn.addEventListener(starling.events.Event.TRIGGERED,delBtnHandler);
				if(sp.smallCamerBtn){
					sp.smallCamerBtn.addEventListener(starling.events.Event.TRIGGERED, cameraBtnHandler);
				}
				if(sp.cameraBtn){
					sp.cameraBtn.addEventListener(starling.events.Event.TRIGGERED, cameraBtnHandler);
				}
				if(sp.confirm){
					sp.confirm.addEventListener(starling.events.Event.TRIGGERED, confirmBtnHandler);
				}
				if(sp.photo){
					sp.photo.addEventListener(TouchEvent.TOUCH, smallPhotoTouchEvent);
//					sp.photo.addEventListener(starling.events.Event.TRIGGERED, smallPhotoTouchEvent);
				}
				containerSp.addChild(sp);
				sp.x = 0; sp.y = 149 * i;
			}
			pageIndex.text = currentPage + "/" + totalPage;
		}
		
		private function smallPhotoTouchEvent(event:TouchEvent):void{
			var touch:Touch = event.touches[0];
			
//			var photo:Image = touch.target as Image;
			var photo:Image = event.currentTarget as Image;
			var proid:String = photo.parent.name;
			if(touch.phase == TouchPhase.BEGAN){
				photo.scaleX = 0.8; photo.scaleY = 0.8;
			}
			if(touch.phase == TouchPhase.ENDED){
				photo.scaleX = 1; photo.scaleY = 1;
				trace(proid);
				showProPhoto(proid);
			}
			
		}
		
		private var DOWNLOAD_COMPLETE:String = NAME + "DownloadComplete";
		
		private function showProPhoto(proid:String):void{
			if(hasPhoto(proid) == false){
				/*下载*/
				var remotePath:String = REMOTE_PIC_PATH + proid + ".jpg";
				var localPath:String = LOCAL_PIC_PATH + proid + ".jpg";
				var downVO:RemoteFileLoadVO = new RemoteFileLoadVO(remotePath,localPath,DOWNLOAD_COMPLETE,proid,null);
				downVO.downType = RemoteFileLoadVO.DOWN_TYPE_PER;
				sendNotification(CoreConst.REMOTE_FILE_LOAD,downVO);
				return;
			}
			loadPhoto(proid);
		}
		
		private function hasPhoto(proid:String):Boolean{
			getPictureArray();
			for(var i:int = 0; i < proPicArray.length; i++){
				if(proPicArray[i].name == proid + ".jpg"){
					return true;
				}
			}
			return false;
		}
		
		private function loadPhoto(proid:String):void{
			var file:File = Global.document.resolvePath(LOCAL_PIC_PATH + proid + ".jpg");
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,loadBigPhotoCompleteHandler);
			loader.load(new URLRequest(file.url));
			return;
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		private function loadBigPhotoCompleteHandler(event:flash.events.Event):void{
			var loader:Loader = event.target.loader as Loader;
			var tmp:Bitmap = new DrawBitmap(loader,loader.width * 610 / loader.height,610);
			var texture:Texture = Texture.fromBitmap(tmp);
			var image:Image = new Image(texture);
			textureList.push(texture);
//			tmp.bitmapData.dispose();
			tmp = null;
			appearPhoto(image);
			trace("LoadComplete.");
		}
		
		private function appearPhoto(_photo:Image):void{
//			picture = new Image(Texture.fromBitmap(tmp,false));
			picture = _photo;
			bg = new Quad(Global.stageWidth,Global.stageHeight,0x000000);
			bg.alpha = 0.3;
			view.addChild(bg);
			picture.pivotX = picture.width >> 1; picture.pivotY = picture.height >> 1;
			picture.x = Global.stageWidth >> 1; picture.y = (Global.stageHeight >> 1) - 50;
			view.addChild(picture);
			TweenLite.from(bg,0.4,{alpha:0});
			TweenLite.from(picture,0.6,{scaleX:0.1,scaleY:0.1,onComplete:appearEnd});
		}
		
		private function appearEnd():void{
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
		
		private function searchUrl(fileName:String):String{
			if(proPicArray != null){
				for(var i:int = 0; i < proPicArray.length; i++){
					if(proPicArray[i].name == fileName){
						return proPicArray[i].url;
					}
				}
			}
			return null;
		}
		
		private function preBtnHandle(event:starling.events.Event):void{
			if(currentPage > 1){
				getProByPage(currentPage - 1);
			}
		}
		
		private function nextBtnHandle(event:starling.events.Event):void{
			if(currentPage < totalPage){
				getProByPage(currentPage + 1);
			}
		}
		
		private var _cameraId:String;
		public function get cameraId():String{
			return _cameraId;
		}
		
		public function set cameraId(value:String):void{
			_cameraId = value;
			for(var i:int = 0; i < proData.length; i++){
				if(proData[i].proid == value){
					currentDealProIndex = i;
					break;
				}
			}
		}
		
		private function cameraBtnHandler(event:starling.events.Event):void{
			cameraId = (event.currentTarget as DisplayObject).parent.name;
			removeTipsHandler(null);
			useCamera();
		}
		
		private var tipSprite:starling.display.Sprite;
		
		private function confirmBtnHandler(e:starling.events.Event):void{
			confirmProid = parseInt((e.currentTarget as DisplayObject).parent.name);
			fileid = -1;
			confirmPromise();
//			addConfirmTips();
		}
		
		private function addConfirmTips():void{
			tipSprite = new starling.display.Sprite();
			var img:Image = new Image(Assets.getTexture("tipConfirm"));
			tipSprite.addChild(img);
			var cameraBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("targetWall/cameraBtn"));
			cameraBtn.x = 727; cameraBtn.y = 409;
			tipSprite.addChild(cameraBtn);
			cameraId = confirmProid.toString();
			cameraBtn.addEventListener(starling.events.Event.TRIGGERED, removeTipAndCameraHandler);
			var cancleBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("targetWall/cancle"));
			cancleBtn.x = 854; cancleBtn.y = 409;
			tipSprite.addChild(cancleBtn);
			cancleBtn.addEventListener(starling.events.Event.TRIGGERED, notUserCameraBtnHandler);
			view.addChild(tipSprite);
		}
		
		private function notUserCameraBtnHandler(event:starling.events.Event):void{
			removeTipsHandler(null);
			getProByPage(currentPage);
		}
		
		private function removeTipAndCameraHandler(event:starling.events.Event):void{
			removeTipsHandler(null);
			useCamera();
		}
		
		private function confirmProHandler(event:starling.events.Event):void{
			removeTipsHandler(null);
			confirmPromise();
		}
		private var enterBtn:starling.display.Button;
		private function addRemindTips():void{
			tipSprite = new starling.display.Sprite();
			var img:Image = new Image(Assets.getTexture("tipShow"));
			tipSprite.addChild(img);
			enterBtn = new starling.display.Button(Assets.getAtlasTexture("targetWall/enter"));
			enterBtn.x = 854; enterBtn.y = 409;
			tipSprite.addChild(enterBtn);
			enterBtn.addEventListener(starling.events.Event.TRIGGERED, enterHandler);
			view.addChild(tipSprite);			
		}
		
		private function enterHandler(event:starling.events.Event):void{
//			trace("213");
//			tabs.selectedIndex = 1;
			removeTipsHandler(null);
		}
		
		private function removeTipsHandler(event:starling.events.Event):void{
			if(enterBtn){
				enterBtn.removeEventListener(starling.events.Event.TRIGGERED, enterHandler);
			}
			if(tipSprite){
				tipSprite.removeChildren(0,-1,true);
				view.removeChild(tipSprite,true);
			}
		}
		
		private function useCamera():void{
			AirImagePicker.getInstance().displayCamera(onImagePicked);
		}
		
		private var filePath:String;
		protected function onImagePicked(path:String):void{
			if (path) {
				var loader:Loader = new Loader();
				filePath = path;
				loader.load(new URLRequest("file://" + path));
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
			}
		}
		private var picture:Image;
		private var bg:Quad;
		private var currentDealProIndex:int = -1;
		
		private function LoaderComHandler(event:flash.events.Event):void{
			var loader:Loader = event.target.loader as Loader;
//			var tmp:Bitmap = new DrawBitmap(loader,loader.width * 610 / loader.height,610);
			var tmp:Bitmap = new DrawBitmap(loader, 1280, 768);
//			var bmpdata:BitmapData = tmp.bitmapData;
			var pro:PromiseVO;
			for(var i:int = 0; i < proData.length; i++){
				if(proData[i].proid == cameraId){
					pro = proData[i];
					break;
				}
			}
			var mtrx:Matrix = new Matrix();
			var scale:Number = tmp.width/1280 < 1 ? tmp.width/1280 : 1;
			mtrx.createBox(scale, scale, 0, (tmp.width - 1280 * scale)>>1, (tmp.height - 200 * scale - 50));
			tmp.bitmapData.draw(makeFlashSprite(pro),mtrx);
			var file:File = new File(filePath);
			if(file) file.deleteFile();
			filePath = Global.document.resolvePath(LOCAL_PIC_PATH + cameraId +".jpg").url;
			savePicture(tmp.bitmapData, filePath);
			var smallWidth:Number = 102; var smallHeight:Number = 77;
			if(tmp.width < tmp.height){
				smallWidth = 77; smallHeight = 102;
			}
			var smallBitmap:Bitmap =new DrawBitmap(tmp, smallWidth, smallHeight);
			file = Global.document.resolvePath(LOCAL_PIC_PATH + cameraId +"small.jpg");
			savePicture(smallBitmap.bitmapData, file.url);
			proData[currentDealProIndex].hasImage = true;
			proData[currentDealProIndex].imageURL = file.url;
			proData[currentDealProIndex].image = new Image(Texture.fromBitmap(smallBitmap));
			var texture:Texture = Texture.fromBitmap(tmp,false);
			picture = new Image(texture);
			textureList.push(texture);
			bg = new Quad(Global.stageWidth,Global.stageHeight,0x000000);
			bg.alpha = 0.3;
			view.addChild(bg);
			picture.scaleX = 0.8; picture.scaleY = 0.8;
			picture.pivotX = picture.width >> 1; picture.pivotY = picture.height >> 1;
			picture.x = Global.stageWidth >> 1; picture.y = (Global.stageHeight >> 1) - 50;
			view.addChild(picture);
			TweenLite.from(bg,0.4,{alpha:0});
			TweenLite.from(picture,0.6,{scaleX:0.1,scaleY:0.1,onComplete:addUploadBtn});
		}
		
		private var uploadBtn:starling.display.Button;
		private var cancleBtn:starling.display.Button;
		private function addUploadBtn():void{
			uploadBtn = new starling.display.Button(Assets.getAtlasTexture("targetWall/upload"));
			uploadBtn.x = Global.stageWidth / 2 -150; uploadBtn.y = 660;
//			uploadBtn.x = Global.stageWidth / 2 - uploadBtn.width / 2; uploadBtn.y = 660;
			view.addChild(uploadBtn);
			uploadBtn.addEventListener(starling.events.Event.TRIGGERED, uploadBtnHandler);
			
			cancleBtn= new starling.display.Button(Assets.getAtlasTexture("targetWall/cancle"));
			cancleBtn.x = Global.stageWidth / 2 + 150 - cancleBtn.width; cancleBtn.y = 660;
			view.addChild(cancleBtn);
			cancleBtn.addEventListener(starling.events.Event.TRIGGERED, cancleBtnHandler);
		}
		
		private function uploadBtnHandler(event:starling.events.Event):void{
			isThisUpload = true;
			var file:File = new File(filePath);
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(view,647,352, null,"上传图片中......"));
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,"promise/" + file.name,null,WorldConst.UPLOAD_PERSON_INIT));
			removePicture();
		}
		
		private function cancleBtnHandler(event:starling.events.Event):void{
			removePicture();
			confirmOrFrush();
		}
		
		private function confirmOrFrush():void{
			/*if ( ( themetwoData[currentDealProIndex].rwstatus) != "Y"){
				confirmPromise();
			}*/
//			 else{
//				dealThemeTwoData();
//			 }
			getProByPage(currentPage);
		}
		
		private function savePicture(bmd:BitmapData,url:String):void{
			var j:JPEGEncoderOptions=new JPEGEncoderOptions(80);
			var b:ByteArray=new ByteArray();
			var rec:Rectangle = new Rectangle(0,0,bmd.width,bmd.height);
			bmd.encode(rec,j,b);
			var file:File = new File(url);
			var fs:FileStream = new FileStream();
			try{
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(b);
				fs.close();
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		private function removePicture():void{
			TweenLite.to(bg,0.4,{alpha:0});
			TweenLite.to(picture,0.4,{scaleX:0.1,scaleY:0.1,onComplete:closeBmp});
		}
		
		
		private function deleUploaded():void{
			if(filePath){
				var file:File = new File(filePath);
				if(file.exists){
					file.deleteFile();
				}
			}
			confirmOrFrush();
		}
		
		private function closeBmp():void{
			view.removeChild(picture);
			view.removeChild(bg);
			view.removeChild(uploadBtn);
			view.removeChild(cancleBtn);
			bg.dispose();
			picture.dispose();
		}
		
		private function makeFlashSprite(pro:PromiseVO):flash.display.Sprite{
			if(pro == null){
				return new flash.display.Sprite();
			}
			var sp:flash.display.Sprite = new flash.display.Sprite();
			sp.graphics.beginFill(0xefefef,0.3);
			sp.graphics.drawRect(0, 0, 1280, 200);
			sp.graphics.endFill();
			
//			var format:TextFormat = new TextFormat("HuaKanT", 20, 0xe18242);
			var format:TextFormat = new TextFormat("HuaKanT", 20, 0);
			var stu:flash.text.TextField = new flash.text.TextField();
			stu.embedFonts = true;
			stu.defaultTextFormat = format;
			stu.text = Global.player.name + "    获取" + pro.gold + "个金币";
			stu.mouseEnabled = false;
			stu.autoSize = TextFieldAutoSize.LEFT;
			stu.x = 19; stu.y = 22;
			sp.addChild(stu);
			
			var par:flash.text.TextField = new flash.text.TextField();
			par.embedFonts = true;
			par.defaultTextFormat = format;
			par.text = pro.parname + "    奖励 " + pro.rwcontent;
			par.mouseEnabled = false;
			par.autoSize = TextFieldAutoSize.LEFT;
			par.x = 19; par.y = 70;
			sp.addChild(par);
			
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");		
			dateFormatter.setDateTimePattern("yyyy-MM-dd");
//			var format2:TextFormat = new TextFormat("HuaKanT", 14, 0x827968);
			var format2:TextFormat = new TextFormat("HuaKanT", 14, 0);
			var sign:flash.text.TextField = new flash.text.TextField();
			sign.defaultTextFormat = format2;
//			sign.text = Global.player.name + " / " + pro.parname + "      " + dateFormatter.format(Global.nowDate);
			sign.text = dateFormatter.format(Global.nowDate);
			sign.mouseEnabled = false;
			sign.autoSize = TextFieldAutoSize.LEFT;
			sign.width = 309;
//			sign.x = 583; sign.y = 118;
			sign.x = 783; sign.y = 118;
			sp.addChild(sign);
			
			return sp;
		}
		
		private function confirmPromise():void{
			PackData.app.CmdIStr[0] = CmdStr.REWARD_PROMISE;
			PackData.app.CmdIStr[1] = confirmProid.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CONFIRM_PROMISE));
		}
		
		private var deleteProid:int = 0;
		private var confirmProid:int = 0;
		
		private function delBtnHandler(e:starling.events.Event):void{
			var proid:int = parseInt((e.currentTarget as DisplayObject).parent.name);
			deleteProid = proid;
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(view,647,352, deletePromise,"确定删除这条约定吗？"));
		}
		
		
		
		private function deletePromise():void{
			PackData.app.CmdIStr[0] = CmdStr.DELETE_PRO_GET_PRONUM;
			PackData.app.CmdIStr[1] = deleteProid.toString();
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(DELETE_PROMISE));
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		
	}
}