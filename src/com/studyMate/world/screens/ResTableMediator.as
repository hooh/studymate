package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.component.BaseResTableMediator;
	import com.studyMate.world.screens.ui.QueueDownMediator;
	import com.studyMate.world.screens.ui.video.VideoBaseClass;
	import com.studyMate.world.screens.ui.video.VideoListItemRenderer;
	
	import flash.desktop.NativeApplication;
	
	import feathers.controls.Alert;
	import feathers.controls.List;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	
	/**
	 *资源管理器，管理视频、，音乐、绘本的列表。点击播放进入相应的界面 
	 * @author wangtu
	 * 
	 */	
	public class ResTableMediator extends BaseResTableMediator
	{
		public static const NAME:String = "ResTableMediator";
		
		private const VIDEO_LIST:String = NAME+"videoList";
		
		public static const DEL_TRIGGERED:String = NAME  + "DEL_TRIGGERED";
		private const YES_DEL_FILE:String = NAME+"yesDelFileHandler";
		private const Del_FILE_COMPLETE:String = NAME+"DelVideoComplete";
		
		public static const PLAY_TRIGGERED:String = NAME + "PLAY_TRIGGERED";
		private const Video_Allow_Info:String = NAME+"Video_Allow_Info";
		
		
		private var playList:List;//列表组件
		private var listCollection:ListCollection = new ListCollection();

		private var currentDown:VideoBaseClass;
						
		private var currentDel:VideoBaseClass;
		private var canPlayVideo:VideoBaseClass;
		
		private var canPlayPath:String = "";
		private static var isWatch:Boolean;//是否观看过电影(static类型请勿修改)
		
		//观看时间记录信息
		private var videoids:String ="";
		private var videoid:String="";
		private var wtimes:String = "";//申请时长
		
		private var isChecking:Boolean;
		private const yesQuitHandler:String = NAME + "yesQuitHandler";
		private var alert:Alert;
		
		public function ResTableMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override protected function quitHandler():void
		{
			if(isWatch){
//				sendNotification(CoreConst.CANCEL_DOWNLOAD);
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n检测到您今天观看过电影,建议您休息一会，并重新登录。",true,yesQuitHandler));
			}else{				
				super.quitHandler();
			}
		}
		
		override public function onRegister():void{
			super.onRegister();
//			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			
			var bg:Image = new Image(Assets.getTexture("mediabg"));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);			
					
									
			var gotoMarketBtn:Button = new Button(Assets.getAtlasTexture("parents/enterMarketBtn"));
			gotoMarketBtn.x = 1130;
			gotoMarketBtn.y = 657;
			gotoMarketBtn.addEventListener(Event.TRIGGERED,gotoMarketBtnHandle);
			view.addChild(gotoMarketBtn);
			
			initList();
			playList.touchable = false;
			
			var userId:String = PackData.app.head.dwOperID.toString();
			sendDelayMediator.sendinServerInfo(CmdStr.GET_RESOURCE_LIST2,VIDEO_LIST,[userId,"VIDEO","*"],SendCommandVO.QUEUE|SendCommandVO.UNIQUE);
			updateList();//改成按时刷新任务
		}
		private function initList():void{			
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 52;		
			layout.paddingBottom =100;
			playList = new List();
			playList.allowMultipleSelection = false;
			playList.x = 50;
			playList.y = 50;
			playList.width = 860;
			playList.height = 560;
			playList.layout = layout;
			playList.itemRendererType = VideoListItemRenderer;
//			playList.itemRendererType = VideoBitmapFontItemRender;
			view.addChild(playList);	
			playList.dataProvider = listCollection;
		}
		
		override public function onRemove():void
		{	
			TweenLite.killTweensOf(updateList);
			if(alert){
				if(PopUpManager.isPopUp(alert))
					PopUpManager.removePopUp(alert);
				alert.dispose();
			}
			super.onRemove();
//			BitmapFontUtils.dispose();
			currentDown = null;
			currentDel = null;
			canPlayVideo = null;
			testArr = null;
			listCollection = null;
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			view.removeChildren(0,-1,true);
			
			sendNotification(WorldConst.HIDE_BACK);	
		}
				
		private function gotoMarketBtnHandle(event:Event):void{		
			sendDelayMediator.execute(sendNotification,[WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MarketViewMediator)]]);
		}
		//初始化位图字体
