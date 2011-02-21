package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class Shortcuts508Mediator extends Mediator
	{
		public static const NAME:String = "shortcuts508Mediator";

		public function Shortcuts508Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						"setClosedCaptionsToOff",
						"setAudioDescriptionToOff"
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
				case "setClosedCaptionsToOff":
					(view as Shortcuts508).setClosedCaptionsToOff ();
				break;

				case "setAudioDescriptionToOff":
					(view as Shortcuts508).setAudioDescriptionToOff ();
				break;
			}
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		public function added() : void  
		{
			(view as Shortcuts508).added(facade);
		}
		
		public function setScreenSize( w:Number, h:Number) : void  
		{
			// Call when video player window changes size (example fullscreen)
			(view as Shortcuts508).setSize(w,h);
		}

		public function setButtons(playBtn:KButton, backBtn:KButton, fwdBtn:KButton, muteBtn:KButton, volDownBtn:KButton, volUpBtn:KButton, fsBtn:KButton, ccBtn:KButton, adBtn:KButton):void
		{
			(view as Shortcuts508).setButtons(playBtn, backBtn, fwdBtn, muteBtn, volDownBtn, volUpBtn, fsBtn, ccBtn, adBtn);
		}
	}
}