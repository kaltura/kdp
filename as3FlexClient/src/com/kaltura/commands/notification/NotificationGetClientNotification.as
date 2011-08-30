package com.kaltura.commands.notification
{
	import com.kaltura.delegates.notification.NotificationGetClientNotificationDelegate;
	import com.kaltura.net.KalturaCall;

	public class NotificationGetClientNotification extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param type int
		 **/
		public function NotificationGetClientNotification( entryId : String,type : int )
		{
			service= 'notification';
			action= 'getClientNotification';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('type');
			valueArr.push(type);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new NotificationGetClientNotificationDelegate( this , config );
		}
	}
}
