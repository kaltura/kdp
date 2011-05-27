package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaUploadTokenBaseFilter extends KalturaFilter
	{
		public var idEqual : String;

		public var idIn : String;

		public var userIdEqual : String;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('userIdEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			return arr;
		}
	}
}
