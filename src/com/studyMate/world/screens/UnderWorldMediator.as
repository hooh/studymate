package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.GameCharaterData;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.underWorld.api.UnderWorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class UnderWorldMediator extends ScreenBaseMediator
	{
		
		public var viewSp:Sprite;
		public var gameHolder:Sprite;
		
		public function UnderWorldMediator(viewComponent:Object=null)
		{
			super(ModuleConst.UNDER_WORLD, viewComponent);
			
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case UnderWorldConst.ADD_HERO:
					var gamedata:Vector.<GameCharaterData> = notification.getBody() as Vector.<GameCharaterData>;
					addHero(gamedata);
					break;
				case UnderWorldConst.ADD_MONSTER:
					
					var gamedata1:Vector.<GameCharaterData> = notification.getBody() as Vector.<GameCharaterData>;
					
					addMonster(gamedata1);
					
					
					break;
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [UnderWorldConst.ADD_HERO,UnderWorldConst.ADD_MONSTER];
		}
		
		
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
			
			viewSp = new Sprite();
			viewSp.y = 1550;
			
			view.addChild(viewSp);

			
			
			gameHolder = new Sprite();
			gameHolder.y = 1570;
			view.addChild(gameHolder);
			
			
			initFloor();
			
			initBasements();
		}
		private function initFloor():void{
			
			
			var img:Image;
			var perImg:Image;
			
			
			
			for(var i:int=1;i<6;i++){
				
				
				img = new Image(Assets.getUnderWorldTexture("underWorld_lvl"+i.toString()+"bg"));
				
				if(perImg)
					img.y = perImg.y+perImg.height-3;
				else
					img.y = 150;
				
				perImg = img;
				
				viewSp.addChild(img);
				
			}
			perImg = null;
			
			img = new Image(Assets.getUnderWorldTexture("underWorld_lvl0bg"));
			img.y = 25;
			viewSp.addChild(img);
			
		}
		
		private var baseList:Vector.<BasementMediator> = new Vector.<BasementMediator>;
		private function initBasements():void{
			var basement:BasementMediator;
			
			for(var i:int=0;i<9;i++){
				
				basement = new BasementMediator(i.toString());
				facade.registerMediator(basement);
				
				basement.view.x = (int(i%3))*350;
				basement.view.y = (int(i/3)+1)*250;
				
				
				gameHolder.addChild(basement.view);
				
				
				baseList.push(basement);
				
				
			}
		}
		
		private function addHero(_gamedata:Vector.<GameCharaterData>):void{
			
			for(var i:int=0;i<baseList.length;i++){
				for(var j:int=0;j<_gamedata.length;j++){
					
					baseList[i].addHero(_gamedata[j].clone());
					
				}
				
				
			}
			
		}
		
		private function addMonster(_gamedata:Vector.<GameCharaterData>):void{
			for(var i:int=0;i<baseList.length;i++){
				for(var j:int=0;j<_gamedata.length;j++){
					
					baseList[i].addMonster(_gamedata[j].clone());
					
				}
				
				
			}
			
			
		}
		
		
		
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			for(var i:int=0;i<baseList.length;i++){
	
				baseList[i].reset();
				
				facade.removeMediator(baseList[i].getMediatorName());
			}
			
			viewSp.removeChildren(0,-1,true);
			gameHolder.removeChildren(0,-1,true);
		}
		
	}
}