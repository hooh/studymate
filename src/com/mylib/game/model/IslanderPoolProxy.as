package com.mylib.game.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.studyMate.module.ModuleConst;
	
	import flash.utils.Dictionary;
	
	import de.polygonal.core.ObjectPool;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class IslanderPoolProxy extends ObjectPool implements IProxy
	{
		public static const NAME:String = "IslanderPoolProxy";
		private var humanPool:HumanPoolProxy;
		private var usingObj:Dictionary;
		private var islanderFactory:IslanderFactory;
		
		public function IslanderPoolProxy(grow:Boolean=false)
		{
			super(grow);
		}
		
		public function getProxyName():String
		{
			return NAME;
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
			humanPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy;
			usingObj = new Dictionary();
		}
		
		public function onRemove():void
		{
			for(var i:* in usingObj) 
			{
				TweenLite.killTweensOf(i);
				if(i.charater){
					humanPool.object = i.charater;
					i.charater = null;
				}
			}
			
			initialze("pause",null);
			initialze("dispose",null);
			
			this.purge();
			this.deconstruct();
		}
		
		
		public function init():void{
			islanderFactory = new IslanderFactory();
			setFactory(islanderFactory);
			allocate(12);
		}
		
		override public function get object():*
		{
			var islanderController:IslanderControllerMediator = super.object as IslanderControllerMediator;
			var islander:HumanMediator =  humanPool.object;
			islanderController.charater = islander;
			islander.velocity = 3;
			getLogger(FightCharaterPoolProxy).debug(islanderController.getMediatorName()+" out "+islander.getMediatorName());
			usingObj[islanderController] = true;
			
			return islanderController;
		}
		
		override public function set object(o:*):void
		{
			if(!(o is IslanderControllerMediator)){
				throw new Error("set wrong type in IslanderPoolProxy");
				return;
			}
			
			
			if((o as IslanderControllerMediator).charater){
				(o as IslanderControllerMediator).pause();
				humanPool.object = (o as IslanderControllerMediator).charater;
				(o as IslanderControllerMediator).reset();
				(o as IslanderControllerMediator).charater = null;
				(o as IslanderControllerMediator).decision = null;
			}
			TweenLite.killTweensOf(o);
			delete usingObj[o];
			super.object = o;
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

import com.mylib.game.charater.logic.IslanderControllerMediator;

import de.polygonal.core.ObjectPoolFactory;

internal class IslanderFactory implements ObjectPoolFactory
{
	public static var idx:int;
	
	public function create():*
	{
		var islanderController:IslanderControllerMediator = new IslanderControllerMediator("FromIslanderFactoryId"+idx,null,1);
		idx++;
		return islanderController;
	}
	
}