package com.studyMate.model.vo
{
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class PopUpCommandVO
	{
		
		public var screenMediator:Mediator;
		public var useModal:Boolean;
		
		
		public function PopUpCommandVO(screenMediator:Mediator,useModal:Boolean=true)
		{
			this.screenMediator = screenMediator;
			this.useModal = useModal;
			
		}
	}
}