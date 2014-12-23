package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.vo.RegisterVO;
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.Button;
	import feathers.controls.NumericStepper;
	import feathers.controls.Radio;
	import feathers.controls.TextInput;
	import feathers.core.ToggleGroup;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import com.studyMate.utils.MyUtils;

	public class RegisterUserMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "RegisterUserMediator";
		
		private var loginName:flash.text.TextField;
		private var password:flash.text.TextField;
		private var rePassword:flash.text.TextField;
		private var realName:flash.text.TextField;
		private var nickName:flash.text.TextField;
		private var telephone:flash.text.TextField;
		private var birYear:NumericStepper;
		private var birMonth:NumericStepper;
		private var birDay:NumericStepper;
		private var entranceAge:NumericStepper;
		private var sex:ToggleGroup;
		private var male:Radio;
		private var female:Radio;
		
		public function RegisterUserMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void
		{
			facade.registerMediator(new RegisterDataMediator());
			addBGImage();
			addBaseInfoInput();
			addPerInfoInput();
			addPerInfoSelect();
			setTheme();
			addButton();
		}
		
		override public function onRemove():void
		{
			if(loginName){
				Starling.current.nativeOverlay.removeChild(loginName);
			}
			if(password){
				Starling.current.nativeOverlay.removeChild(password);
			}
			if(rePassword){
				Starling.current.nativeOverlay.removeChild(rePassword);
			}
			if(realName){
				Starling.current.nativeOverlay.removeChild(realName);
			}
			if(nickName){
				Starling.current.nativeOverlay.removeChild(nickName);
			}
			if(telephone){
				Starling.current.nativeOverlay.removeChild(telephone);
			}
			facade.removeMediator(RegisterDataMediator.NAME);
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case RegisterDataMediator.REGISTER_ERR :
					var errString:String = notification.getBody() as String;
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo(errString, false, null));
					break;
				case RegisterDataMediator.REGISTER_SUCCESS :
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("注册成功,请退出注册.", false, null));
					btn.touchable = false;
					break;
				default : 
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [RegisterDataMediator.REGISTER_ERR, RegisterDataMediator.REGISTER_SUCCESS];
		}
		
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		private function addBGImage():void{
			var bg:Image = new Image(Assets.getTexture("EngTaskIslandBg"));
			bg.touchable = false;
			view.addChild(bg);
			
			bg = new Image(Assets.getTexture("registerInput"));
			bg.x = 232; bg.y = 68;
			bg.touchable = false;
			view.addChild(bg);
			
		}
		
		private function addBaseInfoInput():void{
			var tf:TextFormat = new TextFormat("HeiTi",30,0x969696);
			tf.align = TextFormatAlign.LEFT;
			
			loginName = new TextFieldHasKeyboard();
			loginName.defaultTextFormat = tf;
			loginName.x = 463; loginName.y = 146;
			loginName.type = TextFieldType.INPUT;
			loginName.width = 270; loginName.height = 44;
			loginName.maxChars = 15;
			Starling.current.nativeOverlay.addChild(loginName);
			
			password = new TextFieldHasKeyboard();
			password.displayAsPassword = true;
			password.defaultTextFormat = tf;
			password.x = 463; password.y = 208;
			password.type = TextFieldType.INPUT;
			password.width = 270; password.height = 44;
			password.restrict = "A-Z a-z 0-9";
			password.maxChars = 12;
			Starling.current.nativeOverlay.addChild(password);
			
			rePassword = new TextFieldHasKeyboard();
			rePassword.displayAsPassword = true;
			rePassword.defaultTextFormat = tf;
			rePassword.x = 463; rePassword.y = 270;
			rePassword.type = TextFieldType.INPUT;
			rePassword.width = 270; rePassword.height = 44;
			rePassword.restrict = "A-Z a-z 0-9";
			rePassword.maxChars = 12;
			Starling.current.nativeOverlay.addChild(rePassword);
		}
		
		private function addPerInfoInput():void{
			var tf:TextFormat = new TextFormat(null,30,0x969696);
			tf.align = TextFormatAlign.LEFT;
			
			realName = new TextFieldHasKeyboard();
			realName.defaultTextFormat = tf;
			realName.x = 424; realName.y = 363;
			realName.type = TextFieldType.INPUT;
			realName.width = 176; realName.height = 44;
			realName.maxChars = 20;
			Starling.current.nativeOverlay.addChild(realName);
			
			nickName = new TextFieldHasKeyboard();
			nickName.defaultTextFormat = tf;
			nickName.x = 749; nickName.y = 363;
			nickName.type = TextFieldType.INPUT;
			nickName.width = 257; nickName.height = 44;
			nickName.maxChars = 16;
			Starling.current.nativeOverlay.addChild(nickName);
			
			telephone = new TextFieldHasKeyboard();
			telephone.defaultTextFormat = tf;
			telephone.x = 525; telephone.y = 425;
			telephone.type = TextFieldType.INPUT;
			telephone.width = 177; telephone.height = 44;
			rePassword.restrict = "0-9";
			telephone.maxChars = 11;
			Starling.current.nativeOverlay.addChild(telephone);
		}
		
		private function addPerInfoSelect():void{
			birYear = new NumericStepper();
			birYear.minimum = 1950;
			birYear.maximum = Global.nowDate.fullYear;
			birYear.value = Global.nowDate.fullYear - 12;
			birYear.step = 1;
			birYear.textInputProperties.isEditable = false;
//			birYear.height = 30; 
			birYear.width = 110;
			birYear.x = 448; birYear.y = 492;
			view.addChild(birYear);
			
			birMonth = new NumericStepper();
			birMonth.minimum = 1;
			birMonth.maximum = 12;
			birMonth.value = 1;
			birMonth.step = 1;
			birMonth.textInputProperties.isEditable = false;
//			birMonth.height = 30; 
			birMonth.width = 85;
			birMonth.x = 599; birMonth.y = 492;
			view.addChild(birMonth);
			
			birDay = new NumericStepper();
			birDay.minimum = 1;
			birDay.maximum = 31;
			birDay.value = 1;
			birDay.step = 1;
			birDay.textInputProperties.isEditable = false;
//			birDay.height = 30; 
			birDay.width = 85;
			birDay.x = 719; birDay.y = 492;
			view.addChild(birDay);
			
			entranceAge = new NumericStepper();
			entranceAge.minimum = 3;
			entranceAge.maximum = 12;
			entranceAge.value = 6;
			entranceAge.step = 1;
			entranceAge.textInputProperties.isEditable = false;
//			entranceAge.height = 30; 
			entranceAge.width = 103;
			entranceAge.x = 799; entranceAge.y = 558;
			view.addChild(entranceAge);
			
			sex = new ToggleGroup();
			male = new Radio();
			male.toggleGroup = sex;
			male.name = "M";
			male.x = 435; male.y = 560;
			male.isSelected = true;
			view.addChild(male);
			
			female = new Radio();
			female.toggleGroup = sex;
			female.name = "F";
			female.x = 530; female.y = 560;
			female.isSelected = false;
			view.addChild(female);
		}
		
		private function setTheme():void{
			var quad:Quad = new Quad(1,1,0);
			quad.alpha = 0;
			
			var decrementSkin1:Texture = Assets.getAtlasTexture("decrement1");
			var incrementSkin1:Texture = Assets.getAtlasTexture("increment1");
			var decrementSkin2:Texture = Assets.getAtlasTexture("decrement2");
			var incrementSkin2:Texture = Assets.getAtlasTexture("increment2");
			
//			birYear.textInputFactory = textInputFactory;
//			birYear.customTextInputName = "BirthdayYear";
			birYear.textInputProperties.backgroundSkin = quad;
//			birYear.textInputProperties.@textEditorProperties.fontFamily = "HeiTi";
//			birYear.textInputProperties.@textEditorProperties.fontSize  = 12;
			birYear.textInputProperties.stateToSkinFunction = null;
			birYear.decrementButtonProperties.defaultSkin = new Image(decrementSkin1);
			birYear.incrementButtonProperties.defaultSkin = new Image(incrementSkin1);
			birYear.decrementButtonProperties.minWidth = birYear.decrementButtonProperties.minHeight = 14;
			birYear.incrementButtonProperties.minWidth = birYear.incrementButtonProperties.minHeight = 14;
			birYear.decrementButtonProperties.stateToSkinFunction = null;
			birYear.incrementButtonProperties.stateToSkinFunction = null;
			
			birMonth.textInputProperties.backgroundSkin = quad;
//			birMonth.textInputProperties.@textEditorProperties.fontFamily = "HeiTi";
//			birMonth.textInputProperties.@textEditorProperties.fontSize  = 12;
			birMonth.textInputProperties.stateToSkinFunction = null;
			birMonth.decrementButtonProperties.defaultSkin = new Image(decrementSkin2);
			birMonth.incrementButtonProperties.defaultSkin = new Image(incrementSkin2);
			birMonth.decrementButtonProperties.minWidth = birMonth.decrementButtonProperties.minHeight = 14;
			birMonth.incrementButtonProperties.minWidth = birMonth.incrementButtonProperties.minHeight = 14;
			birMonth.decrementButtonProperties.stateToSkinFunction = null;
			birMonth.incrementButtonProperties.stateToSkinFunction = null;
			
			birDay.textInputProperties.backgroundSkin = quad;
			birDay.textInputProperties.paddingLeft= 10;
			birDay.textInputProperties.width = 46;
			birDay.decrementButtonProperties.defaultSkin = new Image(decrementSkin1);
			birDay.incrementButtonProperties.defaultSkin = new Image(incrementSkin1);
			birDay.decrementButtonProperties.minWidth = birDay.decrementButtonProperties.minHeight = 14;
			birDay.incrementButtonProperties.minWidth = birDay.incrementButtonProperties.minHeight = 14;
			birDay.decrementButtonProperties.stateToSkinFunction = null;
			birDay.incrementButtonProperties.stateToSkinFunction = null;
			
			entranceAge.textInputProperties.backgroundSkin = quad;
			entranceAge.textInputProperties.width = 60;
			entranceAge.textInputProperties.stateToSkinFunction = null;
			entranceAge.decrementButtonProperties.defaultSkin = new Image(decrementSkin1);
			entranceAge.incrementButtonProperties.defaultSkin = new Image(incrementSkin1);
			entranceAge.decrementButtonProperties.minWidth = entranceAge.decrementButtonProperties.minHeight = 14;
			entranceAge.incrementButtonProperties.minWidth = entranceAge.incrementButtonProperties.minHeight = 14;
			entranceAge.decrementButtonProperties.stateToSkinFunction = null;
			entranceAge.incrementButtonProperties.stateToSkinFunction = null;
			
			var radioDefaultSkin:Texture = Assets.getAtlasTexture("defaultRadio");
			var radioSelectSkin:Texture = Assets.getAtlasTexture("selectRadio");
			
			male.defaultSkin = new Image(radioDefaultSkin);
			male.defaultSelectedSkin = new Image(radioSelectSkin);
			male.stateToSkinFunction = null;
			
			female.defaultSkin = new Image(radioDefaultSkin);
			female.defaultSelectedSkin = new Image(radioSelectSkin);
		}
		
		private var btn:starling.display.Button;
		private function addButton():void{
			btn = new starling.display.Button(Assets.getAtlasTexture("config2"));
			btn.x = 831; btn.y = 621;
			view.addChild(btn);
			btn.addEventListener(Event.TRIGGERED, registerBtnHandler);
		}
		
		private function registerBtnHandler(e:Event):void{
			if(checkInput()){
				processInput();
				sendNotification(RegisterDataMediator.REGISTER, registerVO);
			}
		}
		
		private function checkInput():Boolean{
			if(loginName.text == "" || password.text == "" || 
				rePassword.text == "" || realName.text == "" || 
				nickName.text == "" || telephone.text ==""){
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("所有信息都是必要信息，请完成所有信息输入!", false, null));
				return false;
			}
			var reg:RegExp =  /[\一-\龥]/;
			if(reg.test(loginName.text)){
				trace("包含中文");
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("登录账号非法，登陆账号只能为英文字母和数字组合，建议使用QQ号或手机号!", false, null));
				return false;
			}
			if(StringUtil.trim(password.text) != StringUtil.trim(rePassword.text)){
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("两次密码输入不一致!", false, null));
				return false;
			}
			if(StringUtil.trim(password.text).length < 3){
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("密码长度不得小于3!", false, null));
				return false;
			}
			return true;
		}
		
		private var registerVO:RegisterVO;
		private var birthday:String;
		private var sexValue:int;
		private function processInput():void{
			var year:int = birYear.value;
			var month:int = birMonth.value;
			var day:int = birDay.value;
			var birth:Date = new Date(year,month -1,day);
			birthday = MyUtils.dateFormat(birth);
			
			sexValue = sex.selectedIndex;
			if(sexValue == 0){
				sexValue = 1;
			}else{
				sexValue = 0;
			}
			
			var delta:int = entranceAge.value - 6;
			registerVO = new RegisterVO(0,loginName.text,password.text,realName.text,nickName.text,telephone.text,birthday,sexValue,delta);
		}
		
		private function textInputFactory():TextInput{
			var input:TextInput = new TextInput();
			var quad:Quad = new Quad(1,1,0);
			quad.alpha = 0;
			input.backgroundSkin = quad;
			input.textEditorProperties.fontFamily = "HeiTi";
			input.textEditorProperties.fontSize = 12;
			return input;
		}
		
		private function decrement():feathers.controls.Button{
			var btn:feathers.controls.Button = new feathers.controls.Button();
			btn.defaultSkin = new Image(Assets.getAtlasTexture("decrement1"));
			return btn;
		}
		
		private function increment():feathers.controls.Button{
			var btn:feathers.controls.Button = new feathers.controls.Button();
			btn.defaultSkin = new Image(Assets.getAtlasTexture("increment1"));
			btn.stateToSkinFunction = null;
			return btn;
		}
		
	}
}