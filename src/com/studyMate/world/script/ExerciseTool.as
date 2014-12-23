package com.studyMate.world.script
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ScriptExecuseVO;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import mx.utils.StringUtil;
	
	import com.studyMate.view.component.MCButton;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import com.studyMate.utils.LayoutToolUtils;

	public final class ExerciseTool
	{
//		public static var isInitialized:Boolean = false;
		public static var holder:Sprite = new Sprite;
		public static var currentIndex:int=1;
		
		public static var inputField:TextField;
		private static var tipInfo:TextField;
		
		
		public function ExerciseTool(){}
		
		
		public static function initElements():void{
			
			/*if(isInitialized){
				return;
			}
			
			isInitialized = true;*/
			holder.removeChildren();
			var tf:TextFormat = new TextFormat;
			tf.size = 25;
			var inputContainer:Sprite = new Sprite;
			var lbl:TextField = new TextField;
			lbl.defaultTextFormat = tf;
			lbl.mouseEnabled = false;
			lbl.text = "答案：";
			inputContainer.addChild(lbl);
			inputField = new TextField;
			inputField.addEventListener(KeyboardEvent.KEY_DOWN,pressKeyHandler);
			inputField.addEventListener(Event.ADDED_TO_STAGE,getFocus);
			inputContainer.addChild(inputField);
			inputField.x = lbl.x+lbl.textWidth+10;
			tipInfo = new TextField;
			tipInfo.defaultTextFormat = tf;
			tipInfo.mouseEnabled = false;
			inputContainer.addChild(tipInfo);
			tipInfo.x = inputField.x;
			tipInfo.y = 40;
			
			
			inputField.defaultTextFormat = tf;
			inputField.type = TextFieldType.INPUT;
			inputField.width = 600;
			inputField.height = 35;
			inputField.border = true;
			tipInfo.width = inputField.width;
			tipInfo.height = inputField.height;
			inputContainer.x = (Global.stageWidth-inputField.width)*0.5;
			inputContainer.y = 600;
			
			holder.addChild(inputContainer);
			
			var btn1:MCButton = new MCButton(Class(getDefinitionByName("toPrev")),Class(getDefinitionByName("toPrev_down")),null,null);
			holder.addChild(btn1);
			btn1.x = 50;
			btn1.y = 600;
			btn1.addEventListener(MouseEvent.CLICK,prevPage);
			btn1.addEventListener(Event.REMOVED,removeHandler);
			var btn2:MCButton = new MCButton(Class(getDefinitionByName("toNext")),Class(getDefinitionByName("toNext_down")),null,null);
			btn2.x = Global.stageWidth-100;
			btn2.y = 600;
			btn2.addEventListener(MouseEvent.CLICK,nextPage);
			btn2.addEventListener(Event.REMOVED,removeHandler2);
			holder.addChild(btn2);
		}
		private static function getFocus(e:Event):void{
			if(inputField.stage){
				inputField.stage.focus = inputField;
			}
		}
		private static function removeHandler(e:Event):void{
			e.target.removeEventListener(MouseEvent.CLICK,prevPage);
			e.target.removeEventListener(Event.REMOVED,removeHandler);
		}
		private static function removeHandler2(e:Event):void{
			e.target.removeEventListener(MouseEvent.CLICK,nextPage);
			e.target.removeEventListener(Event.REMOVED,removeHandler2);
		}
		
		/**
		 *下一页 
		 * 
		 */
		public static function nextPage(e:MouseEvent):void{
			currentIndex++;
			setCurrentIndex();
			LayoutToolUtils.killLayoutScript();
//			empty();
			LayoutToolUtils.removeAll();
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(currentIndex));
			//把holder顶置
//			LayoutToolUtils.holder.addChild(holder);
		}
		/**
		 *上一页 
		 * 
		 */
		public static function prevPage(e:MouseEvent):void{
			currentIndex--;
			setCurrentIndex();
			LayoutToolUtils.killLayoutScript();
//			empty();
			LayoutToolUtils.removeAll();
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(currentIndex));
			//把holder顶置
