package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.HorizontalScrollerMediator;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.screens.transen.SignCard;
	import com.studyMate.world.screens.transen.WordCard;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Graphics;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;
	
	public class TestCardSentence2 extends ScreenBaseMediator
	{
		public static const NAME:String = "TestCardSentence";
		
		
		private var sentence:String = "` Having done my time with the maketing teams at Intel and Dell, I can tell you that being on the receiving end of brutally frank talk isn't as common as you might think. Far more prevalent in the corporate world is the varnished truth, followed closely by the sporadic truth.";
		
		private var sentenceLable:TextField;
		
		
		public var camera:CameraSprite;
		private var cards:Vector.<WordCard>;
		private const viewGap:int = 60;
		private var cardHolder:starling.display.Sprite;
		private var hotY:Number;
		private var choosePoint:Point;
		private var hasMove:Boolean;
		private var selectedCard:WordCard;
		
		private var _fsm:StateMachine;
		
		private static const CHOOSE:String = "choose";
		private static const START:String = "start"; 
		private static const BLANK:String = "blank";
		private static const UNCHOOSE:String = "unchoose";
		private var preCard:WordCard;
		private var currentCard:WordCard;
		private var chooseCard:WordCard;
		
		private var selectFormat:TextFormat;
		
		private var juggler:Juggler;
		
		
		private var btnHolder:starling.display.Sprite;
		private var cardsGraphics:Graphics;
		private var lineHolder:starling.display.Sprite;
		
		
		public function TestCardSentence2(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function get viewClass():Class
		{
			return starling.display.Sprite;
		}
		
		private function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			sendNotification(CoreConst.HIDE_STARUP_INFOR);
			view.stage.color = 0xeeeeee;
			
			cardHolder = new starling.display.Sprite;
			cardHolder.y = 180;
			
			lineHolder = new starling.display.Sprite;
			
			cardsGraphics = new Graphics(lineHolder);
			
			
			choosePoint = new Point;
			
			sentenceLable = new TextField();
			sentenceLable.width = 1200;
			sentenceLable.height = 40;
			sentenceLable.autoSize = TextFieldAutoSize.LEFT;
			sentenceLable.selectable = false;
			sentenceLable.wordWrap = true;
			sentenceLable.multiline = true;
			sentenceLable.y = 30;
			sentenceLable.x = 30;
			//			sentenceLable.embedFonts = true;
			sentenceLable.defaultTextFormat = new TextFormat("arial",30);
			sentenceLable.text = sentence;
			sentenceLable.addEventListener(MouseEvent.CLICK,sentenceLableHandle);
			
			selectFormat = new TextFormat(null,30,0x000000,false,null,true);
			
			Global.stage.addChild(sentenceLable);
			
			var words:Array = sentence.split(" ");
			var index:int = 0;
			
			var dArr:Vector.<flash.display.DisplayObject> =new Vector.<flash.display.DisplayObject>;
			
			var bg:Shape;
			bg = new Shape();
			bg.name = "bg";
			bg.graphics.beginFill(0xdfcd7a);
			bg.graphics.lineStyle(2,0xffffff);
			bg.graphics.drawRect(0,0,130,80);
			dArr.push(bg);
			
			/*bg = new Shape();
			bg.name = "sign1";
			bg.graphics.beginFill(0x00ff00);
			bg.graphics.lineStyle(2,0xffffff);
			bg.graphics.drawRect(0,0,100,100);*/
			
			var bmp:Bitmap;
			
			bmp = Assets.getTextureAtlasBMP(Assets.store["cardsen"],Assets.store["cardsenXML"],"sign0");
			bmp.name = "sign0";
			dArr.push(bmp);
			
			bmp = Assets.getTextureAtlasBMP(Assets.store["cardsen"],Assets.store["cardsenXML"],"sign1");
			bmp.name = "sign1";
			dArr.push(bmp);
			
			bmp = Assets.getTextureAtlasBMP(Assets.store["cardsen"],Assets.store["cardsenXML"],"sign2");
			bmp.name = "sign2";
			dArr.push(bmp);
			
			bmp = Assets.getTextureAtlasBMP(Assets.store["cardsen"],Assets.store["cardsenXML"],"sign3");
			bmp.name = "sign3";
			dArr.push(bmp);
			
			bmp = Assets.getTextureAtlasBMP(Assets.store["cardsen"],Assets.store["cardsenXML"],"sign4");
			bmp.name = "sign4";
			dArr.push(bmp);
			
			
			BitmapFontUtils.init("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ[]{}\|.,<?'\"",dArr);
			
			WorldConst.stageWidth = 1280;
			WorldConst.stageHeight = 762;
			camera = new CameraSprite(new Rectangle(0,0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			view.addChild(camera);
			
			camera.addChild(cardHolder);
			camera.addChild(lineHolder);
			
			cards = new Vector.<WordCard>;
			
			hotY = 0;
			
			for (var i:int = 0; i < words.length; i++) 
			{
				var word:WordCard = new WordCard();
				word.strIndex = index;
				word.text = words[i];
				cardHolder.addChildAt(word,0);
				word.skewY = 30*Math.PI/180
				word.x = i*viewGap;
				cards.push(word);
				
				
				index+=(words[i] as String).length;
				index+=1;
			}
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HorizontalScrollerMediator,[cards.length*viewGap,0,hotY],SwitchScreenType.SHOW,view)]);
			sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
			view.stage.addEventListener(TouchEvent.TOUCH,selectStageTouchHandle);
			createFSM();
			
			
			
			btnHolder = new starling.display.Sprite;
			
			var btn:Button;
			
			btn = new Button(Assets.getSentenceTexture("signBtn0"));
			btn.x = 80;
			btn.addEventListener(Event.TRIGGERED,signBtn0Handle);
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn1"));
			btn.addEventListener(Event.TRIGGERED,signBtn1Handle);
			btn.x = 160;
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn2"));
			btn.addEventListener(Event.TRIGGERED,signBtn2Handle);
			btn.x = 240;
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn3"));
			btn.addEventListener(Event.TRIGGERED,signBtn3Handle);
			btn.x = 320;
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn4"));
			btn.addEventListener(Event.TRIGGERED,signBtn4Handle);
			btn.x = 400;
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn5"));
			btn.x = 480;
			btn.addEventListener(Event.TRIGGERED,unsignBtnHandle);
			btnHolder.addChild(btn);
			
			
			btnHolder.x = 300;
			btnHolder.y = 350;
			view.addChild(btnHolder);
			
			juggler = new Juggler;
			Starling.juggler.add(juggler);
		}
		
		protected function sentenceLableHandle(event:MouseEvent):void
		{
			var index:int = sentenceLable.getCharIndexAtPoint(event.localX, event.localY);
			var char:String = sentenceLable.text.charAt(index);
			var currentChar:String;
			if(char==" "){
				return;
			}
			
			currentChar = char;
			var fIdx:int=index;
			var eIdx:int=index;
			while(currentChar!=" "&&fIdx>0){
				currentChar = sentenceLable.text.charAt(fIdx);
				fIdx--;
			}
			
			
			currentChar = char;
			while(currentChar!=" "&&eIdx<=sentenceLable.text.length){
				currentChar = sentenceLable.text.charAt(eIdx);
				eIdx++;
			}
			
			if(!index){
				fIdx = -2;
			}
			
			
			var cardIdx:int=0;
			for (var i:int = fIdx+2; i >0; i--) 
			{
				if(sentenceLable.text.charAt(i)==" "){
					cardIdx++;
				}
			}
			
			
			currentCard = cards[cardIdx];
			if(chooseCard==currentCard){
				_fsm.changeState(UNCHOOSE);
			}else{
				
				_fsm.changeState(BLANK);
				_fsm.changeState(CHOOSE);
			}
			
			
			
			
			
			sendNotification(WorldConst.SET_ROLL_TARGETX,-currentCard.x);
			//			sentenceLable.setTextFormat(selectFormat,fIdx+2,eIdx-1);
			
			//			trace(sentenceLable.text.substring(fIdx+2,eIdx-1));
			
			
			
			
		}
		
		private function unsignBtnHandle():void
		{
			
			if(chooseCard&&chooseCard.type!=""){
				var idx:int = cards.indexOf(chooseCard);
				cards.splice(idx,1);
				
				sentenceLable.text = sentenceLable.text.substring(0,chooseCard.strIndex-1)+sentenceLable.text.substr(chooseCard.strIndex+chooseCard.text.length);
				
				for (var i:int = idx; i < cards.length; i++) 
				{
					cards[i].strIndex-=2;
				}
				
				chooseCard.removeFromParent(true);
				sortCard();
				sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
				matchBrackets();
				currentCard = null;
				chooseCard = null;
				
			}
		}
		
		private function signBtn0Handle():void
		{
			sign("sign0_00000",WordCard.SIGN0);
		}
		
		private function signBtn1Handle():void
		{
			sign("sign1_00000",WordCard.SIGN1);
		}
		
		private function signBtn2Handle():void
		{
			sign("sign2_00000",WordCard.SIGN2);
		}
		
		private function signBtn3Handle():void
		{
			sign("sign3_00000",WordCard.SIGN3);
		}
		
		private function signBtn4Handle():void
		{
			sign("sign4_00000",WordCard.SIGN4);
		}
		
		private function sign(textureName:String,_sign:String):void{
			
			if(currentCard){
				
				var sign:WordCard = new WordCard(textureName,_sign);
				var idx:int = cards.indexOf(chooseCard);
				sign.x = (idx+1)*viewGap;
				sign.strIndex = chooseCard.strIndex+chooseCard.text.length+1;
				//				sign.skewY = 30*Math.PI/180;
				sentenceLable.text = sentenceLable.text.substring(0,chooseCard.strIndex+chooseCard.text.length)+" "+_sign+sentenceLable.text.substr(chooseCard.strIndex+chooseCard.text.length);
				sentenceLable.setTextFormat(selectFormat,chooseCard.strIndex,chooseCard.strIndex+chooseCard.text.length);
				
				for (var i:int = idx+1; i < cards.length; i++) 
				{
					cards[i].strIndex+=2;
				}
				
				
				cardHolder.addChildAt(sign,cardHolder.getChildIndex(chooseCard));
				cards.splice(idx+1,0,sign);
				sortCard();
				sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
				matchBrackets();
			}
			
		}
		
		
		
		private function sortCard():void{
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				
				if(cards[i]==chooseCard){
					juggler.tween(cards[i],0.3,{x:i*viewGap-30});
				}else{
					if(cards[i].x!=i*viewGap){
						juggler.tween(cards[i],0.3,{x:i*viewGap});
						
					}
					
				}
				
				
				
			}
			
			
		}
		
		
		private var bcount:int;
		private var nestNum:int;
		
		
		private function matchBrackets():void{
			
			cardsGraphics.clear();
			for (var i:int = 0; i < cards.length; i++) 
			{
				
				if(cards[i].type==WordCard.SIGN1||cards[i].type==WordCard.SIGN3){
					bcount = 0;
					nestNum = 1;
					var nx:Number;
					
					var diff:int=0;
					
					if(cards[i].type==WordCard.SIGN1){
						nx = fineTheOtherBracket(i,WordCard.SIGN1,WordCard.SIGN2);
						cardsGraphics.lineStyle(1,0xff0000);
					}else{
						nx = fineTheOtherBracket(i,WordCard.SIGN3,WordCard.SIGN4);
						cardsGraphics.lineStyle(1,0x00ff00);
						diff = 3;
					}
					
					if(!isNaN(nx)){
						cardsGraphics.moveTo(i*viewGap+60,160);
						cardsGraphics.lineTo(i*viewGap+60,160-nestNum*10-diff);
						cardsGraphics.lineTo(nx+60,160-nestNum*10-diff);
						cardsGraphics.lineTo(nx+60,160);
						
					}
					
					
					
				}
			}
			
		}
		
		private function fineTheOtherBracket(startIdx:int,type1:String,type2:String):Number{
			
			for (var i:int = startIdx; i < cards.length; i++) 
			{
				if(cards[i].type==type1){
					bcount++;
					nestNum++;
				}else if(cards[i].type==type2){
					bcount--;
				}
				
				if(!bcount){
					return i*viewGap;
				}
				
				
			}
			
			return NaN;
		}
		
		
		
		
		
		private function createFSM():void{
			
			_fsm = new StateMachine();
			_fsm.addState(CHOOSE,{enter:enterChoose,from:[START,BLANK,UNCHOOSE]});
			_fsm.addState(UNCHOOSE,{enter:enterUnChoose,from:[START,BLANK,CHOOSE]});
			_fsm.addState(BLANK);
			_fsm.addState(START);
			_fsm.initialState = START
			
		}
		
		private function enterUnChoose(event:StateMachineEvent):void{
			
			if(chooseCard){
				
				juggler.removeTweens(chooseCard);
				
				juggler.tween(chooseCard,0.2,{y:0,x:cards.indexOf(chooseCard)*viewGap});
				
				sentenceLable.setTextFormat(sentenceLable.defaultTextFormat,chooseCard.strIndex,chooseCard.strIndex+chooseCard.text.length);
			}
			
			chooseCard = null;
			
		}
		
		
		private function enterChoose(event:StateMachineEvent):void{
			
			
			
			if(chooseCard){
				
				juggler.removeTweens(chooseCard);
				
				juggler.tween(chooseCard,0.2,{y:0,x:cards.indexOf(chooseCard)*viewGap});
				
				sentenceLable.setTextFormat(sentenceLable.defaultTextFormat,chooseCard.strIndex,chooseCard.strIndex+chooseCard.text.length);
			}
			
			chooseCard = currentCard;
			
			juggler.removeTweens(chooseCard);
			juggler.tween(chooseCard,0.2,{y:-80,x:cards.indexOf(chooseCard)*viewGap-30});
			
			sentenceLable.setTextFormat(selectFormat,chooseCard.strIndex,chooseCard.strIndex+chooseCard.text.length);
			
			
			
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.UPDATE_CAMERA:
				{
					if(camera){
						camera.moveTo(-(notification.getBody() as int),-camera.world.y);
						if(cards!=null){
							for (var i:int = 0; i < cards.length; i++) 
							{
								if(cards[i].x>camera.viewport.right||cards[i].x<camera.viewport.left-80){
									cards[i].visible = false;
								}else{
									cards[i].visible = true;
								}
							}
						}
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
			return [WorldConst.UPDATE_CAMERA];
		}
		
		
		
		private function selectStageTouchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(cardHolder);
			if(touch&&touch.globalY>hotY){
				touch.getLocation(cardHolder,choosePoint);
				var item:starling.display.DisplayObject = cardHolder.hitTest(choosePoint);
				var touchCard:WordCard;
				if(item){
					touchCard = item.parent as WordCard;
				}
				if(!touchCard||(selectedCard&&selectedCard==touchCard)){
					return;
				}
				
				if(touch.phase==TouchPhase.BEGAN){
					hasMove = false;
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,-1);
				}else if(touch.phase==TouchPhase.MOVED&&currentCard != touchCard){
					hasMove = true;
					currentCard = touchCard;
					if(currentCard!=chooseCard){
						_fsm.changeState(BLANK);
						_fsm.changeState(CHOOSE);
						
					}
				}else if(touch.phase==TouchPhase.ENDED&&!hasMove){
					currentCard = touchCard;
					if(currentCard!=chooseCard){
						_fsm.changeState(BLANK);
						_fsm.changeState(CHOOSE);
					}else{
						_fsm.changeState(UNCHOOSE);
					}
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
				}
			}else{
				sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
			}
		}
		
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		
		
		
		
	}
}
import com.studyMate.world.screens;

