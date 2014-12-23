package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.TargetWallVO;
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class ShowPromiseViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ShowPromiseViewMediator";
		public static const QUERYTARGETWALLBYSIDMESSAGE:String = NAME + "QueryTargetWall";
		public static const QUERYPARENTSBYSID:String = NAME + "QueryParentsBySid";
		public static const GETMONEYNUMBER:String = NAME + "GetMoneyNumber";
		private var vo:SwitchScreenVO;
		
		private var targets:Vector.<TargetWallVO>;
		private var targetList:List;
		private var items:Array;
		
		private var targetPaper:TargetPaperView;
		private var _showIndex:int;
		
		private var coinsInfo:TextField;
		private var coinsHave:String;
		private var _coinsTarget:String;
		
		private var container:ScrollContainer; 
		private var layout:TiledRowsLayout;
		private var onTouchBeginY:int;
		private var onTouchEndY:int;
		private var closeBtn:Button;
		
		public function ShowPromiseViewMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}

		public function set coinsTarget(value:String):void{
			_coinsTarget = value;
			coinsInfo.text = coinsHave + "/" + _coinsTarget;
		}

		override public function onRegister():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			
			items.fixed = true;
			var nameOfLogin:String = Global.player.name;
			
			this.targetList = new List();
			this.targetList.dataProvider = new ListCollection(items);
			this.targetList.isSelectable = true;
			this.targetList.scrollerProperties.hasElasticEdges = true;
			this.targetList.itemRendererProperties.labelField = "text";
			this.targetList.addEventListener(Event.CHANGE,list_onChange);
//			view.addChild(targetList);
			targetList.x = 20; targetList.y = 110;
			targetList.width = 195; targetList.height = 500;
			
			targetPaper = new TargetPaperView(nameOfLogin);
			view.addChild(targetPaper);
			targetPaper.x = 290;//200;
			targetPaper.y = 70;
			
			/*2012年12月26日11:49:07*/
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_NONE;
			layout.gap = 1;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			container = new ScrollContainer();
			container.layout = layout;
			container.snapScrollPositionsToPixels = true;
			container.snapToPages = false;
			container.x = 20; container.y = 110;
			container.width = 287; container.height = 535;
			for(var i:int = 0; i < items.length; i++){
				var j:int = items.length - 1 - i;
				var sp:Sprite = new Sprite();
				var one:Image = new Image(Assets.getAtlasTexture("targetWall/otherScroll"));
				one.name = "bg";
				sp.addChild(one);
				var two:Image = new Image(Assets.getAtlasTexture("targetWall/selectScroll"));
				two.name = "bg2";
				two.visible = false;
				sp.addChild(two);
				var text:Sprite = Assets.getWordSprite(items[j].text);
				text.x = 70; text.y = 22;
				sp.addChild(text);
				sp.name = j.toString();
				container.addChild(sp);
				sp.addEventListener(TouchEvent.TOUCH, touchHandler);
			}
			view.addChild(container);
			/*2012年12月26日11:49:24*/
			
			coinsInfo = new TextField(100, 25, "", "HeiTi", 14, 0x000000, true);
			coinsInfo.x = 17; coinsInfo.y = 80;
			view.addChild(coinsInfo);
			
			if(targets.length > 0){
				showIndex = targets.length - 1;
			}
			
			var texture:Texture = Assets.getAtlasTexture("flip/closeGuide");
			closeBtn = new Button(texture);
			closeBtn.x = 1180; closeBtn.y = 110;
			closeBtn.addEventListener(TouchEvent.TOUCH, onCloseBtnHandler);
			view.addChild(closeBtn);
		}
		
		private function onCloseBtnHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				vo.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
			}
		}
		
		private function touchHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				onTouchBeginY = touch.globalY;
			}
			if(touch.phase == TouchPhase.ENDED){
				onTouchEndY = touch.globalY;
				if(Math.abs(onTouchBeginY - onTouchEndY) < 10){
					if((e.currentTarget as DisplayObject).name != _showIndex.toString()){
						showIndex = parseInt((e.currentTarget as DisplayObject).name);
					}
				}
			}
		}
		
		private function list_onChange(event:Event):void{
			showIndex = this.targetList.selectedIndex;
		}
		
		override public function handleNotification(notification:INotification):void {
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GETMONEYNUMBER : 
					if(!result.isErr){
						coinsHave = PackData.app.CmdOStr[4];
					}else{
						coinsHave = "null";
					}
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					break;
				case WorldConst.HIDE_SHOWPROMISEVIEW : {
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				}
			}
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			targets = vo.data as Vector.<TargetWallVO>;
			items = new Array();
			for(var i:int = 0; i < targets.length; i++){
				var dateString:String = targets[i].startDate;
				var item:Object = {text:dateString.substr(0,4) + "-" + dateString.substr(4,2) + "-" + dateString.substr(6,2)};
				items.push(item);
			}
			getCoinsNum();
		}
		
		private function getCoinsNum():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GETMONEYNUMBER));
		}
		
		public function set showIndex(value:int):void{
			var beforChange:int = _showIndex;
			_showIndex = value;
			(container.getChildByName(beforChange.toString()) as Sprite).getChildByName("bg2").visible = false;
			(container.getChildByName(beforChange.toString()) as Sprite).getChildByName("bg").visible = true;
			(container.getChildByName(_showIndex.toString()) as Sprite).getChildByName("bg").visible = false;
			(container.getChildByName(_showIndex.toString()) as Sprite).getChildByName("bg2").visible = true;
			
			var target:TargetWallVO = targets[_showIndex];
			var targetString:String = "null";
			if(target.target.substr(0,6) == "coins:"){
				targetString = target.target.substr(6,target.target.length-6);
			}
			var endDate:String = target.endDate;
			var year:String = endDate.substr(0,4);
			var month:String = endDate.substr(4,2);
			if(month.substr(0,1) == "0") month = month.substr(1,1);
			var day:String = endDate.substr(6,2);
			if(day.substr(0,1) == "0") day = day.substr(1,1);
			targetPaper.setTextFieldString(target.appellation, year, month, 
				day, targetString, target.rwContent, 
				target.startDate.substr(0,4) + "-" + target.startDate.substr(4,2) + "-" + target.startDate.substr(6,2));
			
			if(target.isDead){
				targetPaper.setDead();
			}
			if(target.isFinish){
				targetPaper.setFinish();
			}
			coinsTarget = targetString;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			view.removeChild(targetPaper);
			view.removeChildren(0,-1,true);
			view.dispose();
			super.onRemove();
		}
		
		override public function listNotificationInterests():Array{
			return [GETMONEYNUMBER,WorldConst.HIDE_SHOWPROMISEVIEW];
		}
	}
}

