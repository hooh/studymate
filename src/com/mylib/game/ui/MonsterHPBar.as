package com.mylib.game.ui
{
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.controller.vo.HeroFightVO;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class MonsterHPBar extends Sprite implements IUpdateValue
	{
		private var bar:Quad;
		public var totalValue:int;
		public var currentValue:int;
		private var heroFightVO:HeroFightVO;
		
		public function update():void
		{
			bar.width = int(100*heroFightVO.remainHP/totalValue);
		}
		
		public function MonsterHPBar(heroFightVO:HeroFightVO)
		{
			super();
			this.heroFightVO = heroFightVO;
			totalValue = heroFightVO.monster.data.fullHP;
			
			
			
			bar = new Quad(100,8,0x00ff00);
			addChild(bar);
		}
	}
}