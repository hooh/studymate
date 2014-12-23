package com.mylib.framework.model
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.db.schema.IDAO;
	import com.studyMate.db.schema.IPlayerDAO;
	import com.studyMate.db.schema.PlayerDAO;
	import com.studyMate.db.schema.ViewConfigDAO;
	import com.studyMate.global.Global;
	
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	
	public final class DataBaseProxy extends Proxy implements IProxy
	{
		
		public static const NAME:String = "DataBaseProxy";
		public var entityManager:EntityManager = new EntityManager;
		
		public var sqlConnection:SQLConnection=new SQLConnection();
		private var dbFile:File;
		
		public var viewConfigDAO:IDAO;
		public var playerDAO:IPlayerDAO;
		
		public function DataBaseProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			DBTool.proxy = this;
			
			viewConfigDAO = new ViewConfigDAO();
			playerDAO = new PlayerDAO();
			
		}
		
		override public function onRemove():void
		{
			DBTool.proxy = null;
		}
		
		
		public function setUp():Boolean
		{
			dbFile = Global.document.resolvePath(Global.localPath+"edu.db");
			
			if(!dbFile.exists){
				//sendNotification(ApplicationFacade.PUSH_VIEW,new PushViewVO(EasyDownloadView));
				sendNotification(CoreConst.EASY_DOWNLOAD);
				return false;
			}
			
			
			sqlConnection.open(dbFile);
			return true;
			
		}
		
		
		public function close():void{
			sqlConnection.close();
		}
		
	}
}
import flash.data.SQLConnection;

class EntityManager{
	
	public var sqlConnection:SQLConnection;
	
	public static function get getInstance():EntityManager{
		return new EntityManager;
	}
	
	public function save(para:*):void{
		
	}
	
	public function fetchCriteriaFirstResult(para:*):*{
		return null;
	}
	
	public function findAll(para:*):Array{
		return null;
	}
	
	public function remove(para:*):void{
		
	}
	
}