package com.mylib.game.charater.logic
{
	import com.mylib.game.charater.state.IRandomWalkerState;

	public interface IActorContorller
	{
		
		function get items():Vector.<IRandomWalkerState>;
		function stopAction(walker:IRandomWalkerState):void;
		function addItem(item:IRandomWalkerState):void;
		function removeItem(item:IRandomWalkerState):void;
	}
}