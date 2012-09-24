package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;

	/**
	 * Bumper plugin shows a (short) KalturaEntry before or after the main entry.  
	 */	
	public class BumperPlugin extends Sprite implements IPluginFactory {

		public function BumperPlugin() {
			Security.allowDomain("*");
		}


		/**
		 * Creates a new IPlugin instance. And is implemented by the plugin application class
		 * @param pluginName the plugin name to be created in case there are multiple plugins with
		 *     the same plugin swf file
		 * @return An instance of the plugin
		 */
		public function create(pluginName:String = null):IPlugin {
			var bpc:BumperPluginCode = new BumperPluginCode();
//			bpc.clickurl = clickurl;
//			bpc.bumperEntryID = bumperEntryID;
//			bpc.lockUI = lockUI;
			return bpc;
		}
	}
}