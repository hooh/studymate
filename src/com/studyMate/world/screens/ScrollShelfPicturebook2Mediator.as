package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.view.component.myScroll.Scroll;
	import com.studyMate.world.component.BookGroupComponent;
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.component.LazyLoad;
	import com.studyMate.world.events.NoticeEffectEvent;
	import com.studyMate.world.events.ShowFaceEvent;
	import com.studyMate.world.model.vo.AlertVo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import mycomponent.DrawBitmap;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	


	public class ScrollShelfPicturebook2Mediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ScrollShelfPicturebook2Mediator";
		public var prepareVO:SwitchScreenVO;
		
		private var whichShelf:String;//那一个书架。由外部派发
		
		private var _txtFiled:TextField;//页码
		private var totalPage:int;//总页数
		private var currentPage:int = 1;//当前页默认为第一页
		protected var bookArr:Array;//书本合集数组
		private var currentPoint:Number = 0;//当前滚动组件坐标
		private var FlagArr:Array;//存储布尔值，判断是页面否为处女页
		private var orderId:int = 0;
		private var vec:Vector.<UpdateListItemVO>;//所有绘本
		private var vec1:Vector.<UpdateListItemVO>;//要更新的绘本
		
		private var canBoolean:Boolean;
		private var startComponent:int;
		private var startBook:int;
		private var endComponent:int;
		private var endBook:int;
		private var currentMoveUI:Sprite;
		
		private var scroll:Scroll;
		private var uiMoveBtn:Sprite;
		private var dustbinBtn:Sprite;
		private var bookGroups:Sprite;
		
		private const List_User_PicBook:String = NAME+"ListUserPicBook";
		private const End_List_User_PicBook:String = NAME + "EndListUserPicBook";
		private const List_New_User_PicBook:String  = NAME + "ListNewUserPicBook";
		private const End_List_New_User_PicBook:String  = NAME + "EndListNewUserPicBook";
		private const Exchg_User_Book:String = NAME+ "ExchgUserBook";
		private const Del_User_Book:String = NAME + "DelUserBook";
		private const yesHandlerDel:String = NAME+ "yesHandlerDel";
		
		public function ScrollShelfPicturebook2Mediator(viewComponent:Object = null){
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			view.y = 60;
			
			scroll = new Scroll();
			scroll.width = 1280;
			scroll.height = 692;
			bookGroups = new Sprite();
			scroll.viewPort = bookGroups;
			scroll.delayTime = 0.3;
			scroll.state = 'HORIZONTAL';
			scroll.pageScrollingEnabled = true;
			view.addChild(scroll);			
			
			uiMoveBtn = new Sprite();
			view.addChild(uiMoveBtn);
			
			/*var dustbinClass:Class = AssetTool.getCurrentLibClass("dustbin_Up");//中间底部书架页码
			dustbinBtn = new dustbinClass();
			dustbinBtn.x = 1137;
			dustbinBtn.y = 625;
			view.addChild(dustbinBtn);*/
			
			bookArr = [];
			FlagArr = [];	
			
			vec = new Vector.<UpdateListItemVO>;
			vec1 = new Vector.<UpdateListItemVO>;
			
			if(CacheTool.has(NAME,"PicturebookArr")){
				bookArr = CacheTool.getByKey(NAME,"PicturebookArr") as Array;
				this.showBook(bookArr);
			}else{				
				sendNotification(CoreConst.TOAST,new ToastVO("正在获取所有绘本基本信息...",2));
				sendinServerInfo(CmdStr.List_User_PicBook,whichShelf,List_User_PicBook);//派发第一步获取所有绘本基本信息
			}	
			
		}
		
		override public function handleNotification(notification:INotification):void{	
			var result:DataResultVO = notification.getBody() as DataResultVO;
			if(result && result.isCanceled) return;
			switch(notification.getName()){					
				case List_User_PicBook://获取第一步获取所有绘本基本信息
					if(!result.isEnd){
						var book:BookPicture = new BookPicture();
						book.orderId = orderId;//排序
						book.rankid = PackData.app.CmdOStr[1].toString();//书的rankid标识
						book.rrlPath = PackData.app.CmdOStr[2].toString();//rrl路径
						book.title = PackData.app.CmdOStr[3].toString();//书的标题
						book.facePath = PackData.app.CmdOStr[4].toString();//书的封面路径
						bookArr.push(book);												
						orderId++;
						
						var _item:UpdateListItemVO = new UpdateListItemVO("",PackData.app.CmdOStr[4].toString(),"","");
						_item.hasLoaded = true;//检查文件			
						vec.push(_item);
					}else if(result.isEnd){
						CacheTool.put(NAME,"PicturebookArr",bookArr);					
						sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(vec,End_List_User_PicBook,null));//检查本地文件
					}else if(result.isErr){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n绘本信息获取错误,\n您可以通过FAQ反馈工作人员，\n点击确定离开界面。",false,'yesQuitHandler','noHandler',false,null,yesQuitHandler));//提交订单
					}
					break;
				
				case End_List_User_PicBook:
					sendNotification(CoreConst.TOAST,new ToastVO("正在获取绘本封面更新信息...",0.6));
					sendinServerInfo(CmdStr.List_New_User_PicBook,"All",List_New_User_PicBook);//派发第二步获取绘本要更新封面的信息
					break;
				
				case List_New_User_PicBook://获取第二步获取绘本要更新封面的信息
					if(!result.isEnd){
						var _item1:UpdateListItemVO = new UpdateListItemVO(PackData.app.CmdOStr[1].toString(),PackData.app.CmdOStr[2].toString(),PackData.app.CmdOStr[3].toString(),PackData.app.CmdOStr[4].toString());
						_item1.hasLoaded = false;//强制更新
						vec1.push(_item1);
					}else if(result.isEnd){
						if(vec1.length>0){//如果该变量有，则说明有封面要强制更新		
							sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(vec1,End_List_New_User_PicBook));
						}else{
							this.showBook(bookArr);
						}
					}else if(result.isErr){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n绘本信息获取错误,\n您可以通过FAQ反馈工作人员，\n点击确定离开界面。",false,'yesQuitHandler','noHandler',false,null,yesQuitHandler));//提交订单

					}
					break;
				
				case End_List_New_User_PicBook:
					this.showBook(bookArr);	
					break;
				
				case CoreConst.CLOSE_FACE_SHOW://子目录对象通知其更新页面
					view.mouseEnabled = true;
					view.mouseChildren = true;
					break;
				
