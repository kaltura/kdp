package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionValidationError;

	[Bindable]
	public dynamic class KalturaDistributionValidationErrorMissingMetadata extends KalturaDistributionValidationError
	{
		public var fieldName : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fieldName');
			return arr;
		}
	}
}
