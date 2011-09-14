package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaWidgetBaseFilter extends KalturaFilter
	{
		public var idEqual : String;

		public var idIn : String;

		public var sourceWidgetIdEqual : String;

		public var rootWidgetIdEqual : String;

		public var partnerIdEqual : int = int.MIN_VALUE;

		public var entryIdEqual : String;

		public var uiConfIdEqual : int = int.MIN_VALUE;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var partnerDataLike : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('sourceWidgetIdEqual');
			arr.push('rootWidgetIdEqual');
			arr.push('partnerIdEqual');
			arr.push('entryIdEqual');
			arr.push('uiConfIdEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('partnerDataLike');
			return arr;
		}
	}
}
