package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaMetadataProfileField extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var xPath : String;

		public var key : String;

		public var label : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
