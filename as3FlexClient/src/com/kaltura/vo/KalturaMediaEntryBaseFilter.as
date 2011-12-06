package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntryFilter;

	[Bindable]
	public dynamic class KalturaMediaEntryBaseFilter extends KalturaPlayableEntryFilter
	{
		/** 
		* 		* */ 
		public var mediaTypeEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var mediaTypeIn : String = null;

		/** 
		* 		* */ 
		public var mediaDateGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var mediaDateLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var flavorParamsIdsMatchOr : String = null;

		/** 
		* 		* */ 
		public var flavorParamsIdsMatchAnd : String = null;

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

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