//				case CoreConst.DRAG_FACE_MOVE://拖动封面换位置的通知
//					return;
//					view.mouseEnabled = false;
//					//bookGroups.mouseEnabled = false;
//					var e:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP);
//					view.dispatchEvent(e);
//					
//					currentMoveUI = notification.getBody().target as Sprite;
//					var bitmap:DrawBitmap = new DrawBitmap(currentMoveUI,currentMoveUI.width,currentMoveUI.height);
//					uiMoveBtn.addChild(bitmap);
//					bitmap.alpha = 0.8;
//					uiMoveBtn.x =  view.mouseX-currentMoveUI.width/2;
//					uiMoveBtn.y = view.mouseY-currentMoveUI.height/2;
//					uiMoveBtn.startDrag();
//					uiMoveBtn.addEventListener(MouseEvent.MOUSE_MOVE,onMoveHandler);
//					uiMoveBtn.addEventListener(MouseEvent.MOUSE_UP,onUpHandler);
//					
//					startComponent = currentPage-1;//第几栏
//					startBook = int(currentMoveUI.name);//第几本书
//					break;
//				
//				case Exchg_User_Book:
//					if((PackData.app.CmdOStr[0] as String)=="000"){
//						//trace("换位成功！");
//						succeedFunction();
//					}else{
//						//trace("换位失败！");
//						failedFunction();
//					}
//					break;
//				
//				case Del_User_Book:
//					if((PackData.app.CmdOStr[0] as String)=="000"){
//						//trace("删除成功");
//						MyFunctionDel();
//					}else{
//						//trace("删除失败");
//						failedFunction();
//					}
//					break;
//				case yesHandlerDel:
//					DelElementHandler();
//					break;
				case LazyLoad.QUEUE_LOAD_START://加载完成后恢复点击
					view.mouseChildren = false;
					break;
				case LazyLoad.QUEUE_LOAD_COMPLETE://加载完成后恢复点击
					view.mouseChildren = true;
					break;
			}
		}		
		
		private function yesQuitHandler():void
		{
			var keyEvent:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
			keyEvent.keyCode =  Keyboard.BACK;
			Global.stage.dispatchEvent(keyEvent);
			
		}
		//拖动操作
