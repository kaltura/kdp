package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchCondition;

	[Bindable]
	public dynamic class KalturaSearchComparableCondition extends KalturaSearchCondition
	{
		public var comparison : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('comparison');
			return arr;
		}
	}
}
