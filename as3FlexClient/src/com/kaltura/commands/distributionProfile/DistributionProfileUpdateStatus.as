package com.kaltura.commands.distributionProfile
{
	import com.kaltura.delegates.distributionProfile.DistributionProfileUpdateStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class DistributionProfileUpdateStatus extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param status int
		 **/
		public function DistributionProfileUpdateStatus( id : int,status : int )
		{
			service= 'contentdistribution_distributionprofile';
			action= 'updateStatus';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('status');
			valueArr.push(status);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DistributionProfileUpdateStatusDelegate( this , config );
		}
	}
}
