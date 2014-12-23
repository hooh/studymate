package com.mylib.game.house
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.world.screens.GardenIslandMediator;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.extensions.PixelHitArea;

	public class IslandNpcHouseMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "IslandNpcHouseMediator";
		
		private var newHouse:NpcHouseMediator;
		private var npcHouseMdiator:Vector.<NpcHouseMediator>

		private var hitArea:PixelHitArea;
		private var _houseList:Vector.<HouseInfoVO>;
		
		public function IslandNpcHouseMediator(viewComponent:Object,_hitArea:PixelHitArea,houselist:Vector.<HouseInfoVO>)
		{
			super(NAME, viewComponent);
			
			hitArea = _hitArea;
			
			_houseList = houselist.concat();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.ADD_ISLAND_HOUSE:
					var houseVo:HouseInfoVO = new HouseInfoVO();
					houseVo = notification.getBody() as HouseInfoVO;
					
					/*houseVo.x = 160+view.numChildren*320;*/
					houseVo.x = view.numChildren*320;


					newHouse = new NpcHouseMediator(houseVo,hitArea);
					facade.registerMediator(newHouse);
					npcHouseMdiator.push(newHouse);
					view.addChild(newHouse.view);
					
					(facade.retrieveMediator(GardenIslandMediator.NAME) as GardenIslandMediator).houseList.push(houseVo);

					TweenLite.killTweensOf(newHouse.view);
					TweenLite.from(newHouse.view,0.3,{y:-newHouse.view.height,ease:Linear.easeNone});
					TweenMax.to(newHouse.view,0.1,{delay:0.3,scaleY:1,yoyo:true,repeat:2,ease:Linear.easeNone});
					
					(facade.retrieveMediator(GardenIslandMediator.NAME) as GardenIslandMediator).setHSRange(true);
					
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.ADD_ISLAND_HOUSE];
		}
		
		override public function onRegister():void
		{
			npcHouseMdiator = new Vector.<NpcHouseMediator>;
			
			initHouse();
		}
		
		
		private function initHouse():void{
			var len:int = houseList.length;

			for(var i:int=0; i<len; i++){
				
				var npcHouse:NpcHouseMediator = new NpcHouseMediator(houseList[i],hitArea);
				facade.registerMediator(npcHouse);
				npcHouseMdiator.push(npcHouse);

				npcHouse.touchable = true;
				view.addChild(npcHouse.view);
			}
		}
		
		public function get houseList():Vector.<HouseInfoVO>{
			
			
			return _houseList;
			
		}

		override public function get viewClass():Class
		{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			for(var i:int=0 ; i<npcHouseMdiator.length; i++)
				facade.removeMediator(npcHouseMdiator[i].getMediatorName());
			if(newHouse)
				TweenLite.killTweensOf(newHouse.view);
		}
	}
}