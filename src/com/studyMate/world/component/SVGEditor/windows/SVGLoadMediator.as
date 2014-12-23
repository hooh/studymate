package com.studyMate.world.component.SVGEditor.windows
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.data.LoadSVGVO;
	import com.studyMate.world.component.SVGEditor.myTagList.ListCellRender;
	import com.studyMate.world.component.SVGEditor.utils.SVGUtils;
	import com.studyMate.world.component.SVGEditor.utils.ToolType;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import fl.controls.Button;
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * 导入svg面板。也可以新建
	 * @author wt
	 * 
	 */	
	
	public class SVGLoadMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SVGLoadMediator";
		
		private const LOAD_SVG_COMPLETE:String = NAME+ "LOAD_SVG_COMPLETE";
		private const GET_SVG_LIST:String = NAME + "GET_SVG_LIST";
		
		private var continueLoadSVG:Boolean;
		
		private var itemid:String;
		private var creatNewBtn:Button;
		private var quitBtn:Button;
		private var list:List;
		private var dp:DataProvider = new DataProvider;
		private var pareVO:SwitchScreenVO;
		
		public function SVGLoadMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void
		{
			dp = null;
			view.removeChildren();
			super.onRemove();
		}
		override public function onRegister():void
		{			
			view.graphics.clear();
			view.graphics.beginFill(0x0099FF);
			view.graphics.drawRect(0,0,Global.stageWidth,Global.stageHeight);
			view.graphics.endFill();
			
			
			creatNewBtn = new Button();
			creatNewBtn.x = 500;
			creatNewBtn.label = "创建新文档";
			creatNewBtn.addEventListener(MouseEvent.CLICK,creaNewHandler);
			view.addChild(creatNewBtn);
			
			
			quitBtn = new Button();
			quitBtn.x = 1000;
			quitBtn.label = "×";
			quitBtn.addEventListener(MouseEvent.CLICK,quitHandler);
			view.addChild(quitBtn);
			
			
			list = new List();	
			list.rowHeight = 45;
			list.setStyle("cellRenderer", ListCellRender);
			list.x = 20;
			list.y = 30;
			list.setSize(1200,700);
			list.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
			view.addChild(list);
			SVGUtils.sendinServerInofFunc(CmdStr.QRY_WRONGTITLE,GET_SVG_LIST,['*','*','*','*','*','*','00000000','YYYYMMDD','*']);
		}
		
		protected function quitHandler(event:MouseEvent=null):void
		{
			pareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}
		
		//新建
		protected function creaNewHandler(event:MouseEvent):void
		{
			sendNotification(SVGConst.CLEAR_ALL_ELEMENT);
			
			var loadVO:LoadSVGVO = new LoadSVGVO();
			loadVO.copcode = PackData.app.head.dwOperID.toString();
			loadVO.mopcode = PackData.app.head.dwOperID.toString(); 
			sendNotification(SVGConst.LOAD_SVG_INFO,loadVO);
			
			quitHandler();
		}
		
		protected function itemClickHandler(event:ListEvent):void
		{
			itemid = event.item.data;
			continueLoadSVG = true;
			sendNotification(SVGConst.CLEAR_ALL_ELEMENT);
			var file:File =Global.document.resolvePath(Global.localPath + "book/SVG_TEST.swf");
			if(file.exists){
				sendNotification(SVGConst.LOAD_SWF,file.url);//导入swf文件
			}else{
				sendNotification(SVGConst.LOAD_SWF_COMPLETE);
			}
			
		}				
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){								
				case GET_SVG_LIST:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var svgTitleVO:LoadSVGVO = new LoadSVGVO(PackData.app.CmdOStr); 
						dp.addItem({svgTitleVO:svgTitleVO,data:PackData.app.CmdOStr[1]});
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						list.dataProvider = dp;
					}
					break;
				case SVGConst.LOAD_SWF_COMPLETE://swf加载完成后，查找svg文本
					if(continueLoadSVG){
						continueLoadSVG = false;
						var index:Vector.<int> = new Vector.<int>;
						index.push(12);					
						SVGUtils.sendinServerInofFunc(CmdStr.SELECT_WRONGTITLE,LOAD_SVG_COMPLETE,[itemid],index);
					}
					break;
				case LOAD_SVG_COMPLETE://查找svg
					if((PackData.app.CmdOStr[0] as String) == "000"){
						var loadVO:LoadSVGVO = new LoadSVGVO(PackData.app.CmdOStr);
						sendNotification(SVGConst.LOAD_SVG_INFO,loadVO);
						var byteArr:ByteArray = PackData.app.CmdOStr[12];
						if(byteArr){							
							byteArr.uncompress();
							SVGConst.svgXML = XML(byteArr.readObject());
//							trace("recive svgXML : "+SVGConst.svgXML.toXMLString());
							SVGConst.currentTool = ToolType.SELECT_HAND;//选择工具
						}
						sendNotification(SVGConst.UPDATE_SVG_DOCUMENT);						
						quitHandler();
					}																
					break;

			}
		}
		override public function listNotificationInterests():Array{
			return [GET_SVG_LIST,LOAD_SVG_COMPLETE,SVGConst.LOAD_SWF_COMPLETE];
		}
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}