package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class LeftButtonMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LeftButtonMenuMediator";

		
		private var playerGoldTxt:TextField;
		private var playerNameTxt:TextField;
		private var charater:ICharater;
		
		public function LeftButtonMenuMediator(){
			super(NAME, new Sprite);
		}
		override public function onRegister():void{
			addPlayerName();
			addPlayerGold();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.UPDATE_LEFT_MENU_GOLD:
					var gold:int = notification.getBody() as int;
					
					Global.goldNumber = gold;
					playerGoldTxt.text = gold.toString();
					
					break;
				case WorldConst.SHOW_LEFT_MENU_GOLD:
					var _visible:Boolean = notification.getBody() as Boolean;
					
					if(goldSp)
						goldSp.visible = _visible;
					
					break;
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_LEFT_MENU_GOLD,WorldConst.SHOW_LEFT_MENU_GOLD];
		}
		
		
		

		
		
		private function addPlayerName():void{
			var btn:Button = new Button(Assets.getAtlasTexture("mainMenu/playerName"));
			btn.x = 65; btn.y = 8;
			view.addChild(btn);
			btn.addEventListener(Event.TRIGGERED, showPersonalInfoHandle);
			
			var humanSp:Sprite = new Sprite;
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			charater.view.alpha = 1;
			charater.view.scaleX = 1.5;
			charater.view.scaleY = 1.5;
			charater.view.x = 0;
			charater.view.y = 0;
			GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,Global.myDressList,new Rectangle());
			
			humanSp.addChild(charater.view);
			humanSp.x = 40;
			humanSp.y = 75;
			humanSp.clipRect = new Rectangle(-60,-150,100,130);
			btn.addChild(humanSp);
			
			
			
			if(Global.player == null){
				return;
			}
			playerNameTxt = new TextField(95, 32, Global.player.realName, "HeiTi", 21, 0xffffff);
			playerNameTxt.nativeFilters = [new GlowFilter(0x583118,1,5,5,20)];
			playerNameTxt.autoScale = true;playerNameTxt.hAlign = HAlign.CENTER;
			playerNameTxt.x = 129; playerNameTxt.y = 23;
			playerNameTxt.touchable = false;
			view.addChild(playerNameTxt);
		}
		private var goldSp:Sprite;
		private function addPlayerGold():void{
			goldSp = new Sprite;
			view.addChild(goldSp);
			goldSp.visible = false;
			
			var image:Image = new Image(Assets.getAtlasTexture("mainMenu/playerGold"));
			image.x = 268; image.y = 8;
			goldSp.addChild(image);
			
			playerGoldTxt = new TextField(100, 32, Global.goldNumber.toString(), "comic", 33, 0xffffff);
			playerGoldTxt.nativeFilters = [new GlowFilter(0x583118,1,5,5,20)];
			playerGoldTxt.autoScale = true;playerGoldTxt.hAlign = HAlign.CENTER;
			playerGoldTxt.x = image.x + 65; playerGoldTxt.y = 23;
			goldSp.addChild(playerGoldTxt);
		}
		
		
		//显示个人信息界面
		private function showPersonalInfoHandle(event:Event):void{
//			sendNotification(WorldConst.SHOW_PERSONALINFO);
			
//			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_ROOM)]);
//			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_MARKET)]);
			
			sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(PersonalInfoViewMediator,null,SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
				
			
			
		}
		
	

		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
			charater = null;
			
			view.removeChildren(0,-1,true);
		}
	}
}