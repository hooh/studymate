package com.studyMate.view.component.myDrawing.helpFile
{	
	import com.studyMate.view.component.myDrawing.graph.ToolPanel;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public final class UnionPoint
	{
		
		/**
		 * @author WangTu
		 * 说明：开始字符一定要比结束字符小
		 *       使用前要指明绘图对象
		 * 
		 * @param textField TextField对象
		 * @param beginIndex 开始的字符 (小)
		 * @param endIndex 结束的字符 (大)
		 * @return  Vector.<LineInfo>点线数组,数组长度为beginIndex到endIndex字符之间的总行数。
		 */		
		public static function coordSys(textField:TextField,beginIndex:int,endIndex:int):Vector.<LineInfo>{
			
			var beginChar:int = IsLetter.search(textField.text,beginIndex,"Left");//第一个字符
			var finishChar:int = IsLetter.search(textField.text,endIndex,"Right");	//最后一个字符
			
			//var i:int = 0;
			var currentLine:int = textField.getLineIndexOfChar(beginChar);				//当前行
			var endLine:int = textField.getLineIndexOfChar(finishChar);					//最后一行
			var totalLine:int = endLine - currentLine +1;//总的线段数
			
			var vec:Vector.<LineInfo> = new Vector.<LineInfo>(totalLine,false);

			for(var i:int=0;i<totalLine;i++){
				var countChar:int = textField.getLineLength(currentLine);//当前行的字符个数
				while(countChar<=1){//如果为空行，则跳过继续下一行
					currentLine++;
					i++;
					if(currentLine==endLine){//如果到了最后一行，则直接返回值
						return vec;
					}
					countChar = textField.getLineLength(currentLine);///当前行的字符个数
				}
				
				var tempStartChar:int = textField.getLineOffset(currentLine);//当前行第一个字符的索引
				var tempEndChar:int = tempStartChar+countChar-2;//当前行最后一个字符
				
				/*trace("首字母="+ textField.text.charAt(tempStartChar));
				trace("尾字母="+ textField.text.charAt(tempEndChar));
				trace("******************************************"+"\n");*/
				
				if(tempStartChar<=beginChar){//如果是第一个比beginChar还小
					tempStartChar = beginChar;
				}													
				if(tempEndChar>=finishChar){//如果最后一个比finishChar还大
					tempEndChar = finishChar;
				}
				
				var startRect:Rectangle = null;
				while(!startRect){
					startRect = textField.getCharBoundaries(tempStartChar);
					tempStartChar--;
				}
				var startPoint:Point = new Point(startRect.x,ToolPanel.getStartY(startRect));
				
				var endRect:Rectangle=null;
				while(!endRect){
					endRect = textField.getCharBoundaries(tempEndChar);
					tempEndChar--;
				}				
				var endPoint:Point = new Point((endRect.x+endRect.width),ToolPanel.getEndY(endRect));
				
				vec[i] = cacheLineInfo(startPoint,endPoint);
				currentLine ++;
			}
			return vec;
		}
		
		private static function cacheLineInfo(startPoint:Point,endPoint:Point):LineInfo{
			var lineInfo:LineInfo = new LineInfo();
			lineInfo.startPoint = startPoint;
			lineInfo.endPoint = endPoint;
			return lineInfo;
		}
	}
}