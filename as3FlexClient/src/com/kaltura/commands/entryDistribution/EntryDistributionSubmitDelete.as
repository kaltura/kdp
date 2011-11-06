package com.kaltura.commands.entryDistribution
{
	import com.kaltura.delegates.entryDistribution.EntryDistributionSubmitDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryDistributionSubmitDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function EntryDistributionSubmitDelete( id : int )
		{
			service= 'contentdistribution_entrydistribution';
			action= 'submitDelete';

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
			delegate = new EntryDistributionSubmitDeleteDelegate( this , config );
		}
	}
}
