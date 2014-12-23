package com.studyMate.world.screens
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.controller.LibInitToModuleCommand;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.mylib.framework.utils.CacheTool;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.controller.IPReaderProxy;
	import com.studyMate.db.schema.Player;
	import com.studyMate.db.schema.PlayerDAO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.IPSpeedVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.TimeLimitVo;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.HistoryListItemRender;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.view.EduAlertMediator;
	import com.studyMate.world.screens.view.WifiAlertSkin;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.media.StageWebView;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.List;
	import feathers.controls.Radio;
	import feathers.controls.ToggleSwitch;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class IslandWelcomeMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "IslandWelcomeMediator";
		
		private var clickText:starling.text.TextField;
		
		private var logo:Image;
		
		private var timeline:TimelineLite;
		
		private var userName:flash.text.TextField;
		private var password:flash.text.TextField;
		private var tempUserName:String;

		private var isPassword:Check;
		
		private var isSavePass:Check;
		
		private var toggleGroup:ToggleGroup;
		private var forceDownloadToggle:ToggleSwitch;
		
		private var background:Image;
		private var textures:Vector.<Texture>;
		/*---ZHT20121127BEGIN---*/
		private var loginView:starling.display.Sprite;
		/*---ZHT20121127END---*/
		
		//浏览器用
		private var webOpenBtn:feathers.controls.Button;
		private var stageWebView:StageWebView;
		private var webStartTime:int;
		private var webEndTime:int;
		private var canConnect:Boolean;
		//private var launcher:LaunchAppExtension;
		private var hasLogin:Boolean;
		
		private var featherHolder:starling.display.Sprite;
		private var loginHistoryBtn:starling.display.Button;
		
		public function IslandWelcomeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Global.welcomeInit = false;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		private var historyList:List;
		private var historyCol:ListCollection = new ListCollection();

		override public function onRegister():void
		{
			sendNotification(CoreConst.HIDE_NETWORKSTATE);
			sendNotification(CoreConst.STOP_BEAT);
			sendNotification(CoreConst.CLOSE_SOCKET);
			CacheTool.clrAll();
			sendNotification(WorldConst.BUILD_THEME);
			Global.hasLogin = false;
			
			//清楚任务缓存
			sendNotification(WorldConst.DEL_TASK_DATA_CACHE);
			
			textures = new Vector.<Texture>;
			var texture:Texture = Texture.fromBitmap(Assets.store["isLandIndex"]);
			textures.push(texture);
			background = new Image(texture);
			background.name = "background";
			view.addChild(background);
			
			clickText = new starling.text.TextField(300,100,"点击屏幕继续","HeiTi",40,0xffffff);
			clickText.nativeFilters = [new GlowFilter(0xaaaaaa,1,0,0,5)];
			view.addChild(clickText);
			
			clickText.y = 400;
			clickText.x = 280;
			
			texture = Texture.fromBitmap(Assets.store["islandLogo"],false);
			textures.push(texture);
			logo = new Image(texture);
			logo.name = "logo"
			view.addChild(logo);
			logo.x = 45;
			logo.y = 45;
			
			TweenMax.to(clickText,1,{alpha:0,yoyo:true,repeat:999});
			
			view.addEventListener(TouchEvent.TOUCH,firstTouchHandle);
			
			loginView = new starling.display.Sprite();
			loginView.touchable = false;
			loginView.x = 73;
			loginView.y = 0;
			loginView.name = "loginView"
			view.addChild(loginView);
			
			texture = Texture.fromBitmap(Assets.store["login_bg"],false);
			textures.push(texture);
			var loginBg:Image = new Image(texture);
			loginBg.name = "loginBg";
			loginView.addChild(loginBg);
			
			isPassword = new Check();
			loginView.addChild(isPassword);
			isPassword.isSelected = false;
//			isPassword.defaultLabelProperties.textFormat = new TextFormat("Helvetica Neue,Helvetica,Roboto,Arial,_sans", 18, 0xFFFFFF, true);
//			isPassword.disabledLabelProperties.textFormat = new TextFormat("Helvetica Neue,Helvetica,Roboto,Arial,_sans", 18, 0x000000, true);
//			isPassword.selectedDisabledLabelProperties.textFormat = new TextFormat("Helvetica Neue,Helvetica,Roboto,Arial,_sans", 18, 0x000000, true);
//			isPassword.label = "显示密码";
			isPassword.x = 452; isPassword.y = 339;
			isPassword.addEventListener(starling.events.Event.CHANGE,isPasswordHandler);
			
			
			var isSavePasswordTF:starling.text.TextField = new starling.text.TextField(135,40,"记住密码","HuaKanT",20,0x725f5f);
			isSavePasswordTF.x = 480;
			isSavePasswordTF.y = 320;
			loginView.addChild(isSavePasswordTF);
			
			isSavePass = new Check();
			isSavePass.x = 600;
			isSavePass.y = 336;
			loginView.addChild(isSavePass);
			
			
			texture = Texture.fromBitmap(Assets.store["login_btn"],false);
			textures.push(texture);
			var btn:starling.display.Button = new starling.display.Button(texture,"");
			btn.scaleWhenDown = 1.3;
			loginView.addChild(btn);
			btn.addEventListener(TouchEvent.TOUCH,loginBtnHandle);
			btn.x = 487;
			btn.y = 370;
			
			forceDownloadToggle = new ToggleSwitch();
			forceDownloadToggle.x = 184;
			forceDownloadToggle.y = 335;
			forceDownloadToggle.isSelected = false;
			loginView.addChild(forceDownloadToggle)
				
			
			toggleGroup = new ToggleGroup();
			
			var db:DataBaseProxy = DBTool.proxy;
			var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var playDao:PlayerDAO = new PlayerDAO();
			
			var netName:String = config.getValue("netName");
			if(netName == "" || netName == null)
				netName = "电信";
			
			var radio:Radio = new Radio();
			radio.toggleGroup = toggleGroup;
			if(!CONFIG::ARM){
				radio.name = "190";
				radio.x = 180;
				radio.y = 392;
				if(netName == radio.name)
					radio.isSelected = true;
				loginView.addChild(radio);
			}
			
			
			radio = new Radio();
			radio.toggleGroup = toggleGroup;
			radio.x = 300;
			radio.y = 392;
			radio.name = "电信";
			if(netName == radio.name)
				radio.isSelected = true;
			loginView.addChild(radio);
			
			radio = new Radio();
			radio.toggleGroup = toggleGroup;
			radio.x = 412;
			radio.y = 392;
			radio.name = "联通";
			if(netName == radio.name)
				radio.isSelected = true;
			loginView.addChild(radio);
			
			
			
			texture = Texture.fromBitmap(Assets.store["historyBtn"],false);
			textures.push(texture)
			loginHistoryBtn = new starling.display.Button(texture);
			loginHistoryBtn.x = 535;
			loginHistoryBtn.y = 165;
			if(playDao.getFileUserName().length<1){
				loginHistoryBtn.visible = false;
			}else{
				loginHistoryBtn.visible = true;
			}
			loginHistoryBtn.name = "loginBtn"
			loginView.addChild(loginHistoryBtn); 
			loginHistoryBtn.addEventListener(starling.events.Event.TRIGGERED,showLoginHistoryHandler);
			
			
			
			historyList = new List();
			historyList.x = 395;
			historyList.y = 230;
			historyList.name = "historyList";
			historyList.visible = false;
			historyList.width = 260;
			historyList.dataProvider = historyCol;
			view.addChild(historyList);
			historyList.itemRendererType = HistoryListItemRender;
			historyList.addEventListener(starling.events.Event.CHANGE,selectLoginUserHandler);
			
			
			timeline = new TimelineLite();
			timeline.stop();
			timeline.autoRemoveChildren = true;
			timeline.delay(0.5);
			timeline.append(TweenLite.from(loginView,1.0,{alpha:0,y:-loginView.height,ease:Bounce.easeOut,onComplete:completeTimeLineHandle}));
			
			var tf:TextFormat = new TextFormat(null,30,0x969696);
			tf.align = TextFormatAlign.CENTER;
			
			userName = new flash.text.TextField();
			userName.defaultTextFormat = tf;
			userName.restrict = "^`\/\\\\";
			userName.x = 400;
			userName.y = 173;
			userName.type = TextFieldType.INPUT;
			userName.width = 210;
			userName.height = 50;
			userName.visible = false;
			userName.maxChars = 20;
			Starling.current.nativeOverlay.addChild(userName);
			
			password = new flash.text.TextField();
			password.defaultTextFormat = tf;
			password.restrict = "^`\/";
			password.x = 400;
			password.y = 266;
			password.type = TextFieldType.INPUT;
			password.width = 210;
			password.height = 50;
			password.visible = false;
			password.maxChars = 20;
			password.displayAsPassword = true;
			Starling.current.nativeOverlay.addChild(password);
			
			
			var player:Player = db.playerDAO.findPlayerByUsername(playDao.getDefUser());
			Global.player = player;
			
			if(Global.player){
				userName.text = Global.player.userName;
				
				if(config.getValue("isSavePassword") == "true"){
					isSavePass.isSelected = true;
					
					password.text = Global.player.password;
				}else
					isSavePass.isSelected = false;
			}
						
			sendNotification(WorldConst.HIDE_NOTICE_BOARD);
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			/*---ZHT20121127END---*/
			featherHolder = new starling.display.Sprite();
			view.addChild(featherHolder);
			
			//launcher = new LaunchAppExtension();
			
			webOpenBtn = new feathers.controls.Button();
			webOpenBtn.label = "网页认证";
			webOpenBtn.x = 1150;
			webOpenBtn.name = "网页认证"
			webOpenBtn.addEventListener(starling.events.Event.TRIGGERED,webOpenBtnHandle);
			featherHolder.addChild(webOpenBtn);
			
			var clearSysBtn:feathers.controls.Button = new feathers.controls.Button();
			clearSysBtn.label = "垃圾清理";
			clearSysBtn.x = 1030;
			clearSysBtn.name ="垃圾清理";
			clearSysBtn.addEventListener(TouchEvent.TOUCH,clearSysBtnHandle);
			featherHolder.addChild(clearSysBtn);
			
			var ipSpeedBtn:feathers.controls.Button = new feathers.controls.Button();
			ipSpeedBtn.label = "网络测速";
			ipSpeedBtn.name = "网络测速"
			ipSpeedBtn.x = 1150; ipSpeedBtn.y = 50;
			ipSpeedBtn.addEventListener(starling.events.Event.TRIGGERED, ipSpeedBtnHandle);
			featherHolder.addChild(ipSpeedBtn);
			
			var deviceInfoBtn:feathers.controls.Button = new feathers.controls.Button();
			deviceInfoBtn.label = "设备信息";
			deviceInfoBtn.name = "设备信息";
			deviceInfoBtn.x = 1030; deviceInfoBtn.y = 50;
			deviceInfoBtn.addEventListener(starling.events.Event.TRIGGERED, deviceInfoBtnHandle);
			featherHolder.addChild(deviceInfoBtn);
			
			var offPicBtn:feathers.controls.Button = new feathers.controls.Button();
			offPicBtn.label = "离线绘本";
			offPicBtn.name = "离线绘本";
			offPicBtn.x = 910;
			offPicBtn.addEventListener(starling.events.Event.TRIGGERED,offPicHandler);
			featherHolder.addChild(offPicBtn);
			
			/*sendNotification(WorldConst.CHECK_SOCKET_CONNECT);*/
			
			
//			trace(ApplicationDomain.currentDomain.getDefinition("com.studyMate.world.script.LayoutTool"));
			
			/*var v:Vector.<String> = ApplicationDomain.currentDomain.getQualifiedDefinitionNames();
			
			for (var i:int = 0; i < v.length; i++) 
			{
				if(v[i].substr(0,13)=="com.studyMate"||v[i].substr(0,9)=="com.mylib"){
					trace(v[i]);
				}
			}*/
			
			
			
			
			//跳过登录
//			sendNotification(ApplicationFacade.DATA_INITIALISED);
			//trace(Global.nowDate.fullYear)
			sendNotification(CoreConst.CLEAN_STARUP_INFOR);
			sendNotification(CoreConst.HIDE_STARUP_INFOR);
			Global.welcomeInit = true;
			sendNotification(CoreConst.REFRESH_LOADING);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
			
			//检查eduService权限
			sendNotification(CoreConst.CHECK_EDUSERVICE_ROOT);
			
//			TweenLite.delayedCall(5,function():void{
//				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("温馨提示：今天已经学了好久哦，休息休息吧~O(∩_∩)O~",false));
//			});
			trace("@VIEW:IslandWelcomeMediator:");
		}
		
		private var startY:Number
		private function hideHistoryList(event:TouchEvent):void
		{
			if(event.touches[0].phase == "began"){
				startY = event.touches[0].globalY;
			}else if(event.touches[0].phase == "ended"){
				if(event.touches[0].globalX>390&&event.touches[0].globalX<660
					&&event.touches[0].globalY>160&&event.touches[0].globalY<350
					||Math.abs(startY-event.touches[0].globalY)>15){
					return
				}
				showLoginHistoryHandler();
			}
		}
		
		private function selectLoginUserHandler():void
		{
			if(historyList.selectedItem !=null){
				userName.text = String(historyList.selectedItem);
				var playDao:PlayerDAO = new PlayerDAO;
				var player:Player = playDao.findPlayerByUsername(userName.text);
				if(player != null){
					if(player.savePassword == "true"){
						isSavePass.isSelected = true;
						password.text = player.password;
					}else{
						isSavePass.isSelected = false;
						password.text = ""
					}
				}
				historyList.visible= false;
				historyCol.removeAll();
				userName.visible = true;
				password.visible = true;
				view.removeEventListener(TouchEvent.TOUCH,hideHistoryList);
			}
		}
		
		
		
		private function delLoginHistory(delID:String):void
		{
			var playDao:PlayerDAO = new PlayerDAO;
			if(playDao != null){
				playDao.deleteUser(delID);
			}
			historyCol.removeItem(delID);
			if(delID==userName.text){
				userName.text = "";
				password.text = "";
			}
			if(historyCol.length<1){
				userName.visible = true;
				password.visible = true;
				loginHistoryBtn.visible= false;
			}else{
				loginHistoryBtn.visible=true;
			}
		}	
		
		
		private function showLoginHistoryHandler():void
		{
			tempUserName = userName.text;
			if(historyList.visible){
				historyList.visible = false;
				password.visible = true;
				historyCol.removeAll();
				view.removeEventListener(TouchEvent.TOUCH,hideHistoryList);
			}else{
				historyList.visible = true;
				password.visible = false;
				var _player:PlayerDAO = new PlayerDAO();
				var arry:Array = _player.getFileUserName()
				for(var j:int = 0;j<arry.length;j++){
					historyCol.push(arry[j]);
				}
				if(historyCol.length>=2){
					historyList.height = 136;
				}
				view.addEventListener(TouchEvent.TOUCH,hideHistoryList);
			}
		}
		
		
		protected function keybackHandle(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.preventDefault();
				
				if(facade.hasMediator(EduAlertMediator.NAME)){
					userName.visible = true;
					password.visible = true;
					historyList.visible = false;
					historyCol.removeAll();
					sendNotification(WorldConst.REMOVE_POPUP_SCREEN,facade.retrieveMediator(EduAlertMediator.NAME));
				}
				
			}
		}
		
		private function offPicHandler():void
		{
			Global.initialized = false;
			facade.registerCommand(CoreConst.LIB_INITIALIZED,LibInitToModuleCommand);
			sendNotification(CoreConst.LOAD_APP_MODULES);
			
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(OffBookshelfNewView2Mediator),new SwitchScreenVO(CleanGpuMediator)]);
		}		

		//设定密码这里之所以这么写，是为了解决搜狗光标显示位置不对的bug。
		private function isPasswordHandler(e:starling.events.Event):void{
			var txt:String = password.text;
			password.text = '';
			if(isPassword.isSelected){
				password.displayAsPassword = false;
			}else{
				password.displayAsPassword = true;
			}
			password.text = txt;
			Global.stage.focus = password;
			password.needsSoftKeyboard = true;
			password.requestSoftKeyboard();
			password.setSelection(password.text.length,password.text.length);
		}
		
		private function ipSpeedBtnHandle():void{
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(NetStateMediator,null,SwitchScreenType.SHOW,view,610,120)]);
			sendNotification(CoreConst.OPER_RECORD,new RecordVO("ipSpeed","IslandWelcomeMediator",0));
			
		}
		//显示设备信息
		private function deviceInfoBtnHandle():void{
			var deviceInfo:ShowDeviceInfoMediator = new ShowDeviceInfoMediator(new flash.display.Sprite);
			deviceInfo.view.x = 800; deviceInfo.view.y = 100;
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(deviceInfo)));
		}
		
		private function clearSysBtnHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				
				MyUtils.checkFolderSize();
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(NetStateMediator,null,SwitchScreenType.SHOW,view,640,120)]);
			}
			
		}
		//打开浏览器
		private function webOpenBtnHandle():void{
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(NetStateMediator,null,SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,120)]);
			sendNotification(CoreConst.OPER_RECORD,new RecordVO("start check web","IslandWelcomeMediator",0));
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(NetStateMediator,true,
//				SwitchScreenType.SHOW,AppLayoutUtils.gpuLayer,390,120)]);
		}
		
		private function yesHandler():void{
			
			
			/*var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){*/
				
				password.visible = true;
				userName.visible = true;
			
				Global.use3G = true;
				sendLoginRequest();
				
//			}
		}
		
		private function noHandler():void{
			
			
			
			/*var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){*/
			
				password.visible = true;
				userName.visible = true;
				
				Global.use3G = false;
				sendLoginRequest();
				
//			}
		}
		
		
		private function loginBtnHandle(event:TouchEvent):void
		{
			
			if(event.touches[0].phase=="ended"){	
				sendNotification(WorldConst.DISPOSE_CHECK_SOCKET);
//				.visible = false;
				password.visible = false;
				userName.visible = false;
				historyCol.removeAll();
				historyList.visible =false;
//				
//				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n是否进入\“省流量模式\”？ \n\nTips:\“省流量模式\”中将禁用更新、下载等耗流量的操作。",true,"yesHandler","noHandler",false,null,yesHandler,null,noHandler));
				if( AssetTool.hasLibClass("EduAlert_Wifigroup") == false){
					noHandler();
				}else{	
					var alertVO:AlertVo = new AlertVo("",true,"yesHandler","noHandler",false,null,yesHandler,null,noHandler);
					alertVO.skin = new WifiAlertSkin;
					sendNotification(WorldConst.ALERT_SHOW,alertVO);	
				}

				/*var yesButton:feathers.controls.Button = new feathers.controls.Button();
				yesButton.label = "是";
				yesButton.addEventListener(TouchEvent.TOUCH,yesHandler);
				var noButton:feathers.controls.Button = new feathers.controls.Button();
				noButton.label = "否";
				noButton.addEventListener(TouchEvent.TOUCH,noHandler);
				var btns:ListCollection = new ListCollection();
				btns.addItem(yesButton);
				btns.addItem(noButton);
				Alert.show("3g模式下不能下载大数据","正在使用3G吗？",new ListCollection(
					[
						{ label: "是"},{ label: "否"}
					])
);
				*/
				
//				noHandler();
				
				
			}
		}
		
		private function sendLoginRequest():void{
			
			if(Global.isLoading){
				return;
			}
			
			
			var net:String = (toggleGroup.selectedItem as Radio).name;
			
			PackData.app.head.dwReqCnt =0;
			var xmlReader:IPReaderProxy = facade.retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
			var array:Array;var ipname:String;
			if(net=="电信"){
				ipname = "telecom";
			}else if(net=="联通"){
				ipname = "unicom";
			}else if(net=="190"){
				ipname = "test";
			}
			array = xmlReader.getIpInf(ipname);
			if(array == null){
				array = ["121.33.246.212", 8820, 5];
			}
			sendNotification(CoreConst.CONFIG_IP_PORT,array);
			
			Global.user = StringUtil.trim(userName.text);
			Global.password = StringUtil.trim(password.text);
			
			historyList.visible = false;
			var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			if(isSavePass.isSelected){
				config.updateValue("isSavePassword",true);
				Global.savePassword = "true";
			}else{
				config.updateValue("isSavePassword",false);
				Global.savePassword = "false";
			}
			config.updateValue("netName",net);
			
			if(Global.user==""||Global.user==null){
				sendNotification(CoreConst.TOAST,new ToastVO("用户名不能为空"));
				return;
			}
			
			if(Global.password==""||Global.password==null){
				sendNotification(CoreConst.TOAST,new ToastVO("用户名密码不能为空"));
				return;
			}
			sendNotification(CoreConst.LOADING,true);
			sendNotification(CoreConst.SOCKET_INIT,[true,"B0",updateType]);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName() ;
			var result:DataResultVO = notification.getBody() as DataResultVO;
			
			switch(name){

				case CoreConst.REMIND_UPDATE_COMPLETE:
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
					if(notification.getBody()){
						Alert.show( "我更新了，要退出一下哦", '提示', new ListCollection(
							[
								{ label: "退出应用",triggered:function exit():void{Global.isUserExit = true;NativeApplication.nativeApplication.exit();} }
							]));
						return;
					}
					
					//检查用户限制时间
					sendNotification(WorldConst.CHECK_TIME_LIMIT);
					/*for each (var i:Texture in textures) 
					{
						i.dispose();
					}					
					textures.length = 0;
					sendNotification(CoreConst.SHOW_STARTUP_LOADING);
					sendNotification(CoreConst.SHOW_STARUP_INFOR);
					
					if(Global.initialized){
						sendNotification(CoreConst.RE_GET_INITIALIZE_DATA);
					}else{
						sendNotification(WorldConst.UNLOAD_WORLD_MODULE);
						sendNotification(CoreConst.LOAD_APP_MODULES);
						
					}*/
					
					
					break;
				case WorldConst.CHECK_TIME_LIMIT_COMPLETE:
					var allowIn:Boolean = false;
					Global.timeLimitVo = null;
					if(!result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							var beginTime:String = PackData.app.CmdOStr[1];
							var endTime:String = PackData.app.CmdOStr[2];
							var beginH:* = beginTime.substr(0,2);
							var beginM:* = beginTime.substr(2,2);
							var beginS:* = beginTime.substr(4,2);
							var endH:* = endTime.substr(0,2);
							var endM:* = endTime.substr(2,2);
							var endS:* = endTime.substr(4,2);
							
							
							//取后台时间，对比系统时间
							var timelimitvo:TimeLimitVo = new TimeLimitVo(new Date(null,null,null,beginH,beginM,beginS),new Date(null,null,null,endH,endM,endS));
							timelimitvo.hadl5Tip = false;	//重置5分钟提醒
							timelimitvo.hadexitTip = false;
							Global.timeLimitVo = timelimitvo;
							
							//系统时间
							var nowdate:Date = Global.nowDate;
							var _nowdate:Date = new Date(null,null,null,nowdate.hours,nowdate.minutes);
							trace("现在时间："+_nowdate.hours+":"+_nowdate.minutes);
							allowIn = (timelimitvo.sdate<=_nowdate && _nowdate<timelimitvo.edate);
							
						}else{
							allowIn = true;
							
						}
						
					}else{
						allowIn = true;
						
					}
					
					
					if(allowIn){
						for each (var j:Texture in textures) 
						{
							j.dispose();
						}					
						textures.length = 0;
						sendNotification(CoreConst.SHOW_STARTUP_LOADING);
						sendNotification(CoreConst.SHOW_STARUP_INFOR);
						
						if(Global.initialized){
							sendNotification(CoreConst.RE_GET_INITIALIZE_DATA);
						}else{
							sendNotification(WorldConst.UNLOAD_WORLD_MODULE);
							sendNotification(CoreConst.LOAD_APP_MODULES);
							
						}
						
					}else{
						var tips:String = timelimitvo.sdate.hours+":"+timelimitvo.sdate.minutes+"--"+
							timelimitvo.edate.hours+":"+timelimitvo.edate.minutes;
						trace("限制时间为："+tips);
						
						Alert.show( "您每天的学习时间为："+tips+"\n\n请在限定时间内登录", '温馨提示', new ListCollection(
							[
								{ label: "退出系统",triggered:function exit():void{Global.isUserExit = true;NativeApplication.nativeApplication.exit();} },
								{ label: "切换账号",triggered:function stay():void
								{
									hasLogin = false;
									featherHolder.visible = true;
									loginView.visible = true;
									password.visible = true;
									userName.visible = true;
								} 
								}
								
							]));
						
						
					}
					break;
				case CoreConst.NETWORK_ERROR:{
					sendNotification(CoreConst.LOADING,false);					
					break;
				}
				case CoreConst.DATA_INITIALISED:
					sendNotification(CoreConst.LOADING,false);
					sendNotification(CoreConst.START_BEAT);
					var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
					config.updateValue("LastLoginTime",MyUtils.dateFormat(Global.nowDate)); //记录登录时间
//					facade.registerCommand(CoreConst.CHECK_LOGIN_TIME,CheckLogTmCommand);
					if(Global.initialized){
						sendNotification(WorldConst.SWITCH_FIRST_SCREEN);
					}else{
						sendNotification(CoreConst.CORE_READY);
					}
					break;
				case CoreConst.SOCKET_CLOSED:
					sendNotification(CoreConst.LOADING,false);
					break;
				case CoreConst.LICENSE_PASSED:
					if(hasLogin){
						break;
					}
					CacheTool.clrAll();
					hasLogin = true;
					MyUtils.checkFolderSize();
					featherHolder.visible = false;//修复进入登录状态后。可以点击其他按钮而报错的情况
					loginView.visible = false;
					password.visible = false;
					userName.visible = false;
					if(notification.getBody()!="n"){
						if(Global.use3G||Global.getSharedProperty(ShareConst.NETWORK_ID)==1){
							Global.setSharedProperty(ShareConst.DOWNLOAD_CMD,"USERWJ.DownHostFile(gdgz)");
							sendNotification(CoreConst.REMIND_UPDATE_COMPLETE);
						}else{
							sendNotification(CoreConst.RUN_UPDATE,updateType);
						}
					}
					
					
					break;
				case WorldConst.AUTO_LOGIN:{
					userName.text = notification.getBody()[0];
					password.text = notification.getBody()[1];
					
					sendLoginRequest();
					
					
					break;
				}
				case WorldConst.SELECT_IN_PORT:
					
					var _name:String = (notification.getBody() as IPSpeedVO).name;
					if(_name == "190"){
						toggleGroup.selectedIndex = 0;
					}else if(_name == "电信"){
						toggleGroup.selectedIndex = 1;
					}else if(_name == "联通"){
						toggleGroup.selectedIndex = 2;
					}
					
					break;
				case WorldConst.DELHISTORYLOGIN:
				{
					var delID:String = notification.getBody() as String;
					delLoginHistory(delID);
					break;
				}
			}
		}
		
		private function get updateType():String{
			var _updateType:String;
			if(forceDownloadToggle.isSelected){
				_updateType = "f";
			}else{
				_updateType = "u";
			}
			
			return _updateType;
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.COMMIT_UPDATE_COMPLETE,WorldConst.SELECT_IN_PORT,
				CoreConst.DATA_INITIALISED,WorldConst.GUIDE_END,CoreConst.SOCKET_CLOSED,
				CoreConst.LICENSE_PASSED,CoreConst.REMIND_UPDATE_COMPLETE,CoreConst.NETWORK_ERROR,
				WorldConst.AUTO_LOGIN,WorldConst.DELHISTORYLOGIN,WorldConst.CHECK_TIME_LIMIT_COMPLETE];
		}
		
		
		private function completeTimeLineHandle():void{
			
			userName.visible = true;
			password.visible = true;
			loginView.touchable = true;
		}
		
		override public function onRemove():void
		{
			timeline.clear();
			if(clickText)
				TweenMax.killTweensOf(clickText);
			TweenLite.killTweensOf(loginView);
			Starling.current.nativeOverlay.removeChild(userName);
			view.removeEventListener(TouchEvent.TOUCH,hideHistoryList);
			userName = null;
			Starling.current.nativeOverlay.removeChild(password);
			password = null;
//			btnHolder.removeChildren(0,-1,true);
			view.removeChildren(0,-1,true);
			
			for each (var i:Texture in textures) 
			{
				i.dispose();
			}
//			facade.removeProxy(CheckSocketProxy.NAME);
			
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
			textures.length = 0;
			sendNotification(CoreConst.SHOW_NETWORKSTATE);
		}
		
		
		private function firstTouchHandle(event:TouchEvent):void
		{
			if(event.touches[0].phase=="ended"){
				view.removeEventListener(TouchEvent.TOUCH,firstTouchHandle);
				
				TweenLite.killTweensOf(clickText);
				view.removeChild(clickText);
				clickText.dispose();
				
				TweenLite.to(logo,0.3,{alpha:0,y:0});
		
				timeline.play();
			}
			
		}
		
		
		private function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		
		override public function get viewClass():Class
		{
			return starling.display.Sprite;
		}
		
	}
}