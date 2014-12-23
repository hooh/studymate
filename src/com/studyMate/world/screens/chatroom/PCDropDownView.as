package com.studyMate.world.screens.chatroom
{
	import com.studyMate.world.component.weixin.interfaces.IDropDownView;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	public class PCDropDownView extends Sprite implements IDropDownView
	{
		private var photoBtn:Button;
		
		public function PCDropDownView()
		{
			
			var morebg:Image = new Image(Assets.getChatViewTexture("chatRoom/input_moreBg"));
			this.addChild(morebg);
			
			//拍照按钮
			photoBtn = new Button(Assets.getChatViewTexture("chatRoom/input_photoBtn"));//chatRoom/input_pictureBtn
			photoBtn.x = 20;
			photoBtn.y = 20;
			this.addChild(photoBtn);
			
			
		}
		
		public function get cameraDisplayObject():DisplayObject{
			return photoBtn;
		}
		
		
		public function get shareBoardplayObject():DisplayObject{
			return null;
		}
	}
}