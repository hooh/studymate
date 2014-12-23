package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.item.MarketItemInfoVO;
	import com.mylib.game.charater.item.MarketItemSpriteVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import flash.geom.Point;
	
	import feathers.controls.Button;
	import feathers.controls.ToggleButton;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class MarketBuyViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MarketBuyViewMediator";
		private static const QUERY_MARK_FRAME_INFO:String = "QueryMarkframeInfo";
		private static const MARK_APPLY:String = "MarkApply";
		
		private var frameListHolder:Sprite;
		private var selectHolder:Sprite;
		private var quantityTF:TextField;
		private var amountTF:TextField;
		
		private var vo:SwitchScreenVO;
		private var marketItemSpVo:MarketItemSpriteVO;
		private var faceImgTexture:Texture;
		
		private var marketItemInfoVoList:Vector.<MarketItemInfoVO> = new Vector.<MarketItemInfoVO>;
		
		private var buyBtn:starling.display.Button;
		private var localPoint:Point;
		
		public function MarketBuyViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			this.localPoint = vo.data[0];
			this.marketItemSpVo = vo.data[1];
			this.faceImgTexture = vo.data[2];
			
			
			//发命令字，查询商品详细信息
			PackData.app.CmdIStr[0] = CmdStr.QUERY_MARK_FRAME_INFO;
			PackData.app.CmdIStr[1] = marketItemSpVo.frameId;
			PackData.app.CmdIStr[2] = "*";
			PackData.app.CmdIStr[3] = "*";
			PackData.app.CmdIStr[4] = "*";
			PackData.app.CmdIStr[5] = "*";
			PackData.app.CmdInCnt = 6;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QUERY_MARK_FRAME_INFO));
			
			
