package com.mylib.game.charater
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.item.SpeakFrame;
	import com.mylib.game.controller.vo.CharaterMenuVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.CharaterInfoVO;
	import com.studyMate.world.controller.vo.DisplayChatViewCommandVO;
	import com.studyMate.world.screens.CharaterInfoMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.chatroom.ChatRoomMediator;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.display.Button;
	import starling.events.Event;
	
	public class CharaterMenuProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CharaterMenuProxy";

		private var btnlist:Vector.<Button> = new Vector.<Button>;
		
		public function CharaterMenuProxy(data:Object=null)
		{
			super(NAME, data);
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			
			var talkBtn:Button = new Button(Assets.getAtlasTexture("item/human_talk"));
			talkBtn.name = "talkBtn";
			talkBtn.addEventListener(Event.TRIGGERED,btnHandle);
			btnlist.push(talkBtn);
			
			var infoBtn:Button = new Button(Assets.getAtlasTexture("item/human_info"));
			infoBtn.name = "infoBtn";
			infoBtn.addEventListener(Event.TRIGGERED,btnHandle);
			btnlist.push(infoBtn);
			
			var fightBtn:Button = new Button(Assets.getAtlasTexture("item/human_fight"));
			fightBtn.name = "fightBtn";
			fightBtn.text = "即将开放";
			fightBtn.addEventListener(Event.TRIGGERED,btnHandle);
			fightBtn.enabled = false;
			btnlist.push(fightBtn);
			
		}
		private function btnHandle(e:Event):void{
			var btnName:String = (e.target as Button).name;
			trace("选择："+btnName);
			
			switch(btnName)
			{
				case "talkBtn":
				{
//					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SHOW_CHAT_VIEW,
//						new DisplayChatViewCommandVO(true,"PC",menuVo.id));
//					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ChatRoomMediator,menuVo.id)]);
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.OPEN_MENU,new SwitchScreenVO(ChatRoomMediator,menuVo.id,SwitchScreenType.SHOW));
					
					break;
				}
				case "infoBtn":
				{
					sendNotification(WorldConst.SWITCH_SCREEN,
						[new SwitchScreenVO(CharaterInfoMediator,new CharaterInfoVO(null,menuVo.id,menuVo.dressList,1,menuVo.level),
							SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
					
					sendNotification(WorldConst.SHOW_CHAT_VIEW,
						new DisplayChatViewCommandVO(false));
					
					break;
				}
				case "fightBtn":
				{
					
					applyFight(menuVo.id);
					
					break;
				}
			}
			
			
		}
		
		private function applyFight(_id:String):void{
			TweenLite.killTweensOf(applyFight);
			if(Global.isLoading){
				TweenLite.delayedCall(2,applyFight);
				return;
			}
			
			PackData.app.CmdIStr[0] = CmdStr.CHALLENGE_SB;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = Global.player.realName;
			PackData.app.CmdIStr[3] = _id;
			PackData.app.CmdInCnt = 5;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(WorldConst.APPLY_FIGHT));
			
			
		}
		
		private function menuDisappear(_btnList:Vector.<Button>):void{
			
			for (var i:int = 0; i < _btnList.length; i++) 
			{
				_btnList[i].removeFromParent();
			}
			
			
		}
		
		private var menuVo:CharaterMenuVO;
		public function showMenu(_vo:CharaterMenuVO):void{
			menuVo = _vo;
			
			if(!_vo.charater){
				menuDisappear(btnlist);
				return;
			}
			
			(_vo.charater as IHuman).menu(btnlist);
			
			for (var i:int = 0; i < btnlist.length; i++) 
			{
				btnlist[i].scaleX = 1;
				btnlist[i].scaleY = 1;
				
				TweenLite.from(btnlist[i],0.5,{delay:0.1*i,scaleX:0,scaleY:0,y:btnlist[i].y+btnlist[i].height,ease:Elastic.easeOut});
			}
			
			
			TweenLite.killTweensOf(menuDisappear);
			TweenLite.delayedCall(3,menuDisappear,[btnlist]);
			
		}
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			TweenLite.killTweensOf(menuDisappear);
			TweenLite.killTweensOf(applyFight);
			
			for (var i:int = 0; i < btnlist.length; i++) 
			{
				btnlist[i].removeFromParent(true);
				
			}
			
			
		}
	}
}