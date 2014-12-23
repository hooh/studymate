package com.mylib.game.card
{
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class CardGameHelperMediator extends Mediator
	{
		public static const NAME:String = "CardGameHelperMediator";
		
		
		public function CardGameHelperMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
	}
}