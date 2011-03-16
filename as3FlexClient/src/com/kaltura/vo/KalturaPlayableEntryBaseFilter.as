package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntryFilter;

	[Bindable]
	public dynamic class KalturaPlayableEntryBaseFilter extends KalturaBaseEntryFilter
	{
		public var durationLessThan : int = int.MIN_VALUE;

		public var durationGreaterThan : int = int.MIN_VALUE;

		public var durationLessThanOrEqual : int = int.MIN_VALUE;

		public var durationGreaterThanOrEqual : int = int.MIN_VALUE;

		public var msDurationLessThan : int = int.MIN_VALUE;

		public var msDurationGreaterThan : int = int.MIN_VALUE;

		public var msDurationLessThanOrEqual : int = int.MIN_VALUE;

		public var msDurationGreaterThanOrEqual : int = int.MIN_VALUE;

		public var durationTypeMatchOr : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('durationLessThan');
			arr.push('durationGreaterThan');
			arr.push('durationLessThanOrEqual');
			arr.push('durationGreaterThanOrEqual');
			arr.push('msDurationLessThan');
			arr.push('msDurationGreaterThan');
			arr.push('msDurationLessThanOrEqual');
			arr.push('msDurationGreaterThanOrEqual');
			arr.push('durationTypeMatchOr');
			return arr;
		}
	}
}
