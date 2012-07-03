package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.stats.StatsReportError;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import flash.net.URLRequestMethod;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaPlayer;
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
		private var _hasStarted:Boolean = false;
		
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
				NotificationType.MEDIA_ERROR,
				NotificationType.PLAYER_PLAYED
			];
		}
		
		/**
		 * Handles the given notifiction 
		 * @param note
		 * 
		 */		
		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case NotificationType.MEDIA_ERROR:
					//notify the server - for troubleshooting
					var player:MediaPlayer = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player;
					var data:MediaErrorEvent = note.getBody().errorEvent as MediaErrorEvent;
					var message:String = "resourceUrl: " + resourceUrl +"| Flavor index : " + player.currentDynamicStreamIndex +"| Error ID: "+ data.error.errorID +"| Error Message: "+ data.error.message +  "| Stack Trace: " + data.error.getStackTrace();
					//if error occured before first play, send also the initial bitrate index
					if (!_hasStarted)
					{
						message += "| Initial flavor index: " + (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).startingIndex;
					}
					
					var sendError:StatsReportError = new StatsReportError(NotificationType.MEDIA_ERROR, message);
					sendError.method = URLRequestMethod.POST;
					
					_kc.post(sendError);	
					
					break;
				case NotificationType.PLAYER_PLAYED:
					_hasStarted = true;
					
					break;
				
			}
		}
	}
}