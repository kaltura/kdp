package com.kaltura.commands.syndicationFeed
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;
	import com.kaltura.delegates.syndicationFeed.SyndicationFeedUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class SyndicationFeedUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param syndicationFeed KalturaBaseSyndicationFeed
		 **/
		public function SyndicationFeedUpdate( id : String,syndicationFeed : KalturaBaseSyndicationFeed )
		{
			service= 'syndicationfeed';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(syndicationFeed, 'syndicationFeed');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SyndicationFeedUpdateDelegate( this , config );
		}
	}
}
