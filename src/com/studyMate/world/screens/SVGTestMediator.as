package com.studyMate.world.screens
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.display.base.SVGContainer;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.SVG.text.TextFieldSVGTextDrawer;
	import com.lorentz.processing.ProcessExecutor;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.media.StageWebView;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import mx.utils.StringUtil;
	
	import es.xperiments.media.StageWebViewBridge;
	import es.xperiments.media.StageWebViewBridgeEvent;
	import es.xperiments.media.StageWebViewDisk;
	import es.xperiments.media.StageWebviewDiskEvent;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;

	public class SVGTestMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SVGTestMediator";
		public static const GET_FORMULA:String = NAME + "GetFormula";
		
		private var svgDocument:SVGDocument;
		private var browser:StageWebViewBridge;
		private var webView:StageWebView;
		
		private var formulaBMP:Bitmap;
		
		private var input:TextField;
		
		private var testData:XML = <svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<polyline points="0,0 0,20 20,20 20,40 40,40 40,60"
style="fill:white;stroke:red;stroke-width:2"/>

<path d="M153 334
C153 334 151 334 151 334
C151 339 153 344 156 344
C164 344 171 339 171 334
C171 322 164 314 156 314
C142 314 131 322 131 334
C131 350 142 364 156 364
C175 364 191 350 191 334
C191 311 175 294 156 294
C131 294 111 311 111 334
C111 361 131 384 156 384
C186 384 211 361 211 334
C211 300 186 274 156 274"
style="fill:white;stroke:red;stroke-width:2"/>

<text x="100" y="200" useEmbeddedFonts="true" font-size="60" font-family="HuaKanT">ttttttttttttttttttttt中文</text>

</svg>;
		
		
		
		public function SVGTestMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			ProcessExecutor.instance.initialize(view.stage);
			svgDocument=new SVGDocument();
			svgDocument.textDrawer = new TextFieldSVGTextDrawer();
			var widthIWant:Number = 400;
			var heightIWant:Number = 400;
			
			svgDocument.availableWidth = widthIWant;
			svgDocument.availableHeight = heightIWant;
			
			svgDocument.parse(testData);
			
			view.addChild(svgDocument);
			
			view.stage.quality = StageQuality.HIGH;
			
			
			svgDocument.addEventListener(SVGEvent.RENDERED,renderedHandle);
			
			
