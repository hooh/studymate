package com.studyMate.world.screens{

	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.model.vo.LocalFilesLoadCommandVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.GameListInfoVO;
	import com.studyMate.world.pages.GameMarketPage;
	
	import flash.filesystem.File;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class GameMarketMediator extends ScreenBaseMediator{
		public static const NAME:String = "GameMarketViewMediator";
		private const GET_MONEY:String = "GetMoney";
		private const Query_Game_Info:String = "QueryGameInfo";
		private const Face_Load_Complete:String = "FaceLoadComplete";
		private const Game_Load_Complete:String = "GameLoadComplete";
		private const Open_Game_Complete:String = "OpenGameComplete";
		
		private var pages:Vector.<IFlipPageRenderer>;

		private var curBtn:Object;
		private var goldNum:int;
		
		private var glist:Vector.<GameListInfoVO>;
		
		private var pnameArr:Array = []; //游戏标识，包名
		private var gnameArr:Array = []; //游戏名称
		private var fwbidArr:Array = []; //封面素材标识
		private var fnameArr:Array = []; //封面素材名称
		private var awbidArr:Array = []; //APK素材标识
		private var anameArr:Array = []; //APK素材名称
		private var opointArr:Array = []; //消耗点数
		private var levelArr:Array = []; //评级说明 1~5
		private var localGameList:String = ""; //本地游戏列表,";"分隔
		
		
		private var gold:TextField;
		
		private var texture:Texture;

		public function GameMarketMediator(viewComponent:Object = null) {
			super(NAME,viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}

		override public function onRegister():void {
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			init();
			
			getLocalGames();
			glist = new Vector.<GameListInfoVO>;
			getGamesInfo(CmdStr.Query_Game_Info,"*","*","*","*","00000000","YYYYMMDD",Query_Game_Info);
		}
		override public function onRemove():void
		{
			texture.dispose();
			view.removeChildren(0,-1,true);
			
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			super.onRemove();
			
		}
		private function init():void{
			texture = Texture.fromBitmap(Assets.store["task_bg"],false);
			var bg:Image = new Image(texture);
			view.addChild(bg);
			
			gold = new TextField(200,50,"￥","HeiTi");
			gold.x = 350;
			gold.y = 50;
			view.addChild(gold);
			
		}

		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()){	
				case GET_MONEY:
					goldNum = PackData.app.CmdOStr[4];
					gold.text = "RMB "+goldNum;
					break;
				case Query_Game_Info:
					trace((PackData.app.CmdOStr[0] as String));
					if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						var len:int = pnameArr.length;
						var _glist:GameListInfoVO;
						if(len > 0){
							for(var i:int = 0; i<len; i++){
								_glist = new GameListInfoVO;
								_glist.pname = pnameArr[i];
								_glist.gname = gnameArr[i];
								_glist.fwbid = fwbidArr[i];
								_glist.fname = fnameArr[i];
								_glist.awbid = awbidArr[i];
								_glist.aname = anameArr[i];
								_glist.opoint = opointArr[i];
								_glist.level = levelArr[i];
								
								glist.push(_glist);
							}
							pnameArr = [];
							gnameArr = [];
							fwbidArr = [];
							fnameArr = [];
							awbidArr = [];
							anameArr = [];
							opointArr = [];
							levelArr = [];
							
							var _vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
							var _item:UpdateListItemVO;
							for(i=0;i<glist.length;i++){
								_item = new UpdateListItemVO(glist[i].fwbid.toString(),"game/"+glist[i].fname.toString(),
									"BOOK","");
								_item.hasLoaded = true;
								_vec.push(_item);
							}
							sendNotification(CoreConst.LOCAL_FILES_LOAD,new LocalFilesLoadCommandVO(_vec,Face_Load_Complete));
						}else{
							getGMoney();
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,640,381,null,"最近比较忙，没有游戏更新哦。"));
						}
					}else{
						pnameArr.push(PackData.app.CmdOStr[1]);
						gnameArr.push(PackData.app.CmdOStr[2]);
						fwbidArr.push(PackData.app.CmdOStr[3]);
						fnameArr.push(PackData.app.CmdOStr[4]);
						awbidArr.push(PackData.app.CmdOStr[5]);
						anameArr.push(PackData.app.CmdOStr[6]);
						opointArr.push(PackData.app.CmdOStr[7]);
						levelArr.push(PackData.app.CmdOStr[9]);
						
					}
					break;
				case Face_Load_Complete:
					getGMoney();
					createPages(glist);
					
					if(pages.length != 0)
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageMediator,
							new FlipPageData(pages),SwitchScreenType.SHOW,view)]);

					break;
				case WorldConst.OPEN_GAME:
					curBtn = notification.getBody()[1] as Button;
					
					PackData.app.CmdIStr[0] = CmdStr.Open_Game_Info;
					PackData.app.CmdIStr[1] = notification.getBody()[0].toString();
					PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdInCnt = 3;	
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,
						new SendCommandVO(Open_Game_Complete));	//开启游戏
					
					break;
				case Open_Game_Complete:
					if((PackData.app.CmdOStr[0] as String)=="000"){
						gold.text = "RMB "+PackData.app.CmdOStr[1]; //返回剩余金币
						downloadHandle();		
					}else if((PackData.app.CmdOStr[0] as String)=="M00"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view.stage,640,381,null,"您已购买该游戏，正在为您重新下载，请稍后...（以后别乱删了喔！）"));
						downloadHandle();
					}else{
						//购买失败
//						(curBtn as Button).label = "￥"+(curBtn as Button).id;
					}
					break;
				case Game_Load_Complete:
					sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
					
					(curBtn as Button).label = "Have Load";
					break;
			}
		}

		override public function listNotificationInterests():Array {
			return [GET_MONEY,Query_Game_Info,Face_Load_Complete,Game_Load_Complete,WorldConst.OPEN_GAME,Open_Game_Complete];
		}
		
		/**
		 *获取本地已下载的游戏列表 
		 * 
		 */
		private function getLocalGames():void{
			var file:File = Global.document.resolvePath(Global.localPath + "game/");
			if(file.exists){
				var files:Array = file.getDirectoryListing();
				
				var total:int = files.length;
				for(var i:int = 0;i < total;i++) {
					file = files[i];
					if(file.extension == "apk") {
						localGameList += file.name+";";
					}
				}
			}
		}
		
		private function createPages(glist:Vector.<GameListInfoVO>):void{
			var _glist:Vector.<GameListInfoVO> = new Vector.<GameListInfoVO>;

			
			var len:int = glist.length;
			if(len > 0){
				var packName:String;
				for(var j:int = 0;j < len;j++) {
					packName = glist[j].pname;
					
					//后台下载的列表，本地存在的游戏不显示出来
					if(localGameList.indexOf(packName) == -1)
						_glist.push(glist[j]);
				}
				
				var total1:int = _glist.length;
				var totalPage:int = total1/20+1;
				if(total1%20 == 0)
					totalPage--;
				pages = new Vector.<IFlipPageRenderer>(totalPage);
				
				for (j = 0; j < totalPage; j++)
					pages[j]=new GameMarketPage(j,_glist,totalPage);
				
			}else{
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,640,381,null,"最近比较忙，没有游戏更新哦。"));
			}
			if(_glist.length == 0)
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,640,381,null,"最近比较忙，没有游戏更新哦。"));
		}
		

		//下载游戏
		private function downloadHandle():void{
			(curBtn as Button).label = "Loading...";

			var _item:UpdateListItemVO = new UpdateListItemVO("","game/"+(curBtn as Button).name,"BOOK","");
			_item.hasLoaded = true;
			
//			sendNotification(CoreConst.LOADING_INIT_PROCESS);
			
			sendNotification(CoreConst.REMOTE_FILE_LOAD,new RemoteFileLoadVO(_item.wfname,Global.localPath+_item.wfname,
				Game_Load_Complete,_item,_item));
		}

		/**
		 * 从后台获取游戏列表函数
		 * @param command 命令字
		 * @param title 游戏名称
		 * @param fontName 关联封面素材
		 * @param apkName 关联apk安装包素材名称
		 * @param lastOpt 最后修改人
		 * @param begDate 最后修改起始日期
		 * @param endDate 最后修改结束日期
		 * @param reveive 接收函数
		 * 
		 */		
		private function getGamesInfo(command:String,title:String,fontName:String,apkName:String,
										  lastOpt:String,begDate:String,endDate:String,reveive:String):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = title;
			PackData.app.CmdIStr[2] = fontName;
			PackData.app.CmdIStr[3] = apkName;
			PackData.app.CmdIStr[4] = lastOpt;
			PackData.app.CmdIStr[5] = begDate;
			PackData.app.CmdIStr[6] = endDate;
			PackData.app.CmdInCnt = 7;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台		
		}
		
		
		/**
		 *从后台获取用户金币数 
		 * 
		 */		
		private function getGMoney():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.GMONEY";
			PackData.app.CmdInCnt =3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_MONEY));
		}
		

	}
}
