package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSessionRestriction;

	[Bindable]
	public dynamic class KalturaPreviewRestriction extends KalturaSessionRestriction
	{
		public var previewLength : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('previewLength');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('previewLength');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('previewLength');
			return arr;
		}

	}
}
