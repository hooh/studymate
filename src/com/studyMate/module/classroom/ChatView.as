package com.studyMate.module.classroom
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.studyMate.global.AppLayoutUtils;
	
	import feathers.controls.Check;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	internal class ChatView extends Sprite
	{
		public var holder:Sprite;
		public var checkAuto:Check;//是否自动播放语音				
		public var userHolder:Sprite;

		private var showOnlineHolder:Sprite;
		private var onlineImg:Image;
		private var onlineTxt:TextField;

		public function ChatView()
		{
			holder = new Sprite();
			this.addChild(holder);
			
			userHolder = new Sprite();
			userHolder.x = 1193;
			userHolder.y = 6;
			userHolder.touchable = false;
			holder.addChild(userHolder);
			
			checkAuto = new Check();
			checkAuto.label = '自动语音';
			holder.addChild(checkAuto);
			checkAuto.x = 1053;
			checkAuto.y = 14;
//			checkAuto.isSelected = true;

		}
		

		
		//显示提示内容
		public function showTip(value:String):void{
			if(showOnlineHolder == null){
				showOnlineHolder = new Sprite();
				showOnlineHolder.x = 738;
				showOnlineHolder.y = 286;
				showOnlineHolder.touchable = false;
				AppLayoutUtils.gpuLayer.addChild(showOnlineHolder);
				
				onlineImg = new Image(Assets.getCnClassroomTexture("tipEnterBg"));
				showOnlineHolder.addChild(onlineImg);
				onlineTxt = new TextField(334,47,'','HeiTi',40,0xFFFFFF);
				onlineTxt.autoScale = true;
				onlineTxt.x = 31;
				onlineTxt.y = 77;
				showOnlineHolder.addChild(onlineTxt);
			}
			onlineTxt.text = value;
			TweenMax.from(showOnlineHolder,2.5,{alpha:0,yoyo:true,repeat:1,ease:Quint.easeOut,onComplete:HideHandler});
			
		}

		private function HideHandler():void{
			if(showOnlineHolder){
				showOnlineHolder.removeFromParent(true);
				showOnlineHolder = null;
			}
		}
		override public function dispose():void
		{
			if(showOnlineHolder){
				TweenMax.killTweensOf(showOnlineHolder);
				showOnlineHolder.removeFromParent(true);
			}
			super.dispose();
		}
	}
}