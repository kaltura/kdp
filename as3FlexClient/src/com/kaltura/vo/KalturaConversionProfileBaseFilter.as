package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaConversionProfileBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var idIn : String = null;

		/** 
		* 		* */ 
		public var statusEqual : String = null;

		/** 
		* 		* */ 
		public var statusIn : String = null;

		/** 
		* 		* */ 
		public var nameEqual : String = null;

		/** 
		* 		* */ 
		public var systemNameEqual : String = null;

		/** 
		* 		* */ 
		public var systemNameIn : String = null;

		/** 
		* 		* */ 
		public var tagsMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var tagsMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var defaultEntryIdEqual : String = null;

		/** 
		* 		* */ 
		public var defaultEntryIdIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('nameEqual');
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('defaultEntryIdEqual');
			arr.push('defaultEntryIdIn');
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
