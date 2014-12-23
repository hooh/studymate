package com.studyMate.world.screens
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.ETIslandPageSprite;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.ETIslandPageSpVO;
	import com.studyMate.world.model.vo.EngTaskDayInfoVO;
	
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class EngTaskIslandMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "EngTaskIslandMediator";
		private static const QRY_USER_DAYTASKINFO:String = "QryUserDaytaskInfo";
		
		private var textureList:Vector.<Texture> = new Vector.<Texture>;
		
		private var cloudRange01:Rectangle = new Rectangle(-100,0,1300,200);
		private var cloudRange02:Rectangle = new Rectangle(-600,0,2500,400);
		private var _juggler:Juggler;
		
		private var cloudSp:Sprite;
		private var pageSp:Sprite;
		private var frontSp:Sprite;
		
		private var directBtn_Lef:Button;
		private var directBtn_Rig:Button
		private var currentIndex:int;
		private var goldTF:TextField;
		
		private var vo:SwitchScreenVO;
		private var etDayInfoVoList:Vector.<EngTaskDayInfoVO> = new Vector.<EngTaskDayInfoVO>;
		private var charater:ICharater;

		public function EngTaskIslandMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_USER_DAYTASKINFO;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "*";
			PackData.app.CmdIStr[3] = getTimeFormat();
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_USER_DAYTASKINFO));
		}
		private function getTimeFormat():String {
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyyMMdd");
			return dateFormatter.format(Global.nowDate);
		}
		override public function handleNotification(notification:INotification):void{	
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case QRY_USER_DAYTASKINFO:
					if(!result.isEnd){
						var _etDayInfoVo:EngTaskDayInfoVO = new EngTaskDayInfoVO();
						_etDayInfoVo.userId = PackData.app.CmdOStr[1];
						_etDayInfoVo.rrl = PackData.app.CmdOStr[2];
						_etDayInfoVo.state = PackData.app.CmdOStr[3];
						_etDayInfoVo.money = PackData.app.CmdOStr[4];
						_etDayInfoVo.level = PackData.app.CmdOStr[5];
						
						etDayInfoVoList.push(_etDayInfoVo);
						
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [QRY_USER_DAYTASKINFO];
		}
		
		override public function onRegister():void
		{
			init();
		}
		private function init():void{
			var texture:Texture = Assets.getTexture("EngTaskIslandBg");
			textureList.push(texture);
			var bg:Image = new Image(texture);
			view.addChild(bg);
			
			cloudSp = new Sprite();
			view.addChild(cloudSp);
			
			pageSp = new Sprite();
			view.addChild(pageSp);
			
			frontSp = new Sprite();
			view.addChild(frontSp);
			
			var cloud01:Image =new Image(Assets.getEngTaskIslandTexture("ETI_Cloud01"));
			var cloud02:Image =new Image(Assets.getEngTaskIslandTexture("ETI_Cloud01"));
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud01,holder:cloudSp,range:cloudRange01,randomAction:false,randomSize:false});
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud02,holder:cloudSp,range:cloudRange02,randomAction:false,randomSize:false});
			
			
			_juggler = Starling.juggler;
			
			initData();
			
			//创建分页
			createPagePanel();

			createFrontSp();
		}
		private var etislandPageSpVoList:Vector.<ETIslandPageSpVO> = new Vector.<ETIslandPageSpVO>;
		private function initData():void{
			
			
			var etislandPageSpVo:ETIslandPageSpVO;
			
			var len:int = etDayInfoVoList.length;
			
			for(var i:int=0;i<len;i++){
				
				var len2:int = etislandPageSpVoList.length;
				var isHad:Boolean = false;
				//查找是否存在该类任务
				for(var j:int=0;j<len2;j++){
					
					if(etDayInfoVoList[i].rrl.indexOf(etislandPageSpVoList[j].taskType) != -1){
						etislandPageSpVoList[j].stateList.push(etDayInfoVoList[i].state);
						
						etislandPageSpVoList[j].levelList.push(etDayInfoVoList[i].level);
						
						etislandPageSpVoList[j].money += (int(etDayInfoVoList[i].money));
						
						
						isHad = true;
						break;
						
					}
				}
				if(!isHad){
					var _etislandPageSpVo:ETIslandPageSpVO = new ETIslandPageSpVO();
					
					//属于学单词任务
					if(etDayInfoVoList[i].rrl.indexOf("yy.W") != -1)
						_etislandPageSpVo.taskType = "yy.W";
					else if(etDayInfoVoList[i].rrl.indexOf("yy.R") != -1)
						_etislandPageSpVo.taskType = "yy.R";
					else
						//其余任务跳过
						continue;
					
					_etislandPageSpVo.stateList.push(etDayInfoVoList[i].state);
					_etislandPageSpVo.levelList.push(etDayInfoVoList[i].level);
					_etislandPageSpVo.money += (int(etDayInfoVoList[i].money));

					etislandPageSpVoList.push(_etislandPageSpVo);
				}
			}
			
			
			
		}
		
		
		
		
		private var layout:TiledRowsLayout;
		private var pageContainer:ScrollContainer;
		private var pageIndicator:PageIndicator;
		private function createPagePanel():void{
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 2;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			pageContainer = new ScrollContainer();
			pageContainer.y = 60;
			pageContainer.width = 1280;
			pageContainer.height = 585;
			pageContainer.layout = layout;
			pageContainer.snapToPages = TiledRowsLayout.PAGING_VERTICAL;
			pageContainer.snapScrollPositionsToPixels = true;
			pageSp.addChild(pageContainer);
			pageContainer.addEventListener(FeathersEventType.SCROLL_COMPLETE,pageContainerHandle);
			
			
			var len:int = etislandPageSpVoList.length;
			
			for(var i:int=0;i<len;i++){
				pageContainer.addChild(new ETIslandPageSprite(_juggler,etislandPageSpVoList[i]));
			}

			pageIndicator = new PageIndicator();
			frontSp.addChild(pageIndicator);
			pageIndicator.width = 100;
			centerPivot(pageIndicator);
			pageIndicator.x = 700;
			pageIndicator.y = 700;
			pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			pageIndicator.gap = 3;
			pageIndicator.pageCount = pageContainer.numChildren;
			pageIndicator.touchable = false;
			pageIndicator.normalSymbolFactory = function():DisplayObject{
				return new Image(Assets.getEngTaskIslandTexture("ETI_PageIndicator00"));}
			pageIndicator.selectedSymbolFactory = function():DisplayObject{
				return new Image(Assets.getEngTaskIslandTexture("ETI_PageIndicator01"));}
		}
		private function pageContainerHandle():void{
			pageIndicator.selectedIndex = pageContainer.horizontalScrollPosition/pageContainer.width;
			currentIndex = pageIndicator.selectedIndex;
			
			goldTF.text = "x "+etislandPageSpVoList[currentIndex].money;
			
			directBtn_Lef.visible = true;
			directBtn_Rig.visible = true;
			if(currentIndex <= 0)
				directBtn_Lef.visible = false;
			if(currentIndex >= pageIndicator.pageCount-1)
				directBtn_Rig.visible = false;
			
			charater.actor.playAnimation("idle",7,64,true);
			charater.actor.switchCostume("head","face","bigSmile");
			TweenLite.killTweensOf(delayFun);
			TweenLite.delayedCall(1,delayFun);
		}
		private function delayFun():void{
			charater.actor.playAnimation("idle",7,64,true);
			charater.actor.switchCostume("head","face","normal");
		}
		
		private function createFrontSp():void{
			//站台、人
			var platFrom:Image = new Image(Assets.getEngTaskIslandTexture("ETI_PlatForm"));
			platFrom.x = 85;
			platFrom.y = 507;
			frontSp.addChild(platFrom);
			
			//创建人物
			var chaSp:Sprite = new Sprite();
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
//			CharaterUtils.humanDressFun(charater as HumanMediator,"set2,shoes1,hair6,face_face1");
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).configHumanFromDressList(charater as HumanMediator,"set2,shoes1,hair6,face_face1",new Rectangle());
			charater.view.alpha = 1;
			charater.view.x = 0;
			charater.view.y = 0;
			chaSp.addChild(charater.view);
			chaSp.x = 260;
			chaSp.y = 625;
			chaSp.scaleX = 3;
			chaSp.scaleY = 3;
			frontSp.addChild(chaSp);
			
			//金币icon
			var goldImg:Image = new Image(Assets.getEngTaskIslandTexture("ETI_Gold_Icon"));
			goldImg.x = 135;
			goldImg.y = 660;
			frontSp.addChild(goldImg);
			
			if(etislandPageSpVoList.length>0)
				goldTF = new TextField(170,60,"x "+etislandPageSpVoList[0].money,"HeiTi",50,0xffffff,true);
			else
				goldTF = new TextField(170,60,"x 0","HeiTi",50,0xffffff,true);
			goldTF.nativeFilters = [new GlowFilter(0,1,5,5,20)];
			goldTF.hAlign = HAlign.LEFT;
			goldTF.x = 235;
			goldTF.y = 660;
			frontSp.addChild(goldTF);
			
			//directBtn
			directBtn_Lef = new Button(Assets.getEngTaskIslandTexture("ETI_Direct_Btn"));
			directBtn_Lef.name = "dbtn_Lef";
			directBtn_Lef.x = 38;
			directBtn_Lef.y = 350;
			directBtn_Lef.visible = false;
			frontSp.addChild(directBtn_Lef);
			directBtn_Lef.addEventListener(Event.TRIGGERED,directBtnHandle);
			
			directBtn_Rig = new Button(Assets.getEngTaskIslandTexture("ETI_Direct_Btn"));
			directBtn_Rig.name = "dbtn_Rig";
			directBtn_Rig.scaleX = -1;
			directBtn_Rig.x = 1230;
			directBtn_Rig.y = 350;
			directBtn_Rig.visible = false;
			frontSp.addChild(directBtn_Rig);
			directBtn_Rig.addEventListener(Event.TRIGGERED,directBtnHandle);
			
			currentIndex = 0;
			if(pageIndicator.pageCount > 1)
				directBtn_Rig.visible = true;
			
		}
		private function directBtnHandle(event:Event):void{
			directBtn_Lef.visible = true;
			directBtn_Rig.visible = true;
			
			if((event.target as Button).name == "dbtn_Rig"){
				pageContainer.scrollToPageIndex(++currentIndex,0,1);
			}else{
				pageContainer.scrollToPageIndex(--currentIndex,0,1);
			}
			
			if(currentIndex <= 0)
				directBtn_Lef.visible = false;
			if(currentIndex >= pageIndicator.pageCount-1)
				directBtn_Rig.visible = false;

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
			for each (var i:Texture in textureList){
				i.dispose();
			}
			
			Assets.disposeTexture("ETI_Cloud01");
			Assets.disposeTexture("ETI_PageIndicator00");
			Assets.disposeTexture("ETI_PageIndicator01");
			Assets.disposeTexture("ETI_PlatForm");
			Assets.disposeTexture("ETI_Gold_Icon");
			Assets.disposeTexture("ETI_Direct_Btn");
			
			cloudSp.removeChildren(0,-1,true);
			pageSp.removeChildren(0,-1,true);
			frontSp.removeChildren(0,-1,true);
			
			view.removeChildren(0,-1,true);
			TweenLite.killTweensOf(delayFun);
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
			
			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			super.onRemove();
			
		}


	}
}