//			StageWebViewDisk.addEventListener(StageWebviewDiskEvent.START_DISK_PARSING, onDiskCacheStart);
			StageWebViewDisk.addEventListener(StageWebviewDiskEvent.END_DISK_PARSING, onDiskCacheEnd);
			StageWebViewDisk.initialize(Global.stage);
			
			
			
			/*var webView:StageWebView = new StageWebView();
			webView.stage = view.stage;
			webView.viewPort = new Rectangle(0, 0, view.stage.stageWidth, view.stage.stageHeight);
			var file:File = Global.document.resolvePath("edu/formula/RenderPage.html");
			browser.view.loadURL(file.url);
			webView.loadURL("http://192.168.1.104/bugzilla/html/P2.html");*/
			
			var btn:Sprite = new Sprite();
			btn.buttonMode = true;
			btn.graphics.beginFill(0xff0000);
			btn.graphics.drawRect(0,0,100,40);
			btn.x = 1000;
			
			btn.addEventListener(MouseEvent.CLICK,refreshBtnHandle);
			
			view.addChild(btn);
			
			btn = new Sprite();
			btn.buttonMode = true;
			btn.graphics.beginFill(0x00ff00);
			btn.graphics.drawRect(0,0,100,40);
			btn.x = 1000; btn.y = 100;
			
			btn.addEventListener(MouseEvent.CLICK,refreshBtn4serverHandler);
			
			view.addChild(btn);
			
			input = new TextField();
			input.type = TextFieldType.INPUT;
			input.width = 500;
			input.height = 100;
			input.border = true;
			input.multiline = true;
			input.wordWrap = true;
			view.addChild(input);
			input.x = 400;
			
		}
		
		private function doubleEscapeTeX(s:String):String {
			var t:String ="";
			t = s.replace(/\r/g," ");
			t = t.replace(/\n/g," ");
			t = t.replace(/\\/g,"\\\\");
			return t;
		}
		
		private function refreshBtnHandle(event:MouseEvent):void{
			
			if(formulaBMP){
				if(formulaBMP.parent){
					view.removeChild(formulaBMP);
				}
				formulaBMP.bitmapData.dispose();
			}
			browser.call("setLatex",null,"formula2",doubleEscapeTeX(input.text));
			
		}
		
		private function refreshBtn4serverHandler(event:MouseEvent):void{
			if(formulaBMP){
				if(formulaBMP.parent){
					view.removeChild(formulaBMP);
				}
				formulaBMP.bitmapData.dispose();
			}
			getFormula();
		}
		
		private function showFormula(formula:String):void{
			browser.call("setLatex",null,"formula2",doubleEscapeTeX(formula));
		}
		
		// event listener that gets called on page load complete
		private function onViewLoadComplete( e:Event ):void
		{
			trace('view loaded');
		}
		
		private function onDiskCacheEnd( e:StageWebviewDiskEvent ):void
		{
			
			
			//Now is safe to init our StageWebViewBridge class
			browser = new StageWebViewBridge();
			browser.addCallback("setLatexFromJS",setLatexFromJS);
			browser.addEventListener(StageWebViewBridgeEvent.DEVICE_READY, onDeviceReady );
			browser.addEventListener(Event.COMPLETE,handleLoad);
			view.addChild(browser);
			browser.setSize(WorldConst.stageWidth,WorldConst.stageHeight);
			loadRenderPage();
			
			
			browser.x = -1000;
			browser.y = -1000;
			
			
			
			
			// enable javascript to call function helloWorldFromJS
			
		}
		
		protected function onDeviceReady(event:StageWebViewBridgeEvent):void
		{
			browser.call("setLatex",null,"formula1"," R_i{}^j{}_{kl} = g^{jm} R_{imkl} + \sqrt{1- g^{jm} R_{mikl}} ");
			
		}	
		
		public function handleLoad(e:Event):void
		{
			
			
			
			
		}
		
		private function setLatexFromJS(formulaId:String,formulaWidth:int,formulaHeight:int):void{
			trace(formulaId,formulaWidth,formulaHeight);
			browser.setSize(formulaWidth+20,formulaHeight);
			browser.getSnapShot();
			
			formulaBMP = new Bitmap(browser.bitmapData.clone());
			view.addChild(formulaBMP);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.STAGE_WEB_VIEW_READY:
				{
					
					loadRenderPage();
					
					break;
				}
				case CoreConst.WEBPAGE_LOADED:{
					
					
					break;
				}
				case GET_FORMULA :
					var result:DataResultVO = notification.getBody() as DataResultVO;
					if(!result.isErr){
						var formula:String = PackData.app.CmdOStr[2];
						showFormula(formula);
					}
					break;
					
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.STAGE_WEB_VIEW_READY,CoreConst.WEBPAGE_LOADED,GET_FORMULA];
		}
		
		private function loadRenderPage():void{
			var file:File = Global.document.resolvePath("edu/formula/RenderPage.html");
			
			if(Global.OS==OSType.ANDROID){
				browser.loadURL(file.url);
			}else{
				browser.loadURL(file.nativePath);
			}
			
		}
		
		
		
		
		private function renderedHandle(event:SVGEvent):void{
			var root:SVGContainer = (svgDocument.getElementAt(0) as SVGContainer)
			for (var i:int = 0; i < root.numElements; i++) 
			{
				if("myText"==root.getElementAt(i).id){
					root.getElementAt(i).addEventListener(MouseEvent.CLICK,clickTextHandle);
				}
			}
			
		}
		
		private function clickTextHandle(event:MouseEvent):void{
			trace("click");
		}
		
		private function getFormula():void{
			PackData.app.CmdIStr[0] = CmdStr.SELECT_MATH_FORMULA;
			PackData.app.CmdIStr[1] = "1";
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_FORMULA));
		}
		
	}
}