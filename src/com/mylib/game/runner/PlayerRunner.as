package com.mylib.game.runner
{
	import flash.media.Sound;
	
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import stateMachine.StateMachineEvent;

	public class PlayerRunner extends Runner
	{
		private var frontItem:Item;
		private var itemManger:ItemManager;
		public var recorder:RunnerRecorder;
		private var jumpCount:int;
		public var jumpSound:Sound;
		
		private var dust:MovieClip;
		private var dustTextures:Vector.<Texture>;
		
		public function PlayerRunner(name:String)
		{
			super(name);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			itemManger = facade.retrieveMediator(ItemManager.NAME) as ItemManager;
			
			dustTextures = Assets.getRunnerGameAtlas().getTextures("dust");
			dust = new MovieClip(dustTextures,12);
			RunnerGlobal.juggler.add(dust);
			dust.addEventListener(Event.COMPLETE,dustHandle);
			dust.loop = false;
		}
		
		private function dustHandle():void
		{
			// TODO Auto Generated method stub
			dust.removeFromParent();
		}		
		
		override public function dispose():void
		{
			if(jumpSound){//否则sound移除不掉
				try{
					jumpSound.close();					
				}catch(e:Error){
					trace('close error playerRunner');
				}
				jumpSound=null;
			}
			stop();//否则内存无法移除
			super.dispose();
			RunnerGlobal.juggler.remove(dust);
			dust.dispose();
			for (var i:int = 0; i < dustTextures.length; i++) 
			{
				dustTextures[i].dispose();
			}
			
			dustTextures.length = 0;
			
			
		}
		
		
		override protected function updateFrame():void
		{
			position += _velocity.x;
			
			if(!frontItem||frontItem.bounds.right<view.x){
				var len:int = itemManger.items.length;
				for (var i:int = 0; i < len; i++) 
				{
					if(itemManger.items[i].x>view.x){
						frontItem = itemManger.items[i];
						break;
					}
				}
			}
			
			if(acc){
				position+=acc;
			}
			
			
			if(frontItem&&frontItem.x<view.x&&view.x<frontItem.bounds.right&&view.y>frontItem.bounds.top+frontItem.offsetTop+10){
				
				_fsm.changeState(END);
				
				
			}
			
			
		}
		
		override public function reset():void
		{
			super.reset();
			frontItem = null;
		}
		
		
		override protected function enterEnd(event:StateMachineEvent):void
		{
			// TODO Auto Generated method stub
			super.enterEnd(event);
			facade.sendNotification(RunnerGameConst.GAME_END);
			recorder.die(view.x);
		}
		
		override protected function enterJump(event:StateMachineEvent):void
		{
			// TODO Auto Generated method stub
			super.enterJump(event);
			recorder.jump(view.x);
			jumpCount++;
			
			if(jumpCount==1){
				dust.currentFrame = 0;
				dust.x = view.x-140;
				dust.y = view.y-120;
				view.parent.addChildAt(dust,view.parent.getChildIndex(view));
				dust.play();
			}
			
			
		}
		
		override protected function enterRun(event:StateMachineEvent):void
		{
			// TODO Auto Generated method stub
			super.enterRun(event);
			jumpCount = 0;
		}
		
		
		public function jump():void{
			if(jumpCount<2){
				jumpSound.play();
				_fsm.changeState(EMPTY);
				_fsm.changeState(JUMP);
			}
		}
		
		
	}
}