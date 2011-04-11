package com.kaltura.kdpfl.model
{
	import com.kaltura.KalturaClient;
	import com.kaltura.config.KalturaConfig;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.puremvc.as3.patterns.proxy.Proxy;
	/**
	 *  Class ServicesProxy manages the parameters related to Kaltura services, i.e, creating a KalturaClient, KalturaConfig, etc.
	 * 
	 */	
	public class ServicesProxy extends Proxy
	{
		public static const NAME:String = "servicesProxy";
		
		//public static const CONFIG_SERVICE:String = "configService";
		public var kalturaClient : KalturaClient;
		
		private var _configService:URLLoader;
		/**
		 * Constructor 
		 * 
		 */			
		public function ServicesProxy()
		{
			super(NAME, null);
		}
		/**
		 * constructs a new KalturaClient based on a KalturaConfig object.
		 * @param config object of type KalturaConfig used to construct the KalturaClient
		 * 
		 */		
		public function createClient( config : KalturaConfig ) : void
		{
			kalturaClient = new KalturaClient( config );
		}
			
		public function getConfigService():URLLoader
		{
			if(!_configService)
			{
				var path:String = "config.xml";
				_configService = new URLLoader(new URLRequest(path));
			}
			
			return _configService;
		}
		
	}
}