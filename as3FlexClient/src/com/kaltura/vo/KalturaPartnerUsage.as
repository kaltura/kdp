package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaPartnerUsage extends BaseFlexVo
	{
		/** 
		* Partner total hosting in GB on the disk
		* */ 
		public var hostingGB : Number = NaN;

		/** 
		* percent of usage out of partner's package. if usageGB is 5 and package is 10GB, this value will be 50
		* */ 
		public var Percent : Number = NaN;

		/** 
		* package total BW - actually this is usage, which represents BW+storage
		* */ 
		public var packageBW : int = int.MIN_VALUE;

		/** 
		* total usage in GB - including bandwidth and storage
		* */ 
		public var usageGB : int = int.MIN_VALUE;

		/** 
		* date when partner reached the limit of his package (timestamp)
		* */ 
		public var reachedLimitDate : int = int.MIN_VALUE;

		/** 
		* a semi-colon separated list of comma-separated key-values to represent a usage graph.
keys could be 1-12 for a year view (1,1.2;2,1.1;3,0.9;...;12,1.4;)
keys could be 1-[28,29,30,31] depending on the requested month, for a daily view in a given month (1,0.4;2,0.2;...;31,0.1;)
		* */ 
		public var usageGraph : String;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
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
