package com.studyMate.world.screens.view
{
	//import com.greensock.TweenLite;
	//import com.greensock.easing.Elastic;
	//import com.greensock.plugins.TransformAroundPointPlugin;
	//import com.greensock.plugins.TweenPlugin;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	
	/**
	 * 传入
	 * Data接收三个参数
	 * str 		提示文本
	 * noBtn  	boolean值是否有取消按钮
	 * 
	 * 
	 * 输出 
	 * 
	 */ 
	
	public class EduAlertMediator extends Mediator
	{
		public static const NAME:String = "EduAlertMediator";
		
		//private var closeBtn:Sprite;
		private var yesBtn:Sprite;
		private var noBtn:Sprite;
		private var txt:TextField;
		
		private var bg:Sprite;
		
		private var prepareVO:AlertVo;
		public var isPosition:Boolean;
		
		public function EduAlertMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{	
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("alertShow.mp3"),"alertShow"));
			sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("alertShow"));


			
			bg = view.getChildAt(0) as Sprite;
			
			yesBtn = bg.getChildByName("YesBtn") as Sprite;
			noBtn = bg.getChildByName("NoBtn") as Sprite;
			txt = bg.getChildByName("txt") as TextField;
			if(txt){
				txt.maxChars = 60;
//				txt.multiline = true;
//				txt.wordWrap = true;
				txt.selectable = false;
				txt.mouseEnabled = false;
				txt.antiAliasType = AntiAliasType.ADVANCED;		
				if(Font.enumerateFonts(false).length>0){
					txt.embedFonts = true;
					var textformat:TextFormat = new TextFormat("HeiTi",25,0xFFFFFF,true);
					textformat.letterSpacing = 2;
				}else{
					textformat = new TextFormat(null,25,0xFFFFFF);
				}
				txt.defaultTextFormat = textformat;
				prepareVO.str = prepareVO.str.replace('\n','');
				if(prepareVO.isHTML){	
					txt.htmlText = prepareVO.str;
				}else{
					txt.text = prepareVO.str;				
				}
			}

				
			if(!prepareVO.noBtn){
				noBtn.visible = false;
			}
			if(!isPosition){					
				var shape:Sprite = new Sprite();
				shape.graphics.beginFill(0,0.75);
				shape.graphics.drawRect(0,0,Global.stageWidth,Global.stageHeight+30);
				shape.graphics.endFill();
				view.addChildAt(shape,0);
				bg.x = 0;
				bg.y = 300;				
			}else{
				bg.x = (Global.stageWidth - bg.width)/2;
				bg.y = (Global.stageHeight-bg.height)/2-100;
			}
			
//			view.x = (Global.stage.stageWidth-view.width)/2;
//			view.y = (Global.stage.stageHeight-view.height)/2-100;
			
			view.scaleX = Global.widthScale;
			view.scaleY = Global.heightScale;
			
			yesBtn.addEventListener(MouseEvent.MOUSE_UP,yesClickHandler,false,0,true);
			noBtn.addEventListener(MouseEvent.MOUSE_UP,noClickHandler,false,0,true);
			yesBtn.addEventListener(MouseEvent.MOUSE_DOWN,yesDownClickHandler,false,0,true);
			noBtn.addEventListener(MouseEvent.MOUSE_DOWN,noDownClickHandler,false,0,true);
		}
		

		
		private function yesDownClickHandler(e:MouseEvent):void{
			e.stopImmediatePropagation();
		}
		private function noDownClickHandler(e:MouseEvent):void{
			e.stopImmediatePropagation();
		}
		

		private function yesClickHandler(e:MouseEvent):void{
			e.stopImmediatePropagation();			
			sendNotification(prepareVO.yesHandler,prepareVO.yesParameter);
			if(prepareVO.yesFun ){
				if(prepareVO.yesParameter){
					prepareVO.yesFun.apply(null,prepareVO.yesParameter);
				}else{
					prepareVO.yesFun();
				}
			}
			viewRemoveFromStage();
		}
		private function noClickHandler(e:MouseEvent):void{
			e.stopImmediatePropagation();
			sendNotification(prepareVO.noHandler);						
			if(prepareVO.noFun ){
				if(prepareVO.noParameter){
					prepareVO.noFun.apply(null,prepareVO.noParameter);
				}else{
					prepareVO.noFun();
				}
			}
			viewRemoveFromStage(); 
			
		}
		private function viewRemoveFromStage():void{	
			yesBtn.removeEventListener(MouseEvent.MOUSE_UP,yesClickHandler);
			noBtn.removeEventListener(MouseEvent.MOUSE_UP,noClickHandler);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		
		override public function onRemove():void{	
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'alertShow');
			
			if(yesBtn)	yesBtn.removeEventListener(MouseEvent.MOUSE_DOWN,yesDownClickHandler);
			if(noBtn)	noBtn.removeEventListener(MouseEvent.MOUSE_DOWN,noDownClickHandler);

			if(prepareVO.yesFun) prepareVO.yesFun = null;
			if(prepareVO.noFun ) prepareVO.noFun = null;
			super.onRemove();	
		}
		
		public function prepare(vo:AlertVo):void{
			prepareVO = vo;	
		}


		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}				
	}
}