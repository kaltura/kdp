package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaAssetParamsBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var systemNameEqual : String = null;

		/** 
		* 		* */ 
		public var systemNameIn : String = null;

		/** 
		* 		* */ 
		public var isSystemDefaultEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var tagsEqual : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
			arr.push('isSystemDefaultEqual');
			arr.push('tagsEqual');
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
