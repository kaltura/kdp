package com.kaltura.commands.playlist
{
	import com.kaltura.vo.KalturaPlaylist;
	import com.kaltura.delegates.playlist.PlaylistCloneDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistClone extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param newPlaylist KalturaPlaylist
		 **/
		public function PlaylistClone( id : String,newPlaylist : KalturaPlaylist=null )
		{
			if(newPlaylist== null)newPlaylist= new KalturaPlaylist();
			service= 'playlist';
			action= 'clone';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(newPlaylist, 'newPlaylist');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistCloneDelegate( this , config );
		}
	}
}
