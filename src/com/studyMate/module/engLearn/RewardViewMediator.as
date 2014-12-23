package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.component.SalvoComponent;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.CleanGpuMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.effects.RewardPaper;
	import com.studyMate.world.screens.effects.RewardStar;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	
	import flash.filters.GlowFilter;
	import flash.globalization.DateTimeFormatter;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	/**
	 * 奖励界面
	 * 传入参数：data:Object<br><br>
	 * 范例：<br /><br /><code>
	 * var data:Object={right:20,wrong:0,gold:350,time:3700};
	 * </code><br><br>
	 * <ul><li><b> right </b>-答对题数 </li>
	 * <li><b> wrong </b>-打错题数 </li>
	 * <li><b> gold </b>-奖励金币数 </li>
	 * <li><b> time </b>-本次学习所用时间,单位s </li></ul><br>
	 * 
	 * @author lsj
	 * 
	 */
	internal class RewardViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "RewardViewMediator";
		
		private const yesQuitHandler:String = NAME + "yesQuitHandler";
		private var score:Array;
		
		private var scoreField:TextField;
		
		private var bgHolder:Sprite;
		private var goldHolder:Sprite;
		private var itemHolder:Sprite;
		private var starHolder:Sprite;
		
		private var rewardStar:RewardStar;
		private var rewardPaper:RewardPaper;
		private var starNum:Number;

		private var bgTexture:Texture;
		
		private var right:int;
		private var wrong:int;
		private var gold:int;
		private var time:int;
		
		public function RewardViewMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{	
			rewardPaper.dispose();
			rewardStar.dispose();
			bgTexture.dispose();
			TweenLite.killDelayedCallsTo(start);
			bgHolder.removeChildren(0,-1,true);
			goldHolder.removeChildren(0,-1,true);
			itemHolder.removeChildren(0,-1,true);
			starHolder.removeChildren(0,-1,true);
			
			TweenLite.killTweensOf(score);
			TweenMax.killAll(true);
		}
		
		private var vo:SwitchScreenVO;
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
//			trace("right:"+vo.data.right+"====wrong:"+vo.data.wrong+"====gold:"+vo.data.gold+"====useDate:"+vo.data.date);
			right = vo.data.right;
			wrong = vo.data.wrong;
			gold = vo.data.gold;
			time = vo.data.time;
			
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRegister():void
		{	
			sendNotification(WorldConst.POP_SCREEN_DATA);
			bgHolder = new Sprite();
			view.addChild(bgHolder);
			
			goldHolder = new Sprite();
			view.addChild(goldHolder);
			
			itemHolder = new Sprite();
			view.addChild(itemHolder);
			
			//纸屑在礼炮喷完后出现
			rewardPaper = new RewardPaper;
			TweenLite.delayedCall(8,start);

			
			starHolder = new Sprite();
			view.addChild(starHolder);
			
			//粒子效果的小星星
			rewardStar = new RewardStar;
			rewardStar.x = 600;
			rewardStar.y = 150;
			view.addChild(rewardStar);
			
			var tmpNum:int = 0;
			var starImg:Image;
			if(right!=-1){
				var percent:Number = right/(right+wrong);//解决整形赋值时的bug。
				if(isNaN(percent)){
					starNum = 1;//当right+wrong为0时。除零结果为NaN
				}else{
					var score:int = percent*100;
					starNum = MyUtils.getRewardStar(score);
					
					
					//如果是整数，直接加星星
					if(starNum is int){
						tmpNum = starNum;
						
					}else{
						tmpNum = Math.floor(starNum);
						
						starImg = new Image(Assets.getAtlasTexture("reward/star1"));
						starImg.pivotX = starImg.width>>1;
						starImg.x = (Global.stageWidth>>1)+(tmpNum-1)*162;
						starImg.y = 473;
						starHolder.addChild(starImg);
						TweenMax.from(starImg,0.5,{delay:0.6*tmpNum+((gold/30)+0.3),x:starImg.x+(tmpNum-1)*starImg.width,y:-500,scaleX:1.5,scaleY:1.5,ease:Elastic.easeOut});
					}
					
					
				}
				
			}else{
				starNum=3;
			}
			

			createBg();
			createGoldHolder();
			createItemHolder();
			
			for (var i:int = 0; i < tmpNum; i++) 
			{
				starImg = new Image(Assets.getAtlasTexture("reward/star"));
				starImg.pivotX = starImg.width>>1;
				starImg.x = (Global.stageWidth>>1)+(i-1)*162;
				starImg.y = 473;
				starHolder.addChild(starImg);
				TweenMax.from(starImg,0.5,{delay:0.6*i+((gold/30)+0.3),x:starImg.x+(i-1)*starImg.width,y:-500,scaleX:1.5,scaleY:1.5,ease:Elastic.easeOut});
			}
			
			
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
		}
		
		private function start():void
		{
			// TODO Auto Generated method stub
			rewardPaper.x = 600;
			rewardPaper.y = 150;
			bgHolder.addChild(rewardPaper);
		}
		
		//初始化背景、 答对及打错信息、 任务耗时
		private function createBg():void{
			view.stage.color = 0xfdf1cc;
			bgTexture = Texture.fromBitmap(Assets.store["awardBg"],false,false);
			var bg:Image = new Image(bgTexture);
			bg.alpha = 0.5;
			bg.pivotX = bg.width>>1;
			bg.pivotY = bg.height>>1;
			bg.x = Global.stageWidth>>1;
			bg.y = 200;
			bgHolder.addChild(bg);
			TweenMax.to(bg,15,{rotation:Math.PI*2,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			
			//礼炮特效
			var salvo1:SalvoComponent = new SalvoComponent();
			salvo1.x = 140;
			salvo1.y = -30;
			var salvo2:SalvoComponent = new SalvoComponent();
			salvo2.x = 165;
			salvo2.y = -20;
			salvo2.scaleX = 0.6;
			salvo2.scaleY = 0.6;
			salvo2.rotation = 1.5;
			bgHolder.addChild(salvo1);
			bgHolder.addChild(salvo2);
			
			
			var texture:Texture;
			
			texture = Assets.getAtlasTexture("reward/goodBg");
			var goodBg:Image = new Image(texture);
			goodBg.x = (Global.stageWidth - goodBg.width)>>1;
			goodBg.y = 30;
			bgHolder.addChild(goodBg);
			TweenMax.from(goodBg,(gold/30)+0.2,{delay:0.1,x:180,y:110,scaleX:0,scaleY:0,ease:Elastic.easeOut});
			
			
			texture = Assets.getAtlasTexture("reward/good");
			var goodImg:Image = new Image(texture);
			goodImg.x = 550+(goodImg.width>>1);
			goodImg.y = 45+goodImg.height;
			goodImg.pivotX = goodImg.width>>1;
			goodImg.pivotY = goodImg.height;
			bgHolder.addChild(goodImg);
			var delayTime:Number = 0.6*starNum+((gold/30)+0.3);
			TweenMax.from(goodImg,0.5,{delay:delayTime,scaleX:0,scaleY:0,ease:Elastic.easeOut});
			TweenMax.to(goodImg,0.8,{delay:delayTime+0.5,rotation:-0.1,yoyo:true,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			
			var goodText:TextField = new TextField(520,110,"你真棒！","HuaKanT",95);
			goodText.color = 0xffef69;
			goodText.nativeFilters = [new GlowFilter(0x914824,1,10,10,20)];
			goodText.hAlign = HAlign.LEFT;
			goodText.x = 500;
			goodText.y = 324;
			goodText.alpha = 0;
			bgHolder.addChild(goodText);
			TweenMax.from(goodText,0.1,{delay:delayTime+0.5,x:0,y:0,scaleX:5,scaleY:5,ease:Linear.easeNone});
			TweenMax.to(goodText,0,{delay:delayTime+0.5,alpha:1});
			
			texture = Assets.getAtlasTexture("reward/light2");
			var lightImg:Image;
			var scaleNum:Number;
			for(var i:int=0;i<10;i++){
				lightImg = new Image(texture);
				scaleNum = Math.random();
				lightImg.scaleX = scaleNum;
				lightImg.scaleY = scaleNum;
				lightImg.x = Math.random()*500+350;
				lightImg.y = Math.random()*480+13;
				bgHolder.addChild(lightImg);
				
				TweenMax.to(lightImg,1,{delay:i*0.3,alpha:0,yoyo:true,repeat:int.MAX_VALUE});
			}
			
			
			
			texture = Assets.getAtlasTexture("reward/right");
			var rightImg:Image = new Image(texture);
			rightImg.x = 25;
			rightImg.y = 410;
			bgHolder.addChild(rightImg);
			
			texture = Assets.getAtlasTexture("reward/textBg");
			var textBg:Image;
			var text:TextField;
			textBg = new Image(texture);
			textBg.x = 146;
			textBg.y = 415;
			bgHolder.addChild(textBg);
			
			text = new TextField(106,60,right.toString(),"HeiTi",38);
			if(right==-1){
				text.text = "";
			}
			text.color = 0xffc9e1;
			text.x = 155;
			text.y = 421;
			bgHolder.addChild(text);

			var textTimeTitle:TextField = new TextField(110,47,"time","HeiTi",43);
			textTimeTitle.color = 0xff905a;
			textTimeTitle.nativeFilters = [new GlowFilter(0x847065,1,5,5,20)];
			textTimeTitle.hAlign = HAlign.LEFT;
			textTimeTitle.x = 33;
			textTimeTitle.y = 634;
			bgHolder.addChild(textTimeTitle);
			
			var textTime:TextField = new TextField(340,47,getTimeFormat(time),"HeiTi",43);
			textTime.color = 0xf4ebd3;
			textTime.nativeFilters = [new GlowFilter(0x847065,1,5,5,20)];
			textTime.hAlign = HAlign.LEFT;
			textTime.x = 33;
			textTime.y = 692;
			bgHolder.addChild(textTime);
		}
		//初始化金币
		private function createGoldHolder():void{
			var texture:Texture;
			
			var goldImg:Image;
			for(var i:int=0;i<4;i++){
				texture = Assets.getAtlasTexture("reward/gold"+i);
				goldImg = new Image(texture);
				switch(i){
					case 0:
						goldImg.x = 43;
						goldImg.y = 525;
						break;
					case 1:
						goldImg.alpha = 0;
						goldImg.x = 46;
						goldImg.y = 548;
						break;
					case 2:
						goldImg.alpha = 0;
						goldImg.x = 45;
						goldImg.y = 538;
						break;
					case 3:
						goldImg.alpha = 0;
						goldImg.x = 88;
						goldImg.y = 548;
						break;
				}
				goldHolder.addChild(goldImg);
				if(i!=0){
					TweenMax.from(goldImg,0.5,{delay:1+(i-1)*0.2,x:goldImg.x-goldImg.width,y:goldImg.y-goldImg.height,scaleY:-1});
					TweenMax.to(goldImg,0,{delay:1+(i-1)*0.2,alpha:1});
				}
			}
	
			texture = Assets.getAtlasTexture("reward/light");
			var lightImg:Image;
			var scaleNum:Number;
			for(i=0;i<8;i++){
				lightImg = new Image(texture);
				scaleNum = (Math.round(Math.random()*3)+10)*0.1;
				lightImg.scaleX = scaleNum;
				lightImg.scaleY = scaleNum;
				lightImg.x = Math.random()*120+25;
				lightImg.y = Math.random()*54+500;
				goldHolder.addChild(lightImg);
				
				TweenMax.to(lightImg,1,{delay:i*0.3,alpha:0,yoyo:true,repeat:int.MAX_VALUE});
			}
			

			//金币计数
			score = [0];
			scoreField = new TextField(80,42,"000","HeiTi",38);
			scoreField.color = 0xffc028;
			scoreField.nativeFilters = [new GlowFilter(0x965a36,1,6,6,23)];
			scoreField.hAlign = HAlign.LEFT;
			scoreField.x = 170;
			scoreField.y = 530;
			goldHolder.addChild(scoreField);
			
			TweenLite.to(score,gold/30,{delay:0.3,endArray:[gold],onUpdate:report});
		}
		//初始化表扬动画
		private function createGoodHolder():void{
			
			
		}
		//初始化按钮
		private function createItemHolder():void{
			var texture:Texture;
			var itemBtn:Button;
			for(var i:int=0;i<3;i++){
				if(i==0){
					texture = Assets.getAtlasTexture("reward/shop");
					itemBtn = new Button(texture);//问号
					itemBtn.name = "shop";
				}else if(i==1){
					texture = Assets.getAtlasTexture("reward/menu");
					itemBtn = new Button(texture);//问号
					itemBtn.name = "menu";
				}else{
					texture = Assets.getAtlasTexture("reward/next");
					itemBtn = new Button(texture);//问号
					itemBtn.name = "next";
				}
				
				itemBtn.pivotX = itemBtn.width>>1;
				itemBtn.x = (Global.stageWidth>>1)+(i-1)*180;
				itemBtn.y = 650;
				itemHolder.addChild(itemBtn);
				
				itemBtn.addEventListener(TouchEvent.TOUCH,itemHandle);
			}
		}
	
		
		private var beginX:Number;
		private var endX:Number;
		private function itemHandle(event:TouchEvent):void{
			var btn:Button = event.currentTarget as Button;
			var touchPoint:Touch = event.getTouch(btn);			
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 50){
//						trace("进入！"+btn.name);
						switch(btn.name){
							case "shop":
								break;
							case "menu":
								sendNotification(WorldConst.SHOW_MAIN_MENU);
								sendNotification(WorldConst.POP_SCREEN);
								
								break;
							case "next":
//								trace("下一题任务"+this.vo.data.rrl);
								nextHandler();
								break;
						}						
						
						
					}
				}
			}
		}
		public function nextHandler():void{
			var data:Object={}
			sendNotification(WorldConst.POP_SCREEN_DATA);
			if(this.vo.data.rrl.indexOf("yy.R")!=-1){//获取阅读任务id
				data.rrl = this.vo.data.rrl;
				nextPrepare();
				sendNotification(WorldConst.ADD_GPU_SCREEN_DATA,new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.R"}));
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadBGMediator,data),new SwitchScreenVO(CleanCpuMediator)]);
			}else if(this.vo.data.rrl.indexOf("yy.E")!=-1){//获取习题任务id
				data.rrl = this.vo.data.rrl;
				nextPrepare();
				sendNotification(WorldConst.ADD_GPU_SCREEN_DATA,new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.E"}));
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExercisesLearnMediator,data)]);
				/*习题任务*/				
			}else if(this.vo.data.rrl.indexOf("yy.P")!=-1){//获取知识点任务id
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n知识点暂未开放,\n单击确定返回",false,yesQuitHandler));//提交订单
			}else if(this.vo.data.rrl.indexOf("yy.W")!=-1){//学单词任务;
				data.rrl = this.vo.data.rrl;							
				nextPrepare();
				sendNotification(WorldConst.ADD_GPU_SCREEN_DATA,new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.W"}));
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WordLearningBGMediator,data),new SwitchScreenVO(CleanCpuMediator)]);
			}else if(this.vo.data.rrl.indexOf("@y.O")!=-1){//口语任务
				data.rrl = this.vo.data.rrl;
				data.oralid = this.vo.data.oralid;
				nextPrepare();
				sendNotification(WorldConst.ADD_GPU_SCREEN_DATA,new SwitchScreenVO(TaskListSpokenMeidator));
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenNewMediator,data)]);
			}else if(this.vo.data.rrl.indexOf("yy.D")!=-1){//获取知识点任务id
				data.rrl = this.vo.data.rrl;							
				nextPrepare();
				sendNotification(WorldConst.ADD_GPU_SCREEN_DATA,new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.D"}));
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadAloudBGMediator,data),new SwitchScreenVO(CleanCpuMediator)]);
			}
			else{							
				if(facade.hasMediator(MusicSoundMediator.NAME)){
					facade.removeMediator(MusicSoundMediator.NAME);
				}
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n恭喜你已完成今天所有任务啦！",false,yesQuitHandler));//提交订单
			}			
		}
		
		private function nextPrepare():void{
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.POP_SCREEN_DATA);
			sendNotification(WorldConst.ADD_CPU_SCREEN_DATA,new SwitchScreenVO(CleanCpuMediator));
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case yesQuitHandler:
					/*if(Global.currentScreen!=""){
						sendNotification(WorldConst.POP_SCREEN_DATA);
						sendNotification(WorldConst.ADD_CPU_SCREEN_DATA)
						sendNotification(WorldConst.ADD_GPU_SCREEN_DATA,[new SwitchScreenVO(TaskListMediator,{taskStyle:Global.currentScreen}),new SwitchScreenVO(CleanCpuMediator)]);	
						
					}*/
					sendNotification(WorldConst.SHOW_MAIN_MENU);
						sendNotification(WorldConst.POP_SCREEN);
					
					break;
			}
		}
		override public function listNotificationInterests():Array{	
			return [yesQuitHandler];
		}

		private function getTimeFormat(time:int):String {
			var hour:int = time/3600;
			var minute:int = (time%3600)/60;
			var second:int = (time%3600)%60;

			
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("HH-mm-ss");
			
			var date:Date = new Date(null,null,null,hour,minute,second);//这里不要修改。有用的
			
			return dateFormatter.format(date); //添加年月日为了方便转换时间格式，实际没意义
		}
		
		private function report():void{
			scoreField.text = int(score[0]).toString();
		}
	}
}