package com.studyMate.world.screens.ui
{
	import com.greensock.TweenLite;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.component.sysface.ScrollTextExtends;
	import com.studyMate.world.component.sysface.SysFacePanelMediator;
	import com.studyMate.world.component.sysface.TextFieldExtends;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.controller.vo.SendSimSimiMessageCommandVO;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.model.vo.InsMessageVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Scroller;
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ChatPanelMediator extends Mediator implements IMenuPanel
	{
		public static const NAME:String = "ChatPanel";
		private static const QRYUR_INS_MESS_COMPLETE:String = NAME + "QryurInsMessComplete";
		
		public var input:TextFieldHasKeyboard;
		public var groupChatTF:ScrollTextExtends;
		public var gcRecordStr:String = "";
		public var talkStyle:String = "1";		//1-talk2All, 2-talk2Npc, 3-talk2Fri
		public var isShow:Boolean = false;
		
		public var talk2AllBtn:starling.display.Button;
		public var talk2NpcBtn:starling.display.Button;
		
		public var talkProxy:TalkingProxy;
		
		public var tf:TextFormat;
		
		public var privatChatTF:ScrollTextExtends;
		private var priChatFriTF:TextField;
		private var pcRecordStr:String = "";
		private var insMessList:Vector.<InsMessageVO> = new Vector.<InsMessageVO>;
		
		private var charater:ICharater;
		private var actionList:Vector.<String>
		private var faceList:Vector.<String>
		
		private var npcTalkSP:Sprite;
		private var leftLabTexture:Scale9Textures;
		private var rightLabTexture:Scale9Textures;
		private var headIconTexture:Texture;
		private var talkViewPort:LayoutViewPort;
		private var scroll:Scroller;
		private var labImgList:Vector.<Scale9Image>; //存储对话框列表.

		public function ChatPanelMediator()
		{
			super(NAME, new Sprite);
		}
		
		override public function onRemove():void
		{
			input.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			Starling.current.nativeOverlay.removeChild(input);	
			TweenLite.killTweensOf(delayFun);
			
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
			charater = null;
			charaterSp.dispose();
			humanSC.dispose();
			scroll.dispose();
			
			groupChatTF.removeFromParent(true);
			privatChatTF.removeFromParent(true);
			
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		
		public function get view():Sprite
		{
			return getViewComponent() as Sprite;
		}
		
		public var bg:Image;
		override public function onRegister():void
		{
			bg = new Image(Assets.getTexture("talkingBox"));
			view.addChild(bg);
			
			npcTalkSP = new Sprite();
			view.addChild(npcTalkSP);
			
			createTalkHolder();
			
			tf = new TextFormat("HeiTi",20, 0x3a2002);
			
			groupChatTF = new ScrollTextExtends();
			groupChatTF.width = 600;
			groupChatTF.height = 220;
			groupChatTF.x = 177;
			groupChatTF.y = 5;
			groupChatTF.verticalScrollPosition = -115;
			view.addChild(groupChatTF);
			
			privatChatTF = new ScrollTextExtends();
			privatChatTF.width = 600;
			privatChatTF.height = 220;
			privatChatTF.x = 177;
			privatChatTF.y = 5;
			privatChatTF.verticalScrollPosition = -115;
			
			priChatFriTF = new TextField(150,130,"请选择您的好友","HeiTi",15,0x330000,true);
			priChatFriTF.vAlign = VAlign.TOP;
			priChatFriTF.hAlign = HAlign.LEFT;
			priChatFriTF.x = 680;
			priChatFriTF.y = 10;
			priChatFriTF.visible = false;
			view.addChild(priChatFriTF);
			


			input = new TextFieldHasKeyboard();
			input.name = "input";
			input.defaultTextFormat = new TextFormat("HeiTi",18);
			input.maxChars = 33;
			input.width = 650;
			input.height = 25;
			input.x = 367;
			input.y = -240;
			input.addEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			Starling.current.nativeOverlay.addChild(input);
			talkProxy = facade.retrieveProxy(TalkingProxy.NAME) as TalkingProxy;
			

			
			
			talk2AllBtn = new starling.display.Button(Assets.getAtlasTexture("talkingBox_selTalkBtn"));
			talk2AllBtn.fontName = "HeiTi";
			talk2AllBtn.fontColor = 0xa29079;
			talk2AllBtn.fontSize = 20;
			talk2AllBtn.fontBold = true;
			talk2AllBtn.text = "Talk";
			talk2AllBtn.x = 101;
			talk2AllBtn.y = 160;
			talk2AllBtn.addEventListener(Event.TRIGGERED,talk2AllBtnHandle);
			view.addChild(talk2AllBtn);
			
			talk2NpcBtn = new starling.display.Button(Assets.getAtlasTexture("talkingBox_unSeltalkBtn"));
			talk2NpcBtn.fontName = "HeiTi";
			talk2NpcBtn.fontColor = 0xa29079;
			talk2NpcBtn.fontBold = true;
			talk2NpcBtn.text = Global.user;
			talk2NpcBtn.x = 101;
			talk2NpcBtn.y = 197;
			talk2NpcBtn.addEventListener(Event.TRIGGERED,talk2NpcBtnHandle);
			view.addChild(talk2NpcBtn);
			
			

			var closeBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("flip/closeGuide"));
			closeBtn.x = bg.width;
			closeBtn.scaleX = 0.8;
			closeBtn.scaleY = 0.8;
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			view.addChild(closeBtn);
			
			var inputSendBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("talkingBox_inputSendBtn"));
			inputSendBtn.x = 860;
			inputSendBtn.y = 240;
			inputSendBtn.addEventListener(Event.TRIGGERED,inputSendBtnHandle);
			view.addChild(inputSendBtn);
			
			
			var showfaceBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("talkingBox_faceInputBtn"));
			showfaceBtn.x = 115;
			showfaceBtn.y = 240;
			showfaceBtn.addEventListener(Event.TRIGGERED,showFaceHandler);
			view.addChild(showfaceBtn); 
			
			
			createHuman();
			
			
			
		}


		
		private function showFaceHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SysFacePanelMediator,input,SwitchScreenType.SHOW,Global.stage,input.x,input.y-236)]);
		}
		private var humanSC:Scroller;
		private var humanName:TextField;
		private function createHuman():void{
			actionList = getActionList();
			faceList = getFaceList();
			
			
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,Global.myDressList,new Rectangle());
			charaterSp.addChild(charater.view);
			charater.view.x = 0;
			charater.view.y = 0;
			charaterSp.x = 71;
			charaterSp.y = 137;
			charaterSp.scaleX = 2;
			charaterSp.scaleY = 2;
			
			humanSC = new Scroller();
			humanSC.x = 30;
			humanSC.y = 13;
			humanSC.width = 120;
			humanSC.height = 130;
			humanSC.isEnabled = false;
			humanSC.addEventListener(TouchEvent.TOUCH,humanSCHandle);
			view.addChild(humanSC);
			var viewPort:LayoutViewPort = new LayoutViewPort();
			humanSC.viewPort = viewPort;
			viewPort.addChild(charaterSp);
			
			humanName = new TextField(120,25,Global.user,"HeiTi",23,0xfeaaaa,true);
			humanName.x= 31;
			humanName.y = 14;
			humanName.hAlign = HAlign.LEFT
			view.addChild(humanName);

		}
		private var charaterSp:Sprite = new Sprite();
		private function humanSCHandle(event:TouchEvent):void{
			if(event.touches[0].phase=="ended"){
				var actionNum:int = int(Math.random()*actionList.length);
				
				charater.actor.playAnimation(actionList[actionNum],7,64,true);
				TweenLite.killTweensOf(delayFun);
				TweenLite.delayedCall(2.5,delayFun);
			}
		}
		private function delayFun():void{
			charater.actor.playAnimation("idle",7,64,true);
		}
		
		
		
		
		
		//群聊
		public function talk2AllBtnHandle(event:Event):void{
			if(talkStyle == "2"){
				npcTalkSP.visible = false;
				
				
				//释放NPC
				sendNotification(WorldConst.STOP_PLAYER_TALKING);
			}else if(talkStyle == "3"){
				privatChatTF.removeFromParent();
				priChatFriTF.visible = false;
				
				talk2AllBtn.upState = Assets.getAtlasTexture("talkingBox_selTalkBtn");
				talk2NpcBtn.upState = Assets.getAtlasTexture("talkingBox_unSeltalkBtn");
				
				
			}
			talkStyle = "1";
			view.addChild(groupChatTF);
			
		}
		//NPC聊天
		public function talk2NpcBtnHandle(event:Event):void{
			if(talkStyle == "1"){
				groupChatTF.removeFromParent();
				
				
				
			}else if(talkStyle == "3"){
				
				privatChatTF.removeFromParent();
				priChatFriTF.visible = false;
				
			}
			npcTalkSP.visible = true;
			talkStyle = "2";
			
			talk2AllBtn.upState = Assets.getAtlasTexture("talkingBox_unSeltalkBtn");
			talk2NpcBtn.upState = Assets.getAtlasTexture("talkingBox_selTalkBtn");
		}

		
		
		public function closeBtnHandle(event:Event):void{
			TweenLite.to(view,0.3,{y:-450});
			TweenLite.to(input,0.3,{y:-183});
			input.text = "";
			groupChatTF.text = "";
			isShow = false;
		}
		private function inputSendBtnHandle(event:Event):void{
			doSend();
		}
		private function inputHandle(e:KeyboardEvent):void
		{
			if(e.keyCode==13){
				doSend();
			}						
		}
		private function doSend():void{
			var player:ICharater = (facade.retrieveMediator(MyCharaterInforMediator.NAME) as MyCharaterInforMediator).playerCharater;
			//广播
			if(talkStyle == "1"){
								
				if(input.text != ""){
					talkProxy.playerSay(player,input.text);
					sendNotification(WorldConst.MYCHARATER_SAY,input.text);
					setAllTalkRecord("我",input.text);
				}
			}else if(talkStyle == "2"){ //npc对话
				if(talkProxy.npc != null){
					if(input.text != ""){
						setNPCTalkRecord("me",input.text);
						talkProxy.playerSay(player,input.text);
						
						sendNotification(WorldConst.SEND_SIMSIMI_MSG,new SendSimSimiMessageCommandVO(input.text));
					}
				}else{
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,640,381,null,"请先选中一位人物。"));
				}
				
			}else if(talkStyle == "3"){
				if(input.text != ""){
					
					setFriTalkRecord(Global.player.realName,input.text,getNowTime());
				}
			}
			
			
			input.text = "";
		}
		private function getNowTime():String{
			var date:Date = new Date();
			
			return date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.hours+":"+date.minutes+":"+date.seconds;
		}
		//设置讲话内容——广播
		public function setAllTalkRecord(name:String,talkStr:String):void{
			gcRecordStr += name+"： "+talkStr+"\n\n";
			
			//只记录300个字符
			if(gcRecordStr.length>1000){
				gcRecordStr = gcRecordStr.substring(gcRecordStr.indexOf("\n\n")+1);
			}else
				groupChatTF.verticalScrollPosition += 20;
			if(isShow){
				groupChatTF.scrollToPageIndex(0,groupChatTF.verticalScrollPosition+1,1);

				groupChatTF.text = gcRecordStr;
				groupChatTF.textFormat = tf;
								
			}
		}
		//设置讲话内容——NPC对话
		private function setNPCTalkRecord(name:String,talkStr:String):void{
			var strTF:TextFieldExtends = new TextFieldExtends(385,30,talkStr,"HeiTi",18);
			strTF.height += (int(talkStr.length/21))*32;
			strTF.hAlign = HAlign.LEFT;
			strTF.vAlign = VAlign.TOP;
			
			var labImg:Scale9Image;
			var headImg:Image = new Image(headIconTexture);
			if(name == "me"){
				labImg = new Scale9Image(leftLabTexture);
				labImg.x = headImg.width;
				
				headImg.x = -headImg.width;
				view.addChild(headImg);
				headImg.x+=labImg.x;
				
				strTF.x = 30;
			}else{
				labImg = new Scale9Image(rightLabTexture);
				labImg.x = talkViewPort.width-labImg.width-headImg.width;
				
				headImg.x = labImg.width+headImg.width;
				headImg.scaleX = -1;
				view.addChild(headImg);
				headImg.x+=labImg.x;
				strTF.x = 10;
			}
			strTF.y = 3;
			headImg.y = strTF.height-headImg.height;
			labImg.height = strTF.height;
			labImg.y = getLabHeight();
			
			talkViewPort.addChild(labImg);
			labImgList.push(labImg);
			
			
			//超过16条记录，清楚前8条。
			if(labImgList.length > 12){
				labImgList.splice(0,6);
				
//				while(talkViewPort.numChildren > 0){
//					talkViewPort.removeChildAt(talkViewPort.numChildren-1);
//				}
//				
				talkViewPort.removeChildren();
				for(var i:int=0;i<labImgList.length;i++){
					labImgList[i].y = getLabHeight();
					talkViewPort.addChild(labImgList[i]);
				}
			}
			
			TweenLite.delayedCall(0.1,function start():void{
				view.addChild(strTF);
				strTF.x+=labImg.x;
				if(scroll.maxVerticalScrollPosition != 0)
					scroll.verticalScrollPosition = scroll.maxVerticalScrollPosition;
			});
		}
		//私聊
		private function setFriTalkRecord(name:String,talkStr:String,time:String):void{
			
			pcRecordStr += name+"   "+ time + "\n" + talkStr + "\n\n";
			
			privatChatTF.text = pcRecordStr;
			privatChatTF.textFormat = tf;
			
			privatChatTF.verticalScrollPosition += 20;
		}
		
		private function createTalkHolder():void{
			leftLabTexture = new Scale9Textures(Assets.getAtlasTexture("talkingBox_npcTalk_left"),new Rectangle(10,10,380,15));
			rightLabTexture = new Scale9Textures(Assets.getAtlasTexture("talkingBox_npcTalk_right"),new Rectangle(10,10,380,15));
			headIconTexture = Assets.getAtlasTexture("talkingBox_headIcon");
			labImgList = new Vector.<Scale9Image>;
			talkViewPort = new LayoutViewPort();
			scroll = new Scroller();

			scroll.x = 177;
			scroll.y = 5;
			scroll.width = 700;
			scroll.height = 220;

			scroll.viewPort = talkViewPort;
			npcTalkSP.addChild(scroll);
		}
		private function getLabHeight():Number{
			var height:Number =0 ;
			for(var i:int=0;i<talkViewPort.numChildren;i++){
				height+= talkViewPort.getChildAt(i).height+15;
			}
			return height;
		}
		
		//获取所有动作 	
		private function getActionList():Vector.<String>{
			var actionList:Vector.<String> =  new Vector.<String>;
			var actionXml:XML;
			var boneName:String = "";
			
			actionXml = getFile("textures/MHumanSK.sk");
			for each (var i:XML in actionXml.animation) 
			{
				actionList.push(i.@name);
			}
			return actionList;
		}
		
		//获取所有表情 	
		private function getFaceList():Vector.<String>{
			var faceList:Vector.<String> =  new Vector.<String>;
			var suitXml:XML;
			
			suitXml = getFile("charater/captain.xml");
			for each (var i:XML in suitXml.children()) 
			{
				var equipList:XMLList = i.equipment;
				if(equipList.length()){
					for each(var j:XML in equipList){
						if(j.@name == "face"){
							var itemList:XMLList = j.item;
							if(itemList.length()){
								for each(var k:XML in itemList){
									faceList.push(k.@name);
								}
							}
						}
					}
				}
			}
			return faceList;
		}
		//读文件	
		private function getFile(fileName:String):XML{
			var file:File = Global.document.resolvePath(Global.localPath+"/media/"+fileName);
			var fstream:FileStream = new FileStream();
			fstream.open(file,FileMode.READ);
			
			var xml:XML = XML(fstream.readMultiByte(fstream.bytesAvailable,PackData.BUFF_ENCODE));
			fstream.close();
			
			return xml;
		}

		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(name)
			{
				
				case WorldConst.REC_SIMSIMI_MSG:
				{
					input.text = "";
					
					var idx:int=0;
					var sentence:String = notification.getBody() as String;
					var i:int=0;
					var oldIdx:int;
					var nextStr:String;
					TweenLite.killTweensOf(talkProxy.npcSay);
					while(idx<sentence.length){
						
						oldIdx = idx;
						idx+=15;
						
						if(idx<sentence.length){
							nextStr = sentence.substr(oldIdx,15);
						}else{
							nextStr = sentence.substring(oldIdx);
						}
						
						TweenLite.delayedCall(i*4,talkProxy.npcSay,[nextStr]);
						i++;
						
						
						
					}
					if(sentence.length > 0)
						setNPCTalkRecord("npc",sentence);
					
					break;
				}
				case WorldConst.STOP_PLAYER_TALKING:{
					if(talkStyle == "2"){
						npcTalkSP.visible = false;
						view.addChild(groupChatTF);
						talk2NpcBtn.upState = Assets.getAtlasTexture("talkingBox_unSeltalkBtn");
						talk2AllBtn.upState = Assets.getAtlasTexture("talkingBox_selTalkBtn");
						
//						isTalk2All = true;
						
						talkStyle = "1";
					}
					
					
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.REC_SIMSIMI_MSG,WorldConst.STOP_PLAYER_TALKING];
		}
		
	}
}