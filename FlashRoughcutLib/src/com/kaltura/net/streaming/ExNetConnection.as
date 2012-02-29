package com.kaltura.net.streaming
{
	import com.kaltura.net.streaming.events.ExNetConnectionEvent;
	import com.kaltura.net.streaming.parsers.StreamSourceVO;
	import com.kaltura.net.streaming.status.NetStatus;

	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.*;

	/**
	 *  dispatched to notify the connection was closed.
	 *  @eventType com.kaltura.net.streaming.events.ExNetConnectionEvent.NETCONNECTION_CONNECT_CLOSED
	 */
	[Event(name="netconnectionConnectClosed", type="com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	/**
	 *  dispatched to notify the connection was failed.
	 *  @eventType com.kaltura.net.streaming.events.ExNetConnectionEvent.NETCONNECTION_CONNECT_FAILED
	 */
	[Event(name="netconnectionConnectFailed", type="com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	/**
	 *  dispatched to notify the connection was opened succefully.
	 *  @eventType com.kaltura.net.streaming.events.ExNetConnectionEvent.NETCONNECTION_CONNECT_SUCCESS
	 */
	[Event(name="netconnectionConnectSuccess", type="com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	/**
	 *  dispatched to notify the connection was rejected by the server.
	 *  @eventType com.kaltura.net.streaming.events.ExNetConnectionEvent.NETCONNECTION_CONNECT_REJECTED
	 */
	[Event(name="netconnectionConnectRejected", type="com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	/**
	 *  dispatched to notify the application was closed on the server.
	 *  @eventType com.kaltura.net.streaming.events.ExNetConnectionEvent.NETCONNECTION_CONNECT_APPSHUTDOWN
	 */
	[Event(name="netconnectionConnectAppshutdown", type="com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	/**
	 *  dispatched to notify the connection was made to an invalid app, connection was refused to the given application.
	 *  @eventType com.kaltura.net.streaming.events.ExNetConnectionEvent.NETCONNECTION_CONNECT_INVALIDAPP
	 */
	[Event(name="netconnectionConnectInvalidapp", type="com.kaltura.net.streaming.events.ExNetConnectionEvent")]

	public class ExNetConnection extends NetConnection
	{
		public static const PROGRESSIVE_NETCONNECTION:String = "progressiveNetconnection";

		/**
		 * holds the connection information (such app name, server, protocol, etc).
		 * @see  com.kaltura.net.streaming.parsers.StreamSourceVO
		 */
		private var connectionSource:StreamSourceVO;

		private var _connectionInfo:*;
		/**
		 * information object passed with the connection, usually used for authentication or cdn xml parsing.
		 */
		public function get connectionInfo ():* {
			return _connectionInfo;
		}
		public function set connectionInfo (info:*):void {
			_connectionInfo = info;
		}

		/**
		 * Constrcutor
		 * @param connection_uri		the uri of the connection, pass <code>ExNetConnection.PROGRESSIVE_NETCONNECTION</code> to create a null connection for progressive, use "" to instantiate but not connect.
		 * @param info					extra information for the connection.
		 * @param rest					rest variables to pass on the connection.
		 */
		public function ExNetConnection(connection_uri:String = "", info:* = "", encoding:int = -1, ...rest):void
		{
			super ();
			encoding = encoding == -1 ? ObjectEncoding.AMF0 : encoding;
			NetConnection.defaultObjectEncoding = encoding;
			SharedObject.defaultObjectEncoding = encoding;
			_connectionInfo = info;
			connect (connection_uri);
			client = new NetClient(connection_uri);
			addEventListener (NetStatusEvent.NET_STATUS, netStatus);
			addEventListener (SecurityErrorEvent.SECURITY_ERROR, errorEventHandler);
			addEventListener (AsyncErrorEvent.ASYNC_ERROR, errorEventHandler);
			addEventListener (IOErrorEvent.IO_ERROR, errorEventHandler);
        }

        /**
         * if no url given, create a null connection for progressive play, if the url given is
         * not an RTMP type connection, create a null for progresssive play,
         * if connection uri is invalid, skeep the connection and trace the error.
         * @inheritDoc
         */
        override public function connect(command:String, ...parameters):void
        {
        	if (command == ExNetConnection.PROGRESSIVE_NETCONNECTION)
			{
				super.connect(null);
			} else {
				if (command != "")
				{
					connectionSource = new StreamSourceVO ();
					if (connectionSource.parseURL (command))
					{
						if (connectionSource.isRTMP)
							super.connect(connectionSource.url, parameters);
						else
							super.connect(null);
					} else {
						trace ("connection uri is not valid: " + command);
					}
				}
			}
        }

		/**
		 * monitors the status event.
		 * @see com.kaltura.net.streaming.status.NetStatus
		 */
		private function netStatus(event:NetStatusEvent):void
		{
			var netEvent:ExNetConnectionEvent;
			switch (event.info.code)
			{
	            case NetStatus.NETCONNECTION_CONNECT_SUCCESS:
	            	netEvent = new ExNetConnectionEvent (ExNetConnectionEvent.NETCONNECTION_CONNECT_SUCCESS, connectionSource, event.info);
	                break;
	            case NetStatus.NETCONNECTION_CONNECT_CLOSED:
	            	netEvent = new ExNetConnectionEvent (ExNetConnectionEvent.NETCONNECTION_CONNECT_CLOSED, connectionSource, event.info);
	                break;
	            case NetStatus.NETCONNECTION_CONNECT_FAILED:
	            	netEvent = new ExNetConnectionEvent (ExNetConnectionEvent.NETCONNECTION_CONNECT_FAILED, connectionSource, event.info);
	                break;
	            case NetStatus.NETCONNECTION_CONNECT_REJECTED:
	            	netEvent = new ExNetConnectionEvent (ExNetConnectionEvent.NETCONNECTION_CONNECT_REJECTED, connectionSource, event.info);
	                break;
	            case NetStatus.NETCONNECTION_CONNECT_APPSHUTDOWN:
	            	netEvent = new ExNetConnectionEvent (ExNetConnectionEvent.NETCONNECTION_CONNECT_APPSHUTDOWN, connectionSource, event.info);
	                break;
	            case NetStatus.NETCONNECTION_CONNECT_INVALIDAPP:
	            	netEvent = new ExNetConnectionEvent (ExNetConnectionEvent.NETCONNECTION_CONNECT_INVALIDAPP, connectionSource, event.info);
	                break;
	            case NetStatus.NETCONNECTION_CALL_BADVERSION:
	                break;
	            case NetStatus.NETCONNECTION_CALL_FAILED:
	                break;
	            case NetStatus.NETCONNECTION_CALL_PROHIBITED:
	                break;
			}
			if (netEvent)
				dispatchEvent (netEvent);
		}

		/**
		 * monitors the error event.
		 */
		private function errorEventHandler (event:ErrorEvent):void
		{
			trace ("error connecting: " + event.text);
		}
	}
}