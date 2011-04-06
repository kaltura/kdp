package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSystemPartnerUsageItem extends BaseFlexVo
	{
		public var partnerId : int = int.MIN_VALUE;

		public var partnerName : String;

		public var partnerStatus : int = int.MIN_VALUE;

		public var partnerPackage : int = int.MIN_VALUE;

		public var partnerCreatedAt : int = int.MIN_VALUE;

		public var views : int = int.MIN_VALUE;

		public var plays : int = int.MIN_VALUE;

		public var entriesCount : int = int.MIN_VALUE;

		public var totalEntriesCount : int = int.MIN_VALUE;

		public var videoEntriesCount : int = int.MIN_VALUE;

		public var imageEntriesCount : int = int.MIN_VALUE;

		public var audioEntriesCount : int = int.MIN_VALUE;

		public var mixEntriesCount : int = int.MIN_VALUE;

		public var bandwidth : Number = NaN;

		public var totalStorage : Number = NaN;

		public var storage : Number = NaN;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('partnerId');
			arr.push('partnerName');
			arr.push('partnerStatus');
			arr.push('partnerPackage');
			arr.push('partnerCreatedAt');
			arr.push('views');
			arr.push('plays');
			arr.push('entriesCount');
			arr.push('totalEntriesCount');
			arr.push('videoEntriesCount');
			arr.push('imageEntriesCount');
			arr.push('audioEntriesCount');
			arr.push('mixEntriesCount');
			arr.push('bandwidth');
			arr.push('totalStorage');
			arr.push('storage');
			return arr;
		}
	}
}
