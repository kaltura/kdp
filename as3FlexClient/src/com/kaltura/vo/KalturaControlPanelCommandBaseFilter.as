package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaControlPanelCommandBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var idIn : String;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var createdByIdEqual : int = int.MIN_VALUE;

		public var typeEqual : int = int.MIN_VALUE;

		public var typeIn : String;

		public var targetTypeEqual : int = int.MIN_VALUE;

		public var targetTypeIn : String;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('createdByIdEqual');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('targetTypeEqual');
			arr.push('targetTypeIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			return arr;
		}
	}
}
