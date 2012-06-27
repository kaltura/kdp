package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.stats.StatsReportError;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import flash.net.URLRequestMethod;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * Mediator for errorNotificationPlugin 
	 * @author Michal
	 * 
	 */	
	public class ErrorNotificationMediator extends Mediator
	{
		/**
		 * mediator name
		 */
		public static const NAME:String = "ErrorNotificationMediator";
		/**
		 * currnt entry ID 
		 */		
		public var entryId:String;
		/**
		 * entry's URL path 
		 */		
		public var resourceUrl:String;
		
		private var _kc:KalturaClient;
		
		public function ErrorNotificationMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
			_kc = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
		}
		
		/**
		 *  
		 * @return array of relevant notifications 
		 * 
		 */		
		override public function listNotificationInterests():Array
		{
			return  [
				NotificationType.MEDIA_ERROR
			];
		}
		
		/**
		 * Handles the given notifiction 
		 * @param note
		 * 
		 */		
		override public function handleNotification(note:INotification):void
		{
			//notify the server - for troubleshooting
			if (note.getName() == NotificationType.MEDIA_ERROR) {
				var data:MediaErrorEvent = note.getBody().errorEvent as MediaErrorEvent;
				var sendError:StatsReportError = new StatsReportError(NotificationType.MEDIA_ERROR, 
					"resourceUrl: " + resourceUrl +"| Error ID: "+ data.error.errorID +"| Error Message: "+ data.error.message +  "| Stack Trace: " + data.error.getStackTrace());
				sendError.method = URLRequestMethod.POST;
				
				_kc.post(sendError);
				
			}
		}
	}
}