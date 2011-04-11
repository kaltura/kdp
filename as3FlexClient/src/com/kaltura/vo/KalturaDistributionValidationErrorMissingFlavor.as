package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionValidationError;

	[Bindable]
	public dynamic class KalturaDistributionValidationErrorMissingFlavor extends KalturaDistributionValidationError
	{
		public var flavorParamsId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('flavorParamsId');
			return arr;
		}
	}
}
