package com.studyMate.view
{
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	
	public final class LoadingViewMediator extends Mediator implements IMediator,ILoadingView
	{
		private var total:Number;
		private var _process:Number;
		private var bar:Sprite;
		private var totalWidth:int;
		
		private var cancelBtn:Sprite;
		
		private var waiting:MovieClip;
		private var bitmapDatas:Vector.<BitmapData>;
		private var textures:Vector.<Texture>;
		private var busy:BusyIndicator;
		private var busyTimeline:TimelineMax;
		
		public function LoadingViewMediator()
		{
			super(ModuleConst.LOADING_VIEW_MEDIATOR, new Sprite);
			bitmapDatas = new Vector.<BitmapData>;
			textures = new Vector.<Texture>;
		}
		
		override public function onRegister():void
		{			
			if(!cancelBtn){
				cancelBtn = new Sprite();
				cancelBtn.graphics.beginFill(0xffffff);
				cancelBtn.graphics.lineStyle(1);
				cancelBtn.graphics.drawRect(0,0,60,30);
				cancelBtn.graphics.endFill();
				cancelBtn.buttonMode = true;
				var txt:TextField = new TextField();
				txt.text = "取消下载";
				txt.mouseEnabled = false;
				txt.x = 4;
				txt.y = 2;
				cancelBtn.addChild(txt);
				cancelBtn.y = 70;
				cancelBtn.addEventListener(MouseEvent.CLICK,cancelBtnHandle);
				
			}
			
			refreshSkin();
			
		}
		
		public function refreshSkin():void{
			
			
			if(bar&&bar.parent){
				bar.parent.removeChild(bar);
			}
			
			if(waiting){
				waiting.removeFromParent(true);
			}
			
			if(busy){
				busy.removeFromParent(true);
			}
			
			
			for (var i:int = 0; i < bitmapDatas.length; i++) 
			{
				bitmapDatas[i].dispose();
			}
			
			bitmapDatas.length = 0;
			
			for (var j:int = 0; j < textures.length; j++) 
			{
				textures[j].dispose();
			}
			textures.length = 0;
				
			
			busy = new BusyIndicator;
			
			if(busy.isWorking){
				busy.x = Global.stageWidth*0.5;
				busy.y = Global.stageHeight*0.5;
			}
			if(busy.isWorking){
				busyTimeline = new TimelineMax({onComplete:busyCompleteHandle});
				
			}
			
			if(AssetTool.hasLibClass("ui.processBar")){
				
				
				var c:Class = AssetTool.getCurrentLibClass("ui.processBar") as Class;
				bar = new c;
				totalWidth = bar.width;
				bar.x = -bar.width>>1;
			}else{
				bar = new Sprite();
				var p:Shape = new Shape();
				p.graphics.beginFill(0xefefef);
				p.graphics.drawRect(0,0,1,20);
				p.graphics.endFill();
				p.name = "p";
				bar.addChild(p);
				bar.x = -view.x;
				
				var num:TextField = new TextField();
				num.name = "num";
				bar.addChild(num);
				
				var msg:TextField = new TextField();
				msg.name = "msg";
				bar.addChild(msg);
				msg.y = 20;
				msg.width = 400;
				totalWidth = Global.stage.stageWidth;
				
			}
			
			if(AssetTool.hasLibClass("com.ui.waiting")){
				
				var cc:Class = AssetTool.getCurrentLibClass("com.ui.waiting") as Class;
				var mc:flash.display.MovieClip = new cc;
				var bmpd:BitmapData = new BitmapData(mc.width,mc.height,true,0xffffff);
				bmpd.draw(mc);
				bitmapDatas.push(bmpd);
				textures = new Vector.<Texture>();
				textures.push(Texture.fromBitmapData(bmpd,false));
				
				
				mc.gotoAndPlay(10);
				
				bmpd = new BitmapData(mc.width,mc.height,true,0xffffff);
				bmpd.draw(mc);
				bitmapDatas.push(bmpd);
				textures.push(Texture.fromBitmapData(bmpd,false));
				
				
				
				
				
			}else if(Global.welcomeInit){
				var tt:TextField = new TextField();
				var tf:TextFormat = new TextFormat(null,30,0xee4322);
				tt.defaultTextFormat = tf;
				var bmpd2:BitmapData;
				tt.autoSize = TextFieldAutoSize.LEFT;
				
				tt.text = "Loading";
				bmpd2 = new BitmapData(tt.textWidth,tt.textHeight,true,0xffffff);
				bmpd2.draw(tt);
				textures.push(Texture.fromBitmapData(bmpd2,false));
				
				tf.color = 0x994322;
				tt.defaultTextFormat = tf;
				tt.text = "Loading";
				bmpd2 = new BitmapData(tt.textWidth,tt.textHeight,true,0xffffff);
				bmpd2.draw(tt);
				textures.push(Texture.fromBitmapData(bmpd2,false));
			}
				
			
			if(waiting){
				Starling.juggler.remove(waiting);
				waiting.removeFromParent(true);
				waiting = null;
			}
			
			if(textures.length){
				waiting = new MovieClip(textures);
				AppLayoutUtils.gpuPopUpLayer.addChild(waiting);
				Starling.juggler.add(waiting);
				waiting.y = WorldConst.stageHeight-50;
				waiting.x = WorldConst.stageWidth - 150;
				waiting.visible = false;
				waiting.stop();
				
			}
			
			
			bar.visible = false;
//			waiting.visible = false;
//			waiting.stop();
			view.addChild(bar);
			process = 0;
			
		}
		
		private function busyCompleteHandle():void{
			busy.stop();
			busy.removeFromParent();
			
		}
		
		
		
		protected function cancelBtnHandle(event:MouseEvent):void
		{
			sendNotification(CoreConst.CANCEL_DOWNLOAD);
			sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
			sendNotification(CoreConst.DISABLE_CANCEL_DOWNLOAD);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name){
				case CoreConst.LOADING_PROCESS:
					process=notification.getBody() as int;
					
					break;
				case CoreConst.LOADING_TOTAL:
					
					total = notification.getBody() as Number;
					
					break;
				case CoreConst.LOADING_INIT_PROCESS:
					process = 0;
					if(bar==null){
						
					}else{
						if(!bar.visible){
							bar.visible = true;
						}else if(waiting){
							waiting.visible = false;
						}
					}
					break;
				case CoreConst.LOADING_CLOSE_PROCESS:
					
					//view.busy.visible = true;
					
					if(!bar){
					}else{
						if(bar.visible){
							bar.visible = false;
						}else if(waiting){
							waiting.visible = true;
						}
						
					}
					
					break;
				case CoreConst.LOADING_MSG:
					if(bar!=null){
						(bar.getChildByName("msg") as TextField).text = notification.getBody() as String;
					}
					break;
				case CoreConst.ENABLE_CANCEL_DOWNLOAD:
					view.addChild(cancelBtn);
					break;
				case CoreConst.DISABLE_CANCEL_DOWNLOAD:
					if(cancelBtn.parent){
						cancelBtn.parent.removeChild(cancelBtn);
					}
				break;
				case CoreConst.SHOW_LOADING:
					showLoading();
				break;
				case CoreConst.HIDE_LOADING:
					hideLoading();
					break;
				case CoreConst.REFRESH_LOADING:
					refreshSkin();
					break;
				case CoreConst.SHOW_BUSY:
					showBusy();
					break;
			}
			
			
		}
		
		private function showBusy():void{
			if(!busy.isWorking){
				return;
			}
			
			if(!busy.parent){
				Starling.current.stage.addChild(busy);
			}
			if(!busy.isPlaying){
				busy.play();
				busy.alpha = 1;
				busyTimeline.clear();
				busyTimeline.append(TweenLite.to(busy,1,{alpha:1}));
				busyTimeline.append(TweenLite.to(busy,2,{}));
				busyTimeline.append(TweenLite.to(busy,1,{alpha:0}));
				busyTimeline.totalProgress(0);
			}else{
				busyTimeline.totalProgress(0);
			}
			
			
			
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.LOADING_PROCESS,CoreConst.LOADING_TOTAL,CoreConst.LOADING_CLOSE_PROCESS,CoreConst.LOADING_MSG,
				CoreConst.LOADING_INIT_PROCESS,CoreConst.ENABLE_CANCEL_DOWNLOAD,CoreConst.DISABLE_CANCEL_DOWNLOAD,
				CoreConst.SHOW_LOADING,CoreConst.HIDE_LOADING,CoreConst.REFRESH_LOADING,CoreConst.SHOW_BUSY
				
			];
		}
		
		public function get view():Sprite{
			return viewComponent as Sprite;
		}

		public function get process():Number
		{
			return _process;
		}

		public function set process(value:Number):void
		{
			_process = value;
			
			if(bar!=null){
				
				
				(bar.getChildByName("num") as TextField).text = Math.floor(process/1024).toString()+"k";
				(bar.getChildByName("p") as DisplayObject).width = totalWidth*process/total;
				
			}
		}
		
		public function showLoading():void{
			if(bar.visible){
				Global.stage.addChild(view);
				view.scaleX = Global.widthScale;
				view.scaleY = Global.heightScale;
				view.x = Global.stage.stageWidth>>1;
				view.y = Global.stage.stageHeight>>1;
			}else{
				if(waiting){
					if(AppLayoutUtils.gpuLayer.stage)
					AppLayoutUtils.gpuLayer.stage.addChild(waiting);
					waiting.visible = true;
					waiting.play();
					
				}
			}
			
		}
		
		public function hideLoading():void{
			
			if(view.parent){
				view.parent.removeChild(view);
			}
			
			if(waiting){
				waiting.stop();
				waiting.removeFromParent();
			}
			
			
		}
		
		

		
	}
}