package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaDataEntry extends KalturaBaseEntry
	{
		public var dataContent : String;

		public var retrieveDataContentByGet : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('dataContent');
			return arr;
		}
	}
}
