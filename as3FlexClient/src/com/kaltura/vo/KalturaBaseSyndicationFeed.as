package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBaseSyndicationFeed extends BaseFlexVo
	{
		public var id : String;
		public var feedUrl : String;
		public var partnerId : int = int.MIN_VALUE;
		public var playlistId : String;
		public var name : String;
		public var status : int = int.MIN_VALUE;
		public var type : int = int.MIN_VALUE;
		public var landingPage : String;
		public var createdAt : int = int.MIN_VALUE;
		public var allowEmbed : Boolean;
		public var playerUiconfId : int = int.MIN_VALUE;
		public var flavorParamId : int = int.MIN_VALUE;
		public var transcodeExistingContent : Boolean;
		public var addToDefaultConversionProfile : Boolean;
		public var categories : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('feedUrl');
			propertyList.push('partnerId');
			propertyList.push('playlistId');
			propertyList.push('name');
			propertyList.push('status');
			propertyList.push('type');
			propertyList.push('landingPage');
			propertyList.push('createdAt');
			propertyList.push('allowEmbed');
			propertyList.push('playerUiconfId');
			propertyList.push('flavorParamId');
			propertyList.push('transcodeExistingContent');
			propertyList.push('addToDefaultConversionProfile');
			propertyList.push('categories');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('feedUrl');
			arr.push('partnerId');
			arr.push('playlistId');
			arr.push('name');
			arr.push('status');
			arr.push('type');
			arr.push('landingPage');
			arr.push('createdAt');
			arr.push('allowEmbed');
			arr.push('playerUiconfId');
			arr.push('flavorParamId');
			arr.push('transcodeExistingContent');
			arr.push('addToDefaultConversionProfile');
			arr.push('categories');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('playlistId');
			arr.push('name');
			arr.push('landingPage');
			arr.push('allowEmbed');
			arr.push('playerUiconfId');
			arr.push('flavorParamId');
			arr.push('transcodeExistingContent');
			arr.push('addToDefaultConversionProfile');
			arr.push('categories');
			return arr;
		}

	}
}
