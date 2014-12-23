package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.ui.music.MusicHopeMediator;
	import com.studyMate.world.screens.ui.music.MusicMarketItemRenderer;
	import com.studyMate.world.screens.ui.music.MusicMarketItemVO;
	import com.studyMate.world.screens.ui.music.SearchMusicAlertMediator;
	import com.studyMate.world.screens.view.EduAlertMediator;
	
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.utils.getTimer;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	
	public class MusicMarketMediator extends ScreenBaseMediator
	{		
		public static const NAME:String = "MusicMarketMediator";
		
		private const GET_MONEY:String = NAME+"getMoney";
		private const GET_ALL_MARKET:String = NAME+"GET_ALL_MARKET";
		private const GET_SEARCH_MARKET:String = NAME + "GET_SEARCH_MARKET";
		
		public static const RECIVE_BUY_BUTTON:String = "RECIVE_BUY_BUTTON";
		public static const SEARCH_MUSIC:String = "SEARCH_MUSIC";
		private const yesBuyHandler:String = NAME+"yesBuyHandler";
		private const DETAIL_INFO:String = NAME + "DETAIL_INFO";
		private const COMPLETE_APPLY:String = NAME + "COMPLETE_APPLY";
		
		private var hasNewBuy:Boolean;
		
		private var currentBuyItem:MusicMarketItemVO;		
		private var goldTxt:TextField;
		private var sorryTxt:TextField;
		private var tabs:TabBar;	
		
		private var marketList:List;//列表组件
		
		private var allListCollection:ListCollection = new ListCollection;
		
		private var searchListCollection:ListCollection=new ListCollection;
		
		public function MusicMarketMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);	
		}
		
		override public function onRegister():void{
			//			SoundAS.loadSound(MyUtils.getSoundPath("wordRight.mp3"),"wordRight");
			
			
			var bg:Image = new Image(Assets.getTexture("musicMarketBg"));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);
			
			goldTxt = new TextField(124,38,"0","HeiTi",26,0xFFFFFF);
			goldTxt.autoScale = true;
			goldTxt.x = 74;
			goldTxt.y = 20;
			view.addChild(goldTxt);
			
			tabs = new TabBar();
			tabs.selectedIndex = 0;			
			tabs.x = 275;
			tabs.y = 38;
			tabs.direction = TabBar.DIRECTION_HORIZONTAL;
			tabs.gap = 1.4;
			tabs.dataProvider = new ListCollection(
				[					
					{label: "最新"} , 
					{label: "全部" }, 
					{label:"未购买"},
					{label: "许愿"},
					{label: "搜索"}  					
				]);
			tabs.customTabName = "MusicMarketTabBar";
			tabs.tabFactory = tabButtonFactory;
			tabs.tabProperties.stateToSkinFunction = null;	
			var boldFontDescription:FontDescription = new FontDescription("HuaKanT",FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
//			tabs.tabProperties.@defaultLabelProperties.textFormat = new TextFormat("HuaKanT", 30, 0x76C802,true);
//			tabs.tabProperties.@defaultLabelProperties.embedFonts = true;			
//			tabs.tabProperties.@defaultSelectedLabelProperties.textFormat = new TextFormat("HuaKanT", 30, 0x8E6BF8,true);
//			tabs.tabProperties.@defaultSelectedLabelProperties.embedFonts = true;
			tabs.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 30, 0x76C802);
			tabs.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription, 30, 0x8E6BF8)
			view.addChild(tabs);
			
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("wordRight.mp3"),"wordRight"));						
			sendinServerInofFunc(CmdStr.GET_MONEY,GET_MONEY,[PackData.app.head.dwOperID.toString(),"SYSTEM.SMONEY"]);		
			
			
		}
		private function clearList():void{
			if(marketList){
				marketList.stopScrolling();
				marketList.removeFromParent(true);
			}			
		}
		private function initList():void{
			marketList = new List();
			marketList.x = 270;
			marketList.y = 118;
			marketList.width = 882;
			marketList.height = 608;
			marketList.itemRendererType = MusicMarketItemRenderer;
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 60;		
			layout.paddingBottom =100;
			marketList.layout = layout;
			view.addChild( marketList );	
		}
		private function tabButtonFactory():feathers.controls.Button{
			var tab:ToggleButton = new ToggleButton();
			tab.defaultSkin = new Image(Assets.getMusicSeriesTexture("tabBardefault"));
			tab.defaultSelectedSkin = new Image(Assets.getMusicSeriesTexture("tabBarSelect"));
			tab.downSkin = new Image(Assets.getMusicSeriesTexture("tabBarSelect"));
			return tab;
		}	
		
		private function tabs_changeHandler( event:Event ):void{
			if(sorryTxt){
				view.removeChild(sorryTxt);
				//sorryTxt.dispose();
				sorryTxt = null;
			}
			clearList();
			initList();
			
			var tabs:TabBar = TabBar( event.currentTarget );
			switch(tabs.selectedIndex){
				case 0://最新
					allListCollection.removeAll();
					marketList.dataProvider = allListCollection;
//					tabs.touchable = false;
					enableBtnHandler(false);
					sendinServerInofFunc(CmdStr.NEW_MARK_MUSIC,GET_ALL_MARKET,["","MUSIC","*","*","",PackData.app.head.dwOperID.toString()],SendCommandVO.QUEUE);															
					break;
				case 1://全部
					allListCollection.removeAll();
					marketList.dataProvider = allListCollection;
//					tabs.touchable = false;
					enableBtnHandler(false);
//					trace("startTime",getTimer());
					sendinServerInofFunc(CmdStr.ALL_MARK_MUISC,GET_ALL_MARKET,["","MUSIC","*","*","",PackData.app.head.dwOperID.toString()],SendCommandVO.QUEUE);									
					break;
				case 2://未购买
					allListCollection.removeAll();
					marketList.dataProvider = allListCollection;
//					tabs.touchable = false;
					enableBtnHandler(false);
					sendinServerInofFunc(CmdStr.NOT_BUY_MUSIC,GET_ALL_MARKET,["","MUSIC","*","*","",PackData.app.head.dwOperID.toString()],SendCommandVO.QUEUE);	
					break;
				/*case 3://许愿
				marketList.stopScrolling();
				allListCollection.removeAll();
				searchListCollection.removeAll();
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MusicHopeMediator,null,SwitchScreenType.SHOW)]);
				break;*/
			}
		}
		
		private function tabsTouchHandler(event:TouchEvent):void{
			if(event.touches[0].phase=="ended"){	
				if(tabs.selectedIndex ==3){
					if(sorryTxt){
						view.removeChild(sorryTxt);
						//sorryTxt.dispose();
						sorryTxt = null;
					}
					clearList();
					initList();
					allListCollection.removeAll();
					searchListCollection.removeAll();
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MusicHopeMediator,null,SwitchScreenType.SHOW)]);
				}
				if(tabs.selectedIndex==4){
					if(sorryTxt){
						view.removeChild(sorryTxt);
						//sorryTxt.dispose();
						sorryTxt = null;
					}
					clearList();
					initList();
					marketList.dataProvider = searchListCollection;
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SearchMusicAlertMediator,null,SwitchScreenType.SHOW)]);
				}
			}
		}
		
		override public function onRemove():void{
			currentBuyItem = null;
			allListCollection = null;
			searchListCollection = null;
			marketList.removeChildren(0,-1,true);
			//			SoundAS.removeSound("wordRight");
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'wordRight');
			
			view.removeChildren(0,-1,true);
			
			if(hasNewBuy){
				CacheTool.put(MusicMarketMediator.NAME,"hasNewBuy",true);//有新货购买
			}else{
				CacheTool.put(MusicMarketMediator.NAME,"hasNewBuy",false);//无新货购买
			}
			super.onRemove();
		}
		
