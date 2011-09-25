package com.kaltura.kdpfl.model
{
	import com.kaltura.kdpfl.model.vo.ConfigVO;
	
	import mx.utils.UIDUtil;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * ConfigProxy is the gateway to application parameters. You can access
	 * KDP flashvars from everywhere in the application via this proxy.
	 */	
	public class ConfigProxy extends Proxy
	{
		public static const NAME:String = "configProxy";
		
		public function ConfigProxy(data:Object=null)
		{
			super( NAME , new ConfigVO() );
			vo.flashvars = data;
			vo.sessionId = UIDUtil.createUID();
		}
		
		/**
		 * the value object associated with this proxy 
		 */		
		public function get vo():ConfigVO  
        {  
        	return data as ConfigVO;  
        } 
		
		

	}
}