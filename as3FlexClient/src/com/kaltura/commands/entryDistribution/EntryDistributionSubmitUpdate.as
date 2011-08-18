package com.kaltura.commands.entryDistribution
{
	import com.kaltura.delegates.entryDistribution.EntryDistributionSubmitUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryDistributionSubmitUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function EntryDistributionSubmitUpdate( id : int )
		{
			service= 'contentdistribution_entrydistribution';
			action= 'submitUpdate';

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
			delegate = new EntryDistributionSubmitUpdateDelegate( this , config );
		}
	}
}
