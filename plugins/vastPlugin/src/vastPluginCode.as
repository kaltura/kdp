package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.NonLinearAdProxy;
	import com.kaltura.kdpfl.plugin.component.VastLinearAdProxy;
	import com.kaltura.kdpfl.plugin.component.VastMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class vastPluginCode extends Sprite implements IPlugin, ISequencePlugin {
		//General plugin definitions
		public var postSequence:Number;
		public var preSequence:Number;

		//pre-roll properties
		public var numPreroll:int;
		public var prerollInterval:int;
		public var prerollStartWith:int;
		private var _prerollUrl:String;

		//post-roll properties
		public var numPostroll:int;
		public var postrollInterval:int;
		public var postrollStartWith:int;
		private var _postrollUrl:String;

		private var _overlays:Object;

		//Overlay properties
		[Bindable]
		public var overlayStartAt:Number; //The time at which to show first overlay ad
		[Bindable]
		public var overlayInterval:Number; // Every how much time to show overlay ad henceforth
		[Bindable]
		public var overlayDisplayDuration:Number;
		public var overlayUrl:String;

		//Companion ad vars

		public var flashCompanions:String;
		public var htmlCompanions:String;
		public var timeout : Number;

		//Privates
		private var linearAds:VastLinearAdProxy;
		//private var _nonlinearAds : NonLinearAdProxy;
		
		private var sequenceProxy : Object;
		private var _vastMediator : VastMediator
		private var _sequenceContext : String = "pre";
		private var _playedPrerollsSingleEntry : int = 0;
		private var _playedPostrollsSingleEntry : int = 0; // 
		private var _firstPrerollShown : Boolean = false; //Boolean signifying whether the first pre roll ad was shown
		private var _firstPostrollShown : Boolean = false;//Boolean signifying whether the first post roll ad was shown
		private var _numEntriesPlayedPreroll : int = 0;
		private var _numEntriesPlayedPostroll : int = 0;
		private var _shouldPlayPreroll : Boolean = false;
		private var _shouldPlayPostroll : Boolean = false;
		
		
		public function vastPluginCode()
		{

		}


		public function initializePlugin(facade:IFacade):void {

			//Prepare media elements of the vast plugin and load them
			
			sequenceProxy = facade.retrieveProxy("sequenceProxy");
			_vastMediator = new VastMediator(this);
			facade.registerMediator(_vastMediator);
			linearAds = new VastLinearAdProxy(prerollUrl, postrollUrl, flashCompanions, htmlCompanions, timeout);
		}

		public function initVASTAds () : void
		{
			
			var nonlinearAds:NonLinearAdProxy = new NonLinearAdProxy(this);
			if (overlayUrl)
				nonlinearAds.loadNonLinearAds(overlayUrl);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
		}


		//Implementation of the ISequencePlugin methods

		public function get entryId():String {
			return "null"
		}


		public function get mediaElement():Object {
			return 1;
		}


		public function get postIndex():Number {
			return postSequence;
		}


		public function get preIndex():Number {
			return preSequence;
		}


		public function hasMediaElement():Boolean {
			return true;
		}


		public function get sourceType():String {
			return "url"
		}


		public function hasSubSequence():Boolean {
			
			_vastMediator.reset();
			linearAds.resetVast();
			if (_sequenceContext == "pre") {
				if (numPreroll - _playedPrerollsSingleEntry > 0) {

					return true;
				} else {
					_playedPrerollsSingleEntry = 0;
				}
			}
			if (_sequenceContext == "post") {
				if (numPostroll - _playedPostrollsSingleEntry > 0) {

					return true;
				} else {
					_playedPostrollsSingleEntry = 0;
				}
			}

			//Hack : Since we have no indication that the media has finished playing, 
			// check whether there is no more sub-sequence left
			
			return false;
		}


		public function subSequenceLength():int {
			var returnValue:int = (_sequenceContext == "pre") ? numPreroll : numPostroll;
			return returnValue;
		}


				
		/**
		 * Function starts the plugin playing in the kdp 
		 * 
		 */		
		public function start () : void
		{
			_sequenceContext = (sequenceProxy["vo"]["preCurrentIndex"] != -1) ? "pre" : "post";
			_vastMediator.adContext = _sequenceContext; 
			if (shouldPlay()) {
				_vastMediator.isListening = true;

				if (_playedPrerollsSingleEntry == 0 && _playedPostrollsSingleEntry == 0)
					_vastMediator.enableGUI(false);

				linearAds.loadAd(_sequenceContext);

				if (_sequenceContext == "pre") {
					_playedPrerollsSingleEntry++;
				} else if (_sequenceContext == "post") {
					_playedPostrollsSingleEntry++;
				}
			} else {
				_vastMediator.enableGUI(true);
				linearAds.signalEnd();
			}

		}


		private function shouldPlay():Boolean {
			var shouldPlayPostroll:Boolean = false;
			var shouldPlayPreroll:Boolean = false;
			if (_sequenceContext == "pre" && prerollUrl) {
				if (_playedPrerollsSingleEntry == 0) {
					_numEntriesPlayedPreroll++;
					if (!_firstPrerollShown) {
						if (_numEntriesPlayedPreroll == prerollStartWith) {
							shouldPlayPreroll = true;
							_firstPrerollShown = true;
							_numEntriesPlayedPreroll = 0;
						}
					} else {
						if (_numEntriesPlayedPreroll == prerollInterval) {
							shouldPlayPreroll = true;
							_numEntriesPlayedPreroll = 0;
						}
					}
				} else {
					shouldPlayPreroll = true;
				}
			} else if ((_sequenceContext == "post") && postrollUrl) {
				if (_playedPostrollsSingleEntry == 0) {
					_numEntriesPlayedPostroll++;
					if (!_firstPostrollShown) {
						if (_numEntriesPlayedPostroll == postrollStartWith) {
							shouldPlayPostroll = true;
							_firstPostrollShown = true;
							_numEntriesPlayedPostroll = 0;
						}
					} else {
						if (_numEntriesPlayedPostroll == postrollInterval) {
							shouldPlayPostroll = true;
							_numEntriesPlayedPostroll = 0;
						}
					}
				} else {
					shouldPlayPostroll = true;
				}

			}

			if (_sequenceContext == "pre") {
				return shouldPlayPreroll;
			} else {
				return shouldPlayPostroll;
			}
		}


		[Bindable]
		public function set overlays(value:Object):void {
			_overlays = value;
		}


		public function get overlays():Object {
			return _overlays;
		}

		public function get playedPrerollsSingleEntry():int
		{
			return _playedPrerollsSingleEntry;
		}

		public function set playedPrerollsSingleEntry(value:int):void
		{
			_playedPrerollsSingleEntry = value;
		}

		public function get playedPostrollsSingleEntry():int
		{
			return _playedPostrollsSingleEntry;
		}

		public function set playedPostrollsSingleEntry(value:int):void
		{
			_playedPostrollsSingleEntry = value;
		}
		
		[Bindable]
		public function set prerollUrl(value:String):void
		{
			_prerollUrl = value;
			linearAds.prerollUrl = value;
		}
		
		public function get prerollUrl():String { return _prerollUrl; }
		
		[Bindable]
		public function set postrollUrl(value:String):void
		{
			_postrollUrl = value;
			linearAds.postrollUrl = value;
		}
		
		public function get postrollUrl():String { return _postrollUrl; }
		


	}
}