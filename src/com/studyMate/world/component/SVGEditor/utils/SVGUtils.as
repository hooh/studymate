package com.studyMate.world.component.SVGEditor.utils
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class SVGUtils
	{
		
		
		public static const WIDTH:String = "width";
		public static const HEIGHT:String = "height";
		public static const FONT_SIZE:String = "font-size";
		public static const FONT_FAMILY:String = "font-family";
		public static const FONT_WEIGHT:String = "font-weight";
		public static const LETTER_SPACING:String = "letter-spacing";
		public static const FILL:String = "fill";
		public static const STROKE:String = "stroke";
		public static const STROKE_WIDTH:String = "stroke-width";
		public static const XLINK:String ="xlink:href";
		public static const POINTS:String = "points";
		
		
		/**---------------通信---------------------------*/		
		public static function sendinServerInofFunc(command:String,reveive:String,infoArr:Array,index:Vector.<int>=null):void{			
			PackData.app.CmdIStr[0] = command;
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+1] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+1;	
			if(index!=null){
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive,null,PackData.BUFF_ENCODE,index));	//派发调用绘本列表参数，调用后台
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台				
			}
		}
		
		//净随机数字
		public static function getRandomIDStr():String{
			var numb:int = int(Math.random()*50)+65;
			var numb2:String = String.fromCharCode(numb);
			return getTimer()+numb2+Math.random();
		}
		
		public static function splitNumericArgs(input:String):Vector.<String> {
			var returnData:Vector.<String> = new Vector.<String>();
			
			var matchedNumbers:Array = input.match(/(?:\+|-)?(?:(?:\d*\.\d+)|(?:\d+))(?:e(?:\+|-)?\d+)?/g);
			for each(var numberString:String in matchedNumbers){
				returnData.push(numberString);
			}
			
			return returnData;
		}
	}
}