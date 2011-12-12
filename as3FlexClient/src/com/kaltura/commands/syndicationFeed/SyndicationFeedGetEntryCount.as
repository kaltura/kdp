package com.kaltura.commands.syndicationFeed
{
	import com.kaltura.delegates.syndicationFeed.SyndicationFeedGetEntryCountDelegate;
	import com.kaltura.net.KalturaCall;

	public class SyndicationFeedGetEntryCount extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param feedId String
		 **/
		public function SyndicationFeedGetEntryCount( feedId : String )
		{
			service= 'syndicationfeed';
			action= 'getEntryCount';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('feedId');
			valueArr.push(feedId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SyndicationFeedGetEntryCountDelegate( this , config );
		}
	}
}
