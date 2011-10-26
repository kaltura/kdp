package com.kaltura.vo
{
	import com.kaltura.vo.KalturaOperationAttributes;

	[Bindable]
	public dynamic class KalturaClipAttributes extends KalturaOperationAttributes
	{
		/** 
		* Offset in milliseconds		* */ 
		public var offset : int = int.MIN_VALUE;

		/** 
		* Duration in milliseconds		* */ 
		public var duration : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('offset');
			arr.push('duration');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
