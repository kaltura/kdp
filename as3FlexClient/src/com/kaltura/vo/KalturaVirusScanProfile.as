package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntryFilter;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaVirusScanProfile extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var name : String;

		public var status : int = int.MIN_VALUE;

		public var engineType : String;

		public var entryFilter : KalturaBaseEntryFilter;

		public var actionIfInfected : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('status');
			arr.push('engineType');
			arr.push('entryFilter');
			arr.push('actionIfInfected');
			return arr;
		}
	}
}
