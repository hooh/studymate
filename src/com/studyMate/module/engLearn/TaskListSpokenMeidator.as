package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.engLearn.api.TaskListSpokenConst;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.pages.TaskItem;
	import com.studyMate.world.screens.FlipPageMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TaskListSpokenMeidator extends ScreenBaseMediator
	{
		
		
		public var pageNum:int;
		public var taskArr:Array=[];
		public var totalLen:int;
		public var totalPage:int;
		public var image:TaskItem;
		
		//private var taskStyle:String = "";
		
		private var pages:Vector.<IFlipPageRenderer>;
		private var vo:SwitchScreenVO;
//		private var taskObject:Object;
		private var taskRRL:String;
		private var taskStatu:String;
		private var isRebuild:Boolean;
		
		public function TaskListSpokenMeidator( viewComponent:Object=null)
		{
			super(ModuleConst.TASKLIST_SPOKEN, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			sendNotification(CoreConst.STOP_BEAT);			
			sendNotification(WorldConst.BROADCAST_FAQ,0);
			sendNotification(WorldConst.BROADCAST_MAIL,0);
			sendNotification(WorldConst.BROADCAST_CHAT);
			
			sendNotification(WorldConst.HIDE_NOTICE_BOARD);//隐藏公告栏
			sendNotification(WorldConst.SHOW_BUTTON_BY_LEVEL, 1);
//			sendNotification(WorldConst.SHOW_MAINMENU_BUTTON, "menuSoundBtn");
			var bg:Image = new Image(Assets.getTexture("task_bg"));
			view.addChild(bg);
			
			var rebuildBtn:Button = new Button();
			rebuildBtn.x = 85;
			rebuildBtn.y = 30;
			rebuildBtn.label = "重建任务";
			rebuildBtn.addEventListener(TouchEvent.TOUCH,rebuildBtnHandle);
			view.addChild(rebuildBtn);
			
			if(taskArr.length != 0){
				
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageMediator,new FlipPageData(pages),SwitchScreenType.SHOW,view)]);
			}else{
//				rebuildBtn.visible = false;
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"今天没有该类任务。"));
			}
			
			this.backHandle = quitHandler;
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
		
		private function rebuildBtnHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){//trace("重建所有任务");				
				isRebuild = true;
				updateHandle();
			}
		}				
		private function updateHandle():void//重建所有任务
		{
			PackData.app.CmdIStr[0] = CmdStr.APPLY_YW;
			PackData.app.CmdIStr[1] = "URRB";
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.user;
			PackData.app.CmdIStr[4] = "-101";
			PackData.app.CmdIStr[5] = "flash任务学习";
			PackData.app.CmdIStr[6] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[7] = Global.user;
			PackData.app.CmdIStr[8] = "@y.O";
			PackData.app.CmdInCnt = 9;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(TaskListSpokenConst.REBUILD));
		}
		override public function handleNotification(notification:INotification):void{	
			switch(notification.getName())
			{
				case TaskListSpokenConst.getTodayList:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){	
						var arr:Array = [];
						arr[0] = PackData.app.CmdOStr[0];
						arr[1] = PackData.app.CmdOStr[1];
						arr[2] = PackData.app.CmdOStr[2];
						arr[3] = PackData.app.CmdOStr[3];
						arr[4] = PackData.app.CmdOStr[4];
						arr[5] = PackData.app.CmdOStr[5];
						arr[6] = PackData.app.CmdOStr[6];
						taskArr.push(arr);
						
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						if(taskArr.length>0){
							createPages(taskArr);
						}
						if(isRebuild){
							/*if(facade.hasMediator(FlipPageMediator.NAME) && taskArr.length>0){											
								sendNotification(WorldConst.UPDATE_FLIP_PAGES,new FlipPageData(pages));
							}*/
							if(taskArr.length != 0){
								if(Facade.getInstance(CoreConst.CORE).hasMediator(FlipPageMediator.NAME))
									Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.UPDATE_FLIP_PAGES,new FlipPageData(pages));
								else
									Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageMediator,new FlipPageData(pages),SwitchScreenType.SHOW,view)]);
							}
							isRebuild = false;	
							
							if(taskArr.length==0){
								sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
									640,381,null,"抱歉,今天该类任务无法再重建,请明天再继续任务。"));
							}else{								
								sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
									640,381,null,"重建成功"));
							}
							
						}else{
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);								
						}
						
						
					}
					break;
				case TaskListSpokenConst.REBUILD:
					if(PackData.app.CmdOStr[0] == "000"){													
						taskArr.length = 0;
						
						sendinServerInfo(CmdStr.GET_TODAY_TASK,TaskListSpokenConst.getTodayList,["@y.O"]);
						
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
							640,381,null,"重建失败"));
					}
					break;
			}
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [TaskListSpokenConst.getTodayList,TaskListSpokenConst.REBUILD]
		}
		
		
		private function createPages(taskArr:Array):void{
			var total1:int = taskArr.length;
			var totalPage:int = total1/10+1;
			if(total1%10 == 0)
				totalPage--;
			
			pages = new Vector.<IFlipPageRenderer>(totalPage);
			
			
			for (var i:int = 0; i < totalPage; i++) 
			{
				pages[i]=new SpokenItemRender(i,taskArr,totalPage);
			}
		}


		
		/**
		 * 后台信息派发函数
		 * @param command		命令字
		 * @param reveive		接收字符
		 * @param info			参数数组
		 */		
		private function sendinServerInfo(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+2] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+2;	
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
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
			/*sendNotification(WorldConst.HIDE_MAINMENU_BUTTON,"menuSoundBtn");
			sendNotification(WorldConst.SHOW_BUTTON_BY_LEVEL, 2);
			if(facade.hasMediator(MusicSoundMediator.NAME)){
				facade.removeMediator(MusicSoundMediator.NAME);
			}*/
			view.removeChildren(0,-1,true);
			super.onRemove();
			
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			//taskStyle = vo.data.taskStyle;
		
			sendinServerInfo(CmdStr.GET_TODAY_TASK,TaskListSpokenConst.getTodayList,["@y.O"]);
		}
		
	}
}