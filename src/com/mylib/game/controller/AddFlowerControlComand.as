package com.mylib.game.controller
{
	import com.studyMate.world.screens.FlowerMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class AddFlowerControlComand extends SimpleCommand implements ICommand
	{
		public static const NAME:String = "SceneFlower";
		public static var idx:int;
		
		
		public function AddFlowerControlComand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var view:DisplayObject = notification.getBody() as DisplayObject;
			
			var controller:Mediator = new FlowerMediator(NAME+idx,view);
			facade.registerMediator(controller);
			
			idx++;
			
			
			
			
			
		}
		
	}
}