package com.mylib.game.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.IFighter;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.studyMate.module.ModuleConst;
	
	import flash.utils.Dictionary;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class FightCharaterPoolProxy extends ObjectPool implements IProxy
	{
		private var enemyFactory:FighterFactory;
		public static const NAME:String = "FightCharaterPool";
		private var usingObj:Dictionary;
		
		private var _charaterPool:ObjectPool;
		
		
		public function FightCharaterPoolProxy(grow:Boolean=false)
		{
			super(grow);
		}
		
		public function getProxyName():String
		{
			return ModuleConst.FIGHT_CHARATER_POOL;
		}
		
		public function setData(data:Object):void
		{
		}
		
		public function getData():Object
		{
			return null;
		}
		
		public function onRegister():void
		{
			charaterPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy;
			usingObj = new Dictionary(true);
		}
		
		public function onRemove():void
		{
			for(var i:* in usingObj) 
			{
				TweenLite.killTweensOf(i);
				if(i.charater){
					charaterPool.object = i.charater;
					i.charater = null;
				}
				i.pause();
				i.dispose();
			}
			
			
			
			this.purge();
			this.deconstruct();
		}
		
		public function init():void{
			enemyFactory = new FighterFactory();
			setFactory(enemyFactory);
			allocate(10);
		}
		
		override public function get object():*
		{
			var enemyAI:FighterControllerMediator = super.object as FighterControllerMediator;
			var enemy:IFighter =  charaterPool.object;
			enemyAI.charater = enemy;
			enemy.velocity = 1;
			enemy.attackRate = 1;
			enemy.attackInterval = 1;
			enemy.attackRange = 20;
			enemy.attack = 5;
			enemyAI.reset();
			enemy.hpMax = 100;
			usingObj[enemyAI] = charaterPool;
			
			
			return enemyAI;
		}
		
		override public function set object(o:*):void
		{
			if((o as FighterControllerMediator).charater){
				(o as FighterControllerMediator).pause();
				if((o as FighterControllerMediator).decision){
					(o as FighterControllerMediator).decision.dispose();
					(o as FighterControllerMediator).decision = null;
				}
				usingObj[o].object = (o as FighterControllerMediator).charater;
				(o as FighterControllerMediator).charater = null;
			}
			delete usingObj[o];
			super.object = o;
		}

		public function get charaterPool():ObjectPool
		{
			return _charaterPool;
		}

		public function set charaterPool(value:ObjectPool):void
		{
			_charaterPool = value;
			
		}
		
		private var multitonKey:String;
		public function initializeNotifier(key:String):void
		{
			multitonKey = key;
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification( notificationName, body, type );
		}
	}
}
import com.mylib.game.charater.logic.AIGroup;
import com.mylib.game.charater.logic.FighterControllerMediator;

import de.polygonal.core.ObjectPoolFactory;

internal class FighterFactory implements ObjectPoolFactory
{
	public static var idx:int;
	
	public function create():*
	{
		var enemyAI:FighterControllerMediator = new FighterControllerMediator("FromFighterFactoryId"+idx,null,1,AIGroup.ENEMY);
		idx++;
		return enemyAI;
	}
	
}
