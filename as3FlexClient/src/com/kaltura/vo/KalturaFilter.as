package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchItem;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFilter extends BaseFlexVo
	{
		public var orderBy : String;

		public var advancedSearch : KalturaSearchItem;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('orderBy');
			arr.push('advancedSearch');
			return arr;
		}
	}
}
