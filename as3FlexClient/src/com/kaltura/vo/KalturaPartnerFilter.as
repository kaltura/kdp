package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaPartnerFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;
		public var idIn : String;
		public var nameLike : String;
		public var nameMultiLikeOr : String;
		public var nameMultiLikeAnd : String;
		public var nameEqual : String;
		public var statusEqual : int = int.MIN_VALUE;
		public var statusIn : String;
		public var partnerNameDescriptionWebsiteAdminNameAdminEmailLike : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('idEqual');
			propertyList.push('idIn');
			propertyList.push('nameLike');
			propertyList.push('nameMultiLikeOr');
			propertyList.push('nameMultiLikeAnd');
			propertyList.push('nameEqual');
			propertyList.push('statusEqual');
			propertyList.push('statusIn');
			propertyList.push('partnerNameDescriptionWebsiteAdminNameAdminEmailLike');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('nameLike');
			arr.push('nameMultiLikeOr');
			arr.push('nameMultiLikeAnd');
			arr.push('nameEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('partnerNameDescriptionWebsiteAdminNameAdminEmailLike');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('nameLike');
			arr.push('nameMultiLikeOr');
			arr.push('nameMultiLikeAnd');
			arr.push('nameEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('partnerNameDescriptionWebsiteAdminNameAdminEmailLike');
			return arr;
		}

	}
}
