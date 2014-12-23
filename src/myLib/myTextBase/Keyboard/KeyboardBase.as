package myLib.myTextBase.Keyboard
{
	import com.greensock.TweenLite;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import myLib.myTextBase.interfaces.ITextInput;
	import myLib.myTextBase.interfaces.ITextInputCpu;
	import myLib.myTextBase.interfaces.ITextInputGpu;
	import myLib.myTextBase.utils.KeyBoardConst;
	import myLib.myTextBase.utils.KeyboardType;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import feathers.events.FeathersEventType;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	internal class KeyboardBase extends AbstractKeyboard 
	{
		
		private const NAME:String = "MyKeyboard001";
		
		protected var mainUI:Sprite;
		protected var keyboard_class:Class;
		protected var currentIndex:int;
		
		private var showTipUI:Sprite;//提示ui
		private var shoTipClass:Class;
		
		private var config:*;
		private var hasSoftKeybordSound:Boolean;
						
		public function KeyboardBase()
		{
			this.name = NAME;
			config = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var tmpString:String = config.getValueInUser("setSoftKeySoundBoo");
			if(tmpString == "true"){
				hasSoftKeybordSound = true;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("RingerChanged.mp3"),"keySound"));
			}else{
				hasSoftKeybordSound = false;
			}
			this.addEventListener(flash.events.Event.ADDED_TO_STAGE,addToStageHandler);
			this.addEventListener(flash.events.Event.REMOVED_FROM_STAGE,removeStageHandler);
			
		}
		
		private function init():void{			
			shoTipClass = AssetTool.getCurrentLibClass("Show_Key_Tip");//键盘按键提示信息
			
			mainUI = new keyboard_class;
			this.addChild(mainUI);
			if(MaterialManage.getInstance().useBigSize){
				mainUI.y = KeyBoardConst.LocalY-52;
			}else{		
				mainUI.y = KeyBoardConst.LocalY;
			}
			
//			var delBtnFunc:DragFunc = new DragFunc(mainUI.getChildByName("_8"));
//			delBtnFunc.addEventListener(MyDragEvent.START_EFFECT,delStartEffect);
//			delBtnFunc.addEventListener(MyDragEvent.END_EFFECT,delEndEffect);
			
			var delBtn:SimpleButton = mainUI.getChildByName("_8") as SimpleButton;
			delBtn.addEventListener(MouseEvent.CLICK,delLetter);
			
//			this.actionHandler();//注册拖动
			this.addEventListener(MouseEvent.MOUSE_DOWN,UIKeyboardDownHandler);			
			
		}
		
		//---------添加
		protected function addToStageHandler(event:flash.events.Event):void
		{	
			init();
			this.removeEventListener(flash.events.Event.ADDED_TO_STAGE,addToStageHandler);
			Starling.current.stage.touchable = false;
			hasKeyboard = true;
			TweenLite.delayedCall(0.3,registerStageClick);
			Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.HAS_KEYBOARD);
		}	
		private function registerStageClick():void{
			Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler);	//文字输入
		}
		//--------删除
		protected function removeStageHandler(event:flash.events.Event):void
		{
			mainUI.removeChildren();
			this.removeEventListener(flash.events.Event.REMOVED_FROM_STAGE,removeStageHandler);
			Starling.current.stage.touchable = true;
			hasKeyboard = false;
			iTextInput = null;
			TweenLite.killTweensOf(delLetter);
			TweenLite.killDelayedCallsTo(registerStageClick);
			TweenLite.killDelayedCallsTo(addEvent);
			TweenLite.killTweensOf(removeShowTip);
			Global.stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,UIKeyboardDownHandler);		
//			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.NO_KEYBOARD);
			removeChildren();
		}
		


		/**
		 * ----------------------------------连续删除删除事件-------------------------------------------*/	
//		private function delStartEffect(e:MyDragEvent):void{			
//			TweenLite.delayedCall(0.2,delLetter);			
//		}
//		private function delEndEffect(e:MyDragEvent):void{
//			TweenLite.killTweensOf(delLetter);
//		}
//		
		protected function delLetter(e:MouseEvent):void{
			e.stopImmediatePropagation();
			if(iTextInput is ITextInputCpu){				
				var evt:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN,false );
				evt.keyCode = Keyboard.BACKSPACE;
				(iTextInput as  ITextInputCpu).dispatchEvent(evt);
			}
			
