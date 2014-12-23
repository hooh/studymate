package com.studyMate.world.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.IslandDataVO;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;
	
	public class IslandList extends List implements IMediator,IDataList
	{
		public static const NAME:String = "IslandList";
		
		public var islandList:ListCollection;
		public var ISLAND_LIST_REC:String = NAME + "islandListRec";
		
		
		
		public function IslandList()
		{
			super();
			islandList = new ListCollection();
			
			width = 400;
			height = 300;
			itemRendererProperties.labelField ="name";
			
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
				case ISLAND_LIST_REC:
				{
					var vo:DataResultVO = notification.getBody() as DataResultVO;
					
					if(vo.isEnd){
						dataProvider = islandList;
					}else if(vo.isErr){
						
					}else{
						
						var islandDataVO:IslandDataVO = new IslandDataVO(PackData.app.CmdOStr[2],
							PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],PackData.app.CmdOStr[8],PackData.app.CmdOStr[10],
							PackData.app.CmdOStr[9],PackData.app.CmdOStr[6],PackData.app.CmdOStr[7],PackData.app.CmdOStr[5]);
						islandDataVO.id = PackData.app.CmdOStr[1];
						islandList.push(islandDataVO);
						
						
						
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
			return [ISLAND_LIST_REC];
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
		
		public function updateData():void
		{
			PackData.app.CmdIStr[0] = CmdStr.QRY_LAND_INFO;
			PackData.app.CmdInCnt = 1;
			islandList.removeAll();
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(ISLAND_LIST_REC));
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