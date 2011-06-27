package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntryFilter;

	[Bindable]
	public dynamic class KalturaDocumentEntryBaseFilter extends KalturaBaseEntryFilter
	{
		public var documentTypeEqual : int = int.MIN_VALUE;

		public var documentTypeIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('documentTypeEqual');
			arr.push('documentTypeIn');
			return arr;
		}
	}
}
