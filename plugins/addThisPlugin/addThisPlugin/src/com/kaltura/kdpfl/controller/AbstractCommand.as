package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.plugin.component.IForm;
	
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	public class AbstractCommand extends EventDispatcher implements ICommand
	{
		public static const COMMAND_RESPONSE:String	= "commandResponse";
		protected var _form:IForm;
		protected var _facade:IFacade;
		public function AbstractCommand(f:IFacade)
		{
			_facade	= f;
		}
		
		public function execute(form:IForm):void{
			
		}
	}
}