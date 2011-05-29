package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaPermissionBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var idIn : String;

		public var typeEqual : int = int.MIN_VALUE;

		public var typeIn : String;

		public var nameEqual : String;

		public var nameIn : String;

		public var friendlyNameLike : String;

		public var descriptionLike : String;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		public var partnerIdEqual : int = int.MIN_VALUE;

		public var partnerIdIn : String;

		public var dependsOnPermissionNamesMultiLikeOr : String;

		public var dependsOnPermissionNamesMultiLikeAnd : String;

		public var tagsMultiLikeOr : String;

		public var tagsMultiLikeAnd : String;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('nameEqual');
			arr.push('nameIn');
			arr.push('friendlyNameLike');
			arr.push('descriptionLike');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('dependsOnPermissionNamesMultiLikeOr');
			arr.push('dependsOnPermissionNamesMultiLikeAnd');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			return arr;
		}
	}
}
