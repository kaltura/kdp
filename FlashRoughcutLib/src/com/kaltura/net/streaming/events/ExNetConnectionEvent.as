package com.kaltura.net.streaming.events
{
	import com.kaltura.net.streaming.parsers.StreamSourceVO;

	import flash.events.Event;

	public class ExNetConnectionEvent extends Event
	{
		static public const NETCONNECTION_CONNECT_CLOSED:String = "netconnectionConnectClosed";
		static public const NETCONNECTION_CONNECT_FAILED:String = "netconnectionConnectFailed";
		static public const NETCONNECTION_CONNECT_SUCCESS:String = "netconnectionConnectSuccess";
		static public const NETCONNECTION_CONNECT_REJECTED:String = "netconnectionConnectRejected";
		static public const NETCONNECTION_CONNECT_APPSHUTDOWN:String = "netconnectionConnectAppshutdown";
		static public const NETCONNECTION_CONNECT_INVALIDAPP:String = "netconnectionConnectInvalidapp";

		public var connectionSource:StreamSourceVO;
		public var connectionInfo:Object;

		public function ExNetConnectionEvent (type:String, connection_source:StreamSourceVO, connection_info:Object)
		{
			super (type, false, false);
			connectionSource = connection_source;
			connectionInfo = connection_info;
		}

		override public function clone():Event
		{
			return new ExNetConnectionEvent (type, connectionSource, connectionInfo);
		}
	}
}