package com.studyMate.world.screens.component
{
	import flash.geom.Rectangle;
	
	import soulwire.ai.Boid;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import com.mylib.game.charater.logic.AbstractBoidMediator;

	public class ButterflyMediator extends AbstractBoidMediator
	{
		private var butterflyAssets:Vector.<Texture>;
		
		
		public function ButterflyMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRegister():void
		{
			
			
			_config = {
				minForce:1,
				maxForce:3,
				minSpeed:1,
				maxSpeed:3,
				minWanderDistance:100.0,
				maxWanderDistance:300.0,
				minWanderRadius:100.0,
				maxWanderRadius:300.0,
				minWanderStep:0.1,
				maxWanderStep:0.9,
				boundsRadius:300,
				numBoids:120,
				bounds:new Rectangle(-600,-200,2000,500)
			};
			
			butterflyAssets = Assets.getAtlas().getTextures("animal/butterfly1");
			createBoids(3);
			
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			for each (var i:Texture in butterflyAssets) 
			{
				i.dispose();
			}
			
		}
		
		
		override protected function updateBoid(boid:Boid, index:int, time:Number):void
		{
			(boid.renderData as MovieClip).advanceTime(time);
			// Add some wander to keep things interesting
			boid.wander(0.3);
//			boid.seek(boid.boundsCentre, 0.1);
			boid.flock(_boids);
			
			boid.update();
			boid.render();
		}
		
		
		
		override protected function createBoid():Boid
		{
			var boid : Boid = new Boid();
			
			setProperties(boid);
			
			var butterfly:MovieClip = new MovieClip(butterflyAssets);
			
			butterfly.pivotX = butterfly.width>>1;
			butterfly.pivotY = butterfly.height>>1;
			
			boid.renderData = butterfly;
			
			boid.edgeBehavior = Boid.EDGE_BOUNCE;
			
			_boids.push(boid);
			view.addChild(boid.renderData);
			boid.renderCompleteHandle = renderHandle;
			return boid;
		}
		
		
		private function renderHandle(boid:Boid):void{
			
			if(boid.oldPosition.x>boid.position.x&&boid.renderData.scaleX!=-1){
				boid.renderData.scaleX=-1;
			}else if(boid.oldPosition.x<boid.position.x&&boid.renderData.scaleX!=1){
				boid.renderData.scaleX=1;
			}
			
		}
		
		
	}
}