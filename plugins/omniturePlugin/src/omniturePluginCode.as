package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.OmnitureMediator;

	import flash.display.Sprite;

	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * actual plugin
	 */
	public class omniturePluginCode extends Sprite implements IPlugin {
		/**
		 * Bypass statistics sending
		 */
		public var statsDis:Boolean;

		/**
		 * Omniture account
		 */
		public var account:String;

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


		/**
		 * Constructor
		 */
		public function omniturePluginCode() {
			super();
		}


		/**
		 * Initialize the mediator and the view component
		 * @param facade	KDP application facade
		 */
		public function initializePlugin(facade:IFacade):void {

			_omnitureMediator = new OmnitureMediator(statsDis, new Sprite());
			//setting the variables from the Uiconf to the mediator
			_omnitureMediator.account = account;
			_omnitureMediator.visitorNamespace = visitorNamespace;
			_omnitureMediator.trackingServer = trackingServer;
			_omnitureMediator.trackMilestones = trackMilestones;
			_omnitureMediator.init();
			facade.registerMediator(_omnitureMediator);
			addChild(_omnitureMediator.view);
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