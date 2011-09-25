package com.kaltura.commands.baseEntry
{
	import com.kaltura.delegates.baseEntry.BaseEntryAnonymousRankDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryAnonymousRank extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param rank int
		 **/
		public function BaseEntryAnonymousRank( entryId : String,rank : int )
		{
			service= 'baseentry';
			action= 'anonymousRank';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('rank');
			valueArr.push(rank);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryAnonymousRankDelegate( this , config );
		}
	}
}
