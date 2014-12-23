package com.studyMate.world.screens.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.view.component.myScroll.Scroll;
	import com.studyMate.world.screens.component.vo.MoMoSp;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class MainChatCpuScroller extends Sprite
	{
		
		public var scroll:Scroll;
		protected var UI:Sprite;
		private var chatBmpProxy:ChatViewBmpProxy;
		

		
		public function MainChatCpuScroller(_x:Number,_y:Number,_width:Number,_height:Number)
		{
			super();
			
			
			scroll = new Scroll();
			scroll.state = 'VERTICAL';
			scroll.x = _x;
			scroll.y = _y;
			scroll.width = _width;
			scroll.height = _height;
			
			
			UI = new Sprite();
			
			if(Facade.getInstance(CoreConst.CORE).retrieveProxy(ChatViewBmpProxy.NAME))
				chatBmpProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ChatViewBmpProxy.NAME) as ChatViewBmpProxy;
			else{
				chatBmpProxy = new ChatViewBmpProxy;
				Facade.getInstance(CoreConst.CORE).registerProxy(chatBmpProxy);
			}
			
			var bmp:Bitmap = new Bitmap(new BitmapData(650,height+24,true,0))
			bmp.y = tempY;
			bmp.x = 20;
			tempY += bmp.height+10;
			UI.addChild(bmp);
			
			UI.graphics.beginFill(0,0);
			UI.graphics.drawRect(0,0,650,UI.height);
			UI.graphics.endFill();
			scroll.viewPort = UI;
			UI.y = scroll.height - UI.height;
			addChild(scroll);
			
			
		}
		
		private var tempY:Number = 4;
		
		

		//设置其他人聊天内容
		public function setOtherChat(_name:String,_time:String,_otherStr:String,_isColor:Boolean=false,_type:String="text"):void{
			var __name:String = "";
			var __time:String = "";
			var _th:Number = -10;
			
			if(isChangeName(_name,_time) || isChangeTime(_time,_name)){
				__name = _name;
				__time = getTimeFromat(_time);
				_th = 20;
			}
			
			var bmp:MoMoSp = chatBmpProxy.chatboxL(__name,__time,_otherStr,_isColor,_type);
			bmp.y = tempY+_th;
			bmp.x = 20;
			tempY += bmp.height+_th;
			UI.addChild(bmp);
			
			
			
			UI.graphics.clear();
			UI.graphics.beginFill(0,0);
			UI.graphics.drawRect(0,0,650,UI.height);
			UI.graphics.endFill();
			UI.y = scroll.height - UI.height;

			
			
			
			
		}
		
		
		
		//设置自己聊天内容
		public function setMyChat(_time:String,_myStr:String,_type:String="text"):void{
			var __time:String = "";
			var _th:Number = -10;
			
			if(isChangeTime(_time)){
				__time = getTimeFromat(_time);
				_th = 20;
			}
			
			var bmp:MoMoSp = chatBmpProxy.chatboxR(__time,_myStr,_type);
			bmp.y = tempY+_th;
			bmp.x = scroll.width-bmp.width;
			tempY += bmp.height+_th;
			UI.addChild(bmp);
			
			UI.graphics.clear();
			UI.graphics.beginFill(0,0);
			UI.graphics.drawRect(0,0,650,UI.height);
			UI.graphics.endFill();
			UI.y = scroll.height - UI.height;
			

		}
		private var oldPos:Number = 0;
		private var oldHeight:Number = 1;
//		public var isReset:Boolean;
		public function removeUI():void{
			oldHeight =  UI.height;
			oldPos = UI.y;
			if(UI.numChildren > 0){
				UI.removeChildren(0,UI.numChildren-1);
				
				tempY = 4;
				UI.y = scroll.height;
			}
			
		}
		
		//复位历史坐标
		public function resetPos():void{
			var v:Number = (UI.height - oldHeight);
			if(v>=0){
				UI.y = oldPos-v;
			}						
		}
		
		
		
		
		
		
		
		
		/**
		 * 清除过长数据
		 */		
		private function clearMainChat():void{
			
			//超过12条记录，清楚前6条。
			/*if(spList && spList.length > 12){
				spList.splice(0,1);
				
				_layoutViewPort.removeChildren(0,-1);
				
				
				
				for(var i:int=0;i<spList.length;i++){
					spList[i].y = getLabHeight();
					_layoutViewPort.addChild(spList[i]);
				}
			}*/
		}
		
		
		//20130821-153445   ->   2013-08-21 15:34:45
		private function getTimeFromat(_time:String):String{
			
			var __time:String = 
				_time.substr(0,4) + "-"+
				_time.substr(4,2) + "-"+
				_time.substr(6,2) + " "+
				_time.substr(9,2) + ":"+
				_time.substr(11,2) + ":"+
				_time.substr(13,2);
			
			
			return __time;
		}
		
		private var curName:String = "";
		private var curTime:String = "";
		private function isChangeName(_name:String,_time:String):Boolean{
			//换了人物
			if(curName == "" || curName != _name){
				
				curName = _name;
				curTime = _time;
				
				return true;
				
				
			}else
				return false;
			
			
		}
		private function isChangeTime(_time:String,_name:String=""):Boolean{
			//换了时间
			if(curTime == "" ||
				curTime.substr(0,4) != _time.substr(0,4) || //年
				curTime.substr(4,2) != _time.substr(4,2) || //月
				curTime.substr(6,2) != _time.substr(6,2) || //日
				curTime.substr(9,2) != _time.substr(9,2) || //时
				(int(curTime.substr(11,2)) - int(_time.substr(11,2))>=1) //分
			){
				
				curTime = _time;
				curName = _name;
				
				return true;
				
				
			}else
				return false;
			
		}
		

		
	}
}