package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.db.schema.ViewConfig;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.utils.AssetTool;
	import com.mylib.framework.utils.CacheTool;
	import com.mylib.framework.utils.DBTool;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class InitializeAssetsConfigCommand extends SimpleCommand implements ICommand
	{
		public function InitializeAssetsConfigCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var db:DataBaseProxy = DBTool.proxy;
			var configs:Array = db.viewConfigDAO.findAll();
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"初始化素材");
			AssetTool.assetsMap.clear();
			for each (var i:ViewConfig in configs) 
			{
				AssetTool.assetsMap.insert(i.viewId,i.assets);
				
				if(i.data&&i.data.length>0){
					CacheTool.viewData.insert(i.viewId,i.assets);
				}
				
			}
			
			
			
		}
		
	}
}