package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.ui.music.AddTypeInputMediator;
	import com.studyMate.world.screens.ui.music.AlertMusicTypeMediator;
	import com.studyMate.world.screens.ui.music.ExchangeItemRenderer;
	import com.studyMate.world.screens.ui.music.ExchangeItemVO;
	import com.studyMate.world.screens.ui.music.MusicClassify;
	import com.studyMate.world.screens.ui.music.MusicTypeSp;
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	

	public class ExchangeMusicMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "ExchangeMusicMediator";
		
		public static var isEdit:Boolean;
		private const defaultStr:String = "默认分类";
		private var vo:SwitchScreenVO;
		public static const EXCHANGE_CHANGE_SUCCEED:String = NAME + "EXCHANGE_CHANGE_SUCCEED";
		private const CLASSIFY:String = NAME+"classify";//取得所有分类
		private const GET_MUSIC_LIST:String = NAME+"MUSIC_LIST";
		private const DEL_TYPE_SUCCEED:String = NAME + "DEL_TYPE_SUCCEED";
	
		private var marketList:List;//列表组件
		private var editBtn:Button;
		private var editCompleteBtn:Button;
		private var allListCollection:ListCollection = new ListCollection;
		
		private var typeScroll:ScrollContainer;		
		private var defaultTypeSp:MusicTypeSp;
		private var addTypeSp:MusicTypeSp;
			
		private var typeTxt:TextField;
		private var sorryTxt:TextField;
		private var currentTitle:String = "";
		private var currentGrid:String = "";
		private var currentType:MusicTypeSp;
		public var classifyArr:Vector.<MusicClassify> = new Vector.<MusicClassify>;
		
		public function ExchangeMusicMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);			
		}
		override public function onRegister():void{	
			var bg:Image = new Image(Assets.getTexture("exchangeMusicBg"));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);
			
			defaultTypeSp = new MusicTypeSp([,"0",,defaultStr]);
			addTypeSp = new MusicTypeSp(null);
			
			var layout0:VerticalLayout = new VerticalLayout();
			layout0.gap = 30;		
			typeScroll = new ScrollContainer();
			typeScroll.x = 1048;
			typeScroll.y = 50;
			typeScroll.width = 240;
			typeScroll.height = 680;
			typeScroll.layout = layout0;
			typeScroll.snapScrollPositionsToPixels = true;			
			view.addChild(typeScroll);
			
			typeScroll.addChild(defaultTypeSp);
			typeScroll.addChild(addTypeSp);
												
			typeTxt = new TextField(366,38,"","HeiTi",32,0xFFFFFF,true);
			typeTxt.y = 34;
			typeTxt.width = 384;
			typeTxt.height = 56;
			typeTxt.filter = BlurFilter.createGlow(0x0A4475,1,0.7,0.8);
			typeTxt.touchable = false;
			view.addChild(typeTxt);
												
			editBtn = new Button(Assets.getMusicSeriesTexture("editBtn"));
			editBtn.x = 920;
			editBtn.y = 0;
			view.addChild(editBtn);
			editBtn.addEventListener(Event.TRIGGERED,editTOUCHHandler);
			
			editCompleteBtn = new Button(Assets.getMusicSeriesTexture("editCompleteBtn"));
			editCompleteBtn.x = 920;
			editCompleteBtn.y = 0;
			editCompleteBtn.visible = false;
			view.addChild(editCompleteBtn);
			editCompleteBtn.addEventListener(Event.TRIGGERED,editCompleteTOUCHHandler);
			
			sendinServerInofFunc(CmdStr.GET_ALL_CLASSIFY,CLASSIFY,[ PackData.app.head.dwOperID.toString(),"MUSIC","*"]);//第一步取得所有分类							
		}	
		
		private function initList():void{
			marketList = new List();
			marketList.x = 44;
			marketList.y = 116;
			marketList.width = 856;
			marketList.height = 580;
			marketList.itemRendererType = ExchangeItemRenderer;
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 52;	
			layout.paddingBottom =100;
			layout.paddingBottom =100;
			marketList.layout = layout;
			view.addChild( marketList );
		}
		
		private function editCompleteTOUCHHandler():void
		{		
			editBtn.visible = true;
			editCompleteBtn.visible = false;
			isEdit = false;
			
			var changeVec:Vector.<ExchangeItemVO> = new Vector.<ExchangeItemVO>;
			//检索
			if(allListCollection){
				for(var i:int=0;i<allListCollection.length;i++){
					var exchangeVO:ExchangeItemVO = allListCollection.getItemAt(i) as ExchangeItemVO;
					if(exchangeVO.isSelected){
						changeVec.push(exchangeVO);
					}
				}
			}
			//数据处理
			if(changeVec.length>0){
				/*for(i=0;i<changeVec.length;i++){
					trace(changeVec[i].Name)
				}*/
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AlertMusicTypeMediator,changeVec,SwitchScreenType.SHOW)]);
			}
			
			//复位
			if(allListCollection){
				for(i=0;i<allListCollection.length;i++){
					(allListCollection.getItemAt(i) as ExchangeItemVO).isSelected = false;
					allListCollection.updateItemAt(i);
				}
			}
		}
		
		private function editTOUCHHandler():void
		{
			editBtn.visible = false;
			editCompleteBtn.visible = true;
			isEdit = true;
			if(allListCollection){
				for(var i:int=0;i<allListCollection.length;i++){
					allListCollection.updateItemAt(i);
				}
			}
		}		
		
		override public function onRemove():void{	
			isEdit = false;
			currentType = null;
			defaultTypeSp = null;
			addTypeSp = null;			
			classifyArr.length = 0;
			classifyArr = null;
			allListCollection = null;
			typeScroll.removeChildren(0,-1,true);
			super.onRemove();
		}
			
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case CLASSIFY:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var typeSp:MusicTypeSp = new MusicTypeSp(PackData.app.CmdOStr);
						typeScroll.addChild(typeSp);
						var musicClassify:MusicClassify = new MusicClassify();						
						musicClassify.grid = PackData.app.CmdOStr[1];
						musicClassify.className = PackData.app.CmdOStr[3];						
						classifyArr.push(musicClassify);					
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){//接收完成
						musicClassify = new MusicClassify();
						musicClassify.grid = "0";
						musicClassify.className = defaultStr;						
						classifyArr.push(musicClassify);	
						typeTxt.text = defaultStr;
						currentTitle = defaultStr;
						currentGrid = "0";

						if(typeScroll.contains(addTypeSp)){							
							typeScroll.removeChild(addTypeSp);
						}						
						if(typeScroll.numChildren<18){
							addTypeSp = new MusicTypeSp(null);
							typeScroll.addChild(addTypeSp);							
						}
						sendinServerInofFunc(CmdStr.GET_MUSIC_INFO,GET_MUSIC_LIST,[PackData.app.head.dwOperID.toString(),"MUSIC","*","0"]);//第二部获取未分类的歌曲
					}
					break;
				case EXCHANGE_CHANGE_SUCCEED:
					var vec:Vector.<ExchangeItemVO> = notification.getBody() as Vector.<ExchangeItemVO>;
					for(var m:int=0;m<vec.length;m++){
						allListCollection.removeItem(vec[m]);
						
					}
					sendNotification(CoreConst.TOAST,new ToastVO('歌曲成功分类！'));
					break;
				case GET_MUSIC_LIST://当前分类列表
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var changeItem:ExchangeItemVO = new ExchangeItemVO(PackData.app.CmdOStr);
						changeItem.grid = currentGrid;
						allListCollection.push(changeItem);
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){//接收完成
						if(allListCollection.length==0){
							if(sorryTxt==null){
								sorryTxt = new TextField(850,60,"当前分类中没有找到相应的歌曲。","HeiTi",26,0xFFFFFF);
								sorryTxt.x = 20;
								sorryTxt.y = 200;
								view.addChild(sorryTxt);
								
							}
						}else{
							if(sorryTxt){
								sorryTxt.removeFromParent(true);
								sorryTxt = null;
							}
							if(marketList){
								marketList.stopScrolling();
								marketList.removeFromParent(true);
							}
							initList();
							marketList.dataProvider = allListCollection;
						}
						sendNotification(WorldConst.VIEW_READY);
					}
					break;
				case MusicTypeSp.GET_MUSIC_TYPE://获取当前分类列表
					var data:Object = notification.getBody();
					typeTxt.text = data.title;
					if(currentTitle != data.title){
						currentTitle = data.title;
						currentGrid = data.grgid;
						allListCollection.removeAll();
						sendinServerInofFunc(CmdStr.GET_MUSIC_INFO,GET_MUSIC_LIST,[PackData.app.head.dwOperID.toString(),"MUSIC","*",data.grgid]);	
					}
					break;
				case MusicTypeSp.DEL_MUSIC_TYPE://删除分类列表
					currentType = notification.getBody() as MusicTypeSp;
					sendinServerInofFunc(CmdStr.DEL_MARK_TYPE,DEL_TYPE_SUCCEED,[currentType.grgid ]);//第一步取得所有分类	
					break;
				case DEL_TYPE_SUCCEED:
					if((PackData.app.CmdOStr[0] as String)=="000"){	//trace("删除成功");
						for(var i:int=0;i<classifyArr.length;i++){
							if(classifyArr[i].grid == currentType.grgid){
								classifyArr.splice(i,1);
								break;
							}
						}
						if(currentType.title==typeTxt.text){		//如果删的刚好是当前列表，则需要刷新。
							typeTxt.text = defaultStr;
							allListCollection.removeAll();
							sendinServerInofFunc(CmdStr.GET_MUSIC_INFO,GET_MUSIC_LIST,[PackData.app.head.dwOperID.toString(),"MUSIC","*","0"]);//第二部获取未分类的歌曲
						}
						typeScroll.removeChild(currentType);
						currentType = null;
					}
					break;
				
				case AddTypeInputMediator.ADD_TYPE_SECCEED://添加分类
					var arr:Array = notification.getBody() as Array;
					musicClassify = new MusicClassify();						
					musicClassify.grid = arr[1];
					musicClassify.className = arr[3];						
					classifyArr.push(musicClassify);	
					
					typeSp = new MusicTypeSp(arr);
					typeScroll.addChild(typeSp);
					if(typeScroll.contains(addTypeSp)){							
						typeScroll.removeChild(addTypeSp);
					}						
					if(typeScroll.numChildren<18){
						addTypeSp = new MusicTypeSp(null);
						typeScroll.addChild(addTypeSp);							
					}
					break;
				
				
			}
		}
		override public function listNotificationInterests():Array{
			return [EXCHANGE_CHANGE_SUCCEED,GET_MUSIC_LIST,CLASSIFY,MusicTypeSp.GET_MUSIC_TYPE,AddTypeInputMediator.ADD_TYPE_SECCEED,MusicTypeSp.DEL_MUSIC_TYPE,DEL_TYPE_SUCCEED];
		}
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		
		private function sendinServerInofFunc(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+1] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+1;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
		}
	}
}