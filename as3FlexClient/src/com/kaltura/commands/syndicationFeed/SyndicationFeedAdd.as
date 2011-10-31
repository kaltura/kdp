package com.kaltura.commands.syndicationFeed
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;
	import com.kaltura.delegates.syndicationFeed.SyndicationFeedAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class SyndicationFeedAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param syndicationFeed KalturaBaseSyndicationFeed
		 **/
		public function SyndicationFeedAdd( syndicationFeed : KalturaBaseSyndicationFeed )
		{
			service= 'syndicationfeed';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(syndicationFeed, 'syndicationFeed');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SyndicationFeedAddDelegate( this , config );
		}
	}
}
