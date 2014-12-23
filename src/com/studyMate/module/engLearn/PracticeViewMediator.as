package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	internal class PracticeViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "PracticeViewMediator";
		public static const BEGIN_NEXT_PRACTICE:String = NAME+"BeginNextPractice";
		private var prepareVO:SwitchScreenVO;
		private var rrl:String;
		private var practiceId:String;
		private var status:String;
		
		public var isBrowse:Boolean = false;
		
		public function PracticeViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			if(prepareVO.data.rrl.indexOf("yy.E.")!=-1){//任务练习
				/*rrl = prepareVO.data.rrl;
				practiceId = prepareVO.data.status;
				status = prepareVO.data.type;
				Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);*/
				getPracticeId(prepareVO.data.rrl);
			}
		}
		public static const GET_PRACTICE_TASK:String = NAME+"getPracticeTask";
		private function getPracticeId(childRRL:String):void{
			PackData.app.CmdIStr[0] = CmdStr.GET_READING_TASK_ID;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = childRRL;
			PackData.app.CmdInCnt =3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_PRACTICE_TASK));
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			switch(name){
				case BEGIN_NEXT_PRACTICE:
					var arr:Array = notification.getBody() as Array;
					rrl = arr[0];
					practiceId = arr[1];
					status = arr[2];
					initializeComponent(practiceId);
					break;
				case GET_PRACTICE_TASK : 
					if(PackData.app.CmdOStr[0] == "000"){
						rrl = PackData.app.CmdOStr[2];
						practiceId = PackData.app.CmdOStr[3];
						status = "yy.E.";
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
					}
					break;
			}
		}
		
		public function initializeComponent(_id:String):void{
			var data:Object = new Object;
			data.rrl = rrl;
			data.practiceId = _id;
			data.status = status;
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PracticeComponentViewMediator,data,SwitchScreenType.SHOW,view)]);
		}
		
		override public function listNotificationInterests():Array
		{
			return [BEGIN_NEXT_PRACTICE,GET_PRACTICE_TASK];
		}
		
		override public function onRegister():void
		{
			initializeComponent(practiceId);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		
	}
}