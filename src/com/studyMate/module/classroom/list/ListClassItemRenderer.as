package com.studyMate.module.classroom.list
{
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.module.classroom.CroomVO;
	
	import flash.geom.Point;
	
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	/**
	 * 老师辅导的list
	 * @author wt
	 * 
	 */	
	public class ListClassItemRenderer extends BaseListItemRenderer
	{
		public function ListClassItemRenderer()
		{
			super();
		}
		
		
		override public function dispose():void
		{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
		protected var idLable:TextField;//用户标识
		protected var qtypeLable:TextField;//题目类型
		protected var nameLabel:TextField;//房间名称
		protected var qidsLable:TextField;//辅导题目id
		protected var stimeLable:TextField;//开始时间
		protected var flagLable:TextField;//开始时间
		
		protected var canPlayBoo:Boolean;
		protected var mouseDownX:Number;
		protected var mouseDownY:Number;
		
		protected var bg:Quad;
		
		private const defaultAlpha:Number=0.5;
		private const setAlpha:Number = 0.9;
		
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){					
				this.bg.alpha=setAlpha;				
			}else{
				this.bg.alpha=defaultAlpha;		
			}
			
		}
		
		override protected function initialize():void
		{
			if(!this.nameLabel)
			{
				this.bg = new starling.display.Quad(1050,50,0x1CBFE5);
				this.addChild(this.bg);
				
				this.idLable = new TextField(50,50,"","HeiTi",18,0);
				this.idLable.autoScale = true;
				this.idLable.touchable = false;
				this.addChild(this.idLable);
				
				this.qtypeLable = new TextField(100,50,"","HeiTi",18,0);
				this.qtypeLable.autoScale = true;
				this.qtypeLable.touchable = false;
				this.qtypeLable.x = 60;
				this.addChild(this.qtypeLable);
				
				this.nameLabel = new TextField(150,50,"","HeiTi",18,0);
				this.nameLabel.autoScale = true;
				this.nameLabel.touchable = false;
				this.nameLabel.x = 180;
				this.addChild(this.nameLabel);
				
				
				this.qidsLable = new starling.text.TextField(300, 50, "0", "HeiTi", 16, 0);
				this.qidsLable.x = 350;
				this.qidsLable.autoScale = true;
				this.qidsLable.touchable = false;
				this.addChild(this.qidsLable);	
				
				this.stimeLable = new starling.text.TextField(150, 50, "0", "HeiTi", 16, 0);
				this.stimeLable.x = 650;
				this.stimeLable.autoScale = true;
				this.stimeLable.touchable = false;
				this.addChild(this.stimeLable);
				
				this.flagLable = new starling.text.TextField(250, 50, "0", "HeiTi", 16, 0);
				this.flagLable.x = 800;
				this.flagLable.autoScale = true;
				this.flagLable.touchable = false;
				this.addChild(this.flagLable);
			}
		}
		
		override protected function commitData():void
		{
			if(this._data)
			{
				var baseClass:CroomVO = this._data as CroomVO;
				this.nameLabel.text = baseClass.crname;
				this.idLable.text = baseClass.sid;
				this.qtypeLable.text = baseClass.qtype+'('+baseClass.crid+')';
				this.qidsLable.text = baseClass.qids;
				this.stimeLable.text = baseClass.stime;
				this.flagLable.text = baseClass.surplusTips;
				if(baseClass.crstat == 'U'){					
					this.flagLable.color = 0x0000FF;
				}else{
					this.flagLable.color = 0x000000;
				}
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				
				height = this.bg.height;
			}else{
				height = 20;
			}
		}
		
		
		protected function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.BEGAN){
				pos = touch.getLocation(this);   
				mouseDownX = pos.x;
				mouseDownY = pos.y;
				canPlayBoo = true;
			}else if(touch && touch.phase == TouchPhase.MOVED){
				pos = touch.getLocation(this);  
				if(Math.abs(pos.x-mouseDownX)>10 || Math.abs(pos.y-mouseDownY)>10  ){
					canPlayBoo = false;
				}
			}else if(touch && touch.phase == TouchPhase.ENDED){
				if(canPlayBoo ){					
					isSelected = true;
					
				}
				
			}		
		}
	}
}