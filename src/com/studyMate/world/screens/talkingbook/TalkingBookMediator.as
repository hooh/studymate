package com.studyMate.world.screens.talkingbook
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.component.LazyLoad;
	import com.studyMate.world.component.flipPage.FlipPageExtendMediator;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.BookFaceShow2ViewMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.effects.Bubbles1;
	import com.studyMate.world.screens.offPictureBook.OffConfigStatic;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	
	/**
	 * note
	 * 2014-7-11下午3:08:30
	 * Author wt
	 *
	 */	
	
	public class TalkingBookMediator extends ScreenBaseMediator
	{
		private const NAME:String = 'TalkingBookMediator';
		
		public var prepareVO:SwitchScreenVO;
		private var pageTxt:TextField;//中间底部页码元件
		private var vo:SwitchScreenVO;
		private var whichShelf:String;//显示哪一个书架
		
		private var orderId:int = 0;
		private var vec:Vector.<UpdateListItemVO>;//所有绘本
		private var vec1:Vector.<UpdateListItemVO>;//要更新的绘本
		private var totalPage:int;//总页数
		private var currentPage:int = 1;//当前页默认为第一页
		private var pages:Vector.<IFlipPageRenderer>;
		
		public static const BOOKITEM_CLICK:String = NAME+ 'bookClick';
		private const List_User_PicBook:String = NAME+"ListUserPicBook";
		private const End_List_User_PicBook:String = NAME + "EndListUserPicBook";
		private const List_New_User_PicBook:String  = NAME + "ListNewUserPicBook";
		private const End_List_New_User_PicBook:String  = NAME + "EndListNewUserPicBook";
		
		protected var bookVec:Vector.<BookPicture>;
		
		public function TalkingBookMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(CoreConst.MANUAL_LOADING,false);//可见进度
		}
		override public function onRegister():void
		{
			vec = new Vector.<UpdateListItemVO>;
			vec1 = new Vector.<UpdateListItemVO>;
			
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			Starling.current.stage.color = 0xFFFFFF;
			var bg:Image = new Image(Assets.getTexture("talkingBookBg"));
			view.addChild(bg);
			
			
			var pageView:Image = new Image(Assets.talkingbookTexture("ml_page_up"));
			pageView.x = 471;
			pageView.y = 655;
			view.addChild(pageView);
			
			pageTxt = new TextField(130,47,'加载中...','HeiTi',22,0x7f2d00,true);
			pageTxt.autoScale = true;
			pageTxt.x = 576;
			pageTxt.y = 703;
			pageTxt.touchable = false;
			view.addChild(pageTxt);
			
			
			
			picturebookHandler();
		}
		
		
		protected function picturebookHandler():void{
			if(this.whichShelf==null){//个人书架
				whichShelf = "All";
			}			
			
			if(CacheTool.has(NAME,"PicturebookArr")){
				bookVec = CacheTool.getByKey(NAME,"PicturebookArr") as Vector.<BookPicture>;
				this.showBook(bookVec);
			}else{	
				bookVec = new Vector.<BookPicture>;
				sendNotification(CoreConst.TOAST,new ToastVO("正在获取所有绘本基本信息...",2));
				sendinServerInfo(CmdStr.List_User_PicBook,whichShelf,List_User_PicBook);//派发第一步获取所有绘本基本信息
			}	
		}
		
		
		protected function delCache():void{
			OffConfigStatic.dispose();
			
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		override public function handleNotification(notification:INotification):void
		{
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
						bookVec.push(book);												
						orderId++;
						
						var _item:UpdateListItemVO = new UpdateListItemVO("",PackData.app.CmdOStr[4].toString(),"","");
						_item.hasLoaded = true;//检查文件			
						vec.push(_item);
					}else if(result.isEnd){
						CacheTool.put(NAME,"PicturebookArr",bookVec);					
						sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(vec,End_List_User_PicBook,null));//检查本地文件
					}else if(result.isErr){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n绘本信息获取错误,\n您可以通过FAQ反馈工作人员，\n点击确定离开界面。",false,'yesQuitHandler','noHandler',false,null,delCache));//提交订单
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
							this.showBook(bookVec);
						}
					}else if(result.isErr){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n绘本信息获取错误,\n您可以通过FAQ反馈工作人员，\n点击确定离开界面。",false,'yesQuitHandler','noHandler',false,null,delCache));//提交订单
						
					}
					break;
				
				case End_List_New_User_PicBook:
					this.showBook(bookVec);	
					break;
				case BOOKITEM_CLICK:
					var item:BookPicture = notification.getBody() as BookPicture;
					var arr:Array=[];
					for(var i:int=0;i<bookVec.length;i++){
						arr.push(bookVec[i]);
					}	
					var data:Object = new Object();
					data.item = item;//单独一个
					data.bookArr = arr;//全部
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BookFaceShow2ViewMediator,data,SwitchScreenType.SHOW)]);					
					break;
				case WorldConst.UPDATE_FLIP_PAGE_INDEX:
					var new_index:uint = notification.getBody() as uint;
					trace(new_index);
					pageTxt.text = (new_index+1)+"/"+totalPage;
					CacheTool.put(NAME,"PicturebookCurrentPage",new_index+1);
					break;

				
				
			}
		}
		
		
		private var isFirst:Boolean=true;
		protected function showBook(bookVec:Vector.<BookPicture>):void{
			totalPage = Math.ceil(bookVec.length/21);
			if(CacheTool.has(NAME,"PicturebookCurrentPage")){
				currentPage =  (int)(CacheTool.getByKey(NAME,"PicturebookCurrentPage"));
				pageTxt.text = currentPage+"/"+totalPage;
			}else{
				pageTxt.text = 1 + "/"+totalPage;
			}
			var bookClone:Vector.<BookPicture> = bookVec.concat();
			pages = new Vector.<IFlipPageRenderer>(totalPage);
			for(var i:int=0;i<totalPage;i++){
				var vec:Vector.<BookPicture> = new Vector.<BookPicture>();
				for(var j:int=0;j<21;j++){
					if(bookClone.length>0){						
						vec.push(bookClone.shift());
					}else{
						break;
					}
				}
				pages[i] = new TalkBookPage(i,vec,totalPage);
			}
			
			if(isFirst){
				isFirst = false;				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageExtendMediator,{FlipPageData:new FlipPageData(pages),index:currentPage-1},SwitchScreenType.SHOW,view)]);

			}
			
			trace("@VIEW:TalkingBookMediator:");
		}
		
		
		override public function listNotificationInterests():Array
		{
			
			return[
				List_User_PicBook,
				End_List_User_PicBook,
				List_New_User_PicBook,
				End_List_New_User_PicBook,
				BOOKITEM_CLICK,
				WorldConst.UPDATE_FLIP_PAGE_INDEX,		
				CoreConst.CLOSE_FACE_SHOW]
				
				
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
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			if(vo.data){
				this.whichShelf = vo.data.whichShelf as String;
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
	}
}