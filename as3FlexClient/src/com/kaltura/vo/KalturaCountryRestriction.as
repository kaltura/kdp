package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseRestriction;

	[Bindable]
	public dynamic class KalturaCountryRestriction extends KalturaBaseRestriction
	{
		/** 
		* Country restriction type (Allow or deny)
		* */ 
		public var countryRestrictionType : int = int.MIN_VALUE;

		/** 
		* Comma separated list of country codes to allow to deny 
		* */ 
		public var countryList : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('countryRestrictionType');
			arr.push('countryList');
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
