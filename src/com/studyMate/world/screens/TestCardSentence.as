package com.studyMate.world.screens
{
	import com.freshplanet.lib.ui.scroll.mobile.ScrollController;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.screens.transen.SignVO;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;

	public class TestCardSentence extends ScreenBaseMediator
	{
		public static const NAME:String = "TestCardSentence";
		
		
		private var sentence:String = "` Having done my time with the maketing teams at Intel and Dell, I can tell you that being on the receiving end of brutally frank talk isn't as common as you might think. Far more prevalent in the corporate world is the varnished truth, followed closely by the sporadic truth.";
		
		private var sentenceLable:TextField;
		
		
		private var cardHolder:starling.display.Sprite;
		private var hotY:Number;
		private var p1:Point;
		private var p2:Point;
		private var hasMove:Boolean;
		
		private var _fsm:StateMachine;
		
		private static const CHOOSE:String = "choose";
		private static const START:String = "start"; 
		private static const BLANK:String = "blank";
		private static const UNCHOOSE:String = "unchoose";
		
		private var bformat:TextFormat;
		
		private var selectFormat:TextFormat;
		
		private var juggler:Juggler;
		
		
		private var btnHolder:starling.display.Sprite;
		
		private var currentWord:Point;
		private var chooseWord:Point;
		private var signs:Array;
		private var addedSigns:Vector.<SignVO>;
		
		public static const SIGN0:String = "|";
		public static const SIGN1:String = "[";
		public static const SIGN2:String = "]";
		public static const SIGN3:String = "(";
		public static const SIGN4:String = ")";
		
		
		private var signsFormat:Dictionary;
		
		private var graphics:Graphics;
		
		private var pen:Bitmap;
		
		private var idInput:TextField;
		
		private static const REC_TEXT:String = NAME+"recText";
		private var range:Rectangle;
		
		private var pun:Array;
		
		
		
		public function TestCardSentence(mediatorName:String=null, viewComponent:Object=null)
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
			
			currentWord = new Point(0,1);
			
			cardHolder = new starling.display.Sprite;
			cardHolder.y = 180;
			
			graphics = AppLayoutUtils.cpuLayer.graphics;
			
			
			addedSigns = new Vector.<SignVO>;
			
			pun = [" ",".","'","!",",","-","\r","?","\""];
			
			
			
			p1 = new Point;
			p2 = new Point;
			
			sentenceLable = new TextField();
			sentenceLable.width = 1100;
			sentenceLable.height = 40;
			sentenceLable.autoSize = TextFieldAutoSize.LEFT;
			sentenceLable.selectable = false;
			sentenceLable.wordWrap = true;
			sentenceLable.multiline = true;
			sentenceLable.y = 30;
			sentenceLable.x = 100;
//			sentenceLable.embedFonts = true;
			sentenceLable.defaultTextFormat = new TextFormat("arial",40);
			sentenceLable.text = sentence;
			sentenceLable.addEventListener(MouseEvent.CLICK,sentenceLableHandle);
			
			signs = [SIGN0,SIGN1,SIGN2,SIGN3,SIGN4];
			
			selectFormat = new TextFormat(null,40,0x0000ff,false,null,false);
			bformat = new TextFormat(null,40,0x0000ff,false,null);
			
			
			scroller = new ScrollController();
			range =  new Rectangle(0, 0, AppLayoutUtils.cpuLayer.stage.stageWidth , AppLayoutUtils.cpuLayer.stage.stageHeight );
			scroller.horizontalScrollingEnabled = false;
			scroller.addScrollControll(AppLayoutUtils.cpuLayer,AppLayoutUtils.cpuLayer.stage,new Rectangle(0, 0, AppLayoutUtils.cpuLayer.stage.stageWidth , AppLayoutUtils.cpuLayer.stage.stageHeight ),range);
			
			
			AppLayoutUtils.cpuLayer.addChild(sentenceLable);
			
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
			
			signsFormat = new Dictionary;
			
			signsFormat[SIGN0] = new TextFormat("arial",40,0x91df2c);
			signsFormat[SIGN1] = new TextFormat("arial",40,0xde3ad1);
			signsFormat[SIGN2] = signsFormat[SIGN1];
			signsFormat[SIGN3] = new TextFormat("arial",40,0xfed464);
			signsFormat[SIGN4] = signsFormat[SIGN3];
			
			pen = Assets.getTextureAtlasBMP(Assets.store["cardsen"],Assets.store["cardsenXML"],"pen");
			pen.visible = false;
			pen.scaleY = -1;
			AppLayoutUtils.cpuLayer.addChild(pen);
			
			
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
			
			hotY = 0;
			
			createFSM();
			
			
			
			btnHolder = new starling.display.Sprite;
			
			var btn:Button;
			
			btn = new Button(Assets.getSentenceTexture("next"));
			btn.x = 1200;
			btn.y = -10;
			btn.addEventListener(Event.TRIGGERED,nextBtnHandle);
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("pre"));
			btn.y = -10;
			btn.addEventListener(Event.TRIGGERED,preBtnHandle);
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn0"));
			btn.y = 120;
			btn.addEventListener(Event.TRIGGERED,signBtn0Handle);
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn0"));
			btn.x = 1200;
			btn.y = 120;
			btn.addEventListener(Event.TRIGGERED,signBtn0Handle);
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn1"));
			btn.addEventListener(Event.TRIGGERED,signBtn1Handle);
			btn.y = 200;
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn2"));
			btn.addEventListener(Event.TRIGGERED,signBtn2Handle);
			btn.x = 1200;
			btn.y = 200;
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn3"));
			btn.addEventListener(Event.TRIGGERED,signBtn3Handle);
			btn.y = 280;
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn4"));
			btn.addEventListener(Event.TRIGGERED,signBtn4Handle);
			btn.x = 1200;
			btn.y = 280;
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("signBtn5"));
			btn.x = 1200;
			btn.y = 440;
			btn.addEventListener(Event.TRIGGERED,unsignBtnHandle);
			btnHolder.addChild(btn);
			
			
			btn = new Button(Assets.getSentenceTexture("space"));
			btn.y = 360;
			btn.addEventListener(Event.TRIGGERED,spcaeBtnHandle);
			btnHolder.addChild(btn);
			
			btn = new Button(Assets.getSentenceTexture("enter"));
			btn.x = 1200;
			btn.y = 360;
			btn.addEventListener(Event.TRIGGERED,enterBtnHandle);
			btnHolder.addChild(btn);
			
			btnHolder.x = 10;
			btnHolder.y = 80;
			view.addChild(btnHolder);
			
			
			idInput = new TextField();
			idInput.border = true;
			idInput.type = TextFieldType.INPUT;
			idInput.maxChars = 5;
