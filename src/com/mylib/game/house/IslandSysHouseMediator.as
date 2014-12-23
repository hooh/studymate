package com.mylib.game.house
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.AndroidGameShowMediator;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.IndexMusicMediator;
	import com.studyMate.world.screens.ResTableMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.WorldMediator;
	import com.studyMate.world.screens.talkingbook.TalkingBookMediator;
	import com.studyMate.world.screens.wallpaper.WallpaperViewMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.extensions.PixelHitArea;

	public class IslandSysHouseMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "IslandSysHouseMediator";
		
		private var hitArea:PixelHitArea;
		
		private var sysHouseMdiator:Vector.<SysHouseMediator>

		
		private var SYS_HOUSE:Array = ["House_DressRoom","House_DressMarket","House_NPC01","House_Game","House_Music","House_Movie"];
		
		public function IslandSysHouseMediator(viewComponent:Object,_hitArea:PixelHitArea)
		{
			super(NAME, viewComponent);
			
			hitArea = _hitArea;
		}
		
		override public function onRegister():void
		{
			sysHouseMdiator = new Vector.<SysHouseMediator>;
			
			var houseInfo:HouseInfoVO;
			var sysHouse:SysHouseMediator;
			
			var x:Number;
			var y:Number;  
			var len:int = SYS_HOUSE.length;
			
			for(var i:int = 0; i<len; i++){
				
//				x = -160-320*i;
//				x = -200*i;
				x = -500 + 200*i;
				y = 164;
				
				if(SYS_HOUSE[i] == "House_PicBook")
					y -= 60; 
				else if(SYS_HOUSE[i] == "House_DressMarket")
					y += 20; 
				else if(SYS_HOUSE[i] == "House_DressRoom")
					y += 125; 
				else if(SYS_HOUSE[i] == "House_RunGame")
					y -= 50; 
				else if(SYS_HOUSE[i] == "House_Wallpaper")
					y -=30;
				houseInfo = new HouseInfoVO(SYS_HOUSE[i],x,y);
				
				sysHouse = new SysHouseMediator(houseInfo,hitArea);
				facade.registerMediator(sysHouse);
				sysHouseMdiator.push(sysHouse);
				
				sysHouse.touchable = true;
				view.addChild(sysHouse.view);
			}
		}
		
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case SysHouseMediator.CLICK_HOUSE:
					houseClick(notification.getBody() as SysHouseMediator);
					
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [SysHouseMediator.CLICK_HOUSE];
		}
		
		private function houseClick(_sysHouse:SysHouseMediator):void{
			var localX:int = _sysHouse.view.x;
			var localY:int = _sysHouse.view.y-_sysHouse.view.height-100;
			
			switch(_sysHouse.houseInfo.data){
				case "House_Movie":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,
							MovieHouseEnterHandle,"华记士多，没有你买不到，只有你想不到~O(∩_∩)O~"));
					break;
				case "House_Music":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,MusicHouseEnterHandler,
							"廖记音乐，挑一首属于自己的歌，唱响中国！~O(∩_∩)O~"));
					break;
				case "House_Game":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,GameHouseEnterHandler,
							"涛记娱乐城，轻松一刻！~O(∩_∩)O~"));
					break;
				case "House_PicBook":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,PicBookHouseEnterHandler,
							"苏记书店，书中有黄金屋，书中有和田玉~O(∩_∩)O~"));
					break;
				
				case "House_NPC01":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,TestLearnHouseEnterHandler,
							"快来测测您的学习等级吧~O(∩_∩)O~"));
					break;
				
				case "House_DressMarket":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,dressMarketHandle,
							"装备商城，全新上线，包邮哦~O(∩_∩)O~"));
					
					break;
				case "House_DressRoom":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,dressRoomHandle,
							"您的房间，天天都穿新衣服~O(∩_∩)O~"));
					
					break;
				case "House_RunGame":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,runnerGameHandle,
							"快乐向前冲，你能冲多远？~O(∩_∩)O~"));
					
					break;
				case "House_Wallpaper":
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view,localX,localY,wallpaperHandler,
							"壁纸商城，壁纸天天换~~O(∩_∩)O~"));
					
					break;
			}
			
			
			
		}
		
		private function wallpaperHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WallpaperViewMediator)]);
		}
		
		private function runnerGameHandle():void{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.RUNNER_GAME)]);
			
		}
		
		private function dressRoomHandle():void{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_ROOM)]);
		}
		
		private function dressMarketHandle():void{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_MARKET)]);
		}
		
		private function TestLearnHouseEnterHandler():void{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.INDEX_TEST_LEARNING)]);
		}
		
		private function MovieHouseEnterHandle():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ResTableMediator)]);
		}
		
		private function MusicHouseEnterHandler():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IndexMusicMediator)]);
		}
		
		private function GameHouseEnterHandler():void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AndroidGameMediator),new SwitchScreenVO(CleanCpuMediator)]);
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AndroidGameShowMediator)]);
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.HIDE_LEFT_MENU);
		}
		
		private function PicBookHouseEnterHandler():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TalkingBookMediator),new SwitchScreenVO(CleanCpuMediator)]);

//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BookshelfNewView2Mediator),new SwitchScreenVO(CleanGpuMediator)]);
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
			
			for(var i:int=0 ; i<sysHouseMdiator.length; i++)
				facade.removeMediator(sysHouseMdiator[i].getMediatorName());
		}
	}
}