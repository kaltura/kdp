package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUserBaseFilter;

	[Bindable]
	public dynamic class KalturaUserFilter extends KalturaUserBaseFilter
	{
		public var idEqual : String;

		public var idIn : String;

		public var loginEnabledEqual : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('loginEnabledEqual');
			return arr;
		}
	}
}
