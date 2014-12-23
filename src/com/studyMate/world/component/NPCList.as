package com.studyMate.world.component
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.card.GameCharaterData;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.NPCRawDataVO;
	import com.studyMate.world.screens.CardGameStageMediator;
	import com.studyMate.world.screens.component.NpcListItemRender;
	
	import flash.errors.IllegalOperationError;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class NPCList extends List implements IMediator,IDataList
	{
		public static const NAME:String = "NPCList";
		public var rawData:Vector.<NPCRawDataVO>;
		public var playersData:Vector.<GameCharaterData>;
		private static const NPC_LIST_REC:String = NAME+"NpcListRec";
		
		public function NPCList()
		{
			super();
			rawData = new Vector.<NPCRawDataVO>;
			width = 400;
			height = 300;
			itemRendererProperties.labelField ="name";
			
			itemRendererFactory = itemFactory;
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
		
		
		private function itemFactory():IListItemRenderer{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.accessoryFunction = itemFun;
			return renderer;
		}
		
		private function itemFun( item:GameCharaterData ):DisplayObject{
			var render:NpcListItemRender = new NpcListItemRender();
			render.data = item;
			return render;
			
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
			var dvo:DataResultVO;
			switch(notification.getName())
			{
				case NPC_LIST_REC:
				{
					dvo = notification.getBody() as DataResultVO;
					if(dvo.isEnd){
						playersData = CardGameStageMediator.genPlayerData(rawData);
						refreshList();
					}else if(dvo.isErr){
						
					}else{
						var vo:NPCRawDataVO = new NPCRawDataVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],
							PackData.app.CmdOStr[5],PackData.app.CmdOStr[6],PackData.app.CmdOStr[7],PackData.app.CmdOStr[8],PackData.app.CmdOStr[9],PackData.app.CmdOStr[10]);
						rawData.push(vo);
					}
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		public function refreshList():void{
			
			if(!playersData){
				return;
			}
			
			var dataList:ListCollection = new ListCollection();
			for (var i:int = 0; i < playersData.length; i++) 
			{
				dataList.addItem(playersData[i]);
			}
			dataProvider = dataList;
			
			
		}
		
		public function listNotificationInterests():Array
		{
			return [NPC_LIST_REC];
		}
		
		public function onRegister():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function onRemove():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function updateData():void{
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_NPC_ROLE_INFO;
			PackData.app.CmdInCnt = 1;
			rawData.length=0;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(NPC_LIST_REC));
			
			
		}
		
		public function setViewComponent(viewComponent:Object):void
		{
			if(viewComponent){
				throw IllegalOperationError("the view is fix");
			}
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