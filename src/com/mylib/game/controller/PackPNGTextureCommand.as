package com.mylib.game.controller
{
	import akdcl.skeleton.export.TextureMix;
	import akdcl.skeleton.export.TexturePacker;
	
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.PNGTextureItem;
	import com.mylib.game.controller.vo.PackPNGTextureCommandVO;
	
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PackPNGTextureCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			var vo:PackPNGTextureCommandVO = notification.getBody() as PackPNGTextureCommandVO;
			
			var _packer:TexturePacker = new TexturePacker();
			var file:File; 
			var fs:FileStream;
			
			for each (var i:PNGTextureItem in vo.items) 
			{
				var len:int = i.displayList.length;
				for(var j:int=0;j<len;j++){
					_packer.addTexture(i.displayList[j],i.prefix);
				}
				
			}
			
			var textures:TextureMix = _packer.packTextures(2048, 8);
			
			try {
				file = Global.document.resolvePath(Global.localPath +"/media/textures/"+ vo.fileName+".png");
				fs = new FileStream();				
				fs.open(file,FileMode.WRITE);
				var fileBytes:ByteArray = textures.bitmap.bitmapData.encode(textures.bitmap.bitmapData.rect,new PNGEncoderOptions());
				fs.writeBytes(fileBytes);
				fs.close();
				
				file = Global.document.resolvePath(Global.localPath +"/media/textures/"+ vo.fileName+".xml");
				fs = new FileStream();				
				fs.open(file,FileMode.WRITE);
				fs.writeMultiByte(textures.xml.toString(),PackData.BUFF_ENCODE);
				fs.close();
				
			} catch(e:Error) {
				trace(e.message);
			}
			
			
			
			
		}
		
	}
}