//			idInput.restrict = "0-9";
			idInput.width = 80;
			idInput.height = 30;
			idInput.x = 1160;
			idInput.y = 20;
			idInput.addEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			AppLayoutUtils.cpuLayer.addChild(idInput);
			
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			scroller.removeScrollControll();
			AppLayoutUtils.cpuLayer.removeChild(pen);
			AppLayoutUtils.cpuLayer.removeChild(sentenceLable);
			AppLayoutUtils.cpuLayer.removeChild(idInput);
			
			graphics.clear();
			
		}
		
		
		protected function inputHandle(event:KeyboardEvent):void
		{
			if(event.charCode==13){
				PackData.app.CmdIStr[0] = CmdStr.SELECTYYREAD;
				PackData.app.CmdIStr[1] = idInput.text;
				PackData.app.CmdInCnt = 2;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(REC_TEXT));
			}
			
		}
		
		private function enterBtnHandle():void
		{
			if(chooseWord){
				sentenceLable.replaceText(chooseWord.y,chooseWord.y,"\n");
				sentenceLable.setTextFormat(sentenceLable.defaultTextFormat,chooseWord.y,chooseWord.y+1);
				for (var i:int = 0; i < addedSigns.length; i++) 
				{
					
					if(addedSigns[i].idx>chooseWord.y){
						addedSigns[i].idx+=1;
					}
					
					
				}
				matchBrackets();
			}
		}
		
		private function spcaeBtnHandle():void
		{
			space();
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
			
			
			if(pun.indexOf(currentChar)>=0){
				currentWord = new Point(index,index+1);
			}else{
				
				var fIdx:int=index;
				var eIdx:int=index;
				while(pun.indexOf(currentChar)<0&&fIdx>0){
					currentChar = sentenceLable.text.charAt(fIdx);
					fIdx--;
				}
				
				
				currentChar = char;
				while(pun.indexOf(currentChar)<0&&eIdx<=sentenceLable.text.length){
					currentChar = sentenceLable.text.charAt(eIdx);
					eIdx++;
				}
				
				if(!index){
					fIdx = -2;
				}
				
				currentWord = new Point(fIdx+2,eIdx-1);
			}
			
			
			
			
			if(chooseWord&&currentWord.equals(chooseWord)){
				_fsm.changeState(UNCHOOSE);
			}else{
				
				_fsm.changeState(BLANK);
				_fsm.changeState(CHOOSE);
			}
			
			
			
		}
		
		private function unsignBtnHandle():void
		{
				
				if(chooseWord){
					var char:String;
					var i:int;
					
						char = sentenceLable.text.charAt(chooseWord.y);
						var charCode:Number = sentenceLable.text.charCodeAt(chooseWord.y);
						var nextChar:String = sentenceLable.text.charAt(chooseWord.y+1);
						
						var isSign:Boolean = signs.indexOf(nextChar)>=0?true:false;
						
						if((char==" "&&pun.indexOf(sentenceLable.text.charAt(chooseWord.y+1))>=0)||charCode==13){
							
							sentenceLable.replaceText(chooseWord.y,chooseWord.y+1,"");
							
							for (i = 0; i < addedSigns.length; i++) 
							{
								
								if(addedSigns[i].idx>chooseWord.y+reduceChar){
									addedSigns[i].idx--;
								}
							}
							
							matchBrackets();
							
						}else if(isSign){
							var reduceChar:uint =2;
							sentenceLable.text = sentenceLable.text.substring(0,chooseWord.y)+sentenceLable.text.substr(chooseWord.y+reduceChar);
							sentenceLable.setTextFormat(selectFormat,chooseWord.x,chooseWord.y);
							
							
							
							for (i = 0; i < addedSigns.length; i++) 
							{
								
								if(addedSigns[i].idx==chooseWord.y+1){
									addedSigns.splice(i,1);
								}
								
							}
							
							
							
							for (i = 0; i < addedSigns.length; i++) 
							{
								
								if(addedSigns[i].idx>chooseWord.y+reduceChar){
									addedSigns[i].idx-=reduceChar;
								}
							}
							
							
							
							refreshColor();
							matchBrackets();
							filterSign();
							
						}
					
					
					
					
					
					
					
				
			}
		}
		
		private function signBtn0Handle():void
		{
				sign(SIGN0);
		}
		
		private function nextBtnHandle():void{
			
			
			var sidx:int=-1;
			var eidx:int;
			if(currentWord){
				sidx=currentWord.y;
			}else{
				sidx = 0;
			}
			
			if(sidx==sentenceLable.text.length){
				return;
			}
			
			var char:String;
			char = sentenceLable.text.charAt(currentWord.y);
			
			
			
			if(char!=" "&&pun.indexOf(char)>=0){
				currentWord.setTo(currentWord.y,currentWord.y+1);
			}else if(char==" "&&pun.indexOf(sentenceLable.text.charAt(currentWord.y+1))>=0){
				currentWord.setTo(currentWord.y+1,currentWord.y+2);
			
			}else{
				
				if(char=="<"){
					
					
					while(sidx<sentenceLable.text.length){
						char = sentenceLable.text.charAt(sidx);
						
						if(char==">"){
							sidx++;
							break;
						}else{
							sidx++;
						}
					}
					
					
					while(sidx<sentenceLable.text.length){
						char = sentenceLable.text.charAt(sidx);
						
						if(char!=" "){
							break;
						}else{
							sidx++;
						}
					}
					
					
				}
				
				if(char!=" "&&pun.indexOf(char)>=0){
					currentWord.setTo(sidx,sidx+1);
				}else{
					
					while(sidx<sentenceLable.text.length){
						char = sentenceLable.text.charAt(sidx);
						
						if(pun.indexOf(char)>=0){
							sidx++;
						}else{
							break;
						}
						
					}
					
					if(sidx==sentenceLable.text.length){
						return;
					}
					
					eidx = sidx+1;
					
					while(eidx<sentenceLable.text.length){
						char = sentenceLable.text.charAt(eidx);
						if(pun.indexOf(char)<0){
							eidx++;
						}else{
							break;
						}
					}
					
					currentWord.setTo(sidx,eidx);
				}
			}
				
				
				
				
			
			
			_fsm.changeState(BLANK);
			_fsm.changeState(CHOOSE);
			
		}
		
		
		private function preBtnHandle():void{
			
			
			var sidx:int=-1;
			var eidx:int=sentenceLable.text.length;
			if(currentWord){
				eidx=currentWord.x-1;
			}else{
				eidx = sentenceLable.text.length;
			}
			
			if(eidx<=0){
				return;
			}
			
			var char:String;
			
			char = sentenceLable.text.charAt(currentWord.x-1);
			
			if(char!=" "&&pun.indexOf(char)>=0){
				currentWord.setTo(currentWord.x-1,currentWord.x);
			}else{
				
				
				while(eidx>0){
					char = sentenceLable.text.charAt(eidx);
					
					if(pun.indexOf(char)>=0){
						eidx--;
					}else{
						break;
					}
					
				}
				
				if(eidx<0){
					return;
				}
				
				if(char==">"){
					while(eidx>0){
						
						char = sentenceLable.text.charAt(eidx);
						
						if(char!="<"){
							eidx--;
						}else{
							eidx--;
							break;
						}
						
					}
					
					
					currentWord.setTo(eidx,eidx+1);
				}else{
					
					sidx = eidx-1;
					
					while(sidx>0){
						char = sentenceLable.text.charAt(sidx);
						if(pun.indexOf(char)<0){
							sidx--;
						}else{
							break;
						}
					}
					
					currentWord.setTo(sidx+1,eidx+1);
				}
				
				
			}
			
			
			
			_fsm.changeState(BLANK);
			_fsm.changeState(CHOOSE);
			
		}
		
		
		private function signBtn1Handle():void
		{
			sign(SIGN1);
		}
		
		private function signBtn2Handle():void
		{
			sign(SIGN2);
		}
		
		private function signBtn3Handle():void
		{
			sign(SIGN3);
		}
		
		private function signBtn4Handle():void
		{
			sign(SIGN4);
		}
		
		private function sign(_sign:String):void{
			
			if(chooseWord){
				
				sentenceLable.text = sentenceLable.text.substring(0,chooseWord.y)+" "+_sign+sentenceLable.text.substr(chooseWord.y);
				
				
				sentenceLable.setTextFormat(selectFormat,chooseWord.x,chooseWord.y);
				
				
				for (var i:int = 0; i < addedSigns.length; i++) 
				{
					
					if(addedSigns[i].idx>chooseWord.y){
						addedSigns[i].idx+=2;
					}
					
					
				}
				
				addedSigns.push(new SignVO(chooseWord.y+1,_sign));
				
				
				chooseWord.x=chooseWord.y;
				chooseWord.y+=2;
				_fsm.changeState(BLANK);
				_fsm.changeState(CHOOSE);
				
			}
			
		}
		
		private function space():void{
			
			if(chooseWord){
				sentenceLable.replaceText(chooseWord.y,chooseWord.y," ");
				sentenceLable.setTextFormat(sentenceLable.defaultTextFormat,chooseWord.y,chooseWord.y+1);
				for (var i:int = 0; i < addedSigns.length; i++) 
				{
					
					if(addedSigns[i].idx>chooseWord.y){
						addedSigns[i].idx+=1;
					}
					
					
				}
				matchBrackets();
			}
			
			
		}
		
		
		
		
		private function refreshColor():void{
			
			for (var i:int = 0; i < addedSigns.length; i++) 
			{
				
				sentenceLable.setTextFormat(signsFormat[addedSigns[i].type],addedSigns[i].idx,addedSigns[i].idx+1);
				
				
			}
			
			
			
			
		}
		
		private function sortOnIdx(a:SignVO, b:SignVO):Number {
			if(a.idx > b.idx) {
				return 1;
			} else if(a.idx < b.idx) {
				return -1;
			} else  {
				return 0;
			}
		}
		
		private function sortOnIdxDesc(a:SignVO, b:SignVO):Number {
			if(a.idx > b.idx) {
				return -1;
			} else if(a.idx < b.idx) {
				return 1;
			} else  {
				return 0;
			}
		}
		
		
		
		private var bcount:int;
		private var nestNum:int;
		private var scroller:ScrollController;
		
		
		private function matchBrackets():void{
			
			graphics.clear();
			
			addedSigns.sort(sortOnIdx);
			
			for (var i:int = 0; i < addedSigns.length; i++) 
			{
				
				if(addedSigns[i].type==SIGN1||addedSigns[i].type==SIGN3){
					bcount = 0;
					nestNum = 1;
					var nx:SignVO;
					
					var diff:int=0;
					
					if(addedSigns[i].type==SIGN1){
						nx = fineTheOtherBracket(i,SIGN1,SIGN2);
						graphics.lineStyle(1,uint((signsFormat[addedSigns[i].type] as TextFormat).color));
					}else{
						nx = fineTheOtherBracket(i,SIGN3,SIGN4);
						graphics.lineStyle(1,uint((signsFormat[addedSigns[i].type] as TextFormat).color));
						diff = 12;
					}
					
					if(nx){
					
						var b1:Rectangle = sentenceLable.getCharBoundaries(addedSigns[i].idx);
						var b2:Rectangle = sentenceLable.getCharBoundaries(nx.idx);
						
						var line1:int = sentenceLable.getLineIndexOfChar(addedSigns[i].idx);
						var line2:int = sentenceLable.getLineIndexOfChar(nx.idx);
						
						if(line1==line2){
							graphics.moveTo(b1.right+sentenceLable.x,b1.bottom+20+nestNum*3-diff);
							graphics.lineTo(b2.left+sentenceLable.x,b1.bottom+20+nestNum*3-diff);
						}else{
							var line:TextLineMetrics = sentenceLable.getLineMetrics(line1);
							
							
							graphics.moveTo(b1.right+sentenceLable.x,b1.bottom+20+nestNum*3-diff);
							graphics.lineTo(sentenceLable.x+line.width,b1.bottom+20+nestNum*3-diff);
							
							
							for (var j:int = line1+1; j < line2; j++) 
							{
								
								var fidx:int = sentenceLable.getLineOffset(j);
								line = sentenceLable.getLineMetrics(j);
								b1 = sentenceLable.getCharBoundaries(fidx);
								
								if(b1){
									graphics.moveTo(sentenceLable.x,b1.bottom+20+nestNum*3-diff);
									graphics.lineTo(sentenceLable.x+line.width,b1.bottom+20+nestNum*3-diff);
									
								}
								
							}
							
							graphics.moveTo(sentenceLable.x,b2.bottom+20+nestNum*3-diff);
							graphics.lineTo(sentenceLable.x+b2.left,b2.bottom+20+nestNum*3-diff);
							
							graphics.endFill();
							
						}
						
						
						
						
					}
					
					
					
				}
			}
			
			range.setTo(0, 0, WorldConst.stageWidth,sentenceLable.textHeight+100);
			scroller.setContentRect(range);
			
		}
		
		private function fineTheOtherBracket(startIdx:int,type1:String,type2:String):SignVO{
			
			for (var i:int = startIdx; i < addedSigns.length; i++) 
			{
				if(addedSigns[i].type==type1){
					bcount++;
					nestNum++;
				}else if(addedSigns[i].type==type2){
					bcount--;
				}
				
				if(!bcount){
					return addedSigns[i];
				}
				
				
			}
			
			return null;
		}
		
		
		
		
		
		private function createFSM():void{
			
			_fsm = new StateMachine();
			_fsm.addState(CHOOSE,{enter:enterChoose,from:[START,BLANK,UNCHOOSE]});
			_fsm.addState(UNCHOOSE,{enter:enterUnChoose,from:[START,BLANK,CHOOSE]});
			_fsm.addState(BLANK);
			_fsm.addState(START);
			_fsm.initialState = START;
			
		}
		
		private function enterUnChoose(event:StateMachineEvent):void{
			
			sentenceLable.setTextFormat(sentenceLable.defaultTextFormat,0,sentenceLable.length);
			pen.visible = false;
			chooseWord = null;
			currentWord.setTo(0,0);
			refreshColor();
		}
		
		
		private function enterChoose(event:StateMachineEvent):void{
			
			
			
			sentenceLable.setTextFormat(sentenceLable.defaultTextFormat,0,sentenceLable.text.length);
			
			chooseWord = currentWord;
			
			
			
			
			refreshColor();
			sentenceLable.setTextFormat(selectFormat,chooseWord.x,chooseWord.y);
			filterSign();
			matchBrackets();
			var currentRange:Rectangle = sentenceLable.getCharBoundaries(chooseWord.y);
			pen.visible = true;
			if(currentRange){
				pen.x = currentRange.x+sentenceLable.x;
				pen.y = currentRange.y+sentenceLable.y+pen.height-20;
			}else{
				
				var lastLine:TextLineMetrics;
				
				var lineIdx:int = sentenceLable.getLineIndexOfChar(chooseWord.y);
				
				
				if(lineIdx<0){
					lineIdx = sentenceLable.numLines - 1;
				}
				
				lastLine= sentenceLable.getLineMetrics(lineIdx);
				
				var totalH:int = 0;
				
				var i:int;
				while(i<=lineIdx){
					totalH+=sentenceLable.getLineMetrics(lineIdx).height;
					i++;
				}
				
					
				pen.x = lastLine.width+sentenceLable.x;
				pen.y = sentenceLable.y+totalH-20;
				
			}
			
		}
		
		private function filterSign():void{
			var nx:SignVO;
			var sign:SignVO;
			for (var i:int = 0; i < addedSigns.length; i++) 
			{
				if(addedSigns[i].idx==chooseWord.x){
					sign = addedSigns[i];
					break;
				}
			}
			
			if(sign){
				
				if(sign.type==SIGN1){
					addedSigns.sort(sortOnIdx);
					nx = fineTheOtherBracket(addedSigns.indexOf(sign),SIGN1,SIGN2);
					
					if(nx){
						sentenceLable.setTextFormat(bformat,sign.idx,nx.idx+1);
					}
				}else if(sign.type==SIGN3){
					addedSigns.sort(sortOnIdx);
					nx = fineTheOtherBracket(addedSigns.indexOf(sign),SIGN3,SIGN4);
					
					if(nx){
						sentenceLable.setTextFormat(bformat,sign.idx,nx.idx+1);
					}
				
				}else if(sign.type==SIGN2){
					addedSigns.sort(sortOnIdxDesc);
					nx = fineTheOtherBracket(addedSigns.indexOf(sign),SIGN2,SIGN1);
					
					if(nx){
						sentenceLable.setTextFormat(bformat,nx.idx,sign.idx-1);
					}
				}else if(sign.type==SIGN4){
					addedSigns.sort(sortOnIdxDesc);
					nx = fineTheOtherBracket(addedSigns.indexOf(sign),SIGN4,SIGN3);
					
					if(nx){
						sentenceLable.setTextFormat(bformat,nx.idx,sign.idx-1);
					}
				}
			}
			
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case REC_TEXT:{
					
					var result:DataResultVO = notification.getBody() as DataResultVO;
					
					if(!result.isErr){
						
						var json:Object = JSON.parse(PackData.app.CmdOStr[24]);
						var sentence:String = "";
						var parts:Array = json.content.parts;
						
						for (var i:int = 0; i < parts.length; i++) 
						{
							var ss:Array = parts[i].sentence;
							
							for (var j:int = 0; j < ss.length; j++) 
							{
								sentence+="<@"+ss[j].markno+">   "+ss[j].datastr+"\n";
							}
							
							
							
						}
						
						sentence = sentence.replace(/<br>/g,"\n\n");
						
						sentenceLable.text = sentence;
						
						currentWord.setTo(0,0);
						pen.visible = false;
						addedSigns.splice(0,addedSigns.length);
						graphics.clear();
						range.setTo(0, 0, WorldConst.stageWidth,sentenceLable.textHeight+100);
						scroller.setContentRect(range);
						
						
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
			return [REC_TEXT];
		}
		
		

		
		
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		
		
		
		
	}
}