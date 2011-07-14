package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaConversionProfileAssetParamsBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var conversionProfileIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var conversionProfileIdIn : String;

		/** 
		* 		* */ 
		public var assetParamsIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var assetParamsIdIn : String;

		/** 
		* 		* */ 
		public var readyBehaviorEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var readyBehaviorIn : String;

		/** 
		* 		* */ 
		public var originEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var originIn : String;

		/** 
		* 		* */ 
		public var systemNameEqual : String;

		/** 
		* 		* */ 
		public var systemNameIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('conversionProfileIdEqual');
			arr.push('conversionProfileIdIn');
			arr.push('assetParamsIdEqual');
			arr.push('assetParamsIdIn');
			arr.push('readyBehaviorEqual');
			arr.push('readyBehaviorIn');
			arr.push('originEqual');
			arr.push('originIn');
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
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
