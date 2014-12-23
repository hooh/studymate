package com.studyMate.world.controller
{
	import com.greensock.TweenLite;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.ICharater;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class MarkMyCharaterCommand extends SimpleCommand implements ICommand
	{
		
		public function MarkMyCharaterCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			
			
			
			
//			var texture:Texture = Assets.getCharaterTexture("mark1");
//			var mark:Image = new Image(texture);
//			mark.pivotX = mark.width>>1;
//			mark.pivotY = mark.height>>1;
//			mark.alpha = 0.5;
//			var charater:ICharater = notification.getBody() as ICharater;
//			charater.view.addChildAt(mark,0);
//			mark.y = 0;
//			mark.x = -2;
			
			/*var level:int = Math.random()*1100+100;
			
			TweenLite.delayedCall(1,function():void{
				trace("您的登记======================================================="+level);
			});
			
			var charater:ICharater = notification.getBody() as ICharater;
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).
				setCharaterLevel(charater.view, level, true);*/
			
			
			
			var charater:ICharater = notification.getBody() as ICharater;
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).
				setCharaterLevel(charater.view, Global.myLevel, true);
			
			
		}
		
	}
}