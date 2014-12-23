package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.Check;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	public class RefreshListModuleMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "RefreshListModuleMediator";
		public static const QUERY_MARK_FRAME:String = NAME + "QueryMarkFrame";
		
		public function RefreshListModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void{
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0x828282);
			view.addChild(quad);
			
			addMyList();
			addChecks();
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
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case QUERY_MARK_FRAME:
					if(!result.isEnd){
						newData.push({label: PackData.app.CmdOStr[4]});
					}else{
						if(addData){
							loadableList.addListData(newData);
						}else{
							loadableList.setListData(newData);
						}
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [QUERY_MARK_FRAME];
		}
		
		private var loadableList:LoadableList;
		private function addMyList():void{
			loadableList = new LoadableList();
			loadableList.width = 280; loadableList.height = 300;
			loadableList.x = 500; loadableList.y = 150;
			view.addChild(loadableList);
			loadableList.clipRect = new Rectangle(0, 0, loadableList.width, loadableList.height);
			loadableList.addEventListener(LoadableList.LOAD_EVENT, loadableListLoadHandler);
			loadableList.addEventListener(LoadableList.REFRESH_EVENT, loadableListRefreshHandler);
			addData = false;
			getMusicList(1);
		}
		
		private function addChecks():void{
			var check:Check = new Check();
			check.label = "向下刷新";
			check.name = "refresh";
			check.x = 513; check.y = 460;
			view.addChild(check);
			check.addEventListener(Event.CHANGE, checkChangeHandler);
			check.isSelected = true;
			
			check = new Check();
			check.label = "向上加载";
			check.name = "load";
			check.x = 653; check.y = 460;
			view.addChild(check);
			check.addEventListener(Event.CHANGE, checkChangeHandler);
			check.isSelected = true;
		}
		
		private var newData:Array;
		private var addData:Boolean;
		private var currenPage:int;
		private function getMusicList(curPage:int):void{
			newData = new Array();
			currenPage = curPage;
			PackData.app.CmdIStr[0] = CmdStr.QryMarkframeMUSIC;
			PackData.app.CmdIStr[1] = "";
			PackData.app.CmdIStr[2] = "MUSIC";
			PackData.app.CmdIStr[3] = "*";
			PackData.app.CmdIStr[4] = "*";
			PackData.app.CmdIStr[5] = "";
			PackData.app.CmdIStr[6] = "6";
			PackData.app.CmdIStr[7] = curPage.toString();
			PackData.app.CmdIStr[8] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 9;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(QUERY_MARK_FRAME));
		}
		
		private function checkChangeHandler(event:Event):void{
			var check:Check = event.target as Check;
			if(check.name == "refresh"){
				loadableList.refreshAble = check.isSelected;
			}else if(check.name == "load"){
				loadableList.loadAble = check.isSelected;
			}
		}
		
		private function loadableListLoadHandler():void{
			trace("Listen load Event.");
			addData = true;
			getMusicList(currenPage + 1);
		}
		
		private function loadableListRefreshHandler():void{
			trace("Listen refresh Event.");
			addData = false;
			getMusicList(1);
		}
	}
}