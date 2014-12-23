package com.studyMate.world.component
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.TestCardSentence;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.christmasad.ChristmasAdViewMediator;
	import com.studyMate.world.screens.christmasad.ChristmasPhotoViewMediator;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	
	/**
	 * note
	 * 2014-12-18上午9:49:12
	 * Author wt
	 *
	 */	
	
	public class HeadAdMediator extends ScreenBaseMediator
	{
		private const GET_ADJPG:String = "GET_adJpg";
		private const DOWN_COMPLETE:String = 'DOWN_COMPLETE';
		private const LOCAL_PIC_PATH:String = Global.localPath + "Market/christmasUserJpg/";
		private const LOCAL_SELF_PATH:String = Global.localPath + "Market/ChristmasJPG/";
		
		private var lightImg:Image;
		private var loaders:Loader;
		private var randomJpg:String='';
		private var currentJpg:String = '';
		
		private var adPreTexture:Texture;
		private var adNextTexture:Texture;
		
		private var adPreImg:Image;
		private var adNextImg:Image;
		
		private var holder:Sprite;
		
		public function HeadAdMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("HeadAdMediator", viewComponent);
		}
		override public function onRemove():void{
			TweenLite.killDelayedCallsTo(changeAdjpg);
			if(adPreTexture){
				TweenLite.killTweensOf(adPreImg);
				adPreTexture.dispose();
			}
			if(adNextTexture){
				TweenLite.killTweensOf(adNextImg);
				adNextImg.dispose();
			}
			TweenLite.killDelayedCallsTo(twinkle);
			TweenMax.killTweensOf(lightImg);
			super.onRemove()
		}
		override public function onRegister():void{
			var bg:Image = new Image(Assets.getHappyIslandTexture("billboard"));
			view.addChild(bg);

			loaders = new Loader();			
			loaders.contentLoaderInfo.addEventListener(Event.COMPLETE,LoaderComHandler);
			loaders.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			
			holder = new Sprite();
			holder.x = 57;
			holder.y = 50;
			holder.clipRect = new Rectangle(0,0,800,260);
			view.addChild(holder);
//			holder.addEventListener(TouchEvent.TOUCH,gotoCamera);
			
			lightImg = new Image(Assets.getHappyIslandTexture("light"));
			lightImg.x = 106;
			lightImg.y = 28;
			view.addChild(lightImg);
//			lightImg.touchable = false;
			lightImg.addEventListener(TouchEvent.TOUCH,gotoCamera);
			changeAdjpg();
			
			TweenLite.delayedCall(20*Math.random()+5,twinkle);
		}
		private var beginX:Number;
		private function gotoCamera(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(Math.abs(touchPoint.globalX-beginX) < 10){
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ChristmasPhotoViewMediator,null)]);
					}
				}
			}
			
		}
		
		//灯光闪烁
		private function twinkle():void{
			TweenMax.to(lightImg,0.1,{yoyo:true,alpha:0,repeat:5});
			TweenLite.delayedCall(20*Math.random()+5,twinkle);
		}
		
		//加载成功，派发加载对象，并继续加载下一张。
		private function LoaderComHandler(event:Event):void{
			currentJpg = randomJpg;
			trace("randomJpg:",randomJpg);
			//逻辑：两张图片切换.第一张销毁。下一张往前推送
			//理解成堆栈就行了。
			if(adNextTexture){
				if(adPreTexture) adPreTexture.dispose();
				adPreTexture = adNextTexture;
			}
			adNextTexture = Texture.fromBitmap(loaders.content as Bitmap,false);//bitmap
			if(adNextImg){
				adNextImg.texture = adNextTexture;
			}else{
				adNextImg = new Image(adNextTexture);
				holder.addChild(adNextImg);
			}
			if(adPreTexture){
				if(adPreImg){
					adPreImg.texture = adPreTexture;
				}else{				
					adPreImg = new Image(adPreTexture);
					holder.addChild(adPreImg);
				}
			}
			if(adPreImg){
				if(Math.random()>0.5){
					rolling();
				}else{
					hideing();
				}
			}
		}
		
		private function rolling():void{
			adPreImg.x = 0;
			adNextImg.x = adNextImg.width;
			adPreImg.alpha = 1;
			adNextImg.alpha = 1;
			TweenLite.to(adPreImg,2,{x:-adPreImg.width});
			TweenLite.to(adNextImg,2,{x:0});
		}
		private function hideing():void{
			adPreImg.alpha = 1;
			adNextImg.alpha = 1;
			adPreImg.x = 0;
			adNextImg.x = 0;
			TweenLite.to(adPreImg,2,{alpha:0});
		}
		
		//捕获数组元素为空或者加载失败的事件
		private function ioErrorHandler(event:Event):void{
			trace("ioerror");
			currentJpg = "";
		}
		
		private var isFirst:Boolean;
		//切换广告壁纸
		protected function changeAdjpg():void{
			//trace("状态：",Global.isLoading,Global.isSwitching);
			if(!Global.isLoading && !Global.isSwitching){				
				PackData.app.CmdIStr[0] = CmdStr.CHECK_CHRPIC;
				PackData.app.CmdIStr[1] = "RANDOM";
				PackData.app.CmdInCnt = 2;
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_ADJPG,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
			}else if(!isFirst){
				isFirst = true;
				var file:File =Global.document.resolvePath(LOCAL_SELF_PATH+PackData.app.head.dwOperID.toString()+'.jpg');
				if(file.exists){
					loaders.load(new URLRequest(file.url));
				}
			}
			
			TweenLite.delayedCall(20,changeAdjpg);
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;

			switch(notification.getName())
			{
				case GET_ADJPG:
					if(!result.isErr && !result.isEnd){
						randomJpg = PackData.app.CmdOStr[1];
						//验证本地文件
						var file:File =Global.document.resolvePath(LOCAL_PIC_PATH+randomJpg);	
						if(file.exists && file.size ==  PackData.app.CmdOStr[2]){//文件存在且大小一致,则直接读取
							if(currentJpg != randomJpg){//同一个文件则不加载了
								loaders.load(new URLRequest(file.url));
							}else{
								trace('文件不加载!!!');
							}
							
						}else{//否则下载文件
							trace("需要下载");
							if(!Global.isLoading){
								var remotePath:String = "show/" + randomJpg;
								var localPath:String = LOCAL_PIC_PATH + randomJpg;
								var downVO:RemoteFileLoadVO = new RemoteFileLoadVO(remotePath,localPath,DOWN_COMPLETE,null,null);
								downVO.downType = RemoteFileLoadVO.DOWN_CHRISTMAS;
								sendNotification(CoreConst.REMOTE_FILE_LOAD,downVO);
							}
						}
					}
					break;
				case DOWN_COMPLETE:
					trace("下载完成!!");
					if(randomJpg!=""){
						file = Global.document.resolvePath(LOCAL_PIC_PATH+randomJpg);	
						if(file.exists){//文件存在且大小一致,则直接读取
							loaders.load(new URLRequest(file.url));
						}
					}
					break;
					
				default:
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [DOWN_COMPLETE,GET_ADJPG];
		}
		
				
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}