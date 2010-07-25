package com.kaltura.kdpfl.plugin.component
{
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PlaylistListMediator extends Mediator
	{
		public static const NAME:String = "playlistListMediator";
		//
		public var isPlaylist:Boolean=false;
		public var isPlaying:Boolean=false;
		private var isChange:Boolean=false;
		
		public function PlaylistListMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return ["doPlaylistList","doClosePlaylist","doPlay","doPause"];
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case "doPlaylistList":
					isPlaylist = !isPlaylist;
					(viewComponent as PlaylistList).doPlaylist(isPlaylist);
					if(isPlaying)
					{
						if(isPlaylist)
						{
							isChange=true;
							sendNotification("doPause");
						}
						else
						{
							isChange=true;
							sendNotification("doPlay");
						}
					}
					break;
				case "doClosePlaylist":
					if(isPlaylist)
					{
						isPlaylist=false;
						(viewComponent as PlaylistList).doPlaylist(isPlaylist);
						if(isPlaying)
						{
							isChange=true;
							sendNotification("doPlay");
						}
					}
					break;
				case "doPlay":
					if(isChange)
					{
						isChange=false;
					}
					else
					{
						isPlaying = true;
					}
					break;
				case "doPause":
					if(isChange)
					{
						isChange=false;
					}
					else
					{
						isPlaying = false;
					}
					break;
			}
		}
      
		public function set width(value:Number):void
		{
			(viewComponent as PlaylistList).ww = value;
		}
		
		public function set height(value:Number):void
		{
			(viewComponent as PlaylistList).hh = value;
		}
		
		public function get view():DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		public function set list(dp:DataProvider):void
		{
			(viewComponent as PlaylistList).updateList(dp);			
		}
		
		public function get list():DataProvider
		{
			return (viewComponent as PlaylistList).list;
		}
		
		public function close():void
		{
			sendNotification("doPlaylistSelect");
		}
		
		public function selectItem(index:int=-1):void
		{
			(viewComponent as PlaylistList).selectItem(index);
		}
	}
}