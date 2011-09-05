package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.osmf.kalturaMix.KalturaMixElement;
	import com.kaltura.osmf.kalturaMix.KalturaMixPluginInfo;
	import com.kaltura.osmf.kalturaMix.KalturaMixSprite;

	import flash.display.Sprite;
	import flash.system.Security;

	import org.osmf.elements.*;
	import org.osmf.media.PluginInfoResource;
	import org.osmf.media.pluginClasses.PluginManager;
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * 
	 * @author Atar
	 */
	public class kalturaMixPlugin extends Sprite implements IPlugin, IPluginFactory {
		
		/**
		 * the url from where to load required plugins
		 * @default  {CDN_SERVER_URL}/flash/mixplugins/v3.0
		 */
		public static var mixPluginsBaseUrl:String = "{CDN_SERVER_URL}/flash/mixplugins/v4.0";
		
		/**
		 * @default false 
		 */
		public var disableUrlHashing:Boolean = false;



		/**
		 * Constructor
		 */
		public function kalturaMixPlugin() {
			Security.allowDomain("*");
			var k:KalturaMixElement;
		}


		/**
		 * create plugin
		 * @param pluginName
		 * @return an instance of the "Real" plugin
		 */
		public function create(pluginName:String = null):IPlugin {
			return this;
		}


		/**
		 * initialize plugin manager etc
		 * @param facade	Application Facade
		 */
		public function initializePlugin(facade:IFacade):void {
			KalturaMixSprite.facade = facade;
			var mediaProxy:Object = facade.retrieveProxy("mediaProxy");
			var pluginManager:PluginManager = mediaProxy.vo.osmfPluginManager;
			var pluginResource:PluginInfoResource = new PluginInfoResource(new KalturaMixPluginInfo(disableUrlHashing));
			pluginManager.loadPlugin(pluginResource);
		}


		/**
		 * no implementation to interface method
		 * @param styleName
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
		}
	}
}