//			LayoutToolUtils.holder.addChild(holder);
		}
		/**
		 * 检查答案
		 * 
		 */
		private static function pressKeyHandler(e:KeyboardEvent):void{
			
			
			clearTipText();
			
			
			
			if(e.keyCode == 10||e.keyCode==13){
				
				
				
				if(LayoutToolUtils.queue.queue.length>0){
					return;
				}
				
				
				
				var inputStr:String = inputField.text;
				inputStr = StringUtil.trim(inputStr);
				if(inputStr==""){
					return;
				}
				var inputArr:Array = [];
				if(inputStr.indexOf("/")!=-1){
					inputArr= inputStr.split("/");
				}else{
					inputArr.push(inputStr);
				}
				
				
				var answerArr:Array = TypeTool.getExerciseAnswer();
				
				if(answerArr){
					var rightNum:int = 0;
					var wrongNum:int=0;
					//第一次检查
					for(var i:int=0;i<inputArr.length;i++){
						if(answerArr[i]){
							var s:String = answerArr[i];
							s = s.toLowerCase();
							if(s.indexOf("&")!=-1){
								var aa:Array = s.split("&");
								var findFlag:Boolean = false;
								for(var j:int=0;j<aa.length;j++){
									var _inputStr:String = inputArr[i];
									_inputStr = _inputStr.toLowerCase();
									if(aa[j]==_inputStr){
										findFlag = true;
										rightNum++;
										trace("correct!");
										/*var t:TextField = LayoutTool.holder.getChildByName("ttt"+i) as TextField;
										if(t){
											var ts:String = answerArr[i];
											if(ts.indexOf("&")!=-1){
												ts = ts.replace("&","/");
											}
											t.text = ts;
											t.textColor = 0xff0000;
											t.autoSize = TextFieldAutoSize.CENTER;
										}*/
										break;
									}
								}
								if(!findFlag){
									trace("wrong!");
									wrongNum++;
									/*t = LayoutTool.holder.getChildByName("ttt"+i) as TextField;
									t.text = inputArr[i];
									t.textColor = 0x000000;
									t.autoSize = TextFieldAutoSize.CENTER;*/
									
								}
							}else{
								_inputStr = inputArr[i];
								_inputStr = _inputStr.toLowerCase();
								if(_inputStr==s){
									trace("correct!");
									rightNum++;
									/*var t2:TextField = LayoutTool.holder.getChildByName("ttt"+i) as TextField;
									if(t2){
										var ts2:String = answerArr[i];
										if(ts2.indexOf("&")!=-1){
											ts2 = ts2.replace("&","/");
										}
										t2.text = ts2;
										t2.textColor = 0xff0000;
										t2.autoSize = TextFieldAutoSize.CENTER;
									}*/
								}else{
									trace("wrong!");
									wrongNum++;
									/*t = LayoutTool.holder.getChildByName("ttt"+i) as TextField;
									t.text = inputArr[i];
									t.textColor = 0x000000;
									t.autoSize = TextFieldAutoSize.CENTER;*/
								}
							}
							
						}
					}
					
					if(rightNum==answerArr.length&&wrongNum==0){
						//显示完整解题过程
						LayoutTool.executeCustomTag(TypeTool.rightHandler);
						//5秒后启动“下一题”按钮
//						TweenLite.delayedCall(5,showNextBtn);
					}else{
						
						//第一次错误
						if(!TypeTool.isExerciseWrong){
							TypeTool.isExerciseWrong = true;
							tipInfo.text = inputField.text;
							inputField.text = "";
							LayoutTool.executeCustomTag(TypeTool.firstWrongHandler);
						//第二次以后 错误
						}else{
							tipInfo.text = inputField.text;
							inputField.text = "";
							//显示完整解题过程
							LayoutTool.executeCustomTag(TypeTool.secondWrongHandler);
						}
					}
				}
			}
		}

		
		private static function clearTipText():void{
			tipInfo.text = "";
			
			for(var q:int=0;q<LayoutTool.holder.numChildren;q++){
				var child:DisplayObject = LayoutTool.mainHolder.getChildAt(q);
				if(child is TextField){
					if(child.name.indexOf("eee")!=-1){
						(child as TextField).text = "";
					}
				}
			}
			if(LayoutTool.subHolder){
				LayoutToolUtils.killLayoutScript();

				LayoutTool.subHolder.removeChildren();
			}
		}

		public static function showNextBtn():void{
			if(holder.getChildByName("nextBtn")){
				return;
			}
			var btn2:MCButton = new MCButton(Class(getDefinitionByName("toNext")),Class(getDefinitionByName("toNext_down")),null,null);
			btn2.name = "nextBtn";
			btn2.x = Global.stageWidth-100;
			btn2.y = 600;
			btn2.addEventListener(MouseEvent.CLICK,nextPage);
			btn2.addEventListener(Event.REMOVED,removeHandler2);
			holder.addChild(btn2);
		}
		private static function empty():void{

			holder.removeChildren();
		}
		private static function setCurrentIndex():void{
			if(currentIndex<1){
				currentIndex=1;
			}
			if(currentIndex>=SimpleScriptNewProxy.getTotalPage()){
				currentIndex = SimpleScriptNewProxy.getTotalPage();
			}
		}
	}
}