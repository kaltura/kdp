package com.kaltura.kdpfl.model.type
{
	/**
	 * Class StreamerType holds the constants representing the different media stream types supported by the KDP 
	 * 
	 */	
	public class StreamerType
	{
		/**
		 * StreamerType HTTP represents media that is played in progressive download mode.
		 */		
		public static const HTTP : String = "http";
		/**
		 * StreamerType RTMP represents media that is played in adaptive bitrate mode.
		 */		
		public static const RTMP : String = "rtmp";
		/**
		 * StreamerType LIVE represents media that is being streamed live.
		 */		
		public static const LIVE : String = "live";
	}
}