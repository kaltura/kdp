package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaDocumentEntry extends KalturaBaseEntry
	{
		/** 
		* The type of the document		* */ 
		public var documentType : int = int.MIN_VALUE;

		/** 
		* Comma separated asset params ids that exists for this media entry
		* */ 
		public var assetParamsIds : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('documentType');
			return arr;
		}

	}
}
