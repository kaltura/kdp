package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaCropDimensions extends BaseFlexVo
	{
		public var left : int = int.MIN_VALUE;

		public var top : int = int.MIN_VALUE;

		public var width : int = int.MIN_VALUE;

		public var height : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('left');
			arr.push('top');
			arr.push('width');
			arr.push('height');
			return arr;
		}
	}
}
