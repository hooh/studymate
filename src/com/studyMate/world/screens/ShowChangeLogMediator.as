package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Circ;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.view.component.GpuTextField.TextFieldToGPU;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.HAlign;

	public class ShowChangeLogMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ShowChangeLogMediator";
		private var vo:SwitchScreenVO;
		
		public function ShowChangeLogMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(_vo:SwitchScreenVO):void {
			vo = _vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void {
			initBackground();
			addScroll();
			addText();
			addButton();
			appearView();
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
		}
		
		override public function onRemove():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			super.onRemove();
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		private function initBackground():void{
			var img:Image = new Image(Assets.getTexture("noticeBoard"));
			img.touchable = false;
			view.addChild(img);
		}
		
		private var noticeText:TextFieldTextEditor;
		private var layout:VerticalLayout;
		private var container:ScrollContainer;
		private function addScroll():void{
			layout = new VerticalLayout();
			layout.horizontalAlign = HAlign.CENTER;
			
			container = new ScrollContainer();
			container.layout = layout;
			container.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			container.snapScrollPositionsToPixels = true;
			container.x = 38; container.y = 142;
			container.width = 644; container.height = 353;
			view.addChild(container);
		}
		
		private function addText():void{
			var tf:TextFormat = new TextFormat("HuaKanT",25, 0x3a2002);
			var titleTxt:flash.text.TextField = new flash.text.TextField();
			titleTxt.defaultTextFormat = tf;
			titleTxt.autoSize = TextFieldAutoSize.CENTER;
			titleTxt.wordWrap = true;
			titleTxt.multiline = true;
			titleTxt.embedFonts = true;
			titleTxt.antiAliasType = AntiAliasType.ADVANCED;
			titleTxt.width = 587;
			titleTxt.text = getText();
			
			var titleGpu:TextFieldToGPU = new TextFieldToGPU(titleTxt);
			container.addChild(titleGpu);
		}
		
		private function getText():String{
			var changeLogString:String = new String;
			try {
				var changeLogFile:File = Global.document.resolvePath(Global.localPath+"changeLog.txt");
				var stream:FileStream = new FileStream();
				stream.open(changeLogFile, FileMode.READ);
				changeLogString = stream.readMultiByte(stream.bytesAvailable, "GBK");
				stream.close();
			} catch(error:Error) {
				if(stream) stream.close();
			}
			return changeLogString;
		}
		
		private function addButton():void{
			var btn:Button = new Button(Assets.getAtlasTexture("config"));
			btn.x = 487; btn.y = 513;
			view.addChild(btn);
			btn.addEventListener(Event.TRIGGERED, buttonHandler);
		}
		
		private function buttonHandler(event:Event):void{
			disappearView();
		}
		
		private function appearView():void{
			TweenMax.from(view, 0.6, {scaleX:0.1, scaleY:0.1, x:Global.stageWidth/2, y:Global.stageHeight/2, ease:Back.easeOut});
		}
		
		private function disappearView():void{
			TweenLite.to(view, 0.6, {scaleX:0.1, scaleY:0.1, x:Global.stageWidth/2, y:Global.stageHeight/2, ease:Circ.easeIn, onComplete:closeScreen});
		}
		
		private function closeScreen():void{
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
	}
}