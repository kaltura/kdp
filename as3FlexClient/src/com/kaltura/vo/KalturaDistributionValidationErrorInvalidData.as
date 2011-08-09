package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionValidationError;

	[Bindable]
	public dynamic class KalturaDistributionValidationErrorInvalidData extends KalturaDistributionValidationError
	{
		/** 
		* 		* */ 
		public var fieldName : String;

		/** 
		* 		* */ 
		public var validationErrorType : int = int.MIN_VALUE;

		/** 
		* Parameter of the validation error
For example, minimum value for KalturaDistributionValidationErrorType::STRING_TOO_SHORT validation error		* */ 
		public var validationErrorParam : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fieldName');
			arr.push('validationErrorType');
			arr.push('validationErrorParam');
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
