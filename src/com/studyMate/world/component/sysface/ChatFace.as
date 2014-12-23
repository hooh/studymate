package com.studyMate.world.component.sysface
{
	import com.mylib.framework.utils.AssetTool;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ChatFace
	{
		
		/**
		 * 
		 * @param str 要检测的字符串
		 * @return 表情数组
		 * 
		 */		
		public static function checkStr(str:String):Boolean{
			var reg:RegExp = /\/:[0-9]{2}/g; 
			if(str.search(reg)==-1){//这里只搜索到两个表情符号
				 return false;	
			}
			return true;
		}
		
		public static function addFace(tf:TextField):void{
			var htmlStr:String;
			var textStr:String;
			var indexAry:Array = new Array();//表情索引数组
			var pointObj:Array = new Array();//表情占位坐标数组
			var faceSign:Array = new Array();//表情符数组
			htmlStr = tf.htmlText;
			//表情在聊天内容的符号为： /:02 ， 样式说明：/:为两个字符的标识符，02表示表情数；可以自己换成想要的。
			var reg:RegExp = /\/:[0-9]{2}/g;  
			faceSign = htmlStr.match(reg);//这里只搜索到两个表情符号
			if (faceSign.length == 0)return;
			//下面又把表情符号替换为空，接着下面去搜索空。如果下面去搜索表情符号
			//			tf.htmlText = htmlStr.replace(reg, "<font size=\'18\'>　   </font>");//把文本框内的内容用<font>字体标签代替字符串htmlStr中的表情符号
			
			var fontSize:String = String(tf.defaultTextFormat.size);
			tf.htmlText = htmlStr.replace(reg, "<font size=\'"+fontSize+"\'>　   </font>");//把文本框内的内容用<font>字体标签代替字符串htmlStr中的表情符号
			var ii:uint = 0;
			textStr = tf.text;//再把文本框内的文本，非html文本赋给另一个字符串对象textStr
			while (1){
				indexAry.push(textStr.indexOf("　   ", ii));//循环搜索textField.text中的空格(即上面利用<font>标签替换的字符)索引位置，保存索引位置到indexAry数组中
				if (indexAry[indexAry.length-1] == -1){//|　　|
					indexAry.pop();
					break;
				}
				ii = indexAry[indexAry.length-1] + 1;
			}
			var jj:uint = 0;
			var storeHeight:Number=tf.height;//把textField行高赋给临时变量
			while (jj< indexAry.length){
				tf.height=tf.textHeight;//把textField文本高赋给textField行高
				pointObj.push(tf.getCharBoundaries(indexAry[jj]));//保存表情坐标位置到数组
				tf.height=storeHeight;//把临时变量再赋给行高，还原。
				jj++;
			}
			faceSign = faceSign.reverse();//反转表情符号数组
			pointObj = pointObj.reverse();//反转坐标对象数组
			var kk:uint = 0;
			var faceClass:Class = AssetTool.getCurrentLibClass("face_MC");
			while (kk< faceSign.length){
				if (pointObj[kk] != null){
					//创建一个表情对象
					var n:uint = faceSign[kk].substr(2, 2);
					var obj:MovieClip = new faceClass();//faceMC为资源文件中的影片剪辑
					tf.parent.addChild(obj);
					obj.name = "faces";
					obj.gotoAndStop(n);//由于表情是以一个MC多帧来保存，所以计算出来的表情数，直接跳帧显示
					obj.x = pointObj[kk].x+tf.x+int(fontSize)/3;//设置表情的x坐标
					obj.y = pointObj[kk].y+tf.y+ int(fontSize)/14;//设置表情的y坐标
					obj = null;
				}
				kk++;
			}
			reg = null;
			faceSign = null;
			pointObj = null;
			indexAry = null;
			textStr = null;
			htmlStr = null;
		}
	}
}