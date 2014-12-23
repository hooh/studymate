package com.studyMate.world.controller
{
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.ICharater;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class MarkOtherPlayerCharaterCommand extends SimpleCommand
	{
		public function MarkOtherPlayerCharaterCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
//			var texture:Texture = Assets.getCharaterTexture("mark");
//			var mark:Image = new Image(texture);
//			mark.pivotX = mark.width>>1;
//			mark.pivotY = mark.height>>1;
//			mark.alpha = 0.5;
//			var charater:ICharater = notification.getBody() as ICharater;
//			charater.view.addChildAt(mark,0);
//			mark.y = -12;
//			mark.x = -2;
			
			var charater:ICharater = notification.getBody()[0] as ICharater;
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).
				setCharaterLevel(charater.view, notification.getBody()[1]);
		}
		
	}
}