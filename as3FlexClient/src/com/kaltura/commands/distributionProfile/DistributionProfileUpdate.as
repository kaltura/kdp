package com.kaltura.commands.distributionProfile
{
	import com.kaltura.vo.KalturaDistributionProfile;
	import com.kaltura.delegates.distributionProfile.DistributionProfileUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class DistributionProfileUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param distributionProfile KalturaDistributionProfile
		 **/
		public function DistributionProfileUpdate( id : int,distributionProfile : KalturaDistributionProfile )
		{
			service= 'contentdistribution_distributionprofile';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(distributionProfile, 'distributionProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DistributionProfileUpdateDelegate( this , config );
		}
	}
}
