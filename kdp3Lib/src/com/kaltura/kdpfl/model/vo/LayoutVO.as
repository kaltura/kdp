package com.kaltura.kdpfl.model.vo
{
	import com.kaltura.kdpfl.view.containers.KCanvas;
	
	import mx.utils.ObjectProxy;
	
	/**
	 * Class LayoutVO holds parameters related to the visual layout of the KDP. 
	 * @author Hila
	 * 
	 */	
	public class LayoutVO extends ObjectProxy
	{
		/**
		 * Holds the layout XML 
		 */		
		public var layoutXML:XML;
		/**
		 * Holds an object that has all screens UIcomponents.Their key is the screenId  
		 */		
		public var screens:Object;
		/**
		 * This is a foreground layer that components and plugins could use to place a 
		 * displayObject on a layer over the main layout
		 */		
		public var foreground:KCanvas 
	}
}