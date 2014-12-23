package com.studyMate.view.component.myDrawing.helpFile
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	

	/**
	 * 该类的主要目的是为了提高文本滚动效率
	 * 零时转化成位图
	 * 需要接收事件的时候再还原
	 */	
	public class RegisterModelChange
	{
		private var target:DisplayObject;
		private var cantainer:DisplayObjectContainer;
		private var _bmp:Bitmap;//转化成图片了
		
			
		public function RegisterModelChange(_target:DisplayObject)
		{
				target = _target;
				cantainer = _target.parent as DisplayObjectContainer;
		}
		
		/**
		 *组件变图片
		 * @param onComplete 转换完毕执行函数
		 * @param onCompleteParams 函数参数
		 */
		public function toImage(onComplete:Function=null, onCompleteParams:Array=null):void{			
			var localX:Number = target.x;
			var localY:Number = target.y;
			var bmd:BitmapData;
			if(target && cantainer && cantainer.contains(target)){
				bmd = new BitmapData(target.width,target.height,true,0);
				bmd.draw(target,null,null,null,null,true);
				_bmp = new Bitmap(bmd,'auto',true);
				cantainer.removeChild(target);
				cantainer.addChild(_bmp);
				if(onComplete!=null){
					this.action({onComplete:onComplete,onCompleteParams:onCompleteParams});
				}
			}				
			_bmp.x = localX;
			_bmp.y = localY;			
			
		}
		
		/**
		 *图片还原成组件 
		 * @param onComplete 转换完毕执行函数
		 * @param onCompleteParams 函数参数
		 * 
		 */			
		public function toComponent(onComplete:Function=null, onCompleteParams:Array=null):void{
			var localX:Number;
			var localY:Number;
				if(_bmp){
					if(cantainer.contains(_bmp)){
						localX = _bmp.x;
						localX = _bmp.y;
						cantainer.removeChild(_bmp);
						_bmp.bitmapData.dispose();
						_bmp.bitmapData = null;
						_bmp = null;
						cantainer.addChild(target);
						target.x = localX;
						target.y = localY;
						if(onComplete!=null){
							this.action({onComplete:onComplete,onCompleteParams:onCompleteParams});
						}
					}
				}				
		}
		
		private function action(vars:Object=null):void{
			//if(vars.onCompleteParams){
				vars.onComplete.apply(null,vars.onCompleteParams);									
			//}
		}
		
		public function dispose():void{
			if(cantainer){
				cantainer.removeChildren();
			}
			if(_bmp){
				_bmp.bitmapData.dispose();
				_bmp.bitmapData = null;
				_bmp = null;
			}
			target = null;
			cantainer = null;
		}



	}
}