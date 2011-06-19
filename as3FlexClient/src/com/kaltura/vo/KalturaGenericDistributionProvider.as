package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProvider;

	[Bindable]
	public dynamic class KalturaGenericDistributionProvider extends KalturaDistributionProvider
	{
		public var id : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var isDefault : Boolean;

		public var status : int = int.MIN_VALUE;

		public var optionalFlavorParamsIds : String;

		public var requiredFlavorParamsIds : String;

		public var optionalThumbDimensions : Array = new Array();

		public var requiredThumbDimensions : Array = new Array();

		public var editableFields : String;

		public var mandatoryFields : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isDefault');
			arr.push('optionalFlavorParamsIds');
			arr.push('requiredFlavorParamsIds');
			arr.push('optionalThumbDimensions');
			arr.push('requiredThumbDimensions');
			arr.push('editableFields');
			arr.push('mandatoryFields');
			return arr;
		}
	}
}
