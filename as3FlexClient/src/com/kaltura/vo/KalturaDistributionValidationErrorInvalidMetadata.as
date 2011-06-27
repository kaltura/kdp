package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionValidationErrorInvalidData;

	[Bindable]
	public dynamic class KalturaDistributionValidationErrorInvalidMetadata extends KalturaDistributionValidationErrorInvalidData
	{
		public var metadataProfileId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('metadataProfileId');
			return arr;
		}
	}
}
