package {
	import com.kaltura.kdpfl.plugin.IMidrollSequencePlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.NonLinearAdProxy;
	import com.kaltura.kdpfl.plugin.component.PersistentData;
	import com.kaltura.kdpfl.plugin.component.VastLinearAdProxy;
	import com.kaltura.kdpfl.plugin.component.VastMediator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osmf.media.MediaElement;
	import org.puremvc.as3.interfaces.IFacade;

	public class vastPluginCode extends Sprite implements IPlugin, ISequencePlugin, IMidrollSequencePlugin {
		//General plugin definitions
		public var postSequence:Number;
		public var preSequence:Number;

		
		/**
		 * Hide the timestamp 
		 **/
		public var omitTimestamp:Boolean;
		
		//pre-roll properties
		public var numPreroll:int;
		public var prerollInterval:int;
		public var prerollStartWith:int;
		private var _prerollUrlArr : Array = new Array();
		private var _prerollUrl:String;
		private var _currentPrerollUrl : String;

		//post-roll properties
		public var numPostroll:int;
		public var postrollInterval:int;
		public var postrollStartWith:int;
		private var _postrollUrlArr : Array = new Array();
		private var _postrollUrl:String;
		private var _currentPostrollUrl : String;

		private var _overlays:Object;
		
		private var _trackCuePoints : Boolean = false;
		private var _activeAdTagUrl : String;

		//Overlay properties
		[Bindable]
		/**
		 * The time at which to show first overlay ad
		 * */
		public var overlayStartAt:Number;

		[Bindable]
		/**
		 * Interval time between overlays.
		 * */
		public var overlayInterval:Number;

		[Bindable]
		public var overlayDisplayDuration:Number;
		
		private var _overlayUrl:String;
		private var _overlayUrlArr : Array;
		
		private var _midrollUrlArr : Array = new Array();
		
		[Bindable]
		public var midrollUrl : String;
		[Bindable]
		public var showFirstMidrollAt : Number;
		[Bindable]
		public var midrollInterval : Number;
		

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
		private var _nonlinearAds : NonLinearAdProxy;
		private var _sequenceProxy:Object;
		private var _vastMediator:VastMediator;

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
			_linearAds.omitTimestamp = omitTimestamp;
			_nonlinearAds = new NonLinearAdProxy (this);
			_linearAds.addEventListener(VastLinearAdProxy.SIGNAL_END, endSubsequence);
		}
		
		public function resize(width:Number,height:Number,mode:String):void
		{
			_linearAds.resizeAd(width,height,mode);
		}


		public function loadNonLinearAd( bannerURL : String =null):void
		{
			if (!bannerURL)
			{
				if (overlayUrl)
				{
					_nonlinearAds.loadNonLinearAds(overlayUrl);
				}
					
			}
			else
			{
				this.addEventListener( "overlaysLoaded" , onOverlayLoadedFromCuePoint )
				_nonlinearAds.loadNonLinearAds(bannerURL);
			}
		}
		
		public function finishLinearAd():void 
		{
			_linearAds.removeIcon();
		}
		
		private function onOverlayLoadedFromCuePoint (e : Event ) : void
		{
			_vastMediator.sendNotification( "showOverlayOnCuePoint" );
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
			
			if (_linearAds.hasPendingAds())
				return true;
			
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
			//remove leftovers from previous ad (in case of subsequence)
			finishLinearAd();
			
			_sequenceContext = _sequenceProxy["sequenceContext"];
			_vastMediator.adContext = _sequenceContext;
			if (shouldPlay()) {
				_vastMediator.isListening = true;

				if (!_playedPrerollsSingleEntry && !_playedPostrollsSingleEntry && !_linearAds.sequencedAds)
					_vastMediator.enableGUI(false);

				if (_linearAds.hasPendingAds())
				{
					_linearAds.playNextPendingAd();
				}
				else
				{
					_linearAds.loadAd(activeAdTagUrl , _sequenceContext);
					
					
					if (_sequenceContext == "pre") {
						_playedPrerollsSingleEntry++;
					}
					else if (_sequenceContext == "post") {
						_playedPostrollsSingleEntry++;
					}
				}
				
			}
			else {
			//	_vastMediator.enableGUI(true);
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
			if (_linearAds.hasPendingAds())
				return true;
			
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

			if (_sequenceContext == "pre") {
				if (prerollUrlArr && prerollUrlArr.length)
				{
					activeAdTagUrl = prerollUrlArr[0];
					prerollUrlArr.shift();
				}
				else if ( prerollUrl )
				{
					activeAdTagUrl = prerollUrl;
				}
				if (activeAdTagUrl)
				{
					if (_playedPrerollsSingleEntry == 0) {
						// this is the first ad for this round
						//_numEntriesPlayedPreroll++;
						if (!_firstPrerollShown) {
							// if the first preroll was not yet shown, we are 
							// under the prerollStartWith limitation 
							if (!prerollStartWith || _numEntriesPlayedPreroll == prerollStartWith) {
								result = true;
								_firstPrerollShown = true;
								_numEntriesPlayedPreroll = 1;
							}
						}
						else {
							// otherwise, we are under the prerollInterval limitation.
							if (!prerollInterval || _numEntriesPlayedPreroll == prerollInterval) {
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
				
			}
			else if (_sequenceContext == "post")  
			{
				if (postrollUrlArr && postrollUrlArr.length)
				{
					activeAdTagUrl = postrollUrlArr[0];
					postrollUrlArr.shift();
				}
				else if (postrollUrl)
				{
					activeAdTagUrl = postrollUrl;	
				}
				if ( activeAdTagUrl )
				{
					if (_playedPostrollsSingleEntry == 0) {
	//					_numEntriesPlayedPostroll++;
						if (!_firstPostrollShown) {
							if (!postrollStartWith || _numEntriesPlayedPostroll == postrollStartWith) {
								result = true;
								_firstPostrollShown = true;
								_numEntriesPlayedPostroll = 1;
							}
						}
						else {
							if (!postrollInterval || _numEntriesPlayedPostroll == postrollInterval) {
								result = true;
								_numEntriesPlayedPostroll = 1;
							}
						}
					}
					else {
						result = true;
					}
				}
				
			}
			else if (_sequenceContext == "mid" && midrollUrlArr && midrollUrlArr.length)
			{
				activeAdTagUrl = midrollUrlArr[0];
				midrollUrlArr.shift();
				result = true;
			}
			if (persistence) {
				updatePersistentData()
			}
			return result;
		}
		
		//Implementation of the IMidrollPlugin interface
		
		public function hasMidroll () : Boolean
		{
			return midrollUrl;
		}
		
		public function get midrollMediaElement () : MediaElement
		{
			return _linearAds.playingAd;
		}
		
		public function createMidrollElement (midrollUrl : String) : void
		{
			_linearAds.addEventListener( "linearAdReady", redispatchEvent );
			_linearAds.createLinearAd( midrollUrl );
		}
		
		private function redispatchEvent (e : Event) : void
		{
			dispatchEvent( e.clone() );
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
			
			_prerollUrlArr[0] = _prerollUrl;
			if (_linearAds) {
				_linearAds.prerollUrl = value;
			}
		}


		public function get prerollUrl():String {
			return _prerollUrl;
		}
		
		public function set prerollUrlArr(value : Array): void {
			_prerollUrlArr = value;
		}
		
		public function get prerollUrlArr():Array {
			return _prerollUrlArr;
		}


		[Bindable]
		public function set postrollUrl(value:String):void {
			_postrollUrl = value;
			
			_postrollUrlArr.push( _postrollUrl );
		}


		public function get postrollUrl():String {
			return _postrollUrl;
		}

		
		public function set postrollUrlArr(value : Array): void {
			_postrollUrlArr = value;
		}
		
		public function get postrollUrlArr():Array {
			return _postrollUrlArr;
		}
		
		
		[Bindable]
		public function get overlayUrl():String
		{
			return _overlayUrl;
		}
		
		public function set overlayUrl(value:String):void
		{
			_overlayUrl = value;
		}
		
		public function get midrollUrlArr():Array
		{
			return _midrollUrlArr;
		}
		
		public function set midrollUrlArr(value:Array):void
		{
			_midrollUrlArr = value;
		}
		
		[Bindable]
		public function get trackCuePoints():String
		{
			return _trackCuePoints ? "true" : "false";
		}
		
		public function set trackCuePoints(value:String):void
		{
			if (value == "true")
				_trackCuePoints = true;
			else
				_trackCuePoints = false;
		}

		public function get activeAdTagUrl():String
		{
			return _activeAdTagUrl;
		}

		public function set activeAdTagUrl(value:String):void
		{
			_activeAdTagUrl = value;
		}
		
		public function sendLinearTrackEvent(trkName:String):void {
			_linearAds.trackEvent(trkName);
		}
		

	}
}