//		private function onMoveHandler(event:MouseEvent):void{
//			if(uiMoveBtn.x<0 && canBoolean==true){//向左滚
//				if(currentPage!=1){
//					canBoolean=false;
//					scroll.pageScrollingEnabled=false;
//					TweenLite.to(bookGroups,0.5,{x:-(currentPage-2)*1280,onComplete:MoveChangePageHandler,onCompleteParams:[-1]});
//				}
//			}else if(uiMoveBtn.x > 1136 && canBoolean==true){//向右滚
//				if(currentPage!=totalPage){//如果没有到最后一页
//					canBoolean=false;
//					scroll.pageScrollingEnabled=false;
//					TweenLite.to(bookGroups,0.5,{x:-currentPage*1280,onComplete:MoveChangePageHandler,onCompleteParams:[1]});
//				}				
//			}else if(uiMoveBtn.x>30 && uiMoveBtn.x<1106){//居中即继续可以执行滚动
//				canBoolean = true;
//			}			
//		}
		
		//松开操作
//		private function onUpHandler(event:MouseEvent):void{
//			if(!scroll.pageScrollingEnabled){//如果还在滚动中松手则复原
//				failedFunction();
//			}else{
//				uiMoveBtn.stopDrag();
//				uiMoveBtn.removeEventListener(MouseEvent.MOUSE_MOVE,onMoveHandler);
//				uiMoveBtn.removeEventListener(MouseEvent.MOUSE_UP,onUpHandler);
//				
//				if(dustbinBtn.hitTestObject(uiMoveBtn)){//垃圾箱中
//					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("确定要删除吗",true,yesHandlerDel,"noHandler"));
//					//SkinnableAlert.show("确定要删除吗？","垃圾箱",SkinnableAlert.YES|SkinnableAlert.NO,null,alertTips);
//				}else{//换位或回到原位				
//					exchange();
//				}
//			}
//			
//		}
		/*protected function alertTips(event:CloseEvent):void{
			if(event.detail == SkinnableAlert.YES){
				DelElementHandler();
			}			
		}*/
		//换位
//		private function exchange():void{
//			var regainBoolean:Boolean = false;
//			var XDistance:Number = uiMoveBtn.getChildAt(0).width/2
//			var YDistance:Number = uiMoveBtn.getChildAt(0).height/2;	
//			
//			var vecPoint:Vector.<Point> = CacheTool.getByKey(NAME,"PointAll") as Vector.<Point>;
//			
//			var total:int = (bookGroups.getChildByName("bookGroupCom"+currentPage) as BookGroupComponent).numChildren
//			for(var num:int=0;num<total;num++){
//				if(Math.abs(uiMoveBtn.x-vecPoint[num].x)<XDistance && Math.abs(uiMoveBtn.y-vecPoint[num].y)<YDistance){
//					endComponent = currentPage-1;//第几页
//					endBook = num;//第几本
//					regainBoolean = true;
//					var startNum:int = startComponent*21+startBook;
//					var endNum:int = endComponent*21+endBook;
//					var beginBook:BookPicture = bookArr.getItemAt(startNum) as BookPicture;
//					var toBook:BookPicture = bookArr.getItemAt(endNum) as BookPicture;
//					PackData.app.CmdIStr[0] = CmdStr.Exchg_User_Book;
//					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
//					PackData.app.CmdIStr[2] = whichShelf;
//					PackData.app.CmdIStr[3] = beginBook.rankid;
//					PackData.app.CmdIStr[4] = beginBook.rrlPath;
//					PackData.app.CmdIStr[5] = toBook.rankid;
//					PackData.app.CmdIStr[6] = toBook.rrlPath;
//					PackData.app.CmdInCnt = 7;	
//					sendNotification(CoreConst.SEND_1N,new SendCommandVO(Exchg_User_Book));	//派发调用绘本列表参数，调用后台					
//					break;
//				}
//			}
//			if(regainBoolean==false){//如果没有执行过滑动，则恢复到原始位置
//				var bookGroupCom:BookGroupComponent = bookGroups.getChildByName("bookGroupCom"+(startComponent+1)) as BookGroupComponent;
//				var noticeEffect:NoticeEffectEvent = new NoticeEffectEvent(NoticeEffectEvent.RESET_STATE);
//				bookGroupCom.dispatchEvent(noticeEffect);
//				TweenLite.to(uiMoveBtn,0.5,{x:vecPoint[startBook].x,y:vecPoint[startBook].y,alpha:1,onComplete:removeMyfunction});
//			}
//		}
		
