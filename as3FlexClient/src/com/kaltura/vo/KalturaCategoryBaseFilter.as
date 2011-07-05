package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaCategoryBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var idIn : String;

		public var parentIdEqual : int = int.MIN_VALUE;

		public var parentIdIn : String;

		public var depthEqual : int = int.MIN_VALUE;

		public var fullNameEqual : String;

		public var fullNameStartsWith : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('parentIdEqual');
			arr.push('parentIdIn');
			arr.push('depthEqual');
			arr.push('fullNameEqual');
			arr.push('fullNameStartsWith');
			return arr;
		}
	}
}
