package com.mylib.game.controller
{
	import com.mylib.game.controller.vo.PackMCTextureCommandVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.MCTextureItem;
	
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import akdcl.skeleton.export.TextureMix;
	import akdcl.skeleton.export.TexturePacker;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PackMCTextureCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			var vo:PackMCTextureCommandVO = notification.getBody() as PackMCTextureCommandVO;
			
			var _packer:TexturePacker = new TexturePacker();
			var file:File; 
			var fs:FileStream;
			
			for each (var i:MCTextureItem in vo.items) 
			{
				_packer.addTexturesFromContainer(i.mc,i.prefix);
			}
			
			var textures:TextureMix = _packer.packTextures(256, 2);
			
			
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