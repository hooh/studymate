package com.studyMate.model.vo
{
	import com.studyMate.view.IPreloadMediator;
	
	import flash.display.DisplayObject;

	public final class PushViewVO
	{
		public var viewClass:Class;
		public var data:Object;
		public var context:Object;
		public var transition:Object;
		public var mediator:IPreloadMediator;
		public var viewId:String;
		public var view:DisplayObject;
		/**
		 *push pop show 
		 */		
		public var type:String;
		public var holder:*;
		public var index:int;
		public var x:int;
		public var y:int;
		public var newDomain:Boolean;
		
		public function PushViewVO(viewClass:Class, 
								   data:Object = null,
								   context:Object = null,
								   transition:Object = null,
								   view:DisplayObject=null,
								   mediator:IPreloadMediator=null,
								   viewId:String=null,
								   type:String="push",
								   holder:*=null,
								   x:int=0,
								   y:int=0,
								   index:int=-1)
		{
			this.viewClass = viewClass;
			this.data = data;
			this.context = context;
			this.transition = transition;
			this.view = view;
			this.mediator = mediator;
			this.viewId = viewId;
			this.type = type;
			this.holder = holder;
			this.index= index;
			this.x = x;
			this.y = y;
			
		}
	}
}