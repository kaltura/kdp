package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCropDimensions;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaConversionProfile extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var name : String;

		public var description : String;

		public var createdAt : int = int.MIN_VALUE;

		public var flavorParamsIds : String;

		public var isDefault : int = int.MIN_VALUE;

		public var cropDimensions : KalturaCropDimensions;

		public var clipStart : int = int.MIN_VALUE;

		public var clipDuration : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('flavorParamsIds');
			arr.push('isDefault');
			arr.push('cropDimensions');
			arr.push('clipStart');
			arr.push('clipDuration');
			return arr;
		}
	}
}
