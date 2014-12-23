package com.studyMate.utils 
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display3D.Context3D;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import flash.system.Capabilities;
	import flash.utils.describeType;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class MyUtils
	{
		
		
//		public static var submitId:String = null;
		
		
		
		
		
		//public static var functionTimeLine:TimelineMax = new TimelineMax();
		
		
//		public static var rrlPath:Array = new Array();
		
		public static var webUsingTime:Number = 300;
		
		public static function toSpell(input:String):String{
			
			var str:String = input;
			var reg:RegExp = /&#x/
			
			
			var idx:int = str.search(reg);
			
			while(idx>=0){
				
				var t:String = String.fromCharCode(parseInt(str.substr(idx+3,4),16));
				
				str = str.replace(str.substr(idx,8),t);
				
				idx = str.search(reg);
			}
			
			
			return "["+str+"]";
			
			
		}
		public static function toSpell2(input:String):String{
			var str:String = input;
			var reg:RegExp = /&#x/
			
			
			var idx:int = str.search(reg);
			
			while(idx>=0){
				
				var t:String = String.fromCharCode(parseInt(str.substr(idx+3,4),16));
				
				str = str.replace(str.substr(idx,8),t);
				
				idx = str.search(reg);
			}
			return str;
		}
		
		/*static private var _logger:ILogger = null;
		static public function set logger(value:ILogger):void {
			_logger = value;
		}*/
		
		/*public static function print(...args):void {
			var s:String = args.join(" - ");
			if (_logger!=null) {
				_logger.print(s);
			}else{
				trace(s);
			}
		}*/
		
		/*public static function formatCode(input:String):String{
			var source:String=input;
			var index:int=-1;
			var indexStart:int;
			var indexEnd:int;
			var checkImport:Array=new Array();
			var importRepeat:int=0;
			
			var indexPackageStart:int;
			var indexPackageEnd:int;
			
			var sourceStr:String;
			var newStr:String;
			
			var letterArr:Array=["a","b","c","d","e","f",
								"g","h","i","j","k","l",
								"m","n","o","p","q","r",
								"s","t","u","v","w","x",
								"y","z"];
			var letterId:int=0;

			var indexEnd_save:int;
			
			//删除Package头尾
			indexPackageStart=source.indexOf("{");
			indexPackageEnd=source.lastIndexOf("}");
			source=source.substring(indexPackageStart+1,indexPackageEnd);
		
			
			while((index=source.indexOf("import",index+1))!=-1){
				indexEnd=index;
				indexEnd=source.indexOf(";",indexEnd);
				indexEnd_save=indexEnd;
				sourceStr=source.substring(index,indexEnd)+";";
				
				//indexStart 起始位置，indexEnd 结束位置
				indexEnd=source.lastIndexOf(".",indexEnd);
				indexStart=source.lastIndexOf(" ",indexEnd);
				
				
//				for(var i:int=0;i<checkImport.length;i++){
//					test=source.substring(indexStart+1,indexEnd);
//					test2=checkImport[i].toString().search(source.substring(indexStart+1,indexEnd));
//					if(checkImport[i].toString().search(source.substring(indexStart+1,indexEnd))!=-1)
//						importRepeat=1;
//				}
				
				if(checkImport.indexOf(source.substring(indexStart+1,indexEnd))!=-1){
					importRepeat=1;
				}
				
				//重复命名空间处理
				if(importRepeat==0){
					checkImport.push(source.substring(indexStart+1,indexEnd));
					
					//定义新的命名空间
					newStr="namespace m"+letterArr[letterId]+" = \""+source.substring(indexStart+1,indexEnd)+
						"\"; use namespace m"+letterArr[letterId++]+";";

					source=source.replace(sourceStr,newStr);
				}
				else{
					importRepeat=0;
					newStr=" ";
					sourceStr=source.substring(index-2,indexEnd_save)+";";
					source=source.replace(sourceStr,newStr);
				}
			}
			return source;
		}*/
		
		
		
		
		
		public static function strLineToArray(_script:String):Array{
			return _script.split("\n");
		}
		/*public static function strLineToArray2(_script:String):Array{
			return _script.split("\r\n")
		}*/
		
		
		
		
		/*public static function hasItem(vo:String,ac:Array):int{
			if(ac.length < 1)
				return -1;
			else{
				for(var i:int=0;i<ac.length;i++){
					if(vo == ac[i])
						return i;
				}
				return -1;
			}
		}
		*/
		
		/**
		 *获取文件后缀名 
		 * @param path
		 * @return 
		 * 
		 */		
		public static function getFilePathSuffix(path:String):String{
			
			
			var docIdx:int;
			
			for (var i:int = path.length; i >0 ; i--) 
			{
				if(path.charAt(i)=="."){
					return path.substr(i+1);
				}
			}
			return null;
		}
		
		/*public static function getFileName(path:String):String{
			
			
			var docIdx:int;
			
			for (var i:int = path.length; i >0 ; i--) 
			{
				if(path.charAt(i)=="/"){
					return path.substr(i+1);
				}
			}
			return null;
		}*/

		
		/*public static function toSetArray ($arr:Array):Array
		{
			var obj:Object = {};
			var arr:Array  = [];
			
			for (var i:String in $arr) obj[$arr[i]] = i;
			for (var j:Object in obj) arr[arr.length] = j;
			
			return arr;
		}*/
		
		
		/*public static function isSubclass(a:Class, b:Class): Boolean
		{
			if (int(!a) | int(!b)) return false;
			return (a == b || a.prototype is b);
		}*/
		
		public static function checkOS():void{
			var OS:String;
			if(Capabilities.os.indexOf("Linux")>=0){
				OS = OSType.ANDROID;
			}else{
				OS = OSType.WIN;
			}
			
			Global.OS = OS;
		}
		
		public static function MaterialCmp(updateVO:UpdateListVO):void{
			var newlist:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
			var fileSize:Number;
			var file:File;
			for(var i:int = 0; i < updateVO.list.length; i++){
				
				
				
				
				
				
				if(updateVO.list[i].wfname==Global.appName){
					file = File.applicationDirectory.resolvePath(Global.localPath + updateVO.list[i].path);
					
				}else{
					file = Global.document.resolvePath(Global.localPath + updateVO.list[i].path);
				}
				
				
				if(file.exists){
					fileSize = file.size;
				}else{
					fileSize = 0;
				}
				if(fileSize != updateVO.list[i].size){
					
					if(updateVO.list[i].wfname==Global.appName&&Global.OS==OSType.ANDROID){
					}else{
						newlist.push(updateVO.list[i]);
					}
					
					trace("Download File List Add: /edu/" + updateVO.list[i].path);
				}
				
				
				
				
			}
			updateVO.list = newlist;
		}
		
		public static function dateFormat(date:Date):String{
			var dYear:String = String(date.getFullYear());
			var dMouth:String = String((date.getMonth() + 1 < 10) ? "0" : "") + (date.getMonth() + 1);
			var dDate:String = String((date.getDate() < 10) ? "0" : "") + date.getDate();
			return dYear+dMouth+dDate;
		}
		
		
		/**
		 * 
		 * @param file 文件夹的文件列表
		 */	
		public static const AllowMinSize:Number=1.0;
		public static const ClearMaxSize:Number=2.5;
		public static function checkFolderSize(array:Array=null):void{
			clearFileNum("records",40,20);//清理磁盘日志
			var value:Number = File.documentsDirectory.spaceAvailable/1024/1024/1024;//磁盘剩余大小
			if(value<AllowMinSize){//如果剩余磁盘空间＜2G
				//Facade.getInstance(ApplicationFacade.CORE).sendNotification(ApplicationFacade.CANCEL_DOWNLOAD);//停掉下载
				var directory:File =Global.document.resolvePath(Global.localPath + "Market/video");				
				clearFile(directory,array);//清理视频
				
				value = File.documentsDirectory.spaceAvailable/1024/1024/1024;//磁盘剩余大小
				if(value<ClearMaxSize){//还是不够则提示清理相册
					directory = Global.document.resolvePath("DCIM/Camera");
					clearFile(directory,null);
				}else{
					return;
				}
				
				value = File.documentsDirectory.spaceAvailable/1024/1024/1024;//磁盘剩余大小
				if(value<ClearMaxSize){//还是则提示截屏
					directory = Global.document.resolvePath("Pictures/Screenshots");
					clearFile(directory,null);
					
					directory = Global.document.resolvePath("Screenshots");
					clearFile(directory,null);
				}else{
					return;
				}
				
				value = File.documentsDirectory.spaceAvailable/1024/1024/1024;//磁盘剩余大小
				if(value<ClearMaxSize){//清理视频空间还是不够则清理音乐
					directory = Global.document.resolvePath(Global.localPath + "Market/music");
					clearFile(directory,null);
				}else{
					return;
				}
				
				
				//Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n您的磁盘空间依然不足,请清理您的相册或者其他文件.",false));//提示信息
			}
			
		}
		
		private static function clearFile(file:File,array:Array=null):void{
			if(!file.exists) return;
			var directory:File = file;
			var value:Number;
			var list:Array = directory.getDirectoryListing();
			if(array){
				list = list.filter(doEach);//删除用户列表之外的所有视频。					
			}
			value = File.documentsDirectory.spaceAvailable/1024/1024/1024;
			if(value>ClearMaxSize){//磁盘剩余大小
				return;
			}
			list.sort(compare,Array.CASEINSENSITIVE);//用户列表内的视频再按时间排序
			for (var i:uint = 0; i < list.length; i++) {
				trace(list[i].nativePath);
				if(list[i].exists){
					if(list[i].isDirectory){
						file.deleteDirectory(true);
					}else{						
						list[i].deleteFile();
					}
					trace("列表内要删除的文件："+list[i].nativePath);
					value = File.documentsDirectory.spaceAvailable/1024/1024/1024;
					if(value>ClearMaxSize){//磁盘剩余大小
						return;
					}
				}				
			}
			
			
			function doEach(obj:File,idx:int,ownarr:Array):Boolean{
				if(array.indexOf(obj.url)!=-1){
					return true;
				}
				else {
					if(obj.exists){
						trace("列表外删除的文件："+obj.nativePath);
						if(list[i].isDirectory){
							file.deleteDirectory(true);
						}else{						
							list[i].deleteFile();
						}
					}
					return false;
				}
			}			
			function compare(a:File,b:File):Number{
				if(a.modificationDate.time>b.modificationDate.time){
					return 1;
				}else if(a.modificationDate.time==b.modificationDate.time){
					return 0;
				}else{
					return -1;
				}				
			}
		}
		

		/**
		 *专用于读取 edu/media/目录下的xml文件 
		 * 
		 */		
		public static function getXmlFile(fileName:String):XML{
			var file:File = Global.document.resolvePath(Global.localPath+"/media/"+fileName);
			var fstream:FileStream = new FileStream();
			fstream.open(file,FileMode.READ);
			
			var xml:XML = XML(fstream.readMultiByte(fstream.bytesAvailable,PackData.BUFF_ENCODE));
			fstream.close();
			
			return xml;
		}

		/*public static function copyAsBitmapData(sprite:starling.display.DisplayObject):BitmapData {
			if (sprite == null) return null;
			var resultRect:Rectangle = new Rectangle();
			sprite.getBounds(sprite, resultRect);
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			support.transformMatrix(sprite.root);
			support.translateMatrix( -resultRect.x, -resultRect.y);
			var result:BitmapData = new BitmapData(resultRect.width, resultRect.height, true, 0x00000000);
			support.pushMatrix();
			support.transformMatrix(sprite);
			sprite.render(support, 1.0);
			support.popMatrix();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
		}*/
		/*public static function copyAsBitmapData2(ARG_sprite:DisplayObject):BitmapData {
			
			if ( ARG_sprite == null) {
				return null;
			}
			
			var resultRect:Rectangle = new Rectangle();
			ARG_sprite.getBounds(ARG_sprite, resultRect);
			
			var context:Context3D = Starling.context;
			var scale:Number = Starling.contentScaleFactor;
			
			var nativeWidth:Number = Starling.current.stage.stageWidth;
			var nativeHeight:Number = Starling.current.stage.stageHeight;
			
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0,0,nativeWidth, nativeHeight);
			support.applyBlendMode(true);
			
			if (ARG_sprite.parent){
				support.transformMatrix(ARG_sprite.parent);
			}
			
			support.translateMatrix( -ARG_sprite.x + ARG_sprite.width / 2, -ARG_sprite.y + ARG_sprite.height / 2 );
			
			var result:BitmapData = new BitmapData(nativeWidth, nativeHeight, true, 0x00000000);
			
			support.pushMatrix();
			
			support.blendMode = ARG_sprite.blendMode;
			support.transformMatrix(ARG_sprite);
			ARG_sprite.render(support, 1.0);
			support.popMatrix();
			
			support.finishQuadBatch();
			
			context.drawToBitmapData(result);   
			
			var w:Number = ARG_sprite.width;
			var h:Number = ARG_sprite.height;
			
			if (w == 0 || h == 0) {
				return null;
			}
			
			var returnBMPD:BitmapData = new BitmapData(w, h, true, 0);
			var cropArea:Rectangle = new Rectangle(0, 0, ARG_sprite.width, ARG_sprite.height);
			
			returnBMPD.draw( result, null, null, null, cropArea, true );
			return returnBMPD;
		}*/
		
		public static function setFormat(dur:Number):String
		{
			var _minuter:int=Math.floor(dur/60); //获取总分钟数
			var _second:int=Math.floor(dur%60);  //取得余下的秒数
			var f_minuter:String; //格式化后的分钟
			var f_second:String;  //格式化后的秒钟
			if (_minuter < 10)
			{
				f_minuter = "0" + String(_minuter);
			}
			else
			{
				f_minuter = String(_minuter);
			}
			if (_second < 10)
			{
				f_second = "0" + String(_second);
			}
			else
			{
				f_second = String(_second);
			}
			return f_minuter + ":" + f_second;
		}
		
		public static function getSoundPath(fileName:String):String{
			return Global.document.resolvePath(Global.localPath+"media/sounds/"+fileName).url;
		}
		
		public static function getTimeFormat():String {			
			
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyyMMdd-HHmmss");
			return dateFormatter.format(Global.nowDate);		
			
			
		}
		
		//20141209-102832 转 2014-12-09 10:28:32
		public static function getTimeFormat1():String{			
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");		
			dateFormatter.setDateTimePattern("yyyy-MM-dd HH:mm:ss");			
			return dateFormatter.format(Global.nowDate);
		}
		
		/**
		 * 清理文件夹 
		 * @param filePath 相对路径
		 * @param warmMax  文件数最大时，触发警告
		 * @param clearTo  触发后，请到的数量
		 */		
		public static function clearFileNum(filePath:String,warmMax:int=500,clearTo:int=250):void{
			var directory:File = Global.document.resolvePath(Global.localPath + filePath);
			if(directory.exists){
				var list:Array = directory.getDirectoryListing();
				if(list.length>warmMax){
					list.sort(compare,Array.CASEINSENSITIVE);//用户列表内的视频再按时间排序
					while(list.length>clearTo){
						try{							
							if(list[0].exists){
								if(list[0].isDirectory){
									list[0].deleteDirectory(true);
								}else{						
									list[0].deleteFile();
								}
							}
						}catch(e:Error){
							
						}
						list.shift();
					}
				}			
			}			
			function compare(a:File,b:File):Number{
				if(a.modificationDate.time>b.modificationDate.time){
					return 1;
				}else if(a.modificationDate.time==b.modificationDate.time){
					return 0;
				}else{
					return -1;
				}	
			}
		}
		
		/**
		 * 浅复制一个对象
		 * 对象浅度复制 : 将实例及子实例的所有成员(属性和方法, 静态的除外)都复制一遍, (引用不必重新分配空间!)
		 * @param	obj
		 * @return
		 */
		public static function clone(obj:*):*
		{
			if (obj == null
				|| obj is Class
				|| obj is Function)
			{
				return obj;
			}
			
			var xml:XML = describeType(obj);
			var o:* = new (Object(obj).constructor as Class);
			// clone var variables
			for each(var key:XML in xml.variable)
			{
				o[key.@name] = obj[key.@name];
			}
			// clone getter setter, if the accessor is "readwrite" then set this accessor.
			for each(key in xml.accessor)
			{
				if("readwrite" == key.@access)
					o[key.@name] = obj[key.@name];
			}
			// clone dynamic variables
			for (var k:String in obj)
			{
				o[k] = obj[k];
			}
			return o;
		}
		
		
		/**
		 * 系统评星 
		 * @param score ： 分数
		 * @return 		number:星星数<br><br>
		 * 
		 * 评星标准：<br><br>
		 * 90 <=  score <= 100    ->  3星<br>
		 * 85 <=  score <    90    ->    2.5星<br>
		 * 80 <=  score <    85    ->    2星<br>
		 * 60 <=  score <    80    ->    1.5星<br>
		 * 40 <=  score <    60    ->    1星<br>
		 * 10 <=  score <    40    ->    0.5星<br>
		 * 0   <=  score <    10    ->    0星<br>
		 * 
		 */		
		public static function getRewardStar(score:Number):Number{
			if(90 <=  score &&　score <= 100){
				return 3;
				
			}else if(85 <=  score &&　score <    90){
				return 2.5;
				
			}else if(80 <=  score &&　score <    85){
				return 2;
				
			}else if(60 <=  score &&　score <    80){
				return 1.5;
				
			}else if(40 <=  score &&　score <    60){
				return 1;
				
			}else if(10 <=  score &&　score <    40){
				return 0.5;
				
			}
			
			return 0;
		}
		
		
		public static function getScreen():String{
			var newVal:String = "";
			if(Facade.getInstance(CoreConst.CORE).hasProxy(ModuleConst.SWITCH_SCREEN_PROXY)
				&&(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen){
				var str:String =  (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen.getMediatorName();
				
				var _tmparr:Array = str.split(".");
				if(_tmparr.length > 2){
					newVal = _tmparr[_tmparr.length-1];				
					
				}else{
					newVal = str;
					
				}
			}
			return newVal;
		}
		
		
		//取指定月份最后一天
		public static function getLastDay(year:int, month:int):int{
			//计算本月最后一天
			var lastday:int;
			var days:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
			
			//二月 闰年判断
			if(month == 2){
				lastday = 28;
				if (((year % 4 == 0) && !(year % 100 == 0)) || (year % 400 == 0)){
					lastday = 29;
				}
			}else{
				lastday = days[month-1];
				
			}
			return lastday;
		}
		
		
		
		
	}
}