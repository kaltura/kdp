package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaCEError extends BaseFlexVo
	{
		public var id : String;
		public var partnerId : int = int.MIN_VALUE;
		public var browser : String;
		public var serverIp : String;
		public var serverOs : String;
		public var phpVersion : String;
		public var ceAdminEmail : String;
		public var type : String;
		public var description : String;
		public var data : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('partnerId');
			propertyList.push('browser');
			propertyList.push('serverIp');
			propertyList.push('serverOs');
			propertyList.push('phpVersion');
			propertyList.push('ceAdminEmail');
			propertyList.push('type');
			propertyList.push('description');
			propertyList.push('data');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('partnerId');
			arr.push('browser');
			arr.push('serverIp');
			arr.push('serverOs');
			arr.push('phpVersion');
			arr.push('ceAdminEmail');
			arr.push('type');
			arr.push('description');
			arr.push('data');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('partnerId');
			arr.push('browser');
			arr.push('serverIp');
			arr.push('serverOs');
			arr.push('phpVersion');
			arr.push('ceAdminEmail');
			arr.push('type');
			arr.push('description');
			arr.push('data');
			return arr;
		}

	}
}
