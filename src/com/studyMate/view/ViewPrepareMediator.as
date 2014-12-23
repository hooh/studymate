package com.studyMate.view
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public final class ViewPrepareMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ViewPrepareMediator";
		private var _sourceViewMediator:Mediator;
		
		public function ViewPrepareMediator(sourceViewMediator:Mediator=null)
		{
			this.sourceViewMediator = sourceViewMediator;
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			if(sourceViewMediator){
				sourceViewMediator.handleNotification(notification);
			}
		}
		
		override public function listNotificationInterests():Array
		{
			
			if(sourceViewMediator)
				return sourceViewMediator.listNotificationInterests();
			
			return null;
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			sourceViewMediator = null;
		}

		public function get sourceViewMediator():Mediator
		{
			return _sourceViewMediator;
		}

		public function set sourceViewMediator(value:Mediator):void
		{
			_sourceViewMediator = value;
		}
		
		
		
	}
}