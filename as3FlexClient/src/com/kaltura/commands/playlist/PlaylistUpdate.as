package com.kaltura.commands.playlist
{
	import com.kaltura.vo.KalturaPlaylist;
	import com.kaltura.delegates.playlist.PlaylistUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param playlist KalturaPlaylist
		 * @param updateStats Boolean
		 **/
		public function PlaylistUpdate( id : String,playlist : KalturaPlaylist,updateStats : Boolean=false )
		{
			service= 'playlist';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(playlist, 'playlist');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('updateStats');
			valueArr.push(updateStats);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistUpdateDelegate( this , config );
		}
	}
}
