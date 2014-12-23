package com.studyMate.world.screens.talkingbook
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.screens.BookFaceShow2ViewMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	
	/**
	 * note
	 * 2014-7-11下午5:19:41
	 * Author wt
	 *
	 */	
	
	internal class BookItem extends Sprite
	{
		private var item:BookPicture;
		private var bg:Image;
		private var texture:Texture;
		
		public function BookItem(item:BookPicture,bmp:Bitmap)
		{
			super();
			
			this.item = item;
			
			if(bmp==null){
				var txt:TextField = new TextField(110,120,item.title,'HeiTi',18);
				txt.autoScale = true;
				txt.x = 23;
				txt.y = 30;
				this.addChild(txt);
			}else{
				texture = Texture.fromBitmap(bmp,false);
				var img:Image = new Image(texture);
				img.y = 14;
				this.addChild(img);
			}
			
			addEventListener(TouchEvent.TOUCH,touchHandle);
		}
		
		override public function dispose():void
		{
			if(texture) texture.dispose();
			super.dispose();
		}
		
		private var beginX:Number;
		private var endX:Number;
		private function touchHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(this);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){						
						Facade.getInstance(CoreConst.CORE).sendNotification(TalkingBookMediator.BOOKITEM_CLICK,item);
					}
				}
			}
		}
		
		
	}
}