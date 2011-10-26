package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseRestriction;

	[Bindable]
	public dynamic class KalturaIpAddressRestriction extends KalturaBaseRestriction
	{
		/** 
		* Ip address restriction type (Allow or deny)
		* */ 
		public var ipAddressRestrictionType : int = int.MIN_VALUE;

		/** 
		* Comma separated list of ip address to allow to deny 
		* */ 
		public var ipAddressList : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('ipAddressRestrictionType');
			arr.push('ipAddressList');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
