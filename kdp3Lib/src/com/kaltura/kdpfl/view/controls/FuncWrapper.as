package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.util.KTextParser;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class FuncWrapper
	{
		private var action:String;
		private var component:IEventDispatcher;
		private var facade:IFacade;
		
		public function FuncWrapper(facade:IFacade, component:IEventDispatcher, type:String, action:String)
		{
			this.action = action;
			this.component = component;
			this.facade = facade;
			
			component.addEventListener(type, func); 
		}
		
		private function func(e:Event):void
		{
			KTextParser.execute(facade['bindObject'], action);
		}

	}
}