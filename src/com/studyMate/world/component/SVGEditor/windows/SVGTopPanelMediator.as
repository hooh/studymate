package com.studyMate.world.component.SVGEditor.windows
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.data.LoadSVGVO;
	import com.studyMate.world.component.SVGEditor.utils.SVGUtils;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import mx.utils.StringUtil;
	
	import fl.controls.ComboBox;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * 顶部面板，包含导入按钮和保存信息
	 * @author wt
	 * 
	 */	
	
	public class SVGTopPanelMediator extends SVGBasePannelMediator
	{
		public static const NAME:String = "SVGTopPanelMediator";
		
		private const SAVE_SVG_COMPLETE:String = NAME+"SAVE_SVG";
		
		private var loadSVGInfo:LoadSVGVO;
		
		private var mainSp:Sprite;
		private var percentCombobox:ComboBox;
		private var moveBtn:SimpleButton;
		private var resetBtn:SimpleButton;
		
		private var subject:ComboBox;
		private var srcdesc:TextField;
		private var state:TextField;
		
		private var loadBtn:SimpleButton;
		
		public function SVGTopPanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function onRemove():void
		{
			view.removeChildren();
			super.onRemove();
		}		
		override public function onRegister():void
		{
			
			var pageClass:Class = AssetTool.getCurrentLibClass("SVGTopPanel");
			mainSp = new pageClass;
			view.addChild(mainSp);
			
			loadBtn = mainSp.getChildByName("loadBtn") as SimpleButton;
			loadBtn.addEventListener(MouseEvent.CLICK,loadHandler);
			
			subject = mainSp.getChildByName("subject") as ComboBox;
			
			var tf:TextFormat = new TextFormat("HeiTi",15,0);
			srcdesc = mainSp.getChildByName("srcdescTxt") as TextField;
			srcdesc.embedFonts = true;
			srcdesc.defaultTextFormat = tf;
			srcdesc.border = true;
			
			state = mainSp.getChildByName("state") as TextField;
			state.embedFonts = true;
			state.defaultTextFormat = tf;
			
			percentCombobox = mainSp.getChildByName("percentCombobox") as ComboBox;
			percentCombobox.addEventListener(Event.CHANGE, scaleSelectHandler);
			
			
			moveBtn = mainSp.getChildByName("moveBtn") as SimpleButton;
			resetBtn = mainSp.getChildByName("resetBtn") as SimpleButton;
			moveBtn.addEventListener(MouseEvent.CLICK,moveBtnHandler);
			resetBtn.addEventListener(MouseEvent.CLICK,resetBtnHandler);
			
			
			super.onRegister();
		}
		
		protected function resetBtnHandler(event:MouseEvent):void
		{
			percentCombobox.selectedIndex = 0;
			sendNotification(SVGConst.RESET_COORD);
		}
		
		protected function moveBtnHandler(event:MouseEvent):void
		{
			sendNotification(SVGConst.SHOW_MOVE_VIEW);
		}
		
		protected function scaleSelectHandler(event:Event):void
		{
//			trace(percentCombobox.selectedItem.data);
			
			sendNotification(SVGConst.ZOOM_STAGE,percentCombobox.selectedItem.data);
		}
		
		protected function loadHandler(event:MouseEvent):void
		{
			sendNotification(SVGConst.LOAD__SVG_DOCUMENT);
		}	
		
		protected function saveHandler():void
		{			
			var byteArr:ByteArray = new ByteArray();
			byteArr.writeObject(SVGConst.svgXML)
			byteArr.compress();	

			if(loadSVGInfo == null){
				loadSVGInfo = new LoadSVGVO();
				loadSVGInfo.copcode =loadSVGInfo.mopcode = PackData.app.head.dwOperID.toString();
			}else{
				loadSVGInfo.wrongid = state.text;
			}
			
			
			SVGUtils.sendinServerInofFunc(CmdStr.INSERT_WRONGTITLE,SAVE_SVG_COMPLETE,
																					[loadSVGInfo.wrongid,
																					'',
																					subject.selectedItem.data,
																					StringUtil.trim(srcdesc.text),
																					loadSVGInfo.copcode,
																					PackData.app.head.dwOperID.toString(),
																					"小升初",
																					"status",
																					"type",
																					"答案",
																					byteArr]);						
		}
	
		override protected function svg_handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case SVGConst.LOAD_SVG_INFO:
					loadSVGInfo = notification.getBody() as LoadSVGVO;
					srcdesc.text = loadSVGInfo.srcdesc;
					state.text = loadSVGInfo.wrongid;//id号
					switch(loadSVGInfo.subject){
						case 'yy':
							subject.selectedIndex = 0;
							break;
						case 'sx':
							subject.selectedIndex = 1;
							break;
					}
					break;
				case SVGConst.SAVE_SVG_DOCUMENT://
					sendNotification(SVGConst.REMOVE_REPARE_CREAT_NEW);//取消编辑状态
					
					saveHandler();
					break;
				case SAVE_SVG_COMPLETE:
					if((PackData.app.CmdOStr[0] as String) == "000"){
						state.text = PackData.app.CmdOStr[1];//错题标识；全局唯一标识
						sendNotification(CoreConst.TOAST,new ToastVO(PackData.app.CmdOStr[2]));
//						sendNotification(SVGConst.CLEAR_ALL_ELEMENT);
					}
					break;
			}
			
		}
		override protected function svg_listNotificationInterests():Array{
			return [SVGConst.LOAD_SVG_INFO,
					SAVE_SVG_COMPLETE	,
					SVGConst.SAVE_SVG_DOCUMENT] ;
		}
	}
}