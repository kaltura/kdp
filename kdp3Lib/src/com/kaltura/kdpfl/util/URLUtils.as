package com.kaltura.kdpfl.util
{
	public class URLUtils
	{
		/**
     	 *  Determines if the URL uses the HTTP, HTTPS, or RTMP protocol. 
	     *
     	 *  @param url The URL to analyze.
     	 * 
	     *  @return <code>true</code> if the URL starts with "http://", "https://", or "rtmp://".
     	 */
	    public static function isHttpURL(url:String):Boolean
	    {
        	return url != null &&
               	(url.indexOf("http://") == 0 ||
	                url.indexOf("https://") == 0);
	    }
	    
		/**
		 *  Returns the protocol section of the specified URL.
		 *  The following examples show what is returned based on different URLs:
		 *  
		 *  <pre>
		 *  getProtocol("https://localhost:2700/") returns "https"
		 *  getProtocol("rtmp://www.myCompany.com/myMainDirectory/groupChatApp/HelpDesk") returns "rtmp"
		 *  getProtocol("rtmpt:/sharedWhiteboardApp/June2002") returns "rtmpt"
		 *  getProtocol("rtmp::1234/chatApp/room_name") returns "rtmp"
		 *  </pre>
		 *
		 *  @param url String containing the URL to parse.
		 *
		 *  @return The protocol or an empty String if no protocol is specified.
		 */
		public static function getProtocol(url:String):String
		{
			var slash:int = url.indexOf("/");
			var indx:int = url.indexOf(":/");
			if (indx > -1 && indx < slash)
			{
				return url.substring(0, indx);
			}
			else
			{
				indx = url.indexOf("::");
				if (indx > -1 && indx < slash)
			return url.substring(0, indx);
			}
		
			return "";
		}
		
		/**
		 * Removes the "[[IMPORT]]" from a URL string.
		 * For example the URL http://sandbox.kaltura.com/[[IMPORT]]/cdnsandbox.kaltura.com/Sample.swf will be cut to http://cdnsandbox.kaltura.com/Sample.swf
		 * If the given url does not contain the [[IMPORT]] string, the url is returned without any changes.
		 * The [[IMPORT]] string is known to be concatenated when a swf is loaded from a different into an existing security sandbox.
		 * @param url A URL, that potentially contains the '[[IMPORT]]' String.
		 * @return A concatenation of the url parameter protocol + the string found after the [[IMPORT]] string
		 *
		 */
		public static function removeSandboxNoise(url:String):String
		{
			// when the application is loaded into a warapper that set the SecuritySandbox to SecuritySandbox.currentDomain, the root.loaderInfo.url is somehow set to
			//
			var importIndex:int = url.indexOf("[[IMPORT]]/");
			if (importIndex != -1)
				var startIdx:int = importIndex + 11;
			else
				return url;

			var strippedUrl:String = url.substring(startIdx);
			var protocol:String = getProtocol(url)
			strippedUrl = protocol + "://" + strippedUrl;
			return strippedUrl
		}
	}

}