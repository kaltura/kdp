package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaDistributionProviderBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var typeEqual : String = null;

		/** 
		* 		* */ 
		public var typeIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('typeEqual');
			arr.push('typeIn');
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
