package com.studyMate.module.engLearn.ui
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.module.engLearn.ReadAloundLearnMediator;
	import com.studyMate.module.engLearn.api.LearnConst;
	import com.studyMate.module.engLearn.vo.ReadAloudVO;
	import com.studyMate.view.component.GpuTextField.TextFieldToGPU;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	
	
	/**
	 * 朗读0，1，2学习阶段专用
	 * 2014-10-24下午4:41:11
	 * Author wt
	 *
	 */	
	
	public class AloundLearnItemRenderer extends BaseListItemRenderer
	{
		private var bgImg:Scale9Image;
		private var bgImg2:Scale9Image;
		private var soundBtn:Button;
		private var soundBtn2:Button;
		private var contentTxt:flash.text.TextField;
		private var container:Sprite;
		public static var showCn:Boolean;
		
		private var _cm:ColorMatrixFilter;
		
		private var defaultTextformat:TextFormat;
		private var colorTextformat:TextFormat;
		
		public function AloundLearnItemRenderer()
		{
			super();
		}

		public function get cm():ColorMatrixFilter
		{
			/*_cm = new ColorMatrixFilter();
			_cm.adjustBrightness(0);
			_cm.adjustContrast(0.05);
			_cm.adjustSaturation(0.1);
			_cm.adjustHue(-0.65);*/
			_cm = new ColorMatrixFilter();
			_cm.adjustBrightness(0);
			_cm.adjustContrast(0.15);
			_cm.adjustSaturation(0.1);
			_cm.adjustHue(-70/180);
			return _cm;
		}

		override public function dispose():void
		{
			TweenLite.killTweensOf(bgImg);
			TweenLite.killTweensOf(soundBtn);
			this.removeChildren(0,-1,true);
			super.dispose();
		}
		override protected function initialize():void
		{
			bgImg2 = new Scale9Image(new Scale9Textures(Assets.readAloudTexture('blackBoardImg2'),new Rectangle(250,200,400,40)));//绿色
			bgImg2.touchable = false;
			bgImg2.x = 172;
			bgImg2.visible = false;
			
			this.addChild(bgImg2);
			
			bgImg = new Scale9Image(new Scale9Textures(Assets.readAloudTexture('blackBoardImg'),new Rectangle(250,200,400,40)));//黄色
			bgImg.touchable = false;
			bgImg.x = 172;
			this.addChild(bgImg);
			
			
			
			soundBtn2 = new Button(Assets.readAloudTexture("soundBtn2"));//绿色
			soundBtn2.x = 146;
			soundBtn2.visible = false;
			this.addChild(soundBtn2);
			
			soundBtn = new Button(Assets.readAloudTexture("soundBtn"));//黄色
			soundBtn.x = 146;
			this.addChild(soundBtn);
			
			defaultTextformat = new TextFormat("HeiTi",28,0xFFFFFF,true);
			defaultTextformat.letterSpacing = 1;
			defaultTextformat.leading = 10;
			
			colorTextformat = new TextFormat("HeiTi",22,0xcccccc,true);
			colorTextformat.letterSpacing = 1;
			colorTextformat.leading = 10;
			
			contentTxt = new flash.text.TextField();
			contentTxt.embedFonts = true;
			contentTxt.autoSize = TextFieldAutoSize.LEFT;
			contentTxt.antiAliasType = AntiAliasType.ADVANCED;
			contentTxt.defaultTextFormat = defaultTextformat;
			contentTxt.width = 800;
			contentTxt.multiline = true;
			contentTxt.wordWrap = true;	
			
			container = new Sprite();
//			container.x = 260;
			this.addChild(container);
			
			soundBtn.addEventListener(Event.TRIGGERED,soundStartHandler);
			soundBtn2.addEventListener(Event.TRIGGERED,soundStartHandler);
		}
		
		private function soundStartHandler():void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.SOUND_PLAY,this._data.vo);
		}
		

		override protected function commitData():void
		{
			if(this._data)//进入过的转绿色
			{
				if(this._data.hasEnter){										
					bgImg2.visible = true;
					soundBtn2.visible = true;
					soundBtn2.touchable = true;
					soundBtn.touchable = false;
					if(this._data.effect){
						this._data.effect = false;
						bgImg.visible = true;
						soundBtn.visible = true;
						TweenLite.to(bgImg,1,{alpha:0});
						TweenLite.to(soundBtn,1,{alpha:0});
					}else{
						bgImg.visible = false;
						soundBtn.visible = false;
					}
				}else{
					TweenLite.killTweensOf(bgImg);
					TweenLite.killTweensOf(soundBtn);
					bgImg.alpha = 1;
					soundBtn.alpha = 1;
					bgImg2.visible = false;
					bgImg.visible = true;
					soundBtn2.visible = false;
					soundBtn.visible = true;
					soundBtn2.touchable = false;
					soundBtn.touchable = true;
				}
				var contentGpu:TextFieldToGPU;
				container.removeChildren(0,-1,true);
				if(this._data.vo is ReadAloudVO){		//前面单个句子	
					changeNormal();
					var vo:ReadAloudVO = this._data.vo as ReadAloudVO;	
					if(showCn){						
						contentTxt.text = vo.usSentence+'\n'+vo.cnSentence;
						contentTxt.setTextFormat(colorTextformat,vo.usSentence.length,contentTxt.text.length);
					}else{
						contentTxt.text = vo.usSentence;
						contentTxt.setTextFormat(defaultTextformat);
					}
					
					contentGpu = new TextFieldToGPU();	
					contentGpu.x = 260
					contentGpu.textField = contentTxt;
					container.addChild(contentGpu);
				}else if(this._data.vo is Vector.<ReadAloudVO>){//后面汇总
					var vec:Vector.<ReadAloudVO> = this._data.vo as Vector.<ReadAloudVO>;
					var leading:Number = 0;
					changeBig();
					for(var i:int=0;i<vec.length;i++){
						if(showCn){
							contentTxt.text = vec[i].usSentence+'\n'+vec[i].cnSentence;
							contentTxt.setTextFormat(colorTextformat,vec[i].usSentence.length,contentTxt.text.length);
						}
						else{
							contentTxt.text = vec[i].usSentence;
							contentTxt.setTextFormat(defaultTextformat);
						}
						contentGpu = new TextFieldToGPU();	
						contentGpu.textField = contentTxt;
						contentGpu.y = leading;
						contentGpu.x = 260
						leading += contentGpu.height + 20;
						container.addChild(contentGpu);
					}					
				}else if(this._data.vo is String){ //最后选择提交
					changeSubmit();
					if(this._data.vo == '0' || this._data.vo == '1'){
						var resetBtn:Button = new Button(Assets.readAloudTexture("resetBtn"));
						resetBtn.x = 405;
						resetBtn.y = 267;
						resetBtn.name = 'resetBtn';
						container.addChild(resetBtn);
						resetBtn.addEventListener(TouchEvent.TOUCH,confirmHandler);
						
						var confirmBtn:Button = new Button(Assets.readAloudTexture("confirmBtn"));
						confirmBtn.x = 704;
						confirmBtn.y = 267;
						confirmBtn.name = 'confirmBtn';
						container.addChild(confirmBtn);
						confirmBtn.addEventListener(TouchEvent.TOUCH,confirmHandler);
					}else if(this._data.vo == '2'){
						var txt:starling.text.TextField = new starling.text.TextField(450,52,'亲，为这次学习给自己一个赞吧！','HuaKanT',28,0xFFFFFF,false);
						txt.x = 311;
						txt.y =176;
						container.addChild(txt);
						
						var firstBtn:Button = new Button(Assets.readAloudTexture("firstBtn"));
						firstBtn.x = 313;
						firstBtn.y = 293;
						firstBtn.name = 'firstBtn';						
						firstBtn.addEventListener(TouchEvent.TOUCH,confirmHandler);
						container.addChild(firstBtn);
						
						var secondBtn:Button = new Button(Assets.readAloudTexture("secondBtn"));
						secondBtn.x = 565;
						secondBtn.y = 293;
						secondBtn.name = 'secondBtn';
						secondBtn.addEventListener(TouchEvent.TOUCH,confirmHandler);
						container.addChild(secondBtn);
						
						var threeBtn:Button = new Button(Assets.readAloudTexture("threeBtn"));
						threeBtn.x= 817;
						threeBtn.y = 293;
						threeBtn.addEventListener(TouchEvent.TOUCH,confirmHandler);
						threeBtn.name = 'threeBtn';
						bgImg2.visible = true;
						bgImg.visible = false;
						container.addChild(threeBtn);
					}
				}
			}
			
			width = Global.stageWidth;
		}
		
		private var beginX:Number;
		private var preBtn:DisplayObject
		private function confirmHandler(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(Math.abs(touchPoint.globalX-beginX) < 10){	
						if(preBtn && preBtn!=event.target) preBtn.filter = null;
						preBtn = event.target as DisplayObject;
						trace('提交结果');
						switch((event.target as DisplayObject).name){
							case 'resetBtn':
								Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.RESET_LEARN);
								break;							
							case 'confirmBtn':
								threeHandler();
								break;
							case 'firstBtn':
								if(preBtn.filter!=null){
									firstHandler();
								}else{
									
									preBtn.filter = cm;
									Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(container,400,203,firstHandler,"没准备好，下次再来！"));
								}
								break;
							break;
							case 'secondBtn':
								if(preBtn.filter!=null){
									secondHandler();
								}else{									
									preBtn.filter = cm;
									Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(container,650,203,secondHandler,"嗯，我读的很好，还想多读一次！"))
								}
								break;
							case 'threeBtn':
								if(preBtn.filter!=null){
									threeHandler();
								}else{									
									preBtn.filter = cm;
									Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(container,905,203,threeHandler,"我读的很好，随时放马过来考考我吧！"))
								}
								break;
						}
					}
				}
			}
			
			
		}		
		
		private function firstHandler():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(ReadAloundLearnMediator.CONFIRM_SUBMIT,'50');
		}
		
		private function secondHandler():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(ReadAloundLearnMediator.CONFIRM_SUBMIT,'80');

		}
		private function threeHandler():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(ReadAloundLearnMediator.CONFIRM_SUBMIT,'100');

		}

		
		private function changeNormal():void{
			if(this._data.hasEnter){	//进入过的转绿色			
				soundBtn2.visible = true;
				bgImg2.visible = true;
				bgImg2.scaleY = 1;
				bgImg2.y = 57;
				soundBtn2.y = 55;
			}else{
				soundBtn.visible = true;
				bgImg.visible = true;
				bgImg.scaleY = 1;
				bgImg.y = 57;
				soundBtn.y = 55;
			}
			container.y = 210;
		}
		private function changeBig():void{
			if(this._data.hasEnter){	//进入过的转绿色		
				soundBtn2.visible = true;
				bgImg2.visible = true;
				bgImg2.scaleY = 1.15;
				bgImg2.y = 30;
				soundBtn2.y = 33;
			}else{
				soundBtn.visible = true;
				bgImg.visible = true;
				bgImg.scaleY = 1.15;
				bgImg.y = 30;
				soundBtn.y = 33;
			}
			
			container.y = 106;
		}
		private function changeSubmit():void{
			if(this._data.hasEnter){	//进入过的转绿色		
				bgImg2.scaleY = 1;
				bgImg2.y = 57;
				soundBtn2.y = 55;
				soundBtn2.visible = false;
				bgImg2.visible = false;
			}else{
				bgImg.scaleY = 1;
				bgImg.y = 57;
				soundBtn.y = 55;
				soundBtn.visible = false;
				bgImg.visible = false;
			}
			
			container.y = 0;
		}
		
	}
}