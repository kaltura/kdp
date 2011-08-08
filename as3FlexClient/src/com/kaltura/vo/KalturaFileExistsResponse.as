package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFileExistsResponse extends BaseFlexVo
	{
		public var exists : Boolean;

		public var sizeOk : Boolean;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('exists');
			arr.push('sizeOk');
			return arr;
		}
	}
}
