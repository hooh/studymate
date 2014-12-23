package com.mylib.game.charater
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.fightState.IFightState;
	import com.mylib.game.charater.item.FeelingFrame;
	import com.mylib.game.charater.item.SpeakFrame;
	import com.mylib.game.charater.skill.ISkill;
	import com.mylib.game.charater.weapon.WeaponInfor;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.geom.Rectangle;
	
	import akdcl.skeleton.export.TextureMix;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	
	public class HumanMediator extends SimpleCharaterMediator implements IHuman,IFighter
	{
		public static const NAME:String = "HumanMediator";
		
		public static const FACE_NORMAL:String = "normal";
		public static const RUN:String = "run";
		public static const WALK:String = "walk";
		public static const IDLE:String = "idle";
		public static const SIT:String = "sit";
		public static const BEATHEAD:String = "beatHead";
		public static const ATTACK:String = "attack";
		public static const HIT:String = "hit";
		public static const DIE:String = "die";
		private var _attackRange:int;
		private var _attackRate:Number;
		private var _attackDuration:Number;
		private var _breakChance:Number;
		private var _attack:int;
		private var _hp:int;
		private var _defense:int;
		private var _hpMax:int;
		private var hpDisplay:Quad;
		private const hpDisplayMaxWidth:int = 50;
		private var _minAttackRange:int;
		private var _level:int=1;
		private var _dodge:Number;
		private var _skills:Vector.<ISkill>;
		private var _fightStates:Vector.<IFightState>;
		private var _weapon:WeaponInfor;
		
		public function speak():void
		{
			actor.playAnimation("speak",8,100,true);
		}
		
		override public function idle():void
		{
			if(_currentAction!=IDLE){
				_currentAction = IDLE;
				actor.playAnimation("idle",32,64,true);
				actor.display.pivotX = 20;
				actor.display.pivotY = 60;
				
			}
				
		}
		
		override public function walk():void
		{
			if(_currentAction!=WALK){
				actor.playAnimation(WALK,7,50,true);
				_currentAction = WALK;
			}
		}
		
		public function sit():void
		{
			_currentAction = SIT;
			actor.playAnimation(SIT,20,100,false);
		}
		
		override public function run():void{
			if(_currentAction!=RUN){
				_currentAction = RUN;
				actor.playAnimation(RUN,7,32,true);
				
			}
		}
		
		
		public function beatHead():void
		{
			_currentAction = BEATHEAD;
			actor.playAnimation(BEATHEAD,9,54,false);
			TweenLite.delayedCall(0.3,look,["pain"]);
			TweenLite.delayedCall(2,look,["normal"]);
		}
		
		
		override public function onRegister():void
		{
			_skills = new Vector.<ISkill>;
			_fightStates = new Vector.<IFightState>;
			super.onRegister();
		}
		
		
		
		override protected function initActor():void
		{
			super.initActor();
			look(FACE_NORMAL);
		}
		
		
		
		
		public function HumanMediator(charaterName:String,charaterSuit:CharaterSuitsVO,skeleon:String,viewComponent:Object,range:Rectangle)
		{
			super(charaterName,charaterSuit,skeleon,viewComponent,range);
		}
		
		public function look(face:String):void
		{
			// TODO Auto Generated method stub
			_actor.switchCostume("head","face",face);
		}
		
		public function say(frame:SpeakFrame):void
		{
			
			if(dirX>0){
				frame.dir = -1;
				frame.x = -50*scale;
			}else{
				frame.dir = 1;
				frame.x = 50*scale;
			}
			
			frame.y = -110;
			
			view.addChild(frame);
			
		}
		
		public function feel(frame:FeelingFrame):void
		{
			// TODO Auto Generated method stub
			frame.y = -110;
			if(dirX<0){
				frame.dir = 1;
				frame.x = 50*scale;
			}else{
				frame.dir = -1;
				frame.x = -50*scale;
			}
			
			view.addChild(frame);
		}
		
		public function menu(btn:Vector.<Button>):void{
			
			for (var i:int = 0; i < btn.length; i++) 
			{
				btn[i].x = (-70+50*i)*scale;
				btn[i].y = -120-(20*(i%2));
				view.addChild(btn[i]);
			}
		}
		
		
		override protected function getTexture():TextureMix
		{
			return Assets.charaterTexture;
		}
		
		
		public function attackAction(_speed:Number):void
		{
			_currentAction = ATTACK;
			actor.playAnimation("fight",8,_speed*20,false);
		}
		
		public function hitAction():void
		{
			_currentAction = HIT;
			actor.playAnimation("hit",8,100,false);
		}
		
		public function defenseAction():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function die():void
		{
			_currentAction = DIE;
			actor.playAnimation("die",8,60,false);
		}
		
		public function fallDown():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get hp():int
		{
			return _hp;
		}
		
		public function set hp(_int:int):void
		{
			_hp = _int;
			
			if(_hp<0){
				_hp=0;
			}
			
			/*if(!hpDisplay){
				hpDisplay = new Image(Assets.getCharaterTexture("hpbar"));
				hpDisplay.x = -hpDisplayMaxWidth>>1;
			}
			if(!hpDisplay.parent){
				view.addChild(hpDisplay);
			}
			hpDisplay.width = _hp/_hpMax*hpDisplayMaxWidth;*/
			
			
		}
		
		public function set hpMax(_int:int):void
		{
			_hpMax = _int;
		}
		
		public function get hpMax():int
		{
			return _hpMax;
		}
		
		
		public function set attackRange(_int:int):void
		{
			// TODO Auto Generated method stub
			_attackRange = _int;
		}
		
		public function get attackRange():int
		{
			return _attackRange;
		}
		
		
		public function get attackRate():Number
		{
			return _attackRate;
		}
		
		public function set attackRate(_value:Number):void
		{
			_attackRate = _value;
		}
		
		public function set attackInterval(_value:Number):void
		{
			_attackDuration = _value;
		}
		
		public function get attackInterval():Number
		{
			return _attackDuration;
		}
		
		
		public function get attack():int
		{
			return _attack;
		}
		
		public function set attack(_int:int):void
		{
			_attack = _int;
		}
		
		public function get defense():int
		{
			return _defense;
		}
		
		public function set defense(_int:int):void
		{
			_defense = _int;
		}
		
		
		public function get breakChance():Number
		{
			return _breakChance;
		}
		
		public function set breakChance(_num:Number):void
		{
			_breakChance  = _num;
		}
		
		public function set luck(_num:Number):void
		{
			
		}
		
		public function get lucky():Number
		{
			return 0;
		}
		
		
		
		public function set minAttackRange(_int:int):void
		{
			_minAttackRange = _int;
		}
		
		public function get minAttackRange():int
		{
			return _minAttackRange;
		}
		
		public function set dodge(_num:Number):void
		{
			_dodge = _num;
		}
		
		public function get dodge():Number
		{
			return _dodge;
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set level(_lv:int):void
		{
			_level = _lv;
		}
		
		public function addSkill(_skill:ISkill):void
		{
			_skills.push(_skill);
		}
		
		public function get skills():Vector.<ISkill>
		{
			return _skills;
		}
		
		
		public function addState(_fs:IFightState):void
		{
			_fightStates.push(_fs);
		}
		
		public function get fightStates():Vector.<IFightState>
		{
			return _fightStates;
		}
		
		public function set weapon(_w:WeaponInfor):void
		{
			_weapon = _w;
		}
		
		public function get weapon():WeaponInfor
		{
			// TODO Auto Generated method stub
			return _weapon;
		}
		
		
		
	}
}