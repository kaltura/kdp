package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaConversionProfileBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var idIn : String;

		public var statusEqual : String;

		public var statusIn : String;

		public var nameEqual : String;

		public var systemNameEqual : String;

		public var systemNameIn : String;

		public var tagsMultiLikeOr : String;

		public var tagsMultiLikeAnd : String;

		public var defaultEntryIdEqual : String;

		public var defaultEntryIdIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('nameEqual');
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('defaultEntryIdEqual');
			arr.push('defaultEntryIdIn');
			return arr;
		}
	}
}
