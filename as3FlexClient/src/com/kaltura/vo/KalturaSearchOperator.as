package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchItem;

	[Bindable]
	public dynamic class KalturaSearchOperator extends KalturaSearchItem
	{
		public var type : int = int.MIN_VALUE;

		public var items : Array = new Array();

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('type');
			arr.push('items');
			return arr;
		}
	}
}
