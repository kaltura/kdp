package com.kaltura.commands.playlist
{
	import com.kaltura.delegates.playlist.PlaylistExecuteDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistExecute extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param detailed String
		 **/
		public function PlaylistExecute( id : String,detailed : String='' )
		{
			service= 'playlist';
			action= 'execute';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('detailed');
			valueArr.push(detailed);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistExecuteDelegate( this , config );
		}
	}
}
