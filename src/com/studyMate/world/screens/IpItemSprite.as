package com.studyMate.world.screens
{
	import com.studyMate.model.vo.IPSpeedVO;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class IpItemSprite extends Sprite
	{
		public var ip:IPSpeedVO;
//		public var btn:Sprite;
		
		public function IpItemSprite(_ip:IPSpeedVO){
			super();
			ip = _ip;
			
			this.graphics.lineStyle(1);
			this.graphics.beginFill(0xE6A73F);
			this.graphics.drawRect(0,0,340,40);
			this.graphics.endFill();
			
			var host:TextField = new TextField();
			host.width = 200; host.mouseEnabled = false;
			host.y = 10;
			this.addChild(host);
			
			var time:TextField = new TextField();
			time.width = 180; time.mouseEnabled = false;
			time.x = 150; time.y = 10;
			this.addChild(time);
			
			/*btn = new Sprite();
			btn.graphics.lineStyle(1);
			btn.graphics.beginFill(0xE9E1AC);
			btn.graphics.drawRect(0,0,80,28);
			btn.graphics.endFill();
			var tf:TextField = new TextField();
			tf.text = "选择";
			tf.x = 27; tf.y = 5;
			tf.mouseEnabled = false;
			tf.height = 28;
			btn.addChild(tf);
			btn.x = 245; btn.y = 6;
			this.addChild(btn);*/
			
			host.text = "Host: " + ip.name;
			/*if(ip.conCount <= ip.failCount && ip.conCount != 0){
				time.text = "Connect Failed.";
			}else{
				time.text = "Time: " + ip.timeout + "ms";
			}*/
			
			
			
			
			if(ip.stat == IPSpeedVO.SOCKET_NORMAL){
				time.text = "Time: " + ip.timeout + "ms";
				
			}else if(ip.stat == IPSpeedVO.SOCKET_ERROR){
				time.text = "网络故障，socket连接失败";
				
			}else if(ip.stat == IPSpeedVO.DATA_HEAD_ERROR){
				time.text = "校验数据头解析错误";
				
			}else if(ip.stat == IPSpeedVO.DATA_ERROR){
				time.text = "校验数据解析错误";
				
			}else if(ip.stat == IPSpeedVO.DATA_TIMEOUT){
				time.text = "校验数据传输超时";
				
			}
			
			
			
			
			
			
			
			
		}
	}
}