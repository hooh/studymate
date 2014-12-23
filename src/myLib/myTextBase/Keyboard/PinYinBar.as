package myLib.myTextBase.Keyboard
{
	import com.greensock.TweenLite;
	import com.mylib.framework.utils.AssetTool;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.Global;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;		
	/**
	 * 拼音显示条
	 * @author wangtu
	 */	
	internal class PinYinBar extends Sprite
	{				
		private var textfield:TextField;
		private var textformat:TextFormat;
		private var textformat1:TextFormat;
		private var matrix:Matrix;
				
		private var index:int = 0;
		private var keyArr:Array=[];
		private var dataDic:Dictionary = new Dictionary();
		private var IndexDic:Dictionary = new Dictionary();		
		
		private static var jianpinDic:Dictionary = new Dictionary;
		
		private var list:Array=[];//显示的词组
						
		private var stream:FileStream;
		
		private var containUI:Sprite;
		private var fullPinyinSp:Sprite;
		private var pinyinSP:Sprite;//容器，把所有显示的词条加进去					
		private var full_mask:Shape;
		private var fullBoo:Boolean;
		private var preBtn:SimpleButton;
		private var nextBtn:SimpleButton;
		private var upBtn:SimpleButton;//下一页
		private var downBtn:SimpleButton;
		
		private const NAME:String = "PinyinBar";
		private const barHeight:int = 58;//拼音栏高度
		private static var hasCache:Boolean;//字库是否缓存
		
		public function PinYinBar()
		{
			textformat = new TextFormat("HeiTi",28);
			textformat1 = new TextFormat("HeiTi",24,0x595858);
			textfield = new TextField();
			textfield.width = 120;	
			textfield.embedFonts = true;
			textfield.antiAliasType = AntiAliasType.ADVANCED;
			textfield.defaultTextFormat = textformat;
			textfield.autoSize = TextFieldAutoSize.CENTER;
			
			matrix = new Matrix();
			matrix.translate(16,6);
			addEventListener(Event.REMOVED_FROM_STAGE,removeStageHandler);
			
			init();	
			refreshBody();
		}
		
		protected function removeStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,removeStageHandler);
			TweenLite.killTweensOf(containUI);
			TweenLite.killDelayedCallsTo(insertChinese);
			if(stream){
				stream.removeEventListener(Event.COMPLETE, readBytes);
				stream.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				stream.close();
				stream = null;
			}
		}
		
		private function init():void{
			if(CacheTool.has(NAME,"data")){
				hasCache = true;
				dataDic = CacheTool.getByKey(NAME,"data") as Dictionary;
				keyArr = CacheTool.getByKey(NAME,"key") as Array;
				IndexDic = CacheTool.getByKey(NAME,"IndexDic") as Dictionary;
			}else{//转换词库		
				hasCache = false;
				var sourceFile:File = File.documentsDirectory.resolvePath(Global.localPath+"pinyin.txt");
				stream = new FileStream();
				stream.addEventListener(Event.COMPLETE, readBytes);
				stream.addEventListener(IOErrorEvent.IO_ERROR,ioError);
				stream.openAsync(sourceFile, FileMode.READ);
			}
		}
		private function refreshBody():void{
//			var pinBarClass:Class = AssetTool.getCurrentLibClass("PinyinBar");
			var pinBarClass:Class = MaterialManage.getInstance().pinyinBar_meterial;
			var pinBar:Sprite = new pinBarClass;
			addChild(pinBar);						
						
			var pinBarFullClass:Class = AssetTool.getCurrentLibClass("PinyinBar_FUll");
			containUI = new pinBarFullClass;
			upBtn = pinBar.getChildByName("upBtn") as SimpleButton;
			preBtn = containUI.getChildByName("preBtn") as SimpleButton;
			nextBtn = containUI.getChildByName("nextBtn") as SimpleButton;
			downBtn = containUI.getChildByName("downBtn") as SimpleButton;
			preBtn.addEventListener(MouseEvent.CLICK,preBtnHandler,false,0,true);
			nextBtn.addEventListener(MouseEvent.CLICK,nextBtnHandler,false,0,true);
			upBtn.addEventListener(MouseEvent.CLICK,upBtnHandler,false,0,true);
			downBtn.addEventListener(MouseEvent.CLICK,downBtnHandler,false,0,true);
			fullPinyinSp = new Sprite;
			containUI.addChild(fullPinyinSp);
			
			full_mask = new Shape();
			full_mask.graphics.beginFill(0);
			full_mask.graphics.drawRect(0,0,1280,containUI.height);
			full_mask.graphics.endFill();
			full_mask.y = -containUI.height+barHeight;
			this.addChild(full_mask);
			containUI.mask = full_mask;
		}
		
		protected function ioError(event:IOErrorEvent):void
		{
			hasCache = true;
			TweenLite.killDelayedCallsTo(insertChinese);
		}
		
		private function readBytes(e:Event):void {			
			var bytes:ByteArray = new ByteArray;
			stream.readBytes(bytes, 0, stream.bytesAvailable);
			stream.close();
			var data:Array = bytes.toString().split("\n");
			var total:int = data.length;
			for (var i:int = 0;i<total;i++){				
				var text:String = data[i];
				text = text.replace("\r","");				
				var key:String = text.match(/^[\x00-\xFF]*/)[0];
				keyArr[i] = key;
				dataDic[key] = text.slice(key.length).split(",");
				
				if(IndexDic[text.substr(0,1)]==null){
					IndexDic[text.substr(0,1)]=i;
				}
			}
			hasCache = true;
			CacheTool.put(NAME,"key",keyArr);
			CacheTool.put(NAME,"data" ,dataDic);
			CacheTool.put(NAME,"IndexDic",IndexDic);
		}
		
		private function preBtnHandler(e:MouseEvent):void{
			//trace("上一页");
			e.stopImmediatePropagation();
			if(index>26){
				index-=27;
				refreshSkin2(list,index);
			}
		}
		private function nextBtnHandler(e:MouseEvent):void{
			e.stopImmediatePropagation();
			if(index<100){
				index+=27;
				refreshSkin2(list,index);
			}
		}
		private function downBtnHandler(e:MouseEvent):void{
			e.stopImmediatePropagation();
			pinBarFullRemoveHandler();
		}
		private function upBtnHandler(e:MouseEvent):void{
			//trace("下一页");
			e.stopImmediatePropagation();
		
			if(!fullBoo){
				fullPinyinSp.removeChildren();
				index = 0;
				containUI.y = barHeight;
				fullBoo = true;
				this.addChild(containUI);
				TweenLite.to(containUI,0.2,{y:-containUI.height+barHeight});
				refreshSkin2(list);
			}				
		}
		private function pinBarFullRemoveHandler():void{
			fullBoo = false;
			TweenLite.to(containUI,0.2,{y:barHeight,onComplete:removeFullSp});
		}
		private function removeFullSp():void{
			fullPinyinSp.removeChildren();
			if(this.contains(containUI))
				this.removeChild(containUI);
		}		
		/**
		 * @param str  传入 字母
		 * @return     返回 字母对应的汉字数组
		 */		
		public function setString(str:String):void{
			//trace("接收str ="+str);
			if(fullBoo){
				pinBarFullRemoveHandler();				
			}
			if(str==""){
				if(pinyinSP){
					pinyinSP.removeChildren();
				}
				return;
			}
			list.length = 0;
//			注释，简拼不保留内存
//			if(dataDic[str]){
//				list = list.concat(dataDic[str]);
//				refreshSkin(list);
//				return;
//			}		
			var temp:* = jianpinDic[str];
			if(temp){
				list = list.concat(temp);
			}
			temp = dataDic[str];
			if(temp){
				list = list.concat(temp);
			}
			if(list.length>0){
				refreshSkin(list);
				return;
			}
			
			var i:int = 0;
			var flag:int = 0 ;
			if(IndexDic[str.substr(0,1)]){
				i = IndexDic[str.substr(0,1)];
				flag = i;
			}
//			trace("开始循环的索引 : "+i);						
			var keyStr:String="";
			var totalLength:int = keyArr.length;
			for (i;i< totalLength;i++)
			{
				keyStr = keyArr[i];
				if (keyStr.substr(0,str.length)==str)
					list = list.concat(dataDic[keyStr]);
				if(IndexDic[keyStr.substr(0,1)]!=flag  ||   list.length>108) break;					
			}
//			trace("结束循环的索引： "+i);			
			refreshSkin(list);
		}
		/**
		 * 读写过的汉字保存到内存中，暂时注释掉
		 * 实现模糊搜索
		 * @param chinese 传入中文词组[你好，蚂蚁]，插入内存
		 */		
		/*public function insertChinese(chineseArr:Array):void{
			if(!hasCache){//如果字体库还未缓存，则一秒后再次执行该函数
				TweenLite.delayedCall(1,insertChinese,[chineseArr]);
				return;
			}
			
			var curChar:String;
			var len:int= chineseArr.length;
			for(var m:int=0;m<len;m++){
				curChar = chineseArr[m];
				if(curChar.length>1){
					if(curChar.charAt(curChar.length-1)=='的' || curChar.charAt(curChar.length-1)=='地'){
						if(chineseArr.indexOf(curChar.substr(0,curChar.length-1))==-1){							
							chineseArr.push(curChar.substr(0,curChar.length-1));
						}
					}
				}
			}
			for(var i:int=0;i<chineseArr.length;i++){
				var key:String;
				var keyVec:Vector.<String> = ChineseConverUtil.convertChineseArr(chineseArr[i].toString());
				for(var j:int=0;j<keyVec.length;j++){
	//				trace("反查的拼音 ："+key);
					key = keyVec[j];
					if(dataDic[key]){
						var list:Array = dataDic[key];
						var needADD:Boolean=true;//默认需要添加
						for each(var str:String in list){
							if(str == chineseArr[i]){
								needADD=false;//有相等的则不用添加
								m=list.indexOf(str);
								(dataDic[key] as Array).splice(m,1);								
								(dataDic[key] as Array).unshift(str);//添加到数组开头
								break;
							}
						}
						if(needADD){
							(dataDic[key] as Array).unshift(chineseArr[i]);//添加到数组开头
						}
					}else{
						if(key!=""){
							dataDic[key] = [chineseArr[i]];
							keyArr.push(key);
							IndexDic[key.substr(0,1)] = IndexDic[key.substr(0,1)]+1;
						}	
					}					
				}
			}
			CacheTool.put(NAME,"key",keyArr);
			CacheTool.put(NAME,"data" ,dataDic);
			CacheTool.put(NAME,"IndexDic",IndexDic);
		}*/
		// 简拼不保存内存中
		public function insertChinese(chineseArr:Array):void{
			var curChar:String;
			var len:int= chineseArr.length;
			for(var m:int=0;m<len;m++){
				curChar = chineseArr[m];
				if(curChar.length>1){
					if(curChar.charAt(curChar.length-1)=='的' || curChar.charAt(curChar.length-1)=='地'){
						if(chineseArr.indexOf(curChar.substr(0,curChar.length-1))==-1){							
							chineseArr.push(curChar.substr(0,curChar.length-1));
						}
					}
				}
			}
			jianpinDic = new Dictionary();
			for(var i:int=0;i<chineseArr.length;i++){
				var key:String;
				var keyVec:Vector.<String> = ChineseConverUtil.convertChineseArr(chineseArr[i].toString());
				for(var j:int=0;j<keyVec.length;j++){
					if(jianpinDic[keyVec[j]]){
						jianpinDic[keyVec[j]].push(chineseArr[i]);
					}else{
						jianpinDic[keyVec[j]] = [chineseArr[i]];
						
					}
				}
			}
		}
		
		
		
		
		/**_______________@param data 传入 汉字数组，显示汉字皮肤__________*/		
		private var line:Line;
		private function refreshSkin(data:Array):void{
			if(pinyinSP==null){
				pinyinSP = new Sprite();	
				this.addChild(pinyinSP);
			}else{
				pinyinSP.removeChildren();
			}
			var preSp:Sprite;
			if(data.length){
				var sp:Sprite = creatItem(data[0]);
				sp.x = 0;
				line = new Line();
				line.x = sp.width;
				pinyinSP.addChild(sp);
				pinyinSP.addChild(line)
				preSp = sp;
			}
			for(var i:int=1;i<data.length;i++){
				sp = creatItem(data[i]);
				sp.x = preSp.x + preSp.width+2;
				if(sp.x + sp.width>1230)	break;

				pinyinSP.addChild(sp);				
				line = new Line();
				line.x = sp.x+sp.width;
				pinyinSP.addChild(line);
				preSp = sp;
			}			
		}
		//包装一个词组
		private function creatItem(str:String):Sprite{
			textfield.text = str;
			var sp:Sprite = new Sprite();
			textfield.x = 20;
			textfield.y = 12;
			sp.addChild(textfield);
			var bmd:BitmapData = new BitmapData(sp.width+40,barHeight,true,0);			
			bmd.draw(sp);
			sp.removeChildAt(0);
			var bmp:Bitmap = new Bitmap(bmd);;
			sp.addChild(bmp);			
			sp.name = str;	
//			sp.addEventListener(MouseEvent.MOUSE_DOWN,spDownHandler);
//			sp.addEventListener(MouseEvent.MOUSE_UP,spUpHandler);
			sp.addEventListener(MouseEvent.CLICK,spClickHandler,false,0,true);
			return sp;
		}
		
		/**_______________3*9组字符 传入 汉字数组，显示汉字皮肤__________*/	
		private function refreshSkin2(data:Array,i:int=0):void{	
			fullPinyinSp.removeChildren();
			var start:int = i;
			for(i;i<data.length;i++){
				if(i>(start+26))	break;
				var sp:Sprite = creatItem2(data[i]);
				sp.x = (int(i%9))*142;
				sp.y  = (int(i/9))%3*57 + 58;	
				fullPinyinSp.addChild(sp);				
			}			
		}
		//包装一个词组
		
		private function creatItem2(str:String):Sprite{
			textfield.text = str;
			textfield.setTextFormat(textformat1);
			var sp:Sprite = new Sprite();
			var bmd:BitmapData = new BitmapData(140,56,true,0);			
			bmd.draw(textfield,matrix);
			var bmp:Bitmap = new Bitmap(bmd);;
			sp.addChild(bmp);			
			sp.name = str;	
//			sp.addEventListener(MouseEvent.MOUSE_DOWN,spDownHandler);
//			sp.addEventListener(MouseEvent.MOUSE_UP,spUpHandler);
			sp.addEventListener(MouseEvent.CLICK,spClickHandler,false,0,true);
			return sp;
		}
		
		
		/**
		 * ------------------------汉字点击事件-----------------*/
