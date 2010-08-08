package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSearchAuthData extends BaseFlexVo
	{
		public var authData : String;
		public var loginUrl : String;
		public var message : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('authData');
			propertyList.push('loginUrl');
			propertyList.push('message');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('authData');
			arr.push('loginUrl');
			arr.push('message');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('authData');
			arr.push('loginUrl');
			arr.push('message');
			return arr;
		}

	}
}
