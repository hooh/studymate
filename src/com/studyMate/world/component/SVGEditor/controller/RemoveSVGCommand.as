package com.studyMate.world.component.SVGEditor.controller
{
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.model.EditSVGProxy;
	import com.studyMate.world.component.SVGEditor.model.MoveStageProxy;
	import com.studyMate.world.component.SVGEditor.model.SWFLoadProxy;
	import com.studyMate.world.model.FormulaMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RemoveSVGCommand extends SimpleCommand
	{
		public function RemoveSVGCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			/*----------------------移除数据---------------------------*/
			facade.removeProxy(SWFLoadProxy.NAME);
			facade.removeProxy(EditSVGProxy.NAME);
			facade.removeProxy(MoveStageProxy.NAME);
			
			
			facade.removeMediator(FormulaMediator.NAME);
			
			
			/*----------------------移除命令----------------------------*/
			facade.removeCommand(SVGConst.INITIALIZE_SVG);
			facade.removeCommand(SVGConst.LOAD_SWF);
			facade.removeCommand(SVGConst.REMOVE_SVG);
			facade.removeCommand(SVGConst.MOVE_HAND_BEGIN);
			facade.removeCommand(SVGConst.UPDATE_SWF_LIBRARY);
		}
		
	}
}