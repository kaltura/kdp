package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSystemPartnerPackage extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var name : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('name');
			return arr;
		}
	}
}
