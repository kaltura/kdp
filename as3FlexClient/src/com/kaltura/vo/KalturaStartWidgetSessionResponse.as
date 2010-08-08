package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaStartWidgetSessionResponse extends BaseFlexVo
	{
		public var partnerId : int = int.MIN_VALUE;
		public var ks : String;
		public var userId : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('partnerId');
			propertyList.push('ks');
			propertyList.push('userId');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('partnerId');
			arr.push('ks');
			arr.push('userId');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
