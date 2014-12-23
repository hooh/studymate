package com.studyMate.world.controller
{
	import com.studyMate.global.Global;
	import com.mylib.game.charater.logic.RandomActionProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RandomActionCommand extends SimpleCommand implements ICommand
	{
		
		/**
		 *随机运动生成的 RandomActionProxy
		 */		
		public static var RAProxy:Vector.<RandomActionProxy> = new Vector.<RandomActionProxy>;
		public function RandomActionCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:RandomActionProxy = (new RandomActionProxy()) as RandomActionProxy;
			//全局保存新建的proxy
			RAProxy.push(proxy);
			proxy.addItem(notification.getBody());
		}
	}
}