package com.studyMate.world.screens
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.PromiseVO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class MakeProMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MakeProMediator";
		public static const GETMONEYNUMBER:String = NAME + "GetMoneyNumber";
		public static const MAKE_PROMISE:String = NAME + "MakePromise";
		private var vo:SwitchScreenVO;
		
		private var goldHave:int;
//		private var defaultGold:TextField;
//		private var parentName:TextField;
//		private var rewardTxt:TextField;
//		private var remindTxt:TextField;
		
		private var goldInput:TextFieldHasKeyboard;
		private var parentInput:TextFieldHasKeyboard;
		private var rewardInput:TextFieldHasKeyboard;
		
		private var leftImage:Image;
		private var rightImage:Image;
		private var lefthand:Image;
		private var righthand:Image;
		
		private var proSprite:starling.display.Sprite;
		private var hand01:Image;
		private var hand02:Image;
		private var xin:Image;
		private var bg:Image;
		
		private var starX:int = 164;
		private var starY:int = 152;
		private var starWidth:int = 987;
		private var starHeight:int = 545;
		private var timeline:TimelineLite;
		private var promise:PromiseVO;
		
		private var prepareVO:SwitchScreenVO;
		
		private var awardBgTexture:Texture;
		
		private var leftSp:flash.display.Sprite;
		private var rightSp:flash.display.Sprite;
		
		public function MakeProMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			promise = null;
			if(goldInput)
				goldInput.removeEventListener(flash.events.Event.CHANGE,goldChangeHandler);
				Starling.current.nativeOverlay.removeChild(goldInput);	
			goldInput = null;
			if(parentInput)
				Starling.current.nativeOverlay.removeChild(parentInput);
			parentInput = null;
			if(rewardInput)
				Starling.current.nativeOverlay.removeChild(rewardInput);
			if(leftSp){
				Starling.current.nativeOverlay.removeChild(leftSp);
				Starling.current.nativeOverlay.removeChild(rightSp);
			}
			rewardInput = null;
			if(timeline) timeline.kill();
			TweenMax.killTweensOf(bg);
			TweenMax.killTweensOf(righthand);
			TweenMax.killTweensOf(lefthand);
			TweenMax.killTweensOf(hand01);
			TweenMax.killTweensOf(hand02);
			timeline = null;
			//TweenMax.killAll(true);
			hand01 = null;
			hand02 = null;
			bg = null;
			righthand = null;
			leftImage = null;
			rightImage = null;
			lefthand = null;
			righthand = null;
			
			if(xin){
				TweenMax.killTweensOf(xin);
				xin = null;
			}
			vo = null;
			if(proSprite){
				proSprite.removeChildren(0,-1,true);
			}
			proSprite = null;
			view.removeEventListeners();
			view.removeChildren(0,-1,true);
