package com.studyMate.module.engLearn.reward
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.studyMate.module.engLearn.vo.RewardVO;
	import com.studyMate.utils.MyUtils;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	
	/**
	 * 奖励文字和星星
	 * 2014-12-9下午5:02:29
	 * Author wt
	 */	
	
	internal class StarLevelUI extends Sprite
	{
		private var glodTxt:TextField;
		private var countTxt:TextField;
		private var timeTxt:TextField;
		
		public function StarLevelUI()
		{
			var bg:Image = new Image(Assets.getRewardTexture("centerBg"));
			addChild(bg);
			bg.x = 318;
			bg.y = 70;
			
			glodTxt = new TextField(74,40,"","HeiTi",20,0x914824,true);
			countTxt = new TextField(97,40,"","HeiTi",20,0x914824,true);
			timeTxt = new TextField(110,40,"","HeiTi",20,0x914824,true);
			
			glodTxt.x = 460;
			glodTxt.y = 493;
			countTxt.x = 601;
			countTxt.y = 493;
			timeTxt.x = 751;
			timeTxt.y = 493;
			
			addChild(glodTxt);
			addChild(countTxt);
			addChild(timeTxt);			
		}		
		
		public function showPlay(vo:RewardVO):void{
			glodTxt.text = vo.gold.toString();
			countTxt.text = vo.right+"/"+vo.total;
			timeTxt.text = vo.time.toString();
			showStar(vo.right,vo.total);
		}
		
		private var starNum:Number;
		private function showStar(right:int,total:int):void{
			var tmpNum:int = 0;
			var starImg:Image;
			if(right!=-1){
				var percent:Number = right/total;//解决整形赋值时的bug。
				if(isNaN(percent)){
					starNum = 1;//当right+wrong为0时。除零结果为NaN
				}else{
					var score:int = percent*100;
					starNum = MyUtils.getRewardStar(score);
					
					trace("starNum",starNum);
					//如果是整数，直接加星星
					if(starNum is int){
						tmpNum = starNum;
						
					}else{
						tmpNum = Math.floor(starNum);
						starImg = new Image(Assets.getRewardTexture("halfStar"));
						starImg.pivotX = starImg.width>>1;
						setPosition(tmpNum,starImg);
						this.addChild(starImg);
						TweenMax.from(starImg,0.5,{delay:0.6*tmpNum,scaleX:5,scaleY:5,alpha:0,ease:Back.easeOut});
					}		
				}
			}else{
				starNum = 3;
			}
			trace("tmpNum",tmpNum);
			for (var i:int = 0; i < tmpNum; i++) 
			{
				starImg = new Image(Assets.getRewardTexture("star"));
				starImg.pivotX = starImg.width>>1;
				setPosition(i,starImg);
				this.addChild(starImg);
				TweenMax.from(starImg,0.5,{delay:0.6*i,scaleX:5,scaleY:5,alpha:0,ease:Back.easeOut});
			}
		}
		
		private function setPosition(index:int,obj:DisplayObject):void{
			if(index==0){
				obj.x = 498;
				obj.y = 86;
			}else if(index==1){
				obj.x = 638;
				obj.y = 71;
			}else if(index==2){
				obj.x = 779;
				obj.y = 81;
			}
			
		}
	}
}