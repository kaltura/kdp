package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.googleAnalytics.GAStatisticsMediator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 * A KDP 3 Google Analytics plugin for marshalling all statistics event to Google Analytics service using the ga library.
	 * @author Zohar Babin
	 */	
	public dynamic class googleAnalyticsPlugin extends Sprite implements IPlugin, IPluginFactory
	{
		
		//Any public paramter will be set from uiConf after create() and before initializePlugin()
		//With [Binding] will be immidiatly exposed to uiConf binding, so we set the urchinCode parameter Bindable and public
		[Binding]
		public var urchinCode:String = 'ua-example'; 
		
		public var playheadFrequency:Number 	= 5;
		
		public var visualDebug:Boolean;
		/**
		 * A comma seperated array of notifications to listen to. if this is not set - the default 
		 * GA behavior will be dispatched 
		 */		
		public var customEvents:String; 
		
		public var defaultCategory:String	= "Kaltura Video Events";
		
		// Statistics Mediator to catch all important events & notifications
		private var _statisticsMediator : GAStatisticsMediator;
		
		/**
		 * Constructor.
		 */		
		public function googleAnalyticsPlugin()
		{
			Security.allowDomain ("*");
		}
		
		/**
		 * Used by the Plugin wrapper to create the instance of this class.
		 * @param pluginName the plugin id from the uiConf (will be googleAnalytics).
		 * @return this, an instance of itself.
		 * @see com.kaltura.kdpfl.plugin.Plugin 
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return this;
		}
		
		/**
		 * After the plugin was loaded, this function is being called passing the KDP Facade. 
		 * @param facade	PureMVC Facade; used to communicate with the KDP application, create mediators, listen to events, etc.
		 * @see com.kaltura.kdpfl.ApplicationFacade
		 */		
		public function initializePlugin( facade : IFacade  ) : void
		{
			//loop through dynamic values			
			if (customEvents)
			{
				var customEventsArr:Array = customEvents.split(",");
			}

			_statisticsMediator = new GAStatisticsMediator(urchinCode, new Sprite());
			if(customEventsArr){
				var c:Array	=  _statisticsMediator.notifications.concat(customEventsArr);
				_statisticsMediator.notifications	= c;
			}
			
			_statisticsMediator.defaultCategory		= defaultCategory;
			
			_statisticsMediator.playheadFrequency	= playheadFrequency;
			
			_statisticsMediator.visualDebug = visualDebug;
			facade.registerMediator( _statisticsMediator);
			addChild(_statisticsMediator.view);
			addEventListener(Event.FRAME_CONSTRUCTED, setupGa);
		}
		
		private function setupGa (event:Event):void {
			removeEventListener(Event.FRAME_CONSTRUCTED, setupGa);
			_statisticsMediator.setupGa(urchinCode);
		}
		
		/**
		 * Called by the KDP during initialization of the components, this allows us plugin creators to get a handle to the skin
		 * We'd like to use for the plugin as defined in the uiConf.
		 * @param styleName			The name of the skin defined for this plugin in the uiConf.
		 * @param setSkinSize		Should we set the skin size or use the default as set inside the fla.
		 */		
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void {}
	}
}
