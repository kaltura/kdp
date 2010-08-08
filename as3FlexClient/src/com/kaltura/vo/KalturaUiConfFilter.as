package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaUiConfFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;
		public var idIn : String;
		public var nameLike : String;
		public var objTypeEqual : int = int.MIN_VALUE;
		public var tagsMultiLikeOr : String;
		public var tagsMultiLikeAnd : String;
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;
		public var creationModeEqual : int = int.MIN_VALUE;
		public var creationModeIn : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('idEqual');
			propertyList.push('idIn');
			propertyList.push('nameLike');
			propertyList.push('objTypeEqual');
			propertyList.push('tagsMultiLikeOr');
			propertyList.push('tagsMultiLikeAnd');
			propertyList.push('createdAtGreaterThanOrEqual');
			propertyList.push('createdAtLessThanOrEqual');
			propertyList.push('updatedAtGreaterThanOrEqual');
			propertyList.push('updatedAtLessThanOrEqual');
			propertyList.push('creationModeEqual');
			propertyList.push('creationModeIn');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('nameLike');
			arr.push('objTypeEqual');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('creationModeEqual');
			arr.push('creationModeIn');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('nameLike');
			arr.push('objTypeEqual');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('creationModeEqual');
			arr.push('creationModeIn');
			return arr;
		}

	}
}
