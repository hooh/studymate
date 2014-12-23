package com.studyMate.view
{
	import com.mylib.api.IFileLoadProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.FileVO;
	import com.studyMate.model.vo.LocalFilesLoadCommandVO;
	import com.studyMate.model.vo.ScriptExecuseVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.LayoutToolUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.script.TypeTool;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getDefinitionByName;
	
	import fl.controls.Button;
	
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public final class ExecuteScriptViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ExecuteScriptViewMediator";
		public static const TXT_LOAD_COMPLETE:String = NAME+"fileComplete";
		public static const SWF_LOAD_COMPLETE:String = NAME+"SWFLoadComplete";
		private static var isCreateFile:Boolean = false;
		private static var sendOnce:Boolean = false;
		private static var totalPage:int = 0;
		
		private var myVO:SwitchScreenVO;
		private var currentIndex:int=1;
		
		private var input:TextField;
		private var holder:Sprite;
		
		public function ExecuteScriptViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			myVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,myVO);
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.HIDE_MAIN_MENU);
		}
		
		
		 private function startLoad():void{
			
			 //以下两句将目录指向程序安装目录，注释掉后指向我的文档里的edu目录
			 Global.localPath="";
			 Global.document = File.applicationDirectory;
			 
			 var directory:File = Global.document.resolvePath(Global.localPath+"eduEditor/");
			 if(directory.exists){				 
				 var list:Array = directory.getDirectoryListing();
				 var swfArray:Array = list.filter(callback);
				 var assetsLibArray:Array = [];
				 var vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
				 var item:UpdateListItemVO;
				
				 for(var i:int=0;i<swfArray.length;i++){
					 var fileName:String = getFileName((swfArray[i] as File).url);
					 item = new UpdateListItemVO("","eduEditor/"+fileName,"","");
					 item.hasLoaded = true;
					 vec.push(item);
				 }
				 Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.LOCAL_FILES_LOAD,new LocalFilesLoadCommandVO(vec,SWF_LOAD_COMPLETE));
			 }else{
				 sendNotification(CoreConst.TOAST,new ToastVO('绘本测试文件请放到edu/eduEditor目录'));
			 }
		 }
		 public function getFileName(path:String):String{
			 
			 
			 var docIdx:int;
			 
			 for (var i:int = path.length; i >0 ; i--) 
			 {
				 if(path.charAt(i)=="/"){
					 return path.substr(i+1);
				 }
			 }
			 return null;
		 }
		 override public function get viewClass():Class
		 {
			 return Sprite;
		 }
		 
		 private function callback(item:File, index:int, array:Array):Boolean{
			if(item.url.indexOf(".swf")<0){
				return false;
			}
			return true;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName()){
				case TXT_LOAD_COMPLETE:
					
					trace(notification.getBody());
//					LayoutTool
					var ss:String = notification.getBody()[1] as String;
					
					
					var arr:Array;
					ss = ss.replace(/\r\n/g,"\n");
					ss = ss.replace(/\r/g,"\n");
					arr = MyUtils.strLineToArray(String(notification.getBody()));
					
					
					LayoutToolUtils.script = Vector.<String>(arr);
//					var aa = MyUtils.script
					Global.localPath = "edu/"
					Global.document = File.documentsDirectory;
					totalPage = SimpleScriptNewProxy.getTotalPage();
					start(currentIndex);

					break;
				case SWF_LOAD_COMPLETE:
					trace("swf load complete");
					
					loadScript();
					break;
				case CoreConst.SCRIPT_COMPLETE:
					
					trace("script complete");
//					var returnValue:Object = notification.getBody();
//					if(returnValue==0){
//						if(!sendOnce){
//							currentIndex = 1;
//							sendNotification(ApplicationFacade.EXECUSE_SCRIPT,new ScriptExecuseVO(1));
//							sendOnce = true;
//						}
//					}
					break;
			}
		}
		
		private function loadScript():void{
			Global.localPath="";
			Global.document = File.applicationDirectory;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FILE_LOAD,new FileVO("localscript",Global.localPath+"eduEditor/script.txt" ,TXT_LOAD_COMPLETE,PackData.BUFF_ENCODE));
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [TXT_LOAD_COMPLETE,SWF_LOAD_COMPLETE,CoreConst.SCRIPT_COMPLETE];
		}
		
		override public function onRegister():void
		{
			
			currentIndex = 1;
			startLoad();
			
			
			LayoutToolUtils.holder = holder = new Sprite();
			view.addChild(holder);
			
			createButtons();
			
		}
		private function start(index:int):void{
			
			
			if(index<0||index>totalPage){
				return;
			}
			
			
			
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(index));
		}
		private function onRefresh(e:MouseEvent):void{
			LayoutToolUtils.removeAll();
			
			var fileProxy:IFileLoadProxy = facade.retrieveProxy(ModuleConst.FILE_LOAD_PROXY) as IFileLoadProxy;
			fileProxy.disposeLibsDomain();
			
			startLoad();
		}
		private function clickLeft(e:MouseEvent):void{
			LayoutToolUtils.removeAll();
			TypeTool.killTweenImage();
			currentIndex--;
			if(currentIndex<1){
				currentIndex=1;
			}
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(currentIndex));
		}
		private function clickRight(e:MouseEvent):void{
			LayoutToolUtils.removeAll();
			TypeTool.killTweenImage();
			currentIndex++;
			if(currentIndex>totalPage){
				currentIndex=totalPage;
			}
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(currentIndex));
		}
		override public function onRemove():void
		{
			// TODO Auto Generated method stubon
			super.onRemove();
			LayoutToolUtils.removeAll();
			TypeTool.killTweenImage();
			
			sendNotification(WorldConst.SHOW_MAIN_MENU);
		}
		public function get view():Sprite{
			return viewComponent as Sprite;
		}
		private function createButtons():void{
//				var btn1:MCButton = new MCButton(AssetTool.getCurrentLibClass("defaultConfirmUp"),AssetTool.getCurrentLibClass("defaultConfirmDown"),null,null);
				var btn1:Button = new Button();
				btn1.label = 'preBtn';
				view.addChild(btn1);
				btn1.addEventListener(MouseEvent.CLICK,clickLeft);
//				var btn2:MCButton = new MCButton(AssetTool.getCurrentLibClass("defaultConfirmUp"),AssetTool.getCurrentLibClass("defaultConfirmDown"),null,null);
				var btn2:Button = new Button();
				btn2.label = 'nextBtn';
				btn2.x = 1150;
				btn2.addEventListener(MouseEvent.CLICK,clickRight);
				view.addChild(btn2);
//				var btn3:MCButton = new MCButton(AssetTool.getCurrentLibClass("defaultConfirmUp"),AssetTool.getCurrentLibClass("defaultConfirmDown"),null,null);
				var btn3:Button = new Button();
				btn3.label = 'currentBtn';
				btn3.x = 550;
				view.addChild(btn3);
				btn3.addEventListener(MouseEvent.CLICK,onRefresh);
				
				input = new TextField;
				input.type = TextFieldType.INPUT;
				input.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
				view.addChild(input);
				input.x = 800;
				
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(event.keyCode==10||event.keyCode==13){
				sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(input.text,-1,false,true));
			}
		}
	}
}