//			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		


		
		override public function onRegister():void{
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this,true)));
			sendNotification(MarketViewMediator.SET_CPU_INPUT_VISIBLE,false);
			init();
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case QUERY_MARK_FRAME_INFO:
					trace((PackData.app.CmdOStr[0] as String));
					if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						//接收完毕
						if(marketItemInfoVoList.length > 0){
							
							
							
							
							
						}
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}else{
						if((PackData.app.CmdOStr[1] as String) == "MARK"){
							
							
						}else if((PackData.app.CmdOStr[1] as String) == "MARKINFO"){
							//1:N 存储
							var markItemInfoVO:MarketItemInfoVO = new MarketItemInfoVO();
							markItemInfoVO.frameId = PackData.app.CmdOStr[3];
							markItemInfoVO.goodsId = PackData.app.CmdOStr[4];
							markItemInfoVO.goodsName = PackData.app.CmdOStr[5];
							markItemInfoVO.seq = PackData.app.CmdOStr[6];
							markItemInfoVO.goodsCost = PackData.app.CmdOStr[10];
							
							marketItemInfoVoList.push(markItemInfoVO);
						}
					}
					break;
				case MARK_APPLY:
					trace("截获："+PackData.app.CmdOStr[0]);
					if((PackData.app.CmdOStr[0] as String) == "001")
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"您的余额不足，购买失败。"));
					else if((PackData.app.CmdOStr[0] as String) == "000"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"购买成功."));
						sendNotification(WorldConst.UPDATE_MARKET_PER_INFO,[(PackData.app.CmdOStr[1] as String),marketItemSpVo.frameName]);
						
					}else if((PackData.app.CmdOStr[0] as String) == "0M2")
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"选择列表中包含已购买物品，请重新选择。"));
					
					break;
				
			}
		}
		override public function listNotificationInterests():Array{
			return [QUERY_MARK_FRAME_INFO,MARK_APPLY];
		}
		
		private var bg:Image;
		private function init():void{
			bg = new Image(Assets.getTexture("marketBuyBg"));
			bg.x = (1280-bg.width)>>1;
			bg.y = 40;
			view.addChild(bg);
			TweenLite.from(bg,0.2,{alpha:0,scaleX:0,scaleY:0,x:localPoint.x,y:localPoint.y,ease:Linear.easeNone,onComplete:doShow});

		}
		private function doShow():void{
			var faceImg:Image = new Image(faceImgTexture);
			faceImg.x = 325;
			faceImg.y = 240;
			faceImg.width = faceImg.height = 114;
			view.addChild(faceImg);
			
			var titleTF:TextField = new TextField(340,25,marketItemSpVo.frameName,"HuaKanT",23,0xd23b00);
			titleTF.hAlign = HAlign.LEFT;
			titleTF.vAlign = VAlign.BOTTOM;
			titleTF.x = 495;
			titleTF.y = 240;
			view.addChild(titleTF);
			
			var listCountTF:TextField = new TextField(100,25,"共有 "+marketItemInfoVoList.length+" 集","HuaKanT",23,0xd23b00);
			listCountTF.hAlign = HAlign.RIGHT;
			listCountTF.vAlign = VAlign.BOTTOM;
			listCountTF.x = 855;
			listCountTF.y = 240;
			view.addChild(listCountTF);
			
			
			var txtBriefTF:TextField = new TextField(460,100,"","HuaKanT",18,0x6b3c00);
			txtBriefTF.hAlign = HAlign.LEFT;
			txtBriefTF.vAlign = VAlign.TOP;
			txtBriefTF.x = 495;
			txtBriefTF.y = 267;
			view.addChild(txtBriefTF);
			if(marketItemSpVo.txtBrief.length > 100)
				txtBriefTF.text = marketItemSpVo.txtBrief.substr(0,95)+".....";
			else
				txtBriefTF.text = marketItemSpVo.txtBrief;
			
			
			buyBtn = new starling.display.Button(Assets.getMarketTexture("BuyView/sureBuyBtn"));
			buyBtn.x = 400;
			buyBtn.y = 673;
			buyBtn.width = 100;
			buyBtn.height = 60;
			buyBtn.enabled = false;
			buyBtn.addEventListener(Event.TRIGGERED,buyBtnHandle);
			view.addChild(buyBtn);
			
			var cancleBtn:starling.display.Button = new starling.display.Button(Assets.getMarketTexture("BuyView/cancleBuyBtn"));
			cancleBtn.x = 800;
			cancleBtn.y = 673;
			cancleBtn.width = 100;
			cancleBtn.height = 60;
			cancleBtn.addEventListener(Event.TRIGGERED,cancleBtnHandle);
			view.addChild(cancleBtn);
			
			frameListHolder = new Sprite();
			view.addChild(frameListHolder);
			
			selectHolder = new Sprite();
			view.addChild(selectHolder);
			
			quantityTF = new TextField(60,30,"0","HuaKanT",25,0,true);
			quantityTF.hAlign = HAlign.CENTER;
			quantityTF.vAlign = VAlign.CENTER;
			quantityTF.x = 540;
			quantityTF.y = 590;
			view.addChild(quantityTF);
			
			amountTF = new TextField(90,30,"0","HuaKanT",25,0,true);
			amountTF.hAlign = HAlign.CENTER;
			amountTF.vAlign = VAlign.CENTER;
			amountTF.x = 780;
			amountTF.y = 590;
			view.addChild(amountTF);
			
			
			createListHolder();
			createSelectHolder();
		}
		private function createSelectHolder():void{
			var selectAllBtn:starling.display.Button = new starling.display.Button(Assets.getMarketTexture("BuyView/selectAllBtn"));
			selectAllBtn.x = 347;
			selectAllBtn.y = 550;
			selectAllBtn.addEventListener(Event.TRIGGERED,selectAllBtnHandle);
			view.addChild(selectAllBtn);
		}
		
		
		
		private var btnList:Vector.<Button> = new Vector.<Button>;
		private function createListHolder():void{
			var btn:ToggleButton;
//			var seq:int;
			
			for(var i:int=0;i<marketItemInfoVoList.length;i++){
				btn = new ToggleButton();
//				seq = int(marketItemInfoVoList[i].seq);
				if(i<10)
					btn.label = "0"+(i+1);
				else
					btn.label = (i+1).toString();
				
				btn.width = 50;
				btn.height = 41;
				
				btn.x = 347 + 63*(i%10);
				btn.y = 380 + 50*(int(i/10));
				
				frameListHolder.addChild(btn);

				btn.defaultSkin = new Image(Assets.getMarketTexture("BuyView/ItemUpSkin"));
				btn.downSkin = new Image(Assets.getMarketTexture("BuyView/ItemUpSkin"));
				btn.defaultSelectedSkin = new Image(Assets.getMarketTexture("BuyView/ItemSelectSkin"));
				btn.stateToSkinFunction = null;
				
				btn.addEventListener(Event.TRIGGERED,listBtnHandle);
				
				
//				btn.isToggle = true;
				
				btnList.push(btn);
			}
		}

		
		private function listBtnHandle(event:Event):void{
			//设置购买数量、总额,延迟0.1s，按钮isToggle需要时间
			TweenLite.delayedCall(0.1,setAmountTF);
		}

		private function buyBtnHandle(event:Event):void{
			if(Global.isLoading)
				return;
			sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
				640,381,sureBuy,"确定要花费 "+amountTF.text+" 购买 "+marketItemSpVo.frameName+" 吗？"));
		}
		private function cancleBtnHandle(event:Event):void{
			if(Global.isLoading)
				return;
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		private function sureBuy():void{
			var isBuyFrame:Boolean = true;
			var goodsStr:String = "";
			for(var i:int=0;i<btnList.length;i++){
				if(btnList[i].isSelected){
					if(goodsStr == "")
						goodsStr = marketItemInfoVoList[i].goodsId;
					else
						goodsStr += ","+marketItemInfoVoList[i].goodsId;
				}else
					isBuyFrame = false;
			}
			
			//购买整个主架
			if(isBuyFrame)	goodsStr = "";

			//发送命令字购买
			PackData.app.CmdIStr[0] = CmdStr.MARK_APPLY;
			PackData.app.CmdIStr[1] = "UBMF";
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.user;
			PackData.app.CmdIStr[4] = "0";
			PackData.app.CmdIStr[5] = "";
			PackData.app.CmdIStr[6] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[7] = marketItemSpVo.frameId;
			PackData.app.CmdIStr[8] = goodsStr;
			PackData.app.CmdInCnt = 9;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(MARK_APPLY));
			
			
		}

		
		
		private var isSelectAll:Boolean;
		private function selectAllBtnHandle(event:Event):void{
			
			var i:int;
			if(!isSelectAll){
				for(i=0;i<btnList.length;i++){
					btnList[i].isSelected = true;
				}
				isSelectAll = true;
			}else{
				for(i=0;i<btnList.length;i++){
					btnList[i].isSelected = false;
				}
				isSelectAll = false;
			}
			//设置购买数量、总额
			setAmountTF();
			
		}
		
		private function setAmountTF():void{
			var quantity:int = 0;
			var amount:Number = 0;
			
			for(var i:int=0;i<btnList.length;i++){
				if(btnList[i].isSelected){
					quantity++;
					
					amount+= Number(marketItemInfoVoList[i].goodsCost);
				}
			}
			
			quantityTF.text = quantity.toString();
			amountTF.text = amount.toString();
			
			if(quantity == 0)	buyBtn.enabled = false;
			else	buyBtn.enabled = true;
		}


		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			sendNotification(MarketViewMediator.SET_CPU_INPUT_VISIBLE,true);
			TweenLite.killTweensOf(setAmountTF);
			TweenLite.killTweensOf(bg);
			
			marketItemInfoVoList = null;
			view.removeChildren(0,-1,true);
			super.onRemove();
			
		}
		
		
	}
}