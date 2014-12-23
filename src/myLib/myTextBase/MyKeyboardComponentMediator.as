package myLib.myTextBase {
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import myLib.myTextBase.Keyboard.AbstractKeyboard;
	import myLib.myTextBase.Keyboard.Creator;
	import myLib.myTextBase.utils.KeyBoardConst;
	import myLib.myTextBase.utils.KeyboardType;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	public class MyKeyboardComponentMediator extends Mediator  {		
		
		
		private var keyboardUI:AbstractKeyboard;
		
		private var tempChinese:Array;
		private var hasBackgroundColor:Boolean;
		private var backgroundColor:uint;
								
		public function MyKeyboardComponentMediator() {
			super(ModuleConst.MY_KEYBOARD_COMPONENT);
		}	
		
		override public function onRegister():void
		{
			keyboardUI = new AbstractKeyboard();
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			if(keyboardUI.parent){
				keyboardUI.parent.removeChild(keyboardUI);
			}
			keyboardUI = null;
			super.onRemove();
		}

		
		private function hasKeypad():Boolean{
			if( Keyboard.physicalKeyboardType=="keypad"){
				return true;
			}else{
				return false;
			}
		}

		/**----------------------------------舞台删除事件-------------------------------------------*/		
		private function resetAll():void{
			tempChinese = null;
			hasBackgroundColor = false;
			backgroundColor = 0;
			if(keyboardUI.parent){
				keyboardUI.parent.removeChild(keyboardUI);
			}
			keyboardUI = new AbstractKeyboard();
			KeyBoardConst.current_Keyboard = '';
			KeyBoardConst.LocalY = 500;
			sendNotification(SoftKeyBoardConst.NO_KEYBOARD);
		}

		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SoftKeyBoardConst.RESET_SORFTKEYBOARD:
					resetAll();
					break;
				case KeyBoardConst.CHANGE_KEYBORD:
					ToolTypePropertiesHandler(notification);
					break;				
				case SoftKeyBoardConst.USE_KEYBOARD_CHINESE:
					KeyBoardConst.current_Keyboard = KeyboardType.CN_KEYBOARD;
					ToolTypePropertiesHandler();
					break;
				case SoftKeyBoardConst.KEYBOARD_HASBG:
					hasBackgroundColor = true;
					if(keyboardUI){
						backgroundColor = notification.getBody() as uint;
						keyboardUI.backgroundColor = notification.getBody() as uint;
					}
					break;
				case SoftKeyBoardConst.INSERT_CHINESE:
					tempChinese = notification.getBody() as Array;
					if(keyboardUI && keyboardUI.type==KeyboardType.CN_KEYBOARD){
						if(tempChinese && tempChinese.length){
							keyboardUI.InsertChinese(tempChinese);	
							tempChinese.length = 0;
						}
					}
					break;
				case SoftKeyBoardConst.USE_SIMPLE_KEYBOARD:
					if(notification){
						if(notification.getBody()){
							KeyBoardConst.current_Keyboard = KeyboardType.SIMPLE_KEYBOARD;
							if(keyboardUI.parent){
								ToolTypePropertiesHandler();
							}
						}else{
							if(KeyBoardConst.current_Keyboard == KeyboardType.SIMPLE_KEYBOARD){
								KeyBoardConst.current_Keyboard = KeyboardType.US_KEYBOARD;
								
							}
							if( KeyBoardConst.current_Textinput){
								ToolTypePropertiesHandler();								
							}
						}
					}
					
					break;
				case SoftKeyBoardConst.USE_ASPECT_KEYBOARD:
					if(notification){
						if(notification.getBody()){
							KeyBoardConst.current_Keyboard = KeyboardType.ASPECT_KEYBOARD;
							if(keyboardUI.parent){
								ToolTypePropertiesHandler();
							}
						}else{
							if(KeyBoardConst.current_Keyboard == KeyboardType.ASPECT_KEYBOARD){
								KeyBoardConst.current_Keyboard = KeyboardType.US_KEYBOARD;
								
							}
							if( KeyBoardConst.current_Textinput){
								ToolTypePropertiesHandler();								
							}
						}
					}					
					break;
				case SoftKeyBoardConst.HIDE_SOFTKEYBOARD:
					if(keyboardUI.parent){
						keyboardUI.parent.removeChild(keyboardUI);
					}
					break;
			}
		}
		
		public function ToolTypePropertiesHandler(notification:INotification=null):void{
//			if(hasKeypad())	return;//如果插了硬键盘(注释掉即可电脑测试软键盘)
			
			switch(KeyBoardConst.current_Keyboard){
				case KeyboardType.CN_KEYBOARD:					
					changeTo_CN_KEYBOARD();
					break;
				case KeyboardType.NUM_KEYBOARD:
					changeTo_NUM_KEYBOARD();
					break;
				case KeyboardType.SIGN_KEYBOARD:
					changeTo_SIGN_KEYBOARD();
					break;
				case KeyboardType.US_KEYBOARD:
					changeTo_US_KEYBOARD();
					break;
				case KeyboardType.SIMPLE_KEYBOARD:					
					changeTo_Simple_KEYBOARD();
					break;
				case KeyboardType.ASPECT_KEYBOARD:
					changeTo_Aspect_KEYBOARD();
					break;
				default :
					changeTo_US_KEYBOARD();
					break;
				
			}
			if(keyboardUI.iTextInput)
				keyboardUI.iTextInput.setFocus();
		}
		/*
		* *---------------切换到中文键盘------------------*/
		private function changeTo_CN_KEYBOARD():void{
			if(keyboardUI.type != KeyboardType.CN_KEYBOARD){
				if(keyboardUI.parent){
					keyboardUI.parent.removeChild(keyboardUI);
				}
				keyboardUI = Creator.creatCNKeyboard();				
				Global.stage.addChild(keyboardUI);
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
				
			}else if(!keyboardUI.parent){
				keyboardUI = Creator.creatCNKeyboard();	
				Global.stage.addChild(keyboardUI);	
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}
			
			if(tempChinese && tempChinese.length){
				keyboardUI.InsertChinese(tempChinese);	
				tempChinese.length = 0;
			}
		}
		/*
		* *---------------切换到数字键盘------------------*/
		private function changeTo_NUM_KEYBOARD():void{
			if(keyboardUI.type != KeyboardType.NUM_KEYBOARD){
				if(keyboardUI.parent){
					keyboardUI.parent.removeChild(keyboardUI);
				}
				keyboardUI = Creator.creatNumKeyboard();				
				Global.stage.addChild(keyboardUI);
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}else if(!keyboardUI.parent){
				keyboardUI = Creator.creatNumKeyboard();	
				Global.stage.addChild(keyboardUI);	
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}
		}
		/*
		* *---------------切换到符号键盘------------------*/
		private function changeTo_SIGN_KEYBOARD():void{
			if(keyboardUI.type != KeyboardType.SIGN_KEYBOARD){
				if(keyboardUI.parent){
					keyboardUI.parent.removeChild(keyboardUI);
				}
				keyboardUI = Creator.creatSignKeyboard();				
				Global.stage.addChild(keyboardUI);
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}else if(!keyboardUI.parent){
				keyboardUI = Creator.creatSignKeyboard();	
				Global.stage.addChild(keyboardUI);	
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}
		}
		/*
		* *---------------切换到英文键盘------------------*/
		private function changeTo_US_KEYBOARD():void{
			if(keyboardUI.type != KeyboardType.US_KEYBOARD){//如果当前不是英文键盘
				if(keyboardUI.parent){
					keyboardUI.parent.removeChild(keyboardUI);
				}
				keyboardUI = Creator.creatUSKeyboard();				
				Global.stage.addChild(keyboardUI);
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}else if(!keyboardUI.parent){//是英文键盘，但是未添加到舞台时
				keyboardUI = Creator.creatUSKeyboard();	
				Global.stage.addChild(keyboardUI);		
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}
		}
		/*
		* *---------------切换到简易键盘------------------*/
		private function changeTo_Simple_KEYBOARD():void{
			if(keyboardUI.type != KeyboardType.SIMPLE_KEYBOARD){
				if(keyboardUI.parent){
					keyboardUI.parent.removeChild(keyboardUI);
				}
				keyboardUI = Creator.creatSimpleKeyboard();				
				Global.stage.addChild(keyboardUI);
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}else if(!keyboardUI.parent){
				keyboardUI = Creator.creatSimpleKeyboard();	
				Global.stage.addChild(keyboardUI);
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}
		}
		
		/*
		* *---------------切换到方向键盘------------------*/
		private function changeTo_Aspect_KEYBOARD():void{
			if(keyboardUI.type != KeyboardType.ASPECT_KEYBOARD){
				if(keyboardUI.parent){
					keyboardUI.parent.removeChild(keyboardUI);
				}
				keyboardUI = Creator.creatAspectKeyboard();				
				Global.stage.addChild(keyboardUI);
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}else if(!keyboardUI.parent){
				keyboardUI = Creator.creatAspectKeyboard();	
				Global.stage.addChild(keyboardUI);
				if(hasBackgroundColor){
					keyboardUI.backgroundColor = backgroundColor;
				}
			}
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [KeyBoardConst.CHANGE_KEYBORD,
				SoftKeyBoardConst.USE_KEYBOARD_CHINESE,
				SoftKeyBoardConst.KEYBOARD_HASBG,
				SoftKeyBoardConst.INSERT_CHINESE,
				SoftKeyBoardConst.RESET_SORFTKEYBOARD,
				SoftKeyBoardConst.HIDE_SOFTKEYBOARD,
				SoftKeyBoardConst.USE_ASPECT_KEYBOARD,
				SoftKeyBoardConst.USE_SIMPLE_KEYBOARD];
		}
		
		
		

									
		
						
	}
}
