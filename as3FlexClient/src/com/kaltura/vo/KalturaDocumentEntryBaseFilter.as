package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntryFilter;

	[Bindable]
	public dynamic class KalturaDocumentEntryBaseFilter extends KalturaBaseEntryFilter
	{
		/** 
		* 		* */ 
		public var documentTypeEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var documentTypeIn : String = null;

		/** 
		* 		* */ 
		public var assetParamsIdsMatchOr : String = null;

		/** 
		* 		* */ 
		public var assetParamsIdsMatchAnd : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('documentTypeEqual');
			arr.push('documentTypeIn');
			arr.push('assetParamsIdsMatchOr');
			arr.push('assetParamsIdsMatchAnd');
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
