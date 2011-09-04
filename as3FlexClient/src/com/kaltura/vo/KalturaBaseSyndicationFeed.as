package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBaseSyndicationFeed extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : String = null;

		/** 
		* 		* */ 
		public var feedUrl : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* link a playlist that will set what content the feed will include
if empty, all content will be included in feed
		* */ 
		public var playlistId : String = null;

		/** 
		* feed name
		* */ 
		public var name : String = null;

		/** 
		* feed status
		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* feed type
		* */ 
		public var type : int = int.MIN_VALUE;

		/** 
		* Base URL for each video, on the partners site
This is required by all syndication types.		* */ 
		public var landingPage : String = null;

		/** 
		* Creation date as Unix timestamp (In seconds)
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* allow_embed tells google OR yahoo weather to allow embedding the video on google OR yahoo video results
or just to provide a link to the landing page.
it is applied on the video-player_loc property in the XML (google)
and addes media-player tag (yahoo)		* */ 
		public var allowEmbed : Boolean;

		/** 
		* Select a uiconf ID as player skin to include in the kwidget url		* */ 
		public var playerUiconfId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var flavorParamId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var transcodeExistingContent : Boolean;

		/** 
		* 		* */ 
		public var addToDefaultConversionProfile : Boolean;

		/** 
		* 		* */ 
		public var categories : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
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

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('type');
			return arr;
		}

	}
}
