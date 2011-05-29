package com.kaltura.commands.playlist
{
	import com.kaltura.vo.KalturaPlaylist;
	import com.kaltura.delegates.playlist.PlaylistAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param playlist KalturaPlaylist
		 * @param updateStats Boolean
		 **/
		public function PlaylistAdd( playlist : KalturaPlaylist,updateStats : Boolean=false )
		{
			service= 'playlist';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
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
			delegate = new PlaylistAddDelegate( this , config );
		}
	}
}
