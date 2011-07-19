package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDistributionProfile extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var providerType : String;

		public var name : String;

		public var status : int = int.MIN_VALUE;

		public var submitEnabled : int = int.MIN_VALUE;

		public var updateEnabled : int = int.MIN_VALUE;

		public var deleteEnabled : int = int.MIN_VALUE;

		public var reportEnabled : int = int.MIN_VALUE;

		public var autoCreateFlavors : String;

		public var autoCreateThumb : String;

		public var optionalFlavorParamsIds : String;

		public var requiredFlavorParamsIds : String;

		public var optionalThumbDimensions : Array = new Array();

		public var requiredThumbDimensions : Array = new Array();

		public var sunriseDefaultOffset : int = int.MIN_VALUE;

		public var sunsetDefaultOffset : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('status');
			arr.push('submitEnabled');
			arr.push('updateEnabled');
			arr.push('deleteEnabled');
			arr.push('reportEnabled');
			arr.push('autoCreateFlavors');
			arr.push('autoCreateThumb');
			arr.push('optionalFlavorParamsIds');
			arr.push('requiredFlavorParamsIds');
			arr.push('optionalThumbDimensions');
			arr.push('requiredThumbDimensions');
			arr.push('sunriseDefaultOffset');
			arr.push('sunsetDefaultOffset');
			return arr;
		}
	}
}
