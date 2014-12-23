package com.studyMate.module.engLearn.reward.TextLayer
{
	import com.studyMate.global.Global;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	/**
	 * 一颗星的情况
	 * 2014-12-9下午4:46:58
	 * Author wt
	 *
	 */	
	
	public class RewardTxt_1_0 extends Sprite implements IRewardTxt
	{
		public function RewardTxt_1_0()
		{
			var img:Image = new Image(Assets.getRewardTexture("tip7"));
			this.addChild(img);
			
			this.x = (Global.stageWidth - img.width)>>1;
			this.y = 612;
		}
	}
}