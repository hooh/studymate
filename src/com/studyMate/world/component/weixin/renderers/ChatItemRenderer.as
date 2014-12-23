package com.studyMate.world.component.weixin.renderers
{	
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.component.sysface.TextFieldExtends;
	import com.studyMate.world.component.weixin.SpeechConst;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class ChatItemRenderer extends BaseListItemRenderer
	{
		public function ChatItemRenderer()
		{
			super();
			
		}
		private const contentTop:int = 30;//content的距离
		private var userLabel:TextField;//张怡 2014-01-18 18:56:23
		private var txtLBg:Scale9Image;
		private var txtRBg:Scale9Image;
		private var teachIcon:Image;
		private var studentIcon:Image;
		private var content:*;
		private var userTeacherIcon:Boolean;
		
		override protected function initialize():void
		{
			if(!this.userLabel)
			{				
				this.userLabel = new TextField(240,27,"","HeiTi",14,0x387287,true);				
				this.userLabel.hAlign = HAlign.LEFT;
				this.userLabel.autoSize = TextFieldAutoSize.HORIZONTAL;
				this.addChild(this.userLabel);												
				
				var minRect:Rectangle =  new Rectangle(84,34,2,1);
				txtLBg = new Scale9Image(new Scale9Textures(Assets.getWeixinTexture('leftBg'),minRect));	
				txtLBg.y = contentTop;
//				txtLBg.x = 82;
				
				var minRect1:Rectangle =  new Rectangle(72,34,2,1);
				txtRBg = new Scale9Image(new Scale9Textures(Assets.getWeixinTexture('rightBg'),minRect1));
				txtRBg.y = contentTop;
				
				
//				if(VoicechatComponent.owner((owner.parent as VoicechatComponent).core).configView.useTeacherIcon){	
//					userTeacherIcon = true;
//					studentIcon = new Image(Assets.getWeixinTexture('studentIcon'));
//					teachIcon = new Image(Assets.getWeixinTexture('teacherIcon'));
//				}else{
//					userTeacherIcon = false;
//					studentIcon = new Image(Assets.getWeixinTexture('leftDot'));
//					teachIcon = new Image(Assets.getWeixinTexture('rightDot'));
//				}
//								
//				studentIcon.y = contentTop;
//				teachIcon.y = contentTop;
//				
//				studentIcon.touchable = false;
//				teachIcon.touchable = false;
				txtRBg.touchable = false;
				txtLBg.touchable = false;
//				this.userLabel.touchable = false;
			}
		}

		private var rect:Rectangle;
		override protected function commitData():void
		{
			if(this._data)
			{
				var weixinVO:WeixinVO = this._data as WeixinVO;
				this.userLabel.text = weixinVO.sedname + '  '+weixinVO.sedtime;
				this.userLabel.addEventListener(TouchEvent.TOUCH,userClickHandler);
				txtRBg.removeFromParent();
				txtLBg.removeFromParent();
				if(weixinVO.mtype=='text'){//content是文本
					if(!(this.content is TextFieldExtends)){
						if(this.content) this.content.removeFromParent(true);
						this.content = new TextFieldExtends(0.715*owner.width,50,"","HeiTi",19,0);
						this.content.isHtml = true;
						this.content.hAlign = HAlign.LEFT;
						this.content.autoSize = TextFieldAutoSize.VERTICAL;
						this.addChild(this.content);
					}				
					this.content.text = weixinVO.mtxt;					
					rect = this.content.textBounds;//获取其真实大小
					if(rect.width<90) rect.width = 92;
					else if(rect.width>this.content.width) rect.width = content.width;
					if(weixinVO.owner){//自己说的在右侧
						this.content.x= owner.width-rect.width-124;
						this.content.color = 0x333333;
						
						txtRBg.width = rect.width+50;
						txtRBg.height = rect.height+28;
						txtRBg.x = owner.width-rect.width-146;
						this.addChildAt(txtRBg,0);												
					}else{//对方的回复在左侧
						this.content.x= 105;
						this.content.color = 0x2E6712;
						
						txtLBg.width = rect.width+50;
						txtLBg.height = rect.height+28;
						txtLBg.x = 82;
						this.addChildAt(txtLBg,0);
					}
					
					this.content.y = contentTop+12;					
					height = contentTop + rect.height+42;//高度必须写的		
					
				}else if(weixinVO.mtype == 'voice'){//content是语音	
					if(!(this.content is VoiceSp)){
						if(this.content) this.content.removeFromParent(true);
						if(weixinVO.owner){							
							this.content = new VoiceSp(weixinVO.mtxt,"R");
						}else{
							this.content = new VoiceSp(weixinVO.mtxt,"L");
						}
						this.addChild(this.content);
						
					}else{
						if(weixinVO.owner){
							(this.content as VoiceSp).adjustDirection("R");
						}else{
							(this.content as VoiceSp).adjustDirection("L");
						}
						(this.content as VoiceSp).path = weixinVO.mtxt;
					}
					this.content.y = contentTop;					
					height = contentTop + this.content.height;//高度必须写的	
					(this.content as VoiceSp).state = weixinVO.voiceState;
					(this.content as VoiceSp).hasRead = weixinVO.hasRead;
					(this.content as VoiceSp).soundTime = weixinVO.minf;//附加信息是包含时间的
					(this.content as VoiceSp).layout();
					
					if((this.content as VoiceSp).direction == 'L'){
						this.content.x = 81;
					}else{
						this.content.x= owner.width-(this.content as VoiceSp).bgWidth - 152;
					}
					(this.content as VoiceSp).bgBtn.addEventListener(TouchEvent.TOUCH,weixinClickHandler);

				}else if(weixinVO.mtype == 'pic'){
					if(!(this.content is PicSp)){
						if(this.content) this.content.removeFromParent(true);
						if(weixinVO.owner){
							this.content = new PicSp(weixinVO.mtxt,'R');
							this.content.core = weixinVO.core;
						}else{							
							this.content = new PicSp(weixinVO.mtxt,'L');
							this.content.core = weixinVO.core;
						}						
						this.addChild(this.content);
					}
					if(weixinVO.owner){							
						(this.content as PicSp).x = owner.width - (this.content as PicSp).iconWidth-100;
					}else{
						(this.content as PicSp).x = 81;
					}
					(this.content as PicSp).filename = weixinVO.mtxt;
					(this.content as PicSp).state = weixinVO.voiceState;

					this.content.y = contentTop;					
					height = contentTop + this.content.height;//高度必须写的
					
					(this.content as PicSp).picImg.addEventListener(TouchEvent.TOUCH,picClickHandler);			
				}else{
					height = contentTop;
				}
				
				
				
				if(teachIcon)teachIcon.removeFromParent();
				if(studentIcon)studentIcon.removeFromParent();
				if(VoicechatComponent.owner(weixinVO.core).configView.useTeacherIcon){	
					userTeacherIcon = true;
					if(studentIcon==null) studentIcon = new Image(Assets.getWeixinTexture('studentIcon'));
					if(teachIcon==null) teachIcon = new Image(Assets.getWeixinTexture('teacherIcon'));
				}else{
					userTeacherIcon = false;
					if(studentIcon==null) studentIcon = new Image(Assets.getWeixinTexture('leftDot'));
					if(teachIcon==null) teachIcon = new Image(Assets.getWeixinTexture('rightDot'));
				}
				studentIcon.touchable = false;
				teachIcon.touchable = false;
				studentIcon.y = contentTop;
				teachIcon.y = contentTop;
				if(userTeacherIcon){					
					if(weixinVO.isTeacher){//是老师则加上老师头像
						this.addChild(teachIcon);
						if(weixinVO.owner){
							teachIcon.x = owner.width-75;	
							this.userLabel.x = owner.width - this.userLabel.textBounds.width-15;;					
						}else{
							teachIcon.x = 5;
							this.userLabel.x= 0;
						}
	
					}else{
						this.addChild(studentIcon);
						if(weixinVO.owner){
							studentIcon.x = owner.width-75;
							this.userLabel.x = owner.width - this.userLabel.textBounds.width-15;;		
						}else{
							studentIcon.x = 5;	
							this.userLabel.x= 0;
						}
					}
				}else{
					if(weixinVO.owner){
						this.content.x += 34;
						this.txtRBg.x += 34;
						teachIcon.x = owner.width-75;	
						this.userLabel.x = owner.width - this.userLabel.textBounds.width-15;
						this.addChild(teachIcon);
					}else{
						this.content.x -= 34;
						this.txtLBg.x -= 34;
						studentIcon.x = 5;	
						this.userLabel.x= 0;
						this.addChild(studentIcon);
					}
				}
			}
			else
			{
				height = contentTop;
			}
		}
		
		private function userClickHandler(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(Math.abs(touchPoint.globalY-beginY) < 10){						
						Facade.getInstance(CoreConst.CORE).sendNotification(SpeechConst.USER_LABEL_CLICK,this._data);//派发播放事件事件
					}
				}
			}
		}
		
		override public function dispose():void
		{
			if(txtLBg) txtLBg.removeFromParent(true);
			if(txtRBg) txtRBg.removeFromParent(true);
			if(teachIcon) teachIcon.removeFromParent(true);
			if(studentIcon) studentIcon.removeFromParent(true);
			super.dispose();
		}
		
		
		private var beginY:Number;
		private function picClickHandler(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(Math.abs(touchPoint.globalY-beginY) < 10){						
						Facade.getInstance(this._data.core).sendNotification(SpeechConst.IMG_UI_CLICK,this._data);//派发播放事件事件
					}
				}
			}
		}
		
		protected function weixinClickHandler(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(Math.abs(touchPoint.globalY-beginY) < 10){						
						Facade.getInstance(this._data.core).sendNotification(SpeechConst.WEIXIN_UI_CLICK,this._data);//派发播放事件事件
					}
				}
			}
						
		}

		
	}
}

