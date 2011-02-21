package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDistributionProvider extends BaseFlexVo
	{
		public var type : String;

		public var name : String;

		public var scheduleUpdateEnabled : Boolean;

		public var deleteInsteadUpdate : Boolean;

		public var intervalBeforeSunrise : int = int.MIN_VALUE;

		public var intervalBeforeSunset : int = int.MIN_VALUE;

		public var updateRequiredEntryFields : String;

		public var updateRequiredMetadataXPaths : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('scheduleUpdateEnabled');
			arr.push('deleteInsteadUpdate');
			arr.push('intervalBeforeSunrise');
			arr.push('intervalBeforeSunset');
			arr.push('updateRequiredEntryFields');
			arr.push('updateRequiredMetadataXPaths');
			return arr;
		}
	}
}
