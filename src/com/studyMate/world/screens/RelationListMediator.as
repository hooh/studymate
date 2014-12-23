package com.studyMate.world.screens
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.RelListItemSprite;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.InsMessageVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	
	import feathers.controls.Scroller;
	import feathers.controls.supportClasses.LayoutViewPort;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class RelationListMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "RelationListMediator";
		public static const GET_RELATE_LIST:String = "getRelateList";
		public static const DEL_RELATE:String = "delRelate";
		public static const DEL_RELATE_COMPLETE:String = "delRelateComplete";
		
		private var vo:SwitchScreenVO;
		
		private var nameList:Vector.<String> = new Vector.<String>;
		private var nameListTF:TextField;
		
		private var relListItemSpVoList:Vector.<RelListItemSpVO> = new Vector.<RelListItemSpVO>;

		private var delRelateStdId:String;
		
		private var viewPort:LayoutViewPort;
		
		private var curentFriVo:RelListItemSpVO;
		
		public function RelationListMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			getRelateList();
		}
		

		override public function onRegister():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(this,true));
			
			init();
		}
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_RELATE_LIST:
					if(!result.isEnd){
//						nameList.push(PackData.app.CmdOStr[4]);
						
						var relListItemSpVo:RelListItemSpVO = new RelListItemSpVO();
						relListItemSpVo.userId = PackData.app.CmdOStr[1];
						relListItemSpVo.rstdId = PackData.app.CmdOStr[2];
						relListItemSpVo.rstdCode = PackData.app.CmdOStr[3];
						relListItemSpVo.realName = PackData.app.CmdOStr[4];
						relListItemSpVo.relaType = PackData.app.CmdOStr[5];
						
						
						
						relListItemSpVoList.push(relListItemSpVo);
						
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
				case DEL_RELATE:
					delRelateStdId = notification.getBody() as String;
					
					PackData.app.CmdIStr[0] = CmdStr.DELETE_STD_RELAT;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = delRelateStdId;
					PackData.app.CmdInCnt = 3;
					sendNotification(CoreConst.SEND_11,new SendCommandVO(DEL_RELATE_COMPLETE));
					
					
					break;
				case DEL_RELATE_COMPLETE:
					if(!result.isErr){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							view.width>>1,view.height>>1,null,"成功删除好友！"));
						
						delRelateFromList(delRelateStdId);
						showRelateList();
					}else
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							view.width>>1,view.height>>1,null,"好友删除失败！"));
					
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [GET_RELATE_LIST,DEL_RELATE,DEL_RELATE_COMPLETE];
		}
		
		private function init():void{
			var bg:Image = new Image(Assets.getTexture("relateListBg"));
			view.addChild(bg);
			centerPivot(view);
			
			var closeBtn:Button = new Button(Assets.getAtlasTexture("huInfo_closeBtn"));
			closeBtn.x = bg.width - (closeBtn.width>>1);
			closeBtn.y = -(closeBtn.height>>1);
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			view.addChild(closeBtn);
			
			viewPort = new LayoutViewPort();
			var nameListSC:Scroller = new Scroller();
			nameListSC.x = 35;
			nameListSC.y = 110;
			nameListSC.width = 235;
			nameListSC.height = 310;
			nameListSC.viewPort = viewPort;
			view.addChild(nameListSC);

			showRelateList();
			
		}
		private function closeBtnHandle(event:Event):void{
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}

		private function getRelateList():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_STD_RELATLIST;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_RELATE_LIST));
		}
		
		private function showRelateList():void{
			viewPort.removeChildren(0,-1,true);

			var len:int = relListItemSpVoList.length;

			var relListItemSp:RelListItemSprite;
			for(var i:int=0;i<len;i++){
				relListItemSp = new RelListItemSprite(relListItemSpVoList[i]);
				relListItemSp.y = i*60;
				viewPort.addChild(relListItemSp);
				
			}
			
		}
		
		
		private function delRelateFromList(_rstdId:String):void{
			var len:int = relListItemSpVoList.length;
			for(var i:int=0;i<len;i++){
				if(_rstdId == relListItemSpVoList[i].rstdId){
					
					relListItemSpVoList.splice(i,1);
					break;
				}
			}
		}

		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			
		}
	}
}