//		private function removeMyfunction():void{
//			while(uiMoveBtn.numChildren){
//				uiMoveBtn.removeChildAt(0);
//			}			
//		}
		//移位反馈成功
//		private function succeedFunction():void{				
//			var vecPoint:Vector.<Point> = CacheTool.getByKey(NAME,"PointAll") as Vector.<Point>;
//			TweenLite.to(uiMoveBtn,0.5,{x:vecPoint[endBook].x,y:vecPoint[endBook].y,alpha:1,onComplete:MyfunctionMove});					
//		}
//		//移位反馈失败
//		private function failedFunction():void{
//			return;
//			var vecPoint:Vector.<Point> = CacheTool.getByKey(NAME,"PointAll") as Vector.<Point>;
//			TweenLite.to(uiMoveBtn,0.5,{x:vecPoint[startBook].x,y:vecPoint[startBook].y,alpha:1,onComplete:removeMyfunction});
//			
//			var bookGroupCom:BookGroupComponent = bookGroups.getChildByName("bookGroupCom"+(startComponent+1)) as BookGroupComponent;
//			var noticeEffect:NoticeEffectEvent = new NoticeEffectEvent(NoticeEffectEvent.RESET_STATE);
//			bookGroupCom.dispatchEvent(noticeEffect);
//		}
		
		//绘本全体需要换位的数组元素换位
//		private function MyfunctionMove():void{
//			var startNum:int = startComponent*21+startBook;
//			var endNum:int = endComponent*21+endBook;
//			var flag:int =startNum<endNum ? 1:-1;//前→后=1，后←前=-1；
//			var total:int = Math.abs(endNum-startNum);
//			for(var i:int=0;i<total;i++){
//				var temp:Object;
//				temp = bookArr.getItemAt(startNum);
//				bookArr.setItemAt((bookArr.getItemAt(startNum+flag)),startNum);				
//				bookArr.setItemAt(temp,startNum+flag);				
//				
//				var tempId:int;
//				tempId = (bookArr.getItemAt(startNum) as BookPicture).orderId;
//				(bookArr.getItemAt(startNum) as BookPicture).orderId = (bookArr.getItemAt(startNum+flag) as BookPicture).orderId;
//				(bookArr.getItemAt(startNum+flag) as BookPicture).orderId = tempId;
//				
//				startNum+=flag;
//			}
//			CacheTool.put(NAME,"PicturebookCurrentPage",currentPage);
//			uiMoveBtn.removeChildAt(0);
//			
//			var bookGroupCom:BookGroupComponent = bookGroups.getChildByName("bookGroupCom"+currentPage) as BookGroupComponent;
//			var noticeEffect:NoticeEffectEvent = new NoticeEffectEvent(NoticeEffectEvent.MOVE_EFFECT_START);
//			
//			noticeEffect.startNum = startBook;
//			noticeEffect.endNum = endBook;
//			if( startComponent!=endComponent){//说明不是当前页特效需删除和添加元素
//				noticeEffect.special = startComponent<endComponent ? "left" : "right";//前→后=1，后←前=-1；
//				noticeEffect.currentUI = currentMoveUI;//传入拖动的元件
//				
//				var totals:int = Math.abs(startComponent-endComponent);
//				for(var j:int=0;j<totals;j++){
//					FlagArr[startComponent] = false;				
//					var tempbookGroupCom:BookGroupComponent = bookGroups.getChildByName("bookGroupCom"+(startComponent+1)) as BookGroupComponent;
//					bookGroups.removeChild(tempbookGroupCom);
//					startComponent+=flag;
//				}
//			}
//			bookGroupCom.dispatchEvent(noticeEffect);		
//		}
//		//删除操作
//		private function DelElementHandler():void{
//			var startNum:int = startComponent*21+startBook;
//			var beginBook:BookPicture = bookArr[startNum] as BookPicture;
//			PackData.app.CmdIStr[0] = CmdStr.Del_User_Book;
//			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
//			PackData.app.CmdIStr[2] = whichShelf;
//			PackData.app.CmdIStr[3] = beginBook.rankid;
//			PackData.app.CmdIStr[4] = beginBook.rrlPath;
//			PackData.app.CmdInCnt = 5;	
//			sendNotification(CoreConst.SEND_1N,new SendCommandVO(Del_User_Book));	//派发调用绘本列表参数，调用后台	
//		}
//		
//		private function MyFunctionDel():void{		
//			var startNum:int = startComponent*21+startBook;
//			bookArr.removeItemAt(startNum);
//			
//			FlagArr = [];
//			CacheTool.put(NAME,"PicturebookCurrentPage",currentPage);
//
//			bookGroups.removeChildren();
//			//bookGroups.removeAllElements();
//			showBook(bookArr);//显示当前页"没有则建立"
//			uiMoveBtn.removeChildAt(0);
//		}
		
