package com.mylib.framework.model
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class NetworkDetetor extends Proxy
	{
		public static const NAME:String="NetworkDetetor";
		
		public function NetworkDetetor()
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		private function getIPList():Array{
			
			return null;
		}
		
		
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
	}
}