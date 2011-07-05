package com.kaltura.net.streaming.parsers
{
	public class StreamSourceVO
	{
		public var isRelative:Boolean;
		public var isRTMP:Boolean;
		public var protocol:String;
		public var serverName:String;
		public var portNumber:String;
		public var appName:String;
		public var streamName:String;
		public var wrappedURL:String;
		public var url:String;

		public function StreamSourceVO()
		{
		}

		/**
		 * parse a connection uri.
		 * @param a_url			the uri to parse and break.
		 * @return 				true if the connection uri is valid.
		 */
		public function parseURL(a_url:String):Boolean
		{
			// 					/$(protocol):\/(server):(port)/(appname|appdir/appname)/(stream_name)/i
			var pattern:RegExp = /^((?:http|https|rtmp|rtmp(?:t|s|e|te)):\/(?=\/)|\/)\/?([a-z_\-0-9.%]+)(?::([0-9]+))?\/(?!\?)([^\/]+(?:\/[^\/]+(?=\/))?)\/?(.*)/i;
			var match:Object = pattern.exec(a_url);

			if(match)
			{
				this.url 		= a_url;
				this.protocol	= match[1];
				this.serverName	= match[2];
				this.portNumber	= match[3];
				this.appName	= (match[4]=="")?null:match[4].toString().replace(/\.flv/,"");
				this.streamName	= (match[5]=="")?null:match[5].toString().replace(/\.flv/,"");
				this.isRTMP		= this.protocol.match(/^(?:rtmp|rtmp(?:t|s|e|te))/i)?true:false;
				this.isRelative = this.protocol == "/";
				return true;
			}

			trace ("VideoError: invalid source - " + a_url);
			return false;
		}
	}
}