//			TweenLite.delayedCall(0.1,delLetter);
			iTextInput.setFocus();
			var charString:String = iTextInput.text;
			if(iTextInput.selectionAnchorPosition!=currentIndex){//如果光标位置改变，判断条件为光标末尾不等于长度
				currentIndex = iTextInput.selectionAnchorPosition;				
			}
			var t1:int = iTextInput.selectionAnchorPosition;
			var t2:int = iTextInput.selectionActivePosition;
			if(t1==t2){
				if(t1>0){
					iTextInput.text = 	charString.substr(0,t1-1)+charString.substr(t1);
					currentIndex--;
				}									
			}else{
				iTextInput.text = charString.substr(0,t1)+charString.substr(t2);
			}																
			iTextInput.selectTextRange(currentIndex,currentIndex);	
			
		}
		
		
		
		/**----------------------------------按键字母提示-------------------------------------------*/
		private function UIKeyboardDownHandler(e:MouseEvent):void{
			if(e.target is SimpleButton){
				var btn:SimpleButton = e.target as SimpleButton;
				var i:int = int(btn.name.substr(1));
				if(i>8 && i!=13 && i!=32){//如果为字符
					/*if(_receiveText.maxChars != 0 && _receiveText.text.length>=_receiveText.maxChars){
						return;
					}*/
					var stagePoint:Point = btn.localToGlobal(new Point(0,0));
					var point:Point = mainUI.globalToLocal(stagePoint);
					if(showTipUI == null){
						showTipUI = new shoTipClass();
						showTipUI.mouseEnabled = false;
						showTipUI.mouseChildren = false;						
					}
					var txt:TextField = showTipUI.getChildByName("TXT") as TextField;
					txt.text = String.fromCharCode(i);
					showTipUI.x = point.x;
					showTipUI.y = point.y;
					mainUI.addChild(showTipUI);
					TweenLite.killTweensOf(removeShowTip);
					TweenLite.delayedCall(1,removeShowTip);
				}
			}
		}		
		

		override public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			mainUI.graphics.clear();
			mainUI.graphics.beginFill(_backgroundColor,0.8);
			if(MaterialManage.getInstance().useBigSize){
				mainUI.graphics.drawRect(0,0,340+70,mainUI.height);
				mainUI.graphics.drawRect(922-80,0,358+80,mainUI.height);
			}else{				
				mainUI.graphics.drawRect(0,0,340,mainUI.height);
				mainUI.graphics.drawRect(922,0,358,mainUI.height);
			}
			mainUI.graphics.endFill();
		}
		
		private function removeShowTip():void{
			if(showTipUI && showTipUI.parent){
				showTipUI.parent.removeChild(showTipUI);				
			}
		}
		
		/**----------------------------------键盘拖动事件组-------------------------------------------*/
		/*protected function actionHandler():void{//开始拖动事件
			var UIKeyboardDrag:DragFunc = new DragFunc(mainUI);
			UIKeyboardDrag.addEventListener(MyDragEvent.START_EFFECT,startEffect);
			UIKeyboardDrag.addEventListener(MyDragEvent.END_EFFECT,endEffect);
		}	
		private function startEffect(e:MyDragEvent):void{
			Global.stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
			mainUI.filters = [new GlowFilter(0xffff00F,0.5,32,32,2)];
			mainUI.startDrag(false,new Rectangle(0,0,0,500));
		}*/
		/*private function endEffect(e:MyDragEvent):void{
			mainUI.stopDrag();
			mainUI.filters = null;
			if(MaterialManage.getInstance().useBigSize){				
				KeyBoardConst.LocalY = mainUI.y+52;
			}else{
				KeyBoardConst.LocalY = mainUI.y;
			}
			TweenLite.killDelayedCallsTo(addEvent);
			TweenLite.delayedCall(0.1,addEvent);
		}	*/
		private function addEvent():void{
			Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
		}	
		
		/**
		 * -------当前点击显示列表，是否包含键盘组件 ，true点击到键盘，false没有点击到键盘 --------------*/				
		private function finditem(target:*):Boolean{
			if(target == null){
				return false;
			}
			if (target is ITextInput || (target.name==NAME)){
				return true;//点击到				
			}else{
				if(target.parent is Stage)	return false;//没有点击到,可以关闭
				else	return finditem(target.parent);						
			}
		}	
		

		
		/**----------------------------------舞台点击事件-------------------------------------------*/
		private function stageClickHandler(e:MouseEvent):void{	
//			trace("点击事件");
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("stageClickHandler s","KeyboardBase",0));
			if(hasKeyboard && iTextInput){
				

				var point:Point = new Point(Global.stage.mouseX, Global.stage.mouseY);
				var gpuObj:DisplayObject = Starling.current.stage.hitTest(point);
				var arr_obj:Array = Global.stage.getObjectsUnderPoint(point);
				var hasClicked:Boolean = finditem(arr_obj[arr_obj.length - 1]);//查询是否点击到键盘
				if(!hasClicked && !(gpuObj is ITextInput) && point.x>10){
					this.parent.removeChild(this);
					Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.NO_KEYBOARD);
				}else{
					if(e.target is SimpleButton){
						var i:int = int(e.target.name.substr(1));
						removeShowTip();
						
						if(hasSoftKeybordSound){
//							SoundAS.play("keySound");
//							TweenLite.killDelayedCallsTo(callKeySound);
//							TweenLite.delayedCall(1,callKeySound,null,true);
							callKeySound();
						}
						
						if(i>8){//字符
							iTextInput.setFocus();
							enterChar(i);
						}else{//特殊符号
							enterSpecial(i,e.target.name);
						}
					}
				}
				

			}
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("stageClickHandler e","KeyboardBase",0));
		}
		private function callKeySound():void{			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("keySound"));
		}

		//超界判断
		protected function moreChar(i:int):Boolean{
			if(iTextInput.maxChars != 0 && iTextInput.text.length>=iTextInput.maxChars && i!=13){
				return true;									
				
			}else{
				return false
			}
		}
		
		//字符
		protected function enterChar(i:int):void{	
			if(iTextInput.maxChars != 0 && iTextInput.text.length>=iTextInput.maxChars && i!=13){
				if(type!=KeyboardType.CN_KEYBOARD){
					return;
				}
			}
			if(iTextInput.selectionActivePosition - iTextInput.selectionAnchorPosition > 0 && i == 13){
				
			}else{
				if(iTextInput is ITextInputCpu){
					var evt:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN,false );
					evt.keyCode = i;
					(iTextInput as  ITextInputCpu).dispatchEvent(evt);													
				}else if(iTextInput is ITextInputGpu){
					if(i==13){
						(iTextInput as ITextInputGpu).dispatchEventWith(FeathersEventType.ENTER);
					}else{
						(iTextInput as ITextInputGpu).dispatchEventWith( starling.events.Event.CHANGE);
					}
					
				}
			}
			
			if(i==13){//回车则不进行运算符移位	
				enterChar_Enter(i);
								
			}else{//字符输入								
				enterChar_ABC(i);
			}						
		}
		
		protected function enterChar_Enter(i:int):void{
//			_receiveText.insertText('');																	
			
//			var m:int = iTextInput.selectionAnchorPosition
//			iTextInput.setFocus();
//			iTextInput.selectRange(m,m);
		}
		
		protected function enterChar_ABC(i:int):void{
			if(iTextInput.selectionAnchorPosition!=currentIndex){//如果光标位置改变，判断条件为光标末尾不等于长度
				currentIndex = iTextInput.selectionAnchorPosition;				
			}
			iTextInput.insertText(String.fromCharCode(i));				
			currentIndex++;
			iTextInput.selectTextRange(currentIndex,currentIndex);
		}
		
		//特殊符号
		protected function enterSpecial(i:int,name:String=''):void{
			if(i==8){
				if(iTextInput is ITextInputCpu){					
					var evt:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN,false );
					evt.keyCode = Keyboard.BACKSPACE;
					(iTextInput as  ITextInputCpu).dispatchEvent(evt);
				}
				iTextInput.setFocus();
				
				var charString:String = iTextInput.text;
				if(iTextInput.selectionAnchorPosition!=currentIndex){//如果光标位置改变，判断条件为光标末尾不等于长度
					currentIndex = iTextInput.selectionAnchorPosition;				
				}
				var t1:int = iTextInput.selectionAnchorPosition;
				var t2:int = iTextInput.selectionActivePosition;
				if(t1==t2){
					if(t1>0){
						iTextInput.text = charString.substr(0,t1-1)+charString.substr(t1);
						currentIndex--;
					}									
				}else{
					iTextInput.text = charString.substr(0,t1)+charString.substr(t2);
				}																
				iTextInput.selectTextRange(currentIndex,currentIndex);								
			}else if(i==2){//开启数字界面	
				KeyBoardConst.current_Keyboard = KeyboardType.SIGN_KEYBOARD;
			}else if(i==3){//开启字母界面
				KeyBoardConst.current_Keyboard = KeyboardType.US_KEYBOARD;
			}else if(i==4){//开启运算界面
				KeyBoardConst.current_Keyboard = KeyboardType.NUM_KEYBOARD;
			}else if(i==5){//开启中文输入界面
				KeyBoardConst.current_Keyboard = KeyboardType.CN_KEYBOARD;
			}
			if(i==2 || i==3 || i==4 || i==5){
				Facade.getInstance(CoreConst.CORE).sendNotification(KeyBoardConst.CHANGE_KEYBORD);
			}
		}
		
	}
}