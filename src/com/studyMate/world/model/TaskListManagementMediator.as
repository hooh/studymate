package com.studyMate.world.model
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.UpdateTaskDataVO;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class TaskListManagementMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TaskListManagementMediator";
		private static const ON_RSL:String = NAME + "onRSL";
		private static const GET_TODAY_TASKNUM:String = NAME + "GetTodayTaskNum";
		private static const SEL_FRE_TASKMARK:String = NAME + "SelFreTaskmark";
		
		/**
		 * 本地任务时间戳 
		 */		
		private static var taskStamp:String = "";
		
		/**
		 * 本地缓存服务器时间戳，更新完成任务后写入本地内存 
		 */		
		private static var updateTaskStamp:String = "";
		
		private static var listObject:Object;
		private var taskObj:Object;
		
		override public function onRegister():void
		{
			super.onRegister();
			
//			getTaskList();
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			cleanCache();
		}
		public function cleanCache():void{
			listObject = null;
			taskObj = null;
			taskStamp = "";
			updateTaskStamp = "";
		}

		public function TaskListManagementMediator(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function getTaskList():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_TODAY_TASKJSON;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(ON_RSL,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));

			
		}
		public function getTaskNum():void{
			taskObj = new Object;
			
			PackData.app.CmdIStr[0] = CmdStr.GET_TODAY_TASKNUM;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_TODAY_TASKNUM,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
			
			
		}
		private function checkTaskStamp():void{
			
			PackData.app.CmdIStr[0] = CmdStr.SEL_FRE_TASKMARK;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(SEL_FRE_TASKMARK,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			var result:DataResultVO = notification.getBody() as DataResultVO;
			
			switch(name)
			{
				case SEL_FRE_TASKMARK:
					if(!result.isErr){
						updateTaskStamp = PackData.app.CmdOStr[1];
						
						//如果本地时间戳为空 、服务器返回时间为"YYYYMMDD-hhmmss"、对比时间不等，都需要更新，否则不需要更新
						if(taskStamp == "" || updateTaskStamp == "YYYYMMDD-hhmmss" || taskStamp != updateTaskStamp){
							getTaskList();
							
						}else{
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.UPDATE_TASKLIST_COMPLETE);
							
						}
					}else{
						getTaskList();
						
					}
					break;
				case ON_RSL:
					if(PackData.app.CmdOStr[1] == undefined) break;
					if(!(notification.getBody() as DataResultVO).isErr){
						
						listObject = JSON.parse(PackData.app.CmdOStr[1]);
//						trace(PackData.app.CmdOStr[1]);
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.UPDATE_TASKLIST_COMPLETE);
						taskStamp = updateTaskStamp;
					}
					break;
				case GET_TODAY_TASKNUM:
					
					if(!result.isEnd){
						taskObj[PackData.app.CmdOStr[1]] = PackData.app.CmdOStr[2];
						
						
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.UPDATE_TASK_NUM_COMPLETE);
					
					}
					
					break;

				default:
				{
					break;
				}
			}
			
		}
		override public function listNotificationInterests():Array
		{
			return [ON_RSL,GET_TODAY_TASKNUM,SEL_FRE_TASKMARK];
		}
		
		/**
		 * 根据类型获取今日任务，默认获取今日所有任务
		 * @param taskStyle<br>
		 * 英语单词：yy.W<br>
		 * 英语阅读：yy.R
		 * @return 
		 * 
		 */		
		public function getTodayTaskByStyle(taskStyle:String=null):Object{
			if(!taskStyle)
				return listObject;
			
			for(var i:int=0;i<listObject.length;i++)
			{
				if(String(listObject[i].bookroute) == taskStyle)
					return listObject[i].tasks;
			}
			return new Array;
		}
		
		/**
		 * 根据类型获取今日未完成任务个数，默认获取今日所有未完成任务个数
		 * @param taskStyle<br>
		 * 英语单词：yy.W<br>
		 * 英语阅读：yy.R
		 * 英语习题：yy.E
		 * 英语口语：@y.O
		 * @return 
		 * 
		 */
		public function getTodayUnfinishedTaskByStyle(taskStyle:String=null):int{
			if(taskObj){
				trace(taskObj[taskStyle]);
				
				return taskObj[taskStyle];
			}
			
			return 0;
			
			
			
		}
		
		public function updateTaskData(vo:UpdateTaskDataVO):void{
			
			if(!listObject)
				return;
			
			for(var i:int=0;i<listObject.length;i++)
			{
				if(String(listObject[i].bookroute) == vo.type){
					
					var obj:Object = listObject[i].tasks;
					for (var j:int = 0; j < obj.length; j++) 
					{
						if(obj[j].rrl == vo.rrl){
							obj[j].lnstatus = vo.statu;
							obj[j].rlevel = vo.level;
							return;
						}
					}
				}
			}
		}
		
		
		

		//更新今日任务列表
		public function updateTaskList():void{
//			getTaskList();
			
			//检测任务列表时间戳
			checkTaskStamp();
		}
	}
}