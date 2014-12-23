package com.mylib.framework.model
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.net.SharedObject;
	
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public final class SharedObjectProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SharedObjectProxy";
		public var so:SharedObject;
		
		public function SharedObjectProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			so = SharedObject.getLocal("eduOnline");
			
			if(so.data.loginTime == undefined){
				so.data.loginTime=0;
			}else{
				
			}
			
			so.data.loginTime++;
			so.flush();
			
		}
		
		/**
		 *保存登录信息 
		 * @param operid 操作员标识
		 * @param _region 用户分区
		 * @param _tokennext 成功登录后生成的，用于下次登录加密的令牌值
		 * @param _logincnt 正常登录次数
		 * 
		 */		
		public function saveLoginData(_operid:String,_region:String,_tokennext:String,_logincnt:String,_cntsocket:String):void{
			
			//Log.getLogger("sharedObj").debug(so.data[Global.user]+":"+"operid:"+_operid+",region:"+_region+"tokennext:"_tokennext+",logincnt:"+_logincnt);
			
			so.data[Global.user] = {operid:_operid,region:_region,tokennext:_tokennext,logincnt:_logincnt,cntsocket:_cntsocket};
			so.flush();
			
			
		}
		
		public function saveDefaultUser(user:String,password:String):void{
			so.data["defaultUser"] = user;
			so.data["defaultPSW"] = password;
		}
		
		public function getDefaultUserName():String{
			return so.data["defaultUser"];
		}
		
		public function getDefaultPasword():String{
			return so.data["defaultPSW"];
		}
		
		
		
		/**
		 *本地有没有用户数据 
		 * @param userName
		 * @return 
		 * 
		 */		
		public function hasUserData(userName:String):Boolean{
			return !(so.data[userName]==null);
		}
		
		
		public function getLoginDataByKey(_key:String,userName:String=null):String{
			if(userName){
				return so.data[userName][_key];
			}else{
				return so.data[Global.user][_key];
			}
		}
		
		
		public function deleteUser(_user:String):void{
			delete so.data[_user];
		}
		
		
		
	}
}