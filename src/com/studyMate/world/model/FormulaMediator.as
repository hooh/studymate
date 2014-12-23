package com.studyMate.world.model
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.world.model.vo.FormulaVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import es.xperiments.media.StageWebViewBridge;
	import es.xperiments.media.StageWebViewDisk;
	import es.xperiments.media.StageWebviewDiskEvent;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class FormulaMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MathFormulaMediator";
		private var browser:StageWebViewBridge;
		private var formulaQue:Array;
		private var isBusy:Boolean = false;
		
		public function FormulaMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			//trace("FormulaMediator onRegister: " + (new Date).time);
			StageWebViewDisk.addEventListener(StageWebviewDiskEvent.END_DISK_PARSING, onDiskCacheEnd);
			StageWebViewDisk.setDebugMode(true);
			StageWebViewDisk.initialize(Global.stage);
		}
		
		override public function onRemove():void{
			browser.dispose();
			AppLayoutUtils.cpuLayer.removeChild(browser);
			browser = null;
			StageWebViewDisk.removeEventListener(StageWebviewDiskEvent.END_DISK_PARSING, onDiskCacheEnd);
			formulaQue.length = 0;
			formulaQue = null;
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case WorldConst.SET_FORMULA_IMAGE :
					var vo:FormulaVO = notification.getBody() as FormulaVO;
					formulaQue.push(vo);
					//trace("FormulaMediator getFormula: " + (new Date).time);
					scanQue();
					break;
				case WorldConst.STOP_ALL_FORMULA:
					if(formulaQue){
						formulaQue.length = 0;
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.SET_FORMULA_IMAGE, WorldConst.STOP_ALL_FORMULA];
		}
		
		private function onDiskCacheEnd( e:StageWebviewDiskEvent ):void{
			//trace("FormulaMediator onDiskCacheEnd: " + (new Date).time);
			browser = new StageWebViewBridge(0, 0,1280,800);
			browser.x = -1000; browser.y = -1000;
			browser.addCallback("setLatexFromJS",setLatexFromJS);
			AppLayoutUtils.cpuLayer.addChild(browser);
			loadRenderPage();
			formulaQue = new Array();
			//trace("FormulaMediator prepare: " + (new Date).time);
		}
		
		private var point:Point = new Point(0,0);
		private var rect:Rectangle = new Rectangle();
		private function setLatexFromJS(formulaId:String,formulaWidth:int,formulaHeight:int):void{
			//trace("FormulaMediator callAS: " + (new Date).time);
//			browser.setSize(formulaWidth+20,formulaHeight);
			browser.getSnapShot();
			rect.width = formulaWidth+20;
			rect.height = formulaHeight;
			var bmd:BitmapData = new BitmapData(rect.width,rect.height);
			bmd.copyPixels(browser.bitmapData,rect,point);
			var formulaBMP:Bitmap = new Bitmap(bmd);
//			var formulaBMP:Bitmap = new Bitmap(browser.bitmapData.clone());
			var formulaVo:FormulaVO = new FormulaVO(formulaId);
			formulaVo.bmp = formulaBMP;
			//trace("FormulaMediator SnapShot: " + (new Date).time);
			sendNotification(WorldConst.GET_FORMULA_IMAGE,formulaVo);
			isBusy = false;
			
			scanQue();
		}
		
		private function loadRenderPage():void{
			//trace("FormulaMediator loadRenderPage: " + (new Date).time);
			var file:File = Global.document.resolvePath("edu/formula/RenderPage.html");
			if(file.exists == false){
				sendNotification(CoreConst.TOAST,new ToastVO(file.url+'不存在'));
				return;
			}
			if(Global.OS == OSType.ANDROID){
				browser.loadURL(file.url);
			}else{
				browser.loadURL(file.nativePath);
			}
		}
		
		private function setFormula(id:String, formula:String):void{
			//trace("FormulaMediator callBrowser: " + (new Date).time);
			browser.call("setLatex", null, id, doubleEscapeTeX(formula));
		}
		
		private function doubleEscapeTeX(s:String):String {
			var t:String ="";
			t = s.replace(/\r/g," ");
			t = t.replace(/\n/g," ");
			t = t.replace(/\\/g,"\\\\");
			return t;
		}
		
		private function scanQue():void{			
			if(isBusy) {
				return;
			}
			if(formulaQue.length == 0){
				sendNotification(WorldConst.COMPLETE_ALL_FORMULA);
				return;
			}
			isBusy = true;
			var formulaVo:FormulaVO = formulaQue.shift();
			setFormula(formulaVo.id, formulaVo.formula);
		}
		
	}
}