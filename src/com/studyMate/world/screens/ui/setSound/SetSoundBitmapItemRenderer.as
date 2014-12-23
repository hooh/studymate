package com.studyMate.world.screens.ui.setSound
{
	
	import com.mylib.framework.CoreConst;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.model.vo.BackgroundMusicVO;
	import com.studyMate.world.screens.SetSoundNewMeidator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.music.MusicBaseClass;
	
	import feathers.controls.Label;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class SetSoundBitmapItemRenderer extends BaseListItemRenderer
	{
//		private var holder:Sprite;//大容器
		private var titleLabel:Label;

		private var delBtn:Button;
		
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var bg:Image;
		private var bg2:Image;
		
		public function SetSoundBitmapItemRenderer()
		{
		}
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){					
				bg2.visible = true;
			}else{
				bg2.visible = false;
			}
		}
		
		override protected function initialize():void
		{
			if(!this.titleLabel)
			{							
				bg = new Image(BitmapFontUtils.getTexture('bgQuad_00000'));
				this.addChild(this.bg);
				bg2 = new Image(BitmapFontUtils.getTexture('bgQuad2_00000'));
				bg2.touchable = false;
				bg2.visible = false;
				this.addChild(bg2);

				
				this.titleLabel = BitmapFontUtils.getLabel();
				this.titleLabel.touchable = false;
				this.titleLabel.maxWidth = 230;
				this.titleLabel.x = 46;
				this.titleLabel.y = 10;
				this.addChild(titleLabel);

				
				this.delBtn = new Button(BitmapFontUtils.getTexture("parents/del_Resource_icon_00000"));
				this.delBtn.addEventListener(Event.TRIGGERED,delBtnHandler);
				this.delBtn.x = 900;
				this.delBtn.y = 7;
				this.addChild(delBtn);
				
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			}
		}
		
		override protected function commitData():void
		{
			if(this._data)
			{
				var baseClass:BackgroundMusicVO = this._data as BackgroundMusicVO;
				this.titleLabel.text = baseClass.name;				
			}
		}
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.bg);				
			if(touch && touch.phase == TouchPhase.ENDED){				
				isSelected = true;									
			}		
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		//删除歌曲
		private function delBtnHandler(e:Event):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(SetSoundNewMeidator.Del_Music,this._data);
						
		}
	}
}


