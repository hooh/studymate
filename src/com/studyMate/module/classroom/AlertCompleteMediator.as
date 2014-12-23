package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	internal class AlertCompleteMediator extends ScreenBaseMediator
	{
		private var pareVO:SwitchScreenVO;
		
		public function AlertCompleteMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super('AlertCompleteMediator', viewComponent);
		}
		override public function onRemove():void{
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		override public function onRegister():void{
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this)));
			
			var bg:Quad = new Quad(Global.stageWidth,Global.stageHeight,0);
			bg.alpha = 0.38;
			view.addChild(bg);
			bg.touchable = false;
			
			var bgImg:Image = new Image(Assets.getCnClassroomTexture('alertCompleteBg'));
			bgImg.x = 654;
			bgImg.y = 253;
			view.addChild(bgImg);
			bgImg.touchable = false;
			
			var closeBtn:Button = new Button(Assets.getCnClassroomTexture('cancelEndBtn'));
			closeBtn.x = 798;
			closeBtn.y = 429;
			view.addChild(closeBtn);
			
			var sureBtn:Button = new Button(Assets.getCnClassroomTexture('sureEndBtn'));
			sureBtn.x = 898;
			sureBtn.y = 429;
			view.addChild(sureBtn);
			
			closeBtn.addEventListener(Event.TRIGGERED,closeHandler);
			sureBtn.addEventListener(Event.TRIGGERED,sureHandler);
			
		}
		
		private function sureHandler():void
		{
			PackData.app.CmdIStr[0] = CmdStr.MARK_EXPLAINED;
			PackData.app.CmdIStr[1] =  CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String; //教室标识
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CRoomConst.MARK_RW_COMPLETE,null,'cn-gb',null,SendCommandVO.UNIQUE))
			closeHandler();
		}
		
		private function closeHandler():void
		{
			pareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}
		/*override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				
			}
		}
		override public function listNotificationInterests():Array{
			return [
				];
		}*/
		override public function get viewClass():Class{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{	
			pareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}