package com.kaltura.net.streaming.status
{
	import com.kaltura.utils.KStringUtil;

	final public class NetStatus
	{
		static public const NETSTREAM_BUFFER_EMPTY 					: String = "NetStream.Buffer.Empty";
		static public const NETSTREAM_BUFFER_FULL 					: String = "NetStream.Buffer.Full";
		static public const NETSTREAM_BUFFER_FLUSH 					: String = "NetStream.Buffer.Flush";
		static public const NETSTREAM_FAILED 						: String = "NetStream.Failed";
		static public const NETSTREAM_PUBLISH_START 				: String = "NetStream.Publish.Start";
		static public const NETSTREAM_PUBLISH_BADNAME 				: String = "NetStream.Publish.BadName";
		static public const NETSTREAM_PUBLISH_IDLE 					: String = "NetStream.Publish.Idle";
		static public const NETSTREAM_UNPUBLISH_SUCCESS 			: String = "NetStream.Unpublish.Success";
		static public const NETSTREAM_PLAY_START 					: String = "NetStream.Play.Start";
		static public const NETSTREAM_PLAY_STOP 					: String = "NetStream.Play.Stop";
		static public const NETSTREAM_PLAY_FAILED 					: String = "NetStream.Play.Failed";
		static public const NETSTREAM_PLAY_STREAMNOTFOUND 			: String = "NetStream.Play.StreamNotFound";
		static public const NETSTREAM_PLAY_RESET 					: String = "NetStream.Play.Reset";
		static public const NETSTREAM_PLAY_PUBLISHNOTIFY 			: String = "NetStream.Play.PublishNotify";
		static public const NETSTREAM_PLAY_UNPUBLISHNOTIFY		 	: String = "NetStream.Play.UnpublishNotify";
		static public const NETSTREAM_PLAY_INSUFFICIENTBW 			: String = "NetStream.Play.InsufficientBW";
		static public const NETSTREAM_PLAY_FILESTRUCTUREINVALID 	: String = "NetStream.Play.FileStructureInvalid";
		static public const NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND 	: String = "NetStream.Play.NoSupportedTrackFound";
		static public const NETSTREAM_PAUSE_NOTIFY 					: String = "NetStream.Pause.Notify";
		static public const NETSTREAM_UNPAUSE_NOTIFY 				: String = "NetStream.Unpause.Notify";
		static public const NETSTREAM_RECORD_START 					: String = "NetStream.Record.Start";
		static public const NETSTREAM_RECORD_NOACCESS				: String = "NetStream.Record.NoAccess";
		static public const NETSTREAM_RECORD_STOP 					: String = "NetStream.Record.Stop";
		static public const NETSTREAM_RECORD_FAILED 				: String = "NetStream.Record.Failed";
		static public const NETSTREAM_SEEK_FAILED 					: String = "NetStream.Seek.Failed";
		static public const NETSTREAM_SEEK_INVALIDTIME 				: String = "NetStream.Seek.InvalidTime";
		static public const NETSTREAM_SEEK_NOTIFY 					: String = "NetStream.Seek.Notify";
		static public const NETSTREAM_PLAY_COMPLETE 				: String = "NetStream.Play.Complete"

		static public const NETCONNECTION_CALL_BADVERSION 			: String = "NetConnection.Call.BadVersion";
		static public const NETCONNECTION_CALL_FAILED 				: String = "NetConnection.Call.Failed";
		static public const NETCONNECTION_CALL_PROHIBITED 			: String = "NetConnection.Call.Prohibited";
		static public const NETCONNECTION_CONNECT_CLOSED 			: String = "NetConnection.Connect.Closed";
		static public const NETCONNECTION_CONNECT_FAILED 			: String = "NetConnection.Connect.Failed";
		static public const NETCONNECTION_CONNECT_SUCCESS 			: String = "NetConnection.Connect.Success";
		static public const NETCONNECTION_CONNECT_REJECTED 			: String = "NetConnection.Connect.Rejected";
		static public const NETCONNECTION_CONNECT_APPSHUTDOWN 		: String = "NetConnection.Connect.AppShutdown";
		static public const NETCONNECTION_CONNECT_INVALIDAPP 		: String = "NetConnection.Connect.InvalidApp";

		static public const SHAREDOBJECT_FLUSH_SUCCESS 				: String = "SharedObject.Flush.Success";
		static public const SHAREDOBJECT_FLUSH_FAILED 				: String = "SharedObject.Flush.Failed";
		static public const SHAREDOBJECT_BADPERSISTENCE 			: String = "SharedObject.BadPersistence";
		static public const SHAREDOBJECT_URIMISMATCH 				: String = "SharedObject.UriMismatch";

		static public function convertServerToCamel (server_code:String):String
		{
			server_code = server_code.replace(/\./g, "_");
			return KStringUtil.camelize(server_code);
		}
	}
}