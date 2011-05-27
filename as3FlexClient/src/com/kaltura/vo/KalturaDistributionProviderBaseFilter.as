package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaDistributionProviderBaseFilter extends KalturaFilter
	{
		public var typeEqual : String;

		public var typeIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('typeEqual');
			arr.push('typeIn');
			return arr;
		}
	}
}
