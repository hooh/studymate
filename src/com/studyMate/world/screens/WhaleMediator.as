package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.effects.SwimWater;
	import com.studyMate.world.screens.effects.WaterSpray;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.animation.Juggler;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	
	public class WhaleMediator extends Mediator implements IMediator
	{
		//private const STATE_STAY:uint=1;
		
		
		public static var NAME:String = "WhaleMediator";
		//private var _costumes:Object;
		//private var _animation:MovieClip;
		//public var juggler:Juggler;
		private var texture:Texture;
		
		private var holder:Sprite;
		
		private var swimwater:SwimWater;
		private var waterSpray:WaterSpray;
		
		public var range:Rectangle;
		
		
		public function WhaleMediator(viewComponent:Object,_juggler:Juggler=null)
		{
			//juggler = _juggler;
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
//			SoundAS.loadSound(MyUtils.getSoundPath("waterflow.mp3"),"waterflow");
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("waterflow.mp3"),"waterflow"));						

			texture = Assets.getChapterAtlasTexture("chapter/whale");
			holder = new Sprite();
			holder.x = 200;
			holder.y = 100;
			view.addChild(holder);
			
			
			holder.addChild(new Image(texture));
			keepUPAndDown = true;
			
			view.pivotX = holder.pivotX = holder.width>>1;
			
			
			swimwater = new SwimWater();
			waterSpray = new WaterSpray();
			
			holder.addChild(swimwater);
			holder.addChild(waterSpray);
			swimwater.x = holder.width;
			swimwater.y = 150;
			
			waterSpray.x = 234;
			waterSpray.y = 70;
			
			holder.addEventListener(TouchEvent.TOUCH,clickHandle);
			holder.touchable = true;
//			randomDuration();
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CaptainMediator,null,SwitchScreenType.SHOW,holder,100,50)]);
			
		}
		
		private function clickHandle(event:TouchEvent):void
		{
			// TODO Auto Generated method stub
			if(event.touches[0].phase=="ended"){
				waterSpray.stop();
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,200,0,enterFunction,"到我的肚子里玩吧"));
				
				
			}else if(event.touches[0].phase=="began"){
				waterSpray.removeAnimation();
				waterSpray.start();
			}
		}
		private function enterFunction():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WhaleInsideMediator)]);
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExecuteScriptViewMediator),new SwitchScreenVO(CleanGpuMediator)]);
		}
		
		/*private function randomDuration():void{
			
			randomAction();
			TweenLite.delayedCall(Math.random()*20+5,randomDuration);
			
		}*/
		
		
		
		/*private function randomAction():void{
			
			if(Math.random()>0.3){
				startSpray();
				TweenLite.delayedCall(Math.random()*20+5,stopSpray);
				
			}
			
			if(Math.random()>0.3){
				
				goX(range.width*Math.random()+range.x);
				
			}
			
			
			
		}*/
		
		/*public function startSpray():void{
			waterSpray.removeAnimation();
			waterSpray.start();
		}
		
		public function stopSpray():void{
			waterSpray.stop();
		}
		
		
		
		private function switchState(state:uint):void
		{
			
		}*/
		
		
		private function set keepUPAndDown(_do:Boolean):void{
			
			if(_do){
				TweenMax.to(holder,1,{y:40,yoyo:true,repeat:99999});
			}else{
				TweenMax.killTweensOf(holder);
			}
			
		}
		
		override public function onRemove():void
		{
			
//			SoundAS.removeSound("waterflow");
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'waterflow');
			
			keepUPAndDown = false;
			swimwater.dispose();
			waterSpray.dispose();
			
			texture.dispose();
			view.removeChildren(0,-1,true);
			view.dispose();
		}
		
		private var  boolean:Boolean;
		
		public function goX(_x:int,_time:Number=NaN):void{
			
			TweenMax.killTweensOf(view);
			
			var time:Number;
			if(_time!=_time){
				time = Math.abs(view.x-_x)*0.001;
			}else{
				time = _time;
				
			}
			
			
			swimwater.removeAnimation();
			swimwater.start(time);
			if(_x<view.x){
				holder.scaleX = -1;
			}else{
				holder.scaleX = 1;
				
			}
			
			TweenMax.to(view,time,{x:_x});
		
			if(boolean){
				
//				SoundAS.play("waterflow",0.7);
				sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("waterflow",0.7));

			}
			
			boolean = true;
		}
		
		public function goY(_y:int):void{
			
			
		}
		
		public function move(_x:int,_y:int):void{
			view.x = _x;
			view.y = _y;
		}
		
		
		public function centerPivot(obj:DisplayObject):void
		{
			obj.pivotX=obj.width / 2;
			obj.pivotY=obj.height / 2;
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
	}
}