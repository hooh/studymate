package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.db.schema.AssetsLib;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.AssetsType;
	import com.studyMate.model.vo.FileVO;
	import com.studyMate.model.vo.IFileVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.StyleVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class AssetSaveCommand extends SimpleCommand implements ICommand
	{
		
		private var swfBytes:ByteArray;
		
		
		override public function execute(notification:INotification):void
		{
			var file:FileVO = notification.getBody()[0] as FileVO;
			var ifile:IFileVO = file.parameters as IFileVO;
			if(ifile is AssetsLib){
				var lib:AssetsLib = ifile as AssetsLib;
				var dir:Dictionary;
				if(file.isLoaded){
					
					if(lib.type==AssetsType.STYLE){
						registerLibFont(lib,notification.getBody()[1]);
					}else if(lib.type==AssetsType.XML){
						
						Assets.store[(file.parameters.parameters as String)] = XML(notification.getBody()[1]);
					}else{
						
						Assets.store[(file.parameters.parameters as String)] = notification.getBody()[1];
					}
					
					
					
					sendNotification(CoreConst.LOAD_NEXT_LIB);
					
				}else{
					//库文件不在本地或者需要更新 需要通过网络传输
					
					if(file.type==AssetsType.ASSET||file.type==AssetsType.STYLE){
						//sendNotification(ApplicationFacade.PUSH_VIEW,new PushViewVO(EasyDownloadView));
						sendNotification(CoreConst.EASY_DOWNLOAD,file.filePath);
					}else{
						sendNotification(CoreConst.LOAD_NEXT_LIB);
					}
					
					
					//loadAssets(ifile as AssetsLib);
					
					
					
					
					
				}
			}else if(ifile is UpdateListItemVO){
				//registerLibFont(lib,notification.getBody()[1]);
				sendNotification(CoreConst.LOAD_NEXT_LIB);
			}else if(ifile is StyleVO){
				var style:StyleVO = ifile as StyleVO;
				
				for each (var i:String in style.fonts) 
				{
					Font.registerFont(getDefinitionByName(i) as Class);
					
				}
				
				sendNotification(CoreConst.LOAD_NEXT_LIB);
				
				
				
				
				
			}
			
		}
		
		private function loadAssets(_lib:AssetsLib):void{
			
			/*PackData.app.CmdIStr[0] = CmdStr.OPERFILE_DOWNLOAD_BINFILE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = _lib.path;
			PackData.app.CmdInCnt = 3;*/
			
			
			PackData.app.CmdIStr[0] = CmdStr.SNFILE_csDownloadHostFile_FILE182;
			PackData.app.CmdIStr[1] = "/usr1/snet/swf/"+_lib.path;
			PackData.app.CmdIStr[2] = "0";
			PackData.app.CmdIStr[3] = (16*1024).toString();
			PackData.app.CmdInCnt = 4;
			
			var file:File = Global.document.resolvePath(_lib.path);
			var stream:FileStream = new FileStream();
			stream.open(file,FileMode.WRITE);
			
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(CoreConst.LOAD_SWF_BYTES,[stream,CoreConst.LOAD_NEXT_LIB,_lib],"byte"));
			
		}
		
		public static function registerLibFont(lib:AssetsLib,_content:Object):void{
			
				var arr:Array = lib.parameters.split(";");
				
				for each (var j:String in arr) 
				{
					
					if(j!=""&&_content[j]){
						Font.registerFont(_content[j]);
					}
					
				}
				
				
				
		}
		
		
		public function AssetSaveCommand()
		{
			super();
		}
	}
}