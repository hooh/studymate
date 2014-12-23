package com.studyMate.world.component.gridList
{
	import com.studyMate.global.Global;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 该list扩展了list翻页特效。加入了翻页点阵标记
	 * @author wt
	 * 
	 */	
	
	
	public class ListExtends extends List
	{
		
		private var _hasHorizonDot:Boolean;
		private var holder:Sprite;
		private var selectedSkin:Texture;
		private var defaultSkin:Texture;
		private var dotY:Number;
		private var gap:Number = 28;
		private var selectDot:Image;
		
		public function ListExtends()
		{
			super();
		}
		
		public function get hasHorizonDot():Boolean
		{
			return _hasHorizonDot;
		}
		
		public function set hasHorizonDot(value:Boolean):void
		{
			_hasHorizonDot = value;
			if(value==false){
				if(holder){
					holder.removeChildren(0,-1,true);
				}
			}
		}
		
		public function setHorizonDotSkin(selectedSkin:Texture,defaultSkin:Texture,y:Number=671,gap=28):void{
			this.selectedSkin = selectedSkin;
			this.defaultSkin = defaultSkin;
			this.dotY = y;
			this.gap = gap;
		}
		override public function set dataProvider(value:ListCollection):void
		{
			super.dataProvider = value;
			if(value == null){
				return;
			}
			
			if(_hasHorizonDot && selectedSkin){	
				if(holder){
					holder.removeChildren(0,-1,true);
				}else{
					holder = new Sprite();
					holder.y = this.dotY;
					this.addChild(holder);
				}
				var dot:Image;
				var len:int = this.dataProvider.length;
				for(var i:int=0;i<len;i++){
					dot = new Image(defaultSkin);
					dot.x = gap*i;					
					holder.addChild(dot);
				}
				selectDot = new Image(selectedSkin);
				holder.addChild(selectDot);				
				holder.x = (Global.stageWidth - holder.width)>>1;
			}
		}
		
		override protected function throwToPage(targetHorizontalPageIndex:int=-1, targetVerticalPageIndex:int=-1, duration:Number=0.5):void
		{
			super.throwToPage(targetHorizontalPageIndex, targetVerticalPageIndex, duration);
			
			if(_hasHorizonDot){
				if(selectDot && selectDot.parent){
					selectDot.x = targetHorizontalPageIndex*gap;
				}
			}
		}
	}
}