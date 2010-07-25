package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaDataEntry extends KalturaBaseEntry
	{
		public var dataContent : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('dataContent');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('dataContent');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('dataContent');
			return arr;
		}

	}
}
