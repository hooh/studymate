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
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.display.*;
	TweenPlugin.activate([ThrowPropsPlugin]);

	public class MyTestMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MyTestMediator";
		
//		var bounds:Rectangle = new Rectangle(30, 30, 250, 230);
		var bounds:Rectangle = new Rectangle(0, 0, 1280, 750);
		var mc:Sprite = new Sprite();
		var blitMask:BlitMask = new BlitMask(mc, bounds.x, bounds.y, bounds.width, bounds.height, false);
		
		var t1:uint, t2:uint, y1:Number, y2:Number, x1:Number, x2:Number, xOverlap:Number, xOffset:Number, yOverlap:Number, yOffset:Number;

		public function MyTestMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			
//			view.addChild(mc);
			mc = view;
			setupTextField(mc, bounds);
			
//			blitMask.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
		}
		
		function mouseDownHandler(event:MouseEvent):void {
			TweenLite.killTweensOf(mc);
			x1 = x2 = mc.x;
			xOffset = view.mouseX - mc.x;
			xOverlap = Math.max(0, mc.width - bounds.width);
			y1 = y2 = mc.y;
			yOffset = view.mouseY - mc.y;
			yOverlap = Math.max(0, mc.height - bounds.height);
			t1 = t2 = getTimer();
			mc.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			mc.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
//			blitMask.bitmapMode = true;
		}
		
		function mouseMoveHandler(event:MouseEvent):void {
			var y:Number = view.mouseY - yOffset;
			//if mc's position exceeds the bounds, make it drag only half as far with each mouse movement (like iPhone/iPad behavior)
			if (y > bounds.top) {
				mc.y = (y + bounds.top) * 0.5;
			} else if (y < bounds.top - yOverlap) {
				mc.y = (y + bounds.top - yOverlap) * 0.5;
			} else {
				mc.y = y;
			}
			var x:Number = view.mouseX - xOffset;
			if (x > bounds.left) {
				mc.x = (x + bounds.left) * 0.5;
			} else if (x < bounds.left - xOverlap) {
				mc.x = (x + bounds.left - xOverlap) * 0.5;
			} else {
				mc.x = x;
			}
			blitMask.update();
			var t:uint = getTimer();
			//if the frame rate is too high, we won't be able to track the velocity as well, so only update the values 20 times per second
			if (t - t2 > 50) {
				x2 = x1;
				x1 = mc.x;
				y2 = y1;
				t2 = t1;
				y1 = mc.y;
				t1 = t;
			}
			event.updateAfterEvent();
		}
		
		function mouseUpHandler(event:MouseEvent):void {
			mc.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			var time:Number = (getTimer() - t2) / 1000;
			var xVelocity:Number = (mc.x - x2) / time;
			var yVelocity:Number = (mc.y - y2) / time;
			ThrowPropsPlugin.to(mc, {throwProps:{
				y:{velocity:yVelocity, max:bounds.top, min:bounds.top - yOverlap, resistance:300},
				x:{velocity:xVelocity, max:bounds.left, min:bounds.left - xOverlap, resistance:300}
			}, onUpdate:blitMask.update, ease:Strong.easeOut
			}, 10, 0.3, 1);
//			blitMask.bitmapMode = false;
		}
		
		function setupTextField(container:Sprite, bounds:Rectangle, padding:Number=20):void {
			var tf:TextField = new TextField();
			tf.width = bounds.width - padding;
			tf.x = tf.y = padding / 2;
			tf.defaultTextFormat = new TextFormat("_sans", 24);
			tf.text = "Click and drag this content and then let go as you're dragging to throw it. Notice how it smoothly glides into place, respecting the initial velocity and the maximum/minimum coordinates.\n\nThrowPropsPlugin allows you to simply define an initial velocity for a property (or multiple properties) as well as optional maximum and/or minimum end values and then it will calculate the appropriate landing position and plot a smooth course based on the easing equation you define (Quad.easeOut by default, as set in TweenLite). This is perfect for flick-scrolling or animating things as though they are being thrown.\n\nFor example, let's say a user clicks and drags a ball and you track its velocity using an ENTER_FRAME handler and then when the user releases the mouse button, you'd determine the velocity but you can't do a normal tween because you don't know exactly where it should land or how long the tween should last (faster initial velocity would mean a longer duration). You need the tween to pick up exactly where the user left off so that it appears to smoothly continue moving at the same velocity they were dragging and then decelerate based on whatever ease you define in your tween.\n\nAs demonstrated here, maybe the final resting value needs to lie within a particular range so that the content doesn't land outside a particular area. But you don't want it to suddenly jerk to a stop when it hits the edge; instead, you want it to ease gently into place even if that means going past the landing spot briefly and easing back (if the initial velocity is fast enough to require that). The whole point is to make it look smooth.\n\nThrowPropsPlugin isn't just for tweening x and y coordinates. It works with any numeric property, so you could use it for spinning the rotation of an object as well. Or the scaleX/scaleY properties. Maybe the user drags to spin a wheel and lets go and you want it to continue increasing the rotation at that velocity, decelerating smoothly until it stops.\n\nOne of the trickiest parts of creating a throwProps tween that looks fluid and natural, particularly if you're applying maximum and/or minimum values, is determining its duration. Typically it's best to have a relatively consistent level of resistance so that if the initial velocity is very fast, it takes longer for the object to come to rest compared to when the initial velocity is slower. You also may want to impose some restrictions on how long a tween can last (if the user drags incredibly fast, you might not want the tween to last 200 seconds). The duration will also affect how far past a max/min boundary the property can potentially go, so you might want to only allow a certain amount of overshoot tolerance. That's why ThrowPropsPlugin has a few static helper methods that make managing all these variables much easier. The one you'll probably use most often is the to() method which is very similar to TweenLite.to() except that it doesn't have a duration parameter and it adds several other optional parameters.\n\nA unique convenience of ThrowPropsPlugin compared to most other solutions out there which use ENTER_FRAME loops is that everything is reverseable and you can jump to any spot in the tween immediately. So if you create several throwProps tweens, for example, and dump them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects retrace their steps right back to the beginning.\n\nThe overshootTolerance parameter sets a maximum number of seconds that can be added to the tween's duration (if necessary) to accommodate temporarily overshooting the end value before smoothly returning to it at the end of the tween. This can happen in situations where the initial velocity would normally cause it to exceed the max or min values. An example of this would be in the iOS (iPhone or iPad) when you flick-scroll so quickly that the content would shoot past the end of the scroll area. Instead of jerking to a sudden stop when it reaches the edge, the content briefly glides past the max/min position and gently eases back into place. The larger the overshootTolerance the more leeway the tween has to temporarily shoot past the max/min if necessary.Click and drag this content and then let go as you're dragging to throw it. Notice how it smoothly glides into place, respecting the initial velocity and the maximum/minimum coordinates.\n\nThrowPropsPlugin allows you to simply define an initial velocity for a property (or multiple properties) as well as optional maximum and/or minimum end values and then it will calculate the appropriate landing position and plot a smooth course based on the easing equation you define (Quad.easeOut by default, as set in TweenLite). This is perfect for flick-scrolling or animating things as though they are being thrown.\n\nFor example, let's say a user clicks and drags a ball and you track its velocity using an ENTER_FRAME handler and then when the user releases the mouse button, you'd determine the velocity but you can't do a normal tween because you don't know exactly where it should land or how long the tween should last (faster initial velocity would mean a longer duration). You need the tween to pick up exactly where the user left off so that it appears to smoothly continue moving at the same velocity they were dragging and then decelerate based on whatever ease you define in your tween.\n\nAs demonstrated here, maybe the final resting value needs to lie within a particular range so that the content doesn't land outside a particular area. But you don't want it to suddenly jerk to a stop when it hits the edge; instead, you want it to ease gently into place even if that means going past the landing spot briefly and easing back (if the initial velocity is fast enough to require that). The whole point is to make it look smooth.\n\nThrowPropsPlugin isn't just for tweening x and y coordinates. It works with any numeric property, so you could use it for spinning the rotation of an object as well. Or the scaleX/scaleY properties. Maybe the user drags to spin a wheel and lets go and you want it to continue increasing the rotation at that velocity, decelerating smoothly until it stops.\n\nOne of the trickiest parts of creating a throwProps tween that looks fluid and natural, particularly if you're applying maximum and/or minimum values, is determining its duration. Typically it's best to have a relatively consistent level of resistance so that if the initial velocity is very fast, it takes longer for the object to come to rest compared to when the initial velocity is slower. You also may want to impose some restrictions on how long a tween can last (if the user drags incredibly fast, you might not want the tween to last 200 seconds). The duration will also affect how far past a max/min boundary the property can potentially go, so you might want to only allow a certain amount of overshoot tolerance. That's why ThrowPropsPlugin has a few static helper methods that make managing all these variables much easier. The one you'll probably use most often is the to() method which is very similar to TweenLite.to() except that it doesn't have a duration parameter and it adds several other optional parameters.\n\nA unique convenience of ThrowPropsPlugin compared to most other solutions out there which use ENTER_FRAME loops is that everything is reverseable and you can jump to any spot in the tween immediately. So if you create several throwProps tweens, for example, and dump them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects retrace their steps right back to the beginning.\n\nThe overshootTolerance parameter sets a maximum number of seconds that can be added to the tween's duration (if necessary) to accommodate temporarily overshooting the end value before smoothly returning to it at the end of the tween. This can happen in situations where the initial velocity would normally cause it to exceed the max or min values. An example of this would be in the iOS (iPhone or iPad) when you flick-scroll so quickly that the content would shoot past the end of the scroll area. Instead of jerking to a sudden stop when it reaches the edge, the content briefly glides past the max/min position and gently eases back into place. The larger the overshootTolerance the more leeway the tween has to temporarily shoot past the max/min if necessary.Click and drag this content and then let go as you're dragging to throw it. Notice how it smoothly glides into place, respecting the initial velocity and the maximum/minimum coordinates.\n\nThrowPropsPlugin allows you to simply define an initial velocity for a property (or multiple properties) as well as optional maximum and/or minimum end values and then it will calculate the appropriate landing position and plot a smooth course based on the easing equation you define (Quad.easeOut by default, as set in TweenLite). This is perfect for flick-scrolling or animating things as though they are being thrown.\n\nFor example, let's say a user clicks and drags a ball and you track its velocity using an ENTER_FRAME handler and then when the user releases the mouse button, you'd determine the velocity but you can't do a normal tween because you don't know exactly where it should land or how long the tween should last (faster initial velocity would mean a longer duration). You need the tween to pick up exactly where the user left off so that it appears to smoothly continue moving at the same velocity they were dragging and then decelerate based on whatever ease you define in your tween.\n\nAs demonstrated here, maybe the final resting value needs to lie within a particular range so that the content doesn't land outside a particular area. But you don't want it to suddenly jerk to a stop when it hits the edge; instead, you want it to ease gently into place even if that means going past the landing spot briefly and easing back (if the initial velocity is fast enough to require that). The whole point is to make it look smooth.\n\nThrowPropsPlugin isn't just for tweening x and y coordinates. It works with any numeric property, so you could use it for spinning the rotation of an object as well. Or the scaleX/scaleY properties. Maybe the user drags to spin a wheel and lets go and you want it to continue increasing the rotation at that velocity, decelerating smoothly until it stops.\n\nOne of the trickiest parts of creating a throwProps tween that looks fluid and natural, particularly if you're applying maximum and/or minimum values, is determining its duration. Typically it's best to have a relatively consistent level of resistance so that if the initial velocity is very fast, it takes longer for the object to come to rest compared to when the initial velocity is slower. You also may want to impose some restrictions on how long a tween can last (if the user drags incredibly fast, you might not want the tween to last 200 seconds). The duration will also affect how far past a max/min boundary the property can potentially go, so you might want to only allow a certain amount of overshoot tolerance. That's why ThrowPropsPlugin has a few static helper methods that make managing all these variables much easier. The one you'll probably use most often is the to() method which is very similar to TweenLite.to() except that it doesn't have a duration parameter and it adds several other optional parameters.\n\nA unique convenience of ThrowPropsPlugin compared to most other solutions out there which use ENTER_FRAME loops is that everything is reverseable and you can jump to any spot in the tween immediately. So if you create several throwProps tweens, for example, and dump them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects retrace their steps right back to the beginning.\n\nThe overshootTolerance parameter sets a maximum number of seconds that can be added to the tween's duration (if necessary) to accommodate temporarily overshooting the end value before smoothly returning to it at the end of the tween. This can happen in situations where the initial velocity would normally cause it to exceed the max or min values. An example of this would be in the iOS (iPhone or iPad) when you flick-scroll so quickly that the content would shoot past the end of the scroll area. Instead of jerking to a sudden stop when it reaches the edge, the content briefly glides past the max/min position and gently eases back into place. The larger the overshootTolerance the more leeway the tween has to temporarily shoot past the max/min if necessary.Click and drag this content and then let go as you're dragging to throw it. Notice how it smoothly glides into place, respecting the initial velocity and the maximum/minimum coordinates.\n\nThrowPropsPlugin allows you to simply define an initial velocity for a property (or multiple properties) as well as optional maximum and/or minimum end values and then it will calculate the appropriate landing position and plot a smooth course based on the easing equation you define (Quad.easeOut by default, as set in TweenLite). This is perfect for flick-scrolling or animating things as though they are being thrown.\n\nFor example, let's say a user clicks and drags a ball and you track its velocity using an ENTER_FRAME handler and then when the user releases the mouse button, you'd determine the velocity but you can't do a normal tween because you don't know exactly where it should land or how long the tween should last (faster initial velocity would mean a longer duration). You need the tween to pick up exactly where the user left off so that it appears to smoothly continue moving at the same velocity they were dragging and then decelerate based on whatever ease you define in your tween.\n\nAs demonstrated here, maybe the final resting value needs to lie within a particular range so that the content doesn't land outside a particular area. But you don't want it to suddenly jerk to a stop when it hits the edge; instead, you want it to ease gently into place even if that means going past the landing spot briefly and easing back (if the initial velocity is fast enough to require that). The whole point is to make it look smooth.\n\nThrowPropsPlugin isn't just for tweening x and y coordinates. It works with any numeric property, so you could use it for spinning the rotation of an object as well. Or the scaleX/scaleY properties. Maybe the user drags to spin a wheel and lets go and you want it to continue increasing the rotation at that velocity, decelerating smoothly until it stops.\n\nOne of the trickiest parts of creating a throwProps tween that looks fluid and natural, particularly if you're applying maximum and/or minimum values, is determining its duration. Typically it's best to have a relatively consistent level of resistance so that if the initial velocity is very fast, it takes longer for the object to come to rest compared to when the initial velocity is slower. You also may want to impose some restrictions on how long a tween can last (if the user drags incredibly fast, you might not want the tween to last 200 seconds). The duration will also affect how far past a max/min boundary the property can potentially go, so you might want to only allow a certain amount of overshoot tolerance. That's why ThrowPropsPlugin has a few static helper methods that make managing all these variables much easier. The one you'll probably use most often is the to() method which is very similar to TweenLite.to() except that it doesn't have a duration parameter and it adds several other optional parameters.\n\nA unique convenience of ThrowPropsPlugin compared to most other solutions out there which use ENTER_FRAME loops is that everything is reverseable and you can jump to any spot in the tween immediately. So if you create several throwProps tweens, for example, and dump them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects retrace their steps right back to the beginning.\n\nThe overshootTolerance parameter sets a maximum number of seconds that can be added to the tween's duration (if necessary) to accommodate temporarily overshooting the end value before smoothly returning to it at the end of the tween. This can happen in situations where the initial velocity would normally cause it to exceed the max or min values. An example of this would be in the iOS (iPhone or iPad) when you flick-scroll so quickly that the content would shoot past the end of the scroll area. Instead of jerking to a sudden stop when it reaches the edge, the content briefly glides past the max/min position and gently eases back into place. The larger the overshootTolerance the more leeway the tween has to temporarily shoot past the max/min if necessary.Click and drag this content and then let go as you're dragging to throw it. Notice how it smoothly glides into place, respecting the initial velocity and the maximum/minimum coordinates.\n\nThrowPropsPlugin allows you to simply define an initial velocity for a property (or multiple properties) as well as optional maximum and/or minimum end values and then it will calculate the appropriate landing position and plot a smooth course based on the easing equation you define (Quad.easeOut by default, as set in TweenLite). This is perfect for flick-scrolling or animating things as though they are being thrown.\n\nFor example, let's say a user clicks and drags a ball and you track its velocity using an ENTER_FRAME handler and then when the user releases the mouse button, you'd determine the velocity but you can't do a normal tween because you don't know exactly where it should land or how long the tween should last (faster initial velocity would mean a longer duration). You need the tween to pick up exactly where the user left off so that it appears to smoothly continue moving at the same velocity they were dragging and then decelerate based on whatever ease you define in your tween.\n\nAs demonstrated here, maybe the final resting value needs to lie within a particular range so that the content doesn't land outside a particular area. But you don't want it to suddenly jerk to a stop when it hits the edge; instead, you want it to ease gently into place even if that means going past the landing spot briefly and easing back (if the initial velocity is fast enough to require that). The whole point is to make it look smooth.\n\nThrowPropsPlugin isn't just for tweening x and y coordinates. It works with any numeric property, so you could use it for spinning the rotation of an object as well. Or the scaleX/scaleY properties. Maybe the user drags to spin a wheel and lets go and you want it to continue increasing the rotation at that velocity, decelerating smoothly until it stops.\n\nOne of the trickiest parts of creating a throwProps tween that looks fluid and natural, particularly if you're applying maximum and/or minimum values, is determining its duration. Typically it's best to have a relatively consistent level of resistance so that if the initial velocity is very fast, it takes longer for the object to come to rest compared to when the initial velocity is slower. You also may want to impose some restrictions on how long a tween can last (if the user drags incredibly fast, you might not want the tween to last 200 seconds). The duration will also affect how far past a max/min boundary the property can potentially go, so you might want to only allow a certain amount of overshoot tolerance. That's why ThrowPropsPlugin has a few static helper methods that make managing all these variables much easier. The one you'll probably use most often is the to() method which is very similar to TweenLite.to() except that it doesn't have a duration parameter and it adds several other optional parameters.\n\nA unique convenience of ThrowPropsPlugin compared to most other solutions out there which use ENTER_FRAME loops is that everything is reverseable and you can jump to any spot in the tween immediately. So if you create several throwProps tweens, for example, and dump them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects retrace their steps right back to the beginning.\n\nThe overshootTolerance parameter sets a maximum number of seconds that can be added to the tween's duration (if necessary) to accommodate temporarily overshooting the end value before smoothly returning to it at the end of the tween. This can happen in situations where the initial velocity would normally cause it to exceed the max or min values. An example of this would be in the iOS (iPhone or iPad) when you flick-scroll so quickly that the content would shoot past the end of the scroll area. Instead of jerking to a sudden stop when it reaches the edge, the content briefly glides past the max/min position and gently eases back into place. The larger the overshootTolerance the more leeway the tween has to temporarily shoot past the max/min if necessary.";
			tf.multiline = tf.wordWrap = true;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			container.addChild(tf);
			
			container.graphics.beginFill(0xFFFFFF, 1);
			container.graphics.drawRect(0, 0, tf.width + padding, tf.textHeight + padding);
			container.graphics.endFill();
			container.x = bounds.x;
			container.y = bounds.y;
			
		}
		
		
		
		

		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
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