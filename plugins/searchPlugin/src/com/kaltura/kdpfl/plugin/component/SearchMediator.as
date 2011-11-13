package com.kaltura.kdpfl.plugin.component
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class SearchMediator extends Mediator
	{
		public static const NAME:String = "playlistMediator";
		
		public function SearchMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						"stageResize",
						"layoutReady"
					];
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				// this means that the main container will be 100% X 100% always
				case "stageResize":
					trace("test plugin");
				break;
				
			}
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		public function resizeView (value : Number) : void
		{
			view["constructForm"](value);
		}
	}
}