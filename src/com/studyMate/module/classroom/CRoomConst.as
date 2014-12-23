package com.studyMate.module.classroom
{
	public class CRoomConst
	{
		public static const MARK_RW_COMPLETE:String = 'markRwComplete';//标记任务完成
		
		public static const USERCX_HISTORY:String = 'usercx_history';//查询历史做题记录
		
		public static const CHANGE_U_LIST:String = 'change_U_list';//切换已辅导
		
		public static const CHANGE_D_LIST:String = 'change_D_list';//切换未辅导
		
		public static const INSERT_TEXT:String = 'crInsertText';//插入文本
		
		public static var isComplete:Boolean;
		public static var hasDrawBoard:Boolean;
		
		public static const EVENT_SELF_DRAWBOARD:String = 'crEventSelfDrawBoard';//画图板消息处理(自己以前发送的画图数据)		
		public static const EVENT_OTHER_DRAWBOARD:String = 'crEventOtherDrawBoard';//画图板消息处理(对方发送的画图数据)

//		public static const QUIT_DRAWBOARD:String = 'quit_drawBoard';//退出面板分享		
//		public static const HAS_ANYONE:String = 'hasAnyone';//是否有人在线,参数boolean(有人进入则清理掉画板保持同步)		
//		public static var hasAnyone:Boolean;//是否有人
		public static const CLEAR_DRAWBOARD:String = 'clearDrawBoard';//清理画板
		public static const SHOW_DUSTBIN:String = 'cr_show_dusbin';//显示垃圾桶
		public static const HIDE_DUSTBIN:String = 'cr_hide_dusbin';//隐藏垃圾桶

	}
}