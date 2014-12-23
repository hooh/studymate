package com.studyMate.world.component.SVGEditor.controller
{
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.model.EditSVGProxy;
	import com.studyMate.world.component.SVGEditor.model.MoveStageProxy;
	import com.studyMate.world.component.SVGEditor.model.SWFLoadProxy;
	import com.studyMate.world.model.FormulaMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class InitializeSVGCommand extends SimpleCommand
	{
		public function InitializeSVGCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			/*------------------数据----------------------------*/
			facade.registerProxy(new SWFLoadProxy);
			facade.registerProxy(new EditSVGProxy);
			facade.registerProxy(new MoveStageProxy);
			
			
			facade.registerMediator(new FormulaMediator);
			
			/*----------------------------命令-----------------------------------*/
			facade.registerCommand(SVGConst.LOAD_SWF,SWFLoadCommand);
			facade.registerCommand(SVGConst.REMOVE_SVG,RemoveSVGCommand);
			facade.registerCommand(SVGConst.MOVE_HAND_BEGIN,MoveHandCommand);
			facade.registerCommand(SVGConst.UPDATE_SWF_LIBRARY,SWFLoadCommand);
		}
		
	}
}