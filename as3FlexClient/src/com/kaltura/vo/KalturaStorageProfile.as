package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaStorageProfile extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var name : String;

		public var desciption : String;

		public var status : int = int.MIN_VALUE;

		public var protocol : int = int.MIN_VALUE;

		public var storageUrl : String;

		public var storageBaseDir : String;

		public var storageUsername : String;

		public var storagePassword : String;

		public var storageFtpPassiveMode : Boolean;

		public var deliveryHttpBaseUrl : String;

		public var deliveryRmpBaseUrl : String;

		public var deliveryIisBaseUrl : String;

		public var minFileSize : int = int.MIN_VALUE;

		public var maxFileSize : int = int.MIN_VALUE;

		public var flavorParamsIds : String;

		public var maxConcurrentConnections : int = int.MIN_VALUE;

		public var pathManagerClass : String;

		public var urlManagerClass : String;

		public var trigger : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('desciption');
			arr.push('status');
			arr.push('protocol');
			arr.push('storageUrl');
			arr.push('storageBaseDir');
			arr.push('storageUsername');
			arr.push('storagePassword');
			arr.push('storageFtpPassiveMode');
			arr.push('deliveryHttpBaseUrl');
			arr.push('deliveryRmpBaseUrl');
			arr.push('deliveryIisBaseUrl');
			arr.push('minFileSize');
			arr.push('maxFileSize');
			arr.push('flavorParamsIds');
			arr.push('maxConcurrentConnections');
			arr.push('pathManagerClass');
			arr.push('urlManagerClass');
			arr.push('trigger');
			return arr;
		}
	}
}
