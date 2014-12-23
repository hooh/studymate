package com.mylib.game.charater.effect
{
	import com.mylib.game.charater.weapon.WeaponInfor;
	import com.studyMate.world.controller.vo.AttackCharaterVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class FightEffectProxy extends Proxy
	{
		public static const NAME:String = "FightEffectProxy";
		
		public function FightEffectProxy()
		{
			super(NAME);
		}
		
		public function fight(acvo:AttackCharaterVO):void{
			
//			acvo.attacker.charater.currentAnimation = HumanMediator.ATTACK;
			switch(acvo.attacker.fighter.weapon.type)
			{
				
				
				case WeaponInfor.GUN:
				{
					acvo.attacker.charater.action("fight",8,acvo.attacker.fighter.attackRate*20,false);
					break;
				}
				case WeaponInfor.SWORD:{
					
					acvo.attacker.charater.action("fight",8,acvo.attacker.fighter.attackRate*20,false);
					
					break;
				}
				default:
				{
					break;
				}
			}
			
			
			
		}
		
		
	}
}