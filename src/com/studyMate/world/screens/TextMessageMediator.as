package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.MessageVO;
	
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollText;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class TextMessageMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "TextMessageMediator";
		private var vo:SwitchScreenVO;
		private var msg:MessageVO;
		
		private var msgTextField:TextField;
//		private var parNameTextFld:TextField;
//		private var timeTextFld:TextField;
		private var msgTextField2:ScrollText;
		
		public function TextMessageMediator(mviewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			this.msg = vo.data as MessageVO;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		override public function onRegister():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.HIDE_TALKINGBOX);
			
			var img:Image = new Image(Assets.getTexture("MessagePaper"));
			view.addChild(img);
			img.x = 137; img.y = 80;
			
			var quad:Quad = new Quad(85,85,0);
			quad.alpha = 0;
			quad.x = 20; quad.y = 200;
			view.addChild(quad);
			
			/*var userName:TextField = new TextField(181, 42, Global.player.name, "HuaKanT", 24, 0x8e5841, true);
			view.addChild(userName);
			userName.x = 321; userName.y = 155;*/
			
			msgTextField2 = new ScrollText();
			msgTextField2.isHTML = true;
			msgTextField2.text = "<p><font color='#6d4a2e' size='20'>" + Global.player.name + "</font></p><br/><p>       ";
			msgTextField2.text += msg.msgText;
			msgTextField2.text += "</p><br/><br/><font color='#6d4a2e' size='20'><p align = 'right'>" + msg.sopcode + "</p><p align = 'right'>" + msg.maketime.substr(0,4) + "-" + msg.maketime.substr(4,2) + "-" + msg.maketime.substr(6,2) +"</p></font>";
			view.addChild(msgTextField2);
			msgTextField2.x = 262; msgTextField2.y = 171;
			msgTextField2.width = 914; msgTextField2.height = 460;
			
			var mainFormat:TextFormat = new TextFormat();
			mainFormat.size = 20; mainFormat.color = 0x8e5841;
			msgTextField2.textFormat = mainFormat;
			
			/*parNameTextFld = new TextField(164, 20, msg.sopcode, "HeiTi", 20, 0x8e5841);
			parNameTextFld.x = 871; parNameTextFld.y = 436;
			view.addChild(parNameTextFld);*/
			
			/*timeTextFld = new TextField(164, 20, msg.maketime.substr(0,4) + "-" + msg.maketime.substr(4,2) + "-" + msg.maketime.substr(6,2), "HeiTi", 20, 0x8e5841);
			timeTextFld.x = 871; timeTextFld.y = 470;
			view.addChild(timeTextFld);*/
			
			var texture:Texture = Assets.getAtlasTexture("flip/closeGuide");
			var closeBtn:starling.display.Button = new starling.display.Button(texture);
			closeBtn.x = 1209; closeBtn.y = 94;
			closeBtn.addEventListener(TouchEvent.TOUCH, onCloseBtnHandler);
			view.addChild(closeBtn);
			
		}
		
		private function onCloseBtnHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
//				sendNotification(EnglishIslandMediator.FINISH_MESSAGE,true);
				vo.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
			}
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
	}
}