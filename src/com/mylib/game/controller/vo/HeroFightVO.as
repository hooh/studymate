package com.mylib.game.controller.vo
{
	import com.mylib.game.card.GameCharater;
	import com.studyMate.world.screens.BasementMediator;
	
	import starling.display.Sprite;

	public class HeroFightVO
	{
		public var heros:Vector.<GameCharater>;
		public var monster:GameCharater;
		public var readyCount:int;
		
		public var averageDamage:int;
		
		public var remainHP:int;
		public var crit:Number;
		
		public var reward:Number;
		public var remainTime:int;
		
		public var cacheHP:int;
		public var heroAttribute:uint;
		
		public var taskId:String;
		
		public var basement:BasementMediator;
		
		
		public var charaterHolder:Sprite;
		
		
		public function HeroFightVO(heros:Vector.<GameCharater>,monster:GameCharater,heroAttribute:uint,charaterHolder:Sprite)
		{
			this.heros = heros;
			this.monster = monster;
			readyCount = 0;
			averageDamage = 0;
			reward = 1;
			crit = 0.2;
			
			this.heroAttribute = heroAttribute;
			
			
			remainHP = monster.data.hp;
			remainTime = 0;
			
			this.charaterHolder = charaterHolder;
		}
		
		
		public function update():void{
			updateDamage();
			updateRemainTime();
			
		}
		
		public function updateDamage():void{
			
			var totalDamage:int=0;
			for (var i:int = 0; i < heros.length; i++) 
			{
				
				(heros[i] as GameCharater).data.attack = heros[i].data.values[0].value*1.4+7;
				
				totalDamage += (heros[i] as GameCharater).data.attack;
			}
			
			averageDamage = reward*totalDamage*(1+crit*2);
			
		}
		
		public function updateRemainTime():void{
			remainTime = remainHP/averageDamage;
		}
		
		
		
	}
}