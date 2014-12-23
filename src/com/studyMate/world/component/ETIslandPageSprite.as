package com.studyMate.world.component
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.ETIslandPageSpVO;
	import com.studyMate.world.screens.CleanCpuMediator;
	
	import flash.filters.GlowFilter;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.Juggler;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class ETIslandPageSprite extends Sprite
	{
		
		private var texture:Texture;
		
		private var juggler:Juggler;
		private var sun:MovieClip;
		
		private var etislandPageSpVo:ETIslandPageSpVO;
		private var titleBtn:Button;
		private var finger:Image;
		
		private var totalNum:int = 0;
		private var finishNum:int = 0;
		
		private var oneStarNum:int = 0;
		private var twoStarNum:int = 0;
		private var thrStarNum:int = 0;

		public function ETIslandPageSprite(_juggler:Juggler,_etislandPageSpVo:ETIslandPageSpVO)
		{
			this.juggler = _juggler;
			this.etislandPageSpVo = _etislandPageSpVo;
			
			totalNum = etislandPageSpVo.stateList.length;
			for(var i:int=0;i<totalNum;i++){
				if(etislandPageSpVo.stateList[i] == "E"){
					finishNum++;
					
					if(int(etislandPageSpVo.levelList[i]) >= 90)
						thrStarNum++;
					else if(int(etislandPageSpVo.levelList[i]) >= 80)
						twoStarNum++;
					else
						oneStarNum++;
				}
			}
			
			init();
		}
		
		private function init():void{
			if(etislandPageSpVo.taskType == "yy.W")
				texture = Assets.getTexture("EngTaskIsland_PageBg01");
			else
				texture = Assets.getTexture("EngTaskIsland_PageBg02");
			var bg:Image = new Image(texture);
			bg.x = 60;
			addChild(bg);
			
			
			sun = new MovieClip(Assets.getEngTaskIslandAtlas().getTextures("ETI_Sun"),3);
			sun.x = bg.width - sun.width - 25 + 60;
			sun.y = 25;
			sun.setFrameDuration(0,2);
			juggler.add(sun);
			addChild(sun);
			
			
			if(etislandPageSpVo.taskType == "yy.W"){
				titleBtn = new Button(Assets.getEngTaskIslandTexture("ETI_Title_W"));
				titleBtn.name = "yy.W";
			}else if(etislandPageSpVo.taskType == "yy.R"){
				titleBtn = new Button(Assets.getEngTaskIslandTexture("ETI_Title_R"));
				titleBtn.name = "yy.R";
			}
			titleBtn.x = 540;
			titleBtn.y = 125;
			addChild(titleBtn);
			titleBtn.addEventListener(Event.TRIGGERED,titleBtnHandle);
			
			finger = new Image(Assets.getAtlasTexture("targetWall/hand"));
			finger.touchable = false;
			addChild(finger);
			finger.x = 730; finger.y = 200;
			TweenMax.to(finger, 0.5, {x:723, y:207, yoyo:true,repeat:int.MAX_VALUE});
			
//			createCoin();
			createCoinCount();
			
			createTaskAllState();
			
			var stateNumTF:TextField = new TextField(170,60,finishNum+"/"+totalNum,"HeiTi",43,0xffffff,true);
			stateNumTF.nativeFilters = [new GlowFilter(0,1,5,5,20)];
			stateNumTF.hAlign = HAlign.CENTER;
			stateNumTF.x = 600;
			stateNumTF.y = 433;
			addChild(stateNumTF);
		}
		private function titleBtnHandle(event:Event):void{
			//进入学单词
			if((event.target as Button).name == "yy.W"){
//				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
//					[new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.W"}),new SwitchScreenVO(CleanCpuMediator)]);
				
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
					[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.W"}),new SwitchScreenVO(CleanCpuMediator)]);
				
			}else if((event.target as Button).name == "yy.R"){
				//进入阅读
//				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
//					[new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.R"}),new SwitchScreenVO(CleanCpuMediator)]);
				
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
					[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.R"}),new SwitchScreenVO(CleanCpuMediator)]);
			}
		}
		
		private function createCoinCount():void{
			var coinImg:Image;
			
			for(var i:int=0;i<4;i++){
				coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_State0"+i));
				coinImg.x = 210;
				coinImg.y = 130 + 55*i;
				addChild(coinImg);
			}
			
			
			var coinCountTF:TextField
			for(i=0;i<4;i++){
				coinCountTF = new TextField(200,43,"","HeiTi",38,0xffffff);
				coinCountTF.hAlign = HAlign.LEFT;
				coinCountTF.x = 350;
				coinCountTF.y = 125 + 55*i;
				switch(i){
					case 0:
						coinCountTF.text = "x "+(totalNum-finishNum);
						break;
					case 1:
						coinCountTF.text = "x "+oneStarNum;
						break;
					case 2:
						coinCountTF.text = "x "+twoStarNum;
						break;
					case 3:
						coinCountTF.text = "x "+thrStarNum;
						break;
				}
				addChild(coinCountTF);
			}
			
			
		}
		
		private function createCoin():void{
			var coinImg:Image;
			
			for(var i:int=0;i<totalNum;i++){
				//未开始
				if(etislandPageSpVo.stateList[i] == "S"){
					coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_State00"));
				}else if(etislandPageSpVo.stateList[i] == "E"){
					//任务完成
					if(int(etislandPageSpVo.levelList[i]) >= 90)
						//大于等于90分，三星
						coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_State03"));
					else if(int(etislandPageSpVo.levelList[i]) >= 80)
						//大于等于80分，两星
						coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_State02"));
					else
						//小于80分，两星
						coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_State01"));

				}
				
//				coinImg.x = 130 + 70*(i%5) + 25*(int(i/5));
				coinImg.x = 130 + 70*(i%5)
				
				coinImg.y = 130 + 50*(int(i/5));
				
				
				addChild(coinImg);
			}
		}
		
		private function createTaskAllState():void{
			
			var endPercent:Number = finishNum/totalNum;
			
			if(endPercent == 0){
				//0星
				addChild(getAllStateStar(1));
				addChild(getAllStateStar(2));
				addChild(getAllStateStar(3));
			}else if(endPercent <= 0.5){
				//1星
				addChild(getAllStateStar(1,true));
				addChild(getAllStateStar(2));
				addChild(getAllStateStar(3));
			}else if(endPercent < 1){
				//2星
				addChild(getAllStateStar(1,true));
				addChild(getAllStateStar(2,true));
				addChild(getAllStateStar(3));
			}else{
				//3星
				addChild(getAllStateStar(1,true));
				addChild(getAllStateStar(2,true));
				addChild(getAllStateStar(3,true));
			}
		}
		//添加星星函数
		private function getAllStateStar(_sqe:int,_isHad:Boolean=false):Image{
			var coinImg:Image;
			if(_sqe == 1){
				if(_isHad)
					coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_AllState01"));
				else
					coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_AllState00"));
				centerPivot(coinImg);
				coinImg.x = 585+(coinImg.width>>1);
				coinImg.y = 382+(coinImg.height>>1);
				coinImg.rotation = 2;
			}else if(_sqe == 2){
				if(_isHad)
					coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_AllState11"));
				else
					coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_AllState10"));
				centerPivot(coinImg);
				coinImg.x = 638+(coinImg.width>>1);
				coinImg.y = 343+(coinImg.height>>1);
			}else if(_sqe == 3){
				if(_isHad)
					coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_AllState01"));
				else
					coinImg = new Image(Assets.getEngTaskIslandTexture("ETI_Task_AllState00"));
				centerPivot(coinImg);
				coinImg.x = 720+(coinImg.width>>1);
				coinImg.y = 382+(coinImg.height>>1);
				coinImg.rotation = -2;
			}
			return coinImg;
		}
		
		
		
		
		
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			titleBtn.removeEventListener(Event.TRIGGERED,titleBtnHandle);
			TweenLite.killTweensOf(finger);
			
			etislandPageSpVo = null;
			Assets.disposeTexture("ETI_Task_State00");
			Assets.disposeTexture("ETI_Task_State01");
			Assets.disposeTexture("ETI_Task_State02");
			Assets.disposeTexture("ETI_Task_State03");
			Assets.disposeTexture("ETI_Task_AllState00");
			Assets.disposeTexture("ETI_Task_AllState01");
			Assets.disposeTexture("ETI_Task_AllState10");
			Assets.disposeTexture("ETI_Task_AllState11");
			
			texture.dispose();
			juggler.remove(sun);
			
			removeChildren(0,-1,true);
		}

	}
}