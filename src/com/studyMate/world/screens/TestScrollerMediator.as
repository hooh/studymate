package com.studyMate.world.screens
{
	import com.doitflash.consts.Easing;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.ScrollConst;
	import com.doitflash.utils.scroll.TouchScroll;
	import com.studyMate.global.Global;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TestScrollerMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "TestScrollerMediator";
		
		private var _scroller:TouchScroll;
		
		private var textfield:TextField;
		
		
		private var myString:String = <![CDATA[The Sensitive Side of Android session at Google I/O in San Francisco, CA walked through best practices and considerations for using mobile device sensor data in Google applications. Here's my notes from the talk:
			
			Sensor Best Practices
			
			When you request sensor data, you can specific rate (how much and how often). Don’t ask for too much data at once, you will need more effort to process more data which can lead to less responsive apps.
			As soon as you can, unregister from sensor data. This prevents your app from processing data when it is not using it and helps mitigate battery drain.
			Proximity sensor: typically used to turn screens off when a phone is near a face. Proximity sensor provides can be continuous or binary values. It is safest to assume binary values for compatibility. These sensors usually only emit data within 5cm proximity.
			An ambient light sensor provides data about general luminosity. Can be used to detect wave or swipe gestures. Be aware the space between fingers and thumb can also be detected, which can effect wave gesture detection.
			Proximity sensor is good for gesture validation. The ambient light sensor is susceptible to light changes in environment. Light sensor can detect type of gesture but the proximity sensor can be used to determine that a gesture actually did take place.
			Kinetic Gestures
			
			Motion (kinetic) related actions: tap, shake, chop, wave, etc.
			Sensplore: an Android app that saves sensor data and emails it to you in a CSV file so you can analyze the data your are getting.
			Kinetcs-related sensors: accelerometer, gravity, gyroscope, linear acceleration, magnetic filed, orientation, and rotation vector. Not all devices support all these sensors.
			Data coming out of the gyroscope is very accurate and useful but it does not correspond to how most code is written. Synthetic sensors abstract raw data into something more useful for developers.
			Inclusion of a gyroscope makes a big difference in gesture accuracy.
			Yaw, pitch, and roll come out as device coordinates not World coordinates. You need to adapt them in order build things like a compass.
			When a device is flipped on its side, the top of the device changes. Be aware this can adjust the data coming in.
			Sensor data can consume lots of power. 10, 20, or 50 times a second data is being passed into your code. It’s not lightweight computing. Only sample as fast as you need to and stop when you don’t need to.
			Sampling rates change between devices. The data has variance and static because it comes from cost-effective components for mobile phones not robust and industry-grade sensors.
			Accelerometer data includes gravity. Will only be 0 when falling or in orbit.
			Many Android games use accelerometer data directly. They require you to hold the device flat and tilt it, which allows them to directly use x and y values as acceleration numbers.
			Nintendo Wii and Kinect can’t be rivaled with typical mobile device sensors. You can usefully measure total acceleration, detect shakes, etc. but you can’t get complete positioning data in space.
			Compass View in the Google Maps app captures very subtle motion of a device. This implementation requires significant math.
			Audio Sensors
			
			There are lots of ways to use microphone data beyond voice recording: baby monitor, inaudible sounds detectable only by apps for indoor location, etc.
			Sound fundamentals: human hearing range is between 20Hz and 20KHz. As you get older, this goes down. Sound waves are made up of pitch (frequency) and loundness (amplitude).
			All Android compatible devices support 44.1 kHz sampling rate. The avoid aliasing, sampling rate must be > 2 x highest frequency component of your signal. Understand your signal before selecting the frequency you need.
			If you use a small buffer, you can update your UI more frequently. If you use a large buffer, you use more processing power and memory but will be more tolerant to failure.
			Audio Signal Processing: need to filter noise. It’s easy to get sensor data but challenging to understand and interpret it.
			Use thresholds to extract useful information. Time combined with sensor data can make the information more useful. Use basic statistics to understand and interpret your data.
]]>;
		
		
		
		
		public function TestScrollerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			setScroller();
			onResize();
			
			
			
		}
		
		
		private function setScroller():void
		{
			if (!_scroller) 
			{
				_scroller =  new TouchScroll();
				
				textfield = new TextField();
				textfield.wordWrap = true;
				var tf:TextFormat = new TextFormat();
				tf.size = 40;
				textfield.defaultTextFormat = tf;
				textfield.autoSize = TextFieldAutoSize.LEFT;
				textfield.width = Global.stageWidth-40;
				
				
				
				textfield.text = myString;
				textfield.height = textfield.textHeight;
			}
			
			_scroller.maskContent = textfield;
			_scroller.enableVirtualBg = true;
			_scroller.mouseWheelSpeed = 5;
			
			_scroller.orientation = Orientation.VERTICAL; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
			_scroller.easeType = Easing.Strong_easeOut;
			_scroller.scrollSpace = 0;
			_scroller.aniInterval = 1;
			_scroller.blurEffect = false;
			_scroller.lessBlurSpeed = 15;
			_scroller.yPerc = 25; // min value is 0, max value is 100
			_scroller.xPerc = 0; // min value is 0, max value is 100
			_scroller.mouseWheelSpeed = 2;
			_scroller.isMouseScroll = false;
			_scroller.isTouchScroll = true;
			_scroller.bitmapMode = ScrollConst.NORMAL;
			_scroller.isStickTouch = false;
			_scroller.holdArea = 7;
			
			view.addChild(_scroller);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		private function onResize(e:*=null):void 
		{
			if (_scroller)
			{
				_scroller.maskWidth = Global.stageWidth-40;
				_scroller.maskHeight = Global.stageHeight-20;
				
				_scroller.x = 20;
				_scroller.y = 10;
			}
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}