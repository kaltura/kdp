package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaLiveStreamBitrate extends BaseFlexVo
	{
		public var bitrate : int = int.MIN_VALUE;
		public var width : int = int.MIN_VALUE;
		public var height : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('bitrate');
			propertyList.push('width');
			propertyList.push('height');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('bitrate');
			arr.push('width');
			arr.push('height');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('bitrate');
			arr.push('width');
			arr.push('height');
			return arr;
		}

	}
}