//			sendNotification(WorldConst.OPEN_MENU);
			if(awardBgTexture) awardBgTexture.dispose();
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			prepareVO = vo;
			getCoinsNum();
		}
		
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.HIDE_SETTING_SCREEN :
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
				case GETMONEYNUMBER : 
					if(result.isErr){
						goldHave = 0;
					}else{
						goldHave = parseInt(PackData.app.CmdOStr[4]);
					}
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					break;
				case MAKE_PROMISE : 
					if(!result.isErr){
						chengGong();
					}
					break;
				default : 
					break;
			}
		}
		
		
		private function chengGong():void{
			goldInput.visible = false;
			parentInput.visible = false;
			rewardInput.visible = false;
			
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0x257597);
			view.addChild(quad);
			
			awardBgTexture = Texture.fromBitmap(Assets.store["awardBg"],false,false);
			bg = new Image(awardBgTexture);
			bg.alpha = 0.5;
			bg.pivotX = bg.width>>1;
			bg.pivotY = bg.height>>1;
			bg.x = Global.stageWidth>>1;
			bg.y = (Global.stageHeight>>1) + 110;
			bg.visible = false;
			view.addChild(bg);
			TweenMax.to(bg,15,{rotation:Math.PI*2,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			
			proSprite = makeSp(promise);
			view.addChild(proSprite);
			proSprite.visible = false;
			proSprite.pivotX = 300; proSprite.pivotY = 346;
			proSprite.x = 643; proSprite.y = 406;
			
			hand01 = new Image(Assets.getAtlasTexture("targetWall/hand01"));
			view.addChild(hand01);
			hand01.alpha = 1;
			hand01.x = 581; hand01.y = 365;
			TweenMax.from(hand01, 1.5, {x:281, alpha:0});
			
			timeline = new TimelineLite();
			
			hand02 = new Image(Assets.getAtlasTexture("targetWall/hand02"));
			view.addChild(hand02);
			hand02.x = 642; hand02.y = 365;
			TweenMax.from(hand02, 1.5, {x:942, alpha:0, onComplete:addXin});
			
			var shape:flash.display.Sprite
			
		}
		
		
		/*private function makeStar():void{
			for(var i:int = 0; i < 50; i++){
				var star2:Image = new Image(Assets.getAtlasTexture("targetWall/star2"));
				view.addChild(star2);
				star2.x = Math.random()*starWidth + starX;
				star2.y = Math.random()*starHeight + starY;
				star2.pivotX = star2.width / 2; star2.pivotY = star2.height / 2;
				TweenMax.to(star2, Math.random() * 2, {scaleX:Math.random(), scaleY:Math.random(), alpha:0, yoyo:true,repeat:int.MAX_VALUE});
			}
		}*/
		
		private function addXin():void{
			xin = new Image(Assets.getAtlasTexture("targetWall/xin"));
			view.addChild(xin);
			xin.alpha = 0;
			xin.x = 643 - xin.width/2; xin.y = 365;
			timeline.append(TweenMax.to(xin, 0.8, {alpha:1, rotation:-Math.PI/4, y:325, onComplete:playMovie}));
		}
		
		private function playMovie():void{
			hand01.visible = false; hand02.visible = false;
			xin.visible = false;
			var ourPro:Image = new Image(Assets.getTexture("ourPro"));
			bg.visible = true;
			ourPro.x = 352; ourPro.y = 352;
			view.addChild(ourPro);
//			makeStar();
			proSprite.visible = true;
			TweenMax.from(proSprite, 1, {scaleX:0, scaleY:0, ease:Bounce.easeOut});
			view.addEventListener(TouchEvent.TOUCH, onChenggongHandler);
		}
		
		private function onChenggongHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				view.removeEventListeners(TouchEvent.TOUCH);
				sendNotification(WorldConst.POP_SCREEN);
			}
		}
		
		override public function listNotificationInterests():Array{
			return [GETMONEYNUMBER,MAKE_PROMISE, WorldConst.HIDE_SETTING_SCREEN];
		}
		
		override public function onRegister():void{
			Multitouch.inputMode = MultitouchInputMode.NONE;
			var bg:Image = new Image(Assets.getTexture("makePro"));
			bg.touchable = false;
			view.addChild(bg);
			
			var goldTxt:TextField = new TextField(200, 37, "温馨提示:您现有"+goldHave+"个金币", "HuaKanT", 25, 0x883816);
			goldTxt.autoScale = true;goldTxt.vAlign = VAlign.CENTER;goldTxt.hAlign = HAlign.LEFT;
			goldTxt.x = 110; goldTxt.y = 7;
			view.addChild(goldTxt);
			
			var childName:TextField = new TextField(200, 37, Global.player.name, "HuaKanT", 28, 0x883816);
			childName.autoScale = true;
			childName.x = 89; childName.y = 79;
			view.addChild(childName);
			
//			defaultGold = new TextField(191, 43, (goldHave + 300).toString(), "HeiTi", 28, 0xf4ebd3);
//			defaultGold.autoScale = true;
//			defaultGold.x = 184; defaultGold.y = 184;
//			view.addChild(defaultGold);
//			defaultGold.addEventListener(TouchEvent.TOUCH, goldTouchHandle);
			
//			parentName = new TextField(164, 33, "爸爸和妈妈", "HuaKanT", 28, 0xfd9b5a);
//			parentName.autoScale = true; parentName.hAlign = HAlign.LEFT;
//			parentName.x = 926; parentName.y = 78;
//			view.addChild(parentName);
//			parentName.addEventListener(TouchEvent.TOUCH, parentTouchHandle);
			
//			remindTxt = new TextField(401, 55, "点击输入奖励内容", "HuaKanT", 28, 0x5ab7d6);
//			remindTxt.autoScale = true;
//			remindTxt.x = 788; remindTxt.y = 205;
//			view.addChild(remindTxt);
//			remindTxt.addEventListener(TouchEvent.TOUCH, rewardTouchHandle);
			
//			rewardTxt = new TextField(421, 108, "", "HuaKanT", 28, 0xf4ebd3);
//			rewardTxt.autoScale = true;rewardTxt.hAlign = HAlign.LEFT;
//			rewardTxt.vAlign = VAlign.TOP;
//			rewardTxt.x = 780; rewardTxt.y = 170;
//			view.addChild(rewardTxt);
//			rewardTxt.addEventListener(TouchEvent.TOUCH, rewardTouchHandle);
			
			goldInput = new TextFieldHasKeyboard();
			goldInput.defaultTextFormat = new TextFormat("HuaKanT", 28, 0x925200);
//			goldInput.text = defaultGold.text;
			goldInput.text = (goldHave + 300).toString();
			goldInput.x = 184; goldInput.y = 184;
			goldInput.width = 191; goldInput.height = 43;
			goldInput.maxChars = 9;
			goldInput.wordWrap = true;
//			goldInput.visible = false;
			goldInput.restrict = "0-9";
			goldInput.addEventListener(flash.events.Event.CHANGE,goldChangeHandler);
			Starling.current.nativeOverlay.addChild(goldInput);
			
			parentInput = new TextFieldHasKeyboard();
			parentInput.defaultTextFormat = new TextFormat("HuaKanT", 28, 0x333333);
			parentInput.text = "爸爸和妈妈";
			parentInput.x = 922; parentInput.y = 76;
			parentInput.width = 164; parentInput.height = 34;
			parentInput.maxChars = 10;
			parentInput.restrict = "^/;";
			parentInput.wordWrap = true;
//			parentInput.visible = false;
			Starling.current.nativeOverlay.addChild(parentInput);
			
			rewardInput = new TextFieldHasKeyboard();
			
			var format:TextFormat = new TextFormat("HuaKanT", 28, 0x925200);
			format.leading = 13;
			rewardInput.defaultTextFormat = format;
//			rewardInput.text = rewardTxt.text;
			rewardInput.x = 780; rewardInput.y = 170;
			rewardInput.width = 421; rewardInput.height = 89;
			rewardInput.maxChars = 28;
			rewardInput.wordWrap = true;
			rewardInput.prompt = "点击输入奖励内容";
//			rewardInput.visible = false;
			Starling.current.nativeOverlay.addChild(rewardInput);
			
			var texture:Texture = Assets.getAtlasTexture("targetWall/btn");
			leftImage = new Image(texture);
			leftImage.x = 236 + leftImage.width / 2; leftImage.y = 265 + leftImage.height / 2;
			leftImage.pivotX = leftImage.width / 2; leftImage.pivotY = leftImage.height / 2;
			view.addChild(leftImage);
			leftImage.addEventListener(TouchEvent.TOUCH, leftBtnHandler);
			
			lefthand = new Image(Assets.getAtlasTexture("targetWall/hand"));
			lefthand.touchable = false;
			view.addChild(lefthand);
			lefthand.x = 287; lefthand.y = 298;
			TweenMax.to(lefthand, 0.8, {x:294, y:285, yoyo:true,repeat:999});
			
			rightImage = new Image(texture);
			rightImage.x = 947 + rightImage.width / 2; rightImage.y = 265 + rightImage.height / 2;
			rightImage.pivotX = rightImage.width / 2; rightImage.pivotY = rightImage.height / 2;
			view.addChild(rightImage);
			rightImage.addEventListener(TouchEvent.TOUCH, rightBtnHandler);
			
			righthand = new Image(Assets.getAtlasTexture("targetWall/hand"));
			righthand.touchable = false;
			view.addChild(righthand);
			righthand.x = 1001; righthand.y = 298;
			TweenMax.to(righthand, 0.8, {x:1008, y:285, yoyo:true,repeat:999});
			
			leftSp = new flash.display.Sprite();
			leftSp.graphics.beginFill(0);
			leftSp.graphics.drawCircle(0,0,40);
			leftSp.graphics.endFill();
			leftSp.x = 236+40;
			leftSp.y = 265+40;
			leftSp.alpha = 0;
			Starling.current.nativeOverlay.addChild(leftSp);
			
			rightSp = new flash.display.Sprite();
			rightSp.graphics.beginFill(0);
			rightSp.graphics.drawCircle(0,0,40);
			rightSp.graphics.endFill();
			rightSp.x = 947+40;
			rightSp.y = 265+40;
			rightSp.alpha = 0;
			Starling.current.nativeOverlay.addChild(rightSp);
			
			leftSp.addEventListener(MouseEvent.MOUSE_DOWN,leftMouseDownHandler);
			rightSp.addEventListener(MouseEvent.MOUSE_DOWN,rightMouseDownHandler);//多点触摸，starling层禁用后，只用flash层多点
		}
		
		protected function rightMouseDownHandler(event:MouseEvent):void
		{
			if(!lefthand.visible){
				makePromise();
			}
		}
		
		protected function leftMouseDownHandler(event:MouseEvent):void
		{
			if(!righthand.visible){
				makePromise();
			}
		}
		
		private function goldChangeHandler(event:flash.events.Event):void{
			if(isNaN(event.target.text)){
				event.target.text = "";
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"请输入合法数字"));
			}else if(Number(event.target.text) < 1 && event.target.text != ""){
				event.target.text = "1";
			}
		}
		
		private function rightBtnHandler(e:TouchEvent):void{
			e.stopImmediatePropagation();
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				righthand.visible = false;
				rightImage.scaleX = 0.9;
				rightImage.scaleY = 0.9;
			}
			if(touch.phase == TouchPhase.ENDED){
				righthand.visible = true;
				rightImage.scaleX = 1;
				rightImage.scaleY = 1;
			}
			if(e.touches.length == 2){
				var touch2:Touch = e.touches[1];
				if(touch2.target == leftImage){
					if(touch2.phase == TouchPhase.BEGAN){
						lefthand.visible = false;
						leftImage.scaleX = 0.8;
						leftImage.scaleY = 0.8;
//						makePromise();
					}
					if(touch2.phase == TouchPhase.ENDED){
						lefthand.visible = true;
						leftImage.scaleX = 1;
						leftImage.scaleY = 1;
					}
				}
			}
		}
		
		private function leftBtnHandler(e:TouchEvent):void{
			e.stopImmediatePropagation();
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				lefthand.visible = false;
				leftImage.scaleX = 0.9;
				leftImage.scaleY = 0.9;
			}
			if(touch.phase == TouchPhase.ENDED){
				lefthand.visible = true;
				leftImage.scaleX = 1;
				leftImage.scaleY = 1;
			}
			if(e.touches.length == 2){
				var touch2:Touch = e.touches[1];
				if(touch2.target == rightImage){
					if(touch2.phase == TouchPhase.BEGAN){
						righthand.visible = false;
						rightImage.scaleX = 0.8;
						rightImage.scaleY = 0.8;
//						makePromise();
					}
					if(touch2.phase == TouchPhase.ENDED){
						righthand.visible = true;
						rightImage.scaleX = 1;
						rightImage.scaleY = 1;
					}
				}
			}
		}
		
