package com.studyMate.module.engLearn.reward.TextLayer
{
	import com.studyMate.global.Global;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	/**
	 * note
	 * 2014-12-9下午4:55:01
	 * Author wt
	 *
	 */	
	
	public class RewardTxt_2_1 extends Sprite implements IRewardTxt
	{
		public function RewardTxt_2_1()
		{
			var img:Image = new Image(Assets.getRewardTexture("tip5"));
			this.addChild(img);
			
			this.x = (Global.stageWidth - img.width)>>1;
			this.y = 612;
		}
	}
}