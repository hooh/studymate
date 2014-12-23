package com.studyMate.module.engLearn.ui
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.module.engLearn.api.LearnConst;
	import com.studyMate.module.engLearn.utils.SentenceUtils;
	import com.studyMate.module.engLearn.vo.ReadAloudVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.events.FeathersEventType;
	
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * 
	 * function updateTitle(vo:ReadAloudVO)
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 挖词填空
	 * 2014-10-30上午9:51:28
	 * Author wt
	 *
	 */	
	
	public class AloudExamFillUI extends Sprite
	{
		private var usLabel:ChangeEffectLabel;
		private var cnLabel:Label;
		private var inputTXT:TextFieldHasKeyboard;
		private var nextBtn:Button
		
		private var yesTip:Image;
		private var errorTip:Image;
		
		public var vo:ReadAloudVO;
		private var word:String;
		
		private var cm:ColorMatrixFilter;
		private var inputBg:Image;
		private var isCheck:Boolean;
		
		public function AloudExamFillUI()
		{		
			cm = new ColorMatrixFilter();
			cm.adjustBrightness(-0.2);
			cm.adjustContrast(0);
			cm.adjustSaturation(0);
			cm.adjustHue(0);
			addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		override public function dispose():void
		{	
			if(usLabel)
				usLabel.removeEventListener(Event.RESIZE,flatenHandler);
			TweenMax.killDelayedCallsTo(delayRegister);
			TweenMax.killTweensOf(yesTip);
			TweenMax.killTweensOf(errorTip);
			TweenLite.killTweensOf(nextBtn);
			inputTXT.removeEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);
			AppLayoutUtils.cpuLayer.removeChild(inputTXT);
			
			super.dispose();
		}
		
		
		private function addToStageHandler(e:Event):void
		{
	
			//英文提示
			usLabel = new ChangeEffectLabel();
//			usLabel.textRendererFactory = function():ITextRenderer{
//				return new TextFieldTextRenderer;
//			}
			usLabel.textRendererProperties.textFormat = new TextFormat( "HeiTi", 26, 0xffffff,true );
//			usLabel.textRendererProperties.embedFonts = true;
//			usLabel.wordWrap = true;
			usLabel.maxWidth = 800;
			usLabel.x = 272;
			usLabel.y = 159;
			this.addChild(usLabel);
			
			
			//中文提示
			cnLabel = new Label;
			cnLabel.textRendererFactory = function():ITextRenderer{
				return new TextFieldTextRenderer;
			}
			cnLabel.textRendererProperties.textFormat = new TextFormat( "HeiTi", 24, 0x53d9ff,true );
			cnLabel.textRendererProperties.embedFonts = true;
			cnLabel.wordWrap = true;
			cnLabel.visible = false;
			cnLabel.x = 272;
			cnLabel.y = 220;
			cnLabel.width = 800;
			this.addChild(cnLabel);
			
			nextBtn = new Button(Assets.readAloudTexture("nextBtn"));
			nextBtn.x = 948;
			nextBtn.y = 540;
			centerPivot(nextBtn);
			this.addChild(nextBtn);
			nextBtn.visible = false;
			
			inputBg = new Image(Assets.readAloudTexture("inputBg"));
			inputBg.x = 266;
			inputBg.y = 309;
			inputBg.touchable = false;
			this.addChild(inputBg);
			
			var tf:TextFormat = new TextFormat("HeiTi",36,0,true);
			inputTXT = new TextFieldHasKeyboard();//输入文本
			inputTXT.defaultTextFormat = tf;
//			inputTXT.prompt = '请输入答案';
			inputTXT.x = 273;
			inputTXT.y = 313;
			inputTXT.width = 715;
			inputTXT.height = 72;
			inputTXT.maxChars = 30;
			inputTXT.restrict = "A-Za-z0-9";
			inputTXT.softKeyboardRestrict = /[a-zA-Z0-9]/;
			AppLayoutUtils.cpuLayer.addChild(inputTXT);
//			inputTXT.border = true;
			
			yesTip = new Image(Assets.readAloudTexture("goodTip"));
			yesTip.x = 326;
			yesTip.y = 306;
			yesTip.alpha = 0;
			yesTip.touchable = false;
			this.addChild(yesTip);
			
			errorTip = new Image(Assets.readAloudTexture("errorTip"));
			errorTip.x = 326;
			errorTip.y = 306;
			errorTip.alpha = 0;
			errorTip.touchable = false;
			this.addChild(errorTip);
			
			nextBtn.addEventListener(Event.TRIGGERED,nextHandler);
			
		}		
		
		private function nextHandler(e:Event):void
		{
			inputTXT.text = '';
			nextBtn.visible = false;
			Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.NEXT_ALOUD);
		}
		
		protected function inputKeyDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 13) {//回车		
				var userAnswer:String = inputTXT.text.replace(/\s/g,'');
				if(userAnswer =='') return;
				inputTXT.removeEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);
				if(userAnswer.toLowerCase() == word.toLowerCase()){
					rightHandler(userAnswer);
				}else{
					errorHandler(userAnswer);
				}
				cnLabel.visible = true;//只要有回答。无论对错都显示中文
			}
		}
		
		//回答正确处理流程
		private function rightHandler(value:String):void{
			if(!isCheck){
				Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.ANSWER_RIGHT,"`R`"+value+'/'+word);
				isCheck = true;
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordRight",0.7));
			
			nextBtn.visible = true;	
			TweenLite.from(nextBtn,0.4,{scaleX:8,scaleY:8,alpha:0});
			Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
			inputTXT.mouseEnabled = false;
			Global.stage.focus = null;
			
			this.inputBg.filter = cm;
			
			yesTip.alpha = 0;
			TweenMax.killDelayedCallsTo(delayRegister);
			TweenMax.to(yesTip,0.5,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut});
		}
		//回答错误处理流程
		private function errorHandler(value:String):void{
			if(!isCheck){
				Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.ANSWER_WRONG,"`E`"+value+'/'+word);
				isCheck = true;
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.RESET_SOUND);

