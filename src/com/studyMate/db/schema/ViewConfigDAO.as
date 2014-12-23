package com.studyMate.db.schema
{
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.global.Global;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.filesystem.File;

	public class ViewConfigDAO implements IDAO
	{
		public function ViewConfigDAO()
		{
		}
		
		
		public function findAll():Array
		{
			var result:Array = new Array();
			var con:SQLConnection = DBTool.proxy.sqlConnection;
			if(con != null){
				var queryStmt:SQLStatement = new SQLStatement();
				queryStmt.sqlConnection = con;
				queryStmt.text = "Select * from view_configs";
				queryStmt.execute();
				var rs:SQLResult = queryStmt.getResult();
				for(var i:int = 0; i < rs.data.length; i++){
					var row:Object = rs.data[i];
					var assets:Array = new Array();
					queryStmt.text = "Select * from view_config_assets_libs, assets_libs " +
						"where view_config_assets_libs.assets_lib_id = assets_libs.id " +
						"and view_config_assets_libs.view_config_id = :view_config_id";
					queryStmt.parameters[":view_config_id"] = row["id"];
					queryStmt.execute();
					var assets_libs_array:SQLResult = queryStmt.getResult();
					if(assets_libs_array.data != null){
						for(var j:int = 0; j < assets_libs_array.data.length; j++){
							var row_assetslib:Object = assets_libs_array.data[j];
							var assetslib:AssetsLib = new AssetsLib();
							assetslib.id = row_assetslib["id"];
							assetslib.path = row_assetslib["path"];
							assetslib.domain = row_assetslib["domain"];
							assetslib.parameters = row_assetslib["parameters"];
							assetslib.type = row_assetslib["type"];
							assetslib.version = row_assetslib["version"];
							assets.push(assetslib);
						}
					}
					var viewcng:ViewConfig = new ViewConfig();
					viewcng.id = row["id"];
					viewcng.viewId = row["view_id"];
					viewcng.assets = assets;
					result.push(viewcng);
				}
			}
			return result;
		}
		
		public function insert(_data:Object):void
		{
		}
		
		public function update(_data:Object):void
		{
		}
		
		public function deleteItem(_data:Object):void
		{
		}
	}
}