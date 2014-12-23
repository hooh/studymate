package com.studyMate.world.component.weixin.renderers
{
	import com.greensock.TweenMax;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.weixin.VoiceState;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	
	/**
	 * note 聊天接收的图片的UI
	 * 2014-5-7下午5:36:27
	 * Author wt
	 *
	 */	
	
	internal class PicSp extends Sprite
	{
		public var core:String;
		public const iconWidth:Number = 160;
		public const iconHeight:Number = 94;
		private var _filename:String;
		public var direction:String;	//左侧(L)，还是右侧(R)
		public var hasloaded:Boolean;
		
		private var iconTexture:Texture;
		private var iconImg:Image;
		private var file:File;
		private var loader:Loader;
		public var picImg:Image;//背景图片
		private var loadImg:Image;
		
		public function PicSp(filename:String,direction='L')
		{
			if(filename.indexOf('/')!=-1){
				filename = filename.substring(filename.lastIndexOf('/')+1);
			}
			this._filename = filename;

			this.direction = direction;
						
			picImg = new Image(Assets.getWeixinTexture('defaultPic'));			
			this.addChild(picImg);
		}
		
//		public function adjustDirection(value:String):void{
//			if(this.direction==direction) return;
//			this.direction = direction;
//			if(direction=='L'){
//				picImg.scaleX = -1;
//			}else{
//				picImg.scaleX = 1;
//			}
//		}
		
		public function set filename(value:String):void
		{
//			_filename = value;
			_filename = value.substring(value.lastIndexOf('/')+1);
		}

		override public function dispose():void
		{
			super.dispose();
			if(loader){
				loader.unload();
				loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader = null;
			}
			if(iconTexture){
				iconTexture.dispose();
				iconTexture = null;
			}
			if(loadImg){
				loadImg.removeFromParent(true);
			}
		}
		
		private function startLoad():void{
			file = Global.document.resolvePath(Global.localPath+VoicechatComponent.owner(core).configText.imgfolder+'/'+_filename);
			if(file.exists){
				if(loader == null){
					loader = new Loader();			
					loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				}
				
				loader.load(new URLRequest(file.url));	
				picImg.touchable = false;			
			}
		}
		private function clearLoad():void{
			if(loader){
				loader.unload();
			}
			if(iconImg) iconImg.removeFromParent(true);
		}
		
		private function LoaderComHandler(event:flash.events.Event):void{	
			hasloaded = true;
			var matrix:Matrix = new Matrix();
			matrix.scale(iconWidth / loader.width, iconHeight / loader.height);
			var bmpData:BitmapData = new BitmapData(iconWidth, iconHeight);
			bmpData.draw(loader, matrix);	
			
			iconTexture = Texture.fromBitmapData(bmpData,false);
			iconImg = new Image(iconTexture);
			iconImg.touchable = false;
			this.addChild(iconImg);
//			img.x = 11;
			if(picImg)
				picImg.touchable = true;
		}	
		
		
		private var _state:int=-1;			//当前状态
		public function set state(value:int):void
		{
			_state = value;
			switch(_state){
				case VoiceState.defaultState:
					if(loadImg && loadImg.parent){
						TweenMax.killTweensOf(loadImg);
						loadImg.removeFromParent();
					}
					if(picImg) picImg.touchable = true;
					clearLoad();
					break;
				case VoiceState.loadingState:
					loadImg = new Image(Assets.getWeixinTexture('loading'));
					loadImg.pivotX = loadImg.width>>1;
					loadImg.pivotY = loadImg.height>>1;
					loadImg.x = 70;
					loadImg.y = 40;
					this.addChild(loadImg);
					TweenMax.to(loadImg,3,{rotation:Math.PI,repeat:int.MAX_VALUE});
					if(picImg) picImg.touchable = false;					
					break;
				case VoiceState.playState:
					startLoad();
					break;
			}
			
		}
		
		
//		private function iconTouchHandler(e:TouchEvent):void
//		{
//			if(e.touches[0].phase=="ended"){
//				trace('点击缩略图');
//			}
//		}
		
		private function ioErrorHandler(event:flash.events.Event):void{

		}
	}
}