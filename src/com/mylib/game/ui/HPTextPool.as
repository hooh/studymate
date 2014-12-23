package com.mylib.game.ui
{
	import com.mylib.framework.CoreConst;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.text.TextField;
	
	public class HPTextPool extends ObjectPool implements IProxy
	{
		public static const NAME:String = "HPTextPool";
		
		
		public function HPTextPool(grow:Boolean=true)
		{
			super(grow);
			
			this.setFactory(new TextFieldFactory);
			allocate(12);
		}
		
		override public function get object():*
		{
			// TODO Auto Generated method stub
			return super.object;
		}
		
		override public function set object(o:*):void
		{
			// TODO Auto Generated method stub
			(o as TextField).removeFromParent();
			super.object = o;
		}
		
		public function getData():Object
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getProxyName():String
		{
			return NAME;
		}
		
		public function onRegister():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function onRemove():void
		{
			this.deconstruct();
		}
		
		public function setData(data:Object):void
		{
			// TODO Auto Generated method stub
			
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
import de.polygonal.core.ObjectPoolFactory;

import starling.text.TextField;

internal class TextFieldFactory implements ObjectPoolFactory
{
	
	public function create():*
	{
		return new TextField(60,30,"","HeiBMP",24);
	}
	
}