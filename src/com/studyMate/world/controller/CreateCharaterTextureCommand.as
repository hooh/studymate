package com.studyMate.world.controller
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import akdcl.skeleton.ConnectionData;
	import akdcl.skeleton.export.ConnectionEncoder;
	import akdcl.skeleton.export.ContourInstaller;
	import akdcl.skeleton.export.TextureMix;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class CreateCharaterTextureCommand extends SimpleCommand implements ICommand
	{
		private var index:int = 0;
		private var total:int = 0;
		private var files:Array;
		private var loaders:Loader = new Loader();
		private var textureList:Vector.<flash.display.DisplayObject> = new Vector.<flash.display.DisplayObject>;
		
		public function CreateCharaterTextureCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			ConnectionData.addData(Assets.store["MHumanSK"]);
			ConnectionData.addData(Assets.store["ChickSK"]);
			ConnectionData.addData(Assets.store["BMPSK"]);
			
			
			Assets.petTexture = new TextureMix(Assets.store["petTexture"],XML(Assets.store["petXML"]));
			Assets.petTexture.texture = new TextureAtlas(Texture.fromBitmap(Assets.store["petTexture"],true,false),XML(Assets.store["petXML"]));
			

			Assets.charaterTexture = new TextureMix(Assets.store["myCharater"],XML(Assets.store["myCharaterXml"]));
			Assets.charaterTexture.texture = new TextureAtlas(Assets.getTexture("myCharater"),XML(Assets.store["myCharaterXml"]));
			
			sendNotification(WorldConst.CHARATER_TEXTURE_READY);
			
			
			
			/*var CaptainClass:Class = AssetTool.getCurrentLibClass("com.charater.MHuman");
			var captain:flash.display.MovieClip = new CaptainClass;
			
			var _mc:flash.display.MovieClip = ContourInstaller.install(captain);
			var skeletomXML:XML;
			var file:File; 
			var fs:FileStream;
			
			file = Global.document.resolvePath(Global.localPath +"/media/textures/myTexture/MHumanSK.sk");
			skeletomXML = ConnectionEncoder.encode(_mc);
			fs = new FileStream();				
			fs.open(file,FileMode.WRITE);
			fs.writeMultiByte(skeletomXML.toString(),PackData.BUFF_ENCODE);
			fs.close();*/
		}
		
	}
}