//		private function rewardTouchHandle(event:TouchEvent):void{
//			var touch:Touch = event.touches[0];
//			if(touch.phase == TouchPhase.ENDED){
//				rewardTxt.visible = false;
//				remindTxt.visible = false;
//				rewardInput.visible = true;
//				rewardInput.setFocus();
//				rewardInput.setSelection(0,rewardInput.text.length);
//				
//			}
//		}
		
//		private function parentTouchHandle(event:TouchEvent):void{
//			var touch:Touch = event.touches[0];
//			if(touch.phase == TouchPhase.ENDED){
//				parentName.visible = false;
//				parentInput.visible = true;
//				parentInput.setFocus();
//				parentInput.setSelection(0,parentInput.text.length);
//				
//			}
//		}
		
//		private function goldTouchHandle(event:TouchEvent):void{
//			var touch:Touch = event.touches[0];
//			if(touch.phase == TouchPhase.ENDED){
//				defaultGold.visible = false;
//				goldInput.visible = true;
//				goldInput.setFocus();
//				goldInput.setSelection(0,goldInput.text.length);
////				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
////					640,381,null,Global.player.name + "现有" + goldHave + "金币，请填入适当金币数作为目标"));
//			}
//		}
		
		private function makePromise():void{
			var target:int = parseInt(goldInput.text);
			var parent:String = parentInput.text;
			var reward:String = rewardInput.text;
			if(!(target > 0)){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"目标格式不正确，一定要有明确的目标哟 O(∩_∩)O~"));
				return;
			}
			if(target < goldHave){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"目标金币数不能少于现有金币数哟 O(∩_∩)O~"));
				return;
			}
			if(parent == ""){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"奖励者姓名不能为空哟，(*^__^*) 嘻嘻……"));
				return;
			}
			if(reward == ""){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"没有奖励内容，不公平哟 O(∩_∩)O~"));
				return;
			}
			leftSp.removeEventListener(MouseEvent.MOUSE_DOWN,leftMouseDownHandler);
			rightSp.removeEventListener(MouseEvent.MOUSE_DOWN,rightMouseDownHandler);
			promise = new PromiseVO("0",PackData.app.head.dwOperID.toString(),parent,target.toString(),reward,MyUtils.dateFormat(Global.nowDate),"N",null);
			PackData.app.CmdIStr[0] = CmdStr.INSERT_PROMISE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = parent;
			PackData.app.CmdIStr[3] = target.toString();
			PackData.app.CmdIStr[4] = reward;
			PackData.app.CmdInCnt = 5;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(MAKE_PROMISE));
		}
		
		private function getCoinsNum():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GETMONEYNUMBER));
		}
		
		private function makeSp(pro:PromiseVO):starling.display.Sprite{
			var sp:starling.display.Sprite = new starling.display.Sprite;
			var bg:Image = new Image(Assets.getTexture("qibao"));
			sp.addChild(bg);
			
			var childName:TextField = new TextField(85, 28, Global.player.name, "HuaKanT", 20, 0xcd502f);
			childName.autoScale = true;
			childName.x = 60; childName.y = 81;
			sp.addChild(childName);
			
			var target:TextField = new TextField(778, 28, "获取" + pro.gold + "个金币", "HuaKanT", 20, 0x725f5f);
			target.autoScale = true;
			target.hAlign = HAlign.LEFT;
			target.x = 165; target.y = 81;
			sp.addChild(target);
			
			var parName:TextField = new TextField(85, 28, pro.parname, "HuaKanT", 20, 0xcd502f);
			parName.autoScale = true;
			parName.x = 60; parName.y = 129;
			sp.addChild(parName);
			
			var jiangLi:TextField = new TextField(487, 67, "奖励  " + pro.rwcontent, "HuaKanT", 20, 0x725f5f);
			jiangLi.autoScale = true;
			jiangLi.hAlign = HAlign.LEFT; jiangLi.vAlign = VAlign.TOP;
			jiangLi.x = 165; jiangLi.y = 129;
			sp.addChild(jiangLi);
			
			var sign:TextField = new TextField(200, 25, Global.player.name + " / " + pro.parname, "HuaKanT", 18, 0x827968);
			sign.autoScale = true;
			sign.hAlign = HAlign.RIGHT;
			sign.x = 360; sign.y = 197;
			sp.addChild(sign);
			
			var time:TextField = new TextField(200, 25, pro.sdate.substr(0,4) + "-" + pro.sdate.substr(4,2)+ "-" + pro.sdate.substr(6,2), "HuaKanT", 20, 0x71b0c4);
			time.autoScale = true;
			time.hAlign = HAlign.RIGHT;
			time.x = 360; time.y = 220;
			sp.addChild(time);
			
			return sp;
		}
		
		
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		
	}
}