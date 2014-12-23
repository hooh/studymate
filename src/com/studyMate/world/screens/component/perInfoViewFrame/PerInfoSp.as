package com.studyMate.world.screens.component.perInfoViewFrame
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.StudentInfoVO;
	
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import myLib.myTextBase.GpuTextInput;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class PerInfoSp extends Sprite
	{
		private static const NAME:String = "PerInfoSp";
		public static const UPDATE_NICKNAME_COMPLETE:String = NAME + "UpdateNickNameComplete";
		public static const UPDATE_SIGN_COMPLETE:String = NAME + "UpdateSignComplete";
		
		private var stuVo:StudentInfoVO;
		private var gold:String;
		private var charater:ICharater;
		
		private var nNameTF:GpuTextInput;
		private var signTF:GpuTextInput;
		private var oldNName:String = "";
		private var oldSigh:String = "";
		
		public function PerInfoSp(_stuVo:StudentInfoVO,_gold:String)
		{
			super();
			
			stuVo = _stuVo;
			gold = _gold;
			oldNName = stuVo.nickName;
			
			var bg:Image = new Image(Assets.getPersonalInfoTexture("tabg_perInfo"));
			bg.x = 58;
			bg.y = 66;
			addChild(bg);
			
			
			
			createHuman();
			createInfo();
			
		}
		private function createHuman():void{
			charater = (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object;
			GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,Global.myDressList,new Rectangle());
			
			charater.view.x = 160;
			charater.view.y = 180;
			charater.view.scaleX = 1.5;
			charater.view.scaleY = 1.5;
			charater.view.alpha = 1;
			addChild(charater.view);
			
			if(stuVo.sex == "0"){
				charater.actor.getProfile().sex = "F";
				charater.sex = "F";
			}else{
				charater.actor.getProfile().sex = "M";
				charater.sex = "M";
			}
		}
		private function createInfo():void{
			//名字、昵称、生日
			var realNameTF:TextField = new TextField(200,30,stuVo.realName,"HeiTi",23,0xffffff);
			realNameTF.x = 355;
			realNameTF.y = 92;
			realNameTF.hAlign = HAlign.LEFT;
			addChild(realNameTF);
			
			nNameTF = new GpuTextInput();
			nNameTF.x = 355;
			nNameTF.y = 145;
			nNameTF.maxChars = 6;
			nNameTF.width = 135; 
			nNameTF.height = 33;
			addChild(nNameTF);
			nNameTF.setTextFormat(new TextFormat("HeiTi",23,0xffffff));
			nNameTF.prompt = "- - - - -";
			nNameTF.text = stuVo.nickName;
			nNameTF.addEventListener(FeathersEventType.ENTER,nNameEnterHandle);
			
			
			var birStr:String = stuVo.birth.substr(0,4)+"-"+stuVo.birth.substr(4,2)+"-"+stuVo.birth.substr(6,2);
			var birthTF:TextField = new TextField(200,30,birStr,"HeiTi",23,0xffffff);
			birthTF.x = 355;
			birthTF.y = 202;
			birthTF.hAlign = HAlign.LEFT;
			addChild(birthTF);
			
			
			//经验、金币
//			var experienTF:TextField = new TextField(130,30,"---/---","HeiTi",23,0xffffff,true);
//			experienTF.x = 135;
/*			var experienTF:TextField = new TextField(130,30,getStandLvl(Global.myLevel)+" 级","HeiTi",23,0xffffff,true);
			experienTF.x = 140;
			experienTF.y = 272;
			experienTF.hAlign = HAlign.LEFT;
			addChild(experienTF);*/
			
			
			var level:TextField = new TextField(130,30,"Lv.","HeiTi",12,0xffffff,true)
			level.x = 90;
			level.y = 275;
			level.nativeFilters = [new GlowFilter(0x004D63,1,3,3,10)];
			level.hAlign = HAlign.LEFT;
			addChild(level);
			
			var levelNum:TextField = new TextField(130,30,String(Math.ceil(Global.myLevel/100)),"HeiTi",22,0xffffff,true);
			levelNum.x = 115;
			levelNum.y = 272;
			levelNum.nativeFilters = [new GlowFilter(0x004D63,1,3,3,10)];
			levelNum.hAlign = HAlign.LEFT;
			addChild(levelNum);

			
			
			var goldTF:TextField = new TextField(130,30,gold,"HeiTi",23,0xffffff,true);
			goldTF.x = 367;
			goldTF.y = 272;
			goldTF.hAlign = HAlign.LEFT;
			addChild(goldTF);
			
			//签名
			signTF = new GpuTextInput;
			signTF.x = 88;
			signTF.y = 375;
			signTF.maxChars = 60;
			signTF.width = 395; 
			signTF.height = 150;
			addChild(signTF);
			signTF.setTextFormat(new TextFormat("HeiTi",23,0));
			signTF.stageTextField.multiline = true;
			signTF.stageTextField.isEditable = true;
			signTF.prompt = "请输入您的个性签名";
			signTF.text = stuVo.sign;
			signTF.addEventListener(FeathersEventType.ENTER,signTFEnterHandle);
			
		}
		private function getStandLvl(_lvl:int):String{
			var lvl:int = 0;
			if(_lvl != 0){
				var p:int = _lvl/100;
				var q:int = _lvl%100;
				
				//能被100整除
				if(q == 0){
					lvl = p;
				}else{
					lvl = p+1;
				}
			}
			return lvl.toString();
		}
		
		
		private function nNameEnterHandle(e:Event):void{
			if(Global.isLoading)
				return;
			
			//昵称不同时，修改昵称
			if(nNameTF.text != oldNName){
				PackData.app.CmdIStr[0] = CmdStr.MODIFY_STUDENT_INFO;
				PackData.app.CmdIStr[1] = stuVo.operId;
				PackData.app.CmdIStr[2] = nNameTF.text;
				PackData.app.CmdIStr[3] = stuVo.realName;
				PackData.app.CmdIStr[4] = stuVo.smsTelNo;
				PackData.app.CmdIStr[5] = stuVo.birth;
				PackData.app.CmdIStr[6] = stuVo.sign;
				PackData.app.CmdInCnt = 7;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(UPDATE_NICKNAME_COMPLETE));
				
			}
		}
		private function signTFEnterHandle(e:Event):void{
			if(Global.isLoading)
				return;
			
			//昵称不同时，修改昵称
			if(signTF.text != oldSigh){
				PackData.app.CmdIStr[0] = CmdStr.UPDATE_STU_SIGN;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = signTF.text;
				PackData.app.CmdInCnt = 3;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(UPDATE_SIGN_COMPLETE));
			}
		}
		
		
		
		
		public function setNName(_success:Boolean):void{
			//修改成功，修改昵称
			if(_success){
				oldNName = nNameTF.text;
				stuVo.nickName = nNameTF.text;;
			}else{
				nNameTF.text = oldNName;
			}
		}
		public function setSigh(_success:Boolean):void{
			//修改成功，修改签名
			if(_success){
				oldSigh = signTF.text;
				stuVo.nickName = signTF.text;
			}else{
				signTF.text = oldSigh;
			}
		}
		
		
		
		override public function dispose():void
		{
			if(charater){
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
				charater = null;
			}
			
			removeChildren(0,-1,true);
			super.dispose();
		}
		
		
		
		
		
	}
}