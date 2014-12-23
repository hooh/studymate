package com.mylib.framework.controller
{
	import com.studyMate.db.schema.AssetsLib;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class LoadSwfBytes extends SimpleCommand implements ICommand
	{
		
		public var completeNotice:String;
		public var completeNoticeParameters:Array;
		
		private var lib:AssetsLib;
		
		private var fileStream:FileStream;
		
		public function LoadSwfBytes()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var result:DataResultVO = notification.getBody() as DataResultVO;
			var bb:ByteArray;
			fileStream = result.para[0];
			if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
				lib = result.para[2];
				
				completeNotice = result.para[1];
				var loader:Loader = new Loader();
				var context:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
				context.allowCodeImport = true;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandle);
				fileStream.close();
				
				var file:File = Global.document.resolvePath(lib.path);
				fileStream.open(file,FileMode.READ);
				
				bb = new ByteArray();
				fileStream.readBytes(bb);
				fileStream.close();
				loader.loadBytes(bb,context);
				
				
				//loader.load(new URLRequest(Global.document.resolvePath(lib.path).url),context);
				
			}else{
				bb = PackData.app.CmdOStr[2];
				fileStream.writeBytes(bb);
			}
			
		}
		
		private function loadCompleteHandle(event:Event):void{
			
			AssetSaveCommand.registerLibFont(lib,event.target.content);
			
			sendNotification(completeNotice);
		}
		
		
		
		
	}
}