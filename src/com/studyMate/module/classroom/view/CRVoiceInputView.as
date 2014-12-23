package com.studyMate.module.classroom.view
{
	import com.studyMate.world.component.weixin.interfaces.IVoiceInputView;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	
	public class CRVoiceInputView extends CRInputBase implements IVoiceInputView
	{
		private var startRecordBtn:Button;//开始录音
		private var changeInputBtn:Button;//切换文字输入
		private var tipImg:Image;//提示取消和试听的图标
		
		public function CRVoiceInputView()
		{
			super();
			
			var inputImg:Image = new Image(Assets.getCnClassroomTexture("inputBg"));
			inputImg.x = -1;
			holder.addChild(inputImg);
			
			startRecordBtn = new Button(Assets.getCnClassroomTexture('startRecordBtn'),'',Assets.getCnClassroomTexture('stopRecordBtn'));
			startRecordBtn.x = 63;
			startRecordBtn.y = 15;
			holder.addChild(startRecordBtn);
			
			changeInputBtn = new Button(Assets.getCnClassroomTexture('changeInputBtn'));
			changeInputBtn.x = 504;
			changeInputBtn.y = 21;
			holder.addChild(changeInputBtn);
			
			holder.addChild(dropDownBtn);
		}
		
		public function get recordDisplayObject():DisplayObject
		{
			return startRecordBtn;
		}
		

		
		public function get switchTextInputDisplayObject():DisplayObject
		{
			return changeInputBtn;
		}

		
		public function get startListenDisplayObject():DisplayObject
		{
			if(tipImg==null){
				tipImg = new Image(Assets.getWeixinTexture('tryListenImg'));
				tipImg.x = 894;
				tipImg.y = 230;
			}
			
			return tipImg;
		}
		
		override public function dispose():void
		{
			if(tipImg){
				tipImg.removeFromParent(true);
				tipImg = null;
			}
			if(startListenDisplayObject) startListenDisplayObject.removeFromParent(true);
		}
		
		
		public function startRecordState():void{
			if(!startListenDisplayObject.parent) this.addChild(startListenDisplayObject);			
		}
		
		public function endRecordState():void{
			if(startListenDisplayObject) startListenDisplayObject.removeFromParent();
		}

		override public  function dropdownState():void{
			if(holder.y != 522){
				holder.y = 522;
				super.dropdownState();
			}else{
				defaultState();
			}
		}

		
		override public function defaultState():void{//默认状态
			holder.y = 663
			super.defaultState();
			
		}
	}
}