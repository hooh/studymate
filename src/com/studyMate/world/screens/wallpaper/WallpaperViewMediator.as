package com.studyMate.world.screens.wallpaper
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.component.DotNavigationSp;
	import com.studyMate.world.component.LazyLoad;
	import com.studyMate.world.events.ItemLoadEvent;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import mycomponent.DrawBitmap;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	

	public class WallpaperViewMediator extends ScreenBaseMediator
	{
		private const NAME:String = "WallpaperViewMediator";
		
		private const QRYWALLPAPER:String = "QryWallpaper";
		private const loadPictureCompelet:String = "LoadPicture";
		private const PREVIEWLOADINGCOM:String = "PreviewLoadingCom";
		private const USELOADINGCOM:String = "UseLoadingCom";
		
		public static const PICTUREITEM:String = "PictureItem";
		public static const USEWALLPAPER:String = "UseWallpaper";
		private const yesDelHandler:String = NAME+"yesDelHandler";
		private const BUYWALLPAPER:String = "BuyWallpaper";

		
		private var index:int = 0;
		private var num:Number = 0;

		
		private var selectWallpaper:WallpaperData;
		private var selectWallpaperSp:WallpaperSp;
		private var upVec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
		private var upPathArr:Array = new Array();
		private var lazyload:LazyLoad;
		
		private const row:int = 4;//行
		private const col:int = 3;//列		
		private const leftSpace:int =0;//左边距
		private const topSpace:int =0;//上边距
		private const rowgap:int =250;//行间隔
		private const colgap:int = 230;//列间隔
		
		private var btnContainer:ScrollContainer;
		private var dotSp:DotNavigationSp;
		private var tempPage:int = 0;

		
		private var preViewBtn:Button;
		private var useBtn:Button;
		
		private var filter:ColorMatrixFilter;
		
		private var prepareVo:SwitchScreenVO;

		private var wallpaperVec:Vector.<WallpaperData> = new Vector.<WallpaperData>();
		
		public function WallpaperViewMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent)
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVo = vo
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return WallpaperView
		}
		
		public function get view():WallpaperView
		{
			return getViewComponent() as WallpaperView
		}
		
		override public function onRegister():void
		{
			var bg:Image = new Image(Assets.getTexture("wallpaperBackground"));
			bg.blendMode = BlendMode.NONE;
			view.addChild(bg);
			

			
			var matrix:Vector.<Number>= Vector.<Number>([0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0,      0,      0,      1, 0]);  			
			filter = new ColorMatrixFilter(matrix);
			
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paddingTop = 10;
			layout.paddingLeft = 10;
			layout.horizontalGap = 40;
			layout.verticalGap = 15;
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.manageVisibility = true;
			
			btnContainer = new ScrollContainer();		
			btnContainer.snapToPages = true;	
			btnContainer.x = 20
			btnContainer.width = 1240;
			btnContainer.height = 800;
			btnContainer.layout = layout;
			btnContainer.addEventListener(FeathersEventType.SCROLL_START ,startScrollHandler);
			btnContainer.addEventListener(FeathersEventType.CREATION_COMPLETE,creatCompleteHandler);
			btnContainer.addEventListener(FeathersEventType.SCROLL_COMPLETE,completeScrollHandler);
			view.addChild(btnContainer);
			
			preViewBtn = new Button(Assets.getWallpaperAtlasTexture("previewBtn"));
			preViewBtn.x = 850;
			preViewBtn.y = 580;
			preViewBtn.filter = filter;
			preViewBtn.touchable = false;
			view.addChild(preViewBtn);
			preViewBtn.addEventListener(starling.events.Event.TRIGGERED,previewHandler);
	
			useBtn = new Button(Assets.getWallpaperAtlasTexture("useBtn"));
			useBtn.x = 1050;
			useBtn.y = 580;
			useBtn.filter = filter;
			useBtn.touchable = false;
			view.addChild(useBtn);
			useBtn.addEventListener(starling.events.Event.TRIGGERED,useWallpaperHandler);
			getWallpaperList();
		}
		
		private function completeScrollHandler():void
		{
			dotSp.pageIndex = btnContainer.horizontalPageIndex;
		}
		
		private function useWallpaperHandler():void
		{
			if(selectWallpaper!= null){
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.ALERT_SHOW,new AlertVo("你确定要花100金币换一张壁纸吗？",true,yesDelHandler));
			}
		}
		
		
		private function previewHandler():void
		{
			var _localPath:String = Global.localPath +"/wallpaper/"+selectWallpaper.filePath;
			var _file:File = Global.document.resolvePath(_localPath);
			if(!_file.exists){
				var _path:String = "/home/cpyf/BOOK/wallpaper/"+selectWallpaper.filePath;
				var downVO:RemoteFileLoadVO = new RemoteFileLoadVO(_path,_localPath,PREVIEWLOADINGCOM);
				downVO.downType = RemoteFileLoadVO.USER_FILE;
				sendNotification(CoreConst.REMOTE_FILE_LOAD,downVO);
			}else{
				previewPicture();
			}
		}
		
		
		private function creatCompleteHandler():void
		{
			btnContainer.horizontalScrollBarFactory = null;
			dotSp = new DotNavigationSp();
			if(wallpaperVec.length> 0)
			{
				dotSp.pageTotal = Math.ceil(Number(wallpaperVec[0].total)/8); 
				dotSp.x = (Global.stageWidth-30*Math.ceil(Number(wallpaperVec[0].total)/8))>>1;
			}
			dotSp.y = Global.stageHeight - 80;
			view.addChildAt(dotSp,1);
		}
		
		private function startScrollHandler():void
		{
			if(tempPage<btnContainer.horizontalPageIndex&&wallpaperVec.length<Number(wallpaperVec[0].total))
			{
				tempPage = btnContainer.horizontalPageIndex;
				upPathArr.length = 0;
				upVec.length = 0;
				getWallpaperList();
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return[QRYWALLPAPER,loadPictureCompelet,PICTUREITEM,PREVIEWLOADINGCOM,WorldConst.HIDE_SETTING_SCREEN,
				   USELOADINGCOM,USEWALLPAPER,yesDelHandler,BUYWALLPAPER];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case QRYWALLPAPER:
				{
					if(!_result.isErr)
					{
						if(!_result.isEnd)
						{
							var _wallPaperData:WallpaperData = new WallpaperData();
							_wallPaperData.wallpaperID = PackData.app.CmdOStr[1].toString();
							_wallPaperData.price = PackData.app.CmdOStr[2].toString();
							_wallPaperData.position = PackData.app.CmdOStr[3].toString();
							_wallPaperData.filePath = PackData.app.CmdOStr[4].toString();
							_wallPaperData.time  = PackData.app.CmdOStr[5].toString();
							_wallPaperData.total = PackData.app.CmdOStr[6].toString();	
							wallpaperVec.push(_wallPaperData);
							upPathArr.push(("wallpaper/s_"+_wallPaperData.filePath));
							var _item:UpdateListItemVO = new UpdateListItemVO("","wallpaper/s_"+PackData.app.CmdOStr[4].toString(),"","");
							_item.hasLoaded = true;	
							upVec.push(_item);	
						}else{
							if(wallpaperVec.length>0){
								if(dotSp !=null){
									dotSp.pageTotal = Math.ceil(Number(wallpaperVec[0].total)/8); 
									dotSp.x = (Global.stageWidth-30*Math.ceil(Number(wallpaperVec[0].total)/8))>>1;
								}
								sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(upVec,loadPictureCompelet,null));
							}else{
								sendNotification(CoreConst.TOAST,new ToastVO("壁纸还没上架，尽情期待哦~^_^"));
							}
						}
					}
					break;
				}
				case loadPictureCompelet:
				{
					loadAllWallpaper(upPathArr);
					break;
				}
				case PICTUREITEM:
				{
					selectWallpaper = notification.getBody() as WallpaperData;
					break;
				}
				case PREVIEWLOADINGCOM:
				{
					previewPicture();
					break;
				}
				case USELOADINGCOM:
				{
					break;
				}
				case yesDelHandler:
				{
					buyWallpaper();
					break;
				}
				case BUYWALLPAPER:
				{
					if(!_result.isErr)
					{
						if(PackData.app.CmdOStr[0] == "000")
						{
							var _localPath:String = Global.localPath +"/appman/"+"bk_pic.jpg";
							var _file:File = Global.document.resolvePath(_localPath);
							var _file1:File = Global.document.resolvePath(Global.localPath+"/wallpaper/"+selectWallpaper.filePath);
							if(!_file1.exists){
								var _path:String = "/home/cpyf/BOOK/wallpaper/"+selectWallpaper.filePath;
								var downVO:RemoteFileLoadVO = new RemoteFileLoadVO(_path,_localPath,USELOADINGCOM);
								downVO.downType = RemoteFileLoadVO.USER_FILE;
								sendNotification(CoreConst.REMOTE_FILE_LOAD,downVO);	
							}else{
								var destination:File = File.documentsDirectory;
								destination = destination.resolvePath(_localPath);
								_file1.copyTo(destination,true);
							}
							sendNotification(CoreConst.TOAST,new ToastVO("壁纸设置成功~"));
						}
					}
				}
			}
		}
		
		private function buyWallpaper():void
		{
			PackData.app.CmdIStr[0] = CmdStr.BUYWALLPAPER;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID;
			PackData.app.CmdIStr[2] = selectWallpaper.wallpaperID;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(BUYWALLPAPER));
		}
		
		private function previewPicture():void
		{
			var loader:Loader = new Loader();
			var _localPath:String = Global.document.resolvePath(Global.localPath +"wallpaper/"+selectWallpaper.filePath).url
			loader.load(new URLRequest(_localPath));
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,completeHandler);
		}
		
		protected function completeHandler(event:flash.events.Event):void
		{
			var localImg:Bitmap = new Bitmap();
			localImg = event.target.content;
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PreviewWallpaperViewMediator,localImg,SwitchScreenType.SHOW,view,0,0)]);
		}
		
		
		private function loadAllWallpaper(upPathArr:Array):void
		{
			lazyload = new LazyLoad(upPathArr);
			index = 0;
			lazyload.addEventListener(ItemLoadEvent.ITEM_LOAD_COMPLETE,loadCompleteHandler);
		}		
		
		protected function loadCompleteHandler(event:ItemLoadEvent):void
		{
			var bitmap:Bitmap = new DrawBitmap(event.Item,256,160);
			var _wallpaperSp:WallpaperSp = new WallpaperSp(bitmap,wallpaperVec[num]);
			_wallpaperSp.x = ((int)(index%row))*rowgap + leftSpace;
			_wallpaperSp.y = ((int)(index/row))%col*colgap + topSpace;
			btnContainer.addChild(_wallpaperSp);
			_wallpaperSp.addEventListener(TouchEvent.TOUCH,selectPictureHandler);
			index++;
			num++;
		}
		
		
		private var startX:Number;
		private function selectPictureHandler(event:TouchEvent):void
		{
			if(event.touches[0].phase  == TouchPhase.BEGAN)
			{
				startX = event.touches[0].globalX;
			}else if(event.touches[0].phase == TouchPhase.ENDED)
			{
				if(Math.abs(startX-event.touches[0].globalX) < 15)
				{
					if(selectWallpaperSp!=null){
						selectWallpaperSp.hideSelectBackground();
					}
					(event.currentTarget as WallpaperSp).selectBackgroud();
					selectWallpaperSp = event.currentTarget as WallpaperSp;
					preViewBtn.filter = null;
					preViewBtn.touchable = true;
					useBtn.filter = null;
					useBtn.touchable = true;
				}
			}
		}
		
		private function getWallpaperList():void
		{
			if(!Global.isLoading)
			{
				PackData.app.CmdIStr[0] = CmdStr.QRYWALLPAPER;
				PackData.app.CmdIStr[1] = "Y";
				PackData.app.CmdIStr[2] = btnContainer.horizontalPageIndex*16;
				PackData.app.CmdIStr[3] = 16;
				PackData.app.CmdInCnt = 4;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRYWALLPAPER));
			}
		}
		
	
	}
}