package com.studyMate.module.engLearn.ui
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.mylib.framework.CoreConst;
	import com.studyMate.module.engLearn.api.LearnConst;
	import com.studyMate.module.engLearn.vo.ReadAloudVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	/**
	 * 连线模块
	 * 2014-10-21下午5:33:53
	 * Author wt
	 *
	 */	
	
	public class LinkMatchUI extends Sprite
	{
		
		private var vecL:Vector.<LinkLabel>;
		private var vecR:Vector.<LinkLabel>;
		private var shape:Shape;
		
		private var gap:Number = 106;
		
		private var preLink:LinkLabel;
		private var endLink:LinkLabel;
		
		private var yesTip:Image;
		private var errorTip:Image;
		
		private var linkTotal:int=0;//连线次数
		
		public function LinkMatchUI()
		{
			vecL = new Vector.<LinkLabel>;
			vecR = new Vector.<LinkLabel>;
			
			addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			super();
		}
		
		private function addToStageHandler(e:Event):void
		{
			shape = new Shape();
			shape.touchable = false;
			shape.touchGroup = false;
			this.addChildAt(shape,0);
			this.addEventListener(TouchEvent.TOUCH,labelTouchHandler);
			
			yesTip = new Image(Assets.readAloudTexture("goodTip"));
			yesTip.alpha = 0;
			yesTip.touchable = false;
			this.addChild(yesTip);
			
			errorTip = new Image(Assets.readAloudTexture("errorTip"));
			errorTip.alpha = 0;
			errorTip.touchable = false;
			this.addChild(errorTip);
		}		
		
		
		
		/**
		 * 传入题目数组 
		 * @param vec
		 * 
		 */		
		public function dataProvid(vec:Vector.<ReadAloudVO>):void{
			this.removeChildren(0,-1,true);
			vecR.length = 0;
			vecL.length = 0;
			var label:LinkLabel;
			for(var i:int=0;i<vec.length;i++){
				label = new LinkLabel();
				label.mark = i.toString();
				label.type = 'l';
				label.rankId = vec[i].rankid;
				label.text =vec[i].usSentence;
				vecL.push(label);
				
				label = new LinkLabel();
				label.mark = i.toString();
				label.type = 'r';
				label.rankId = vec[i].rankid;
				label.text = vec[i].cnSentence;
				vecR.push(label);				
			}			
			if(vecR.length>0){
				randomPosition();
			}
			
		}
		
		
		
		
		//随机位置处置,自身插入法
		public function randomPosition():void{
			var label:LinkLabel;
			var i:int = vecL.length;
			while(i){
				vecL.push(vecL.splice(int(Math.random() * i--), 1)[0]);
			}
			i = vecR.length;
			while(i){
				vecR.push(vecR.splice(int(Math.random() * i--), 1)[0]);
			}
			for(i = 0;i<vecL.length;i++){
				label = vecL[i];
				label.text = (i+1)+'.'+label.text;
				label.y = i*gap;
				this.addChild(label);
				
				label = vecR[i];
				label.text = String.fromCharCode(97+i)+'.'+ label.text;
				label.x = 678;
				label.y = i*gap;
				this.addChild(label);
			}
			
			
			
		}
		
		
		private	var pos:Point = new Point();
		private var pos0:Point = new Point();
		
		private var moveLink:LinkLabel;
		private function labelTouchHandler(e:TouchEvent):void
		{
			
			var touch:Touch = e.getTouch(this);	
			if(!touch){
				return;
			}
			switch(touch.phase){
				case TouchPhase.BEGAN:
					touch.getLocation(e.currentTarget as DisplayObject,pos0);						
					shape.graphics.clear();						
//					trace('BEGAN',(e.target as LinkLabel).mark);					
					if(preLink!=e.target){							
						prepareCheck(e.target as LinkLabel);
					}
					
					break;
				case TouchPhase.MOVED:
					touch.getLocation(e.currentTarget as DisplayObject,pos);
					shape.graphics.clear();
					shape.graphics.lineStyle(8,0xFF7D7D);
					shape.graphics.moveTo(pos0.x,pos0.y);
					shape.graphics.lineTo(pos.x,pos.y);
					
					var temp:LinkLabel = this.hitTest(pos) as LinkLabel;
					if(temp){
						if(temp!=preLink){
							if(temp != moveLink && preLink.type!=temp.type){
								if(moveLink) moveLink.hideBorder();
								moveLink = temp;
								moveLink.showBorder();
							}
						}
					}else{
						if(moveLink){
							moveLink.hideBorder();
							moveLink = null;
						}
					}
					/*if(temp && temp!=moveLink){
						if(moveLink) moveLink.hideBorder();
						moveLink = temp;
						moveLink.showBorder();
					}*/
					break;
				case TouchPhase.ENDED:
					if(moveLink) moveLink.hideBorder();
					touch.getLocation(e.currentTarget as DisplayObject,pos);
					endLink = this.hitTest(pos) as LinkLabel;
					if(endLink){
//						trace('ENDED',endLink.mark);							
						if(preLink!=endLink){
							if(preLink.type != endLink.type){									
								checkResult();
							}else{
								clearGraphics();
							}
						}else{
							clearGraphics();
						}
					}else{
						clearGraphics();
					}
					break;
			}
			
		}
		
		private function clearGraphics():void{
			if(preLink){
				preLink.isSelected = false;
				preLink = null;
			}
			shape.graphics.clear();				
		}
		
		
		
		private function prepareCheck(target:LinkLabel):void{
			if(preLink){								
				preLink.isSelected = false;
			}
			preLink = target;
			preLink.isSelected = true;
				
		}
		
		private function checkResult():void{
			if(!preLink) return;
			this.touchable = false;//禁屏
			endLink.isSelected = true;			
			linkTotal++;
			if(preLink.mark == endLink.mark){//正确
				yesTip.x = (pos.x + pos0.x)/2 -65; 
				yesTip.y = (pos.y + pos0.y)/2 - 58;
				yesTip.alpha = 0;
				TweenMax.to(yesTip,0.5,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut});
				
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordRight",0.7));
				TweenLite.killDelayedCallsTo(rightHandler);
				TweenLite.delayedCall(1,rightHandler);
				
				if(linkTotal<6){				
					Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.ANSWER_RIGHT,"`R`"+preLink.rankId+'/'+endLink.rankId);
				}
				
			}else{
				errorTip.x = (pos.x + pos0.x)/2 -93
				errorTip.y = (pos.y + pos0.y)/2 -77;
				errorTip.alpha = 0;
				TweenMax.to(errorTip,0.5,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut});
				
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordError",0.7));
				TweenLite.killDelayedCallsTo(wrongHandler);
				TweenLite.delayedCall(1,wrongHandler);
				
				if(linkTotal<6){				
					Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.ANSWER_WRONG,"`E`"+preLink.rankId+'/'+endLink.rankId);
				}
			}
			
			
			
		}
		private function wrongHandler():void{
			trace('错误！×');		
						
			this.touchable = true;
			shape.graphics.clear();	
			if(preLink){
				preLink.isSelected = false;
				preLink = null;
			}
			if(endLink){
				endLink.isSelected = false;
				endLink = null;
			}
		}
		
		
		private function rightHandler():void{
			trace('正确！√');
			shape.graphics.clear();	
			if(preLink){
				if(preLink.type=='l'){					
					vecL.splice(vecL.indexOf(preLink),1);
				}else{
					vecR.splice(vecR.indexOf(preLink),1);
				}
				preLink.removeFromParent(true);
			}
			if(endLink){
				if(endLink.type=='l'){	
					vecL.splice(vecL.indexOf(endLink),1);
				}else{					
					vecR.splice(vecR.indexOf(endLink),1);
				}
				endLink.removeFromParent(true);
			}
			preLink = null;
			endLink = null;
			
//			layoutChildren();
			TweenLite.delayedCall(5,enable,null,true);
			
		}
		
		private function enable():void
		{
			this.touchable = true;
			if(vecL.length==0){
				Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.LINK_COMPLETE,linkTotal.toString());
			}
		}
//		
//		private function layoutChildren():void{
//			for(var i:int=0;i<vecL.length;i++){
//				TweenLite.to(vecL[i],0.5,{y:i*gap});
//				TweenLite.to(vecR[i],0.5,{y:i*gap});
//			}
//		}

		
		override public function dispose():void
		{
			TweenLite.killDelayedCallsTo(enable);
			TweenLite.killDelayedCallsTo(rightHandler);
			TweenLite.killDelayedCallsTo(wrongHandler);
			for(var i:int=0;i<vecL.length;i++){
				TweenLite.killTweensOf(vecL[i]);
				TweenLite.killTweensOf(vecR[i]);
			}
			super.dispose();
		}
	}
}