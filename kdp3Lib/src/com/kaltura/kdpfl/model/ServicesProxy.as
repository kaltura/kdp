package com.kaltura.kdpfl.model
{
	import com.kaltura.KalturaClient;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.kdpfl.model.vo.ServicesVO;
	
	import flash.net.URLLoader;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 *  Class ServicesProxy manages the parameters related to Kaltura services, i.e, creating a KalturaClient, KalturaConfig, etc.
	 * 
	 */	
	public class ServicesProxy extends Proxy
	{
		public static const NAME:String = "servicesProxy";
		
		
		//DEPRECATED
		public var kalturaClient : KalturaClient;
		
		//public static const CONFIG_SERVICE:String = "configService";
		private var _configService:URLLoader;
		/**
		 * Constructor 
		 * 
		 */			
		public function ServicesProxy()
		{
			super(NAME, new ServicesVO());
		}
		/**
		 * constructs a new KalturaClient based on a KalturaConfig object.
		 * @param config object of type KalturaConfig used to construct the KalturaClient
		 * 
		 */		
		public function createClient( config : KalturaConfig ) : void
		{
			this.vo.kalturaClient = new KalturaClient( config );
			kalturaClient = this.vo.kalturaClient;
			
		}
		
		public function get vo () : ServicesVO
		{
			return this.data as ServicesVO;
		}
			
		
		
		
		
		
		
	}
}