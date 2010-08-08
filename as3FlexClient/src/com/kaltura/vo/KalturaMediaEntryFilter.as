package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntryFilter;

	[Bindable]
	public dynamic class KalturaMediaEntryFilter extends KalturaPlayableEntryFilter
	{
		public var mediaTypeEqual : int = int.MIN_VALUE;
		public var mediaTypeIn : String;
		public var mediaDateGreaterThanOrEqual : int = int.MIN_VALUE;
		public var mediaDateLessThanOrEqual : int = int.MIN_VALUE;
		public var flavorParamsIdsMatchOr : String;
		public var flavorParamsIdsMatchAnd : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('mediaTypeEqual');
			propertyList.push('mediaTypeIn');
			propertyList.push('mediaDateGreaterThanOrEqual');
			propertyList.push('mediaDateLessThanOrEqual');
			propertyList.push('flavorParamsIdsMatchOr');
			propertyList.push('flavorParamsIdsMatchAnd');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('mediaTypeEqual');
			arr.push('mediaTypeIn');
			arr.push('mediaDateGreaterThanOrEqual');
			arr.push('mediaDateLessThanOrEqual');
			arr.push('flavorParamsIdsMatchOr');
			arr.push('flavorParamsIdsMatchAnd');
			return arr;
		}

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