//		public function initBitmapFont():void{
//			var len:int = listCollection.length;
//			var videBase:VideoBaseClass;
//			var str:String = '';
//			for(var i:int=0;i< len;i++){
//				videBase = (listCollection.data[i] as VideoBaseClass);
//				str += (videBase.Name);
//			}
//			if(str!=''){
//				str += "\%.0123456789M分钟";
//				var assets:Vector.<DisplayObject> = new Vector.<DisplayObject>;
//				var bmp:Bitmap = Assets.getTextureAtlasBMP(Assets.store["AtlasTexture"],Assets.store["AtlasXml"],"parents/del_Resource_icon");
//				bmp.name = "parents/del_Resource_icon";
//				assets.push(bmp);
//				bmp = Assets.getTextureAtlasBMP(Assets.store["AtlasTexture"],Assets.store["AtlasXml"],"parents/play_Resource_icon");
//				bmp.name = "parents/play_Resource_icon";
//				assets.push(bmp);
//				bmp = Assets.getTextureAtlasBMP(Assets.store["AtlasTexture"],Assets.store["AtlasXml"],"parents/down_Resource_icon");
//				bmp.name = "parents/down_Resource_icon";
//				assets.push(bmp);
//				
//				var ui:Shape = new Shape();
//				ui.graphics.clear();
//				ui.graphics.beginFill(0x0a4475,0.1);
//				ui.graphics.drawRect(0,0,830,50);
//				var bmd:BitmapData = new BitmapData(830,50,true,0);
//				bmd.draw(ui);
//				bmp = new Bitmap(bmd);
//				bmp.name = 'bgQuad';
//				assets.push(bmp);
//				
//				ui.graphics.clear();
//				ui.graphics.beginFill(0x0a4475,0.2);
//				ui.graphics.drawRect(0,0,830,50);
//				bmd = new BitmapData(830,50,true,0);
//				bmd.draw(ui);
//				bmp = new Bitmap(bmd);
//				bmp.name = 'bgQuad2';
//				assets.push(bmp);
//				
//				var tf:TextFormat = new TextFormat('HeiTi',18,0x666666);
//				tf.letterSpacing = -2;
//				BitmapFontUtils.init(str,assets,tf);
//			}
//		}
		
		private var testArr:Array=[];
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case yesQuitHandler:
					Global.isUserExit = true;
					NativeApplication.nativeApplication.exit();
					break;
				case VIDEO_LIST:
					if(!result.isEnd  && !result.isErr){//接收
						var baseClass:VideoBaseClass = new VideoBaseClass(PackData.app.CmdOStr);
						tempEnd.push(baseClass);
						testArr.push(baseClass.url);
					}else if(result.isEnd && !result.isErr){//接收完成
						sendNotification(QueueDownMediator.TEST_PATH,testArr);
//						this.initBitmapFont();						
//						if(playList){
//							playList.stopScrolling();
//							playList.removeFromParent(true);
//						}
//						initList();						
//						playList.dataProvider = listCollection;
						sendNotification(WorldConst.VIEW_READY);
						
						stopUpdateList();
						playList.touchable = true;
						
						trace("@VIEW:ResTableMediator:");
					}
					break;
				case WorldConst.CURRENT_DOWN_RESINFOSP:
					currentDown = notification.getBody() as VideoBaseClass;
					
					break;
				case WorldConst.CURRENT_DOWN_COMPLETE:///下载完成保存视频	
					currentDown = notification.getBody() as VideoBaseClass;
					currentDown.hasSource = true;
					listCollection.updateItemAt(listCollection.getItemIndex(currentDown));
					break;
				case DEL_TRIGGERED:
					currentDel = notification.getBody() as VideoBaseClass;
