package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.controller.vo.ZoomResultVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.component.LineItemSprite;
	import com.studyMate.world.model.vo.CoordinateMediatorVO;
	import com.studyMate.world.model.vo.StandardItemsVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class WorldMapCoordinateMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "WorldMapCoordinateMediator";
		public static const INIT_COORDINATEVO:String = "InitCoordinateVo";
		
		public static const SHOW_LINES:String = "ShowLines";
		
		public static const UPDATE_MYMARK:String = "UpdateMyMark";
		public static const UPDATE_GOALMARK:String = "UpdateGoalMark";
		
		private var standardFile:File = Global.document.resolvePath(Global.localPath+"standard.txt");
		private var stream:FileStream = new FileStream();
		
		private var standItemVoList:Vector.<StandardItemsVO> = new Vector.<StandardItemsVO>;
		private var LineItemSpList:Vector.<LineItemSprite> = new Vector.<LineItemSprite>;
		private var ItemBgList:Vector.<Image> = new Vector.<Image>;
		private var ItemGradeList:Vector.<Image> = new Vector.<Image>;
		private var itemSp:Sprite;
		private var itemBgSp:Sprite;
		private var itemBgTexture:Texture;
		
		private var _center:int;
		
		private var _maxNumber:Number;
		private var range:Rectangle = new Rectangle(0,0,1280,0);
		
		private var halfWidth:int;
		private var halfHeight:int;
		private var local:Point;
		private var edge:Rectangle;
		private var tvo:TransformVO;
		
		private var prepareVO:SwitchScreenVO;
		
		
		public var style:ICoordinateStyle;
		
		private var myMark:int;
		private var myGrade:int;
		
		private var myZone:Image;
		private var currentLevel:int;

		
		public function WorldMapCoordinateMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		public function get center():int
		{
			return _center;
		}
		public function set center(value:int):void
		{
			_center = value;
		}
		
		public function get maxNumber():Number
		{
			return _maxNumber;
		}
		public function set maxNumber(value:Number):void{
			_maxNumber = value;
		}
		

		override public function prepare(vo:SwitchScreenVO):void
		{
			
			tvo = vo.data as TransformVO;
			prepareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.HIDE_SETTING_SCREEN :
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
				case INIT_COORDINATEVO:
					var coordVo:CoordinateMediatorVO = notification.getBody() as CoordinateMediatorVO;
					style = coordVo.style;
					standItemVoList = coordVo.standItemVoList;
					maxNumber = coordVo.maxNumber;
					
					break;
				case SHOW_LINES:
					currentLevel = notification.getBody() as int;
					
					addChildLines();
					showLine(currentLevel);
					break;
				case WorldConst.UPDATE_CAMERA:
				{
					
					local = notification.getBody() as Point;
					if(local){//可能是null
						
						setCentreX(local.x/tvo.scale);
					}
					
					break;
				}
				case WorldConst.UPDATE_SCALE:{
					
					var zoomResult:ZoomResultVO = notification.getBody() as ZoomResultVO;
					
					doScale();
					setCentreX(local.x/tvo.scale);
					
					break;
				}
				case UPDATE_MYMARK:
					myMark = notification.getBody() as int;
					
					updateBoatLocal(myMark);
					
					break;
				case UPDATE_GOALMARK:
					updateGoalLocal( notification.getBody() as int);
					break;
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA,WorldConst.UPDATE_SCALE,INIT_COORDINATEVO,SHOW_LINES,UPDATE_MYMARK,UPDATE_GOALMARK
					,WorldConst.HIDE_SETTING_SCREEN];
		}
		
		override public function onRegister():void
		{
			halfWidth = WorldConst.stageWidth>>1;
			halfHeight = WorldConst.stageHeight>>1;

			
			local = tvo.location;
			edge = tvo.range;
			
			itemBgSp = new Sprite;
			view.addChild(itemBgSp);
			
			itemSp = new Sprite;
			view.addChild(itemSp);
			
			
			itemBgTexture = Assets.getWorldMapTexture("line_Grade_Bg");
		}
		
		//计算点数所对应的像素点
		private function pointToPix(_num:int,_center:int=0,_scale:Number=1):int{
			return range.width*_scale/(maxNumber*1.1)*_num+_center*_scale-halfWidth*(_scale-1);
		}
		
		//更新船的位置
		private function updateBoatLocal(_mark:int):void{
			sendNotification(WorldMapMediator.UPDATE_MYLOCAL,markToLocal(_mark));
		}
		private function updateGoalLocal(_mark:int):void{
			sendNotification(WorldMapMediator.UPDATE_GOALLOCAL,markToLocal(_mark));
		}
		//根据分数计算坐标
		private function markToLocal(_mark:int):int{
			var markX:int = 0;
			
			var firNum:int;
			var senNum:int;
			var firX:int;
			var senX:int;
			
			var len:int = LineItemSpList.length;
			for(var i:int=0;i<len;i++){
				
				if(int(LineItemSpList[i].standItemVo.level) == currentLevel){
					//刚好等于标准分数
					if(LineItemSpList[i].standItemVo.standData == _mark.toString()){

						markX = pointToPix(int(LineItemSpList[i].standItemVo.name));
						break;
					}else if(int(LineItemSpList[i].standItemVo.standData) > _mark){
						//非第一条线
						if(i > 2){
							//小于当前标准，并且大于上一标准
							if(int(LineItemSpList[i-3].standItemVo.standData) < _mark){
								firNum = int(LineItemSpList[i-3].standItemVo.standData);
								senNum = int(LineItemSpList[i].standItemVo.standData);
								
								firX = pointToPix(int(LineItemSpList[i-3].standItemVo.name));
								senX = pointToPix(int(LineItemSpList[i].standItemVo.name));
								
							}
						}else{
							//第一条线
							firNum = 0;
							senNum = int(LineItemSpList[i].standItemVo.standData);

							firX = 0;
							senX = pointToPix(int(LineItemSpList[i].standItemVo.name));
						}
						
						
						var perNumToPix:Number = (senX - firX)/(senNum - firNum);
						
						markX = firX + (_mark-firNum)*perNumToPix;
						break;
						
					}
					
					//超过最后一条线
					if(int(LineItemSpList[i].standItemVo.name) == maxNumber){
						if(int(LineItemSpList[i].standItemVo.standData) < _mark){
							markX = pointToPix(int(LineItemSpList[i].standItemVo.name))+100;
							
							break;
							
						}
					}
				}
			}
			return markX;
		}
		
		//初始化坐标线条
		private function addChildLines():void{
			itemSp.removeChildren(0,-1,true);
			itemBgSp.removeChildren(0,-1,true);
			LineItemSpList.splice(0,LineItemSpList.length);
			ItemBgList.splice(0,ItemBgList.length);
			ItemGradeList.splice(0,ItemGradeList.length);
			
			var len:int = standItemVoList.length;
			
			var lineItemSp:LineItemSprite;
			
			var j:int=1;
			for(var i:int=0;i<len;i++){
				lineItemSp = style.getLevelDisplay(standItemVoList[i]);
				
				itemSp.addChild(lineItemSp);
				
				LineItemSpList.push(lineItemSp);

			}
		}
		
		//显示、刷新坐标线
		private function showLine(_level:int):void{
			currentLevel = _level;
			
			var len:int = LineItemSpList.length;
			
			var gap:Number=0;
			for(var i:int=0;i<len;i++){
				LineItemSpList[i].visible = false;
				var lineName:int = int(LineItemSpList[i].standItemVo.name);
				var lineLvl:int = int(LineItemSpList[i].standItemVo.level);
				
				if(lineLvl == _level){
					
					LineItemSpList[i].x = this.pointToPix(lineName,center,tvo.scale);
					
					if(LineItemSpList[i].x >= 0 &&LineItemSpList[i].x <= 1280)
						LineItemSpList[i].visible = true;

					if(lineName!= 0&& lineName%2 == 0){
						LineItemSpList[i].itembg.x = LineItemSpList[i-3].x - LineItemSpList[i].x;
						
						LineItemSpList[i].itembg.scaleX = LineItemSpList[i].x - LineItemSpList[i-3].x;
						LineItemSpList[i].itembg.scaleY = 762;
						
						
						
					}
					if(i >= 3){
						LineItemSpList[i].itemGrade.x = -((LineItemSpList[i].x - LineItemSpList[i-3].x + LineItemSpList[i].itemGrade.width)>>1);
					}else
						LineItemSpList[i].itemGrade.x = -75;
					
					/*if(LineItemSpList[i].itemmybg){
						LineItemSpList[i].itemmybg.x = LineItemSpList[i-3].x - LineItemSpList[i].x;
						
						LineItemSpList[i].itemmybg.scaleX = LineItemSpList[i].x - LineItemSpList[i-3].x;
						LineItemSpList[i].itemmybg.scaleY = 762;
					}*/
					
					
					

				}
			}
			
		}
		
		public function doScale():void{
			
			
			showLine(currentLevel);
		}
		
		
		public function setCentreX(_x:Number):void{
			
			center = _x;
			
			showLine(currentLevel);

			
		}
		
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		
	}
}