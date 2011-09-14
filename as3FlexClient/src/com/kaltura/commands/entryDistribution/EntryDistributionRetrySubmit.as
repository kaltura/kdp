package com.kaltura.commands.entryDistribution
{
	import com.kaltura.delegates.entryDistribution.EntryDistributionRetrySubmitDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryDistributionRetrySubmit extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function EntryDistributionRetrySubmit( id : int )
		{
			service= 'contentdistribution_entrydistribution';
			action= 'retrySubmit';

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
			delegate = new EntryDistributionRetrySubmitDelegate( this , config );
		}
	}
}
