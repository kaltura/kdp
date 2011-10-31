package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaConversionProfileAssetParams extends BaseFlexVo
	{
		/** 
		* The id of the conversion profile
		* */ 
		public var conversionProfileId : int = int.MIN_VALUE;

		/** 
		* The id of the asset params
		* */ 
		public var assetParamsId : int = int.MIN_VALUE;

		/** 
		* The ingestion origin of the asset params
		* */ 
		public var readyBehavior : int = int.MIN_VALUE;

		/** 
		* The ingestion origin of the asset params
		* */ 
		public var origin : int = int.MIN_VALUE;

		/** 
		* Asset params system name
		* */ 
		public var systemName : String = null;

		/** 
		* Starts conversion even if the decision layer reduced the configuration to comply with the source		* */ 
		public var forceNoneComplied : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('readyBehavior');
			arr.push('origin');
			arr.push('systemName');
			arr.push('forceNoneComplied');
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
