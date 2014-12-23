package com.studyMate.module.engLearn.reward.TextLayer
{
	import com.studyMate.global.Global;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	/**
	 * 2棵星的情况
	 * 2014-12-9下午4:48:05
	 * Author wt
	 *
	 */	
	
	public class RewardTxt_2_0 extends Sprite implements IRewardTxt
	{
		public function RewardTxt_2_0()
		{
			var img:Image = new Image(Assets.getRewardTexture("tip4"));
			this.addChild(img);
			
			this.x = (Global.stageWidth - img.width)>>1;
			this.y = 612;
		}
	}
}