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
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.engLearn.vo.ReadAloudVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	import com.studyMate.world.screens.view.EduAlertMediator;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.graphics.Fill;
	import starling.display.graphics.Stroke;
	import starling.display.shaders.vertex.RippleVertexShader;
	import starling.text.TextField;
	
	
	/**
	 * note
	 * 2014-10-20上午10:29:05
	 * Author wt
	 *
	 */	
	
	public class ReadAloudBGMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'ReadAloudBGMediator';
		
		private const GET_ID_Arr:String = NAME + "getIdArr";//获取id串

		private var prepareVO:SwitchScreenVO;
		private var rrl:String;
		private var topic:String;//id,唯一标识
		private var LEA:String;//层级
		private var isFirst:Boolean;
		private var isInit:Boolean;
		private var dataVec:Vector.<ReadAloudVO> = new Vector.<ReadAloudVO>;
		
		private const RECEIVE_DATA:String = NAME+'reciveData';
		private const DOWN_STANDARD_SOUND:String = NAME + 'downStandardSound';//下载标准录音

		
		public function ReadAloudBGMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			if(facade.hasMediator(EduAlertMediator.NAME)){
				sendNotification(WorldConst.REMOVE_POPUP_SCREEN,(facade.retrieveMediator(EduAlertMediator.NAME) as EduAlertMediator));
			}
			super.onRemove();
		}
		override public function onRegister():void
		{
			if(facade.hasMediator(MusicSoundMediator.NAME)){
				facade.removeMediator(MusicSoundMediator.NAME);
			}
			//背景
			var bg:Image = new Image(Assets.getTexture("readAloudBg"));
			bg.blendMode = BlendMode.NONE;
			view.addChild(bg);
			
			var txt:TextField = new TextField(80,30,topic);
			txt.touchable = false;
			txt.y = 720;
			view.addChild(txt);
			
			//水波
			var w:Number = view.stage.stageWidth;
			var h:Number = view.stage.stageHeight;
			var waterColorTop:uint = 0x08acff;
			var waterColorBottom:uint = 0x0073ad;
			var waterColorSurface:uint = 0xc6e5f5;
			
			var waterHeight:Number = h-80;
			var waterFill:Fill = new Fill();
			waterFill.addVertex(0, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, h, waterColorBottom,0.5 );
			waterFill.addVertex(0, h, waterColorBottom,0.5 );
			waterFill.touchable = false;
			view.addChild(waterFill);
			
			var waterSurfaceThickness:Number = 20;
			var waterSurfaceStroke:Stroke = new Stroke();
			waterSurfaceStroke.material.vertexShader = new RippleVertexShader();
			for (var i:int = 0; i < 50; i++ )
			{
				var ratio:Number = i / 49;
				waterSurfaceStroke.addVertex( ratio * w, waterHeight - waterSurfaceThickness*0.25, waterSurfaceThickness, waterColorSurface, 0.8, waterColorTop, 0.3);
			}
			waterSurfaceStroke.touchable = false;
			view.addChild(waterSurfaceStroke);
				
			var data:Object = {};
			data.dataVec = dataVec.concat();
			data.rrl = rrl;
			data.topic = topic;
			data.LEA = LEA;
//			LEA = '3';
			if(LEA=='0' || LEA=='1' || LEA=='2'){//学习阶段1，2，3
				
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadAloundLearnMediator,data,SwitchScreenType.SHOW)]);//cpu层显示		
				
			}else if(int(LEA)>=3){//考核阶段				
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadAloudExamMediator,data,SwitchScreenType.SHOW)]);//cpu层显示		
			}else{///返回数据问题
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉！后台朗读数据未返回LEA层级."));
			}
		}
		
		
		
		//有声音没下载则去下载，否则直接初始化界面
		private function getAllsounds():void{
			var file:File;
			var _item:UpdateListItemVO;
			var vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
			
			file =  Global.document.resolvePath(Global.localPath+'reading/er'+topic+'.mp3');
			if(!file.exists || file.size != dataVec[0].fsize){
				_item = new UpdateListItemVO("",'reading/er'+topic+'.mp3',"","");
				_item.hasLoaded = true;//检查文件
				vec.push(_item);
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(vec,DOWN_STANDARD_SOUND));//检查本地文件
			}else{
				if(!isInit){
					isInit = true;
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
				}
			}
			
		}
	
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_ID_Arr:
					if(!result.isErr){
						topic = PackData.app.CmdOStr[3];
						LEA =  PackData.app.CmdOStr[4];
						PackData.app.CmdIStr[0] = CmdStr.GETREADING_TASK;
						PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
						PackData.app.CmdIStr[2] = topic;
						var sendVO:SendCommandVO = new SendCommandVO(RECEIVE_DATA);
						sendVO.doFilter = false;
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,sendVO);
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉！后台朗读数据有误！请退出."));
					}
					break;
				
				case RECEIVE_DATA:
					if(!result.isEnd && !result.isErr){
						var readAloundVO:ReadAloudVO = new ReadAloudVO(PackData.app.CmdOStr);
						readAloundVO.LEA = LEA;
						readAloundVO.soundPath = 'edu/reading/er'+topic+'.mp3';
						dataVec.push(readAloundVO);
					}else if(result.isEnd && !result.isErr){
						if(!isFirst){
							isFirst = true;	
							if(dataVec.length==0){
								Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉！该组朗读录入数据为空.请反馈在线教育"));
							}else{								
								getAllsounds();
							}
						}
					}
					break;
				
				case CoreConst.BEGIN_SEND:
					if(!isFirst){
						dataVec.length = 0;
						
					}
					break;
				case DOWN_STANDARD_SOUND://下载完成
					if(!isInit){
						isInit = true;
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [GET_ID_Arr,RECEIVE_DATA,CoreConst.BEGIN_SEND,DOWN_STANDARD_SOUND];
		}
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			rrl = prepareVO.data.rrl;
			PackData.app.CmdIStr[0] = CmdStr.GET_READING_TASK_ID;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = rrl;
			PackData.app.CmdInCnt = 3;	
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_ID_Arr));
		}
		
	}
}