package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.engLearn.api.TaskListConst;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.TaskListManagementMediator;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.pages.TaskPage;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.FlipPageMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class TaskListMediator extends ScreenBaseMediator
	{
		private var arrayCollection:Array = [];
		private var pages:Vector.<IFlipPageRenderer>;
		private var vo:SwitchScreenVO;
		private var taskObject:Object;
		private var taskRRL:String;
		private var taskStatu:String;
		private var isRebuild:Boolean;
		
		private const delayTime:Number=3600;
		/**
		 *任务类型<br>
		 * 英语单词：yy.W
		 * 英语阅读：yy.R
		 */		
		private var taskStyle:String = "";
		private var texture:Texture;

		public function TaskListMediator(viewComponent:Object=null)
		{
			super(ModuleConst.TASKLIST, viewComponent);
		}

		override public function onRegister():void
		{
			sendNotification(CoreConst.STOP_BEAT);			
			sendNotification(WorldConst.BROADCAST_FAQ,0);
			sendNotification(WorldConst.BROADCAST_MAIL,0);
			sendNotification(WorldConst.BROADCAST_CHAT);
			
			sendNotification(WorldConst.HIDE_NOTICE_BOARD);//隐藏公告栏
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SHOW_BUTTON_BY_LEVEL, 1);
			sendNotification(WorldConst.SHOW_MAINMENU_BUTTON, "menuSoundBtn");
			
			var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;

			
			
			texture = Texture.fromBitmap(Assets.store["task_bg"],false);
			var bg:Image = new Image(texture);
			view.addChild(bg);
			
			var rebuildBtn:Button = new Button(Assets.getTaskListTexture("rebuildBtn"));
			rebuildBtn.x = 1070;
			rebuildBtn.y = 672;
			rebuildBtn.addEventListener(Event.TRIGGERED,rebuildBtnHandle);
			view.addChild(rebuildBtn);
			
			if(taskStyle=='yy.W'){
				var rebuildErrBtn:Button = new Button(Assets.getTaskListTexture("rebuildErrBtn"));
				rebuildErrBtn.x = 860;
				rebuildErrBtn.y = 672;
				rebuildErrBtn.addEventListener(Event.TRIGGERED,rebuildErrBtnHandle);
				view.addChild(rebuildErrBtn);
			}
	
			if(taskObject.length != 0){
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageMediator,new FlipPageData(pages),SwitchScreenType.SHOW,view)]);
			}else{
//				rebuildBtn.visible = false;
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"今天没有该类任务。"));
			}

			this.backHandle = quitHandler;
			TweenLite.delayedCall(delayTime,quitHandler);//三分钟后退出
			var tmpString:String = config.getValueInUser("setBackgroundMusic");
			if(tmpString == "true"){
				if(!facade.hasMediator(MusicSoundMediator.NAME)){				
					sendNotification(WorldConst.SHOW_MUSICPLAYER);
					Global.stage.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}else if(tmpString == "false"){
			}else{
				config.updateValueInUser("setBackgroundMusic", true);
				if(!facade.hasMediator(MusicSoundMediator.NAME)){				
					sendNotification(WorldConst.SHOW_MUSICPLAYER);
					Global.stage.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
			
			trace("@VIEW:TaskListMediator:");
		}
		private function quitHandler():void{
			sendNotification(CoreConst.START_BEAT);

			sendNotification(WorldConst.HIDE_MAINMENU_BUTTON,"menuSoundBtn");
			sendNotification(WorldConst.SHOW_BUTTON_BY_LEVEL, 2);
			if(facade.hasMediator(MusicSoundMediator.NAME)){
				facade.removeMediator(MusicSoundMediator.NAME);
			}
			sendNotification(WorldConst.POP_SCREEN);
		}
		/*protected function viewKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.preventDefault();	
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,viewKeyDownHandler);
				sendNotification(WorldConst.REMOVE_MAINMENU_BUTTON,"menuSoundBtn");
				if(facade.hasMediator(MusicSoundMediator.NAME)){
					facade.removeMediator(MusicSoundMediator.NAME);
				}
			}
		}*/
		private function rebuildBtnHandle(e:Event):void{
			trace("重建所有任务");
			sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n确定要重建当日任务吗？",true,'yesQuitHandler','noHandler',false,null,rebuildHandler));//提交订单
			
		}
		private function rebuildErrBtnHandle(e:Event):void{
			trace("重建错题任务");
			sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n确定要重建错题任务吗？",true,'yesQuitHandler','noHandler',false,null,rebuildErrHandler));//提交订单
			
		}
		
		private function rebuildErrHandler():void
		{
			if(!isRebuild){
				isRebuild = true;
				updateErrHandle();
			}
		}
		
		private function rebuildHandler():void{
			if(!isRebuild){
				isRebuild = true;
				updateHandle();
			}
		}
			
		private function createPages(task:Object):void{
			var total1:int = task.length;
			var totalPage:int = total1/15+1;
			if(total1%15 == 0)
				totalPage--;
			
			pages = new Vector.<IFlipPageRenderer>(totalPage);
			
			
			for (var i:int = 0; i < totalPage; i++) 
			{
				pages[i]=new TaskPage(i,task as Array,totalPage);
			}
		}
		
		override public function handleNotification(notification:INotification):void{	
			var data:Object={};
			switch(notification.getName())
			{
				case WorldConst.ITEM_TASK_INFO:
					taskRRL = notification.getBody()[0];
					taskStatu = notification.getBody()[1];
					
					beginOneTask();
					break;
				case TaskListConst.BEGIN_ONE_TASK:
					if(PackData.app.CmdOStr[1] == undefined) break;
					if(PackData.app.CmdOStr[0] == "000")
					{
						branchLearn();
					}
					break;
				//进入阅读界面
				case TaskListConst.GET_READING_TASK:
					if(PackData.app.CmdOStr[0] == "000"){
						var rrl:String = PackData.app.CmdOStr[2];
						var returnId:String = PackData.app.CmdOStr[3];	
						
						data.rrl = rrl;
						data.isComplete = true;
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadBGMediator,data),new SwitchScreenVO(CleanCpuMediator)]);
					}
					break;
				//进入习题界面
				case TaskListConst.GET_PRACTICE_TASK:
					if(PackData.app.CmdOStr[0] == "000"){
						rrl = PackData.app.CmdOStr[2];
						returnId = PackData.app.CmdOStr[3];
//						sendNotification(ApplicationFacade.PUSH_VIEW,new PushViewVO(PracticeView,new TaskItemVO(rrl,returnId,taskStatu)));
					}
					break;
				//进入知识点界面
				case TaskListConst.GET_KNOWLEDGE_POINT_TASK:
					if(PackData.app.CmdOStr[0] == "000"){
						rrl = PackData.app.CmdOStr[2];
						returnId = PackData.app.CmdOStr[3];
//						sendNotification(ApplicationFacade.PUSH_VIEW,new PushViewVO(KnowledgeTaskView,new TaskItemVO(rrl,returnId,taskStatu)));
					}
					break;
				//监听WorldConst.UPDATE_TAKSLIST的更新完成
				case WorldConst.UPDATE_TASKLIST_COMPLETE:
					var taskListManagementMediator:TaskListManagementMediator = Facade.getInstance(CoreConst.CORE).retrieveMediator(TaskListManagementMediator.NAME) as TaskListManagementMediator;
					taskObject = taskListManagementMediator.getTodayTaskByStyle(taskStyle);
					
					if(taskObject.length != 0){
						createPages(taskObject);
					}
					
					if(isRebuild){
						if(taskObject.length != 0){
							if(Facade.getInstance(CoreConst.CORE).hasMediator(FlipPageMediator.NAME))
								Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.UPDATE_FLIP_PAGES,new FlipPageData(pages));
							else
								Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageMediator,new FlipPageData(pages),SwitchScreenType.SHOW,view)]);
						}	
							
						isRebuild = false;
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
				//刷新重建所有任务
				case TaskListConst.REBUILD:
					if(PackData.app.CmdOStr[0] == "000"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
							640,381,null,"重建成功"));
						
						sendNotification(WorldConst.UPDATE_TAKSLIST);
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
							640,381,null,"重建失败"));
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
			return [WorldConst.ITEM_TASK_INFO,TaskListConst.BEGIN_ONE_TASK,
				TaskListConst.GET_READING_TASK,TaskListConst.GET_PRACTICE_TASK,
				TaskListConst.GET_KNOWLEDGE_POINT_TASK,WorldConst.UPDATE_TASKLIST_COMPLETE,TaskListConst.REBUILD];
		}
		
		//学习分支机构
		private function branchLearn():void{
			var data:Object={};
			if(taskRRL.indexOf("yy.R")!=-1){
				//获取阅读任务id
				data.rrl = taskRRL;
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadBGMediator,data),new SwitchScreenVO(CleanCpuMediator)]);
				
			}else if(taskRRL.indexOf("yy.E")!=-1){
				//获取习题任务id
				data.rrl = taskRRL;
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExercisesLearnMediator,data)]);
			}else if(taskRRL.indexOf("yy.P")!=-1){
				//获取知识点任务id
				PackData.app.CmdIStr[0] = CmdStr.GET_READING_TASK_ID;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = taskRRL;
				PackData.app.CmdInCnt =3;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(TaskListConst.GET_KNOWLEDGE_POINT_TASK));
			}else if(taskRRL.indexOf("yy.D")!=-1){
				data.rrl = taskRRL;
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadAloudBGMediator,data)]);
			}else{
				data.rrl = taskRRL;
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WordLearningBGMediator,data),new SwitchScreenVO(CleanCpuMediator)]);
				//							sendNotification(ApplicationFacade.PUSH_VIEW,new PushViewVO(WordLearningView,new TaskItemVO(taskRRL,taskStatu)));
				taskStatu = "";
			}
		}
		
		//开始任务
		private function beginOneTask():void{
			if(taskStatu == "") return;
			if(taskStatu == "A" || taskStatu == "R")
			{
				if(taskRRL.indexOf("yy.W")==0){					
					PackData.app.CmdIStr[0] = CmdStr.BEGIN_ONE_TASK;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = taskRRL;
					PackData.app.CmdInCnt = 3;
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(TaskListConst.BEGIN_ONE_TASK));
				}else{
					branchLearn();
				}
			}
			if(taskStatu == "Z" ){
				if(taskRRL.indexOf("yy.R")!=-1){
					PackData.app.CmdIStr[0] = CmdStr.GET_READING_TASK_ID;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = taskRRL;
					PackData.app.CmdInCnt =3;
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(TaskListConst.GET_READING_TASK));
				}
			}
		}
		private function updateErrHandle():void{
			PackData.app.CmdIStr[0] = CmdStr.APPLY_YW;
			PackData.app.CmdIStr[1] = "URRB";
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.user;
			PackData.app.CmdIStr[4] = "-101";
			PackData.app.CmdIStr[5] = "flash任务学习";
			PackData.app.CmdIStr[6] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[7] = Global.user;
			PackData.app.CmdIStr[8] = 'yy.w';
			PackData.app.CmdInCnt = 9;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(TaskListConst.REBUILD,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
		}
		//重建所有任务
		private function updateHandle():void
		{
			PackData.app.CmdIStr[0] = CmdStr.APPLY_YW;
			PackData.app.CmdIStr[1] = "URRB";
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.user;
			PackData.app.CmdIStr[4] = "-101";
			PackData.app.CmdIStr[5] = "flash任务学习";
			PackData.app.CmdIStr[6] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[7] = Global.user;
			PackData.app.CmdIStr[8] = taskStyle;
			PackData.app.CmdInCnt = 9;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(TaskListConst.REBUILD,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
		}

		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRemove():void
		{
			//Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,viewKeyDownHandler);
			Assets.disposeTexture("task/bg");
			Assets.disposeTexture("task/star");
			texture.dispose();
			view.removeChildren(0,-1,true);
			TweenLite.killDelayedCallsTo(quitHandler);
			super.onRemove();
			
		}

		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			taskStyle = vo.data.taskStyle;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.UPDATE_TAKSLIST);
	
		}
		
		override public function activate():void
		{
			super.activate();
			trace("@VIEW:TaskListMediator:");
		}
	}
}