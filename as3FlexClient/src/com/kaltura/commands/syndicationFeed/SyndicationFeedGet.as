package com.kaltura.commands.syndicationFeed
{
	import com.kaltura.delegates.syndicationFeed.SyndicationFeedGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class SyndicationFeedGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function SyndicationFeedGet( id : String )
		{
			service= 'syndicationfeed';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SyndicationFeedGetDelegate( this , config );
		}
	}
}
