package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaAssetParamsBaseFilter extends KalturaFilter
	{
		public var systemNameEqual : String;

		public var systemNameIn : String;

		public var isSystemDefaultEqual : int = int.MIN_VALUE;

		public var tagsEqual : String;

		public var formatEqual : String;

		public var originEqual : int = int.MIN_VALUE;

		public var originIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
			arr.push('isSystemDefaultEqual');
			arr.push('tagsEqual');
			arr.push('formatEqual');
			arr.push('originEqual');
			arr.push('originIn');
			return arr;
		}
	}
}
