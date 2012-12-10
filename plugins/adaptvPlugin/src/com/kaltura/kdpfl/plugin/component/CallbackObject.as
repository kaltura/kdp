package com.kaltura.kdpfl.plugin.component
{
	public class CallbackObject
	{
		import org.puremvc.as3.interfaces.IFacade;	
			
		private  var _facade:IFacade;
		private  var _resumeEvent:String;
				
		public function CallbackObject(facade : IFacade)
		{
			_facade = facade;
		}
		
		public function setResumeEvent(evt:String):void
		{
			_resumeEvent = evt;
		}
		
	    public function playVideo():void {
	        // Note that the player should start with controls disabled
	        // and the video should not begin playing until the Ad Player calls this function

			var media : Object = _facade.retrieveMediator("kMediaPlayerMediator");
			
			_facade.sendNotification(_resumeEvent);				
			_facade.sendNotification("enableGui", true);
//	        videoPlayer.playVideo();           // start the video
	        //videoPlayer.enablecontrols(); // enable the controls of the player
	   
	        // adjust the visual or other state of your video player as necessary
	        // e.g. the play/pause button
	    }
	
	    public function pauseVideo():void {
			_facade.sendNotification("doPause");
	    	
//	        videoPlayer.pauseVideo();
	        // adjust the visual or other state of your video player as necessary
	        // e.g. the play/pause button
	    }
	
	    public function handleAdEvent(e:Object):void {
	    	var i:Number = 1;
	        // handles events from the ad plugins loaded during the videoview, e.g. impressions, clicks, etc
	    }
	}
}