package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParams;

	import com.kaltura.vo.KalturaFlavorAsset;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFlavorAssetWithParams extends BaseFlexVo
	{
		/** 
		* The Flavor Asset (Can be null when there are params without asset)
		* */ 
		public var flavorAsset : KalturaFlavorAsset;

		/** 
		* The Flavor Params
		* */ 
		public var flavorParams : KalturaFlavorParams;

		/** 
		* The entry id
		* */ 
		public var entryId : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flavorAsset');
			arr.push('flavorParams');
			arr.push('entryId');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
