package com.kaltura.commands.syndicationFeed
{
	import com.kaltura.delegates.syndicationFeed.SyndicationFeedDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class SyndicationFeedDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function SyndicationFeedDelete( id : String )
		{
			service= 'syndicationfeed';
			action= 'delete';

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
			delegate = new SyndicationFeedDeleteDelegate( this , config );
		}
	}
}
