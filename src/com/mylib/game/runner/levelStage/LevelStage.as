package com.mylib.game.runner.levelStage
{
	import com.greensock.TweenLite;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.IslandersManagerMediator;
	import com.mylib.game.charater.logic.ai.IslanderAI;
	import com.mylib.game.charater.logic.vo.JoinIslandVO;
	import com.mylib.game.model.CharaterSuitsInfoProxy;
	import com.mylib.game.model.HumanPoolProxy;
	import com.mylib.game.model.IslanderPoolProxy;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.CharaterInfoMediator;
	import com.studyMate.world.screens.component.WordCard;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class LevelStage extends Sprite
	{
		
		private var itemData:Vector.<Array>;
		
		private static const items:Array = ["house1","house2","house3","house4","house5","house6","house7","house8","house9","house10",
			"house11","house12","house13","house14","house15"];
		
		private var images:Array;
		
		
		private var houseHolder:Sprite = new Sprite;
		
		private var npcList:Array = [];
		
		public function LevelStage()
		{
			super();
			
			images = [];
			
			for (var i:int = 0; i < items.length; i++) 
			{
				var img:Image = new Image(Assets.getRunnerGameTexture(items[i]));
				img.pivotY = img.height;
				img.pivotX = int(img.height*0.5);
				images.push(img);
			}
			
			addChild(houseHolder);
		}
		
		
		private function randomArr(arr:Array):Array
		{
			var outputArr:Array = arr.slice();
			var i:int = outputArr.length;
			while (i)
			{
				outputArr.push(outputArr.splice(int(Math.random() * i--), 1)[0]);
			}
			return outputArr;
		}
		
		
		public function refresh():void{
			
			var num:int = Math.random()*6+5;
			
			var currentIdx:int;
			randomArr(images);
			for (var i:int = 0; i < num; i++) 
			{
				var img:Image = images[i];
				
				currentIdx+=int(Math.random()*100);
				img.x = currentIdx;
				houseHolder.addChild(img);
				currentIdx+=img.pivotX;
				
				
			}
			
			
			
			
			if(npcList.length == 0)
			{
				createNpc();
			}
			
			for (var j:int = 0; j < npcList.length; j++) 
			{
				/*trace((npcList[j] as IslanderControllerMediator).charater.charaterName+ "==" + 
					(npcList[j] as IslanderControllerMediator).charater.view.x+"||"+
					(npcList[j] as IslanderControllerMediator).charater.view.y+"||"+
					(npcList[j] as IslanderControllerMediator).charater.view.visible+"||"+
					(npcList[j] as IslanderControllerMediator).charater.view.alpha);*/
				var dress:String = getRandomDress();
				
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).
					configHumanFromDressList((npcList[j] as IslanderControllerMediator).charater,dress,null);
			}
			
			
		}
		
		protected function createNpc():void{
			var controller:IslanderControllerMediator;

			var currentIdx:int;
			for (var i:int = 0; i < 3; i++) 
			{
				controller = (Facade.getInstance(CoreConst.CORE).retrieveProxy(IslanderPoolProxy.NAME) as IslanderPoolProxy).object;
				controller.charater.charaterName = "standNPC"+i;
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).
					configHumanFromDressList(controller.charater,"face_face1",null);
				
				addChild(controller.charater.view);
				
				
				
				var x:Number = Math.random()*1000;
				var y:Number = Math.random()*10;
				
				currentIdx+=int(Math.random()*100);
				x = currentIdx;
				currentIdx+=controller.charater.view.width;
				controller.setTo(x, y);
				
				npcList.push(controller);
			}
			
		}
		
		
		private function getRandomDress():String{
			
			var npcsuitProxy:CharaterSuitsInfoProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(CharaterSuitsInfoProxy.NAME) as CharaterSuitsInfoProxy;
			
			var npclist:Array = npcsuitProxy.getNpcList().concat();
			var npc:String = npclist[int(Math.random()*npclist.length)];
			
			return npcsuitProxy.getDress(npc);
			
			
		}
		
		
		
		
		private function recoverNPC():void{
			for(var i:int = 0; i < npcList.length; i++)
			{
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(IslanderPoolProxy.NAME) as IslanderPoolProxy).object = npcList[i];
			}
			
			npcList = [];
			
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
			
			recoverNPC();
			
			for (var i:int = 0; i < images.length; i++) 
			{
				(images[i] as Image).removeFromParent(true);
			}
			
			
			
		}
		
		
		
		
		
	}
}