package com.studyMate.module.engLearn
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.ICharater;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.WordVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.Const;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	import flash.net.dns.AAAARecord;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	/**
	 * 学单词gpu展示层，存放一些特效和动画效果
	 * @author Wangtu
	 * 
	 */	
	public class WordLearningBGMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "WordLearningBGMediator";
		public static const APPLE_EVENT:String = NAME + "apple_event";
		private const yesQuitHandler:String = NAME + "yesQuitHandler";
		protected const RECEIVE_DATA:String = NAME + "receive_data";
		
		private var isFirst:Boolean;
		
		protected var prepareVO:SwitchScreenVO;	
		private var charater:ICharater;
		
		private var yesRightImg:Image;
		
		private var changeButton:feathers.controls.Button;
		
		private var zhongwenImg:Image;
		private var yingwenImg:Image;
		
		protected var dataSetArr:Array=[];		
		
		private var hasInit:Boolean;
		
		private var soundSlider:Slider;
		private var config:IConfigProxy;
		private const soundVolume:String = "learnWordSoundVolume";
		
		private var minScale9Txtur:Scale9Textures;
		private var maxScale9Txtur:Scale9Textures;
		
		public function WordLearningBGMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{		
			sendNotification(CoreConst.SET_BEAT_DUR,90);
			var texture:Image = new Image(Assets.getTexture("worldLearning"));
			texture.blendMode = BlendMode.NONE;
			texture.touchable = false;
			view.addChild(texture);	
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AppleTreeMediator,null,SwitchScreenType.SHOW,view,1054,395)]);//苹果树				
			
			for (var i:int = 0; i < 5; i++) //5朵花朵
			{
				var flowerImg:Image = new Image(Assets.getAtlasTexture("plant/flower"+int(Math.random()*4)));
				flowerImg.x = Math.random()*520;
				flowerImg.y = 535+Math.random()*230;
				sendNotification(WorldConst.ADD_FLOWER_CONTROL,flowerImg);
				view.addChild(flowerImg);
			}			
										
			var wenhaoImage:starling.display.Button = new starling.display.Button(Assets.getEgAtlasTexture("word/wenhaoSign"));//问号
			view.addChild(wenhaoImage);
			wenhaoImage.x = 745;
			wenhaoImage.y = 112;
			wenhaoImage.addEventListener(TouchEvent.TOUCH,wenhaoHandler);
			
			var SoundImage:starling.display.Button = new starling.display.Button(Assets.getEgAtlasTexture("word/laba"));//播放声音
			view.addChild(SoundImage);
			SoundImage.x = 15;
			SoundImage.y = 15;
			SoundImage.addEventListener(TouchEvent.TOUCH,soundHandler);
			
			yesRightImg = new Image(Assets.getEgAtlasTexture("word/YesRight"));
			yesRightImg.x = 330;
			yesRightImg.y = 85;
			yesRightImg.alpha = 0;
			yesRightImg.touchable = false;
			view.addChild(yesRightImg);
															
			var minRect:Rectangle = new Rectangle(8,0,2,12);
			var maxRect:Rectangle = new Rectangle(0,0,2,12);
			minScale9Txtur = new Scale9Textures(Assets.getEgAtlasTexture("word/soundMinTrack"),minRect);
			maxScale9Txtur = new Scale9Textures(Assets.getEgAtlasTexture("word/soundMaxTrack"),maxRect);
			soundSlider = new Slider();
			soundSlider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			soundSlider.width = 120;
			soundSlider.x = 110;
			soundSlider.y = 5;
			soundSlider.minimum = 1;
			soundSlider.maximum = 20;
			soundSlider.step = 1;
			soundSlider.page = 2;
			soundSlider.minimumPadding = -10;
			soundSlider.maximumPadding = -10;
			
			config = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var value:String = (config.getValueInUser(soundVolume));
			if(value==""){
				config.updateValueInUser(soundVolume,3);
				soundSlider.value = 3;
			}else{
				soundSlider.value = int(value);				
			}
			WordLearningTXTMediator.soundVolume = soundSlider.value/4;
			
			soundSlider.liveDragging = false;
			view.addChild(soundSlider);
			soundSlider.addEventListener( Event.CHANGE, slider_changeHandler );
			
			soundSlider.thumbProperties.defaultSkin = new Image(Assets.getEgAtlasTexture("word/sliderSound"));
			soundSlider.minimumTrackProperties.defaultSkin = new Scale9Image(minScale9Txtur);
			soundSlider.maximumTrackProperties.defaultSkin =  new Scale9Image(maxScale9Txtur);
			soundSlider.thumbProperties.stateToSkinFunction = null;
			soundSlider.minimumTrackProperties.stateToSkinFunction = null;
			soundSlider.maximumTrackProperties.stateToSkinFunction = null;
			soundSlider.thumbProperties.minWidth = soundSlider.thumbProperties.minHeight = 0;
			
			
			hasInit = true;
			showGpuMediator();
			
			trace("@VIEW:WordLearningBGMediator:");
		}
		
		private function slider_changeHandler(event:Event):void
		{
			WordLearningTXTMediator.soundVolume = soundSlider.value/4;
			config.updateValueInUser(soundVolume,soundSlider.value);
			sendNotification(WorldConst.WL_PLAYSOUND);
		}
		
		protected function showGpuMediator():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WordLearningTXTMediator,dataSetArr.concat(),SwitchScreenType.SHOW)]);//cpu层显示		
			this.backHandle = function():void{
				if(dataSetArr.length==0){
					sendNotification(WorldConst.POP_SCREEN);
				}else{
					
					var isStart:Boolean = (facade.retrieveMediator(WordLearningTXTMediator.NAME) as WordLearningTXTMediator).isStart;
					var grpcode:String = (facade.retrieveMediator(WordLearningTXTMediator.NAME) as WordLearningTXTMediator).currentWordVO.grpcode;
					var wrongNum:int = (facade.retrieveMediator(WordLearningTXTMediator.NAME) as WordLearningTXTMediator).wrongNum;
					if(isStart && wrongNum>0 && grpcode != "LE001" && grpcode != "LE002" && grpcode != "LE003"){			
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n要放弃该阶段任务吗？\n\n放弃会扣除部分金币。",true,yesQuitHandler));//提交订单
					}else{
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n确定退出学单词吗？",true,yesQuitHandler));//提交订单
					}
				}
			}
		}
		
		private function changInputHandler():void
		{
			sendNotification(WorldConst.CHANGE_INPUT);
		}
		
		//问号
		private function wenhaoHandler(e:TouchEvent):void{			
			if(e.touches[0].phase=="ended"){
				sendNotification(WorldConst.WL_QUESTION_TIP);
			}		
		}	
		//播放声音
		private function soundHandler(e:TouchEvent):void{			
			if(e.touches[0].phase=="ended"){
				sendNotification(WorldConst.WL_PLAYSOUND);
			}		
		}
		
		override public function onRemove():void{	
			sendNotification(CoreConst.SET_BEAT_DUR,Const.DEFAULT_BEAT_DUR);
			if(yingwenImg){
				TweenMax.killTweensOf(yingwenImg);
			}
			if(zhongwenImg){
				TweenMax.killTweensOf(zhongwenImg);
			}
			dataSetArr.length = 0;
			dataSetArr = null;
//			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			/*charater.dispose();
			facade.removeMediator((charater as IMediator).getMediatorName());*/
			view.removeChildren(0,-1,true);
			maxScale9Txtur.texture.dispose();
			minScale9Txtur.texture.dispose();
			super.onRemove();			
		}
										
		/**------------------------------------数据反馈与读取--------------------------------------------------*/
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()) {
					case WorldConst.SHOW_CHANGEINPUTBUTTON:
						if(changeButton==null){							
							changeButton = new feathers.controls.Button();
							changeButton.label = "切换键盘方式";
							changeButton.x = 5;
							changeButton.y = 110;
							view.addChild(changeButton);
							changeButton.addEventListener(Event.TRIGGERED,changInputHandler);
						}
						break;
					case APPLE_EVENT:
						sendNotification(AppleTreeMediator.GROW,notification.getBody());//显示苹果树上的苹果，根据传参决定个数
						break;					
					case yesQuitHandler:
						//sendNotification(WorldConst.POP_SCREEN);
						if(!Global.isLoading){								
							sendNotification(WordLearningTXTMediator.yesAbandonHandler);
						}
						break;
					case WorldConst.WL_YESRIGHT:
						TweenMax.killTweensOf(yesRightImg);
						yesRightImg.alpha=0;
						TweenMax.to(yesRightImg,0.5,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut});
						break;
					case WorldConst.YINGWEN_TIP:
						if(yingwenImg==null){
							yingwenImg = new Image(Assets.getEgAtlasTexture("word/yingwenTip1"));
							yingwenImg.x = 200;
							yingwenImg.y = 100;
							yingwenImg.alpha = 0;
							yingwenImg.touchable = false;
							view.addChild(yingwenImg);
						}
						TweenMax.killTweensOf(yingwenImg);
						yingwenImg.alpha = 0;
						TweenMax.to(yingwenImg,0.5,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut});
						break;
					case WorldConst.ZHONGWEN_TIP:
						if(zhongwenImg == null){
							zhongwenImg = new Image(Assets.getEgAtlasTexture("word/zhongwenTip1"));
							zhongwenImg.x = 200;
							zhongwenImg.y = 100;
							zhongwenImg.alpha = 0;
							zhongwenImg.touchable = false;
							view.addChild(zhongwenImg);
						}
						TweenMax.killTweensOf(zhongwenImg);
						zhongwenImg.alpha = 0;
						TweenMax.to(zhongwenImg,0.5,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut});
						break;
					case RECEIVE_DATA:
						if(!result.isEnd){
//							var wordVO:WordVO = new WordVO(PackData.app.CmdOStr);							
//							dataSetArr.push(wordVO);
								var wordVO:WordVO = new WordVO(PackData.app.CmdOStr);
								dataSetArr.push(wordVO);
							
						}else{
							if(!isFirst){
								isFirst = true;										
								Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);	
							}
						}
						
						break;
					case CoreConst.BEGIN_SEND:
						if(!isFirst){							
							dataSetArr.length = 0;
						}
						break;
					
			}
		}
		override public function listNotificationInterests():Array{
			return [APPLE_EVENT,yesQuitHandler,RECEIVE_DATA,
				WorldConst.SHOW_CHANGEINPUTBUTTON,CoreConst.BEGIN_SEND,
				WorldConst.WL_YESRIGHT,WorldConst.YINGWEN_TIP,WorldConst.ZHONGWEN_TIP];
		}
				
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;
			PackData.app.CmdIStr[0] = CmdStr.OBTAIN_WORD_LIST_THE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			trace("当前rrl = "+vo.data.rrl.toString());
			PackData.app.CmdIStr[2] = vo.data.rrl.toString();
			PackData.app.CmdInCnt = 3;
			var sendVO:SendCommandVO = new SendCommandVO(RECEIVE_DATA);
			sendVO.doFilter = false;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,sendVO);
			//Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);						
		}
	}
}