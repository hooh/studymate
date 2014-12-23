package com.studyMate.world.component
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import starling.events.Event;
	
	public class BaseListItemRenderer extends FeathersControl implements IListItemRenderer
	{
		protected var _index:int = -1;
		protected var _owner:List;
		protected var _isSelected:Boolean;
		protected var _data:Object;
		
		public function BaseListItemRenderer()
		{
			super();
		}
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get owner():List
		{
			return List(this._owner);
		}
		
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		//子类列表若要改变isSelected被选择的状态，则重写isSelecte方法
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;	
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		override protected function initialize():void
		{
			throw new Error("ItemRender子类需重写initialize方法");
		}
		
		override protected function draw():void
		{
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			if(dataInvalid)
			{
				this.commitData();
			}

		}
		
		protected function commitData():void
		{
			throw new Error("ItemRender子类需重写commitData方法");
		}
		
	}
}