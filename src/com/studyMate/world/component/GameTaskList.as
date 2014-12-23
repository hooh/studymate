package com.studyMate.world.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.GameTaskVO;
	import com.studyMate.world.model.vo.IslandDataVO;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;
	
	public class GameTaskList extends List implements IMediator,IDataList
	{
		public static const NAME:String = "GameTaskList";
		
		public var taskList:ListCollection;
		private const LIST_REC:String = NAME + "listRec";
		
		public function GameTaskList()
		{
			super();
			taskList = new ListCollection;
			width = 400;
			height = 300;
			itemRendererProperties.labelField = "name";
			addEventListener(Event.ADDED_TO_STAGE,addHandle);
			addEventListener(Event.REMOVED_FROM_STAGE,removeHandle);
		}
		
		
		private function removeHandle(event:Event):void
		{
			Facade.getInstance(CoreConst.CORE).removeMediator(NAME);
		}
		
		private function addHandle(event:Event):void
		{
			
			Facade.getInstance(CoreConst.CORE).registerMediator(this);
			
			
			
		}
		
		public function updateData():void
		{
			PackData.app.CmdIStr[0] = CmdStr.QRY_GAME_TASK_INFO;
			PackData.app.CmdInCnt = 1;
			taskList.removeAll();
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(LIST_REC));
			
		}
		
		public function getMediatorName():String
		{
			return NAME;
		}
		
		public function getViewComponent():Object
		{
			return this;
		}
		
		public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case LIST_REC:
				{
					
					
					var vo:DataResultVO = notification.getBody() as DataResultVO;
					
					if(vo.isEnd){
						dataProvider = taskList;
					}else if(vo.isErr){
						
					}else{
						
						var dataVO:GameTaskVO = new GameTaskVO();
						dataVO.id = PackData.app.CmdOStr[1];
						dataVO.cd = PackData.app.CmdOStr[12];
						dataVO.description =PackData.app.CmdOStr[3];
						dataVO.islandIDs = PackData.app.CmdOStr[9];
						dataVO.isMainLine = PackData.app.CmdOStr[10];
						dataVO.name = PackData.app.CmdOStr[2];
						dataVO.orderNum = PackData.app.CmdOStr[11];
						dataVO.playerNumber = PackData.app.CmdOStr[6];
						dataVO.reward = PackData.app.CmdOStr[8];
						dataVO.script = PackData.app.CmdOStr[5];
						dataVO.time = PackData.app.CmdOStr[7];
						dataVO.type = PackData.app.CmdOStr[4];
						taskList.push(dataVO);
						
						
						
					}
					
					break;
				}
					
				default:
				{
					break;
				}
			}
			
		}
		
		public function listNotificationInterests():Array
		{
			return [LIST_REC];
		}
		
		public function onRegister():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function onRemove():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function setViewComponent(viewComponent:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private var multitonKey:String;
		public function initializeNotifier(key:String):void
		{
			multitonKey = key;
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification( notificationName, body, type );
		}
		
	}
}