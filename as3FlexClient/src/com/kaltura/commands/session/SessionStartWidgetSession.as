package com.kaltura.commands.session
{
	import com.kaltura.delegates.session.SessionStartWidgetSessionDelegate;
	import com.kaltura.net.KalturaCall;

	public class SessionStartWidgetSession extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param widgetId String
		 * @param expiry int
		 **/
		public function SessionStartWidgetSession( widgetId : String,expiry : int=86400 )
		{
			service= 'session';
			action= 'startWidgetSession';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('widgetId');
			valueArr.push(widgetId);
			keyArr.push('expiry');
			valueArr.push(expiry);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SessionStartWidgetSessionDelegate( this , config );
		}
	}
}
