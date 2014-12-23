package com.studyMate.world.screens.email.emailmediator
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.email.EmailData;
	import com.studyMate.world.screens.email.emailrender.EditorReadedEmailItemRenderer;
	import com.studyMate.world.screens.email.emailrender.ReadedEmailItemrenderer;
	import com.studyMate.world.screens.email.emailview.CollectEmailView;
	
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.controls.ScrollText;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.events.Event;

	public class CollectEmailViewMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "CollectMediator";
		
		private const QRYEMAILTREE:String = "QryEmailTree";
		private const SELEMAIL4PAD:String = "SelEmail4Pad";
		private const BATDELEMAIL4P:String = "BatDeleMail4p";
		private const DELEMAIL4PAD:String = "DelEmail4Pad";
		private const yesDelHandler:String = NAME+"yesDelHandler";
		private const yesHandler:String = NAME+"yesHandler";
		private const noHandler:String = NAME+"noHandler";
		
		private var delID:EmailData;
		private var prepareVO:SwitchScreenVO;
		
		private var croomList:List;//列表组件
		private var croomUVec:ListCollection = new ListCollection();
		private var emailVec:Vector.<EmailData> = new Vector.<EmailData>;

		public function CollectEmailViewMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return CollectEmailView;
		}
		
		public function get view():CollectEmailView{
			return getViewComponent() as CollectEmailView;
		}
		
		
		private var msgTextField2:ScrollText = new ScrollText();
		private var moreBtn:Button;
		private var begin:int = -5;

		override public function onRegister():void
		{
			
			view.addChild(msgTextField2);
			msgTextField2.x = 455;
			msgTextField2.y = 150;
			msgTextField2.width = 700;
			msgTextField2.height = 592;
			msgTextField2.paddingTop = 0;
			msgTextField2.isHTML = true;
			msgTextField2.textFormat = new TextFormat('HeiTi',21,0,true);
			msgTextField2.embedFonts = true;
			
			moreBtn = new Button(Assets.getEmailAtlasTexture("more"));
			moreBtn.x = 120;
			moreBtn.y = 700;
			view.addChild(moreBtn);
			moreBtn.addEventListener(Event.TRIGGERED,moreEmailHandler);
			
			croomList = new List();
			croomList.x = 0;
			croomList.y = 65;
			croomList.width = 420;
			croomList.height = 630;
			croomList.dataProvider = croomUVec;
			croomList.itemRendererType = ReadedEmailItemrenderer
			view.addChild(croomList);	
			view.editorBtn.addEventListener(Event.TRIGGERED,editorEmailHandler);
			view.delBtn.addEventListener(Event.TRIGGERED,delEmailHandler);
			view.finshBtn.addEventListener(Event.TRIGGERED,finishEditorEmailHandler);
			croomList.addEventListener(Event.CHANGE,selectHandler);
			getEmailList();
		}
		
		
		private function moreEmailHandler():void
		{
			getEmailList()		
		}
		
		private function selectHandler():void
		{
			if(croomList.selectedItem != null){
				view.hideBackground.visible = false;
				view._label.visible = true;
				view._title.visible = true;
				PackData.app.CmdIStr[0] = CmdStr.SELEMAIL4PAD;
				PackData.app.CmdIStr[1] = croomList.selectedItem.mailid;
				PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdInCnt = 3;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(SELEMAIL4PAD));
				
			}
		}
		
		private function delEmailHandler():void
		{
			sendNotification(WorldConst.ALERT_SHOW,new AlertVo("你确定要删除全部已读邮件吗？",true,yesDelHandler));//提交订单
		}
		
		
		private function finishEditorEmailHandler():void
		{
			view.editorBtn.visible = true;
			view.delBtn.visible = false;
			view.finshBtn.visible = false;
			croomList.itemRendererType = ReadedEmailItemrenderer
		}
		
		
		private function editorEmailHandler():void
		{
			view.editorBtn.visible = false;
			view.delBtn.visible = true;
			view.finshBtn.visible = true;
			croomList.itemRendererType = EditorReadedEmailItemRenderer
		}
		
		private function getEmailList():void
		{
			if(!Global.isLoading){
				begin = begin + 5;
				PackData.app.CmdIStr[0] = CmdStr.QRYEMAILTREE;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = "1";
				PackData.app.CmdIStr[3] = begin;
				PackData.app.CmdIStr[4] = 0;
				PackData.app.CmdInCnt = 5;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRYEMAILTREE));	
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return[WorldConst.HIDE_SETTING_SCREEN,QRYEMAILTREE,BATDELEMAIL4P,yesDelHandler,SELEMAIL4PAD,DELEMAIL4PAD,WorldConst.DELEMAIL,yesHandler,noHandler]
		}
		
		
		private var num:int = 0;  
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody()as DataResultVO;
			var _emaildata:EmailData = new EmailData();
			switch(notification.getName())
			{
				case WorldConst.HIDE_SETTING_SCREEN:
				{
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
				}
				case yesDelHandler:
				{
					PackData.app.CmdIStr[0] = CmdStr.BATDELEMAIL4P;
					PackData.app.CmdIStr[1] =  PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = "1"
					PackData.app.CmdInCnt = 3;
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(BATDELEMAIL4P));
					break;
				}
				case QRYEMAILTREE:
				{
					if(!_result.isErr){
						if(!_result.isEnd){
							_emaildata.mailid = PackData.app.CmdOStr[1];
							_emaildata.send = PackData.app.CmdOStr[2];
							_emaildata.creattime = PackData.app.CmdOStr[3];
							for(var i:int = 0;i<PackData.app.CmdOStr[2].length;i++){
								if(PackData.app.CmdOStr[2].charAt(i) == "<"){
									_emaildata.sendid = PackData.app.CmdOStr[2].slice(i+1,PackData.app.CmdOStr[2].length-1);
								}
							}
							_emaildata.mark = PackData.app.CmdOStr[5];
							_emaildata.readtime = PackData.app.CmdOStr[6];
							if(PackData.app.CmdOStr[7].length < 1){
								_emaildata.subject = "<无主题邮件>";
							}else{
								_emaildata.subject = PackData.app.CmdOStr[7]
							}
							num = PackData.app.CmdOStr[8];
					/*		if(PackData.app.CmdOStr[8].length < 20){
								_emaildata.mailtext = PackData.app.CmdOStr[8];
							}else{
								PackData.app.CmdOStr[8].slice(0,19)+"....."
							}*/
							view.shape.visible = false;
							emailVec.push(_emaildata);
						}else{
							if(emailVec.length<1&&croomUVec.length>1){
								sendNotification(CoreConst.TOAST,new ToastVO("这已经是你收藏的所有邮件了"));
							}else{
								for(var j:int =0;j<emailVec.length;j++){
									croomUVec.push(emailVec[j])
								}
								emailVec.length = 0
							}
							if(croomUVec.length<1){
								view.shape.visible = true;
								moreBtn.visible = false;
							}else{
								view.shape.visible = false;
								if(num<=5){
									moreBtn.visible = false;
								}else{
									moreBtn.visible = true;
								}
							}

						}
					}
					break;
				}
				case SELEMAIL4PAD:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							view.sendname.text = PackData.app.CmdOStr[3]+"<ID:"+PackData.app.CmdOStr[2]+">";
							if(PackData.app.CmdOStr[8].length == 1){
								view.title.text = "无主题邮件";
								view.title.color = 0x595653;
							}else{
								view.title.text = PackData.app.CmdOStr[8];
							}
							msgTextField2.text = PackData.app.CmdOStr[10];
						}
					}
					break;
				}
				case DELEMAIL4PAD:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							croomList.dataProvider.removeItem(delID);
						}
					}
					break;
				}
				case BATDELEMAIL4P:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							croomUVec.removeAll();
							emailVec.length = 0;
						}
					}
					break;
				}
				case WorldConst.DELEMAIL:
				{
					delID = notification.getBody() as EmailData;
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.ALERT_SHOW,new AlertVo("你确定要删除这封收藏邮件吗？",true,yesHandler,noHandler));	
					msgTextField2.visible = false;
					break;
				}
				case yesHandler:
				{
					msgTextField2.visible = true;
					PackData.app.CmdIStr[0] = CmdStr.DELEMAIL4PAD;
					PackData.app.CmdIStr[1] =  PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = delID.mailid;
					PackData.app.CmdIStr[3] = "R";
					PackData.app.CmdInCnt = 4;
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(DELEMAIL4PAD));
					break;
				}
				case noHandler:
				{
					msgTextField2.visible = true;
					break;
				}
			}
			
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			view.removeChild(msgTextField2,true);
			view.removeChildren(0,-1,true);
		}
	}
}