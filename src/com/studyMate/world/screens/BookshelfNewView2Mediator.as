package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.offPictureBook.OffConfigStatic;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	

	public class BookshelfNewView2Mediator extends ScreenBaseMediator
	{
		public static const NAME:String = "BookshelfNewView2Mediator";
		
		public static var canClearBoo:Boolean=true;
		public var prepareVO:SwitchScreenVO;
		private var page:Sprite;//中间底部页码元件
		private var vo:SwitchScreenVO;
		private var whichShelf:String;//显示哪一个书架
		public var txtFiled:TextField;
		
		public function BookshelfNewView2Mediator(viewComponent:Object=null){			
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			Starling.current.stage.color = 0xFFFFFF;
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			view.stage.focus  = view;
			
			var BG:Class = AssetTool.getCurrentLibClass("ml_background");//书架的背景
			view.addChild(new BG);
			
			/*var mlCloseClass:Class = AssetTool.getCurrentLibClass("ml_close_up");//右上角退出图片
			var mlCloseDownClass:Class = AssetTool.getCurrentLibClass("ml_close_down");
			
			var mlCloseSp:Sprite = new mlCloseClass();
			var mlCloseDownSp:Sprite = new mlCloseDownClass();*/			
			
			var mlPageClass:Class = AssetTool.getCurrentLibClass("ml_page_up");//中间底部书架页码
			page = new mlPageClass();
			page.x = 471;
			page.y = 655;
			page.mouseChildren =false;
			page.mouseEnabled = false;
			txtFiled = (page.getChildByName("page") as TextField)
			txtFiled.text = "1/1";
			view.addChild(page);//添加中间底部书架页码										  
			
			picturebookHandler();
						
//			view.stage.addEventListener(KeyboardEvent.KEY_DOWN,viewKeyDownHandler);
		}
		
		protected function viewKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
//				event.preventDefault();	
//				event.stopImmediatePropagation();
				delCache();
				
				view.stage.removeEventListener(KeyboardEvent.KEY_DOWN,viewKeyDownHandler);
				/*if(Global.isLoading){
					sendNotification(CoreConst.CANCEL_DOWNLOAD);
				}else{
					sendNotification(WorldConst.POP_SCREEN);
				}*/
			}
		}		
		
		override public function handleNotification(notification:INotification):void
		{
//			switch(notification.getName()){
//				case CoreConst.DOWNLOAD_CANCELED:	
//					if(facade.hasMediator(BookFaceShow2ViewMediator.NAME)){
//						view.stage.addEventListener(KeyboardEvent.KEY_DOWN,viewKeyDownHandler);
//					}else{						
//						sendNotification(WorldConst.POP_SCREEN);						
//					}
//					break;
//			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.DOWNLOAD_CANCELED];
		}
		
		
		protected function picturebookHandler():void{
			var object:Object = {};
			object.txtPage = txtFiled;
			if(this.whichShelf!=null){//个人书架
				object.whichShelf = this.whichShelf;
			}else{//集体书架
				object.whichShelf = "All";
			}

			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ScrollShelfPicturebook2Mediator,object,SwitchScreenType.SHOW,view)]);
		}



		
		protected function delCache():void{
			OffConfigStatic.dispose();
			if(CacheTool.has(NAME,"FlagShelf")){
				CacheTool.clr(NAME,"FlagShelf");
			}		
			if(CacheTool.has(ScrollShelfPicturebook2Mediator.NAME,"PicturebookCurrentPage")){
				CacheTool.clr(ScrollShelfPicturebook2Mediator.NAME,"PicturebookCurrentPage");
			}
			if(CacheTool.has(ScrollShelfPicturebook2Mediator.NAME,"PicturebookArr")){
				(CacheTool.getByKey(ScrollShelfPicturebook2Mediator.NAME,"PicturebookArr") as Array).length = 0;
				CacheTool.clr(ScrollShelfPicturebook2Mediator.NAME,"PicturebookArr");
			}			
			if(CacheTool.has(ScrollShelfPicturebook2Mediator.NAME,"PointAll")) {
				CacheTool.clr(ScrollShelfPicturebook2Mediator.NAME,"PointAll");
			}
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRemove():void{
//			view.stage.removeEventListener(KeyboardEvent.KEY_DOWN,viewKeyDownHandler);
			prepareVO = null;
			txtFiled = null;
			Global.stage.frameRate = 60;
			//delCache();
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(CoreConst.MANUAL_LOADING,false);//可见进度
			
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			if(vo.data){
				this.whichShelf = vo.data.whichShelf as String;
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}