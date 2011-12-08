package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaEntryMetadata extends BaseFlexVo
	{
		public var entry : KalturaBaseEntry;

		public var metadatas : Array = new Array();

public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
