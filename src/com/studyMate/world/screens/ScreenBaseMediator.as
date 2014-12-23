package com.studyMate.world.screens
{
	import com.mylib.framework.controller.IPrepareMediator;
	import com.mylib.framework.controller.IScreenBase;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import flash.errors.IllegalOperationError;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	
	public class ScreenBaseMediator extends Mediator implements IMediator, IPrepareMediator,IScreenBase
	{
		protected var _runEnterFrames:Boolean;
		public var backHandle:Function;
		
		public function ScreenBaseMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		public function activate():void
		{
			// TODO Auto Generated method stub
		}
		
		public function get viewClass():Class
		{
			throw new IllegalOperationError("get viewClass must be implemented");
			return null;
		}
		
		
		public function deactivate():void
		{
			// TODO Auto Generated method stub
		}
		
		public function set runEnterFrames(_b:Boolean):void{
			
			if(!_runEnterFrames&&_b){
				Starling.juggler.add(this);
			}else if(_runEnterFrames&&!_b){
				Starling.juggler.remove(this);
			}
			_runEnterFrames = _b;
		}
		
		public function get runEnterFrames():Boolean{
			return _runEnterFrames;
		}
		
		
		
		public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		override public function onRemove():void
		{
			if(_runEnterFrames){
				runEnterFrames = false;
			}
		}
		
		
		
		
		public function prepare(vo:SwitchScreenVO):void
		{
			throw new IllegalOperationError("prepare must be implemented");
		}
	}
}