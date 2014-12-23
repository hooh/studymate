package com.mylib.game.model
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.HumanMediator;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.utils.Dictionary;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class HumanPoolProxy extends ObjectPool implements IProxy
	{
		
		private var humanFactory:HumanFactory;
		private var usingObj:Dictionary;
		
		
		public function HumanPoolProxy(grow:Boolean=false)
		{
			usingObj = new Dictionary(true);
			super(grow);
		}
		
		
		public function getProxyName():String
		{
			return ModuleConst.HUMAN_POOL;
		}
		
		override public function get object():*
		{
			var o:HumanMediator = super.object;
			o.actor.start();
			(o as HumanMediator).idle();
			(o as HumanMediator).view.alpha = 1;
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
			(o as HumanMediator).actor.stop();
			(o as HumanMediator).actor.stopMove();
			(o as HumanMediator).actor.dressDown();
			(o as HumanMediator).actor.setProfile(new CharaterSuitsVO);
			(o as HumanMediator).view.removeEventListeners();
			(o as HumanMediator).view.removeFromParent(true);
			
			(o as HumanMediator).skills.length = 0;
			(o as HumanMediator).fightStates.length = 0;
			
			(o as HumanMediator).scale = 1;
			(o as HumanMediator).dirX = 1;
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
			var suitsProxy:CharaterSuitsProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
			var profile:CharaterSuitsVO = suitsProxy.getCharaterSuit("templet",true);
			
			var defaultProfile:CharaterSuitsVO;
			humanFactory = new HumanFactory(profile);
			setFactory(humanFactory);
			allocate(12);
			
		}
		
		public function onRemove():void
		{
			
			for  (var i:* in usingObj) 
			{
				object = i;
			}
			while(this.wasteCount){
				(object as HumanMediator).dispose();
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
import com.mylib.game.charater.HumanMediator;
import com.mylib.game.model.CharaterSuitsProxy;
import com.studyMate.world.model.vo.CharaterSuitsVO;

import de.polygonal.core.ObjectPoolFactory;

import org.puremvc.as3.multicore.patterns.facade.Facade;

import starling.display.Sprite;

internal class HumanFactory implements ObjectPoolFactory
{
	public static var idx:int;
	public var defaultProfile:CharaterSuitsVO;
	
	public function HumanFactory(defaultProfile:CharaterSuitsVO)
	{
		this.defaultProfile = defaultProfile;
	}
	
	public function create():*
	{
//		trace(idx);
		var human:HumanMediator;
		var suitsProxy:CharaterSuitsProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
		human = new HumanMediator("FromHumanFactoryId"+idx,suitsProxy.getCharaterSuit("templet",true),"MHuman",new Sprite,null);
		
		Facade.getInstance(CoreConst.CORE).registerMediator(human);
		human.actor.stop();
		idx++;
		return human;
	}
}