//			inputTXT.selectTextRange(0,inputTXT.text.length);
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordError",0.4));
			updateCurrent();//打错刷新当前句子
			errorTip.alpha = 0;
			TweenMax.to(errorTip,0.5,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut});
			TweenMax.killDelayedCallsTo(delayRegister);
			TweenMax.delayedCall(1,delayRegister);
		}
		
		private function delayRegister():void{
			inputTXT.text = '';
			inputTXT.addEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);
		}
		
		
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(value){
				inputTXT.visible = true;
				inputTXT.text = '';
				inputTXT.setFocus();				
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
				inputTXT.visible = false;
			}
		}
		
		
		
		
		private function updateCurrent():void{
			var obj:Object = SentenceUtils.blankWord();
			if(isCheck){
				usLabel.updateChange(obj.blankTxt,2);
			}else{				
				usLabel.text = obj.blankTxt;
			}
			word = obj.fillWord
		}
		
//		private var isCheck:Boolean;
		//切换刷新当前题目
		public function updateTitle(vo:ReadAloudVO):void{
			isCheck = false;
			this.vo = vo;
			this.inputBg.filter = null;
//			isCheck = false;
			cnLabel.text = vo.cnSentence;
			cnLabel.visible = false;
			nextBtn.visible = false;
			SentenceUtils.updateFilterTxt(vo.usSentence);
			updateCurrent();
			inputTXT.mouseEnabled = true;
			inputTXT.addEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);
			
			usLabel.addEventListener(Event.RESIZE,flatenHandler);
			
		}
		
		private function flatenHandler(e:Event):void
		{
			cnLabel.y = usLabel.y + usLabel.height+20;
			inputTXT.y = cnLabel.y + cnLabel.height +40;
			inputBg.y = inputTXT.y  - 7;
		}
		
		
		
		
	
		
	}
}