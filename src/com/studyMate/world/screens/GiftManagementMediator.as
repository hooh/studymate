package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.MessageVO;
	import com.studyMate.world.screens.component.SysRewardCartoonMediator;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GiftManagementMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "GiftManagementMediator";
		public static const GET_NEW_GIFT:String = NAME + "Get_New_Gift";
		public static const GET_READ_GIFT:String = NAME + "Get_Read_Gift";
		public static const REC_GIFT:String = NAME + "RecGiftByMsgId";
		
		private var range:Rectangle;
		private var giftArray:Vector.<GiftSprite>;
		private var camera:CameraSprite;
		
		public function GiftManagementMediator(viewComponent:Object,range:Rectangle,camera:CameraSprite){
			super(NAME, viewComponent);
			this.range = range;
			this.camera = camera;
		}
		
		override public function onRegister():void{
			giftArray = new Vector.<GiftSprite>;
		}
		
		/*private function randomDrop():void{
			TweenLite.delayedCall(2,randomDrop);
			dropGift(null);
		}*/
		
		public function dropGift(msg:MessageVO,_delay:Number=0):void{
			var img:GiftSprite = new GiftSprite(msg);
			view.addChild(img);
			
			img.y = -400;
			img.pivotY = img.height;
			img.x = -(camera.world.x) + Math.random() * 1000 - 500;
			
			TweenLite.to(img,1,{y:range.bottom-Math.random()*range.height,delay:_delay,ease:Quad.easeIn,onComplete:dropCompleteHandle,onCompleteParams:[img]});
			img.addEventListener(TouchEvent.TOUCH, giftHandler);
		}
		
		private function dropCompleteHandle(gift:GiftSprite):void{
			TweenLite.to(gift,0.2,{scaleY:0.8});
			TweenLite.to(gift,1,{scaleY:1,delay:0.2,ease:Elastic.easeOut});
		}
		
		private function showGift(msg:MessageVO):void{
			var img:GiftSprite = new GiftSprite(msg);
			view.addChild(img);
			img.x = Math.random()*range.width+range.x;
			img.y = range.bottom - Math.random()*range.height;
			img.addEventListener(TouchEvent.TOUCH, giftHandler);
			img.pivotY = img.height;
		}
		
		private function giftHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				var msg:MessageVO = (e.currentTarget as GiftSprite).msg;
				(e.currentTarget as GiftSprite).visible = false;
				recGiftByMid(msg.msgId);
			}
		}
		
		private function recGiftByMid(msgId:String):void{
			PackData.app.CmdIStr[0] = CmdStr.REC_GIFT_BY_MSG;
			PackData.app.CmdIStr[1] = msgId;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(REC_GIFT));
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_READ_GIFT : 
					if(!result.isEnd){
						var msg:MessageVO = new MessageVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],
							PackData.app.CmdOStr[4],PackData.app.CmdOStr[5],PackData.app.CmdOStr[6],PackData.app.CmdOStr[7],
							PackData.app.CmdOStr[8],PackData.app.CmdOStr[9],PackData.app.CmdOStr[10],PackData.app.CmdOStr[11],
							PackData.app.CmdOStr[12],PackData.app.CmdOStr[13]);
						dropGift(msg,Math.random()*2);
					}
					break;
				case REC_GIFT : 
					if(!result.isErr){
						if(PackData.app.CmdOStr[2] == "Gold"){
							sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SysRewardCartoonMediator,["奖励",PackData.app.CmdOStr[3]],SwitchScreenType.SHOW,view.stage,0,0)]);
						}
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [GET_READ_GIFT,REC_GIFT];
		}
		
		override public function onRemove():void{
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
	}
}