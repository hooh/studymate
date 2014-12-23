package com.mylib.game.runner
{
	import com.greensock.TweenLite;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class RunnerCloudProxy extends Proxy implements IProxy
	{
		public static const NAME :String = "RunnerCloudProxy";
		
		private var clouds:Array = [];
		private var ranlist:Array = [];
		
		public function RunnerCloudProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			initClouds();
		}
		
		private var _holder:Sprite;
		public function set holder(val:Sprite):void{
			_holder = val;
		}
		
		public function get holder():Sprite{
			return _holder;
		}
		
		
		
		//初始化对象
		private function initClouds():void{
			
			var _cloud:RunnerCloud;
			for (var i:int = 1; i < 13; i++) 
			{
				var s:int = i/3;
				var r:int = i%3;
				
				if(r == 0){
					_cloud = new RunnerCloud(Assets.getRunnerGameTexture("cloud3"));
					_cloud.speed = s+5;
					
					
					
				}else{
					_cloud = new RunnerCloud(Assets.getRunnerGameTexture("cloud"+r));
					_cloud.speed = s+6;
					
					
				}
				_cloud.touchable = false;
				_cloud.name = i.toString();
				clouds.push(_cloud);
				
				
			}
			
			
			
		}
		
		
		public function start():void{
			
			getCloud();
			
		}
		
		public function end():void{
			TweenLite.killDelayedCallsTo(getCloud);
			for (var i:int = 0; i < clouds.length; i++) 
			{
				TweenLite.killTweensOf(clouds[i]);
				(clouds[i] as RunnerCloud).removeFromParent();
			}
			ranlist = [];
		}
		
		public function restart():void{
			
			end();
			start();
		}
		
		
		private function getCloud():void{
			TweenLite.killDelayedCallsTo(getCloud);
			
			var delay:Number;
			var getIdx:int = getRandomIdx();
			
			if(getIdx == -1)
			{
				delay = Math.random()*0.7+0.3;
				TweenLite.delayedCall(delay,getCloud);
				return;
			}
			
			var cloud:RunnerCloud = clouds[getIdx] as RunnerCloud;
			cloud.x = 1480;
			cloud.y = Math.random()*200+10;
			holder.addChild(cloud);
			TweenLite.to(cloud,cloud.speed,{x:-500, onComplete:moveCompleteHandle, onCompleteParams: [cloud]});
			
			delay = Math.random()*0.7+0.3;
			TweenLite.delayedCall(delay,getCloud);
			
		}
		
		private function getRandomIdx():int{
			
			var getIdx:int = Math.random()*11;
			if(ranlist.indexOf(getIdx) > -1)
			{
				//有，则重新选
				for (var i:int = 0; i < 12; i++) 
				{
					if(ranlist.indexOf(i) == -1)
					{
						ranlist.push(i);
						return i;
					}
				}
				return -1;
			}
			
			ranlist.push(getIdx);
			return getIdx;
		}
		
		
		private function moveCompleteHandle(_cloud:RunnerCloud):void{
			
			if(_cloud)
			{
				_cloud.removeFromParent();
				
				
				var i:int = ranlist.indexOf((int(_cloud.name)-1));
				if(i > -1)
				{
					ranlist.splice(i,1);
				}
			}
			
			
		}
		
		
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			end();
		}
		
		
		
	}
}