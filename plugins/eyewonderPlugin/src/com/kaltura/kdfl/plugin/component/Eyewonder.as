package com.kaltura.kdfl.plugin.component
{
	import com.eyewonder.instream.players.AdManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Eyewonder extends MovieClip 
	{
		public static const AD_MANAGER_READY : String = "adManagerReady";
		
		public var adManager : AdManager;
		private var _config : Object;
		
		/**
		 * Constructor 
		 * @param config
		 * 
		 */		
		public function Eyewonder( config : Object ) : void
		{
			_config = config;
			addEventListener( Event.ADDED_TO_STAGE , addAdManager );
		}
		
		/**
		 * add the adManager to stage and dispatch that the manager ready to work with 
		 * @param event
		 * 
		 */		
		private function addAdManager( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE , addAdManager );
			if(!adManager)
			{
				adManager = new AdManager( _config , this );
				dispatchEvent( new Event (AD_MANAGER_READY) );
			}
		}
	}
}