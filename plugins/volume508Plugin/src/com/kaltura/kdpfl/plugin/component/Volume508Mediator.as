package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class Volume508Mediator extends Mediator
	{
		public static const NAME:String = "volume508Mediator";
		private var _entryId:String = "";
		private var _totalBytes:Number = 0;
		private var _backbtn:KButton;
		private var _fwdbtn:KButton;
		private var _skipTimeout:int = 0;

		public function Volume508Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						"volumeChanged",
						"volume508down",
						"volume508up",
						"volume508mute"
					];
		}
		
		override public function handleNotification(note:INotification):void
		{
			var eventName:String = note.getName();
			var data:Object = note.getBody();
			var media : Object = facade.retrieveProxy("mediaProxy");
			var entry:String = media["vo"]["entry"]["id"];			

			switch (eventName)
			{
				// this means that the main container will be 100% X 100% always
				case "volumeChanged":
				{
					(view as Volume508).volumeChanged(data.newVolume);
				}
				break;

				case "volume508down":
				{
					(view as Volume508).volumeDown(facade);
				}
				break;

				case "volume508up":
				{
					(view as Volume508).volumeUp(facade);
				}
				break;

				case "volume508mute":
				{
					(view as Volume508).volumeMute(facade);
				}
				break;
			}
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		public function setScreenSize( w:Number, h:Number) : void  
		{
			// Call when video player window changes size (example fullscreen)
			(view as Volume508).setSize(w,h);
		}
	}
}