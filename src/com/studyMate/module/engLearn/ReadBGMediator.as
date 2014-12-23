package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.effects.LeafPartical;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	internal class ReadBGMediator extends ScreenBaseMediator
	{
		public static const NAME:String="ReadBGMediator";
		
		public static const TIP_INFORMATION:String = "tip_information";//提示信息
		public static const SHOW_ICON:String = "showICON";//提示图标
		public static const TIP_HOLDER:String = "tipHolder";
		private const yesQuitHandler:String = NAME + "yesQuitHandler";
		
		protected var prepareVO:SwitchScreenVO;
		//private var infoData:SwitchScreenVO;
		
		private var leaf:LeafPartical;
		private var hasKeyboard:Boolean;//是否有键盘
		
		//private var read_tip:Sprite;//提示牌子
		//private var tipTextField:TextField;//提示文本对象
		private var read_catBtn:Button;
		
		private const GET_READ_ID:String = "GET_READ_ID";
		private const GET_READ_CONTENT:String = "GET_READ_Content";
		
		private var answerGroup:Sprite;
		private var reasonGroup:Sprite;
		
		//private const GET_READING_TEXT_RETURN:String = "GET_READING_TEXT_RETURN";		
		//private var rrl:String;
		//private var readId:String;
		//private var dataObj:Object={};//接收到的数据
		
		public function ReadBGMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void{		
			var texture:Image = new Image(Assets.getTexture("readBGview"));
			texture.blendMode = BlendMode.NONE;
			texture.touchable = false;
			view.addChild(texture);
			leaf = new LeafPartical();
			view.addChild(leaf);
			
			var preBtn:Button = new Button(Assets.getEgAtlasTexture("word/read_preBtn"));
			preBtn.x = 700;
			preBtn.y = 690;
			view.addChild(preBtn);
			var nextBtn:Button  = new Button(Assets.getEgAtlasTexture("word/read_nextBtn"));
			nextBtn.x = 807;
			nextBtn.y = 690;
			view.addChild(nextBtn);		
			/*var completeBtn:Button = new Button(Assets.getEgAtlasTexture("word/read_completeBtn"));
			completeBtn.x = 947;
			completeBtn.y = 690;
			view.addChild(completeBtn);	*/		
			read_catBtn = new Button(Assets.getEgAtlasTexture("word/read_cat"));
			read_catBtn.x = 1234;
			read_catBtn.y = 459;
			view.addChild(read_catBtn);
			
			/*read_tip = new Sprite();//提示信息框
			read_tip.x = 690; read_tip.y = 236;
			view.addChild(read_tip);
			read_tip.visible = false;
			var tipImage:Image = new Image(Assets.getEgAtlasTexture("word/read_tips"));
			read_tip.addChild(tipImage);*/
			/*tipTextField = new TextField(434,108,"暂无提示...","HeiTi",15,0xFFFFFF);
			tipTextField.x = 44; tipTextField.y = 40;
			read_tip.addChild(tipTextField);*/
			
			var textureICO0:Texture = Assets.getEgAtlasTexture("word/read_yesIco");
			var textureICO1:Texture = Assets.getEgAtlasTexture("word/read_noIco");
			var Right:Image = new Image(textureICO0);
			var wrong:Image =  new Image(textureICO1);	
			answerGroup = new Sprite();	
			Right.visible = false;
			wrong.visible = false;
			answerGroup.addChild(Right);
			Right.y = -10;
			answerGroup.addChild(wrong);
			view.addChild(answerGroup);	
			answerGroup.x = 690;
			answerGroup.y = 530;
			
			var Right0:Image = new Image(textureICO0);
			var wrong1:Image =  new Image(textureICO1);	
			reasonGroup = new Sprite();		
			Right0.visible = false
			wrong1.visible = false;
			reasonGroup.addChild(Right0);
			Right0.y = -10;
			reasonGroup.addChild(wrong1);
			view.addChild(reasonGroup);
			reasonGroup.x = 690;
			reasonGroup.y = 592;
			
			//read_tip.addEventListener(TouchEvent.TOUCH,readTipTouchHandler);//阅读提示框单击事件
			read_catBtn.addEventListener(TouchEvent.TOUCH,catTouchHandler);//提示信息
			preBtn.addEventListener(TouchEvent.TOUCH,preTouchHandler);//上一题
			nextBtn.addEventListener(TouchEvent.TOUCH,nextTouchHandler);//下一题
			//completeBtn.addEventListener(TouchEvent.TOUCH,completeTouchHandler);//完成
			
			
			
			showGpuMediator();		
			
			trace("@VIEW:ReadBGMediator:");
		}
		
		protected function showGpuMediator():void{
			if(prepareVO.data.isComplete){
				var arr2:Array = this.getTextArrFun("outHTML",prepareVO.data.initialTxt);//解析脚本
				prepareVO.data.translationText = arr2[2];
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadCPUCompleteMediator,prepareVO,SwitchScreenType.SHOW)]);//cpu层显示
			}else{	
				this.backHandle = function():void{
					if(facade.retrieveMediator(ReadCPUMediator.NAME)){						
						var isStart:Boolean = (facade.retrieveMediator(ReadCPUMediator.NAME) as ReadCPUMediator).isStart;
						if(isStart){
							sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n确定放弃阅读任务吗？\n\n放弃会扣除部分金币。",true,yesQuitHandler));//提交订单
						}else{
							sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n确定退出阅读任务吗？",true,yesQuitHandler));//提交订单	
						}
					}else{						
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n确定退出阅读任务吗？",true,yesQuitHandler));//提交订单				
					}
				}
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadCPUMediator,prepareVO,SwitchScreenType.SHOW)]);//cpu层显示
			}
		}
		
		override public function onRemove():void{		
			leaf.dispose();
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		
		/*private function readTipTouchHandler(e:TouchEvent):void{
			if(e.getTouch(read_tip,TouchPhase.ENDED)){
				if(!hasKeyboard){
					read_tip.visible = false;
					sendNotification(TIP_HOLDER,false);
				}				
			}
		}*/
		private var readTipBoo:Boolean=true;
		private function catTouchHandler(e:TouchEvent):void{
			if(e.getTouch(read_catBtn,TouchPhase.ENDED)){
				if(!hasKeyboard){
					readTipBoo = !readTipBoo;
					//read_tip.visible = !read_tip.visible;
					sendNotification(TIP_HOLDER,readTipBoo);
				}				
			}
		}
		
		private function preTouchHandler(e:TouchEvent):void{
			if(e.touches[0].phase=="ended"){
				sendNotification("preTouchHandler");
			}
		}
		private function nextTouchHandler(e:TouchEvent):void{
			if(e.touches[0].phase=="ended"){
				sendNotification("nextTouchHandler");
			}
		}
		/*private function completeTouchHandler(e:TouchEvent):void{
			if(e.touches[0].phase=="ended"){
				
			}
		}*/
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()) {
				case GET_READ_ID:
					if(!result.isErr){
						prepareVO.data.readId = PackData.app.CmdOStr[3];
						if(prepareVO.data.readId=='' || prepareVO.data.readId==undefined){
							Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉,该任务下暂时没有阅读"));
							Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_SWITCH,prepareVO);
							return;
						}
						this.sendinServerInfo(CmdStr.GET_READING_TEXT,GET_READ_CONTENT,[prepareVO.data.readId]);//根据id获取文章
					}else {
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉！获取不到该任务下的习题id."));
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_SWITCH,prepareVO);
					}
					/*if(PackData.app.CmdOStr[0] == "000"){//第一步获取阅读id
						prepareVO.data.readId = PackData.app.CmdOStr[3];
						this.sendinServerInfo(CmdStr.GET_READING_TEXT,GET_READ_CONTENT,[prepareVO.data.readId]);//根据id获取文章
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){
						sendNotification(CoreConst.TOAST,new ToastVO("抱歉！后台阅读数据有误！请退出."));
					}*/
					break;
				case GET_READ_CONTENT://第二部获取阅读文本
					if(!result.isErr){
						prepareVO.data.initialTxt = PackData.app.CmdOStr[3];
						//var arr2:Array = this.getTextArrFun("outHTML",initialTxt);//解析脚本
						//readingText = arr2[0];
						//annotationText = arr2[1];
						//translationText = arr2[2];
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉！后台阅读数据有误！请退出."));
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_SWITCH,prepareVO);
					}
					break;
				case ReadBGMediator.TIP_HOLDER:
				//	read_tip.visible = notification.getBody();
					break;
				case TIP_INFORMATION:
				//	read_tip.visible = true;
					//tipTextField.text = notification.getBody().toString();
					break;
				case SHOW_ICON:
					var str:String = notification.getBody().toString();
					switch(str){
						case "answerR":  
							answerGroup.getChildAt(0).visible = true;
							answerGroup.getChildAt(1).visible = false;
							break;
						case "answerW":	
							answerGroup.getChildAt(0).visible = false;
							answerGroup.getChildAt(1).visible = true;
							break;
						case "reasonR":	
							reasonGroup.getChildAt(0).visible = true;
							reasonGroup.getChildAt(1).visible = false;
							break;
						case "reasonW":	
							reasonGroup.getChildAt(0).visible = false;
							reasonGroup.getChildAt(1).visible = true;
							break;
						default:
							answerGroup.getChildAt(0).visible = false;
							answerGroup.getChildAt(1).visible = false;
							reasonGroup.getChildAt(0).visible = false;
							reasonGroup.getChildAt(1).visible = false;
							break;
					}
					break;
				case yesQuitHandler:
					//sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EnglishIslandMediator),new SwitchScreenVO(CleanCpuMediator)]);
					//sendNotification(WorldConst.POP_SCREEN);		
					if(!Global.isLoading){						
						sendNotification(ReadCPUMediator.yesAbandonHandler);
					}
					break;
				case SoftKeyBoardConst.HAS_KEYBOARD:
					hasKeyboard = true;

				case SoftKeyBoardConst.NO_KEYBOARD:
					hasKeyboard = false;
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [TIP_INFORMATION,SHOW_ICON,GET_READ_ID,GET_READ_CONTENT,yesQuitHandler,SoftKeyBoardConst.HAS_KEYBOARD,SoftKeyBoardConst.NO_KEYBOARD,ReadBGMediator.TIP_HOLDER];
		}
		
		/**
		 * 后台信息派发函数
		 * @param command		命令字
		 * @param reveive		接收字符
		 * @param info			参数数组
		 */		
		private function sendinServerInfo(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+2] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+2;	
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(reveive,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));	//派发调用绘本列表参数，调用后台
		}
		
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		/**
		 * 取得左侧界面所有html文本内容
		 * @param notation	
		 * @param _src
		 * @return 	返回原文和翻译
		 */		
		private function getTextArrFun(notation:String,_src:String):Array{
			var arr:Array = _src.split("\n")
			var arr2:Array = [];
			var total:int = arr.length
			for(var i:int = 0;i < total;i++) {
				if(arr[i].indexOf(notation) != -1) {
					var s:int = arr[i].lastIndexOf("`");
					var str:String = arr[i].toString().substring(s + 1);
					arr2.push(str);
					if(arr2.length == 3)	break;
				}
			}
			return arr2;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;		
			if(prepareVO.data.readId){
				this.sendinServerInfo(CmdStr.GET_READING_TEXT,GET_READ_CONTENT,[prepareVO.data.readId]);//根据id获取文章
				return;
			}
			
			if(prepareVO.data.rrl.indexOf("yy.R")!=-1){
				//infoData.data.rrl = prepareVO.data.rrl;					
				//rrl = prepareVO.data.data.rrl;	
//				trace("阅读 rrl = "+prepareVO.data.rrl);
				this.sendinServerInfo(CmdStr.GET_READING_TASK_ID,GET_READ_ID,[prepareVO.data.rrl]);//获取阅读任务id				
			}
			//Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);															
		}
	}
}