package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntryFilter;

	[Bindable]
	public dynamic class KalturaMediaEntryBaseFilter extends KalturaPlayableEntryFilter
	{
		public var mediaTypeEqual : int = int.MIN_VALUE;

		public var mediaTypeIn : String;

		public var mediaDateGreaterThanOrEqual : int = int.MIN_VALUE;

		public var mediaDateLessThanOrEqual : int = int.MIN_VALUE;

		public var flavorParamsIdsMatchOr : String;

		public var flavorParamsIdsMatchAnd : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('mediaTypeEqual');
			arr.push('mediaTypeIn');
			arr.push('mediaDateGreaterThanOrEqual');
			arr.push('mediaDateLessThanOrEqual');
			arr.push('flavorParamsIdsMatchOr');
			arr.push('flavorParamsIdsMatchAnd');
			return arr;
		}
	}
}
