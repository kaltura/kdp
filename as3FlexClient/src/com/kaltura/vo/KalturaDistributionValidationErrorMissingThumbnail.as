package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionThumbDimensions;

	import com.kaltura.vo.KalturaDistributionValidationError;

	[Bindable]
	public dynamic class KalturaDistributionValidationErrorMissingThumbnail extends KalturaDistributionValidationError
	{
		public var dimensions : KalturaDistributionThumbDimensions;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('dimensions');
			return arr;
		}
	}
}
