package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.FreeWheelComponent;
	import com.kaltura.kdpfl.plugin.component.FreeWheelMediator;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class freeWheelPluginCode extends UIComponent implements IPlugin, ISequencePlugin
	{
		public static const URL : String = "url";
		/**
		 * Kaltura's pre sequence index
		 */		
		public var preSequence : int;
		
		/**
		 * The freeWheel osmf plugin url path 
		 */		
		public var fwPluginLocation : String;
				
		/**
		 * AdManager location url 
		 * Required: false 
		 */		
		public var admanagerUrl : String;

		/**
		 * Ad Server url
		 * Required: false 
		 */		
		public var adServerUrl : String;
		
		/**
		 * NetworkId provided by Freewheel system 
		 * Required: true
		 */		
		public var networkId : uint;

		/**
		 * site section id provided by Freewheel system 
		 * Required: false
		 */	
		public var siteSectionCustomId : uint
		
		/**
		 * Site section network id provided by Freewheel system 
		 * Required: false
		 */		
		public var siteSectionNetworkId : uint

		/**
		 * Video asset network id provided by Freewheel system
		 * Required: false
		 */
		public var videoAssetNetworkId : uint;

		/**
		 * Player profiler
		 * Required: true
		 */		
		public var playerProfile : String;

		/**
		 * Cache buster for loading AdManager 
		 */		
		public var cacheBuster : Number;
		 	
		 	
		private var	_freeWheelMediator : FreeWheelMediator;		
			
		public function freeWheelPluginCode()
		{
		}
		
		/**
		 * After kaltura plugin is loaded an initialize Plugin is execute
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			var freeWheelComponent : FreeWheelComponent = new FreeWheelComponent();
			freeWheelComponent.fwPluginLocation = fwPluginLocation;
			freeWheelComponent.admanagerUrl = admanagerUrl;
			freeWheelComponent.adServerUrl = adServerUrl;
			freeWheelComponent.networkId = networkId;
			freeWheelComponent.siteSectionCustomId = siteSectionCustomId;		
			freeWheelComponent.siteSectionNetworkId = siteSectionNetworkId;	
			freeWheelComponent.videoAssetNetworkId = videoAssetNetworkId;	
			freeWheelComponent.playerProfile = playerProfile;
			freeWheelComponent.cacheBuster = cacheBuster;
			
			_freeWheelMediator = new FreeWheelMediator( freeWheelComponent );
			
			_freeWheelMediator.preSequence = preSequence;
			_freeWheelMediator.postSequence = postSequence; 
			
			addChild( freeWheelComponent );
		}
		
		// Implement the ISequencePlugin interface
		// the only intresting part here is the start function.
		//////////////////////////////////////////////////////////
		public function start () : void
		{
			_freeWheelMediator.loadAndProceed();
		}
		
		public function hasSubSequence() : Boolean { return false; }
		public function subSequenceLength () : int { return 0; }
		public function hasMediaElement () : Boolean { return false; }	
		public function get entryId () : String { return "null"; }
		public function get sourceType () : String { return URL; }	
		public function get mediaElement () : Object { return null; } 
		public function get preIndex () : Number { return preSequence; }
		public function get postIndex () : Number { return postSequence; }
		//////////////////////////////////////////////////////////
		
	
		override public function set width(value:Number):void
		{
			super.width = value;
			_freeWheelMediator.getDisplay().width = value;
		}
		
		override public function set hieght(value:Number):void
		{
			super.hieght = value;
			_freeWheelMediator.getDisplay().hieght = value;
		}
	}
}