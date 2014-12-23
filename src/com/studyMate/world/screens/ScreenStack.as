package com.studyMate.world.screens
{
	import com.mylib.framework.model.vo.SwitchScreenVO;

	public class ScreenStack
	{
		public var stack:Vector.<SwitchScreenVO>;
		
		public function ScreenStack()
		{
			stack = new Vector.<SwitchScreenVO>;
			
		}
		
		public function push(vo:SwitchScreenVO):void{
			stack.push(vo);
		}
		
		public function pop():SwitchScreenVO{
			return stack.pop();
		}
		
		public function lastScreen():SwitchScreenVO{
			if(!stack.length){
				return null;
			}
			return stack[stack.length-1];
		}
		
		public function lastTwoScreen():SwitchScreenVO{
			if(stack.length-2<0){
				return null;
			}
			return stack[stack.length-2];
		}
		
		public function get length():uint{
			return stack.length;
		}
		
		public function set length(_l:uint):void{
			stack.length=0;
		}
		
	}
}