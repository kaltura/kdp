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
		/**
		 * StreamerType HDNETWORK represents media that is being http-streamed from akamai.
		 */		
		public static const HDNETWORK : String = "hdnetwork";
		/**
		 * StreamerType HDNETWORK_HDS represents media that is being http-dynamic-streamed from akamai.
		 */		
		public static const HDNETWORK_HDS : String = "hdnetworkmanifest";
		/**
		 * StreamerType HDS represents media that is being http-dynamic-streamed.
		 */		
		public static const HDS : String = "hds";
	}
}