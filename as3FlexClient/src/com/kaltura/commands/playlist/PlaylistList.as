package com.kaltura.commands.playlist
{
	import com.kaltura.vo.KalturaPlaylistFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.playlist.PlaylistListDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaPlaylistFilter
		 * @param pager KalturaFilterPager
		 **/
		public function PlaylistList( filter : KalturaPlaylistFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaPlaylistFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'playlist';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistListDelegate( this , config );
		}
	}
}
