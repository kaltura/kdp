package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaClientNotification extends BaseFlexVo
	{
		public var url : String;

		public var data : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('url');
			arr.push('data');
			return arr;
		}
	}
}
