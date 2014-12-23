package com.mylib.game.runner
{
	import com.greensock.TweenLite;
	import com.studyMate.world.screens.effects.PaperEff;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ItemManager extends Mediator
	{
		public static const NAME:String = "ItemManager";
		private var _viewport:Rectangle;
		
		private var bucketPool:ObjectPool;
		private var bucket2Pool:ObjectPool;
		private var bucket3Pool:ObjectPool;
		private var poolPool:ObjectPool;
		private var deadTreePool:ObjectPool;
		private var deadTree2Pool:ObjectPool;
		private var rockPool:ObjectPool;
		
		private var pools:Dictionary;
		
		
		
		private var preItemX:int;
		
		public var items:Vector.<Item>;
		private var nextSpace:int;
		private var data:Vector.<Number>;
		private var current:int;
		private var levelDis:int;
		
		public function ItemManager(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			bucketPool = new ObjectPool(true);
			bucketPool.allocate(10,Bucket);
			
			bucket2Pool = new ObjectPool(true);
			bucket2Pool.allocate(10,Bucket2);
			
			bucket3Pool = new ObjectPool(true);
			bucket3Pool.allocate(10,Bucket3);
			
			poolPool = new ObjectPool(true);
			poolPool.allocate(10,Pool);
			
			deadTreePool = new ObjectPool(true);
			deadTreePool.allocate(10,DeadTree);
			
			deadTree2Pool = new ObjectPool(true);
			deadTree2Pool.allocate(10,DeadTree2);
			
			rockPool = new ObjectPool(true);
			rockPool.allocate(10,Rock);
			
			pools = new Dictionary();
			pools[MapItemType.BUCKET] = bucketPool;
			pools[MapItemType.BUCKET2] = bucket2Pool;
			pools[MapItemType.BUCKET3] = bucket3Pool;
			pools[MapItemType.POOL] = poolPool;
			pools[MapItemType.DEAD_TREE] = deadTreePool;
			pools[MapItemType.DEAD_TREE2] = deadTree2Pool;
			pools[MapItemType.ROCK] = rockPool;
			
			
			
			items = new Vector.<Item>;
			nextSpace = 500;
			
			eff = new PaperEff;
			eff.y = -500;
		}
		
		private var eff:PaperEff;
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			eff.dispose();
			
			recycleAll();
			
			
			for each (var i:ObjectPool in pools) 
			{
				i.initialze("dispose",null);
				i.deconstruct();
			}
			
			
			
		}
		
		private function disposeImg():void{
			
			
			
		}
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		private function recycle(item:Item):void{
			item.removeFromParent();
			pools[item.type].object = item;
		}
		
		public function recycleAll():void{
			for (var i:int = 0; i < items.length; i++) 
			{
				
				recycle(items[i]);
			}
			
			items.length = 0;
			nextSpace = 500;
			preItemX = 0;
			current = 0;
		}
		
		private function stopEff():void{
			eff.clear();
			eff.stop();
			eff.removeFromParent();
		}
		
		public function show(viewport:Rectangle):void{
			
			_viewport = viewport;
			if(!data||current>=data.length){
				return;
			}
			
			while(data[current]<viewport.x&&data[current]!=MapItemType.LEVEL){
				current+=2;
				if(current>=data.length){
					return;
				}
			}
			
			if(viewport.right>data[current]){
				
				if(data[current]==MapItemType.LEVEL){
					levelDis = viewport.right+1000;
					eff.x = viewport.right+1000;
					eff.clear();
					eff.start();
					view.addChild(eff);
					sendNotification(RunnerGameConst.LEVEL_UP,data[current+1]);
					sendNotification(RunnerGameConst.PICK_RECORD);
				}else if(data[current+1]<MapItemType.SPEEDUP){
					
					if(eff.parent&&levelDis+2200<viewport.right){
						stopEff();
					}
					
					
					if(pools[data[current+1]]){
						preItemX = data[current];
						var o:Item = pools[data[current+1]].object;
						items.push(o);
						(o as DisplayObject).x = data[current];
						(o as DisplayObject).y = 100;
						view.addChild(o);
						
					}
				}else if(data[current+1]==MapItemType.LEVEL_END){
				
				}else if(data[current+1]>=MapItemType.ACCUP){
					sendNotification(RunnerGameConst.SET_ACC,data[current+1]-MapItemType.ACCUP);
				}else if(data[current+1]>MapItemType.SPEEDUP){
					
					sendNotification(RunnerGameConst.SET_SPEED,data[current+1]-MapItemType.SPEEDUP);
					
				}
				
				current+=2;
				
			}
			
			if(items.length&&items[0].x<viewport.x-items[0].width){
				var dispItem:Item = items.shift();
				recycle(dispItem);
			}
			
			
		}
		
		public function setItems(_data:Vector.<Number>):void{
			data = _data;
		}
		
		
		
	}
}