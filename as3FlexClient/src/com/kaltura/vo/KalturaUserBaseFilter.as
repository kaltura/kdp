package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaUserBaseFilter extends KalturaFilter
	{
		public var partnerIdEqual : int = int.MIN_VALUE;

		public var screenNameLike : String;

		public var screenNameStartsWith : String;

		public var emailLike : String;

		public var emailStartsWith : String;

		public var tagsMultiLikeOr : String;

		public var tagsMultiLikeAnd : String;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var isAdminEqual : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('partnerIdEqual');
			arr.push('screenNameLike');
			arr.push('screenNameStartsWith');
			arr.push('emailLike');
			arr.push('emailStartsWith');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('isAdminEqual');
			return arr;
		}
	}
}
