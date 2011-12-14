package
{
	import com.kaltura.kdfl.plugin.component.Eyewonder;
	import com.kaltura.kdfl.plugin.component.EyewonderMediator;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class EyewonderPluginCode extends UIComponent implements IPlugin, ISequencePlugin
	{
		/**
		 * presequence order of this plugin 
		 */		
		public var preSequence : int;
		
		/**
		 * post sequence order of this plugin 
		 */		
		public var postSequence : int;
		
		/**
		 * url from which to retreive preroll ads 
		 */		
		public var preroll : String; // = "http://cdn1.eyewonder.com/200125/754851/1149206/1149206_tag.xml?ewbust=[timestamp]";	
		
		/**
		 * url from which to retreive midroll ads 
		 */
		public var midroll : String; // = "http://cdn1.eyewonder.com/200125/754851/1149206/1149206_tag.xml?ewbust=[timestamp]";
		
		/**
		 * url from which to retreive postroll ads 
		 */
		public var postroll : String;//= "http://cdn1.eyewonder.com/200125/754851/1149206/1149206_tag.xml?ewbust=[timestamp]";

		/**
		 * url from which to retreive overlay ads 
		 */
		public var overlay : String; // = "http://cdn1.eyewonder.com/200125/754851/1149218/1149218_tag.xml?ewbust=[timestamp]";
		
		
		/**
		 * ads volume 
		 */		
		public var volume : Number = 100;
		
		/**
		 * length of time to wait before showing overlay
		 */		
		public var overlayDelay : Number = 5;
		
		/**
		 * @copy EyewonderMediator.showOverlayAt
		 */		
		public var showOverlayAt : String = "5";
		
		/**
		 * @copy EyewonderMediator.showMidrollAt
		 */
		public var showMidrollAt : String = "50%";

		/**
		 * a reference to this plugin's (pureMVC) mediator 
		 */		
		private var _eyewonderMediator : EyewonderMediator;
		
		/**
		 * configuration object 
		 */		
		private var _rootCfg:Object = new Object();
		
		
		/**
		 * Constructor. 
		 */		
		public function EyewonderPluginCode(){}
		
		
		override public function set width(value:Number):void
		{
			_rootCfg.width = value;
			super.width = value;
 			if(_eyewonderMediator)
				_eyewonderMediator.setSize( super.width , super.height ); 
		} 
		
		override public function set height(value:Number):void
		{
			_rootCfg.height = value;
			super.height = value;
 			
			if(_eyewonderMediator)
				_eyewonderMediator.setSize( super.width , super.height ); 
		}
		
		/**
		 * KDP triggers this function to initialize the plugin. 
		 * @param facade	pureMVC facade
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			_rootCfg.preroll = preroll;
			_rootCfg.midroll = midroll;
			_rootCfg.postroll = postroll;
			_rootCfg.overlay = overlay;
			_rootCfg.volume = volume;
			_rootCfg.overlay_delay = overlayDelay;
				
			var eyewonder : Eyewonder = new Eyewonder( _rootCfg );
			_eyewonderMediator = new EyewonderMediator( eyewonder );
			_eyewonderMediator.preSequence = preSequence;
			_eyewonderMediator.postSequence = postSequence;
			_eyewonderMediator.showOverlayAt = showOverlayAt;
			_eyewonderMediator.showMidrollAt = showMidrollAt;	
			facade.registerMediator( _eyewonderMediator );
			this.addChild( eyewonder );
		}
		
		/**
		 * interface method - empty implementation. </br>
		 * not a visual plugin so no need to implement
		 * */ 
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{} 
		
		//Implementation of the ISequencePlugin methods : 
		
		
		public function hasMediaElement () : Boolean
		{
			return false;
		}
		
		public function get entryId () : String
		{
			return "null";
		}
		
		public function get mediaElement () : Object
		{
			return null;
		}
		public function hasSubSequence () : Boolean
		{
			return false;
			
		}
		public function subSequenceLength () : int
		{
			return 0;	
		}
		public function get preIndex () : Number
		{
			return preSequence;
		}
		public function get postIndex () : Number
		{
			return postSequence;
		}
		
		public function start () : void
		{
			_eyewonderMediator.forceStart();
		}
		public function get sourceType () : String
		{
			return "url";
		}
	}
}