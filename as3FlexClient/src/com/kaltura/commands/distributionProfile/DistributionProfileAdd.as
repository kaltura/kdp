package com.kaltura.commands.distributionProfile
{
	import com.kaltura.vo.KalturaDistributionProfile;
	import com.kaltura.delegates.distributionProfile.DistributionProfileAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class DistributionProfileAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param distributionProfile KalturaDistributionProfile
		 **/
		public function DistributionProfileAdd( distributionProfile : KalturaDistributionProfile )
		{
			service= 'contentdistribution_distributionprofile';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(distributionProfile, 'distributionProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DistributionProfileAddDelegate( this , config );
		}
	}
}
