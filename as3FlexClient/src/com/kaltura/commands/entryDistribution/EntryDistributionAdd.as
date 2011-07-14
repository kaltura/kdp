package com.kaltura.commands.entryDistribution
{
	import com.kaltura.vo.KalturaEntryDistribution;
	import com.kaltura.delegates.entryDistribution.EntryDistributionAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryDistributionAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryDistribution KalturaEntryDistribution
		 **/
		public function EntryDistributionAdd( entryDistribution : KalturaEntryDistribution )
		{
			service= 'contentdistribution_entrydistribution';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(entryDistribution, 'entryDistribution');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EntryDistributionAddDelegate( this , config );
		}
	}
}
