package com.addthis.share {
    		
    import flash.display.Sprite;
    import flash.external.ExternalInterface;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    
    /**
     * ShareAPI
     *
     * This class provides a simple wrapper over the AddThis Sharing Endpoints, to make them easier 
     * to use from within ActionScript 3.  
     *
     * See http://www.addthis.com/help/sharing-api for additional information on the endpoints that
     * this class wraps.
     */ 
    public class ShareAPI extends Sprite {
        
        static public const ENDPOINT:String = "http://api.addthis.com/oexchange/0.8/";
        static private const DEFAULT_OPTIONS:Object = {
            'title'       : '', 
            'width'       : -1,
            'height'      : -1,
            'swfurl'      : '',
			'description' : '',
            'screenshot'  : ''
        };
        
        private var profileID:String;
        
        /**
         * Instantiate the wrapper for use.
         *  
         * Profile ID: your AddThis Profile ID (to enable proper analytics)
         */
        public function ShareAPI(profileID:String = '') {
            super();
            this.profileID = profileID;
        }
        
        /**
         * Initiate the share process by sending the user's browser to the endpoint.  At minimum, you ALWAYS share a URL.
         * Extra optional parameters allow you to specify additional content, like flash objects, that will be shared to
         * destinations that support it.
         *
         * See http://www.addthis.com/help/sharing-api for additional information
         *
         * url: the URL to share (this URL will be scraped for metadata as appropriate; see http://www.addthis.com/help/embedded-content#tagging)
         * service: the service code of the destination service to share to, or "menu" to display all choices; see http://www.addthis.com/services/list for possible names
         * options: an object containing various additional options, as follows:
         *     standard options:
         *         title: content title; optional
         *         desc: content description; optional
         *     rich-content options (to specify additional content to share; optional, but if specified, all of the following must be sent to the endpoints):
         *         swfurl: URL of the SWF content to be shared; no default and therefore required
         *         width: SWF width; defaults to stage size
         *         height: SWF height; defaults to stage size
         *         screenshot: preview image used on certain destinations (igoogle, etc); no default and therefore required
         */
        public function share(url:String, service:String='menu', options:Object=null):void {
            var shareUrl:String = getShareUrl(url, service, options);
			
            ExternalInterface.call("window.open", shareUrl, "_blank");
        }
        
        /**
         * Gets a URL that can be used for initiating a share process, but doesn't actually open the browser.
         * See the share method for parameter documentation.
         */ 
        public function getShareUrl(url:String, service:String='menu', options:Object=null):String {
        	options ||= {};
        	var params:URLVariables = new URLVariables();
        	var shareUrl:String = ENDPOINT;
        	
        	for (var k:String in DEFAULT_OPTIONS) {
            	if (DEFAULT_OPTIONS[k] || options[k])
                	params[k] = options[k] || DEFAULT_OPTIONS[k];
            }
        	params.url = url;
        	if (stage) {
            	if (params.width <= 0)
                	params.width = stage.stageWidth;
            	if (params.height <= 0)
                	params.height = stage.stageHeight;
        	}
        	if (profileID)
            	params.pubid = profileID;

            shareUrl += (service != 'menu') ? 'forward' + '/' + service + '/offer?' + params.toString() : 'offer?' + params.toString();     	
            return shareUrl;
        }
     }
}