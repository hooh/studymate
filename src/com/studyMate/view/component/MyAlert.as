package com.studyMate.view.component
{
	import com.pialabs.eskimo.controls.SkinnableAlert;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	public final class MyAlert extends SkinnableAlert
	{
		public function MyAlert()
		{
			
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
		}
		
		public static function show(text:String = "", title:String = "", flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null):SkinnableAlert
		{
			/*var modal:Boolean = (flags & SkinnableAlert.NONMODAL) ? false : true;
			
			if (!parent)
			{
				var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
				// no types so no dependencies
				var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
				if (mp && mp.useSWFBridge())
				{
					parent = Sprite(sm.getSandboxRoot());
				}
				else
				{
					parent = Sprite(FlexGlobals.topLevelApplication);
				}
			}*/
			
			
			var alert:SkinnableAlert = new SkinnableAlert();
			
			/*if (flags & SkinnableAlert.OK || flags & SkinnableAlert.CANCEL || flags & SkinnableAlert.YES || flags & SkinnableAlert.NO)
			{
				alert.buttonFlags = flags;
			}
			
			alert.text = text;
			alert.title = title;
			
			if (closeHandler != null)
			{
				alert.addEventListener(CloseEvent.CLOSE, closeHandler);
			}
			
			alert.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
			
			
			PopUpManager.addPopUp(alert, parent, modal);*/
			
			return alert;
		}
		
		
	}
}