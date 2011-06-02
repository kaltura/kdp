package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSearch extends BaseFlexVo
	{
		public var keyWords : String;

		public var searchSource : int = int.MIN_VALUE;

		public var mediaType : int = int.MIN_VALUE;

		public var extraData : String;

		public var authData : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('keyWords');
			arr.push('searchSource');
			arr.push('mediaType');
			arr.push('extraData');
			arr.push('authData');
			return arr;
		}
	}
}
