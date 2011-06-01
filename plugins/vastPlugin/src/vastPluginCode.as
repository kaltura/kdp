package {
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.NonLinearAdProxy;
	import com.kaltura.kdpfl.plugin.component.PersistentData;
	import com.kaltura.kdpfl.plugin.component.VastLinearAdProxy;
	import com.kaltura.kdpfl.plugin.component.VastMediator;
	
	import flash.display.Sprite;
	import flash.net.SharedObject;
	
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
		/**
		 * The time at which to show first overlay ad
		 * */
		public var overlayStartAt:Number;

		[Bindable]
		/**
		 * Every how much time to show overlay ad henceforth
		 * */
		public var overlayInterval:Number;

		[Bindable]
		public var overlayDisplayDuration:Number;
		public var overlayUrl:String;

		//Companion ad vars

		/**
		 * a string representing the companion ads to be presented inside the player
		 * */
		public var flashCompanions:String;

		/**
		 * a string representing the companion ads to be presented in the HTML page
		 * */
		public var htmlCompanions:String;

		/**
		 * time to wait for ad load before skipping an ad
		 */
		public var timeout:Number;


		// persistence
		/**
		 * should values be maintained in
		 * sharedObject between sessions
		 */
		public var persistence:Boolean = false;

		/**
		 * object that stores data between sessions
		 */
		private var _pers:PersistentData;

		

		//Privates
		private var _linearAds:VastLinearAdProxy;

		private var _sequenceProxy:Object;
		private var _vastMediator:VastMediator

		/**
		 * the context in which the current ad is playing, pre | post
		 * */
		private var _sequenceContext:String = "pre";

		/**
		 * @copy #playedPrerollsSingleEntry
		 * */
		private var _playedPrerollsSingleEntry:int = 0;

		/**
		 * @copy #playedPostrollsSingleEntry
		 * */
		private var _playedPostrollsSingleEntry:int = 0;

		/**
		 * Boolean signifying whether the first pre roll ad was shown
		 * */
		private var _firstPrerollShown:Boolean = false;

		/**
		 * Boolean signifying whether the first post roll ad was shown
		 * */
		private var _firstPostrollShown:Boolean = false;

		/**
		 * number of entries which were played since the last preroll was shown
		 */
		private var _numEntriesPlayedPreroll:int = 1;

		/**
		 * number of entries which were played since the last postroll was shown
		 */
		private var _numEntriesPlayedPostroll:int = 1;



		/**
		 * Prepare media elements of the vast plugin and load them
		 * */
		public function initializePlugin(facade:IFacade):void {
			if (persistence) {
				_pers = new PersistentData();
				_pers.init(facade);
			}

			_sequenceProxy = facade.retrieveProxy("sequenceProxy");
			_vastMediator = new VastMediator(this);
			facade.registerMediator(_vastMediator);
			_linearAds = new VastLinearAdProxy(prerollUrl, postrollUrl, flashCompanions, htmlCompanions, timeout);
			_linearAds.addEventListener(VastLinearAdProxy.SIGNAL_END, endSubsequence);
		}


		public function initVASTAds():void {

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
			_linearAds.resetVast();
			if (_sequenceContext == "pre") {
				if (numPreroll - _playedPrerollsSingleEntry > 0) {

					return true;
				}
				else {
					_playedPrerollsSingleEntry = 0;
				}
			}
			if (_sequenceContext == "post") {
				if (numPostroll - _playedPostrollsSingleEntry > 0) {

					return true;
				}
				else {
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
		public function start():void {
			_sequenceContext = (_sequenceProxy["vo"]["preCurrentIndex"] != -1) ? "pre" : "post";
			_vastMediator.adContext = _sequenceContext;
			if (shouldPlay()) {
				_vastMediator.isListening = true;

				if (_playedPrerollsSingleEntry == 0 && _playedPostrollsSingleEntry == 0)
					_vastMediator.enableGUI(false);

				_linearAds.loadAd(_sequenceContext);

				if (_sequenceContext == "pre") {
					_playedPrerollsSingleEntry++;
				}
				else if (_sequenceContext == "post") {
					_playedPostrollsSingleEntry++;
				}
			}
			else {
				_vastMediator.enableGUI(true);
				_linearAds.signalEnd();
			}
		}


		
		/**
		 * update counters and flush data according to current roll. </br>
		 * this happens right before the plugin returns control to KDP
		 * @param e
		 */		
		private function endSubsequence(e:Event = null):void {
			if (_sequenceContext == "pre") {
				_numEntriesPlayedPreroll++;
			}
			else {
				_numEntriesPlayedPostroll++;
			}
			if (persistence) {
				updatePersistentData();
			}
		}
		

		


		private function shouldPlay():Boolean {
			var result:Boolean = false;
			if (persistence) {
				if (!_pers.isPersistenceValid()) {
					// reset 
					_pers.resetPersistenceData();
				}
				// use saved data:
				var pd:Object = _pers.data;
				_firstPrerollShown = pd.prerollFirstShow;
				_numEntriesPlayedPreroll = pd.prerollEntries;
				_firstPostrollShown = pd.postrollFirstShow;
				_numEntriesPlayedPostroll = pd.postrollEntries;
			}

			if (_sequenceContext == "pre" && prerollUrl) {
				if (_playedPrerollsSingleEntry == 0) {
					// this is the first ad for this round
//					_numEntriesPlayedPreroll++;
					if (!_firstPrerollShown) {
						// if the first preroll was not yet shown, we are 
						// under the prerollStartWith limitation 
						if (_numEntriesPlayedPreroll == prerollStartWith) {
							result = true;
							_firstPrerollShown = true;
							_numEntriesPlayedPreroll = 1;
						}
					}
					else {
						// otherwise, we are under the prerollInterval limitation.
						if (_numEntriesPlayedPreroll == prerollInterval) {
							result = true;
							_numEntriesPlayedPreroll = 1;
						}
					}
				}
				else {
					// still have ads to play for this round
					result = true;
				}
			}
			else if ((_sequenceContext == "post") && postrollUrl) {
				if (_playedPostrollsSingleEntry == 0) {
//					_numEntriesPlayedPostroll++;
					if (!_firstPostrollShown) {
						if (_numEntriesPlayedPostroll == postrollStartWith) {
							result = true;
							_firstPostrollShown = true;
							_numEntriesPlayedPostroll = 1;
						}
					}
					else {
						if (_numEntriesPlayedPostroll == postrollInterval) {
							result = true;
							_numEntriesPlayedPostroll = 1;
						}
					}
				}
				else {
					result = true;
				}
			}
			if (persistence) {
				updatePersistentData()
			}
			return result;
		}
		
		
		/**
		 * save updated data to the persistent storage 
		 */		
		private function updatePersistentData():void {
			var pd:Object = new Object();
			pd.prerollFirstShow = _firstPrerollShown;
			pd.prerollEntries = _numEntriesPlayedPreroll;
			pd.postrollFirstShow = _firstPostrollShown;
			pd.postrollEntries = _numEntriesPlayedPostroll;
			_pers.updatePersistentData(pd);
		}


		// =========================================================
		// public getters / setters
		// =========================================================


		[Bindable]
		public function set overlays(value:Object):void {
			_overlays = value;
		}


		public function get overlays():Object {
			return _overlays;
		}


		/**
		 * number of preroll ads that were shown per a single entry
		 * */
		public function get playedPrerollsSingleEntry():int {
			return _playedPrerollsSingleEntry;
		}


		/**
		 * @private
		 * */
		public function set playedPrerollsSingleEntry(value:int):void {
			_playedPrerollsSingleEntry = value;
		}


		/**
		 * number of postroll ads that were shown per a single entry
		 * */
		public function get playedPostrollsSingleEntry():int {
			return _playedPostrollsSingleEntry;
		}


		/**
		 * @private
		 * */
		public function set playedPostrollsSingleEntry(value:int):void {
			_playedPostrollsSingleEntry = value;
		}


		[Bindable]
		public function set prerollUrl(value:String):void {
			_prerollUrl = value;
			_linearAds.prerollUrl = value;
		}


		public function get prerollUrl():String {
			return _prerollUrl;
		}


		[Bindable]
		public function set postrollUrl(value:String):void {
			_postrollUrl = value;
			_linearAds.postrollUrl = value;
		}


		public function get postrollUrl():String {
			return _postrollUrl;
		}

	}
}