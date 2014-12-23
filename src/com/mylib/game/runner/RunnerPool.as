package com.mylib.game.runner
{
	import com.mylib.framework.CoreConst;
	
	import flash.utils.Dictionary;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	
	public class RunnerPool extends ObjectPool 
	{
		private var runnerFactory:RunnerFactory;
		private var usingObj:Dictionary;
		
		
		public function RunnerPool(grow:Boolean=false)
		{
			super(grow);
			usingObj = new Dictionary;
			runnerFactory = new RunnerFactory;
			setFactory(runnerFactory);
			allocate(6);
		}
		
		override public function deconstruct():void
		{
			
			
			for (var i:* in usingObj) 
			{
				object = i;
			}
			
			initialze("dispose",null);
			
			super.deconstruct();			
		}
		
		
		override public function get object():*
		{
			var o:Runner = super.object;
			usingObj[o] = true;
			return o;
		}
		
		override public function set object(o:*):void
		{
			// TODO Auto Generated method stub
			super.object = o;
			delete usingObj[o];
			(o as Runner).reset();
			(o as Runner).stop();
			(o as Runner).ai.runner = null;
			(o as Runner).ai.target = null;
			(o as Runner).view.removeFromParent();
			
		}
		
	}
}

import com.mylib.framework.CoreConst;
import com.mylib.game.runner.Runner;
import com.mylib.game.runner.RunnerAI;

import de.polygonal.core.ObjectPoolFactory;

import org.puremvc.as3.multicore.patterns.facade.Facade;


internal class RunnerFactory implements ObjectPoolFactory
{
	public static var idx:int;
	
	public function create():*
	{
		var runner:Runner = new Runner("FromRunnerPoolId"+idx);
		Facade.getInstance(CoreConst.CORE).registerMediator(runner);
		runner.ai = new RunnerAI(null,runner);
		idx++;
		return runner;
	}
	
}