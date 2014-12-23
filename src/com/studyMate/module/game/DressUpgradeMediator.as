package com.studyMate.module.game
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.item.DressMarketItem;
	import com.mylib.game.fightGame.CircleChart;
	import com.mylib.game.fightGame.RollerUtils;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.game.api.DressMarketConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.DressSeriesItemVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class DressUpgradeMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "DressUpgradeMediator";
		public static const UPDATE_EQUIP_SUCCESS:String = NAME + "UpdateEquipSuccess";
		private static const UPGRADE_EQUIP_COMPLETE:String = NAME + "UpgradeEquipComplete";
		
		private var vo:SwitchScreenVO;
		
		private var holder:Sprite;
		private var nowCircle:CircleChart;
		private var upCircle:CircleChart;
		
		private var clickItem:DressMarketItem;
		private var nowDressVo:DressSuitsVO;
		private var upDressVo:DressSuitsVO;
		
		
		public function DressUpgradeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			clickItem = vo.data[0] as DressMarketItem;
			nowDressVo = vo.data[1] as DressSuitsVO;
			upDressVo = vo.data[2] as DressSuitsVO;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRegister():void
		{
			sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(this,true));
			
			//遮罩
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
			quad.alpha = 0.5;
			view.addChild(quad);
			holder = new Sprite;
			holder.x = 518;
			holder.y = 190;
			view.addChild(holder);
			
			var bg:Image = new Image(Assets.getDressSeriesTexture("DressMarket/updateBg"));
			holder.addChild(bg);
			var cancleBtn:Button = new Button(Assets.getDressSeriesTexture("DressMarket/updateBg_cleBtn"));
			cancleBtn.x = 66;
			cancleBtn.y = 225;
			holder.addChild(cancleBtn);
			cancleBtn.addEventListener(Event.TRIGGERED,cancleBtnHandle);
			var upgradeBtn:Button = new Button(Assets.getDressSeriesTexture("DressMarket/updateBg_upBtn"));
			upgradeBtn.x = 325;
			upgradeBtn.y = 225;
			upgradeBtn.enabled = false;
			holder.addChild(upgradeBtn);
			upgradeBtn.addEventListener(Event.TRIGGERED,upgradeBtnHandle);
			
			var nowEquip:DisplayObject = GlobalModule.charaterUtils.getEquipImgByName(nowDressVo.name);
			nowEquip.x = 125;
			nowEquip.y = 125;
			holder.addChild(nowEquip);
			nowCircle = new CircleChart;
			nowCircle.x = 150;
			nowCircle.y = 60;
			nowCircle.scaleX = 0.8;
			nowCircle.scaleY = 0.8;
			nowCircle.clear();
			holder.addChild(nowCircle);
			RollerUtils.setChartByProperty(nowCircle,GlobalModule.charaterUtils.getEquipProperty(nowDressVo.name));
			nowCircle.refresh();
			
			var item:DressSeriesItemVO = GlobalModule.charaterUtils.getNextLevelEquip(nowDressVo.name);
			if(item){
				var upEquip:DisplayObject = GlobalModule.charaterUtils.getEquipImgByName(item.name);
				upEquip.x = 395;
				upEquip.y = 125;
				holder.addChild(upEquip);
				upCircle = new CircleChart;
				upCircle.x = 410;
				upCircle.y = 60;
				upCircle.scaleX = 0.8;
				upCircle.scaleY = 0.8;
				upCircle.clear();
				holder.addChild(upCircle);
				RollerUtils.setChartByProperty(upCircle,GlobalModule.charaterUtils.getEquipProperty(item.name));
				upCircle.refresh();
				
				createProcess();
				upgradeBtn.enabled = true;
			}
			
			
			
			
			
			
			
			
			
			
			
			
		}
		private var pro1:Image;
		private var pro2:Image;
		private var pro3:Image;
		private function createProcess():void{
			pro1 = new Image(Assets.getDressSeriesTexture("DressMarket/updateBg_proImg"));
			pro1.x = 220;
			pro1.y = 123;
			pro1.alpha = 0;
			holder.addChild(pro1);
			pro2 = new Image(Assets.getDressSeriesTexture("DressMarket/updateBg_proImg"));
			pro2.x = 270;
			pro2.y = 123;
			pro2.alpha = 0;
			holder.addChild(pro2);
			pro3 = new Image(Assets.getDressSeriesTexture("DressMarket/updateBg_proImg"));
			pro3.x = 320;
			pro3.y = 123;
			pro3.alpha = 0;
			holder.addChild(pro3);
			TweenMax.to(pro1,0.5,{alpha:1,yoyo:true,repeat:int.MAX_VALUE});
			TweenMax.to(pro2,0.5,{delay:0.3,alpha:1,yoyo:true,repeat:int.MAX_VALUE});
			TweenMax.to(pro3,0.5,{delay:0.6,alpha:1,yoyo:true,repeat:int.MAX_VALUE});
			
		}
		
		private function cancleBtnHandle(e:Event):void{
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		private function upgradeBtnHandle(e:Event):void{
			if(Global.isLoading)
				return;
			
			PackData.app.CmdIStr[0] = CmdStr.BUY_EQUIPMENT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = upDressVo.equipId; //equipId
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(UPGRADE_EQUIP_COMPLETE));
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case UPGRADE_EQUIP_COMPLETE:
					//购买成功
					if((PackData.app.CmdOStr[0] as String)=="000"){
						sendNotification(DressMarketConst.UPDATE_MONEY,[PackData.app.CmdOStr[3],PackData.app.CmdOStr[4]]);
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(AppLayoutUtils.uiLayer,640,381,null,"恭喜您，装备升级成功！"));
						
						sendNotification(UPDATE_EQUIP_SUCCESS,upDressVo.name);
						clickItem.upgradeItem(nowDressVo,upDressVo);
						cancleBtnHandle(null);
					}else if((PackData.app.CmdOStr[0] as String)=="M00"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(AppLayoutUtils.uiLayer,640,381,null,"十分抱歉，您的金币不足，升级失败."));
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(AppLayoutUtils.uiLayer,640,381,null,"莫名错误导致升级失败，请与客服联系"));
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [UPGRADE_EQUIP_COMPLETE];
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void
		{
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			
			nowCircle.dispose();
			if(upCircle)	upCircle.dispose();
			
			if(pro1)	TweenLite.killTweensOf(pro1);
			if(pro2)	TweenLite.killTweensOf(pro2);
			if(pro3)	TweenLite.killTweensOf(pro3);
			
			view.removeChildren(0,-1,true);
		}
		
		
		
		
		
		
		
	}
}