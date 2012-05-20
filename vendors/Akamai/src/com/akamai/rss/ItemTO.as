package com.akamai.rss{


	import flash.events.EventDispatcher;

	[Bindable]
	/**
	 * The ItemTO class is a transfer object defining the data representation of
	 * an item in a media RSS feed.<p/>
	 * This class is used by the AkamaiMediaRSS class and is not invoked directly by
	 * end users.<p/>
	 * The properties in this class are defined by the Media RSS specification which can
	 * be viewed at <a href="http://search.yahoo.com/mrss" target="_blank">http://search.yahoo.com/mrss</a>.
	 *
	 */
	dynamic public class ItemTO extends EventDispatcher {

		public var title:String;
		public var author:String;
		public var description:String;
		public var pubDate:String;
		public var enclosure:EnclosureTO;
		public var media:Media;
		public var link:String;

		//kaltura patches, under namespace: xmlns:kaltura="http://kaltura.com/playlist/1.0":
/* 		public var adminTags:String;
		public var credit:String;
		public var createdAt:String;
		public var entryId:String;
		public var plays:String;
		public var rank:String;
		public var sourceLink:String;
		public var tags:String;
		public var uploaderLink:String;
		public var uploaderName:String;
		public var uploaderUid:String
		public var views:String;
		public var votes:String; */
		//end of kaltura patches
	}
}