package com.kaltura.vo
{
	import com.kaltura.vo.KalturaThumbParamsFilter;

	[Bindable]
	public dynamic class KalturaThumbParamsOutputBaseFilter extends KalturaThumbParamsFilter
	{
		/** 
		* 		* */ 
		public var thumbParamsIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var thumbParamsVersionEqual : String = null;

		/** 
		* 		* */ 
		public var thumbAssetIdEqual : String = null;

		/** 
		* 		* */ 
		public var thumbAssetVersionEqual : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('thumbParamsIdEqual');
			arr.push('thumbParamsVersionEqual');
			arr.push('thumbAssetIdEqual');
			arr.push('thumbAssetVersionEqual');
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
