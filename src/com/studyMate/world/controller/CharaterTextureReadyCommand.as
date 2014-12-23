package com.studyMate.world.controller
{
	import com.mylib.game.model.BMPFighterPoolProxy;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CharaterTextureReadyCommand extends SimpleCommand implements ICommand
	{
		public function CharaterTextureReadyCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var suitsProxy:CharaterSuitsProxy = facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
			suitsProxy.init();
			
			sendNotification(WorldConst.CONFIG_DEPENDED_MODEL);
			
			
			
			facade.registerProxy(new HumanPoolProxy(true));
			facade.registerProxy(new BMPFighterPoolProxy(true));
			
			
			var humanPoolProxy:HumanPoolProxy = facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy;
			humanPoolProxy.init();
			
			var bmpFighterPoolProxy:BMPFighterPoolProxy = facade.retrieveProxy(ModuleConst.BMP_FIGHTER_POOL) as BMPFighterPoolProxy;
			bmpFighterPoolProxy.init();
			
		}
		
	}
}