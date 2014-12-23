package com.studyMate.world.controller
{
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.view.EduAlertMediator;
	import com.studyMate.world.screens.view.NormalAlertSkin;
	import com.studyMate.world.screens.view.WifiAlertSkin;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class AlertShowCommand extends SimpleCommand implements ICommand
	{
		public function AlertShowCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(facade.hasMediator(EduAlertMediator.NAME))
				return;			
			var alertVo:AlertVo = notification.getBody() as AlertVo;
			var alertMeidator:EduAlertMediator;
			if(alertVo.skin){
				alertMeidator =  new EduAlertMediator(alertVo.skin);
				alertMeidator.isPosition = true;
			}else{
				alertMeidator = new EduAlertMediator(new NormalAlertSkin());
			}
			/*if(notification.getType() == "0"){
				var alertMeidator:EduAlertMediator = new EduAlertMediator(new WifiAlertSkin());
				alertMeidator.isPosition = true;
			}else{
				alertMeidator = new EduAlertMediator(new NormalAlertSkin());
				
			}*/
			
			
			alertMeidator.prepare(alertVo);//字符串代表弹出框内容
//			sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(alertMeidator.view));
			//facade.registerMediator(alertMeidator);
			
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(alertMeidator)));
			
		}
	}
}