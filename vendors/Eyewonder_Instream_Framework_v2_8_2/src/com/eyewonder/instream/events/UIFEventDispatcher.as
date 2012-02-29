package com.eyewonder.instream.events {
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import com.eyewonder.instream.debugger.UIFSendToPanel;
		
	public class UIFEventDispatcher extends EventDispatcher {
		private var eventListeners:Array = new Array();
		
		public function UIFEventDispatcher( target:IEventDispatcher = null ) {
			super(target);
		}
		
		public override function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			
			if ( type != UIFEvent.CONTROL_EVENT && type != UIFEvent.TRACK_EVENT && type != UIFEvent.ERROR_EVENT ) {
				var store:Object = { type: type, listener: listener };
			
				eventListeners.push( store );
			}
			
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		public function listenerCleanup():void {
			while ( eventListeners.length > 0 ) {
				var event:Object = eventListeners.pop();
			
				super.removeEventListener( event.type, event.listener );
			}
		}
	}
	
}