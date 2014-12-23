package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.ExerciseLogicProxy;
	import com.studyMate.model.vo.ScriptExecuseVO;
	import com.studyMate.utils.LayoutToolUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.view.component.ReadingTextField;
	import com.studyMate.view.component.myDrawing.helpFile.RegisterModelChange;
	import com.studyMate.world.component.MydragMethod.MyDragEvent;
	import com.studyMate.world.component.MydragMethod.MyDragFunc;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.script.LayoutTool;
	import com.studyMate.world.script.TypeTool;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import fl.controls.Button;
	import fl.controls.TextArea;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	internal class ReadCPUCompleteMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ReadCPUCompleteMediator";
				
		private var readingText:String;//文章
		//private var annotationText:String;//翻译提示
		private var translationText:String;//翻译
		
		private var totalPage:int = 0;
		public var pageIndex:int=1;
				
		private var logic:ExerciseLogicProxy;
		private var prepareVO:SwitchScreenVO;
		private var initialTxt:String;//后台反馈的原始文本
		private var readingComp:TextField;
		private var registerModelChange:RegisterModelChange;
		
		public var changeBtn:Button;
		private var translationTextArea:TextArea;
		
		public function ReadCPUCompleteMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void{
			//文章	
			LayoutToolUtils.holder = view.readingHolder;
			LayoutToolUtils.script = Vector.<String>(MyUtils.strLineToArray(initialTxt));
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO("TEXT1",-1,false,true));
			
			//___________测试滚动______________
			view.readScroller.viewPort = view.readingHolder;
			view.addChild(view.readScroller);
			
			readingComp = findItem(view.readingHolder);
			readingComp.htmlText += "\n\n\n\n\n\n\n";
			readingComp.cacheAsBitmap = true;//解决文字转位图抖动的问题
			registerModelChange = new RegisterModelChange(readingComp);
			registerModelChange.toImage(imageCompleteHandler);
			
			view.readScroller.update();
			//题目
			LayoutToolUtils.holder = view.questionHolder;
			LayoutToolUtils.removeAll();		
			logic = new ExerciseLogicProxy();
			facade.registerProxy(logic);
			LayoutToolUtils.script = Vector.<String>(MyUtils.strLineToArray(initialTxt));
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(1));
			
			//页码
			totalPage = SimpleScriptNewProxy.getTotalPage();

			view.questionCount.text = "1/"+totalPage;		
			view.tipsScroll.addEventListener(MouseEvent.CLICK,tipScrollClickHandler);
			
			view.questionScroller.viewPort = view.questionHolder;
			view.addChildAt(view.questionScroller,0);		
			
			view.answerTA.prompt = "已完成，无需输入答案";
			view.reasonTA.prompt = "已完成，无需输入答案";
			view.answerTA.mouseEnabled =false;
			view.reasonTA.mouseEnabled =false;
			view.answerTA.useKeyboard = false;
			view.reasonTA.useKeyboard =false;
			
			
			///////下面的两个flash组件有bug。会导致textfied输入框一直持有焦点。垃圾adobe做的组件。
			changeBtn = new Button();
			changeBtn.label = "查看翻译";
			changeBtn.emphasized = true;
			changeBtn.toggle = true;
			changeBtn.x = 50;
			changeBtn.y = 700;
			changeBtn.setStyle("textFormat", new TextFormat("HeiTi",14,0x8080FF));
			view.addChild(changeBtn);
			changeBtn.addEventListener(MouseEvent.CLICK,changeHandler);
