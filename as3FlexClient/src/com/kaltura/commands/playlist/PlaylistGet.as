package com.kaltura.commands.playlist
{
	import com.kaltura.delegates.playlist.PlaylistGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param version int
		 **/
		public function PlaylistGet( id : String,version : int=-1 )
		{
			service= 'playlist';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistGetDelegate( this , config );
		}
	}
}
