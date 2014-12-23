package com.studyMate.module.game
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.item.EquipmentItemButton;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.game.api.DressRoomConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class ItemControlMediator extends ScreenBaseMediator
	{
		public static const NAME:String =  "ItemControlMediator";
		
		private static const SELL_EQUIP:String = NAME + "sellEquip";
		
		private var vo:SwitchScreenVO;
		private var equipItem:EquipmentItemButton;
		private var isDress:Boolean;
		
		private var sellBtn:Button;
		
		public function ItemControlMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			equipItem = vo.data[0] as EquipmentItemButton;
			isDress = !vo.data[1];
			
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this,true)));
			
			//定位
			
			var spoint:Point = equipItem.parent.localToGlobal(new Point(equipItem.x,equipItem.y));
	
			//购买按钮
			sellBtn = new Button(Assets.getDressSeriesTexture("DressRoom/sellBtn"));
			sellBtn.name = "sellBtn";
			sellBtn.addEventListener(Event.TRIGGERED,sellBtnHandle);
			view.addChild(sellBtn);
			
			var dressTexture:Texture;
			if(isDress){
				dressTexture = Assets.getDressSeriesTexture("DressRoom/dressUp");
				sellBtn.enabled = true;
			}else{
				dressTexture = Assets.getDressSeriesTexture("DressRoom/dressDonw");
				sellBtn.enabled = false;
			}
			//默认装备，不可出售
			if(equipItem.dressSuitsVo.equipId == "-1"){
				sellBtn.enabled = false;
			}
			
			
			var dressBtn:Button = new Button(dressTexture);
			dressBtn.x = spoint.x+142;
			dressBtn.y = spoint.y + 45;
			dressBtn.addEventListener(Event.TRIGGERED,dressBtnHandle);
			view.addChild(dressBtn);
			
			sellBtn.x = spoint.x - sellBtn.width;
			sellBtn.y = dressBtn.y - sellBtn.height;
			sellBtn.x = dressBtn.x =spoint.x+142;
			
			
			if(dressBtn.x+dressBtn.width > 1280)
			{
				sellBtn.x = dressBtn.x = spoint.x - sellBtn.width;
				
			}
			
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,hideBtnHandle);
		}
		
		private function dressBtnHandle():void{
			//默认套装，不可出售
			if(equipItem.dressSuitsVo.equipId == "-1"){
				sellBtn.enabled = false;
			}else{
				sellBtn.enabled = !sellBtn.enabled;
			}
			
			
			sendNotification(DressRoomConst.HUMAN_DRESS,equipItem);
			
		}
		
		private function sellBtnHandle():void{
			
			
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(view,640,381,doSell,"确定出售该装备？\n(将获得原价50%的收益)"));
			
			
		}
		private function doSell():void{
			
			PackData.app.CmdIStr[0] = CmdStr.SELL_EQUIPMENT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = equipItem.dressSuitsVo.equipId;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(SELL_EQUIP,null,'cn-gb',null,SendCommandVO.QUEUE));
			
			
		}
		
		
		
		
		private function hideBtnHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					if(Starling.current.stage.contains(view) && 
						!view.getBounds(Starling.current.stage).contains(touchPoint.globalX,touchPoint.globalY)){ //主菜单区域
						//关闭
						closeBtnHandle();
					}
				}
			}
		}
		
		private function closeBtnHandle():void{
			vo.type = SwitchScreenType.HIDE;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case SELL_EQUIP:
					if(!result.isErr){
						
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(AppLayoutUtils.gpuLayer,640,381,null,"获得:"+PackData.app.CmdOStr[2]+"钻石，"+PackData.app.CmdOStr[3]+"金币"));
						
						closeBtnHandle();
						sendNotification(DressRoomConst.SELL_DRESS_COMPLETE,equipItem);
						
					}
					
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [SELL_EQUIP];
		}
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		
	}
}