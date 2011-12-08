package com.kaltura.commands.entryDistribution
{
	import com.kaltura.delegates.entryDistribution.EntryDistributionServeReturnedDataDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryDistributionServeReturnedData extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param actionType int
		 **/
		public function EntryDistributionServeReturnedData( id : int,actionType : int )
		{
			service= 'contentdistribution_entrydistribution';
			action= 'serveReturnedData';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('actionType');
			valueArr.push(actionType);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EntryDistributionServeReturnedDataDelegate( this , config );
		}
	}
}
