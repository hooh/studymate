package com.studyMate.world.component.gridList
{
	import com.studyMate.utils.MyUtils;
	
	import feathers.data.ListCollection;
	
	/**
	 * 表格list，可以实现行和列的功能
	 * @author wt
	 * 
	 * 附加属性
	 * 
	 * 
	 * 

	 */	
	/*
	
	使用方法
	var layout:HorizontalLayout = new HorizontalLayout();
	list = new GridList();
	list.x = 0;
	list.y = 0;
	list.width = Global.stageWidth;
	list.height = 632;
	list.layout = layout;
	list.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;//只有一页时。是否可以滚动
	list.snapToPages = true;//是否按页翻动
	list.itemRendererType = IGridItem;//需要实现IGridItem的可显示类
	list.horizontalScrollBarFactory = null;//是否隐藏水平滚动条
	view.addChild(list);	
	list.dataProvider = dataProvider*/
	
	public class GridList extends ListExtends
	{
		/**
		 * 行数 
		 */		
		public var row:int = 2;//行
		/**
		 * 列数 
		 */		
		public var column:int = 4;//列
		/**
		 * 行距 
		 */		
		public var rowGap:Number = 290;//行距(行与行的间距)
		/**
		 * 列距 
		 */		
		public var columnGap:Number = 294;
		/**
		 * 距离顶端 
		 */		
		public var Top:Number = 100;
		/**
		 * 距离左侧 
		 */		
		public var Left:Number = 132;
		
		
		private var _gridItemClass:Class;		
		
		public function GridList()
		{
			super();
			
			this._itemRendererType = BaseGridRenderer;
		}
		
		

		override public function set dataProvider(value:ListCollection):void
		{
			if(row*column==0){
				throw new Error('对GroupPageList设置行属性和列属性，不能为0和负数');
				return;
			}
			if(value == null){
				super.dataProvider = value;
				return;
			}
			
			var cloneList:ListCollection =  new ListCollection(MyUtils.clone(value.data));
			var groupList:ListCollection = new ListCollection();
			
			
			var arr:Array = [];
			while(cloneList.length>0){
				arr.push(cloneList.removeItemAt(0));
				if(arr.length>= row*column){
					groupList.push(arr);
					
					arr = [];
				}
			}
			if(arr.length>0){
				groupList.push(arr);
			}			
			super.dataProvider = groupList;		
		}

		public function get gridItemClass():Class
		{
			if(_gridItemClass==null){
				throw new Error('请为GridList设定gridItemClass属性');
			}
			return _gridItemClass;
		}
		
		override public function set itemRendererType(value:Class):void{
			
			this._gridItemClass = value;
		}
		
	
		
	}
}