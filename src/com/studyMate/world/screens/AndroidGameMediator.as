package com.studyMate.world.screens
{
	import com.edu.EduAllExtension;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateGameServiceCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.pages.AndroidGamePage;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class AndroidGameMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "AndroidGameMediator";
		public static const Del_Game:String = "DelGame";
		private const Play_Game_Time:String = "PlayGameTime";
		private var pages:Vector.<IFlipPageRenderer>;
		
		private var gameName:String;
		private var packName:String;
		private var applyTime:int;//申请时长
		private var gameNameList:String = "";
		//private var rootExecuteExtension:RootExecuteExtension;
		private var installGameList:String;
		//private var lauapk:LaunchAppExtension;		
		//private var getActName:GetInstalledPackagesFunction;

		private var texture:Texture;
		private var norAppList:String = "";
		private var isFirstIn:Boolean;
		
		public function AndroidGameMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRegister():void
		{
//			rootExecuteExtension = new RootExecuteExtension();//取得其命令行
//			getActName = new GetInstalledPackagesFunction();//取得安装包
//			lauapk = new LaunchAppExtension();//运行游戏
//			installGameList = getActName.execute();//遍历所有已安装程序的包，查看制定程序是否已安装
			installGameList = EduAllExtension.getInstance().getInstalledPackagesFunction();

//			sendNotification(ApplicationFacade.UPDATE_GAME_SERVICE,new UpdateGameServiceCommandVO(gameNameList,0,"addTime"));

			texture = Texture.fromBitmap(Assets.store["task_bg"],false);
			var bg:Image = new Image(texture);
			view.addChild(bg);
			
			var gotoAppStoreBtn:Button = new Button();
			gotoAppStoreBtn.x = 85;
			gotoAppStoreBtn.y = 30;
			gotoAppStoreBtn.label = "游戏市场";
			gotoAppStoreBtn.addEventListener(TouchEvent.TOUCH,gotoAppStoreHandle);
			view.addChild(gotoAppStoreBtn);
			
			getNorApplist();
			
			isFirstIn = true;
			
			createPages();
			
			
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
		}
		private function gotoAppStoreHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GameMarketMediator)]);
			}
		} 
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			switch(name)
			{
				case Play_Game_Time:
					if((PackData.app.CmdOStr[0] as String)=="000"){
						applyTime = int(PackData.app.CmdOStr[1]);
//						sendNotification(ApplicationFacade.UPDATE_GAME_SERVICE,new UpdateGameServiceCommandVO(gameNameList,applyTime,"setTime"));
						sendNotification(CoreConst.UPDATE_GAME_SERVICE,new UpdateGameServiceCommandVO(packName,applyTime,"playGame"));
						

						if(applyTime <= 0){
//							//时间不足以启动应用，取消禁屏
							sendNotification(WorldConst.SET_MODAL,false);
							sendNotification(CoreConst.MANUAL_LOADING,false);
							
							//后台提示信息
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,640,381,null,"温馨提示："+PackData.app.CmdOStr[2]));
						}else{
							//禁屏
							sendNotification(WorldConst.SET_MODAL,true);
							
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,640,381,null,"你有 "+900/60+" 分钟的游戏时间。"));
							
							GameStart();//开始游戏
						}
					}
					break;
				case WorldConst.GET_PLAY_GAME_TIME:
					gameName = notification.getBody()[0].toString();
					packName = notification.getBody()[1].toString();
					
					sendinServerInfo(CmdStr.Play_Game_Time,packName,"840",Play_Game_Time);

					break;
				case Del_Game:
					
					deleteGame(notification.getBody()[1].toString());
					
					break;

			}
		}
		override public function onRemove():void{
			super.onRemove();
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			
			if(queue){
				queue.unload();
				queue.dispose(true);
				queue = null;
			}
			
			view.removeChildren(0,-1,true);
			
			texture.dispose();
			for(var i:int=0;i<textureList.length;i++)
				textureList[i].dispose();
			
			
		}
		override public function listNotificationInterests():Array
		{
			return [Play_Game_Time,WorldConst.GET_PLAY_GAME_TIME,Del_Game];
		}
		
		private function deleteGame(gameName:String):void{
			if(gameName!=""){
				
				//删除 游戏文件
				var _fileName:String;
				var files:Array;
				var total:int;
				var _file:File = Global.document.resolvePath(Global.localPath + "game/");
				if(_file.exists){
					files = _file.getDirectoryListing();
					total = files.length;
				}
				for(var i:int=0;i<total;i++){
					_file = files[i];
					if(_file.extension == "apk") {
						_fileName = _file.name.substr(0,_file.name.length-4);
						if(_fileName == gameName){
							_file.deleteFile();
							break;
						}
					}
				}
				
				//命令删除游戏
				EduAllExtension.getInstance().rootExecuteExtension("pm uninstall "+gameName);
				
				//刷新界面
				createPages();
				
				
			}
			
			
			
		}
		

		private var apks:Array = [];
		private var textureList:Vector.<Texture> = new Vector.<Texture>;
		private var queue:LoaderMax;
		private function createPages():void{
			var file:File = Global.document.resolvePath(Global.localPath + "game/");
			var total:int = 0;
			apks = [];
			textureList.splice(0,textureList.length);
			if(queue){
				queue.unload();
				queue.dispose(true);
				queue = null;
			}
			if(file.exists){
				var files:Array = file.getDirectoryListing();
				total = files.length;
			}
			for(var i:int = 0;i < total;i++) {
				file = files[i];
				if(file.extension == "apk") {
					var pname:String = file.name.substring(file.name.indexOf("&")+1,file.name.lastIndexOf("."));
					apks.push(file);
					if(!isNormalApp(pname)){
						gameNameList += pname + ";";
					}
				}
			}
			loadIcon(apks);
		}
		private function loadIcon(apkArr:Array):void{
			var len:int = apkArr.length;
			var file:File;
			
			queue = new LoaderMax({name:"mainQueue",onComplete:completeHandler,onError:null});
			
			for(var i:int=0;i<len;i++){
				file = apkArr[i] as File;
				gameName = file.name.substring(0,file.name.indexOf("&")); //游戏名称
				packName = file.name.substring(file.name.indexOf("&")+1,file.name.lastIndexOf(".")); //包名
				
				if(gameName != "")
					queue.append( new ImageLoader(Global.document.resolvePath(Global.localPath + "game/" + gameName + "&" + packName + ".png").url
						, {name:"photo"+i,width:72,height:72}) );
				else
					queue.append( new ImageLoader(Global.document.resolvePath(Global.localPath + "game/" + packName + ".png").url
						, {name:"photo"+i}) );
			}
			queue.maxConnections = 2;
			queue.load();
		}
		private function completeHandler(event:LoaderEvent):void {
			var len:int = apks.length;
			for(var i:int=0;i<len;i++){
				try{
					textureList.push(Texture.fromBitmap((LoaderMax.getContent("photo"+i) as ContentDisplay).rawContent as Bitmap,false));
				}catch(error:Error){
					//icon不存在，新建默认图标
					textureList.push(Texture.fromBitmapData(new BitmapData(72,72,false,0xff835b)));
				}
				
			}
			doShowPage();
		}
		private var pageMap:Dictionary = new Dictionary();
		private function doShowPage():void{
			var len:int = apks.length;
			var totalPage:int = len/20+1;
			if(len%20 == 0)
				totalPage--;
			pages = new Vector.<IFlipPageRenderer>(totalPage);
			
			for (var j:int = 0; j < totalPage; j++) 
			{
				pages[j]=new AndroidGamePage(j,apks,totalPage,textureList);
			}
			
			//首次进入
			if(isFirstIn){
				isFirstIn = false;
				
				if(pages.length > 0)
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageMediator,new FlipPageData(pages),SwitchScreenType.SHOW,view)]);
			}else{
				//删除操作
				if(facade.hasMediator(FlipPageMediator.NAME))
					sendNotification(WorldConst.UPDATE_FLIP_PAGES,new FlipPageData(pages));
			}
			
		}
		
		
		
		private function getNorApplist():void{
			try{
				var norAppFile:File = Global.document.resolvePath(Global.localPath+"command/normalAppList.dat");
				var stream:FileStream = new FileStream();
				stream.open(norAppFile,FileMode.READ);
				
				norAppList = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
			}catch(error:Error){
				
			}
		}
		private function isNormalApp(appName:String):Boolean{
			if(norAppList.indexOf(appName) != -1)	return true;
			else return false;
		}
		
		/**
		 *判断packagename游戏是否已经安装
		 * @param packagename
		 * @return 
		 * 
		 */		
		private function listAppHandle(packagename:String):Boolean {
			if(installGameList.indexOf(packagename) >= 0)
				return true;
			else
				return false;
		}
		private function GameStart():void{
			if(!listAppHandle(packName)) { //游戏未安装				
				//var apk:ApkExecuteExtension = new ApkExecuteExtension(); //获取apk程序名
				
				if(gameName != "")
					//apk.execute(Global.document.nativePath + "/" + Global.localPath + "game/" + gameName + "&" + packName + ".apk");
					EduAllExtension.getInstance().apkExecuteExtension(Global.document.nativePath + "/" + Global.localPath + "game/" + gameName + "&" + packName + ".apk");
				else
					//apk.execute(Global.document.nativePath + "/" + Global.localPath + "game/" + packName + ".apk");
					EduAllExtension.getInstance().apkExecuteExtension(Global.document.nativePath + "/" + Global.localPath + "game/" + packName + ".apk");

				TweenLite.delayedCall(2,callApp,[""]);
			} else { //程序已安装，直接启动
				//rootExecuteExtension.execute("pm enable "+ packName);
				EduAllExtension.getInstance().rootExecuteExtension("pm enable "+ packName);
				TweenLite.delayedCall(2,callApp,[packName]);				
			}
		}
		private function callApp(appName:String):void {
			//lauapk.execute(appName,"call");
			Global.isUserExit = true;
			EduAllExtension.getInstance().launchAppExtension(appName,"call");
			NativeApplication.nativeApplication.exit();
		}
		
		/**
		 * 后台信息派发函数
		 * @param command 命令字
		 * @param name 游戏id名
		 * @param time 申请时长
		 * @param reveive 接收函数
		 */		
		private function sendinServerInfo(command:String,name:String,time:String,reveive:String):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = name;
			PackData.app.CmdIStr[3] = time
			PackData.app.CmdInCnt = 4;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台		
		}
	}
}