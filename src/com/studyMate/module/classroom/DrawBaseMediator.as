package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.IGraphicsData;
	import flash.display.Shape;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	
	/**
	 * note
	 * 2014-6-16下午5:18:15
	 * Author wt
	 *
	 */	
	
	public class DrawBaseMediator extends ScreenBaseMediator
	{
		protected var _commands:Vector.<IGraphicsData>;
		protected var tempCommands:Vector.<IGraphicsData>;
		protected var canvas:Shape;
		protected var isSelfBoard:Boolean;//是否是自己的面板
		protected var pareVO:SwitchScreenVO;

		
		public function DrawBaseMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRemove():void
		{
			AppLayoutUtils.cpuLayer.removeChild(canvas);
			canvas = null;
		}
		override public function onRegister():void
		{
			_commands = new Vector.<IGraphicsData>;
			tempCommands = new Vector.<IGraphicsData>;
			canvas = new Shape();
			AppLayoutUtils.cpuLayer.addChild(canvas);
		}
		
				
		
		public function drawBoardHander(weixinVO:WeixinVO):void{
			switch(weixinVO.minf){
				case 'A':									
					try{						
						if(weixinVO.mtxt) weixinVO.mtxt.uncompress();		
						var vec:Vector.<IGraphicsData> = weixinVO.mtxt.readObject();
					}catch(e:Error){
//						trace('画板数据错误');
						return;
					}
					var temp:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
					for(var i:int=0;i<vec.length;i++){						
						_commands.push(vec[i]);
						temp.push(vec[i]);
					}
					canvas.graphics.drawGraphicsData(temp);
					tempCommands.length = 0;	
					addDraw();
					break;
				case "L":
					if(_commands.length>1){
						tempCommands.push(_commands.pop());
						tempCommands.push(_commands.pop());
					}
					canvas.graphics.clear();
					canvas.graphics.drawGraphicsData(_commands);
					break;
				case "R":
					if(tempCommands.length>1){
						_commands.push(tempCommands.pop());
						_commands.push(tempCommands.pop());
					}
					canvas.graphics.clear();
					canvas.graphics.drawGraphicsData(_commands);
					break;
				case "C":
					if(weixinVO.mtxt.toString()=='all'){	
//						if(PackData.app.head.dwOperID.toString() != messageVO.sedid){							
						clearAllDraw();
//						}
					}else{
						clearSelfDraw();
					}
					break;
			}
		}
		public function addDraw():void{
			
		}
		
		// 清除自己的画图数据
		public function clearSelfDraw():void{
			
		}

		//清理全部画图数据
		public function clearAllDraw():void{
			
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			
		}
	}
}