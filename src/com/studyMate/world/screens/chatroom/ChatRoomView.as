package com.studyMate.world.screens.chatroom
{
	import com.greensock.TweenLite;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.HappyIslandMediator;
	
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Label;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.text.BitmapFontTextFormat;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ChatRoomView extends Sprite
	{
		internal var tabBar:TabBar;
		internal var header:Image;
		internal var wtalkTitle:Image;
		internal var ptaklTitle:TextField;
		internal var mainSp:Sprite;
		internal var perInfoBtn:Button;
		internal var wchistoryBtn:Button;
		internal var pchistoryBtn:Button;
		
		internal var tipSp:Sprite;
		private var pcTips:Image;
		internal var tipsTF:TextField;
		
		public function ChatRoomView()
		{
			super();
			
			var bg:Quad = new Quad(1280,800,0xbfe8ec);
//			bg.alpha = 0.5;
			addChild(bg);
			
			
			initTabBar();
			initMainSp();
			
			initPTalkUI();
			initWTalkSp();
			initSearchSp();
			
			
			tipSp = new Sprite;
			tipSp.visible = false;
			
			addChild(tipSp);
			pcTips = new Image(Assets.getChatViewTexture("firMessNum"));
			pcTips.x = 3;
			pcTips.y = 240;
			tipSp.addChild(pcTips);
			
			tipsTF = new TextField(20,15,"2","HeiTi",12,0xffffff,true);
			tipsTF.x = 3;
			tipsTF.y = 240;
//			tipsTF.border = true;
			tipSp.addChild(tipsTF);
		}
		
		private function initTabBar():void{
			tabBar = new TabBar();
			tabBar.x = -2;
			tabBar.y = 57;
			tabBar.gap= 12;
			tabBar.dataProvider = new ListCollection(
				[				
					{ label: "" ,type:0 ,
						defaultIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_wtalk_up")) ,
						defaultSelectedIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_wtalk_down")),
						downIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_wtalk_down"))},
					{ label: "" ,type:1 ,
						defaultIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_ptalk_up")) ,
						defaultSelectedIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_ptalk_down")),
						downIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_ptalk_down"))},
					{ label: "" ,type:2 ,
						defaultIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_searchFri_up")) ,
						defaultSelectedIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_searchFri_down")),
						downIcon:new Image(Assets.getChatViewTexture("chatRoom/tab_searchFri_down"))},
				]);
			tabBar.addEventListener(Event.CHANGE, tabBarChangeHandler);
			tabBar.validate();
			addChild(tabBar);
			
			tabBar.direction = TabBar.DIRECTION_VERTICAL;
			tabBar.customTabName = "tabBar";
			tabBar.tabProperties.stateToSkinFunction = null;
			
			
		}
		public function hideWCTab():void{
			TweenLite.delayedCall(0.5,function ():void{
				if(tabBar && tabBar.numChildren > 0 && tabBar.getChildAt(0)){
					/*tabBar.getChildAt(0).touchable = false;
					tabBar.getChildAt(0).alpha = 0.6;*/
					tabBar.getChildAt(0).visible = false;
				}
			});
			
			
		}
		
		
		
		private function initMainSp():void{
			mainSp = new Sprite;
			mainSp.x = 60;
			mainSp.y = 9;
			addChild(mainSp);
			
			var bg:Image = new Image(Assets.getTexture("chatRoomBg"));
			mainSp.addChild(bg);
			
			//标题栏
			header = new Image(Assets.getChatViewTexture("chatRoom/header"));
			header.x = -3;
			header.y = -5;
			mainSp.addChild(header);
			
			
			
			
		}
		
		
		//私聊容器
		public var ptalkSp:Sprite = new Sprite;
		private var pInputSp:PInputSprite;	//私聊输入框容器
		
		//广播容器
		public var wtalkSp:Sprite = new Sprite;
		private var wInputSp:WInputSprite;	//广播输入容器
		
		//搜索容器
		public var searchSp:Sprite = new Sprite;
		public var search:SearchSprite;
		public var searchNonTips:Image;
		
		
		private function initPTalkUI():void{
			
			ptalkSp = new Sprite;
			ptalkSp.x = 325;
			ptalkSp.y = 9;
			ptalkSp.visible = false;
			addChild(ptalkSp);
			
			
//			pInputSp = new PInputSprite;
//			pInputSp.y = 640;
//			ptalkSp.addChild(pInputSp);
			
			
			//私聊提示
			ptaklTitle = new TextField(250,30,"","HeiTi",22,0x6e421b,true);
			ptaklTitle.x = (((mainSp.width-267) - ptaklTitle.width)>>1);
			ptaklTitle.y = 15;
			ptaklTitle.touchable = false;
			ptaklTitle.vAlign = VAlign.CENTER;
			ptaklTitle.hAlign = HAlign.CENTER;
			ptalkSp.addChild(ptaklTitle);
			
			//好友资料按钮
			perInfoBtn = new Button(Assets.getChatViewTexture("chatRoom/friInfoBtn"));
			perInfoBtn.x = (mainSp.width-267) - perInfoBtn.width-35;
			ptalkSp.addChild(perInfoBtn);
			
			pchistoryBtn = new Button(Assets.getChatViewTexture("chatRoom/historyBtn"));
//			historyBtn.x = ((mainSp.width-52) - wtalkTitle.width)>>1;
			pchistoryBtn.x = (mainSp.width-267)- perInfoBtn.width - 150;
			pchistoryBtn.y = 30;
			ptalkSp.addChild(pchistoryBtn);
		}
		
		private function initWTalkSp():void{
			wtalkSp = new Sprite;
			wtalkSp.x = 72;
			wtalkSp.y = 9;
			addChild(wtalkSp);
			
//			wInputSp = new WInputSprite;
//			wInputSp.y = 630;
//			wtalkSp.addChild(wInputSp);
			
			
			
			
			
			
			
			
			//群聊提示
			wtalkTitle = new Image(Assets.getChatViewTexture("chatRoom/wtalkingTips"));
			wtalkTitle.x = ((mainSp.width-12) - wtalkTitle.width)>>1;
			wtalkTitle.y = 15;
			wtalkSp.addChild(wtalkTitle);
			
			wchistoryBtn = new Button(Assets.getChatViewTexture("chatRoom/historyBtn"));
//			historyBtn.x = ((mainSp.width-52) - wtalkTitle.width)>>1;
			wchistoryBtn.x = mainSp.width- wtalkTitle.width - 50;
			wchistoryBtn.y = 30;
			wtalkSp.addChild(wchistoryBtn);
		}
		
		
		
		
		private function initSearchSp():void{
			
			searchSp = new Sprite;
			searchSp.x = 109;
			searchSp.y = 53;
			searchSp.visible = false;
			searchSp.alpha = 0;
			addChild(searchSp);
			
			
			//背景
			var resultBg:Image = new Image(Assets.getTexture("chatRoomSearchBg"));
			resultBg.y = 125;
			searchSp.addChild(resultBg);
			
			search = new SearchSprite;
			search.visible = false;
			searchSp.addChild(search);
			
			searchNonTips = new Image(Assets.getChatViewTexture("chatRoom/searchNothing"));
			searchNonTips.x = 165;
			searchNonTips.y = 327;
			searchNonTips.visible = false;
			searchSp.addChild(searchNonTips);
		}
		
		private var _perlistSp:PersonListSprite;
		public function set perlistSp(val:PersonListSprite):void{
			_perlistSp = val;
		}
		public function get perlistSp():PersonListSprite{
			return _perlistSp;
		}
		
		public var _pcVoiChat:VoicechatComponent;
		public function set pcVoiChat(val:VoicechatComponent):void{
			_pcVoiChat = val;
		}
		public function get pcVoiChat():VoicechatComponent{
			return _pcVoiChat;
		}
		
		
		private var _wcVoiChat:VoicechatComponent;
		public function set wcVoiChat(val:VoicechatComponent):void{
			_wcVoiChat = val;
		}
		public function get wcVoiChat():VoicechatComponent{
			return _wcVoiChat;
		}
		
		public function selePerson(_id:int):void{
			
			tabBar.selectedIndex = 1;
			TweenLite.delayedCall(0.5,function():void{
				
				perlistSp.selectPerson(_id);
			});
			
		}
		
		
		
		private function tabBarChangeHandler(event:Event):void{
			
			if(tabBar.selectedItem.type == 0){
				header.visible = true;
				
				wtalkSp.visible = true;
				ptalkSp.visible = false;
				searchSp.visible = false;
				searchSp.alpha = 0;
				search.visible = false;
				wcVoiChat.visible = true;
				pcVoiChat.visible = false;
//				wcVoiChat.viewVisible = true;
//				pcVoiChat.viewVisible = false;
//				pInputSp.hide();
//				wInputSp.show();
				
				TweenLite.to(perlistSp,0.2,{x:-300});
				
			}else if(tabBar.selectedItem.type == 1){
				header.visible = true;
				
				wtalkSp.visible = false;
				ptalkSp.visible = true;
				searchSp.visible = false;
				search.visible = false;
				searchSp.alpha = 0;
				
				wcVoiChat.visible = false;
				pcVoiChat.visible = true;
//				wcVoiChat.viewVisible = false;
//				pcVoiChat.viewVisible = true;
//				pInputSp.show();
//				wInputSp.hide();
				tipSp.visible = false;
				//如果有选择，则点击一次，调用查看聊天方法
				var selectItem:PersonListItem = perlistSp.selectItem;
				if(selectItem)
				{
					perlistSp.doItemClick(selectItem);
				}
				
				
				TweenLite.to(perlistSp,0.2,{x:0});
				
			}else{
				header.visible = false;
				
				wtalkSp.visible = false;
				ptalkSp.visible = false;
				searchSp.visible = true;
				search.visible = true;
				TweenLite.killTweensOf(searchSp);
				TweenLite.to(searchSp,0.5,{alpha:1});
				
				wcVoiChat.visible = false;
				pcVoiChat.visible = false;
//				wcVoiChat.viewVisible = false;
//				pcVoiChat.viewVisible = false;
//				pInputSp.hide();
//				wInputSp.hide();
				
				TweenLite.to(perlistSp,0.2,{x:-300});
			}
			
			
		}
		
		public function show(_idx:int=0):void{
			tabBar.selectedIndex = _idx;
			tabBarChangeHandler(null);
			
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
			TweenLite.killTweensOf(searchSp);
			
			tabBar.removeEventListener(Event.CHANGE, tabBarChangeHandler);
			
			removeChildren(0,-1,true);
			
		}
	}
}