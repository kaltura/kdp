package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchItem;

	[Bindable]
	public dynamic class KalturaSearchCondition extends KalturaSearchItem
	{
		/** 
		* 		* */ 
		public var field : String = null;

		/** 
		* 		* */ 
		public var value : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('field');
			arr.push('value');
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
