package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaStartWidgetSessionResponse extends BaseFlexVo
	{
		public var partnerId : int = int.MIN_VALUE;

		public var ks : String;

		public var userId : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
