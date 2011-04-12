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

		public var type : String;

		public var landingPage : String;

		public var createdAt : int = int.MIN_VALUE;

		public var allowEmbed : Boolean;

		public var playerUiconfId : int = int.MIN_VALUE;

		public var flavorParamId : int = int.MIN_VALUE;

		public var transcodeExistingContent : Boolean;

		public var addToDefaultConversionProfile : Boolean;

		public var categories : String;

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
