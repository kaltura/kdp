package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.OmnitureMediator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IProxy;

	/**
	 * Owner: Eitan Avgil
	 * Omniture plugin code. This class cretes a omnitureMediator and listen to it. If it gets a unique event from 
	 * one of the listed events it will look for matching event & event data (eVars and props). if it finds data, it will send the 
	 * event and clear the events object for next event.  
	 */
	public dynamic class omniturePluginCode extends Sprite implements IPlugin {
		/**
		 * Bypass statistics sending
		 */
		public var statsDis:Boolean;

		/**
		 * Omniture account
		 */
		public var account:String;
		
		/**
		 * Omniture debugMode
		 */
		public var debugMode:String = "";
		
		/**
		 * Omniture dc
		 */
		public var dc:String;
		/**
		 * Omniture charSet
		 */
		public var charSet:String;
		/**
		 * Omniture currencyCode
		 */
		public var currencyCode:String;
		
		public var dynamicConfig:String = "false";

		/**
		 * Omniture visitor namespace
		 */
		public var visitorNamespace:String;

		/**
		 * Omniture tracking server url
		 */
		public var trackingServer:String;

		/**
		 * percents of the movie to track
		 */
		public var trackMilestones:String = "25,50,75,100";

		/**
		 * mediator for this plugin
		 */
		private var _omnitureMediator:OmnitureMediator;

		public var customEvents:String = "";

		/**
		 * Constructor
		 */
		public function omniturePluginCode() {
			super();
		}

		private var  sequenceProxy:IProxy; 

		/**
		 * Initialize the mediator and the view component
		 * @param facade	KDP application facade
		 */
		public function initializePlugin(facade:IFacade):void {

			sequenceProxy= facade.retrieveProxy("sequenceProxy");
			var customEventsArr:Array = new Array();
			if (customEvents)
				customEventsArr = customEvents.split(",");
			_omnitureMediator = new OmnitureMediator(customEventsArr);
			//setting the variables from the Uiconf to the mediator
			_omnitureMediator.account = account;
			_omnitureMediator.debugMode = debugMode;
			_omnitureMediator.visitorNamespace = visitorNamespace;
			_omnitureMediator.trackingServer = trackingServer;
			_omnitureMediator.trackMilestones = trackMilestones;
			if(dc)
				_omnitureMediator.dc = dc;
			if(dc)
				_omnitureMediator.charSet = charSet;
			if(charSet)
				_omnitureMediator.charSet = charSet;
			if(currencyCode)
				_omnitureMediator.currencyCode = currencyCode;
			
			_omnitureMediator.dynamicConfig = dynamicConfig;
			
			
			_omnitureMediator.init();
			facade.registerMediator(_omnitureMediator);
			
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.VIDEO_VIEW_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.SHARE_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.OPEN_FULL_SCREEN_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.CLOSE_FULL_SCREEN_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.SAVE_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.SEEK_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.CHANGE_MEDIA_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.PLAYER_PLAY_END_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.MEDIA_READY_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.REPLAY_EVENT , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.PERCENT_50 , generalEvent);
			_omnitureMediator.eventDispatcher.addEventListener(OmnitureMediator.VIDEO_AUTOPLAY_EVENT , generalEvent);
			
			//listen to general events:
			for each (var str:String in customEventsArr)
			{
				_omnitureMediator.eventDispatcher.addEventListener(str , generalEvent);
			}

		}

		/**
		 * This function will look for dynamic properties in this class instance and send Omniture a matching event. 
		 * The evt.type is a string that will be the prefix of the event, its eVars and its props. This example will send event22 with eVar18 - video name
		 * eVar19-videoSite , prop33 - video name and prop 32 - video site. 
		 * <Plugin id="omniture" ... 
		 * saveEvent="event22" 
		 * saveEventEvar1="eVar18" saveEventEvar1Value="{mediaProxy.entry.id}"
		 * saveEventEvar2="eVar19" saveEventEvar2Value="{configProxy.flashvars.referer}"
		 * saveEventProp1="prop33" saveEventprop1Value="{mediaProxy.entry.id}"
		 * saveEventProp2="prop32" saveEventprop2Value="{configProxy.flashvars.referer}" ... />
		 * @param evt
		 * 
		 */		
		private function generalEvent(evt:Event):void
		{
			var foundEventProp:Boolean;
			var propsAndEvars:Object = new Object();
			
/*			//check if this event definition exist 
			if(!this[evt.type])
				return;*/
			
			for (var s:String in this)
			{
				// search for members with 'Value' string that matches the prefix of this event
				if(s.indexOf(evt.type)>-1 && s.indexOf("Value")>-1)
				{
					foundEventProp = true;
					//is this a property value ? 
					if (s.indexOf("Prop")>-1)
					{
						//found a prop value - extract the prop data 
						var propNumber:String = s.split("Value")[0].toString().split("Prop")[1];
						propsAndEvars[this[evt.type+"Prop"+propNumber]] = this[evt.type+"Prop"+propNumber+"Value"];
					}
					//is this an eVar value ? 
					if (s.indexOf("Evar")>-1)
					{
						//found an eVar - extract the eVar data
						var evarNumber:String = s.split("Value")[0].toString().split("Evar")[1];
						propsAndEvars[this[evt.type+"Evar"+evarNumber]] = this[evt.type+"Evar"+evarNumber+"Value"];
					}

				}
			}
			if(foundEventProp)
			{
				// build event
				if(this[evt.type])
				{
					//see if this has an event or just evar
					_omnitureMediator.s.Media.trackEvents = "events";
					_omnitureMediator.s.events = this[evt.type]; // eg event14
				}
				//build props and evars
				for (var key:String in propsAndEvars)
				{
					//trace(key , propsAndEvars[key]);
					_omnitureMediator.s[key] = propsAndEvars[key];
				}

				// send event - verify that this is not happening during sequence (Best buy custom)
				if (!sequenceProxy["vo"]["isInSequence"] || evt.type=="vastStartedPlaying"  )
				{
					if(evt.type!="vastStartedPlaying" && evt.type!="shareEvent")					
						_omnitureMediator.s.track();
					else if (evt.type=="vastStartedPlaying")
					{
						_omnitureMediator.s.events="event68"
						_omnitureMediator.s.eVar19= _omnitureMediator._mediaName;
						_omnitureMediator.s.linkTrackVars="events,eVar19"
						_omnitureMediator.s.linkTrackEvents="event68"
						_omnitureMediator.s.trackLink("","o","Preroll Start")
					}
					else
					{
						_omnitureMediator.s.events="event34"
						_omnitureMediator.s.eVar19= _omnitureMediator._mediaName;
						_omnitureMediator.s.linkTrackVars="events,eVar19"
						_omnitureMediator.s.linkTrackEvents="event34"
						_omnitureMediator.s.trackLink("","o","Video Share")
					}
				}
				
				//clear objects
				for (var key1:String in propsAndEvars)
				{
					_omnitureMediator.s[key1] = null;
				}

				_omnitureMediator.s.events = null;
			} else // event with no props || evars (Best buy custom)
			{
				//verify that this is an event that was declared 
				if(this[evt.type])
				{
					_omnitureMediator.s.Media.trackEvents = "events";
					_omnitureMediator.s.events = this[evt.type]; // eg event14
					if(evt.type != "adEnd")
						_omnitureMediator.s.track();
					else {
						_omnitureMediator.s.events="event57,event69"
						_omnitureMediator.s.eVar19= _omnitureMediator._mediaName;	
						_omnitureMediator.s.linkTrackEvents="event57,event69";
						_omnitureMediator.s.trackLink("","o","")

					}
				}
			}
		}

		

		/**
		 * Do nothing.
		 * No implementation required for this interface method on this plugin.
		 * @param styleName
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {}
	}
}