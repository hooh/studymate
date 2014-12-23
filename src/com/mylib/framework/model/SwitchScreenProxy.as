package com.mylib.framework.model
{
	
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.ScreenStack;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	public class SwitchScreenProxy extends Proxy implements IProxy,ISwitchScreenProxy
	{
		private var _cpuStack:ScreenStack;
		private var _gpuStack:ScreenStack;
		
		private var _cpuMediators:Vector.<String>;
		private var _gpuMediators:Vector.<String>;
		private var _gpuFloatScreens:Vector.<SwitchScreenVO>;
		private var _cpuFloatScreens:Vector.<SwitchScreenVO>;
		
		
		
		//记录是否已经有切换的gpu界面
		protected var switchGpuMark:Boolean;
		//记录是否已经有切换的cpu界面
		protected var switchCpuMark:Boolean;
		
		private var _currentGpuScreen:ScreenBaseMediator;
		private var _currentCpuScreen:ScreenBaseMediator;
		
		private var _pushStackType:uint;
		
		
		public static const PUSH:uint = 1;
		public static const POP:uint = 0;
		public static const REPLACE:uint = 2;
		
		
		/**
		 *0 pop
		 * 1 push
		 * 2 replace 
		 */
		public function get pushStackType():uint
		{
			return _pushStackType;
		}
		
		/**
		 * @private
		 */
		public function set pushStackType(value:uint):void
		{
			_pushStackType = value;
		}
		
		public function get cpuFloatScreens():Vector.<SwitchScreenVO>
		{
			return _cpuFloatScreens;
		}
		
		public function set cpuFloatScreens(value:Vector.<SwitchScreenVO>):void
		{
			_cpuFloatScreens = value;
		}
		
		public function get gpuFloatScreens():Vector.<SwitchScreenVO>
		{
			return _gpuFloatScreens;
		}
		
		public function set gpuFloatScreens(value:Vector.<SwitchScreenVO>):void
		{
			_gpuFloatScreens = value;
		}
		
		public function get cpuMediators():Vector.<String>
		{
			return _cpuMediators;
		}
		
		public function set cpuMediators(value:Vector.<String>):void
		{
			_cpuMediators = value;
		}
		
		public function get gpuMediators():Vector.<String>
		{
			return _gpuMediators;
		}
		
		public function set gpuMediators(value:Vector.<String>):void
		{
			_gpuMediators = value;
		}
		
		public function get gpuStack():ScreenStack
		{
			return _gpuStack;
		}
		
		public function set gpuStack(value:ScreenStack):void
		{
			_gpuStack = value;
		}
		
		public function get cpuStack():ScreenStack
		{
			return _cpuStack;
		}
		
		public function set cpuStack(value:ScreenStack):void
		{
			_cpuStack = value;
		}
		
		public function get currentCpuScreen():ScreenBaseMediator
		{
			return _currentCpuScreen;
		}
		
		public function set currentCpuScreen(value:ScreenBaseMediator):void
		{
			_currentCpuScreen = value;
		}
		
		public function get currentGpuScreen():ScreenBaseMediator
		{
			return _currentGpuScreen;
		}
		
		public function set currentGpuScreen(value:ScreenBaseMediator):void
		{
			_currentGpuScreen = value;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			cpuStack = new ScreenStack();
			gpuStack = new ScreenStack();
			
			cpuMediators = new Vector.<String>;
			gpuMediators = new Vector.<String>;
			
			gpuFloatScreens = new Vector.<SwitchScreenVO>;
			cpuFloatScreens = new Vector.<SwitchScreenVO>;
			
		}
		
		
		public function SwitchScreenProxy()
		{
			super(ModuleConst.SWITCH_SCREEN_PROXY);
		}
		
		public function switchViews(_views:Vector.<SwitchScreenVO>):void{
			
			var vo:SwitchScreenVO;
			var view:*;
			
			switchCpuMark = false;
			switchGpuMark = false;
			var needPush:Boolean;
			needPush = false;
			var i:int;
			//create views and regist with mediator
			for (i = 0; i < _views.length; i++) 
			{
				vo = _views[i];
				if(!vo.view){
					view = new vo.mediator.viewClass;
				}else{
					view = vo.view;
				}
				registerScreen(vo,view);
				
				vo.mediator.setViewComponent(view);
				
				if(vo.type==SwitchScreenType.SWITCH){
					needPush = true;
				}
				
				
			}
			
			if((pushStackType==PUSH)&&needPush){
				
				//补齐队列  the same with last screen
				if(!switchCpuMark){
					cpuStack.push(cpuStack.lastScreen());
				}
				
				if(!switchGpuMark){
					gpuStack.push(gpuStack.lastScreen());
				}
				
			}else if(pushStackType==POP){
				cpuStack.pop();
				gpuStack.pop();
			}
			
			
		}
		
		protected function registerScreen(vo:SwitchScreenVO,view:*):void{
			if(view is flash.display.DisplayObject){
				registerCpuScreen(vo,view);
			}else if(view is starling.display.DisplayObject){
				registerGpuScreen(vo,view);
			}
		}
		
		public function initScreen(_views:Vector.<SwitchScreenVO>):void{
			var vo:SwitchScreenVO;
			var i:int;
			var needPush:Boolean;
			//we register the mediators finally since reentry
			for (i = 0; i < _views.length; i++) 
			{
				vo = _views[i];
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("s onRegister",vo.mediatorName,0));
				facade.registerMediator(vo.mediator);
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("e onRegister",vo.mediatorName,0));
				vo.mediator = null;
				vo.view = null;
				
				if(vo.type==SwitchScreenType.SWITCH){
					Global.isSwitching = false;
					needPush = true;
				}
				
			}
			
			if(needPush){
				sendNotification(WorldConst.SWITCH_SCREEN_COMPLETE,_views);
			}else{
				sendNotification(WorldConst.SHOW_SCREEN_COMPLETE,_views);
			}
			
			Starling.current.start();
			
		}
		
		
		protected function registerGpuScreen(vo:SwitchScreenVO,view:starling.display.DisplayObject):void{
			
			if(vo.type==SwitchScreenType.SWITCH){
				
				if(switchGpuMark){
					throw new IllegalOperationError("can not switch multi-gpu view at once");
				}
				
				
				sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.GPU);
				AppLayoutUtils.gpuLayer.removeChildren(0,-1,true);
				AppLayoutUtils.gpuLayer.dispose();
				
				AppLayoutUtils.gpuLayer.addChild(view);
				
				if(pushStackType==PUSH){
					gpuStack.push(vo);
				}
				
				currentGpuScreen = vo.mediator;
				switchGpuMark = true;
				
				
			}else{
				view.x = vo.x;
				view.y = vo.y;
				
				if(!vo.holder){
					vo.holder = AppLayoutUtils.gpuLayer;
				}
				
				
				if(vo.index>=0){
					(vo.holder as starling.display.DisplayObjectContainer).addChildAt(view,vo.index);
				}else{
					(vo.holder as starling.display.DisplayObjectContainer).addChild(view);
				}
				
				
				if(vo.type!=SwitchScreenType.HIDE){
					gpuFloatScreens.push(vo);
				}
				
				
			}
			vo.mediatorName = vo.mediator.getMediatorName();
			gpuMediators.push(vo.mediatorName);
			
			
		}
		
		protected function registerCpuScreen(vo:SwitchScreenVO,view:flash.display.Sprite):void{
			
			
			if(vo.type==SwitchScreenType.SWITCH){
				
				if(switchCpuMark){
					throw new IllegalOperationError("can not switch multi-cpu view at once");
				}
				
				
				sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.CPU);
				
				AppLayoutUtils.cpuLayer.addChild(view);
				
				if(pushStackType==PUSH){
					cpuStack.push(vo);
				}
				
				currentCpuScreen = vo.mediator;
				switchCpuMark = true;
			}else{
				view.x = vo.x;
				view.y = vo.y;
				if(!vo.holder){
					vo.holder = AppLayoutUtils.cpuLayer;
				}
				
				if(vo.index>=0){
					(vo.holder as flash.display.DisplayObjectContainer).addChildAt(view,vo.index);
				}else{
					(vo.holder as flash.display.DisplayObjectContainer).addChild(view);
				}
				
				
				if(vo.type!=SwitchScreenType.HIDE){
					cpuFloatScreens.push(vo);
				}
				
				
			}
			vo.mediatorName = vo.mediator.getMediatorName();
			cpuMediators.push(vo.mediatorName);
			
		}
		
		
		
		
		
		
		
	}
}