//		private function MoveChangePageHandler(i:int):void{	
//			signHandler1(i);
//			pageEndHandler(null);
//			scroll.pageScrollingEnabled=true;	
//		}				
		
		private function showBook(bookArr:Array):void{
			totalPage = Math.ceil(bookArr.length/21);						
			if(CacheTool.has(NAME,"PicturebookCurrentPage")){
				currentPage =  (int)(CacheTool.getByKey(NAME,"PicturebookCurrentPage"));
				_txtFiled.text = currentPage+"/"+totalPage;
				scroll.horizontalScrollPosition = (currentPage-1)*1280;
				currentPoint = scroll.horizontalScrollPosition;
			}else{
				_txtFiled.text = 1 + "/"+totalPage;
			}						
			/**
			 * 定位scroll组件用
			 */
			/*var ui:Sprite = new Sprite();
			ui.graphics.beginFill(0,0);
			ui.graphics.drawRect(0,0,1,1);
			ui.graphics.endFill();
			ui.mouseEnabled = false;
			ui.x = (totalPage-1)*1281;
			ui.y = 690;
			bookGroups.addChild(ui);*/	
			bookGroups.graphics.clear();
			bookGroups.graphics.beginFill(0,0);
			bookGroups.graphics.drawRect(0,0,totalPage*1280-20,690);
			bookGroups.graphics.endFill();
			
			/**
			 * 默认所有的页面均为处女页
			 */
			for(var i:int=0;i<totalPage;i++){
				FlagArr[i] = false;
			}
			
			signHandler1(0);//显示当前页
			
			scroll.addEventListener(Scroll.EFFECT_END,pageEndHandler);
			scroll.addEventListener(Scroll.EFFECT_START,pageStartHandler);//手势滑动离开后触发		
			scroll.update();
		}
		
		private function pageStartHandler(event:Event):void{										
			var i:Number = scroll.horizontalScrollPosition-currentPoint;
			var bookGroupCom:BookGroupComponent = bookGroups.getChildByName("bookGroupCom"+currentPage) as BookGroupComponent;
			if(bookGroupCom)
				bookGroupCom.pauseLoad();
			if(i>0){//trace("11向右边滚动");				
				signHandler1(1);				
			}else if(i<0){//trace("22向左边滚动")
				signHandler1(-1);
			}		
			
		}
		
		private function pageEndHandler(event:Event):void{	
			currentPage = (int)(scroll.horizontalScrollPosition/1280) +1;
			_txtFiled.text = currentPage+ "/"+totalPage;
			currentPoint = scroll.horizontalScrollPosition;
			CacheTool.put(NAME,"PicturebookCurrentPage",currentPage);
			
			var bookGroupCom:BookGroupComponent = bookGroups.getChildByName("bookGroupCom"+currentPage) as BookGroupComponent;
			if(bookGroupCom){
				bookGroupCom.startLoad();
			}else{
				signHandler1(0);//显示当前页"没有则建立"
			}
			clearBmp();
			
		}
		
		/**
		 * 下面的函数为显示书本的算法
		 * 根据手势传参，相应的依次显示书本文件
		 * 算法依据为FlagArr数组的作用为记住页面是否曾经打开过
		 */
		private function signHandler1(i:int):void{	
			try{				
				if(FlagArr[currentPage+(i-1)]==false){//如果当前页是处女地，则注册侦听				
					var faceArr:Array = [];
					var titleArr:Array = [];
					var sourceArr:Array = [];
					var num:int;
					if(totalPage == currentPage+i){
						num = bookArr.length-(totalPage-1)*21
					}else{
						num = 21;
					}
					for(var m:int=0; m<num;m++){
						var item:BookPicture = (bookArr[m +(currentPage+(i-1))*21] as BookPicture);
						faceArr.push(item.facePath);
						titleArr.push(item.title);
						sourceArr.push(item);
					}
					//trace("currentPage+(i-1)="+(currentPage+(i-1)));
					var whichOne:int = currentPage+i;
					var bookGroupCom:BookGroupComponent = new BookGroupComponent(faceArr,titleArr,sourceArr,whichOne);//添加一个页面的书本
					bookGroups.addChild(bookGroupCom);
					bookGroupCom.x = (currentPage+(i-1))*Global.stageWidth;	
					bookGroupCom.addEventListener(ShowFaceEvent.SHOW_FACE,showFaceHandler);
					bookGroupCom.name = "bookGroupCom"+String(currentPage+i);//书本名字为当前页面编码1,2,3
					//trace("bookGroupCom.name = "+bookGroupCom.name);
					
					FlagArr[currentPage+(i-1)] = true;
				}
			}catch(e:Error){
				
			}			
		}	
		
		private function clearBmp():void{
			while( bookGroups.numChildren>1){
				bookGroups.removeChildAt(0);				
			}
			for(var i:int=0;i<totalPage;i++){
				FlagArr[i] = false;
			}
		}
		
		//侦听显示封面
		protected function showFaceHandler(event:ShowFaceEvent):void{			
			view.mouseEnabled = false;
			view.mouseChildren = false;
			var bookbtn:BookPicture = (event.Item.bookContent as BookPicture);
			var data:Object = new Object();
			data.item = bookbtn;//单独一个
			data.bookArr = bookArr;//全部
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BookFaceShow2ViewMediator,data,SwitchScreenType.SHOW,view.parent)]);
		}								
		
		//后台信息派发函数
		private function sendinServerInfo(command:String,info:String,reveive:String):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = Global.license.macid;
			PackData.app.CmdIStr[3] = info;
			PackData.app.CmdInCnt = 4;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台		
		}
		
		override public function listNotificationInterests():Array{
			return[List_User_PicBook,End_List_User_PicBook,List_New_User_PicBook,End_List_New_User_PicBook,CoreConst.CLOSE_FACE_SHOW,
//				CoreConst.DRAG_FACE_MOVE,Exchg_User_Book,Del_User_Book,yesHandlerDel,WorldConst.VIEW_READY
				LazyLoad.QUEUE_LOAD_START,LazyLoad.QUEUE_LOAD_COMPLETE
			
			];
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite; 
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;
			_txtFiled = vo.data.txtPage as TextField;//页码引用
			this.whichShelf = vo.data.whichShelf as String;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRemove():void{
			super.onRemove();
			_txtFiled = null;
			prepareVO = null;
			vec.length = 0;
			vec = null;
			vec1.length = 0;
			vec1 = null;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}