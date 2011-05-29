package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseRestriction;

	[Bindable]
	public dynamic class KalturaIpAddressRestriction extends KalturaBaseRestriction
	{
		public var ipAddressRestrictionType : int = int.MIN_VALUE;

		public var ipAddressList : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('ipAddressRestrictionType');
			arr.push('ipAddressList');
			return arr;
		}
	}
}
