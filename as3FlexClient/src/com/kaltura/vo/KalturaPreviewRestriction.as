package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSessionRestriction;

	[Bindable]
	public dynamic class KalturaPreviewRestriction extends KalturaSessionRestriction
	{
		/** 
		* The preview restriction length 
		* */ 
		public var previewLength : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('previewLength');
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