//		private var tempVec:Vector.<MusicMarketItemVO> = new Vector.<MusicMarketItemVO>;
		private var tempVec:ListCollection=new ListCollection();
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_MONEY:
					if(!result.isErr){
						tabs.addEventListener( Event.CHANGE, tabs_changeHandler );
						tabs.addEventListener(TouchEvent.TOUCH,tabsTouchHandler);
						goldTxt.text = PackData.app.CmdOStr[4];
						
						clearList();
						initList();
						marketList.dataProvider = allListCollection;
						tabs.touchable = false;
						sendinServerInofFunc(CmdStr.NEW_MARK_MUSIC,GET_ALL_MARKET,["","MUSIC","*","*","",PackData.app.head.dwOperID.toString()],SendCommandVO.QUEUE);
					}else{
						sendNotification(CoreConst.TOAST,new ToastVO("获取金币出错，请后退重新进入该界面."));
					}
					break;
				case GET_ALL_MARKET:
					if(!result.isEnd && !result.isErr){//接收																
						var markItemSpVO:MusicMarketItemVO = new MusicMarketItemVO(PackData.app.CmdOStr);						
						tempVec.addItem(markItemSpVO);
						
						if(tempVec.length>100){
							allListCollection.addAll(tempVec);
							tempVec.removeAll();
						}
									
					}if(result.isEnd){//接收{
						if(tempVec.length>0){							
							allListCollection.addAll(tempVec);
							tempVec.removeAll();
						}
;	
						if(allListCollection.length==0){
							if(sorryTxt==null){
								
								sorryTxt = new TextField(450,60,"没有找到相应的歌曲。","HeiTi",26,0xFFFFFF);
								sorryTxt.x = 270;
								sorryTxt.y = 117;
								view.addChild(sorryTxt);
							}
						}
						sendNotification(WorldConst.VIEW_READY);
						
						enableBtnHandler(true);
						
						
//						trace("endTime",getTimer());
					}
					break;
				
				case SEARCH_MUSIC:
					searchListCollection.removeAll();					
					sendinServerInofFunc(CmdStr.ALL_MARK_MUISC,GET_SEARCH_MARKET,[notification.getBody(),"MUSIC","*","*","",PackData.app.head.dwOperID.toString()]);		
					break;;
				case GET_SEARCH_MARKET:
					if(!result.isEnd){//接收															
						markItemSpVO = new MusicMarketItemVO(PackData.app.CmdOStr);				
						searchListCollection.push(markItemSpVO);
					}else if(result.isEnd){//接收	
						clearList();
						initList();
						marketList.dataProvider = searchListCollection;
						
						enableBtnHandler(true);
						if(searchListCollection.length==0){
							if(sorryTxt==null){
								
								sorryTxt = new TextField(450,60,"没有找到相应的歌曲。","HeiTi",26,0xFFFFFF);
								sorryTxt.x = 270;
								sorryTxt.y = 117;
								view.addChild(sorryTxt);
							}
						}else{
							if(sorryTxt){
								view.removeChild(sorryTxt);
								//sorryTxt.dispose();
								sorryTxt = null;
							}
						}
					}
					break;
				case RECIVE_BUY_BUTTON:
					if(facade.hasMediator(EduAlertMediator.NAME)) return;//一个小bug。禁屏失效的bug。
					currentBuyItem = notification.getBody() as MusicMarketItemVO;					
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo(
						"<br><font face='HeiTi' size='24'>您要花</font>"+
						"<font color='#0033FF' face='HeiTi' size='24'>"+currentBuyItem.goodsCost+ "</font>" +
						"<font face='HeiTi' size='24'>"+"金币购买</font><br>"+
						"<font color='#0033FF' face='HeiTi' size='24'>\""+currentBuyItem.goodsName+"\"</font>" +
						"<font face='HeiTi' size='24'>吗？</font>"
						,true,yesBuyHandler,"",true));//提交订单
					break;
				case yesBuyHandler:
					sendinServerInofFunc(CmdStr.QUERY_MARK_FRAME_INFO,DETAIL_INFO,[currentBuyItem.frameId,"*","*","*","*"]);//详细信息					
					break;
				case DETAIL_INFO://获取商品id
					if((PackData.app.CmdOStr[1] as String) == "MARKINFO"){
						currentBuyItem.goodsId = PackData.app.CmdOStr[4];
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){//购买命令
						sendinServerInofFunc(CmdStr.MARK_APPLY,COMPLETE_APPLY,["UBMF",PackData.app.head.dwOperID.toString(),Global.user,"0","",PackData.app.head.dwOperID.toString(),currentBuyItem.frameId,currentBuyItem.goodsId]);						
					}
					break;
				case COMPLETE_APPLY:
					if((PackData.app.CmdOStr[0] as String) == "001"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n您的余额不足,购买失败.",false));
					}else if((PackData.app.CmdOStr[0] as String) == "000"){
						//						SoundAS.play("wordRight",0.7);	
						sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordRight",0.7));
						
						goldTxt.text = PackData.app.CmdOStr[1];
						updateBuyIcon()
						hasNewBuy = true;
					}else if((PackData.app.CmdOStr[0] as String) == "0M2"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n您已拥有该音乐,请重新选择.",false));
						updateBuyIcon()
					}else if((PackData.app.CmdOStr[0] as String) == "M"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n系统出错,请稍后再买.",false));
					}					
					break;				
			}
		}		
		override public function listNotificationInterests():Array{
			return [GET_MONEY,GET_ALL_MARKET,GET_SEARCH_MARKET,RECIVE_BUY_BUTTON,yesBuyHandler,DETAIL_INFO,COMPLETE_APPLY,SEARCH_MUSIC];
		}
		
		public function updateBuyIcon():void{
			currentBuyItem.hasBuy = "1"
			if(tabs.selectedIndex==3 || tabs.selectedIndex==4){
				searchListCollection.updateItemAt(searchListCollection.getItemIndex(currentBuyItem));
			}else{
				allListCollection.updateItemAt(allListCollection.getItemIndex(currentBuyItem));		
			}
		}
		
		public function enableBtnHandler(boo:Boolean):void{	
			tabs.touchable = boo;
			if(marketList && marketList.dataProvider){				
				var len:int = marketList.dataProvider.length;
				for(var i:int=0;i<len;i++){
					(marketList.dataProvider.getItemAt(i) as MusicMarketItemVO).enable = boo;
					marketList.dataProvider.updateItemAt(i);
				}
			}
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		
		private function sendinServerInofFunc(command:String,reveive:String,infoArr:Array,type=SendCommandVO.NORMAL):void{				
			PackData.app.CmdIStr[0] = command;
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+1] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+1;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive,null,'cn-gb',null,type));	//派发调用绘本列表参数，调用后台
		}		
	}
}