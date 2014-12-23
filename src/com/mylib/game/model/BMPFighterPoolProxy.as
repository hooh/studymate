package com.mylib.game.model
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.BMPEnemyMediator;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.utils.Dictionary;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class BMPFighterPoolProxy extends ObjectPool implements IProxy
	{
		
		private var bmpFighterFactory:BMPCharaterFactory;
		private var usingObj:Dictionary;
		
		
		public function BMPFighterPoolProxy(grow:Boolean=false)
		{
			usingObj = new Dictionary(true);
			super(grow);
		}
		
		
		public function getProxyName():String
		{
			return ModuleConst.BMP_FIGHTER_POOL;
		}
		
		override public function get object():*
		{
			var o:BMPEnemyMediator = super.object;
			o.actor.start();
			(o as BMPEnemyMediator).idle();
			(o as BMPEnemyMediator).view.alpha = 1;
			usingObj[o] = true;
			
			return o;
		}
		
		public function callbackAll():void{
			
			for (var i:* in usingObj) 
			{
				object = i;
			}
			
		}
		
		
		override public function set object(o:*):void
		{
			(o as BMPEnemyMediator).actor.stop();
			(o as BMPEnemyMediator).actor.stopMove();
			(o as BMPEnemyMediator).actor.dressDown();
			(o as BMPEnemyMediator).actor.setProfile(new CharaterSuitsVO);
			(o as BMPEnemyMediator).view.removeEventListeners();
			(o as BMPEnemyMediator).view.removeFromParent(true);
			if((o as BMPEnemyMediator).skills){
				(o as BMPEnemyMediator).skills.length = 0;
			}
			if((o as BMPEnemyMediator).fightStates){
				(o as BMPEnemyMediator).fightStates.length = 0;
			}
			
			(o as BMPEnemyMediator).scale = 1;
			delete usingObj[o];
			super.object = o;
			
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
		}
		
		public function init():void{
			
			bmpFighterFactory = new BMPCharaterFactory();
			setFactory(bmpFighterFactory);
			allocate(12);
			
		}
		
		public function onRemove():void
		{
			for (var i:* in usingObj) 
			{
				object = i;
			}
			
			while(this.wasteCount){
				(object as BMPEnemyMediator).dispose();
			}
			
			usingObj = null;
			this.purge();
			this.deconstruct();
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
import com.mylib.framework.CoreConst;
import com.mylib.game.charater.BMPEnemyMediator;
import com.mylib.game.model.CharaterSuitsProxy;

import de.polygonal.core.ObjectPoolFactory;

import org.puremvc.as3.multicore.patterns.facade.Facade;

import starling.display.Sprite;

internal class BMPCharaterFactory implements ObjectPoolFactory
{
	public static var idx:int;
	
	public function BMPCharaterFactory()
	{
	}
	
	public function create():*
	{
		var fighter:BMPEnemyMediator;
		var suitsProxy:CharaterSuitsProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
		fighter = new BMPEnemyMediator("FromBMPFighterFactoryId"+idx,suitsProxy.getCharaterSuit("bmpTemplet",true),new Sprite,null);
		
		
		Facade.getInstance(CoreConst.CORE).registerMediator(fighter);
		
		
		fighter.actor.stop();
		idx++;
		return fighter;
	}
}