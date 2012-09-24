package com.kaltura.kdpfl.model.type
{
	/**
	 * This class represents debug levels
	 * debug level affects the traces that will be exposed when debugMode=true 
	 * @author michalr
	 * 
	 */	
	public class DebugLevel
	{
		/**
		 * traces will include all notifications, besides "playerUpdatePlayhead" and "bytesDownloadedChange"  
		 */		
		public static const LOW:int = 0;
		/**
		 * traces will include all notification besides "bytesDownlodedChange" 
		 */		
		public static const MEDIUM:int = 1;
		/**
		 * traces will include all notifications 
		 */		
		public static const HIGH:int = 2;
	}
}