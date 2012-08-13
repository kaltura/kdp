package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.model.ExternalInterfaceProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ExternalInterfaceMediator extends Mediator
	{
		public static const NAME:String = "externalInterfaceMediator";
		private var _callBacks : Array = new Array();
		
		/**
		 * Get a hold of the External Interface Proxy  
		 */		
		private var _extProxy : ExternalInterfaceProxy;
		
		/**
		 * Constructor 
		 * @param mediatorName
		 * @param viewComponent
		 * 
		 */		
		public function ExternalInterfaceMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, null);
		}
		/**
		 * set the list notifications the html is intrest of
		 * @param arr
		 * 
		 */		
		public function set callBacks( arr : Array ) : void
		{
			_callBacks = arr;
		}
		
		/**
		 * when register we subscribe the html wrapper to notifications of he's intrests
		 * @return 
		 * 
		 */		
		override public function listNotificationInterests():Array
		{
			return _callBacks;
		}
		
		/**
		 * Call the html page with the notifications he subscribe to
		 * @param note
		 * 
		 */		
		override public function handleNotification(note:INotification):void
		{
			_extProxy = facade.retrieveProxy( ExternalInterfaceProxy.NAME ) as ExternalInterfaceProxy;
			_extProxy.call( note.getName() , note.getBody() );
		}
		
	}
}