package {
	import com.kaltura.kdfl.plugin.Bumper;
	import com.kaltura.kdfl.plugin.BumperMediator;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * Actual bumper plugin code
	 */	
	public class BumperPluginCode extends UIComponent implements IPlugin, ISequencePlugin {
 
		public var preSequence : int;
		public var postSequence : int;
		
		/**
		 * the url to which clicking the bumper video should lead.
		 */
		public var clickurl:String;

		/**
		 * id of the entry to be played as bumper video 
		 */
		public var bumperEntryID:String;
		
		/**
		 * determines wether UI should be locked during bumpervideo playback
		 */
		public var lockUI:String;
		
		/**
		 * indicates the bumper should only play once for pre and
		 * once for post, at first possible chance.
		 */		
		public var playOnce:String;

		/**
		 * an object that holds bumper configuratiuon
		 */
		private var _rootCfg:Object = new Object();

		/**
		 * the mediator for this plugin
		 */
		private var _bumperMediator:BumperMediator;


		/**
		 * Constructor.
		 */
		public function BumperPluginCode() {

		}


		/**
		 * @copy UIComponent.set width
		 */
		override public function set width(value:Number):void {
			_rootCfg.width = value;
			super.width = value;
			if (_bumperMediator)
				_bumperMediator.resetSize();
		}


		/**
		 * @copy UIComponent.set height
		 */
		override public function set height(value:Number):void {
			_rootCfg.height = value;
			super.height = value;

			if (_bumperMediator)
				_bumperMediator.resetSize();
		}


		/**
		 * This function is automatically called by the player after the plugin has loaded.
		 * @param facade	the facade used to comunicate with the hosted player.
		 */
		public function initializePlugin(facade:IFacade):void {
			// create a data vo and pass it to a Bumper instance
			// add the Bumper instance to stage
			_rootCfg.clickurl = clickurl;
			_rootCfg.bumperEntryID = bumperEntryID; 
			_rootCfg.lockUI = lockUI;
			_rootCfg.playOnce = (playOnce == "true");
			_rootCfg.width = super.width;
			_rootCfg.height = super.height;

			var bumper:Bumper = new Bumper(_rootCfg);
			_bumperMediator = new BumperMediator(bumper);
			_bumperMediator.preSequence = preSequence;
			_bumperMediator.postSequence = postSequence;

			facade.registerMediator(_bumperMediator);
			this.addChild(bumper);
		}


		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {

		}
		public function get entryId () : String
		{
			return bumperEntryID;
		}
		
		public function get mediaElement () : Object
		{
			return null;
		}
		
		public function hasMediaElement() : Boolean
		{
			return true;
		}
		public function get preIndex () : Number
		{
			return preSequence;
		}
		public function get postIndex () : Number
		{
			return postSequence;
		}
		public function get sourceType () : String
		{
			return "entryId";
		}
		public function hasSubSequence () : Boolean
		{
			return false;
		}
		public function subSequenceLength () : int
		{
			return 0;
		}
		public function start () : void
		{
			_bumperMediator.playContent();
		}


	}
}