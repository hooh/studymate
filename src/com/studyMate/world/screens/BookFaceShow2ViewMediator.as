package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.view.BookFaceShow2View;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class BookFaceShow2ViewMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "BookFaceShow2ViewMediator";
		public var prepareVO:SwitchScreenVO;		
		private var loaders:Loader;
		private var direction:int;//鼠标手势的方向-1为向右滚，1为向左滚
		private var bookArr:Array;//书本合集数组
		private var flag:Boolean;//是否收到反馈信息
		private var idArr:Array = [];
		private var sourceArr:Array=[];
		private var typeArr:Array=[];
		private var version:Array = [];
		private var sizeArr:Array = [];
		public var item:BookPicture;
		
		private var AS_AND_SWF_LOAD:Boolean=false;
		
		private static const List_New_User_Rrl:String = NAME+"ListNewUserRrl";
		private static const List_User_Rrl:String = NAME+"ListUserRrl";
		private static const down_Load_AS:String = NAME + "downLoadAS";
		private static const down_Load_SWF:String = NAME+"downLoadSWF";
		
		public function BookFaceShow2ViewMediator(viewCompoent:Object = null){
			super(NAME, viewComponent);
		}
		override public function onRemove():void{		
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			view.addEventListener(TransformGestureEvent.GESTURE_SWIPE,touchMoveHandler);//手势滑动即刻触发，板子响应快点好。
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			item = null;
			TweenLite.killTweensOf(view.uiImage);
			TweenLite.killTweensOf(view.backGround);
			loaders.contentLoaderInfo.addEventListener(Event.COMPLETE,LoaderComHandler);
			loaders.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
			loaders.unloadAndStop();
			loaders = null;
			prepareVO.data = null;
			prepareVO = null;
			bookArr = null;
			/*if(bookArr){
			bookArr.length = 0;
			bookArr = null;
			}*/
			super.onRemove();			
		}
		
		override public function onRegister():void{	
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this)));

			view.btnGroup.visible =false;			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			loaders = new Loader();
			loaders.contentLoaderInfo.addEventListener(Event.COMPLETE,LoaderComHandler);
			loaders.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
			itemShow();
		}		
		
		/**
		 * 加载图片显示动画算法
		 */
		private function LoaderComHandler(event:Event):void{				
			var bit:Bitmap=event.target.content;//为修改宽、高方便，给加载进来的图片一个变量名bit
			bit.width=400;//修改图片的宽			
			bit.height=500;//修改图片的高
			
			var BigBookFaceClass:Class = AssetTool.getCurrentLibClass("big_Book_Face");//大图片书壳子
			//var bookFaceBtn:MCButton = new MCButton(BigBookFaceClass,BigBookFaceClass);
			var bookFaceBtn:Sprite = new BigBookFaceClass;
			var sp:Sprite = new Sprite();
			
			if(view.uiImage.numChildren){//如果里面已经有图片的话				
				view.btnGroup.mouseEnabled = false;//禁用按钮
				view.btnGroup.mouseChildren = false;
				if(view.hasEventListener(TransformGestureEvent.GESTURE_SWIPE)){
					view.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,touchMoveHandler);//手势滑动即刻触发，板子响应快点好。
				}
				
				/**
				 * 后一张图片
				 */	
				sp.addChild(bookFaceBtn);				
				sp.addChild(bit);
				bit.x=33;
				bit.y=60;
				view.uiImage.addChild(sp);
				if(direction==-1){ //向右边滚
					TweenLite.to(view.uiImage.getChildAt(0),1,{x:-(view.uiImage.x+view.uiImage.width),onComplete:moveEndEffectHandler});//前一个
					TweenLite.from(sp,1,{x:(1280-view.uiImage.x)});//后一个
				}else if(direction == 1){
					TweenLite.to(view.uiImage.getChildAt(0),1,{x:(1280-view.uiImage.x)});
					TweenLite.from(sp,1,{x:-(view.uiImage.x+view.uiImage.width),onComplete:moveEndEffectHandler});
				}
			}else{//如果里面有图片的话
				bit.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);			
				sp.addChild(bookFaceBtn);
				sp.addChild(bit);
				bit.x=33;
				bit.y=60;
				view.uiImage.addChild(sp);				
			}						
		}
		
		private function addToStageHandler(event:Event):void{	
			var baseData:int = item.orderId;
			var NumX:Number = int(baseData%7)*163 + 85-10;
			var NumY:Number = (int(baseData/7))%3*216-7 + 63;
			TweenLite.from(view.uiImage,0.5,{scaleX:0.32,scaleY:0.32,x:NumX,y:NumY,onComplete:addBackgroundHandler});			
		}
		
		//图片放大后，添加背景图片事件
		private function addBackgroundHandler():void{
			TweenLite.killTweensOf(view.uiImage.getChildAt(0));
			view.btnGroup.visible =true;	
			TweenLite.to(view.backGround,1,{alpha:0.7});//背景色渐显
			
			/**
			 * 展示封面显示以后各种按钮的侦听
			 */	
			view.infoBtn.addEventListener(MouseEvent.CLICK,showInfoHandler);//测试信息使用按钮
			/*view.asLoadBtn.addEventListener(MouseEvent.CLICK,asLoadHandler);//测试信息
			view.swfLoadBtn.addEventListener(MouseEvent.CLICK,swfLoadHandler);*///测试信息
			
			view.cancleBtn.addEventListener(MouseEvent.CLICK,closeShowHandler);//自己侦听删除自己	
			view.sureBtn.addEventListener(MouseEvent.CLICK,enterBookHandler);
			view.leftBtn.addEventListener(MouseEvent.CLICK,rightBookHandler);
			view.rightBtn.addEventListener(MouseEvent.CLICK,leftBookHandler);
			view.addEventListener(TransformGestureEvent.GESTURE_SWIPE,touchMoveHandler);//手势滑动即刻触发，板子响应快点好。
			view.delTxt.addEventListener(MouseEvent.CLICK,delHandler);
		}
		
		protected function delHandler(event:MouseEvent):void
		{
			if(item){				
				var file:File
				for(var i:int=0;i<item.swfPath.length;i++){
					file = Global.document.resolvePath(Global.localPath+item.swfPath[i]);
					if(file.exists){
						file.deleteFile();
					}
				}
				file = Global.document.resolvePath(Global.localPath+item.asPath);
				if(file.exists){
					file.deleteFile();
				}
				item.needLoad = true;
				view.DownLoadFlagBtn.visible = true;
			}
			
			enterBookHandler();
		}
		//关闭封面展示
		private function closeShowHandler(event:MouseEvent):void{						
			view.btnGroup.visible =false;			
			TweenLite.to(view.backGround,0.5,{alpha:0});//背景色渐显
			
			var baseData:int = item.orderId;
			var NumX:Number = int(baseData%7)*163 + 85-10;
			var NumY:Number = (int(baseData/7))%3*216-7 + 63;			
			TweenLite.to(view.uiImage,0.5,{x:NumX,y:NumY,scaleX:0.32,scaleY:0.32,onComplete:closeThisHandler});
		}		
		
		private function closeThisHandler():void{
			sendNotification(CoreConst.CLOSE_FACE_SHOW);
			prepareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);	
		}
		//***********************************************************************************************************************************************//
		private function showInfoHandler(event:MouseEvent):void{	
			try{
				if(item){					
					var ss:String=""+item.swfPath.join("item.swfPath \n");
					var str:String = "rrl="+item.rrlPath+"\n"+"facePath="+item.facePath+"\n"+"asPath="+item.asPath +"\n"+"swfPath="+ss;
					view.info.text =  str;
					if(view.info.visible){
						view.info.visible = false;
					}else{
						view.info.visible = true;				
					}			
				}
			}catch(e:Error){
				
			}
		}
		private function asLoadHandler(e:MouseEvent):void{
			sendinServerInfo(CmdStr.List_User_Rrl,item.rrlPath,down_Load_AS);//派发第一步获取所有绘本基本信息				
		}
		private function loadas():void{
			var _vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
			var _itemAs:UpdateListItemVO = new UpdateListItemVO(item.asId,item.asPath,item.asType,item.asVersion);			
			_itemAs.hasLoaded = false;
			_vec.push(_itemAs);//as文件
			sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(_vec));//检查本地文件	
		}
		private function swfLoadHandler(e:MouseEvent):void{
			sendinServerInfo(CmdStr.List_User_Rrl,item.rrlPath,down_Load_SWF);//派发第一步获取所有绘本基本信息			
		}
		private function loadswf():void{
			var _vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
			
			for(var i:int=0;i<item.swfId.length;i++){
				var _itemSwf:UpdateListItemVO = new UpdateListItemVO(item.swfId[i].toString(),item.swfPath[i].toString(),item.swfType[i].toString(),item.swfVersion[i].toString());
				_itemSwf.hasLoaded = false;
				_vec.push(_itemSwf);//swf文件
			}			
			_itemSwf.hasLoaded = false;
			_vec.push(_itemSwf);//as文件
			sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(_vec));//检查本地文件	
		}
		
		//*********************************************************************************************************************************************************//
		
		
		private function ioErrorHandler(event:Event):void{			
		}				
		/**
		 * 程序启动后的执行起始程序
		 */
		private function itemShow():void{
			var str:String;
			if(item){
				if(item.facePath != ""){
					str = Global.document.resolvePath(Global.localPath+item.facePath).url;
				}else{
					str = Global.document.resolvePath(Global.localPath+"book/bookFace/kisses.jpg").url;
				}
				loaders.load(new URLRequest(str));
				
				if(item.hasCache){//如果有缓存则读取缓存
					flag = true;
					//trace("读缓存");
					panelShow();//显示面板信息
				}else{//没有缓存信息读取则
					if(!Global.isLoading){						
						sendinServerInfo(CmdStr.List_User_Rrl,item.rrlPath,List_User_Rrl);//派发第一步获取所有绘本基本信息
						//trace("不用读缓存");
					}
				}
			}				
		}		
		
		private function moveEndEffectHandler():void{
			//view.btnGroup.visible = true;
			view.btnGroup.mouseEnabled = true;//滚动完成按钮	恢复使用
			view.btnGroup.mouseChildren = true;
			if(!view.hasEventListener(TransformGestureEvent.GESTURE_SWIPE)){
				view.addEventListener(TransformGestureEvent.GESTURE_SWIPE,touchMoveHandler);//手势滑动即刻触发，板子响应快点好。
			}
			view.uiImage.removeChildAt(0);
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){	
				case List_User_Rrl:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){
						idArr.push(PackData.app.CmdOStr[1].toString());		//素材id				
						sourceArr.push(PackData.app.CmdOStr[2].toString());//素材文件路径
						typeArr.push(PackData.app.CmdOStr[3].toString());  //文件类型
						version.push(PackData.app.CmdOStr[4].toString());  //最新版本号
						sizeArr.push(Number(PackData.app.CmdOStr[5]));	   //文件大小
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						var len:int = sourceArr.length;
						if(len>0){	
							item.asId = idArr[0];
							item.asPath = sourceArr[0];
							item.asType = typeArr[0];
							item.asVersion = version[0];
							item.asSize = sizeArr[0];		
							
							for(var i:int=1;i<len;i++){								
								item.swfId[i-1]=idArr[i];
								item.swfPath[i-1]=sourceArr[i];
								item.swfType[i-1]=typeArr[i];
								item.swfVersion[i-1]=version[i];
								item.swfSize[i-1]=sizeArr[i];
							}	
							
							idArr=[];
							typeArr=[];
							version=[];
							sourceArr=[];
							sizeArr=[];
							sendinServerInfo(CmdStr.List_New_User_Rrl,item.rrlPath,List_New_User_Rrl);//派发第二步获取所有绘本更新信息	
						}
					}
					break;
				
				case List_New_User_Rrl:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){						
						flag = true;
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){		
						if(flag){//如果执行过上面。则说明需要下载
							item.needLoad = true;//需要下载
						}else{
							//检查本地文件是否存在		
							trace("swf路径 = "+item.swfPath[0]);
							if(!test(item.asPath) || !test(item.swfPath[0])){
								item.needLoad = true;//本地文件不存在也要下载
							}else{
								item.needLoad = false;//本地不需要下载
							}		
						}						
						item.hasCache = true;//不用读取缓存了。
						panelShow();//显示面板信息
					}
					
					flag = true;
					break;
				
				case down_Load_AS:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){
						idArr.push(PackData.app.CmdOStr[1].toString());		//素材id				
						sourceArr.push(PackData.app.CmdOStr[2].toString());//素材文件路径
						typeArr.push(PackData.app.CmdOStr[3].toString());  //文件类型
						version.push(PackData.app.CmdOStr[4].toString());  //最新版本号
						sizeArr.push(Number(PackData.app.CmdOStr[5]));	   //文件大小
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){		
						var len1:int = sourceArr.length;
						if(len1>0){	
							item.asId = idArr[0];
							item.asPath = sourceArr[0];
							item.asType = typeArr[0];
							item.asVersion = version[0];
							item.asSize = sizeArr[0];		
							
							for(var j:int=1;j<len1;j++){								
								item.swfId[j-1]=idArr[j];
								item.swfPath[j-1]=sourceArr[j];
								item.swfType[j-1]=typeArr[j];
								item.swfVersion[j-1]=version[j];
								item.swfSize[j-1]=sizeArr[j];
							}
							idArr=[];
							typeArr=[];
							version=[];
							sourceArr=[];
							sizeArr=[];
							loadas();
						}
					}
					
					break;
				
				case down_Load_SWF:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){
						idArr.push(PackData.app.CmdOStr[1].toString());		//素材id				
						sourceArr.push(PackData.app.CmdOStr[2].toString());//素材文件路径
						typeArr.push(PackData.app.CmdOStr[3].toString());  //文件类型
						version.push(PackData.app.CmdOStr[4].toString());  //最新版本号
						sizeArr.push(Number(PackData.app.CmdOStr[5]));	   //文件大小
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){		
						var len2:int = sourceArr.length;
						if(len2>0){	
							item.asId = idArr[0];
							item.asPath = sourceArr[0];
							item.asType = typeArr[0];
							item.asVersion = version[0];
							item.asSize = sizeArr[0];		
							
							for(var m:int=1;m<len2;m++){								
								item.swfId[m-1]=idArr[m];
								item.swfPath[m-1]=sourceArr[m];
								item.swfType[m-1]=typeArr[m];
								item.swfVersion[m-1]=version[m];
								item.swfSize[m-1]=sizeArr[m];
							}
							idArr=[];
							typeArr=[];
							version=[];
							sourceArr=[];
							sizeArr=[];
							loadswf();
						}
					}
					
					break;
				
				case CoreConst.CANCEL_DOWNLOAD:
					sendNotification(CoreConst.CANCEL_SWITCH);
					closeThisHandler();
					
					break;
			}			
		}
		
		override public function listNotificationInterests():Array{
			return[List_New_User_Rrl,List_User_Rrl,down_Load_AS,down_Load_SWF,CoreConst.CANCEL_DOWNLOAD];
		}
		//验证文件是否存在
		private function test(str:String):Boolean{
			var file:File = Global.document.resolvePath(Global.localPath+str);
			if(file.exists){
				return true;//文件存在
			}else
				return false;//文件不存在
		}
		
		protected function panelShow():void{
			if(item.needLoad){//为true则需要下载
				view.delTxt.visible = false;
				view.DownLoadFlagBtn.visible = true;
			}else{//否则无需下载，直接读取本地文件
				view.delTxt.visible = true;
				view.DownLoadFlagBtn.visible = false;
			}
		}
		//鼠标手势		
		private function touchMoveHandler(event:TransformGestureEvent):void{	
			if(event.offsetX == -1) { //向右滚
				rightBookHandler(null);				
				direction = -1;
			} else if(event.offsetX == 1) { //向左滚
				leftBookHandler(null);
				direction = 1;
			} 
		}
		//向左浏览
		private function leftBookHandler(event:MouseEvent):void{
			if(item && item.orderId!=0){//不是第一个的话，则可以向左
				item = bookArr[item.orderId -1] as BookPicture;
				if(item){					
					direction = 1;
					itemShow();				
					view.leftBtn.visible = true;
					
					view.info.visible = true;
					showInfoHandler(null);//测试信息，待删除
				}
			}else{//如果是第一个则禁用向左
				view.rightBtn.visible = false;
			}
		}
		//向右浏览
		private function rightBookHandler(event:MouseEvent):void{
			if(item && item.orderId != (bookArr.length-1)){//不是最后一个则可以向右
				item = bookArr[item.orderId +1] as BookPicture;
				if(item){					
					direction = -1;
					itemShow();
					view.rightBtn.visible = true;
									
					view.info.visible = true;
					showInfoHandler(null);//测试信息，待删除
				}
			}else{
				view.leftBtn.visible = false;
			}
		}
		
		protected function enterBookHandler(event:MouseEvent=null):void{
			//sendNotification(ApplicationFacade.PUSH_VIEW,new PushViewVO(EBookNewView,item));
			if(Global.use3G && item.needLoad){
				sendNotification(CoreConst.TOAST,new ToastVO('当前正在使用3g网络，不能下载'));
				return;
			}
			if(!flag){
				sendNotification(CoreConst.TOAST,new ToastVO("请检查您的网络连接 或 离wifi信号源距离过远。"));
			}else{
				if(item){		
					view.cancleBtn.visible = false;
					view.sureBtn.visible = false;
					view.leftBtn.visible = false;
					view.rightBtn.visible = false;
					view.delTxt.visible = false;
					view.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,touchMoveHandler);//手势滑动即刻触发，板子响应快点好。
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EBookNewView2Mediator,item),new SwitchScreenVO(CleanGpuMediator)]);
				}
			}
		}
		
		//后台信息派发函数
		private function sendinServerInfo(command:String,info:String,reveive:String):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = Global.license.macid;
			PackData.app.CmdIStr[3] = info;
			PackData.app.CmdInCnt = 4;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));	//派发调用绘本列表参数，调用后台		
		}
		
		public function get view():BookFaceShow2View{
			return getViewComponent() as BookFaceShow2View;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;
			item = prepareVO.data.item as BookPicture;//单本书
			bookArr = prepareVO.data.bookArr as Array;//所有书
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}		
		
		override public function get viewClass():Class{
			return BookFaceShow2View;
		}
	}
}