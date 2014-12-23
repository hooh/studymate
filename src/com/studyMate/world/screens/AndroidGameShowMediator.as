package com.studyMate.world.screens
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.SwitchScreenCommand;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.InstallAppCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.AndroidGame.AndroidGameVO;
	import com.studyMate.world.component.AndroidGame.GameDownloadMediator;
	import com.studyMate.world.component.AndroidGame.GamePlayMediator;
	import com.studyMate.world.component.AndroidGame.MyGameItem;
	import com.studyMate.world.component.AndroidGame.MyGameScroller;
	import com.studyMate.world.component.AndroidGame.MyGameSwitchScreenCommand;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class AndroidGameShowMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "AndroidGameShowMediator";
		public static const APPLY_DOWNLOAD:String = NAME + "ApplyDownload";
		public static const APPLY_INSTALL:String = NAME + "ApplyInstall";
		public static const APPLY_PLAY_GAME:String = NAME + "ApplyPlayGame";
		public static const APPLE_DEL:String = NAME + "ApplyDel";
		public static const SWITCH_TO_CANCELDOWN:String = NAME + "SwitchToCanceldown";
		
		
		private static const APK_FACE_DOWNLOAD_COMPLETE:String = NAME + "ApkFaceDownloadComplete";
		private static const QRY_USER_GAME_COMPLETE:String = NAME + "QryUserGameComplete";
		
		private var vo:SwitchScreenVO;
		
		private var remainTime:int;//可用时长
		private var remainTimeTF:TextField;

		private var cancelAction:Function;
		private var cancelActionParameters:Array;
		
		private var applyCancelType:String = "exit";	//exit    down    play
		
		public function AndroidGameShowMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			getMyGamesInfo();
		}
		override public function onRegister():void
		{	
			sendNotification(WorldConst.SHOW_LEFT_MENU);
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			
			var image:Image = new Image(Assets.getTexture("gameShowbg"));
			image.blendMode = BlendMode.NONE;
			image.touchable = false;
			view.addChild(image);	
			
			
			
			var timeIcon:Image = new Image(Assets.getAndroidGameTexture("leaveTimeIcon"));//time icon图标
			timeIcon.x = 470;
			timeIcon.y  = 18;
			view.addChild(timeIcon);
			
			//可用游戏时长。直接赋值, 字符串类似"15 min"
			remainTimeTF = new TextField(150,70,'00 min',"HeiTi",26,0xFFFFFF,true);
			remainTimeTF.x = 500;
			remainTimeTF.y = 7;
			view.addChild(remainTimeTF);
			
			
			//转商城界面
			var goMarketeBtn:Button = new Button(Assets.getAndroidGameTexture("toGameMarketBtn"));
			goMarketeBtn.x = 1050;
			goMarketeBtn.y  = 6;
			view.addChild(goMarketeBtn);
			
			//编辑按钮
			var editBtn:Button = new Button(Assets.getAndroidGameTexture("gameEditBtn"));
			editBtn.x = 1147;
			editBtn.y = 14;
			view.addChild(editBtn);
			
			
			goMarketeBtn.addEventListener(Event.TRIGGERED,goToMarketHandler);
			editBtn.addEventListener(Event.TRIGGERED,editHandler);
			
			
			initCheckList();
			checkAppState();
			
			createGameScroll();
		
		}
		
		private var myGameList:Vector.<AndroidGameVO> = new Vector.<AndroidGameVO>; 
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case QRY_USER_GAME_COMPLETE:
					if(!result.isEnd){
						
						var gamevo:AndroidGameVO = new AndroidGameVO;
						gamevo.gid = PackData.app.CmdOStr[1];
						gamevo.gameName = PackData.app.CmdOStr[2];
						gamevo.faceId = PackData.app.CmdOStr[3];
						gamevo.faceName = PackData.app.CmdOStr[4];
						gamevo.apkId = PackData.app.CmdOStr[5];
						gamevo.apkName = PackData.app.CmdOStr[6];
						gamevo.gold = PackData.app.CmdOStr[7];
						gamevo.perPoint = PackData.app.CmdOStr[8];
						gamevo.level = PackData.app.CmdOStr[9];
						gamevo.isOpen = PackData.app.CmdOStr[10];
						gamevo.type = PackData.app.CmdOStr[11];
						
						myGameList.push(gamevo);
						
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DOWNLOAD_APK_FACE,[myGameList,APK_FACE_DOWNLOAD_COMPLETE]);
						
					}
					
					break;
				case APK_FACE_DOWNLOAD_COMPLETE:
					
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					
					
					break;
				case CoreConst.DOWNLOAD_CANCELED:	
					if(cancelAction && applyCancelType == "exit")
						cancelAction.apply(null,cancelActionParameters);
					else if(applyCancelType == "down")
						startDownload();
					else if(applyCancelType == "play")
						startPlay();
					else if(applyCancelType == "del")
						startDel(applyDelItem);
					applyCancelType = null;
					cancelAction = null;
					cancelActionParameters = null;
					break;
				case APPLY_DOWNLOAD:
					applyDownItem = notification.getBody() as MyGameItem;
					
					if(Global.isLoading){
						applyCancelType = "down";
						sendNotification(CoreConst.CANCEL_DOWNLOAD);
						
					}else{
						startDownload();
					}
					
					
					break;
				case APPLY_INSTALL:
					applyInstallItem = notification.getBody() as MyGameItem;
					
					var _path:String = Global.document.nativePath + "/" + Global.localPath+"game/"+applyInstallItem.gameVo.apkName;
					
					sendNotification(CoreConst.INSTALL_APP_COMMAND,new InstallAppCommandVO("A",_path,CoreConst.INSTALL_GAME_COMPLETE));
					
					break;
				case CoreConst.INSTALL_GAME_COMPLETE:
					
					var flag:String = notification.getBody() as String;
					//安装成功
					if(flag == "success"){
						if(applyInstallItem){
							
							applyInstallItem.updateItemState("play");
							
							applyInstallItem.myIconSp.removeFromParent(true);
							
						}
					}else{
						if(applyInstallItem){
							var __path:String = Global.document.nativePath + "/" + Global.localPath+"game/"+applyInstallItem.gameVo.apkName;
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,640,381,doInstall,"系统权限丢失，是否采用手动安装？\n（请及时与客服人员联系）",cancelInstall,__path));
						}else{
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,640,381,null,"安装失败，请尝试退出界面再重新进入安装。"));
							
						}
						
					}
					break;
				case APPLY_PLAY_GAME:
					applyPlayItem = notification.getBody() as MyGameItem;
					
					if(Global.isLoading){
						applyCancelType = "play";
						sendNotification(CoreConst.CANCEL_DOWNLOAD);
						
					}else{
						startPlay();
					}
					
					
					
					break;
				case APPLE_DEL:
					applyDelItem = notification.getBody() as MyGameItem;
					
					if(Global.isLoading){
						applyCancelType = "del";
						sendNotification(CoreConst.CANCEL_DOWNLOAD);
						
					}else{
						startDel(applyDelItem);
					}
					
					
					break;
				case SWITCH_TO_CANCELDOWN:
					
					execute(sendNotification,[WorldConst.SWITCH_SCREEN,notification.getBody(),notification.getType()]);
					
					break;
				
				
			}
		}
		override public function listNotificationInterests():Array{
			return [QRY_USER_GAME_COMPLETE,APK_FACE_DOWNLOAD_COMPLETE,CoreConst.DOWNLOAD_CANCELED,
				APPLY_DOWNLOAD,APPLY_INSTALL,CoreConst.INSTALL_GAME_COMPLETE,APPLY_PLAY_GAME,APPLE_DEL,SWITCH_TO_CANCELDOWN];
		}
		
		
		
		private function doInstall(_path:String):void{
			//静默安装失败，改用手动安装
			sendNotification(CoreConst.INSTALL_APP_COMMAND,new InstallAppCommandVO("M",_path,CoreConst.INSTALL_GAME_COMPLETE));
		}
		private function cancelInstall():void{
			if(applyInstallItem){
				applyInstallItem.updateItemState("install");
				
				applyInstallItem.myIconSp.removeFromParent(true);
			}
			
		}
		
		private function startDel(_item:MyGameItem):void{
			if(_item.gameVo.gid!=""){
				
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
						if(_fileName == _item.gameVo.gid){
							_file.deleteFile();
							break;
						}
					}
				}
				
				//命令删除游戏
				EduAllExtension.getInstance().rootExecuteExtension("pm uninstall "+_item.gameVo.gid);
				
				_item.updateItemState("down");
				
				if(_item.myIconSp)
					_item.myIconSp.removeFromParent(true);
				
			}
		}
		
		
		private var mygameScroll:MyGameScroller;
		private function createGameScroll():void{
			
			/*for(var i:int=0;i<100;i++){
				var vo:AndroidGameVO = new AndroidGameVO;
				vo = myGameList[10];
				
				myGameList.push(vo);
			}
			*/
			facade.registerMediator(new GameDownloadMediator());
			facade.registerMediator(new GamePlayMediator());
			facade.registerCommand(WorldConst.SWITCH_SCREEN,MyGameSwitchScreenCommand);
			
			
			mygameScroll = new MyGameScroller(myGameList,view);
			
			
			view.addChild(mygameScroll);
			
			
			
//			this.backHandle = quitHandler;
		}
		
		
		private function quitHandler():void{//先停止消息后，再退出
			
			execute(sendNotification,[WorldConst.POP_SCREEN]);
		}
		private function execute(action:Function,parameters:Array):void{
			if(Global.isLoading){
				applyCancelType = "exit";
				sendNotification(CoreConst.CANCEL_DOWNLOAD);
				cancelAction = action;
				cancelActionParameters = parameters;
			}else{
				action.apply(null,parameters);
			}
		}
		
		private var applyDelItem:MyGameItem;
		private var applyPlayItem:MyGameItem;
		private var applyDownItem:MyGameItem;
		private var applyInstallItem:MyGameItem;
		private function startDownload():void{
			if(mygameScroll.currentDownItem && applyDownItem){
				mygameScroll.currentDownItem.updateStateBtn(true);
				trace("回复按钮"+mygameScroll.currentDownItem.gameVo.gameName);
			}
				
			mygameScroll.currentDownItem = applyDownItem;
			sendNotification(WorldConst.SET_MODAL,false);
			
			sendNotification(GameDownloadMediator.START_DOWNLOAD,applyDownItem);
		}
		private function startPlay():void{
			if(mygameScroll.currentDownItem){
				mygameScroll.currentDownItem.updateStateBtn(true);
				trace("回复按钮"+mygameScroll.currentDownItem.gameVo.gameName);
				
				mygameScroll.currentDownItem = null;
			}
			
			sendNotification(WorldConst.SET_MODAL,false);
			
			sendNotification(GamePlayMediator.START_PLAY_GAME,applyPlayItem);
			
		}
		
		
		private function checkAppState():void{
			
			
			
			if(myGameList){
				for(var i:int=0;i<myGameList.length;i++){
					//已安装
					if(isInstalled(myGameList[i].gid))
						myGameList[i].state = "play";
					
					else if(isDowned(myGameList[i].gid)){
						//未下载
						myGameList[i].state = "install";
						
						
					}else{
						//已下载，未安装
						myGameList[i].state = "down";
						
						
					}
					
					
				}
			}
		}
		
		private var installedList:String;
		private var downedList:String = "";
		private function initCheckList():void{
			installedList = EduAllExtension.getInstance().getInstalledPackagesFunction();
			
			var file:File = Global.document.resolvePath(Global.localPath + "game/");
			var total:int = 0;
			
			if(file.exists){
				var files:Array = file.getDirectoryListing();
				total = files.length;
			}
			for(var i:int = 0;i < total;i++) {
				file = files[i];
				if(file.extension == "apk") {
					
					downedList += file.name + ",";
				}
			}
		}
		//判断是否安装
		private function isInstalled(_gid:String):Boolean{
			if(installedList.indexOf(_gid) != -1)
				return true;
			else
				return false;
		}
		//判断是否下载
		private function isDowned(_gid:String):Boolean{
			
			if(downedList.indexOf(_gid) != -1)
				return true;
			else
				return false;
		}
		
		
		
		
		
		

		private var editState:Boolean = false;

		//编辑
		private function editHandler():void
		{
			mygameScroll.displayDelBtn(!editState);
			editState = !editState;
		}
		//跳转商城
		private function goToMarketHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AndroidGameMarketMediator,myGameList)]);
		}
		
		
		

		
		private function getMyGamesInfo():void{
			
			PackData.app.CmdIStr[0] = CmdStr.Query_User_Game_Info;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "*";
			PackData.app.CmdInCnt = 3;	
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_USER_GAME_COMPLETE));	
			
		}
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRemove():void{
			super.onRemove();
			
			applyInstallItem = null;
			
			facade.registerCommand(WorldConst.SWITCH_SCREEN,SwitchScreenCommand);
			facade.removeMediator(GameDownloadMediator.NAME);
			facade.removeMediator(GamePlayMediator.NAME);
			
			sendNotification(WorldConst.SET_MODAL,false);
			sendNotification(CoreConst.MANUAL_LOADING,false);
			
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			
			view.removeChildren(0,-1,true);
		}
	}
}