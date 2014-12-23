package com.mylib.game.charater.logic
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.ICharater;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import stateMachine.StateMachine;

	public class BaseCharaterControllerMediator extends RunnerMediator implements IBoid
	{
		public var position  	:Vector3D;
		public var velocity 	:Vector3D;
		public var mass			:Number;
		public var steering  	:SteeringManager;
		protected var _fsm:StateMachine;
		
		
		protected var _decision:IDecision;
		
		public var destination:Vector3D  = new Vector3D;
		
		protected var _touchable:Boolean;
		
		public static const CLICK_CHARATER:String = NAME + "clickCharater";
		
		
		public function BaseCharaterControllerMediator(mediatorName:String=null, viewComponent:Object=null,totalMass:Number=1)
		{
			super(mediatorName, viewComponent);
			
			position 	= new Vector3D;
			velocity 	= new Vector3D(0, 0);
			mass	 	= totalMass;
			steering 	= new SteeringManager(this);
			_fsm = new StateMachine();
			_fsm.id = getMediatorName();
			
			initFSM();
			
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			touchable = false;
		}
		
		override public function advanceTime(time:Number):void
		{
			
			
			think();
			
			steering.update();
			
			if(!charater){
				return;
			}
			charater.view.x = position.x;
			charater.view.y = position.y;
			
			
			if(velocity.x>0){
				charater.dirX = 1;
			}else if(velocity.x<0){
				charater.dirX = -1;
			}
			
		}
		
		public function think() :void {
			if(decision)
			decision.makeDecision(this);
		}
		
		override public function start():void
		{
			// TODO Auto Generated method stub
			super.start();
		}
		
		protected function initFSM():void{
			
		}
		
		public function getMass():Number
		{
			return mass;
		}
		
		public function getMaxVelocity():Number
		{
			if(charater){
				return charater.velocity;
			}else{
				return 0;
			}
		}
		
		public function getPosition():Vector3D
		{
			return position;
		}
		
		public function getVelocity():Vector3D
		{
			return velocity;
		}
		
		public function get fsm():StateMachine
		{
			return _fsm;
		}
		
		public function get decision():IDecision
		{
			return _decision;
		}
		
		public function set decision(_d:IDecision):void
		{
			_decision = _d;
		}
		
		
		public function get charater():ICharater{
			return getViewComponent() as ICharater;
		}
		
		public function set charater(_c:ICharater):void{
			setViewComponent(_c);
		}
		
		public function set touchable(_b:Boolean):void{
			
			if(_b){
				if(charater&&charater.view){
					charater.view.addEventListener(TouchEvent.TOUCH,clickHandle);
				}
			}else{
				if(charater&&charater.view){
					charater.view.removeEventListener(TouchEvent.TOUCH,clickHandle);
				}
			}
			_touchable = _b;
		}
		
		override public function setViewComponent(viewComponent:Object):void
		{
			if(charater){
				charater.view.removeEventListener(TouchEvent.TOUCH,clickHandle);
			}
			
			super.setViewComponent(viewComponent);
			
			touchable = touchable;
			
		}
		
		
		protected function clickHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				
				
				var location:Point = touch.getLocation(event.currentTarget as DisplayObject);
				if(!(event.currentTarget as DisplayObject).hitTest(location, true))
				{
					return;
				}
				
				
				
				Facade.getInstance(CoreConst.CORE).sendNotification(CLICK_CHARATER,this);
			}
			
		}
		
		
		public function setTo(_x:int,_y:int):void{
			
			position.setTo(_x,_y,0);
			charater.view.x = _x;
			charater.view.y = _y;
		}
		
		public function getAngle(vector :Vector3D) :Number {
			return Math.atan2(vector.y, vector.x);
		}
		
		
		public function get touchable():Boolean{
			return _touchable;
		}
		
		public function reset() :void {
			velocity.setTo(0,0,0);
			resetState();
		}
		
		public function resetState():void{
		}
		
		
		public function go(_x:int,_y:int):void{
			
		}
		
	}
}