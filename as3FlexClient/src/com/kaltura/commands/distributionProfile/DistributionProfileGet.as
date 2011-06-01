package com.kaltura.commands.distributionProfile
{
	import com.kaltura.delegates.distributionProfile.DistributionProfileGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class DistributionProfileGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function DistributionProfileGet( id : int )
		{
			service= 'contentdistribution_distributionprofile';
			action= 'get';

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
			delegate = new DistributionProfileGetDelegate( this , config );
		}
	}
}
