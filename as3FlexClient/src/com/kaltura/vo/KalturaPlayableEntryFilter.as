package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntryFilter;

	[Bindable]
	public dynamic class KalturaPlayableEntryFilter extends KalturaBaseEntryFilter
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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('durationLessThan');
			propertyList.push('durationGreaterThan');
			propertyList.push('durationLessThanOrEqual');
			propertyList.push('durationGreaterThanOrEqual');
			propertyList.push('msDurationLessThan');
			propertyList.push('msDurationGreaterThan');
			propertyList.push('msDurationLessThanOrEqual');
			propertyList.push('msDurationGreaterThanOrEqual');
			propertyList.push('durationTypeMatchOr');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
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