//					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n确定要删除\n"+currentDel.Name+"吗？",true,YES_DEL_FILE));
					var message:String = "\n确定要删除\n"+currentDel.Name+"吗？";
					
					alert = Alert.show( message, 'Tip', new ListCollection(
						[
							{ label: "OK",triggered:function yesDel():void{sendNotification(YES_DEL_FILE)} },
							{ label: "NO" }
						]));
					alert.width = 200;
					break;
				case YES_DEL_FILE:	//点击弹出框确定删除后。若通信，则先停止通信才删除				
					var userId:String = PackData.app.head.dwOperID.toString();
					sendDelayMediator.sendinServerInfo(CmdStr.DEL_RESOURCE,Del_FILE_COMPLETE,["UMDI",userId,Global.user,"0","",currentDel.instid]);
					break;
				
				case Del_FILE_COMPLETE:
					if((PackData.app.CmdOStr[0] as String)=="000"){//trace("删除成功");	
						queueDownMediator.removeOf(currentDel);
						listCollection.removeItem(currentDel);
//						currentDel = null;
					}else{
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，由于网络问题导致删除失败",false));
					}
					queueDownMediator.downloadNextItem();
					break;
				
				case PLAY_TRIGGERED:
					if(isChecking==false){
						isChecking = true;
						
						canPlayVideo = notification.getBody() as VideoBaseClass;
						canPlayPath = canPlayVideo.Encrypt_path;
						userId = PackData.app.head.dwOperID.toString();
						videoid = canPlayVideo.downId;
						videoids = "Video."+videoid;
						wtimes = canPlayVideo.totalTime;
						var reg:RegExp = /(\d*)/g;
						sendDelayMediator.sendinServerInfo(CmdStr.CHECK_PLAY_VIDEO,Video_Allow_Info,[userId,videoids,videoid,wtimes.match(reg)[0]]);							
					}
					break;
				case Video_Allow_Info://后台是否同意用户播放视频		
					isChecking = false;
					if((PackData.app.CmdOStr[0] as String)=="000"){
						isWatch = true;
						var obj:Object = new Object();
						obj.videoid = canPlayVideo.downId;
						obj.videoname = canPlayVideo.Name;
						obj.startTime = MyUtils.getTimeFormat();
						obj.videoids = "Video."+videoid;
						obj.wtimes = canPlayVideo.totalTime;
						obj.canPlayPath = canPlayPath;
//						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(StageVideoMediator,obj)]);
						sendDelayMediator.execute(sendNotification,[WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(StageVideoMediator,obj)]]);

					}else{					
						//sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n"+(PackData.app.CmdOStr[1] as String),false,""));//提示信息
						sendNotification(CoreConst.TOAST,new ToastVO((PackData.app.CmdOStr[1] as String),1.5));
						queueDownMediator.downloadNextItem();
					}
					break;
				
			}
		}
				
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			return arr.concat([yesQuitHandler,
								PLAY_TRIGGERED,
								DEL_TRIGGERED,
								WorldConst.CURRENT_DOWN_RESINFOSP,
								WorldConst.CURRENT_DOWN_COMPLETE,
								VIDEO_LIST,
								Video_Allow_Info,YES_DEL_FILE,Del_FILE_COMPLETE]);
		}
		
		
		private var tempEnd:ListCollection = new ListCollection();
		private function updateList():void{
			if(tempEnd.length>0){
				listCollection.addAll(tempEnd);
				tempEnd.removeAll();
			}			
			TweenLite.delayedCall(2,updateList);			
		}
		private function stopUpdateList():void{
			updateList();
			TweenLite.killTweensOf(updateList);
		}
		
		// 该函数为降低刷新List频率
		override protected function updateLoadingHandler():void
		{
			if(currentDown){
				currentDown.downPercent = (process/total * 100).toString().substr(0,5) + "%";	
				listCollection.updateItemAt(listCollection.getItemIndex(currentDown));					
			}
		}
			
	}
}
