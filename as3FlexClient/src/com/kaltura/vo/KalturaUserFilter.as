package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaUserFilter extends KalturaFilter
	{
		public var idEqual : String;
		public var idIn : String;
		public var partnerIdEqual : int = int.MIN_VALUE;
		public var screenNameLike : String;
		public var screenNameStartsWith : String;
		public var emailLike : String;
		public var emailStartsWith : String;
		public var tagsMultiLikeOr : String;
		public var tagsMultiLikeAnd : String;
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('idEqual');
			propertyList.push('idIn');
			propertyList.push('partnerIdEqual');
			propertyList.push('screenNameLike');
			propertyList.push('screenNameStartsWith');
			propertyList.push('emailLike');
			propertyList.push('emailStartsWith');
			propertyList.push('tagsMultiLikeOr');
			propertyList.push('tagsMultiLikeAnd');
			propertyList.push('createdAtGreaterThanOrEqual');
			propertyList.push('createdAtLessThanOrEqual');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('partnerIdEqual');
			arr.push('screenNameLike');
			arr.push('screenNameStartsWith');
			arr.push('emailLike');
			arr.push('emailStartsWith');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('partnerIdEqual');
			arr.push('screenNameLike');
			arr.push('screenNameStartsWith');
			arr.push('emailLike');
			arr.push('emailStartsWith');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			return arr;
		}

	}
}
