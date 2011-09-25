package com.kaltura.kdpfl.plugin.component
{
	import fl.core.UIComponent;
	
	public class FreeWheelComponent extends UIComponent implements IFwPlayerModule, IFwContext
	{
		/**
		 * The freeWheel osmf plugin url path 
		 */		
		public var fwPluginLocation : String;
				
		/**
		 * AdManager location url 
		 * Required: false 
		 */		
		public var admanagerUrl : String;

		/**
		 * Ad Server url
		 * Required: false 
		 */		
		public var adServerUrl : String;
		
		/**
		 * NetworkId provided by Freewheel system 
		 * Required: true
		 */		
		public var networkId : uint;

		/**
		 * site section id provided by Freewheel system 
		 * Required: false
		 */	
		public var siteSectionCustomId : uint
		
		/**
		 * Site section network id provided by Freewheel system 
		 * Required: false
		 */		
		public var siteSectionNetworkId : uint

		/**
		 * Video asset network id provided by Freewheel system
		 * Required: false
		 */
		public var videoAssetNetworkId : uint;

		/**
		 * Player profiler
		 * Required: true
		 */		
		public var playerProfile : String;

		/**
		 * Cache buster for loading AdManager 
		 */		
		public var cacheBuster : Number;
		
		/**
		 * Reference to the freeWheel plugin 
		 */		
		public var fwPlugin : Object
	}
}