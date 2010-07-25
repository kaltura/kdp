package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaUploadTokenFilter extends KalturaFilter
	{
		public var idEqual : String;
		public var idIn : String;
		public var userIdEqual : String;
		public var statusEqual : int = int.MIN_VALUE;
		public var statusIn : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('idEqual');
			propertyList.push('idIn');
			propertyList.push('userIdEqual');
			propertyList.push('statusEqual');
			propertyList.push('statusIn');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('userIdEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('userIdEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			return arr;
		}

	}
}
