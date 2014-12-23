package com.studyMate.world.component.SVGEditor
{
	

	public class SVGConst
	{
		public static var svgXML:XML;
		public static var currentTool:String;//当前选择的工具		
		public static var isEditState:Boolean;// 编辑状态，true为正在编辑状态
		
		public static var stageWidth:Number = 1280;
		public static var stageHeight:Number = 752;
				
		public static const INITIALIZE_SVG:String = "SVG_INITIALIZE_SVG";
		public static const REMOVE_SVG:String = "SVG_REMOVE_SVG";
		
		public static const SHOW_MOVE_VIEW:String = "SVG_SHOW_MOVE_VIEW";
		public static const COORD_CHANGE:String = "SVG_COORD_CHANGE";
		public static const RESET_COORD:String = "SVG_RESET_COORD";
		
		public static const ZOOM_STAGE:String = "SVG_ZOOM_STAGE";
		
		
		public static const LOAD_SVG_INFO:String = 'SVG_LOAD_SVG_INFO';
		
		/**-----------------------顶栏----------------------------------------*/
		public static const LOAD__SVG_DOCUMENT:String = "SVG_LOAD__SVG_DOCUMENT";//导入文档
		public static const SAVE_SVG_DOCUMENT:String = "SVG_SAVE_SVG_DOCUMENT";//保存文档		
		public static const LOAD_SWF:String = "SVG_LOAD_SWF";//导入swf文件	
		
		public static const UPDATE_SWF_LIBRARY:String = "SVG_UPDATE_SWF_LIBRARY"//刷新库
		
		/**-----------------------控制命令----------------------------------------*/		
		public static const CLEAR_ALL_ELEMENT:String = "SVG_CLEAR_ALL_ELEMENT";//清空文档
		public static const UPDATE_SVG_DOCUMENT:String = "SVG_UPDATE_SVG_DOCUMENT";//开始刷新文本
		public static const UPDATE_SVG_DOCUMENT_COMPLETE:String = "SVG_UPDATE_SVG_DOCUMENT_COMPLETE";//刷新文本完毕
		public static const PROPERTIES_CHANGE:String = "SVG_PROPERTIES_CHANGE";//属性变更,0为直接更改，非0为设定属性
		public static const SELECT_TAG:String = "SVG_SELECT_TAG";//选择标签，传入id
		public static const UPDATE_STAGE_SCALE:String = 'SVG_UPDATE_STAGE_SCALE';//更新舞台尺寸
		
		public static const PREPARE_CREAT_NEW:String = "SVG_PREPARE_CREAT_NEW";//准备新建新的可编辑对象
		public static const REMOVE_REPARE_CREAT_NEW:String = "SVG_REMOVE_REPARE_CREAT_NEW";//移除新建
		
		public static const CREAT_NEW_ELEMENT:String = "SVG_CREAT_NEW_ELEMENT";
		
		
		public static const MOVE_HAND_BEGIN:String = "SVG_MOVE_HAND_BEGIN";
		
		public static const MODIFIY_ELEMENT:String = "SVG_MODIFIY_ELEMENT";//修改显示对象,传入继承EditSVGBase的子类
		
		/**-----------------------属性面板----------------------------------------*/	
		public static const PROPERTIES:String = "SVG_PROPERTIES";//属性面板
						
		/**-----------------------其它控制命令----------------------------------------*/				
		public static const LOAD_SWF_COMPLETE:String = "SVG_LOAD_SWF_COMPLETE";//加载swf的列表
		public static const HIDE_PANEL:String = "SVG_HIDE_PANEL";//隐藏面板
		public static const SHOW_PANEL:String = "SVG_SHOW_PANEL";//显示面板
		public static const CHANGE_TAG:String = "SVG_CHANGE_TAG";
		
		
	}
}