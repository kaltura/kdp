package com.kaltura.kdpfl.plugin.component
{
	import fl.events.SliderEvent;
	
	import flash.events.Event;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ResizerMediator extends Mediator
	{
		public static const NAME : String = "resizerMediator";
		
		public function ResizerMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void 
		{
			//(viewComponent as ResizerPluginCode).addEventListener( SliderEvent.CHANGE , onSizeChange );
		}
		
		
	}
}