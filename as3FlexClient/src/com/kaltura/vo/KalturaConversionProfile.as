package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCropDimensions;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaConversionProfile extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var status : String;

		public var name : String;

		public var systemName : String;

		public var tags : String;

		public var description : String;

		public var defaultEntryId : String;

		public var createdAt : int = int.MIN_VALUE;

		public var flavorParamsIds : String;

		public var isDefault : int = int.MIN_VALUE;

		public var cropDimensions : KalturaCropDimensions;

		public var clipStart : int = int.MIN_VALUE;

		public var clipDuration : int = int.MIN_VALUE;

		public var xslTransformation : String;

		public var storageProfileId : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('status');
			arr.push('name');
			arr.push('systemName');
			arr.push('tags');
			arr.push('description');
			arr.push('defaultEntryId');
			arr.push('flavorParamsIds');
			arr.push('isDefault');
			arr.push('cropDimensions');
			arr.push('clipStart');
			arr.push('clipDuration');
			arr.push('xslTransformation');
			arr.push('storageProfileId');
			return arr;
		}
	}
}
