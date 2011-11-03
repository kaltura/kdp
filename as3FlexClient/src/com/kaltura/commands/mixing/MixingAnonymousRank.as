package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingAnonymousRankDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingAnonymousRank extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param rank int
		 **/
		public function MixingAnonymousRank( entryId : String,rank : int )
		{
			service= 'mixing';
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
			delegate = new MixingAnonymousRankDelegate( this , config );
		}
	}
}
