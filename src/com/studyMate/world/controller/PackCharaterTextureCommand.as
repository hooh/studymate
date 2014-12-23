package com.studyMate.world.controller
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.mylib.game.controller.vo.PackPNGTextureCommandVO;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.AndroidGame.AndroidGameVO;
	import com.studyMate.world.component.AndroidGame.GameMarket.GameMarketPage;
	import com.studyMate.world.controller.vo.PNGTextureItem;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	import akdcl.skeleton.export.TexturePacker;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class PackCharaterTextureCommand extends SimpleCommand implements ICommand
	{
		private var index:int = 0;
		private var total:int = 0;
		private var files:Array;
		private var loaders:Loader = new Loader();
		private var textureList:Vector.<flash.display.DisplayObject> = new Vector.<flash.display.DisplayObject>;
		
		public function PackCharaterTextureCommand()
		{
			super();
		}
		
		
		private var view:Sprite;
		private var queue:LoaderMax;
		
		override public function execute(notification:INotification):void
		{
			
			view = notification.getBody() as Sprite;
			
			
			queue = new LoaderMax({name:"mainQueue",maxConnections:1,onChildComplete:childCompleteHandler,onComplete:completeHandle});
			
			var __file:File;
			var _file:File = Global.document.resolvePath(Global.localPath + "media/textures/myTexture/equipment/");
			if(_file.exists){
				files = _file.getDirectoryListing();
				
				
				for (var i:int = 0; i < files.length; i++) 
				{
					__file = files[i];
					
					if(__file.extension == "png")
						queue.append( new ImageLoader(Global.document.resolvePath(Global.localPath + "media/textures/myTexture/equipment/" + __file.name).url,
							{name: __file.name.substr(0,__file.name.length-4)}));
				}
				
				
			}
			_file = Global.document.resolvePath(Global.localPath + "media/textures/myTexture/bone/");
			if(_file.exists){
				files = _file.getDirectoryListing();
				
				
				for (i = 0; i < files.length; i++) 
				{
					__file = files[i];
					
					if(__file.extension == "png")
						queue.append( new ImageLoader(Global.document.resolvePath(Global.localPath + "media/textures/myTexture/bone/" + __file.name).url,
							{name: __file.name.substr(0,__file.name.length-4)}));
				}
				
				
			}
			
			queue.load();
			
		}
		private function childCompleteHandler(e:LoaderEvent):void{
			
			if(e.target.content && e.target.vars){
				
				var loadedImage:ContentDisplay = e.target.content;
				var _bit:Bitmap = loadedImage.rawContent as Bitmap;
				_bit.smoothing = true;
				
				
				var scale:Number = 0.25;
				var matrix:Matrix = new Matrix();
				matrix.scale(scale, scale);
				var smallBMD:BitmapData = new BitmapData(_bit.width * scale, _bit.height * scale, true, 0x000000);
				smallBMD.draw(_bit.bitmapData, matrix, null, null, null, true);
				
				
				var bit:Bitmap = new Bitmap(smallBMD, PixelSnapping.AUTO, true);
				bit.name = e.target.vars.name;
				textureList.push(bit);
				index++;
				
				
				
			}else{
				
				trace("加入失败："+e.text);
				
			}
			
			
		}
		private function completeHandle(e:LoaderEvent):void{
			trace("加载完成@!!!共有："+textureList.length);
			
			/*var img:Image;
			for (var i:int = 0; i < textureList.length; i++) 
			{
				img = new Image(Texture.fromBitmap(textureList[i] as Bitmap,false));
				img.x = 50 + 100*(int(i%10));
				
				img.y = 100 + 100*(int(i/10));
				view.addChild(img);
			}*/
			
			packEquipmentFile();
			
			
		}
		//打包装备文件
		private function packEquipmentFile():void{
			var file:File; 
			var fs:FileStream;
			var _packer:TexturePacker = new TexturePacker();
			var len:int = textureList.length;
			if(len>0){
				for(var j:int=0;j<len;j++){
					_packer.addTexture(textureList[j]);
				}
				Assets.charaterTexture = null;
				Assets.charaterTexture = _packer.packTextures(2048, 8);
				
				Assets.charaterTexture.texture = new TextureAtlas(Texture.fromBitmap(Assets.charaterTexture.bitmap,true,false),Assets.charaterTexture.xml);
				
				
				_packer.dispose();
				
				sendNotification(WorldConst.PACK_PNG_TEXTURE,new PackPNGTextureCommandVO("myCharater",new <PNGTextureItem>[
					new PNGTextureItem(textureList),
				]));
			}
		}
		
	}
}