package com.studyMate.world.component.gridList
{
	import com.studyMate.world.component.BaseListItemRenderer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	internal class BaseGridRenderer extends BaseListItemRenderer
	{
		
		private var _groupHolder:Sprite;		
		
		public function BaseGridRenderer()
		{
			super();
		}

		public function get groupHolder():Sprite
		{
			return _groupHolder;
		}

		override public function dispose():void
		{
			this.removeChildren(0,-1,true);
			super.dispose();
		}

		override protected function initialize():void
		{
			if(!this._groupHolder)
			{	
				_groupHolder = new Sprite();
				this.addChild(_groupHolder);
			}
		}
		override protected function commitData():void
		{
			if(this._data)
			{
				var ownerList:GridList = owner as GridList;
				var count:int = ownerList.row*ownerList.column;
				var arr:Array = this._data as Array;
				var len:int = arr.length;
				var groupItem:IGridItem;
//				for(var i:int=0;i<_groupHolder.numChildren;i++){
//					_groupHolder.getChildAt(i).visible = false;
//				}
				_groupHolder.removeChildren(0,-1,true);
				for(var i:int=0;i<len;i++){
					if(_groupHolder.numChildren<len){
						groupItem = new ownerList.gridItemClass;
						(groupItem as DisplayObject).x = _groupHolder.numChildren%ownerList.column*ownerList.columnGap + ownerList.Left;						
						(groupItem as DisplayObject).y = int(_groupHolder.numChildren/ownerList.column)*ownerList.rowGap + ownerList.Top;
						_groupHolder.addChild(groupItem as DisplayObject);						
						groupItem.data = arr[i];
					}
//					(groupItem as DisplayObject).visible = true;
					
				}
				width = ownerList.width;
				height = ownerList.height;
			}
		}
	}
}