package com.studyMate.world.screens
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.DataResultVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class BenchMarkViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "BenchMarkViewMediator";

		public function BenchMarkViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		private var configXML:XML;
		override public function onRegister():void
		{
//			sendNotification(WorldConst.HIDE_MAIN_MENU);
//			sendNotification(WorldConst.HIDE_LEFT_MENU);

			configXML = <config precision="2" title="2011年全球手机销量" ySuffix="亿部">
																		<axis>
																			<x title="厂商" type="field"/>
																			<y title="销量" type="linear"/>
																		</axis>
																		<series>
																			<column xField="label" yField="value"/>
																		</series>
																		<data>
																			<set label="Nokia" value="4.171"/>
																			<set label="Samsung" value="3.294"/>
																			<set label="Apple" value="0.932"/>
																			<set label="LG" value="0.881"/>
																			<set label="ZTE" value="0.661"/>
																			<set label="Others" value="5.521"/>
																		</data>
																	</config>;
			
			
			
//			var chart:Chart2D = new Chart2D();
//			chart.width = 500;
//			chart.height = 500;
//			chart.setConfigXML(configXML.toString());
//			chart.render();
//			Starling.current.nativeOverlay.addChild(chart);
			
			
			
//			var lineTexture:Texture = Assets.getWorldMapTexture("benchMark/coordinateLine");
//			
//			var lineX:Image = new Image(lineTexture);
//			view.addChild(lineX);
//			lineX.x = 100;
//			lineX.y = 700;
//			lineX.scaleX = 900;
//			lineX.scaleY = 5;
//			
//			var lineY:Image = new Image(lineTexture);
//			view.addChild(lineY);
//			lineY.x = 100;
//			lineY.y = 700;
//			lineY.scaleX = 5;
//			lineY.scaleY = -500;
//			
//			
//			var point:Image;
//			for(var i:int=0;i<10;i++){
//				point = new Image(lineTexture);
//				view.addChild(point);
//				
//				point.x = 130+80*i;
//				point.y = 700-40*i;
//				point.scaleX = 5;
//				point.scaleY = 5;
//				
//			}
			
			
			
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void
		{
			super.onRemove();
			
//			sendNotification(WorldConst.SHOW_MAIN_MENU);
//			sendNotification(WorldConst.SHOW_LEFT_MENU);
			
		}
	}
}