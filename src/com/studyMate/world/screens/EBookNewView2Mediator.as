package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.ebook.PictureBook;
	import com.studyMate.model.vo.FileVO;
	import com.studyMate.model.vo.LocalFilesLoadCommandVO;
	import com.studyMate.model.vo.ScriptExecuseVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.LayoutToolUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.offPictureBook.OffConfigStatic;
	import com.studyMate.world.script.LayoutTool;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	
	import fl.controls.Label;
	import fl.controls.Slider;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import zhen.guo.yao.components.flipbook.FlipCompleteEvent;
	import zhen.guo.yao.components.flipbook.FlipPage;
	import zhen.guo.yao.components.flipbook.HotEvent;
	import zhen.guo.yao.components.flipbook.PageUtils;

	public class EBookNewView2Mediator extends ScreenBaseMediator
	{
		public static const NAME:String = "EBookNewView2Mediator";
		//public static const FILE_COMPLETE:String = NAME+"FileComplete";
		private const PBLIB_SWF_PAGE_LOAD:String = NAME + "pbSwfPageLoad";
		private const Load_AS_FILE:String = NAME + "loadAsFile";
		protected const PRE_PARE:String = NAME + "Prepare";
		private const yesHandler:String = NAME + "yesHandler";
		private const RECIVE_DATA:String = NAME + "RECIVE_DATA";
				
		private var flipPage:FlipPage;
		//private var holder:SpriteVisualElement;
		//private var holderCover:SpriteVisualElement;
		//private var wordSelectStart:int = -1;
		//private var wordSelectEnd:int = -1;
		private var nextPage:Boolean = false;
		private var prePage:Boolean = false;
		private var next_preSign:Boolean = false;
		private var gotoPageSign:Boolean = false;
		//private var alertTipsSign:Boolean = false;
		private var isKeyBoardOpened:Boolean;
		private var isZoomed:Boolean = false;
		protected var viewVO:SwitchScreenVO;
		private var beginTime:Number;
		//private var endTime:Date;
		private var rrl:String;
		private var rankid:String;
		private var beginDateStr:String; 
		
		protected var _vec:Vector.<UpdateListItemVO>;
		
		
		private var gotoPageHS:Slider;
		private var pageIndex:Label;
		private var holder:Sprite;
		
		public function EBookNewView2Mediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;		
			//Global.isLoading = false;
			gotoPageHS = new Slider();
			gotoPageHS.x = 100;
			gotoPageHS.y = 680;
			gotoPageHS.width = 1080;
			gotoPageHS.value = 1;
			gotoPageHS.snapInterval = 1;
			gotoPageHS.visible = false;
			view.addChild(gotoPageHS);
			
			pageIndex = new Label();
			pageIndex.text = "加载中...";
			pageIndex.x = 619;
			pageIndex.y = 699;
			view.addChild(pageIndex);
			
			holder = new Sprite();
			view.addChild(holder);
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(CoreConst.LOCAL_FILES_LOAD,new LocalFilesLoadCommandVO(_vec,Load_AS_FILE));//检查本地文件										
		}
		
		protected function checkPic():void{
			var item:BookPicture = viewVO.data as BookPicture;
			var boo:Boolean = OffConfigStatic.checkPic(item.asPath);
			if(boo){
				OffConfigStatic.insert(item);
			}
		}
		
		private function goAction():void{	
			checkPic();
			
			beginTime = getTimer();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("yyyyMMdd-HHmmss");
			beginDateStr = dtf.format(Global.nowDate); 
			
			isZoomed = false;
			view.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,softKeybordHandle);
			view.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,softKeybordHandle);
			
			flipPage = new FlipPage(1280,752,50);									
			flipPage.showShadowOnFlipComplete=false;//翻页完毕后不显示中间阴影
			
			//holder.height = flipPage.height;
			holder.addChild(flipPage);
			
			flipPage.addEventListener(HotEvent.PRESSED, hotPressedHandler);//热区按下
			flipPage.addEventListener(HotEvent.DRAGED, hotDragedHandler);//热区按下后，拖动。
			flipPage.addEventListener(FlipCompleteEvent.FLIP_COMPLETE, flipCompleteHandle);//翻页完成。			
			
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,backEvent,false,1);
			
			//SelectMenuTextfield.gotoPageHS = gotoPageHS;
			//服务器脚本

			LayoutToolUtils.LibSCRSelect = "pictureBook";
			view.addEventListener(MouseEvent.CLICK,pbHolderCoverVisible);
			PageUtils.book = new PictureBook();
			
			gotoPageHS.maximum = SimpleScriptNewProxy.getTotalPage();
			flipPage.loadByPageIndex(gotoPageHS.maximum);
			gotoPageHS.minimum = 1;
			flipPage.dispatchEvent(new FlipCompleteEvent(FlipCompleteEvent.FLIP_COMPLETE));
																
			Global.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);//屏幕放大
			//view.addEventListener(MouseEvent.MOUSE_DOWN,startDragging);//屏幕拖动
			view.addEventListener(MouseEvent.MOUSE_UP,stopDragging);
			
			Global.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);			
			
			gotoPageHS.addEventListener(MouseEvent.MOUSE_DOWN,regotoPage);
			gotoPageHS.addEventListener(MouseEvent.MOUSE_UP,adgotoPage);
			gotoPageHS.addEventListener(Event.CHANGE,changePage);
			
			view.setChildIndex(gotoPageHS,view.numChildren-1);
			view.setChildIndex(pageIndex,view.numChildren-1);
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){				
				
				case PBLIB_SWF_PAGE_LOAD:				
					LayoutToolUtils.script = Vector.<String>(MyUtils.strLineToArray(notification.getBody()[1] as String));					
					goAction();
					Global.isLoading = false;
					break;
				
				case Load_AS_FILE:					
					sendNotification(CoreConst.FILE_LOAD,new FileVO("book",Global.localPath+viewVO.data.asPath ,PBLIB_SWF_PAGE_LOAD,PackData.BUFF_ENCODE));					
					break;	
				case PRE_PARE:
					var item:BookPicture = viewVO.data as BookPicture;
					item.needLoad = false;
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,viewVO);
					break;
				case yesHandler:					
					alertTips();
					break;
				case RECIVE_DATA:
					TweenLite.killTweensOf(holder);
					addOrRemoveEventListener("remove");
					Global.stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);//屏幕放大
					sendNotification(WorldConst.POP_SCREEN);
					break;
				case CoreConst.CANCEL_DOWNLOAD:{
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_SWITCH,viewVO);
					break;
				}
			}						
		}
		
		override public function listNotificationInterests():Array{
			return [PBLIB_SWF_PAGE_LOAD,Load_AS_FILE,PRE_PARE,yesHandler,RECIVE_DATA,CoreConst.CANCEL_DOWNLOAD];
		}
		
		private function updateHolderHeight():void{			
			var maxH:Number=0;
			var hh:Number;
			var item:DisplayObject;
			var total:int = holder.numChildren;
			for (var i:int=0; i < total; i++) {
				item = holder.getChildAt(i);
				hh = item.height+item.y;
				if(maxH<hh){
					maxH=hh;
				}
			}
			holder.height = maxH;
		}
		//屏幕放大功能
		private var scaleNum:Number = 1;
		private var p:Point;
		private var olderScaleX:Number;
		private var olderX:Number;
		private var olderY:Number;
		protected function onZoom(e:TransformGestureEvent):void{
			scaleNum = (e.scaleY+e.scaleX)/2;	
			//scaleNum = e.scaleY;
			if(e.phase==GesturePhase.BEGIN){
				p = new Point( e.stageX, e.stageY );
				holder.mouseEnabled = holder.mouseChildren = false;
				isZoomed = true;
				olderScaleX = holder.scaleX;
				olderX = holder.x;
				olderY = holder.y;
				view.stopDrag();
				if(Global.stage.hasEventListener(MouseEvent.DOUBLE_CLICK)){
					Global.stage.removeEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
				}
				if(view.hasEventListener(MouseEvent.MOUSE_DOWN)){
					view.addEventListener(MouseEvent.MOUSE_DOWN,startDragging);//屏幕拖动
				}
				addOrRemoveEventListener("remove");
			}else if(e.phase==GesturePhase.UPDATE){
				if(holder.scaleX*scaleNum>5){
					holder.scaleX = 5;
					holder.scaleY=5;
				}else{
					holder.scaleX = holder.scaleY *= scaleNum;

					//holder.x = p.x*(1-holder.scaleX);
					//holder.y = p.y*(1-holder.scaleY);
					
					holder.x = p.x- (p.x - olderX)*holder.scaleX/olderScaleX;
					holder.y = p.y- (p.y - olderY)*holder.scaleX/olderScaleX;
				}
				
			}else if(e.phase==GesturePhase.END){
				//updateHolderHeight();
				

				if(holder.scaleX<=1.2){
					if(holder.scaleX!=1){
						TweenLite.to(holder,0.5,{scaleX:1,scaleY:1,x:0,y:0});
					}
					holder.mouseEnabled = holder.mouseChildren = true;
					view.stopDrag();
					isZoomed = false;
					addOrRemoveEventListener("add");
					
				}else{
					view.addEventListener(MouseEvent.MOUSE_DOWN,startDragging);//屏幕拖动
					/*if(isZoomed){
						trace("可以拖动了。");
						var a:Number = holder.scaleX*Global.stageWidth -Global.stageWidth;
						var b:Number = holder.scaleY*Global.stageHeight - Global.stageHeight;
						var rect:Rectangle = new Rectangle(-a,-b,a,b);
						holder.startDrag(false,rect);
						Global.stage.addEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
					}*/
				}
			}		　　			
		}
		private function addOrRemoveEventListener(s:String):void{
			if(s=="add"){
				if(!flipPage.hasEventListener(HotEvent.PRESSED)){
					flipPage.addEventListener(HotEvent.PRESSED, hotPressedHandler);//热区按下
					flipPage.addEventListener(HotEvent.DRAGED, hotDragedHandler);//热区按下后，拖动。
					flipPage.addEventListener(FlipCompleteEvent.FLIP_COMPLETE, flipCompleteHandle);//翻页完成。
					Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,backEvent,false,1);
				}
			}else{
				flipPage.removeEventListener(HotEvent.PRESSED, hotPressedHandler);//热区按下
				flipPage.removeEventListener(HotEvent.DRAGED, hotDragedHandler);//热区按下后，拖动。
				flipPage.removeEventListener(FlipCompleteEvent.FLIP_COMPLETE, flipCompleteHandle);//翻页完成。
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,backEvent);
			}
		}
		protected function startDragging(e:MouseEvent):void{
			if(isZoomed){
				var a:Number = holder.scaleX*Global.stageWidth -Global.stageWidth;
				var b:Number = holder.scaleY*Global.stageHeight - Global.stageHeight;
				var rect:Rectangle = new Rectangle(-a,-b,a,b);
				holder.startDrag(false,rect);
				Global.stage.addEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
			}
		}		
		private function DoubleClickHandler(e:MouseEvent):void{
			Global.stage.removeEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
			holder.mouseEnabled = holder.mouseChildren = true;
			view.stopDrag();
			holder.scaleX = 1;
			holder.scaleY = 1;
			isZoomed = false;
			holder.x = 0;
			holder.y = 0;
			//trace("北双击");
			addOrRemoveEventListener("add");
		}
		
		protected function stopDragging(event:MouseEvent):void{
			if(isZoomed){
				holder.stopDrag();
			}
		}
		private function softKeybordHandle(event:SoftKeyboardEvent):void{
			if(event.type == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE&&!isKeyBoardOpened){
				isKeyBoardOpened = true;				
			}else if(event.type == SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE){
				isKeyBoardOpened = false;				
			}
		}						
		
		private function pbHolderCoverVisible(event:MouseEvent):void{
			if(event.localX > 50 && event.stageY > 700){
				if(gotoPageHS.visible == true && gotoPageSign == false){
					gotoPageHS.visible = false;
				}
				else{
					gotoPageHS.visible = true;
					gotoPageSign = false;
				}
			}			
		}			
		
		private function regotoPage(event:MouseEvent):void{		
			Global.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);	
		}
		private function adgotoPage(event:MouseEvent):void{
			Global.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);	
		}
		
		private function changePage(event:Event):void{
			flipPage.gotoPage(gotoPageHS.value-1);
			var currentPage:int = flipPage.currentPageIndex+1;			
			//服务器脚本		
			LayoutToolUtils.holder = flipPage.currentPage as Sprite;
			LayoutToolUtils.removeAll();
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(flipPage.pages[flipPage.currentPageIndex],-1));
			
			pageIndex.text = currentPage.toString() + "/" + SimpleScriptNewProxy.getTotalPage();
			gotoPageHS.value = currentPage;
			gotoPageSign = true;
								
		}				
		
		private function onSwipe(e:TransformGestureEvent):void{
			if(isZoomed){
				return;
			}
			gotoPageHS.visible = false;
			//wordSelectStart = -1;
			//wordSelectEnd = -1;
			pageIndex.visible = false;
			if(e.offsetX==-1){
				if(!flipPage._page.isEnd){
					flipPage.next();
				}				
			}			
			if(e.offsetX==1){
				if(!flipPage._page.isStart){
					flipPage.prev();
				}
			}
		}		
		
		//确认则发送读书的基本信息
		protected function alertTips():void{
			//等待做好弹出框组件
				//服务器脚本
				//endTime = Global.nowDate;
			if(!Global.isLoading){
				
				var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
				dtf.setDateTimePattern("yyyyMMdd-HHmmss");
				
				
				var endDateStr:String=dtf.format( Global.nowDate); //学习结束时间
				var ms:int = getTimer() - beginTime;
				var totalTime:String = String(int(ms/1000));//学习总时长		
				var currentPageStr:String = String(flipPage.currentPageIndex+1);//当前页				
				var totalPageStr:String = String(SimpleScriptNewProxy.getTotalPage());//总页数											
				
	
				LayoutToolUtils.LibSCRSelect = "pictureBook";
				
				PackData.app.CmdIStr[0] = CmdStr.Submit_Task_Pic_Book;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = rrl;
				PackData.app.CmdIStr[3] = rankid;
				PackData.app.CmdIStr[4] = totalTime;
				PackData.app.CmdIStr[5] = beginDateStr;
				PackData.app.CmdIStr[6] = endDateStr;
				PackData.app.CmdIStr[7] = currentPageStr;
				PackData.app.CmdIStr[8] = totalPageStr;
				PackData.app.CmdIStr[9] = title;
				PackData.app.CmdInCnt = 10;
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(RECIVE_DATA));
			}
								
		}
		protected function stopBack():void{
			sendNotification(WorldConst.ALERT_SHOW,new AlertVo("确定要退出吗",true,yesHandler,"noHandler"));
		}
		protected function backEvent(event:KeyboardEvent):void{
			if(event.keyCode==Keyboard.ESCAPE || event.keyCode == 16777238){
				event.preventDefault();			
				event.stopImmediatePropagation();
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("确定要退出吗",true,yesHandler,"noHandler"));
			}else if(event.keyCode == Keyboard.PAGE_UP || event.keyCode == 37){
				event.preventDefault();	
				event.stopImmediatePropagation();				
				flipPage.prev();
			}else if(event.keyCode == Keyboard.PAGE_DOWN || event.keyCode == 39){
				event.preventDefault();	
				event.stopImmediatePropagation();
				flipPage.next();
			}
		}
		
		//翻页完成。
		protected function flipCompleteHandle(event:FlipCompleteEvent):void{
			Global.stage.frameRate=24;
			pageIndex.visible = true;
			gotoPageHS.visible = false;
			next_preSign = false;
			if( flipPage ){
				if(nextPage){
					flipPage.next();
					nextPage = false;
				}else if(prePage){
					flipPage.prev();
					prePage = false;
				}else{		
					var currentPage:int = flipPage.currentPageIndex+1;	
					//服务器脚本		
					pageIndex.text = currentPage.toString() + "/" + SimpleScriptNewProxy.getTotalPage();
					gotoPageHS.value = currentPage;
					LayoutToolUtils.holder = flipPage.currentPage as Sprite;
					LayoutToolUtils.removeAll();
					if(flipPage.currentPageIndex==gotoPageHS.maximum){
						pageIndex.text = "1/"+SimpleScriptNewProxy.getTotalPage();
						flipPage.gotoPage(0);
					}/*else{
					}*/
					sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(flipPage.pages[flipPage.currentPageIndex],-1));
				}
			}			
		}		
		
		//热区按下
		private function hotPressedHandler(evn:HotEvent):void{
			Global.stage.frameRate=60;
			gotoPageHS.visible = false;
			//wordSelectStart = -1;
			//wordSelectEnd = -1;
			pageIndex.visible = false;			
			LayoutToolUtils.killLayoutScript();			
		}		
		
		//热区按下后，拖动。
		private function hotDragedHandler(evn:HotEvent):void{
			if(gotoPageHS)
				gotoPageHS.visible = false;
			if(view && flipPage && flipPage._hot ){
				if(flipPage._hot.pressedHotName == "RightUp" || flipPage._hot.pressedHotName == "RightDown"){
					if(view.mouseX >= 1230 && next_preSign == false){
						nextPage = true;
					}
					if(view.mouseX < 1230){
						next_preSign = true;
						nextPage = false;
					}
				}
				
				if(flipPage._hot.pressedHotName == "LeftUp" || flipPage._hot.pressedHotName == "LeftDown"){
					if(view.mouseX <= 50 && next_preSign == false){
						prePage = true;
					}
					if(view.mouseX > 50){
						next_preSign = true;
						prePage = false;
					}
				}
			}
						
		}						
		
		public function get view():Sprite{
			return viewComponent as Sprite;
		}
		
		override public function onRemove():void{
			Global.stage.frameRate=60;
			Global.stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);	
			TweenLite.killTweensOf(holder);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			if(LayoutToolUtils.holder){
				/*while(LayoutToolUtils.holder.numChildren){
					var sp:DisplayObject =  LayoutToolUtils.holder.removeChildAt(0);
					sp = null;
				}*/
				LayoutToolUtils.holder.removeChildren();
				LayoutToolUtils.holder = null;
			}
			if(flipPage){
				flipPage.parent.removeChild(flipPage);
				flipPage.removeEventListener(HotEvent.PRESSED, hotPressedHandler);//热区按下
				flipPage.removeEventListener(HotEvent.DRAGED, hotDragedHandler);//热区按下后，拖动。
				flipPage.removeEventListener(FlipCompleteEvent.FLIP_COMPLETE, flipCompleteHandle);//翻页完成。
				flipPage = null;
			}
			if(gotoPageHS){
				gotoPageHS.removeEventListener(MouseEvent.MOUSE_DOWN,regotoPage);
				gotoPageHS.removeEventListener(MouseEvent.MOUSE_UP,adgotoPage);
				gotoPageHS.removeEventListener(Event.CHANGE,changePage);
			}
			viewVO.data = null;
			viewVO = null;		
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,backEvent);
			Global.stage.removeEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
			Global.stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);//屏幕放大
			LayoutToolUtils.killLayoutScript();
			LayoutToolUtils.disposeHolder();
			LayoutTool.reset();
			//LayoutTool.reset();			
			//LayoutToolUtils.holder.getq
			super.onRemove();			
		}
		private var title:String ;
		override public function prepare(vo:SwitchScreenVO):void{
			viewVO = vo;			
		
			var item:BookPicture = viewVO.data as BookPicture;
			rrl = item.rrlPath;
			title = item.title;
			rankid = item.rankid;
			_vec = new Vector.<UpdateListItemVO>;
			var _itemAs:UpdateListItemVO = new UpdateListItemVO(item.asId,item.asPath,item.asType,item.asVersion);
			var _itemSwf:UpdateListItemVO;
			if(item.needLoad){//如果需要下载，则强制下载
				//item.needLoad = false;
				_itemAs.hasLoaded = false;
			}else{
				_itemAs.hasLoaded = true;
			}
			_vec.push(_itemAs);//as文件
			for(var i:int=0;i<item.swfId.length;i++){
				_itemSwf = new UpdateListItemVO(item.swfId[i].toString(),item.swfPath[i].toString(),item.swfType[i].toString(),item.swfVersion[i].toString());
				if(item.needLoad){
					_itemSwf.hasLoaded = false;
				}else{
					_itemSwf.hasLoaded = true;
				}
				_vec.push(_itemSwf);//swf文件
			}
			//item.needLoad = false;
			//sendNotification(ApplicationFacade.LOCAL_FILES_LOAD,new LocalFilesLoadCommandVO(_vec,Load_AS_FILE));//检查本地文件
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(_vec,PRE_PARE,null,true));
			
		}
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}