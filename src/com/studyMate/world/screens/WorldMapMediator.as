package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.controller.vo.ZoomResultVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.effects.SwimWater;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class WorldMapMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "WorldMapMediator";
		public static const UPDATE_MYLOCAL:String = "UpdateMylocal";
		public static const UPDATE_GOALLOCAL:String = "UpdateGoallocal";
		
		private var camera:CameraSprite;
		private var scale:Number=1;
		
		private var halfWidth:int;
		private var halfHeight:int;
		
		
		private var local:Point;
		private var tvo:TransformVO;
		
		private var _background:OceanMapBG;
		
		private var boatSp:Sprite;
		private var myBoat:Image;
		private var roleIcon:Image;
		
		
		private var GoldSp:Sprite;
		private var moreGold:Image;
		private var lessGold:Image
		
		
		private var prepareVO:SwitchScreenVO;
		
		public function WorldMapMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			tvo = vo.data as TransformVO;
			prepareVO = vo
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.HIDE_SETTING_SCREEN :
				{
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
				}
				case WorldConst.UPDATE_CAMERA:
				{
					local = notification.getBody() as Point;
					
					camera.moveTo(-local.x/tvo.scale,-local.y/tvo.scale,scale,0,false);
					break;
				}
				case WorldConst.UPDATE_SCALE:{
					var zoomResult:ZoomResultVO = notification.getBody() as ZoomResultVO;
					scale = zoomResult.scale;
					
					
					camera.moveTo(-local.x/tvo.scale,-local.y/tvo.scale,scale,0,false);
					break;
				}
				case UPDATE_MYLOCAL:
					
					updateMyLocal(notification.getBody() as int);
					
					break;
				case UPDATE_GOALLOCAL:
					
					updateGoalLocal(notification.getBody() as int);
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA,WorldConst.UPDATE_SCALE,UPDATE_MYLOCAL,UPDATE_GOALLOCAL,WorldConst.HIDE_SETTING_SCREEN ];
		}
		
		
		override public function onRegister():void
		{
			camera = new CameraSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, 0.02, .01);
			camera.moveTo(camera.world.x,camera.world.y,scale,0,false);
			view.addChild(camera);
			
			halfWidth = WorldConst.stageWidth>>1;
			halfHeight = WorldConst.stageHeight>>1
			local = tvo.location;
			
			_background = new OceanMapBG;
			camera.addChild(_background);
			
			//岛屿
			initIslands();
			
			
			GoldSp = new Sprite;
			moreGold = new Image(Assets.getWorldMapTexture("moreGold"));
			lessGold = new Image(Assets.getWorldMapTexture("lessGold"));
			lessGold.alpha = 0;
			GoldSp.addChild(moreGold);
			GoldSp.addChild(lessGold);
			camera.addChild(GoldSp);
			TweenMax.to(GoldSp,1,{y:GoldSp.y-5, yoyo:true,repeat:int.MAX_VALUE});

			
			boatSp = new Sprite;
			myBoat = new Image(Assets.getWorldMapTexture("boat_word"));
			boatSp.addChild(myBoat);
			
			roleIcon = new Image(Assets.getWorldMapTexture("roleIcon"));
			roleIcon.pivotX = roleIcon.width>>1;
			roleIcon.pivotY = roleIcon.height;
			roleIcon.x = -15+(roleIcon.width>>1);
			roleIcon.y = -83+roleIcon.height;
			boatSp.addChild(roleIcon);
			camera.addChild(boatSp);
			TweenMax.to(boatSp,1,{y:boatSp.y-5, yoyo:true,repeat:int.MAX_VALUE});
			



			
			_background.show(new Rectangle(-Global.stageWidth*0.5,-Global.stageHeight*0.5,Global.stageWidth,Global.stageHeight));
			
			camera.addEventListener(CameraUpdateEvent.CAMERA_UPDATE, updateBackground);
			
			
			
			mySwimwater = new SwimWater();
			mySwimwater.x = myBoat.width;
			mySwimwater.y = myBoat.y + myBoat.height;
			boatSp.addChild(mySwimwater);
			
			goalSwimwater = new SwimWater();
			goalSwimwater.x = moreGold.width;
			goalSwimwater.y = moreGold.y + moreGold.height;
			GoldSp.addChild(goalSwimwater);
			
			boatSp.addEventListener(TouchEvent.TOUCH,myBoatTouchHandle);
			GoldSp.addEventListener(TouchEvent.TOUCH,goldTouchHandle);
		}
		private function updateBackground(e:CameraUpdateEvent):void
		{
			_background.show(e.viewport);
		}
		private function initIslands():void{
			var island:Image;
			for(var i:int=0;i<6;i++){
				
				island = new Image(Assets.getWorldMapTexture("island"+i));
				
				island.x = 250*i-500;
				
				island.y = Math.random()*762-381;
				
				camera.addChild(island);
				
				
				
			}
		}
		
		
		private var mySwimwater:SwimWater;
		private var goalSwimwater:SwimWater;
		private function updateMyLocal(localX:int):void{
			TweenLite.to(roleIcon,0.3,{scaleX:0,scaleY:0});
			
			boatSp.y = 0;

			if(localX - 640 < boatSp.x){
				boatSp.scaleX = -1;
			}else
				boatSp.scaleX = 1;
			
			TweenLite.killTweensOf(boatSp);
			
			mySwimwater.removeAnimation();
			mySwimwater.start(1.3);
			TweenLite.to(boatSp,1,{x:localX - 640,ease:Linear.easeNone,onComplete:myboatUpdateComplete});
			TweenMax.to(boatSp,1,{y:boatSp.y-5, yoyo:true,repeat:int.MAX_VALUE});
		}
		private function myboatUpdateComplete():void{
			if(boatSp.scaleX == -1)
				boatSp.scaleX = 1;
			
			TweenLite.to(roleIcon,0.3,{scaleX:1,scaleY:1});
		}
		private function updateGoalLocal(localX:int):void{
			GoldSp.y = 0;
			
			
			if(localX - 640 < GoldSp.x){
				GoldSp.scaleX = -1;
			}else
				GoldSp.scaleX = 1;
			
			TweenLite.killTweensOf(GoldSp);
			
			goalSwimwater.removeAnimation();
			goalSwimwater.start(1.3);
			TweenLite.to(GoldSp,1,{x:localX - 640,ease:Linear.easeNone,onComplete:gboatUpdateComplete});
			TweenMax.to(GoldSp,1,{y:GoldSp.y-5, yoyo:true,repeat:int.MAX_VALUE});
		}
		private function gboatUpdateComplete():void{
			if(GoldSp.scaleX == -1)
				GoldSp.scaleX = 1;
			
			
			//超越目标
			if(boatSp.x >= GoldSp.x){
				moreGold.alpha = 0;
				overEffect(lessGold,true);
				
				myDialog = "您已超越现在等级目标，可以向更高的级别发起挑战啦!";
				goldDialog = "我是现在等级目标，您已经超越了我，呜呜呜...";
			}else{
				lessGold.alpha = 0;
				overEffect(moreGold,true);
				
				myDialog = "距离现在的目标还有一段距离。加油，您很快就可以超越它啦!";
				goldDialog = "HI，我是现在等级目标，您很快就能超越我，加油！孩子...";
			}
		}
		//过度效果
		private function overEffect(target:DisplayObject,_endVisible:Boolean):void{
			TweenLite.killTweensOf(target);
			
			if(_endVisible){
				target.alpha = 1;
				TweenLite.from(target,0.5,{alpha:0});
			}else{
				target.alpha = 0;
				TweenLite.from(target,0.5,{alpha:1});
			}
			
		}
		private var myDialog:String = "。。。";
		private var goldDialog:String = "。。。";
		private function myBoatTouchHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
//				sendNotification(WorldConst.DIALOGBOX_SHOW,
//					new DialogBoxShowCommandVO(camera,boatSp.x+(boatSp.width>>1),boatSp.y-boatSp.height+30,null,
//						myDialog,null,null,"style2"));
			}
			
		}
		private function goldTouchHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
//				sendNotification(WorldConst.DIALOGBOX_SHOW,
//					new DialogBoxShowCommandVO(camera,GoldSp.x+(GoldSp.width>>1),GoldSp.y-GoldSp.height-30,null,
//						goldDialog,null,null,"style2"));
			}
			
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
			TweenLite.killTweensOf(boatSp);
			TweenLite.killTweensOf(roleIcon);
			TweenLite.killTweensOf(GoldSp);
			
			mySwimwater.dispose();
			
			Assets.disposeTexture("boat1");
		}
		
		
		
	}
}