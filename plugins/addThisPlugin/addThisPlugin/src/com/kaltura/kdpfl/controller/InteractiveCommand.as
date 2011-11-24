package com.kaltura.kdpfl.controller
{
	import org.puremvc.as3.interfaces.IFacade;
	
	public class InteractiveCommand extends AbstractCommand
	{
		public static const NAME:String	= "InteractiveCommand";
		public function InteractiveCommand(f:IFacade)
		{
			super(f);
		}
	}
}