//		private function spDownHandler(e:MouseEvent):void{
//			(e.target as Sprite).filters = [new GlowFilter(0xffff00F,0.5,32,32,2)];
//		}
//		private function spUpHandler(e:MouseEvent):void{
//			(e.target as Sprite).filters = null;
//		}
		private function spClickHandler(e:MouseEvent):void{
			e.stopPropagation();
			var dataEvent:DataEvent = new DataEvent(DataEvent.DATA);
			dataEvent.data = e.target.name;
			this.dispatchEvent(dataEvent);
			if(fullBoo){
				fullBoo = false;
				pinBarFullRemoveHandler();
				
			}
			pinyinSP.removeChildren();
		}
		
		//获取第一个词组
		public function setFirstHanzi():void{
			var  str:String = "";
			if(pinyinSP.numChildren){
				str = pinyinSP.getChildAt(0).name;
				var dataEvent:DataEvent = new DataEvent(DataEvent.DATA);
				dataEvent.data = str;
				this.dispatchEvent(dataEvent);
				if(fullBoo){
					fullBoo = false;
					pinBarFullRemoveHandler();
					
				}
			}
		}
	}
}
import flash.display.Shape;

class Line extends Shape
{
	public function Line(){
		this.graphics.lineStyle(1,0xAAAAAA);
		this.graphics.moveTo(0,0);
		this.graphics.lineTo(0,58);
		this.graphics.lineStyle(1,0xF9F9F9);
		this.graphics.moveTo(1,0);
		this.graphics.lineTo(1,58);
	}
	
}