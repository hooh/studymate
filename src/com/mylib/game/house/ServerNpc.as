package com.mylib.game.house
{
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	
	public class ServerNpc
	{
		public var serverNpcVo:ServerNpcVo = new ServerNpcVo();
		
		public var isEnter:Boolean;
		
		public var islander:IslanderControllerMediator;
		
		
		public function ServerNpc(_islander:IslanderControllerMediator){
			
			islander = _islander;
			
		}
	}
}