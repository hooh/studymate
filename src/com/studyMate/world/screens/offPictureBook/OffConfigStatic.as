package com.studyMate.world.screens.offPictureBook
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.component.offline.FileRead;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class OffConfigStatic
	{		
		private static var file:File = Global.document.resolvePath(Global.localPath + "offline/bookShelf2.ini");
		public static var AllArr:Array;
		
		public function OffConfigStatic()
		{
		}
		private static function init():void{
			if(AllArr==null){				
				if(!file.exists){
					var AllStr:String = FileRead.getValue("offline/bookShelf.ini");
					AllArr = (JSON.parse(AllStr)).picbook as Array;//String转JSON										
				}else{
					AllStr = FileRead.getValue("offline/bookShelf2.ini");
					AllArr = (JSON.parse(AllStr)) as Array;//String转JSON
				}
			}
		}
		
		/**
		 * 检查是否需要插入数据 ,true为需要
		 * @param rrl
		 * @return 
		 * 
		 */		
		public static function checkPic(asPath:String):Boolean{
			init();//初始化
			var len:int = AllArr.length;
			for(var i:int=0;i<len;i++){
				if(asPath==AllArr[i].as3){
					return false;
				}
			}
			return true;
		}
		
		public static function insert(item:BookPicture):void{
			var obj:Object = {};
			obj.jpg = item.facePath;
			obj.as3 = item.asPath;
			obj.swf = item.swfPath;
			obj.rrl = item.rrlPath;
			AllArr.push(obj);
			var s:String = JSON.stringify(AllArr);
			var stream:FileStream = new FileStream()
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(s,PackData.BUFF_ENCODE);
			stream.close();
		}
		
		public static function dispose():void{
			if(AllArr){
				AllArr.length = 0;
				AllArr = null;
			}
		}
	}
}