package com.mylib.game.house
{
	import com.mylib.framework.CoreConst;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PixelHitArea;
	import starling.extensions.PixelImageTouch;
	import starling.textures.Texture;
	
	public class SysHouseMediator extends Mediator implements IMediator, ISysHouse
	{
		public static const CLICK_HOUSE:String = NAME + "clickHouse";
		
		private var _houseInfo:HouseInfoVO;
		
		private var _house:House;
		
		private var _hitArea:PixelHitArea;
		
		private var _taskNum:int;
		
		private var texture:Texture;
		private var houseImg:PixelImageTouch;
		
		public function SysHouseMediator(houseVoInfo:HouseInfoVO, hitarea:PixelHitArea, tasknum:int=0, viewComponent:Object=null)
		{
			houseInfo = houseVoInfo;
			
			hitArea = hitarea;
			
			taskNum = tasknum;
			
			
			super(houseVoInfo.data, viewComponent);

		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			initSysHouse();
		}
		
		
		
		public function initSysHouse():void{
			var isTask:Boolean;
			
			if(taskNum == 0)
				isTask = false;
			else
				isTask = true;
			
			texture = Assets.getHapIslandHouseTexture(houseInfo.data);
			houseImg = new PixelImageTouch(texture,hitArea);
			
			
			_house  = new House(houseInfo.data,houseImg,houseInfo.x,houseInfo.y,isTask,taskNum.toString());
			
			
			
		}
		
		public function get view():Sprite{
			return _house;
			
		}
		
		public function set touchable(val:Boolean):void{
			if(val){
				if(_house)
					_house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);
			}else{
				if(_house)
					_house.removeEventListener(TouchEvent.TOUCH,houseTouchHandle);
			}
			
		}
		
		private var beginX:Number;
		private var endX:Number;
		private function houseTouchHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						
						Facade.getInstance(CoreConst.CORE).sendNotification(CLICK_HOUSE,this);
						
					}
				}
			}
		}
		
		
		public function set houseInfo(houseInfo:HouseInfoVO):void
		{
			_houseInfo = houseInfo;
		}
		
		public function get houseInfo():HouseInfoVO
		{
			return _houseInfo;
		}
		
		public function set hitArea(hitArea:PixelHitArea):void{
			_hitArea = hitArea;
			
		}
		public function get hitArea():PixelHitArea{
			
			return _hitArea;
		}
		
		
		
		public function set taskNum(value:int):void{
			_taskNum = value;
			
		}
		public function get taskNum():int{
			return _taskNum;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			texture.dispose();
			houseImg.dispose();
			
			view.dispose();
		}
	}
}