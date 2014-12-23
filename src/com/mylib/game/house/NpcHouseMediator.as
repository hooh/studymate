package com.mylib.game.house
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.card.GameCharaterData;
	import com.studyMate.global.Global;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.GardenIslandMediator;
	import com.studyMate.world.screens.IslandsMapMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.ProgressBar;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PixelHitArea;
	import starling.extensions.PixelImageTouch;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class NpcHouseMediator extends Mediator implements IMediator, INpcHouse
	{
		public static var idx:int;
		
		private var _houseInfo:HouseInfoVO;
		
		private var _house:House;
		
		private var _hitArea:PixelHitArea;
		
		private var texture:Texture;
		private var houseImg:PixelImageTouch;
		
		public function NpcHouseMediator(houseVoInfo:HouseInfoVO, hitarea:PixelHitArea, viewComponent:Object=null)
		{
			
			houseInfo = houseVoInfo;
			
			hitArea = hitarea;
			
			
			
			super(houseVoInfo.data + idx, viewComponent);
			
			idx++;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			initNpcHouse();
		}
		
		
		
		private function initNpcHouse():void{
			
			texture = Assets.getHapIslandHouseTexture(houseInfo.data);
			houseImg = new PixelImageTouch(texture,hitArea);
			
			
			_house  = new House(houseInfo.data,houseImg,houseInfo.x,houseInfo.y,false,"");
			
			view.addEventListener(Event.ADDED_TO_STAGE, onStage);
			
		}
		
		
		private var proValue:Vector.<Number>;
		private var proBar:ProgressBar;
		private var proTF:TextField;
		private var hammer:Image;
		private var buildSp:Sprite;
		private function onStage(e:Event):void
		{
			var nowTime:Number = int(Global.nowDate.getTime()/1000);
			var min:Number;
			var max:Number;
			//刚买的房子
			if(houseInfo.buildTime != -1){
				min = nowTime;
				
				max = min+houseInfo.buildTime;
				
				houseInfo.buildTime = -1;
				houseInfo.createTime = min;
				houseInfo.finishTime = max;
			}else if(nowTime < houseInfo.finishTime){
				//未完成修建
				min = houseInfo.createTime;
				max = houseInfo.finishTime;
			}else if(nowTime >= houseInfo.finishTime){
				
				return;
				
			}
			
			
			buildSp = new Sprite();
			view.addChild(buildSp);
			
			proBar = new ProgressBar();
			proBar.minimum = min;
			proBar.maximum = max;
			proBar.value = nowTime;
			proBar.width = 180;
			buildSp.addChild(proBar);
			proBar.x = (view.width-proBar.width)>>1;
			proBar.y = -50;
			
			
			
			//progressBar换肤
			var bgTexture:Scale9Textures = new Scale9Textures(Assets.getAtlasTexture("item/progressBg"),new Rectangle(3,3,745,10));
			var fillTexture:Scale9Textures = new Scale9Textures(Assets.getAtlasTexture("item/progressFill"),new Rectangle(4,3,1,10));
			var backgroundSkin:Scale9Image = new Scale9Image(bgTexture);
			backgroundSkin.width = 180;
			proBar.backgroundSkin = backgroundSkin;
			var fillSkin:Scale9Image = new Scale9Image(fillTexture);
			fillSkin.width = 9;
			proBar.fillSkin = fillSkin;
			
			
			
			//进度文本显示
			proTF = new TextField(180,15,"","HeiTi",13);
			proTF.vAlign = VAlign.CENTER;
			proTF.hAlign = HAlign.CENTER;
			proBar.addChild(proTF);
			
			proValue = Vector.<Number>([nowTime]);
			TweenLite.to(proValue,max-nowTime,{endVector:Vector.<Number>([max]),onUpdate:report,ease:Linear.easeNone});
			
			
			
			
			//锤子
			hammer = new Image(Assets.getAtlasTexture("mainMenu/menuInstallBtn"));
			hammer.x = view.width;
			hammer.pivotX = hammer.width-15;
			hammer.pivotY = hammer.height-15;
			TweenMax.to(hammer,0.1,{rotation:-0.2,yoyo:true,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			buildSp.addChild(hammer);
			TweenLite.delayedCall(1,update);
			
			
			TweenMax.to(houseImg,Math.random()*0.2+0.1,{scaleY:0.9,yoyo:true,repeat:int.MAX_VALUE,ease:Linear.easeNone});
		}
		
		
		private var lessMS:int;
		private var lessHour:int;
		private var lessMinut:int;
		private var lessMinut2:int;
		private var lessSecond:int;
		private function report():void{
			proBar.value = proValue[0];
			
			lessMS = proBar.maximum - proBar.value;
			lessHour = lessMS/3600;
			
			lessMinut2 = lessMS%3600;
			lessMinut = lessMinut2/60;
			lessSecond = lessMinut2%60;
			
			proTF.text = "（还剩"+lessHour+"时"+lessMinut+"分"+lessSecond+"秒完成）";
			
			
			if(proValue[0] == proBar.maximum){
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,view.width>>1,-80,null,houseInfo.name+" 建造完毕！"));
				houseImg.scaleY = 1;
				
				TweenLite.killTweensOf(proValue);
				TweenLite.killTweensOf(hammer);
				TweenLite.killTweensOf(update);
				TweenLite.killTweensOf(houseImg);
				
				buildSp.visible = false;
				buildSp.removeChildren(0,-1,true);
			}
		}
		private function update():void{
			var ranX:Number = Math.random()*view.width;
			var ranY:Number = (Math.random()*view.height)>>1;
			
			if(ranX<(view.width>>1))	hammer.scaleX = -1;
			else	hammer.scaleX = 1;
			
			hammer.x = ranX;
			hammer.y = ranY;
			
			TweenLite.delayedCall(Math.random()*5,update);
		}
		
		
		
		
		
		public function set hitArea(hitArea:PixelHitArea):void
		{
			_hitArea = hitArea;
		}
		
		public function get hitArea():PixelHitArea
		{
			return _hitArea;
		}
		
		public function set houseInfo(houseInfo:HouseInfoVO):void
		{
			_houseInfo = houseInfo;
		}
		
		public function get houseInfo():HouseInfoVO
		{
			return _houseInfo;
		}
		
		public function get view():Sprite
		{
			return _house;
		}
		
		public function set touchable(val:Boolean):void
		{
			if(val){
				if(view){
					view.addEventListener(TouchEvent.TOUCH,clickHandle);
				}
			}else{
				if(view){
					view.removeEventListener(TouchEvent.TOUCH,clickHandle);
				}
			}
		}
		private function clickHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				
				sendNotification(GardenIslandMediator.HOUSE_CLICK,houseInfo);
			}
			
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			TweenLite.killTweensOf(proValue);
			TweenLite.killTweensOf(hammer);
			TweenLite.killTweensOf(update);
			TweenLite.killTweensOf(houseImg);
			
			view.dispose();
		}
	}
}