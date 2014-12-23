package com.mylib.game.charater
{
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	
	import akdcl.skeleton.export.TextureMix;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	
	public class SimpleCharaterMediator extends Mediator implements IMediator,ICharater
	{
		public static const NAME:String = "SimpleCharaterMediator";
		protected var _actor:IActor;
		
		private var _charaterName:String;
		public var charaterSuit:CharaterSuitsVO;
		public var skeleon:String;
		public var _sex:String;
		
		
		public var isCopy:Boolean;
		
		private var _dirX:int;
		private var _scale:Number;
		
		protected var _velocity:Number;
		
		protected var _currentAction:String;
		protected var _range:Rectangle;
		
		public function get actor():IActor
		{
			return _actor;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}	
		
		
		public function idle():void
		{
		}
		public function walk():void
		{
		}
		
		public function run():void
		{
		}
		
		
		override public function onRemove():void
		{
			facade.removeMediator((_actor as IMediator).getMediatorName());
			view.removeEventListeners(TouchEvent.TOUCH);
		}
		
		override public function onRegister():void
		{
			initActor();
			
		}
		
		protected function initActor():void{
			_actor = new ActorMediator(getMediatorName()+ActorMediator.NAME,charaterSuit,skeleon,viewComponent,Starling.juggler,getTexture());
			facade.registerMediator(_actor as IMediator);
			idle();
		}
		
		protected function getTexture():TextureMix{
			throw new IllegalOperationError("getTexture() 必须重写");
			return null;
		}
		
		
		
		public function SimpleCharaterMediator(charaterName:String,charaterSuit:CharaterSuitsVO,skeleon:String,viewComponent:Object,range:Rectangle,copy:Boolean=false)
		{
			this.charaterName = charaterName;
			this.charaterSuit = charaterSuit;
			this.skeleon = skeleon;
			this.sex = charaterSuit.sex;
			this.range = range;
			scale = 1;
			dirX=1;
			isCopy = copy;
			super(NAME+charaterName, viewComponent);
			
		}
		
		public function dispose():void
		{
			facade.removeMediator(getMediatorName());
		}

		public function get charaterName():String
		{
			return _charaterName;
		}

		public function set charaterName(value:String):void
		{
			_charaterName = value;
		}
		
		public function get sex():String
		{
			return _sex;
		}
		
		public function set sex(value:String):void
		{
			_sex = value;
		}

		
		public function set dirX(_d:int):void
		{
			if(view&&actor.display.scaleX!=scale*_d){
				actor.display.scaleX = scale*_d;
			}
			_dirX = _d;
		}
		
		public function get dirX():int
		{
			return _dirX;
		}
		
		public function set scale(_s:Number):void
		{
			_scale = _s;
			if(view&&view.scaleX!=_scale){
				view.scaleX = view.scaleY = _scale;
			}
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function action(...parameters):void
		{
			_currentAction = parameters[0];
			actor.playAnimation(parameters[0],parameters[1],parameters[2],parameters[3]);
		}
		
		public function get currentAction():String
		{
			return _currentAction;
		}
		
		
		public function set velocity(num:Number):void
		{
			_velocity = num;
		}
		
		public function get velocity():Number
		{
			return _velocity;
		}
		
		public function get range():Rectangle
		{
			return _range;
		}
		
		public function set range(_r:Rectangle):void
		{
			_range = _r;
		}
		
	}
}