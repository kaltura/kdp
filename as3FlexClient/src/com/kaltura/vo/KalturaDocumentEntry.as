package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaDocumentEntry extends KalturaBaseEntry
	{
		public var documentType : int = int.MIN_VALUE;

		public var conversionProfileId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
