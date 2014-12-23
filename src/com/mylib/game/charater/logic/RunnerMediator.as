package com.mylib.game.charater.logic
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	
	public class RunnerMediator extends Mediator implements IMediator, IRunner, IAnimatable
	{
		
		
		public function RunnerMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		public function start():void
		{
			
			if(!Facade.getInstance(CoreConst.CORE).hasMediator(this.getMediatorName())){
				Facade.getInstance(CoreConst.CORE).registerMediator(this);
			}
			
			if(!Starling.juggler.contains(this)){
				Starling.juggler.add(this);
			}
			
		}
		
		public function pause():void
		{
			if(Starling.juggler.contains(this)){
				Starling.juggler.remove(this);
			}
		}
		
		public function advanceTime(time:Number):void
		{
		}
		
		
		override public function onRemove():void
		{
			pause();
		}
		
		public function dispose():void{
			TweenLite.killTweensOf(this);
			Facade.getInstance(CoreConst.CORE).removeMediator(getMediatorName());
		}
		
	}
}