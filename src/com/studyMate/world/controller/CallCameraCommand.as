package com.studyMate.world.controller
{
	import com.edu.AirImagePicker;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CallCameraCommand extends SimpleCommand implements ICommand
	{
		public function CallCameraCommand(){
			super();
		}
		
		override public function execute(notification:INotification):void{
			AirImagePicker.getInstance().displayCamera(onImagePicked);
		}
		
		private function onImagePicked(path:String):void{
			sendNotification(WorldConst.CAMERA_OVER, path);
		}
	}
}