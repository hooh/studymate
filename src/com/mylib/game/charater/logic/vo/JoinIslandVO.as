package com.mylib.game.charater.logic.vo
{
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	
	import flash.geom.Point;

	public class JoinIslandVO
	{
		
		public var home:Point;
		public var islander:IslanderControllerMediator;
		
		public function JoinIslandVO(islander:IslanderControllerMediator,home:Point)
		{
			this.islander = islander;
			this.home = home;
		}
	}
}