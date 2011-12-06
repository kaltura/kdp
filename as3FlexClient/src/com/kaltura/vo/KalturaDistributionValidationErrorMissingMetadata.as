package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionValidationError;

	[Bindable]
	public dynamic class KalturaDistributionValidationErrorMissingMetadata extends KalturaDistributionValidationError
	{
		/** 
		* 		* */ 
		public var fieldName : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fieldName');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
