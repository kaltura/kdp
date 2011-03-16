package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.yahoo.astra.fl.controls.carouselClasses.StackCarouselRenderer;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ComscoreMediator extends Mediator
	{
		public static const NAME : String = "comscoreMediator";
		
		public static const VIDEO_TYPE : String = "1";
		
		public static const PREROLL_AD_CONTENT_TYPE : String = "090000";
		
		public static const POSTROLL_AD_CONTENT_TYPE : String = "100000";
		
		public static const MIDROLL_AD_CONTENT_TYPE : String = "110000";
		
		protected var _playerPlayedFired : Boolean = false;
		
		protected var cParams : Object = new Object();
		
		protected var _flashvars : Object;
		
		public function ComscoreMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			var arr : Array = [NotificationType.PLAYER_PLAYED, AdsNotificationTypes.AD_START, NotificationType.ENTRY_READY, NotificationType.LAYOUT_READY]
			return arr;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var sequenceProxy : SequenceProxy = (facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy);
			switch (notification.getName() )
			{
				case NotificationType.LAYOUT_READY:
					_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
					break;
				case NotificationType.ENTRY_READY:
					createCParams();
					_playerPlayedFired = false;
					break;
				case NotificationType.PLAYER_PLAYED:
					if (!_playerPlayedFired)
					{
						
						if (!sequenceProxy.vo.isInSequence) 
						{
							cParams["c5"] = (viewComponent as ComscorePluginCode).c5;
							comscoreBeacon ();
							_playerPlayedFired = true;
						}
					}
					break;
				case AdsNotificationTypes.AD_START:
					switch (sequenceProxy.sequenceContext)
					{
						case SequenceContextType.PRE:
							cParams["c5"] = PREROLL_AD_CONTENT_TYPE;
							break;
						case SequenceContextType.POST:
							cParams["c5"] = POSTROLL_AD_CONTENT_TYPE;
							break;
						case SequenceContextType.MID:
							cParams["c5"] = MIDROLL_AD_CONTENT_TYPE;
							break;
					}
					comscoreBeacon ();
					break;
			}
		}
		
		protected function comscoreBeacon () : void
		{
			var loadUrl : String;
			var referrer : String = "";
			var page : String = "";
			var title : String = "";
			try {
				referrer = ExternalInterface.call( "function() { return document.referrer; }").toString();
				page = ExternalInterface.call( "function () { return document.location.href; } ").toString();
				title = ExternalInterface.call( "function () { retun document.title; } ").toString();
			} catch (e : Error) {
				
			}
			
			if (page.indexOf("https") != -1 ) {
				loadUrl = "https://sb.";	
			}  else {
				loadUrl = "http://b."
			}
			loadUrl += "scorecardresearch.com/p?";
			
			for (var cParam : String  in cParams) {
				loadUrl += cParam+"="+cParams[cParam]+"&";
			}
			
			if (page && page != "") {
				loadUrl += "c7=" + page +"&";
			}
			
			if (title && title != "") {
				loadUrl += "c8=" + title +"&";
			}
			
			if (referrer && referrer != "") {
				loadUrl += "c9=" + referrer +"&";
			}
			
			loadUrl += Math.random().toString() + "&";
			
			loadUrl +="cv=" + (viewComponent as ComscorePluginCode).comscoreVersion;
			
			var loader : URLLoader = new URLLoader();
			
			var urlRequest : URLRequest = new URLRequest(loadUrl);

			loader.addEventListener(Event.COMPLETE, onComscoreBeaconSuccess);
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, onComscoreBeaconFailed);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onComscoreBeaconFailed);
			loader.load(urlRequest);
		}
		
		protected function onComscoreBeaconSuccess (e : Event) : void
		{
			
		}
		
		protected function onComscoreBeaconFailed (e : Event) : void
		{
			
		}
		
		protected function createCParams() : void
		{
			cParams["c1"] = (viewComponent as ComscorePluginCode).c1 ? (viewComponent as ComscorePluginCode).c1 : VIDEO_TYPE;
			cParams["c2"] = (viewComponent as ComscorePluginCode).c2;
			cParams["c3"] = (viewComponent as ComscorePluginCode).c3;
			cParams["c4"] = (viewComponent as ComscorePluginCode).c4;
			cParams["c5"] = (viewComponent as ComscorePluginCode).c5;
			cParams["c6"] = (viewComponent as ComscorePluginCode).c6;
			cParams["c10"] = (viewComponent as ComscorePluginCode).c10;
			
			
		}
	}
}