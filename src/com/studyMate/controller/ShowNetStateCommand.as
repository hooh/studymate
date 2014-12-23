package com.studyMate.controller
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.NetStateMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class ShowNetStateCommand extends SimpleCommand implements ICommand
	{
		
		
		public function ShowNetStateCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void{
			
			var netStateMediator:NetStateMediator = facade.retrieveMediator(NetStateMediator.NAME) as NetStateMediator;
			
			if(!netStateMediator)
			{
				netStateMediator = new NetStateMediator;
				
				var vo:SwitchScreenVO = new SwitchScreenVO;
				vo.data = true;
				
				netStateMediator.prepare(vo);
				facade.registerMediator(netStateMediator);
				
			}
			
			AppLayoutUtils.uiLayer.addChild(netStateMediator.view);
			
		}
		
		
	}
}