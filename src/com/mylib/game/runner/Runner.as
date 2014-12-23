package com.mylib.game.runner
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.model.IslanderPoolProxy;
	import com.studyMate.module.GlobalModule;
	
	import flash.geom.Vector3D;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;
	
	public class Runner extends Mediator implements IAnimatable
	{
		
		public var charater:IslanderControllerMediator;
		private var _data:Vector.<int>;
		public var currentIdx:uint;
		protected var _velocity:Vector3D;
		public var land:int = 80;
		protected var _fsm:StateMachine;
		protected static const JUMP:String = "jump";
		protected static const END:String = "end";
		protected static const RUN:String = "run";
		protected static const EMPTY:String = "empty";
		
		public var isEnd:Boolean;
		
		private var nameField:TextField;


		protected var frameFun:Function;
		public var offset:int = -100;
		public var acc:Number; 
		private var _position:Number=0;
		
		public var ai:RunnerAI; 
		
		public function Runner(name:String)
		{
			
			super(name);
			_velocity = new Vector3D(4,0);
			
		}
		
		public function dispose():void{
			
			facade.removeMediator(this.getMediatorName());
			
		}
		
		public function get position():Number
		{
			return _position;
		}

		public function set position(value:Number):void
		{
			_position = value;
			view.x = int(_position);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			charater = (facade.retrieveProxy(IslanderPoolProxy.NAME) as IslanderPoolProxy).object;
			charater.fsm.changeState(AIState.IDLE);
			
			charater.charater.run();
			charater.setTo(0,land);
			
			
			
			_fsm = new StateMachine();
			_fsm.addState(RUN,{enter:enterRun,from:[JUMP,END]});
			_fsm.addState(JUMP,{enter:enterJump,from:[RUN,EMPTY]});
			_fsm.addState(END,{enter:enterEnd,from:[RUN,JUMP]});
			_fsm.addState(EMPTY,{enter:enterEmpty,from:[JUMP]});
			_fsm.initialState = RUN;
			reset();
			
			nameField = new TextField(120,30,"","HeiTi");
			nameField.y = 18;
			nameField.color =0x04447a;
			nameField.autoSize = TextFieldAutoSize.HORIZONTAL;
			
			
			
		}
		
		public function start():void{
			RunnerGlobal.juggler.add(this);
			charater.charater.actor.start();
		}
		
		public function stop():void{
			RunnerGlobal.juggler.remove(this);
			charater.charater.actor.stop();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			(facade.retrieveProxy(IslanderPoolProxy.NAME) as IslanderPoolProxy).object = charater;
			Starling.juggler.remove(this);
			if(ai){
				ai.target = null;
				ai.runner = null;
			}
			if(_data)
			_data.length = 0;
		}
		
		
		
		protected function enterEmpty(event:StateMachineEvent):void{
			
		}
		
		protected function enterRun(event:StateMachineEvent):void{
			_velocity.y=0;
			charater.charater.run();
			view.y = land;
			frameFun = runFun;
		}
		
		protected function enterJump(event:StateMachineEvent):void{
			_velocity.y = -10;
			charater.charater.action("jump",4,40,false);
			frameFun = jumpFun;
		}
		
		public function set speed(_speed:Number):void{
			_velocity.x = _speed;
		}
		
		public function get speed():Number{
			return _velocity.x;
		}
		
		protected function enterEnd(event:StateMachineEvent):void{
			isEnd = true;
			frameFun = endFun;
			if(_data){
				_data.length = 0;
			}
			charater.charater.action("trip",10,20,false);
			TweenLite.to(charater.charater.view,1,{x:charater.charater.view.x+100,ease:Quad.easeOut});
			TweenLite.to(charater.charater.view,0.4,{y:land,ease:Quart.easeIn});
			
		}
		
		public function dressUp(dress:String):void{
			GlobalModule.charaterUtils.configHumanFromDressList(charater.charater,dress,null);
		}
		
		public function reset():void{
			currentIdx = 0;
			isEnd = false;
			_fsm.changeState(RUN);
			position = offset;
			acc =0;
			_velocity.y = 0;
			
		}
		
		protected function jumpFun():void{
			var aboveGround:Boolean=view.y <= land+5;
			if(aboveGround){
				_velocity.y+=0.4;
				view.y+=_velocity.y;
			}
			
			if(!aboveGround&&!isEnd){
				_fsm.changeState(RUN);
			}
			updateFrame();
			
		}
		
		protected function runFun():void{
			updateFrame();
			
		}
		
		protected function endFun():void{
			
		}
		
		
		protected function updateFrame():void{
			
			position += _velocity.x;
			if(ai){
				ai.update();
			}
			
			
			if(_data&&currentIdx<_data.length){
				if(view.x>=_data[currentIdx]){
					if(_data[currentIdx+1]==OperType.JUMP){
						_fsm.changeState(EMPTY);
						_fsm.changeState(JUMP);
					}else{
						_fsm.changeState(END);
					}
					
					currentIdx+=2;
				}
			}
			
			if(!_velocity.y&&acc!=0){
				position+=acc;
			}
			
			
			
		}
		
		
		
		
		
		public function set data(_data:Vector.<int>):void{
			this._data = _data;
		}
		
		public function get data():Vector.<int>{
			return this._data;
		}
		
		
		public function get view():Sprite{
			return charater.charater.view;
		}
		
		public function set name(_name:String):void{
			nameField.text = _name;
			view.addChild(nameField);
			nameField.alignPivot();
		}
		
		public function get name():String{
			return nameField.text;
		}
		
		
		public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			frameFun.apply();
			
		}
		
	}
}