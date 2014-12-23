package com.mylib.game.charater.item
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.fightGame.CircleChart;
	import com.mylib.game.fightGame.RollerUtils;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.DressMarketMediator;
	import com.studyMate.module.game.DressMarketScroller;
	import com.studyMate.module.game.DressUpgradeMediator;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.model.vo.DressSeriesItemVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.Label;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import com.studyMate.world.model.vo.DressSeriesVO;
	
	public class DressMarketItem extends Sprite
	{
		public static const ITEM_CLICK:String = "ItemClick";
		public static const BUY_CLICK:String = "BuyClick";
		public static const UPDATE_CLICK:String = "UpdateClick";
		public var dressSuitsVo:DressSuitsVO;
		private var upSuitsVo:DressSuitsVO;
		
		private var price:String;
		private var equipCircle:CircleChart;
		
		private var bg:Image;
		private var buyBtn:Button;
		private var infoBtn:Button;
		
		private var buyTexture:Texture;
		private var infiTexture:Texture;
		
		private var bgSp:Sprite;
		private var previewSp:Sprite;
		
		public function DressMarketItem(_equipCircle:CircleChart,_dressSuitsVo:DressSuitsVO,_upSuitsVo:DressSuitsVO)
		{
			super();
			
			equipCircle = _equipCircle;
			dressSuitsVo = _dressSuitsVo;
			upSuitsVo = _upSuitsVo;
			freshItem(dressSuitsVo);
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageHandle);
		}
		public function freshItem(_dressSuitsVo:DressSuitsVO):void{
			dressSuitsVo = _dressSuitsVo;
			if(!dressSuitsVo)
				return;
			
			removeChildren(0,-1,true);
			
			//装备等级
			var lvl:String = "1";
			var topLvl:int = 1;
			var isTopLvl:Boolean = false;
			var serInfo:DressSeriesVO = GlobalModule.charaterUtils.getEquipSerInfo(dressSuitsVo.name);
			var serItemInfo:DressSeriesItemVO = GlobalModule.charaterUtils.getEquipItemInfo(dressSuitsVo.name);
			if(serInfo) topLvl = serInfo.topLevel;
			if(serItemInfo)	lvl = serItemInfo.level;
//			if((int(lvl)) == topLvl)	isTopLvl = true;	//已经是最高级
			if(!upSuitsVo) isTopLvl = true;
//			trace("最高级："+topLvl);
			
			var bgTexture:Texture;
			var lvlInfoTexture:Texture;
			var btnTexture:Texture;
//			bgTexture = BitmapFontUtils.getTexture("DressMarket/itemBg_lvl"+lvl+"_00000");
			bgTexture = BitmapFontUtils.getTexture("DressMarket/itemBg_lvl"+topLvl+"_00000");
			//是最高级
			if(isTopLvl)	lvlInfoTexture = BitmapFontUtils.getTexture("DressMarket/lvlIconMax"+topLvl+"_M_00000");//lvlIconMax1_M
			else	lvlInfoTexture = BitmapFontUtils.getTexture("DressMarket/lvlIconMax"+topLvl+"_"+lvl+"_00000");//lvlIconMax1_1
			
			//背景
			bgSp = new Sprite;
			addChild(bgSp);
			bgSp.addEventListener(TouchEvent.TOUCH,itemClickHandle);
			bg = new Image(bgTexture);
			bg.x = 8;
			bg.y = 1;
			bgSp.addChild(bg);
			var lvlInfo:Image = new Image(lvlInfoTexture);
			bgSp.addChild(lvlInfo);
			
			//信息按钮
			infoBtn = new Button(BitmapFontUtils.getTexture("DressMarket/itemInfoBtn_00000"));
			infoBtn.x = 116;
//			addChild(infoBtn);
//			infoBtn.addEventListener(Event.TRIGGERED,infoBtnHandle);
			
			var gamePrice:String = "---";
			var goldPrice:String = "---";
			//购买按钮
			if(dressSuitsVo.hasBuy){
				if(isTopLvl){	//已购买，最高级
					buyBtn = new Button(BitmapFontUtils.getTexture("DressMarket/itemUpdateDisBtn_00000"));
					buyBtn.touchable = false;
				}else{	//已购买，还能升级
					buyBtn = new Button(BitmapFontUtils.getTexture("DressMarket/itemUpdateBtn_00000"));
					gamePrice = upSuitsVo.price.toString();
					goldPrice = upSuitsVo.goldprice;
				}
				buyBtn.name = "updateBtn";
			}else{	//未购买
				buyBtn = new Button(BitmapFontUtils.getTexture("DressMarket/itemBuyBtn_00000"));
				buyBtn.name = "buyBtn";
				gamePrice = dressSuitsVo.price.toString();
				goldPrice = dressSuitsVo.goldprice;
			}
			buyBtn.fontName = "HuaKanT";
			buyBtn.x = 12;
			buyBtn.y = 145;
			addChild(buyBtn);
			buyBtn.addEventListener(Event.TRIGGERED,buyBtnHandle);
			
			//预览遮罩
			previewSp = new Sprite;
			previewSp.x = 7;
			previewSp.y = 6;
			addChild(previewSp);
			previewSp.visible = false;
			
			//价格标签
			var pimg:Image = new Image(BitmapFontUtils.getTexture("DressMarket/itemGoldIcon1_00000"));
			/*pimg.x = 11;
			pimg.y = 113;*/
			pimg.x = 38;
			pimg.y = 102;
			addChild(pimg);
			var p2img:Image = new Image(BitmapFontUtils.getTexture("DressMarket/itemGoldIcon2_00000"));
			/*p2img.x = 77;
			p2img.y = 113;*/
			p2img.x = 39;
			p2img.y = 120;
			addChild(p2img);
			
			/*var tf1:TextField = new TextField(40,15,dressSuitsVo.price.toString(),"HeiTi",13,0xffffff,true);
			tf1.nativeFilters = [new GlowFilter(0,1,5,5,20)];
			tf1.hAlign = HAlign.LEFT;
			tf1.x = 32;
			tf1.y = 115;
			addChild(tf1);
			var tf2:TextField = new TextField(40,15,dressSuitsVo.goldprice,"HeiTi",13,0xffffff,true);
			tf2.nativeFilters = [new GlowFilter(0,1,5,5,20)];
			tf2.hAlign = HAlign.LEFT;
			tf2.x = 96;
			tf2.y = 115;
			addChild(tf2);*/
			var tf1:Label = BitmapFontUtils.getLabel();
			/*tf1.setSize(55,15);
			tf1.x = 32;
			tf1.y = 110;*/
			tf1.x = 59;
			tf1.y = 99;
			tf1.setSize(100,15);
			addChild(tf1);
			tf1.text = gamePrice;
			var tf2:Label = BitmapFontUtils.getLabel();
			/*tf2.setSize(55,15);
			/*tf2.x = 96;
			tf2.y = 110;*/
			tf2.x = 58;
			tf2.y = 117;
			tf2.setSize(110,15);
//			tf2.textRendererProperties.autoScale = true;
			addChild(tf2);
//			tf2.textRendererProperties.autoScale = true;
			tf2.text = goldPrice;
			
			//新品提示
			if(dressSuitsVo.isNew)
			{
				var newTips:Image = new Image(BitmapFontUtils.getTexture("DressMarket/newTips_00000"));
				newTips.x = 168-newTips.width;
				addChild(newTips);
			}
		}
		//升级装备item
		public function upgradeItem(_nowVo:DressSuitsVO,_upVo:DressSuitsVO):void{
			_nowVo.isShow = false;
			
			var marketScroll:DressMarketScroller = (Facade.getInstance(CoreConst.CORE).retrieveMediator(ModuleConst.DRESS_MARKET) as DressMarketMediator).scroll;
			upSuitsVo = marketScroll.getNextLvlSuitvo(_upVo.name);
			
			_upVo.isShow = true;
			_upVo.hasBuy = true;
			dressSuitsVo = _upVo;
			freshItem(dressSuitsVo);
			marketScroll.updateEquipImg(_nowVo.name,_upVo.name);
		}
		
		
		private var beginY:Number;
		private var endY:Number;
		private function itemClickHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endY = touchPoint.globalY;
					if(Math.abs(endY-beginY) < 10){
						trace("点击了item");
						
						Facade.getInstance(CoreConst.CORE).sendNotification(ITEM_CLICK,dressSuitsVo);
						
					}
				}
			}
		}
		private function infoBtnHandle():void{
			trace("查看信息");
			
			previewSp.visible = true;
			previewSp.addChild(equipCircle);
			
			equipCircle.x = 70;
			equipCircle.y = 60;
			equipCircle.scaleX = 0.9;
			equipCircle.scaleY = 0.9;
			equipCircle.clear();
			RollerUtils.setChartByProperty(equipCircle,dressSuitsVo.property);
			equipCircle.refresh();
			
		}
		private function buyBtnHandle(e:Event):void{
			var btn:Button = e.target as Button;
			if(btn.name == "updateBtn"){
				trace("升级");
//				Facade.getInstance(CoreConst.CORE).sendNotification(UPDATE_CLICK,dressSuitsVo);
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(DressUpgradeMediator,[this,dressSuitsVo,upSuitsVo],
						SwitchScreenType.SHOW)]);
				
				
				
				
			}else if(btn.name == "buyBtn"){
				trace("购买");
				Facade.getInstance(CoreConst.CORE).sendNotification(BUY_CLICK,[this,dressSuitsVo]);
				
				
//				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
//					[new SwitchScreenVO(DressUpgradeMediator,dressSuitsVo.name,
//						SwitchScreenType.SHOW)]);
				
				
			}
		}
		private function stageHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.BEGAN){
					
					if(!previewSp.getBounds(Starling.current.stage).contains(touch.globalX,touch.globalY)){ //价格按钮区域
						//关闭
						previewSp.visible = false;
					}else{
						
					}
					
					
					
				}
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			if(Starling.current.stage.hasEventListener(TouchEvent.TOUCH))
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageHandle);
			
			if(bg)	bg.removeEventListener(Event.TRIGGERED,itemClickHandle);
			if(buyBtn)	buyBtn.removeEventListener(Event.TRIGGERED,buyBtnHandle);
			if(infoBtn)	infoBtn.removeEventListener(Event.TRIGGERED,infoBtnHandle);
			
			removeChildren(0,-1,true);
		}
		
	}
}