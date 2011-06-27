package com.kaltura.commands.entryDistribution
{
	import com.kaltura.delegates.entryDistribution.EntryDistributionSubmitAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryDistributionSubmitAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param submitWhenReady Boolean
		 **/
		public function EntryDistributionSubmitAdd( id : int,submitWhenReady : Boolean=false )
		{
			service= 'contentdistribution_entrydistribution';
			action= 'submitAdd';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('submitWhenReady');
			valueArr.push(submitWhenReady);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EntryDistributionSubmitAddDelegate( this , config );
		}
	}
}
