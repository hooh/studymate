package com.studyMate.world.screens.component
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.controller.vo.RemindPriMessVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ChatFriendListItem extends Sprite
	{
		public var relList:RelListItemSpVO;
		
		private var bgSp:Sprite = new Sprite;
		private var icon:Image;
		private var messNumSp:Sprite = new Sprite;
		
		public function ChatFriendListItem(_relList:RelListItemSpVO)
		{
			super();
			relList = _relList;
			
			addChild(bgSp);
			var bg:Image = new Image(BitmapFontUtils.getTexture("friItemBg_00000"));
			bgSp.addChild(bg);
			bgSp.visible = false;
			

			
			icon = new Image(BitmapFontUtils.getTexture("friIconF_00000"));
			icon.x = 10;
			icon.y = 4;
			addChild(icon);
			
			
			
			var nameTF:Label = BitmapFontUtils.getLabel();
			nameTF.setSize(65,18);
			nameTF.x = 55;
			nameTF.y = 12;
			addChild(nameTF);
			nameTF.text = relList.realName;
			
			//没显示颜色
			if(relList.relaType == "S")
				nameTF.textRendererProperties.textFormat = new BitmapFontTextFormat("dHei",14,0x404dfe);
			
			
			if(relList.messNum > 0){
				addChild(messNumSp);
				messNumSp.visible = true;
				
				var messNumBg:Image = new Image(BitmapFontUtils.getTexture("firMessNum_00000"));
				messNumSp.addChild(messNumBg);
				
				var messNumTF:Label = BitmapFontUtils.getLabel();
				var tf:BitmapFontTextFormat = new BitmapFontTextFormat("dHei",12,0xffffff,TextFormatAlign.CENTER);
				tf.letterSpacing = -2;
				messNumTF.textRendererProperties.textFormat = tf;
				messNumTF.setSize(20,15);
				messNumTF.x = 1;
//				messNumTF.y = 3;
				messNumSp.addChild(messNumTF);
				messNumTF.text = relList.messNum.toString();
			}
			
			
			//有消息，需要提醒
			if(relList.isShake)
				shakeIcon();
			
		}
		
		public function set bgVisible(val:Boolean):void{
			bgSp.visible = val;
		}
		
		private function shakeIcon():void{
			
			TweenMax.to(icon,0.3,{x:icon.x+2,y:icon.y+2,repeat:int.MAX_VALUE,yoyo:true,ease:Linear.easeNone});
//			TweenMax.to(icon,0.2,{delay:0.2,x:icon.x+2,y:icon.y+2,repeat:int.MAX_VALUE,yoyo:true,ease:Linear.easeNone});
			
		}
		
		public function stopShake():void{
			relList.isShake = false;
			relList.messNum = 0;
			messNumSp.visible = false;
			
			TweenLite.killTweensOf(icon);
			icon.x = 10;
			icon.y = 4;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.REMIND_PRIVATE_MESS,new RemindPriMessVO(false,relList.rstdId));
		}
		
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			TweenLite.killTweensOf(icon);
			
			removeChildren(0,-1,true);
		}
		
		
	}
}