/**
 * demoPlugin
 *
 * @langversion 3.0
 * @playerversion Flash 10.0.1
 * @author Eitan
 */
package {
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.controller.PlayRandomSoundCommand;
	import com.kaltura.kdpfl.plugin.controller.TimeHandlerCommand;
	import com.kaltura.kdpfl.plugin.model.SoundProxy;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * <code>nonvisualDemoCode</code> is the real plugin. 
	 * KDP initializes it by calling <code>initializePlugin()</code> and then calls <code>setSkin()</code>.
	 * @author Atar
	 */
	public class nonvisualDemoCode extends UIComponent implements IPlugin {
		

		/**
		 * Constructor
		 */
		public function nonvisualDemoCode() {

		}


		/**
		 * KDP calls this interface method to initialize the new plugin. 
		 * 
		 * 
		 * @param facade	KDP application facade
		 * @return
		 */
		public function initializePlugin(facade:IFacade):void {
			//TODO pass some parameter from outside
			// create the sound proxy and register it with the application facade
			facade.registerProxy(new SoundProxy(SoundProxy.NAME));
			
			// register the different commands. this means an instance of the command 
			// will be created every time the matching notification is sent. 
			facade.registerCommand(NotificationType.VOLUME_CHANGED, PlayRandomSoundCommand);
			facade.registerCommand(NotificationType.KDP_READY, PlayRandomSoundCommand);
			facade.registerCommand(NotificationType.MEDIA_READY, TimeHandlerCommand);
			facade.registerCommand(NotificationType.PLAYER_UPDATE_PLAYHEAD, TimeHandlerCommand);
//			
			// this notification will be sent by TimeHandlerCommand when it needs to play a sound:
			facade.registerCommand(SoundProxy.PLAY_RANDOM_SOUND, PlayRandomSoundCommand);
		}


		/**
		 * KDP calls this interface method in order to set the plugin's skin.
		 * This plugin isn't visual and has no skin, so the implementation is empty.
		 * @param styleName		name of style to be set
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
			
		}


	}
}