//			
//			
			translationTextArea = new TextArea();
			translationTextArea.setStyle("textFormat", new TextFormat("HeiTi",20,0,null,null,null,null,null,null,null,null,null,15));
			translationTextArea.setStyle("textPadding",20);
			translationTextArea.setStyle("antiAliasType",AntiAliasType.ADVANCED);
			translationTextArea.wordWrap = true;
			translationTextArea.editable = false;
			translationTextArea.x = 675;
			translationTextArea.y = 0;
			translationTextArea.width = 600;
			translationTextArea.height = 752;
			translationTextArea.htmlText = translationText+"\n\n\n\n\n\n\n\n\n";
			view.addChild(translationTextArea);
			translationTextArea.visible = false;
		}
		
		private var changeBoo:Boolean;
		protected function changeHandler(event:MouseEvent):void
		{
			changeBoo = !changeBoo;
			if(changeBoo){
				translationTextArea.visible = true;				
			}else{
				translationTextArea.visible = false;
			}
			
		}
		
		private function tipScrollClickHandler(e:MouseEvent):void{
			view.tipsScroll.visible = false;
		}
		
		override public function onRemove():void{
			while(view.numChildren){
				view.removeChildAt(0);
			}		
			logic = null;
			LayoutToolUtils.removeAll();
			LayoutToolUtils.holder = null;
			view.tipsScroll.removeEventListener(MouseEvent.CLICK,tipScrollClickHandler);
			TweenLite.killDelayedCallsTo(sendNotification);
			facade.removeProxy(ExerciseLogicProxy.NAME);
			super.onRemove();
		}
		
		/**----------------------------------查找textfiled函数-------------------------------------------*/
		private function findItem(_holder:DisplayObjectContainer):TextField{
			var textChild:TextField;
			for(var i:int = 0;i < _holder.numChildren;i++) {
				var displayObject:DisplayObject = _holder.getChildAt(i);
				if(displayObject is Sprite) {
					for(var j:int = 0;j < (displayObject as Sprite).numChildren;j++) {
						var child:DisplayObject = (displayObject as Sprite).getChildAt(j);
						if(child is TextField) {
							textChild = child as TextField;
							_holder.width = textChild.width;
							_holder.height = textChild.height;
							break;
						}
					}
				}
			}
			return textChild;
		}
		/**----------------------------------文本、图片转化功能群-------------------------------------------*/
		private function imageCompleteHandler():void{
			var UIDrag:MyDragFunc = new MyDragFunc(view.readingHolder,0.5);
			UIDrag.addEventListener(MyDragEvent.START_EFFECT,StartEffectHandler);
			UIDrag.addEventListener(MyDragEvent.END_EFFECT,EndEffectHandler);
		}		
		private function StartEffectHandler(e:MyDragEvent):void{
			registerModelChange.toComponent();
			(readingComp as ReadingTextField).show(e.localX,e.localY);
		}
		private function EndEffectHandler(e:MyDragEvent):void{
			Global.stage.focus=readingComp;
			readingComp.setSelection(0,0);
			registerModelChange.toImage();
		}
		

		/*private function functionHandle(e:Event):void{			
			if(isCheckRight && pageIndex<totalPage)	TweenLite.delayedCall(2,sendNotification,["nextTouchHandler"]);			
		}*/
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case TypeTool.EXECUTE_SHOW_QUESTION_FUNCTION:					
					view.questionScroller.update();
					break;
				case "preTouchHandler"://ReadBGMediator发送的消息，点击上一题			
					pageIndex--;
					//isCheckRight = false;
					LayoutTool.clearSubHolder();
					if(pageIndex<1){
						pageIndex = 1;
					}

					sendNotification(ReadBGMediator.TIP_HOLDER,false);
					sendNotification(ReadBGMediator.SHOW_ICON,"");

					view.questionHolder.removeChildren();
					LayoutToolUtils.holder = view.questionHolder;
					sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(pageIndex));						
					
					view.questionCount.text = pageIndex+"/"+totalPage;
					break;
				case "nextTouchHandler"://点击下一题					
					pageIndex++;
					//isCheckRight = false;
					sendNotification(ReadBGMediator.SHOW_ICON,"");
					LayoutTool.clearSubHolder();
					if(pageIndex>totalPage){
						pageIndex = totalPage;
						view.questionCount.text = totalPage+"/"+totalPage;
					}else{
						sendNotification(ReadBGMediator.TIP_HOLDER,false);

						view.questionCount.text = pageIndex+"/"+totalPage;
						view.questionHolder.removeChildren();				
						LayoutToolUtils.holder = view.questionHolder;
						sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(pageIndex));
					}							
					break;
			
				case ReadBGMediator.TIP_HOLDER:
					view.tipsScroll.update();
					view.tipsScroll.visible = notification.getBody() as Boolean;//提示文本内容
					break;
				
				case WorldConst.GET_SCREEN_FAQ:
					var str1:String = "阅读界面/"+"浏览状态,id:"+ prepareVO.data.data.readId;
					sendNotification(WorldConst.SET_SCREENT_FAQ,str1);
					break;

			}
		}		
		override public function listNotificationInterests():Array{
			return [WorldConst.GET_SCREEN_FAQ,WorldConst.DICTIONARY_SHOW,"preTouchHandler","nextTouchHandler",ReadBGMediator.TIP_HOLDER,TypeTool.EXECUTE_SHOW_QUESTION_FUNCTION];
		}
		

		
		private function get view():ReadCPUView{
			return getViewComponent() as ReadCPUView;
		}
		override public function get viewClass():Class{
			return ReadCPUView;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;	
			//rrl = prepareVO.data.data.rrl;
			initialTxt = prepareVO.data.data.initialTxt;
			translationText = prepareVO.data.data.translationText+"\n\n\n\n\n\n\n";
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
		}
	}
}