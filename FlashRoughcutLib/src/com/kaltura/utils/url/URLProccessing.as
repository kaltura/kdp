/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.utils.url
{
	//xxx import mx.core.Application;
	import mx.utils.URLUtil;

	public class URLProccessing
	{
		///////
		////	DYNAMIC BINDING PARAMETERS CONSTANT
		///////
		/**
		 *binding constant to use with "completeUrl" method.
		 * @see #completeUrl
		 */
		static public const BINDING_DOMAIN_NAME:String = "{DOMAIN_NAM}";
		/**
		 *binding constant to use with "completeUrl" method.
		 * @see #completeUrl
		 */
		static public const BINDING_SERVER_URL:String = "{SERVER_URL}";
		/**
		 *binding constant to use with "completeUrl" method.
		 * @see #completeUrl
		 */
		static public const BINDING_CDN_SERVER_URL:String = "{CDN_SERVER_URL}";

		///////
		////	PRIVATES
		///////
		/**
		 * streamer service url (this service is used by the player usually),
		 * to get a concatenated stream for progressive-dual type streaming.
		 */
		static private var loadConcatenatedStreamURL:String = "flv/";
		/**
		 * this part is used to track the partner and sub_p when using cdn, will come as the first part of the request after
		 * the baseUrl of the cdn.
		 */
		static private var partnerInfoForTracking:String = "/p/#p#/sp/#sp#/";
		/**
		 * the current host of the swf file.
		 */
		static private var _currentDomainURL:String = '$urlUnDefined$';

		///////
		////	PUBLICS
		///////
		/**
		 * used to globaly disable url hashing for multiple domains.
		 */
		static public var disable_hashURLforMultipalDomains:Boolean = true;
		/**
		 * the path for the partnerservices2 services.
		 */
		static public var partnerServicesUrl:String = "/index.php/partnerservices2";
		/**
		 * the path for the keditorServices (such as flvStreamer).
		 */
		static public var keditorServicesUrl:String = "index.php/keditorservices";
		/**
		 * the path for the clipper service.
		 */
		static public var urlClipVideo:String = "flvclipper/entry_id/";
		/**
		 * the kaltura server domain, without protocol and optional subdomain (kaldev is mandatory, www is optional) as defined by the config.
		 */
		static public var serverDomain:String = '$urlUnDefined$';
		/**
		 * the url of the server as defined by the config.
		 */
		static public var serverURL:String = '$urlUnDefined$';
		/**
		 * the url of the cdn to use.
		 */
		static public var cdnURL:String = '$urlUnDefined$';

		/**
		 * @return the current url of the swf.
		 */
		static public function get currentDomainURL ():String
		{
			if (_currentDomainURL == '$urlUnDefined$')
					createDomainURL ();
			return _currentDomainURL;
		}

		///////
		////	PUBLIC METHODS
		///////
		/**
		 *builds an rtmp url from the server Url.
		 * @return 		the rtmp on the serverUrl.
		 */
		static public function getMediaServerUrl (custom_protocol:String = "rtmp://", custom_application:String = "oflaDemo"):String
		{
			var protocolExist:int = serverURL.indexOf("://");
			var domainUrl:String = (protocolExist > -1) ? serverURL.substring(protocolExist + 3) : serverURL;
			if (domainUrl.indexOf('/') > -1)
				domainUrl = domainUrl.substring(0, domainUrl.indexOf('/'));
			var fmsUrl:String = custom_protocol + domainUrl + "/" + custom_application;
			return fmsUrl;
		}

		/**
		 *get the file name from a url of local filesystem path.
		 * @param url		the url to strip the file from.
		 * @return 			the file name.
		 */
		static public function getFileNameLocalPath(url:String):String
		{
			var aFilteredSlash:Array = url.split("/");
			var lastCell:String = aFilteredSlash[aFilteredSlash.length - 1];
			var aFilteredBackSlash:Array = lastCell.split("\\");
			return aFilteredBackSlash[aFilteredBackSlash.length - 1]
		}

		/**
		 * append a url to the server url from the config or the current domain url and append the partner services path.
		 * @param url				the url.
		 * @param from_config		true to append the host url from the config/falshVars, false for Application[url] url.
		 * @param isService			true to append the partner services path.
		 * @param noCdn				override the cdn feature for non-service urls (if this is false, default, non-service urls will be passed through cdn).
		 * @return 					the new url.
		 */
		static public function prepareURL (url:String, from_config:Boolean = true, is_service:Boolean = true, customSubDomain:String = "", noCdn:Boolean = false):String
		{
			if (url.indexOf("http://") == 0) 
					return url;
			
			if (!from_config)
				if (_currentDomainURL == '$urlUnDefined$')
					createDomainURL ();
			var retURL:String = '$urlUnDefined$';
			if (url.substr(0,1) != '/')
				retURL = (from_config ? (is_service || noCdn ? serverURL : cdnURL) : _currentDomainURL) + (is_service ? partnerServicesUrl : "" ) + '/' + url;
			else
				retURL = (from_config ? (is_service || noCdn ? serverURL : cdnURL) : _currentDomainURL) + (is_service ? partnerServicesUrl : "" ) + url;
			if (customSubDomain != "")
				retURL = URLProccessing.addSubDomain (retURL, customSubDomain);
			return retURL;
		}

		/**
		 *replaces a subdomain inside a given url.
		 * @param url					the url to manipulate.
		 * @param customSubdomain		the new subdomain.
		 * @param replace				true to replace the subdomain, false to add customSubdomain.orginialsubdomain.
		 * @return 						the given url with a new subdomain.
		 *
		 */
		static public function addSubDomain (url:String, custom_subdomain:String, replace:Boolean = false):String
		{
			var newUrl:String;
			var firstPart:String;
			var protocolExist:int = url.indexOf("://");
			var protocol:String = protocolExist > -1 ? url.substring (0, protocolExist) : '';
			var domainUrl:String = (protocol != '') ? url.substring(protocolExist + 3) : url;
			var rest:String = domainUrl.substring(domainUrl.indexOf('/'));
			domainUrl = domainUrl.substring(0, domainUrl.indexOf('/'));
			var subdomains:Array = domainUrl.split ('.');
			var oldSubdomain:String = subdomains[0];
			var i:int;
			var restdomain:String = '';
			for (i = 1; i < subdomains.length; ++i) restdomain = restdomain + '.' + subdomains[i];
			if (replace)
				newUrl = protocol + '://'+ custom_subdomain + restdomain + rest;
			else
				newUrl = protocol + '://' + custom_subdomain + "." + oldSubdomain + restdomain + rest;
			return newUrl;
		}

		/**
		 *strip a given url for its domain name only.
		 * @param url	a valid url.
		 * @return 		the domain name from the given url (no protocol or subdomains).
		 */
		static public function getDomainFromUrl (url:String):String
		{
			var newUrl:String;
			var firstPart:String;
			var protocolExist:int = url.indexOf("://");
			var protocol:String = protocolExist > -1 ? url.substring (0, protocolExist) : '';
			var domainUrl:String = (protocol != '') ? url.substring(protocolExist + 3) : url;
			var rest:String = domainUrl.substring(domainUrl.indexOf('/'));
			domainUrl = domainUrl.substring(0, domainUrl.indexOf('/'));
			var subdomains:Array = domainUrl.split ('.');
			var i:int;
			var restdomain:String = '';
			for (i = 1; i < subdomains.length; ++i) restdomain = restdomain + '.' + subdomains[i];
			return restdomain;
		}

		/**
		 * parse the url to get the server domain from which the swf was loaded.
		 */
		static private function createDomainURL ():void
		{
			_currentDomainURL = "";//xxx Application.application.url;
			var splitURL:String = _currentDomainURL.substr (0, _currentDomainURL.lastIndexOf("/"));
			_currentDomainURL = splitURL;
		}

		/**
		 *load an asset from the server by it's entryId from the clipper service.
		 * @param entry_id				the entryId of the asset to load.
		 * @param start					if the asset is a stream (video/audio) use this to cut the stream to specific start millisecond.
		 * @param length				if the asset is a stream (video/audio) use this to cut the stream to specific length millisecond.
		 * @param partnerPart			the partner info, used for tracking when using cdn.
		 * @param ks					for secured connections a valid ks must be provided.
		 * @param entry_version			if specified will fetch the specifc version of the entry.
		 * @return 						the clipper service url to load the desired asset.
		 */
		static public function clipperServiceUrl (entry_id:String, start:int = -1, length:int = -1, flavor:String = '0', partnerPart:String = '', ks:String = '', entry_version:int = -1, add_domain:Boolean = true):String
		{
			var url:String = "";
			if (start > 0 || length >= 0)
				url = (add_domain ? serverURL : '') + (partnerPart != '' ? partnerPart : '/') + urlClipVideo + entry_id + "/clip_from/" + ((start * 1000)>>0).toString() + "/clip_to/" + (((start + length) * 1000)>>0).toString() + '/flavor/' + flavor;
			else
				url = (add_domain ? cdnURL : '') + (partnerPart != '' ? partnerPart : '/') + urlClipVideo + entry_id + '/flavor/' + flavor;
			if (ks != '')
				url = url + '/ks/' + ks;
			if (entry_version != -1)
				url = url + '/version/' + entry_version;
			return url;
		}

		/**
		 *adds streaming capabilities to a clipper service url.
		 * @param clipper_url			the originial clipper file.
		 * @param seek_from_bytes		the bytes to stream from.
		 * @return 						streaming clipper url.
		 *
		 */
		static public function clipperServiceAddProgressiveStream (clipper_url:String, seek_from:uint):String
		{
			var idx:int = clipper_url.indexOf('/seek_from');
			if (idx > -1)
				clipper_url = clipper_url.substr(0, idx);
			if (clipper_url.substr(clipper_url.length-1,1) == '/')
				clipper_url = clipper_url.substr(0, clipper_url.length-1);
			var new_clipper_url:String = clipper_url + '/seek_from/' + seek_from.toString();
			return new_clipper_url;
		}

		/**
		 * strips slashes from the end of a url.
		 * @param url		the url to strip slashes from.
		 * @return 			the url without slashes at end.
		 */
		static public function stripLastSlash (url:String):String
		{
			while (url.substr(url.length-1,1) == '/')
				url = url.substr(0, url.length-1);
			return url;
		}

		/**
		 * load concatenated stream for progressive-dual streaming method.
		 * @param entry_id				the roughcut's entry id.
		 * @param stream_type			the type of the stream to get (valid: -audio-, -video-).
		 * @param odd_even_part			determine whether to load the first or the second part of the stream.
		 * @param roughcut_version		the version of the roughcut to load.
		 * @param partnerPart			the partner info, used for tracking when using cdn.
		 * @return 						the url for the concatenated stream service.
		 */
		static public function streamerServiceUrl (entry_id:String, stream_type:String, odd_even_part:String, roughcut_version:String, partnerPart:String = ''):String
		{
			var streamUid:String = entry_id + stream_type + odd_even_part + "-" + roughcut_version;
			var customStreamerService:String = (partnerPart == '' ? '/' : partnerPart) + loadConcatenatedStreamURL;
			var streamerUrl:String = cdnURL +  customStreamerService + streamUid + '-padding';
			return streamerUrl;
		}

		/**
		 * load the thumbnail of a given entry.
		 * @param entry_id		the entryId whose thumbnail to load.
		 * @param thumb_width	the width of the thumbnail to create.
		 * @param thumb_height	the height of the thumbnail to create.
		 * @param partnerPart	if the request require tracking, use the getPartnerPartForTracking method to create a valid partnerPart for the request.
		 * @return 				a request url to get the desired thumbnail.
		 * @see com.kaltura.utils.url.URLProccessing#getPartnerPartForTracking
		 */
		static public function getThumbnail (entry_id:String, entry_version:String, thumb_width:int = 640, thumb_height:int = 480, partnerPart:String = ''):String
		{
			return cdnURL + partnerPart + "thumbnail/entry_id/" + entry_id + '/width/' + thumb_width + '/height/' + thumb_height + '/version/' + entry_version;
		}

		/**
		 *helper function to get the filename from a given url.
		 * @param url	the url to get the filename out of.
		 */
		static public function getFileName (url:String):String
		{
			if (url)
				return url.substring(url.lastIndexOf('/') + 1, url.length);
			else
				return url;
		}

		/**
		 * build the partner info part of the requests that require tracking (when using cdn).
		 * @param p_id		the partner id
		 * @param subp_id	the sub_partner id
		 */
		static public function getPartnerPartForTracking (p_id:String, subp_id:String):String
		{
			var partnerPart:String = partnerInfoForTracking;
			partnerPart = partnerPart.replace("#p#", p_id);
			partnerPart = partnerPart.replace("#sp#", subp_id);
			return partnerPart;
		}

		/**
		 * Optimize Parallel Downloads to Minimize Object Overhead.
		 * <p>With the average web page growing past 50 external objects, minimizing object overhead is critical to optimize web performance.
		 * You can minimize the number of objects by using CSS sprites, combining objects to minimize HTTP requests,
		 * and suturing CSS or JavaScript files at the server. With today's faster broadband connections, boosting parallel downloads
		 * can realize up to a 40% improvement in web page latency.
		 * You can use two or three hostnames to serve objects from the same server to fool browsers into multithreading more objects.</p>
		 * @param url			the url to hash it's subdomain.
		 * @param entry_id		the entryId of the asset the url points to.
		 * @param un_hash		true if the reverse action is needed (the url will be unhashed), used for debugging.
		 * @param trace_debug	if true, the function will trace debug info.
		 * @return 				the url with its subdomain hashed / unhasehed.
		 * @see http://www.websiteoptimization.com/speed/tweak/parallel/
		 */
		static public function hashURLforMultipalDomains (url:String, entry_id:String, un_hash:Boolean = false, trace_debug:Boolean = false):String
		{
			if (disable_hashURLforMultipalDomains)
				return url;
			var newUrl:String;
			var subDomain:String;
			var protocolExist:int = url.indexOf("://");
			var protocol:String = protocolExist > -1 ? url.substring (0, protocolExist) : '';
			var domainUrl:String = (protocol != '') ? url.substring(protocolExist + 3) : domainUrl;
			var rest:String = domainUrl.substring(domainUrl.indexOf('/'));
			domainUrl = domainUrl.substring(0, domainUrl.indexOf('/'));
			var subdomains:Array = domainUrl.split ('.');
			//if there is no subdomain (mydomain.com instead of my.domain.com) return with no hashing.
			if (subdomains.length < 3)
				return url;
			subDomain = subdomains[0];
			subDomain = protocol + '://' + subDomain;
			var lastChar:int = subDomain.charCodeAt(subDomain.length - 1);
			var i:int;
			if (trace_debug)
			{
				trace ('\nhashURLforMultipalDomains (ver 2)\n', 'url: ' + url + '\n' + 'protocol: ' + protocol + '\n' +
														'domain: ' + domainUrl + '\n' + 'http://subDomain: ' + subDomain +
														'\n' + 'lastChar: ' + lastChar);
			}
			var restdomain:String = '';
			var hashedCode:String = (entry_id.charCodeAt(entry_id.length - 1) % 7 + 1).toString();
			if (!un_hash)
			{
				if (lastChar < 48 || lastChar > 57)
				{
					for (i = 1; i < subdomains.length; ++i) restdomain = restdomain + '.' + subdomains[i];
					newUrl = subDomain + hashedCode + restdomain + rest;
					if (trace_debug) trace ("(newUrl) - get: " + newUrl);
					return newUrl;
				} else {
					if (trace_debug) trace ("(url) - get: " + url);
					return url;
				}
			} else {
				if (lastChar < 48 || lastChar > 57 || !isNaN(subdomains[0]))
				{
					// the url is either not hashed or the first part of the domain is a number
					// that means the domain might be an ip number - so no need to remove anything..
					if (trace_debug) trace ("(url) - get: " + url);
					return url;
				} else {
					//the last char is a number, so the url
					// is already hashed, so remove hashing:
					for (i = 1; i < subdomains.length; ++i) restdomain = restdomain + '.' + subdomains[i];
					newUrl = subDomain.substr(0, subDomain.length-1) + restdomain + rest;
					if (trace_debug) trace ("(newUrl) - get: " + newUrl);
					return newUrl;
				}
			}
		}


		/**
		 *convert host code to host url.
		 * <p>use this to prevent url injection (so the system can't be used for cross-site hits)</p>
		 * @param host_code		the host code.
		 * @param trace_debug	if true, the function will trace debug info.
		 * @param cdn_url		if set, will override default cdn host with this value.
		 * @return 				the url of the host.
		 */
		static public function createURLFromHostCode (host_code:String, trace_debug:Boolean = false, cdn_url:String = ""):String
		{
			var protocol:String = URLUtil.getProtocol(host_code);
 			var port:uint = URLUtil.getPort(host_code);
 			if (protocol == '') {
				protocol = "http";
			}else{
				host_code = URLUtil.getServerName(host_code);
			}
			var hostURL:String;
 			switch (host_code)
			{
 				case "0":
 				case "kaldev.kaltura.com":
					hostURL = "kaldev.kaltura.com";
					URLProccessing.serverDomain = "kaldev.kaltura.com";
					URLProccessing.serverURL = protocol + "://kaldev.kaltura.com";
					URLProccessing.cdnURL = protocol + "://cdnkaldev.kaltura.com";
				break;

				case null:
				case "undefined":
				case undefined:
				case "":                        
				case "1":
				case "www.kaltura.com":
				case "corp.kaltura.com":
				case "kaltura.com":
					hostURL = "www.kaltura.com";
    				URLProccessing.serverDomain = "kaltura.com";
					URLProccessing.serverURL = protocol + "://www.kaltura.com";
					URLProccessing.cdnURL = protocol + "://cdn.kaltura.com";
				break;

				case "2":
				case "localhost":
					hostURL = "localhost";
					URLProccessing.serverDomain = "localhost";
					URLProccessing.serverURL = protocol + "://localhost";
					URLProccessing.cdnURL = protocol + "://localhost";
				break;

				case "3":
				case "sandbox.kaltura.com":
					hostURL = "sandbox.kaltura.com";
					URLProccessing.serverDomain = "sandbox.kaltura.com";
					URLProccessing.serverURL = "http://sandbox.kaltura.com";
					URLProccessing.cdnURL = "http://cdnsandbox.kaltura.com";
				break;

				default:
					hostURL = host_code;
					URLProccessing.serverDomain = host_code;
					URLProccessing.serverURL = protocol + "://" +  host_code;
					URLProccessing.cdnURL = protocol + "://" + hostURL;
				break;
			}
			if (cdn_url != "")
				URLProccessing.cdnURL = URLUtil.getProtocol(cdn_url) == "" ? protocol + "://" + cdn_url : cdn_url;
			if (trace_debug) trace ("running on server: " + URLProccessing.serverURL + "(" + URLProccessing.serverDomain + " / " + host_code + "), cdn: " + URLProccessing.cdnURL);
			return hostURL;
		}

		/**
		 *completes a given url, replaces binding parameters in a given url.
		 * <p>parmeters available:</p>
		 * <code>{DOMAIN_NAME} - the domain (only, not protocol or optional subdomains) of the kaltura server the client is working with.</code>
		 * <code>{SERVER_URL} - the full url (no protocol) of the kaltura server the client is working with.</code>
		 * <code>{CDN_SERVER_URL} - the full url of the CDN the client is working with.</code>
		 * @param url					source string to replace binding codes in.
		 * @param binding_code			the code to replace, see description for available codes.
		 * @return						the source string with codes replaced by actual application values.
		 */
		static public function completeUrl (url:String, binding_code:String):String
		{
			var ret:String;
			switch (binding_code)
			{
				case "{DOMAIN_NAME}":
					ret = url.replace(binding_code, URLProccessing.serverDomain)
					break;
				case "{SERVER_URL}":
					ret = url.replace(binding_code, URLProccessing.serverURL)
					break;
				case "{CDN_SERVER_URL}":
					ret = url.replace(binding_code, URLProccessing.cdnURL)
					break;
			}
			return ret;
		}
	}
}