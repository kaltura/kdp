package com.kaltura.commands.playlist
{
	import com.kaltura.delegates.playlist.PlaylistDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function PlaylistDelete( id : String )
		{
			service= 'playlist';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistDeleteDelegate( this , config );
		}
	}
}
