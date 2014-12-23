package com.mylib.game.controller.vo
{
	import com.mylib.game.card.CardGroup;

	public class CardFightAnimationVO
	{
		public var attackers:CardGroup;
		public var defenders:CardGroup;
		
		public function CardFightAnimationVO(attackers:CardGroup,defenders:CardGroup)
		{
			this.attackers = attackers;
			this.defenders = defenders;
		}
	}
}