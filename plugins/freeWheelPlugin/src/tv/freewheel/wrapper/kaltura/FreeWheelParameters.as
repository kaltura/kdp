package tv.freewheel.wrapper.kaltura
{
	import com.kaltura.kdpfl.model.vo.ConfigVO;
	import com.kaltura.types.KalturaAdProtocolType;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.types.KalturaCuePointType;
	import com.kaltura.vo.KalturaAdCuePoint;
	import com.serialization.json.JSON;
	import com.yahoo.astra.fl.charts.skins.CircleSkin;
	
	import flash.external.ExternalInterface;
	
	import org.osmf.logging.Log;
	
	import tv.freewheel.logging.Logger;
	import tv.freewheel.renderer.util.ParameterParserUtil;
	import tv.freewheel.renderer.util.ParameterSelectionUtil;
	import tv.freewheel.renderer.util.StringUtil;
	
	public class FreeWheelParameters
	{
		// the following objects are sorted by priority ranks
		//private var jsParams:Object = {};
		// flashvars:Object;
		//private var entryMeta:Object = {};
		private var _entryMetadata:Object = {};
		public var uiConf:Object = {};
		private var defaultValues:Object = {};
		
		private var paramsTable:Array;
		public var errors:Array;
		
		private var logger:Logger;
		// Parameter names
		public static const PARAM_ADMANAGER_URL:String = 'adManagerUrl';
		public static const PARAM_SERVER_URL:String = 'serverUrl';
		public static const PARAM_NETWORK_ID:String = "networkId";
		public static const PARAM_PLAYER_PROFILE:String = 'playerProfile';
		public static const PARAM_VIDEO_ASSET_ID:String = 'videoAssetId';
		public static const PARAM_VIDEO_ASSET_ID_TYPE:String = 'videoAssetIdType';
		public static const PARAM_VIDEO_ASSET_FALLBACK_ID:String = 'videoAssetFallbackId';
		public static const PARAM_VIDEO_ASSET_NETWORK_ID:String = "videoAssetNetworkId";
		public static const PARAM_SITE_SECTION_ID:String = "siteSectionId";
		public static const PARAM_SITE_SECTION_ID_TYPE:String = "siteSectionIdType";
		public static const PARAM_SITE_SECTION_FALLBACK_ID:String = "siteSectionFallbackId";
		public static const PARAM_SITE_SECTION_NETWORK_ID:String = "siteSectionNetworkId";
		public static const PARAM_RENDERER_CONFIGURAION:String = "rendererConfiguration";
		public static const PARAM_CAPABILITIES:String = "capabilities";
		public static const PARAM_KEY_VALUES:String = "keyValues";
		public static const PARAM_OVERRIDE_PARAMETERS:String = "overrideParameters";
		public static const PARAM_EXTENSIONS:String = 'extensions';
		public static const PARAM_REPLAY_TIME_POSITION_CLASSES:String = 'replayTimePositionClasses';
	//	public static const PARAM_CUEPOINT_METADATA:String = "cuePointMetadataFieldName";
		public static const PARAM_USER_PAUSE_NOTIFICATION_NAME:String = 'userPauseNotificationName';
		public static const PARAM_CUSTOM_VISITOR:String = "customVisitor";
		
		// Parameters
		private var _adManagerUrl:String = null;
		private var _serverUrl:String = null;
		private var _networkId:Number = 0;
		private var _playerProfile:String = null;
		private var _videoAssetId:String = null;
		private var _videoAssetIdType:uint = 0;
		private var _videoAssetFallbackId:Number = 0;
		private var _videoAssetNetworkId:Number = 0;
		private var _siteSectionId:String = null;
		private var _siteSectionIdType:uint = 0;
		private var _siteSectionFallbackId:Number = 0;
		private var _siteSectionNetworkId:Number = 0;
		private var _rendererConfiguration:String = null;
		private var _capabilities:Object = {};
		private var _keyValues:Array = [];
		private var _overrideParameters:Object = {};
		private var _extensions:Object = {};
	//	private var _cuePointMetadataFieldName:String = '';
		private var _cuePoints:Object = {};
		
		private var _cuePointsArray:Array;
		
		private var _replayTimePositionClasses:Array = [];
		private var _userPauseNotificationName:String;
		private var _customVisitor:String = null;
		
		
		public function FreeWheelParameters(flashvars:Object=null, entryMetadata:Object=null)
		{
			this.logger = Logger.getSimpleLogger("KDPPlugin.Parameters ");
			this.logger.debug('new FreeWheelParameters()');
			this.defaultValues = {
				PARAM_ADMANAGER_URL: null,
				PARAM_SERVER_URL: null,
				PARAM_NETWORK_ID: 0,
				PARAM_PLAYER_PROFILE: null,
				PARAM_VIDEO_ASSET_ID: null,
				PARAM_VIDEO_ASSET_ID_TYPE: 0,
				PARAM_VIDEO_ASSET_FALLBACK_ID: 0,
				PARAM_VIDEO_ASSET_NETWORK_ID: 0,
				PARAM_SITE_SECTION_ID: null,
				PARAM_SITE_SECTION_ID_TYPE: 0,
				PARAM_SITE_SECTION_FALLBACK_ID: 0,
				PARAM_SITE_SECTION_NETWORK_ID: 0,
				PARAM_RENDERER_CONFIGURAION: null,
				PARAM_CAPABILITIES: {},
				PARAM_KEY_VALUES: [],
				PARAM_OVERRIDE_PARAMETERS: {},
				PARAM_EXTENSIONS: {},
				PARAM_CUEPOINT_METADATA: '',
				PARAM_REPLAY_TIME_POSITION_CLASSES: ['midroll', 'overlay'],
				PARAM_USER_PAUSE_NOTIFICATION_NAME: 'userClickedPauseNotification'
			};
			
			this.logger.debug('flashvars: ' + StringUtil.objectToString(flashvars));
			
			if (entryMetadata){
				this._entryMetadata = entryMetadata;
			}
			
			this.logger.debug('entryMetadata: ' + StringUtil.objectToString(this.entryMeta));
			this.paramsTable = [this.jsParams, flashvars || new Object(), this.entryMeta, this.uiConf, this.defaultValues];
			this.parseParameters();
		}
		
		private function get jsParams():Object{
			if(ExternalInterface.available) {
				ExternalInterface.marshallExceptions = true;
				try {
					return ExternalInterface.call("fw_config");
				} 
				catch(e:Error) {
					this.logger.warn("call fw_config js fail:" + e.message);
				}
			}
			return {};
		}
		
		private function get entryMeta():Object{
			var entryMeta:Object = new Object();
			if (this._entryMetadata){
				for (var k:String in this._entryMetadata){
					entryMeta[k.charAt(0).toLowerCase() + k.substring(1)] = this._entryMetadata[k];
				}
			}
			return entryMeta;
		}
		
		public function set adManagerUrl(v:*):void{
			this._adManagerUrl = (v as String) || null;
		}
		public function set serverUrl(v:*):void{
			this._serverUrl = (v as String) || null;
		}
		public function set networkId(v:*):void{
			this._networkId = ParameterParserUtil.parseNumber(v) || 0;
		}
		public function set playerProfile(v:*):void{
			this._playerProfile = (v as String) || null;
		}
		public function set videoAssetId(v:*):void{
			this._videoAssetId = (v as String) || null;
		}
		public function set videoAssetIdType(v:*):void{
			this._videoAssetIdType = ParameterParserUtil.parseInt(v) || 0;
		}
		public function set videoAssetFallbackId(v:*):void{
			this._videoAssetFallbackId = ParameterParserUtil.parseNumber(v) || 0;
		}
		public function set videoAssetNetworkId(v:*):void{
			this._videoAssetNetworkId = ParameterParserUtil.parseNumber(v) || 0;
		}
		public function set siteSectionId(v:*):void{
			this._siteSectionId = (v as String) || null;
		}
		public function set siteSectionIdType(v:*):void{
			this._siteSectionIdType = ParameterParserUtil.parseInt(v) || 0;
		}
		public function set siteSectionFallbackId(v:*):void{
			this._siteSectionFallbackId = ParameterParserUtil.parseNumber(v) || 0;
		}
		public function set siteSectionNetworkId(v:*):void{
			this._siteSectionNetworkId = ParameterParserUtil.parseNumber(v) || 0;
		}
		public function set rendererConfiguration(v:*):void{
			this._rendererConfiguration = (v as String) || null;
		}
		public function set userPauseNotificationName(v:*):void{
			this._userPauseNotificationName = (v as String) || 'userClickedPauseNotification';
		}
		public function set customVisitor(v:*):void{
			this._customVisitor = (v as String) || null;
		}
		/*public function set cuePointMetadataFieldName(v:*):void{
			this._cuePointMetadataFieldName = (v as String) || '';
			if (!StringUtil.isBlank(this._cuePointMetadataFieldName)){
				var cuePointsString:String = ParameterSelectionUtil.parseString(this._cuePointMetadataFieldName, this.paramsTable);
				this.logger.debug(this._cuePointMetadataFieldName + ':' + cuePointsString);
				try{
					this._cuePoints = JSON.deserialize(cuePointsString);
				}
				catch (e:Error){
					Logger.current.warn('Failed to parse ' + this._cuePointMetadataFieldName);
					this._cuePoints = {};
				}
			}
			else{
				this._cuePoints = {};
			}
		}*/
		
		public function set capabilities(v:*):void{
			if (v is String)
				this._capabilities = parseStringAsObject(v);
			else if (v != null)
				this._capabilities = v as Object || {};
			else
				this._capabilities = {};
		}
		public function set keyValues(v:*):void{
			if (v is String)
				this._keyValues = this.parseStringAsArray(v);
			else if (v != null)
				this._keyValues = v as Array || [];
			else
				this._keyValues = [];
		}
		public function set overrideParameters(v:*):void{
			if (v is String)
				this._overrideParameters = this.parseStringAsObject(v);
			else if (v != null)
				this._overrideParameters = v as Object || {};
			else
				this._overrideParameters = {};
		}
		public function set extensions(v:*):void{
			if (v is String)
				this._extensions = this.parseStringAsObject(v);
			else if (v != null)
				this._extensions = v as Object || {};
			else
				this._extensions = {};
		}
		public function set replayTimePositionClasses(v:*):void{
			if (v is String)
				this._replayTimePositionClasses = ParameterParserUtil.parseArray(v as String);
			else if (v != null)
				this._replayTimePositionClasses = v as Array || [];
			else
				this._replayTimePositionClasses = [];
		}
		
		public function parseParameters(flashvars:Object = null, entryMetadata:Object = null, entryCuePoints:Object = null):void{
			this.logger.debug('flashvars: ' + StringUtil.objectToString(flashvars));
			if (entryMetadata){
				this._entryMetadata = entryMetadata;
			}
			if (entryCuePoints){
				this._cuePoints = transformCuePointsMap(entryCuePoints);
			}
			this.logger.debug('entryMetadata: ' + StringUtil.objectToString(this.entryMeta));
			this.paramsTable = [this.jsParams, flashvars || new Object(), this.entryMeta, this.uiConf, this.defaultValues];
			
			this.adManagerUrl = ParameterSelectionUtil.parseString(PARAM_ADMANAGER_URL, this.paramsTable);
			this.serverUrl = ParameterSelectionUtil.parseString(PARAM_SERVER_URL, this.paramsTable);
			this.networkId = ParameterSelectionUtil.parseNumber(PARAM_NETWORK_ID, this.paramsTable);
			this.playerProfile = ParameterSelectionUtil.parseString(PARAM_PLAYER_PROFILE, this.paramsTable);
			this.videoAssetId = ParameterSelectionUtil.parseString(PARAM_VIDEO_ASSET_ID, this.paramsTable);
			this.videoAssetIdType = ParameterSelectionUtil.parseInt(PARAM_VIDEO_ASSET_ID_TYPE, this.paramsTable);
			this.videoAssetFallbackId = ParameterSelectionUtil.parseNumber(PARAM_VIDEO_ASSET_FALLBACK_ID, this.paramsTable);
			this.videoAssetNetworkId = ParameterSelectionUtil.parseNumber(PARAM_VIDEO_ASSET_NETWORK_ID, this.paramsTable);
			this.siteSectionId = ParameterSelectionUtil.parseString(PARAM_SITE_SECTION_ID, this.paramsTable);
			this.siteSectionIdType = ParameterSelectionUtil.parseInt(PARAM_SITE_SECTION_ID_TYPE, this.paramsTable);
			this.siteSectionFallbackId = ParameterSelectionUtil.parseNumber(PARAM_SITE_SECTION_FALLBACK_ID, this.paramsTable);
			this.siteSectionNetworkId = ParameterSelectionUtil.parseNumber(PARAM_SITE_SECTION_NETWORK_ID, this.paramsTable);
			this.rendererConfiguration = ParameterSelectionUtil.parseString(PARAM_RENDERER_CONFIGURAION, this.paramsTable);
			//this.cuePointMetadataFieldName = ParameterSelectionUtil.parseString(PARAM_CUEPOINT_METADATA, this.paramsTable);
			this.capabilities = ParameterSelectionUtil.parseObject(PARAM_CAPABILITIES, this.paramsTable);
			this.keyValues = ParameterSelectionUtil.parseObject(PARAM_KEY_VALUES, this.paramsTable);
			this.overrideParameters = ParameterSelectionUtil.parseObject(PARAM_OVERRIDE_PARAMETERS, this.paramsTable);
			this.extensions = ParameterSelectionUtil.parseObject(PARAM_EXTENSIONS, this.paramsTable);
			this.replayTimePositionClasses = ParameterSelectionUtil.parseObject(PARAM_REPLAY_TIME_POSITION_CLASSES, this.paramsTable);
			this.userPauseNotificationName = ParameterSelectionUtil.parseString(PARAM_USER_PAUSE_NOTIFICATION_NAME, this.paramsTable);
			this.customVisitor = ParameterSelectionUtil.parseString(PARAM_CUSTOM_VISITOR, this.paramsTable);
			for (var i:int = 0; i < this.replayTimePositionClasses.length; i++){
				this.replayTimePositionClasses[i] = this.replayTimePositionClasses[i].toLowerCase();
			}
		}
		
		/**
		 * trnasform the cuePointsMap 
		 * from: key=intime, value= cue points array
		 * to: key=cue point id, value = cue point
		 * */
		private function transformCuePointsMap(map:Object):Object {
			var transformedMap:Object = new Object();
			for (var intime:String in map) {
				var cpArr:Array = map[intime] as Array;
				for (var i:int = 0; i<cpArr.length; i++) {
					var curCP:KalturaAdCuePoint = cpArr[i] as KalturaAdCuePoint;
					if (curCP && curCP.protocolType == KalturaAdProtocolType.CUSTOM)
						transformedMap[curCP.id] = curCP;
				}
			}
			return transformedMap;
		}
		
		public function validate():Boolean{
			this.errors = new Array();
			if (StringUtil.isBlank(this.adManagerUrl)){
				errors.push("adManagerUrl is null.");
			}
			if (StringUtil.isBlank(this.serverUrl)){
				errors.push('serverUrl is null.');
			}
			if (this.networkId == 0){
				errors.push('networkId is null.');
			}
			if (StringUtil.isBlank(this.videoAssetId)){
				errors.push('videoAssetId is null.');
			}
			if (StringUtil.isBlank(this.siteSectionId)){
				errors.push('siteSectionId is null.');
			}
			return errors.length == 0;
		}
		
		private function parseStringAsObject(str:String):Object{
			var ret:Object = new Object();
			if (StringUtil.isBlank(str))
				return ret;
			for each (var kv:String in str.split('&')){
				var temp:Array = kv.split('=');
				if (temp.length == 2){
					ret[temp[0]] = temp[1];
				}
			}
			return ret;
		}
		
		private function parseStringAsArray(str:String):Array{
			var ret:Array = new Array();
			if (StringUtil.isBlank(str))
				return ret;
			for each (var kv:String in str.split('&')){
				var temp:Array = kv.split('=');
				if (temp.length == 2){
					var obj:Object = new Object();
					obj[temp[0]] = temp[1];
					ret.push(obj);
				}
			}
			return ret;
		}
		
		public function toString():String{
			return 'adManagerUrl: ' + _adManagerUrl + ' | ' +
				'serverUrl: ' + _serverUrl + ' | ' +
				'networkId: ' + _networkId + ' | ' +
				'playerProfile: ' + _playerProfile + ' | ' +
				'videoAssetId: ' + _videoAssetId + ' | ' +
				'videoAssetIdType: ' + _videoAssetIdType + ' | ' +
				'videoAssetFallbackId: ' + _videoAssetFallbackId + ' | ' +
				'videoAssetNetworkId: ' + _videoAssetNetworkId + ' | ' +
				'siteSectionId: ' + _siteSectionId + ' | ' +
				'siteSectionIdType: ' + _siteSectionIdType + ' | ' +
				'siteSectionFallbackId: ' + _siteSectionFallbackId + ' | ' +
				'siteSectionNetworkId: ' + _siteSectionNetworkId + ' | ' +
				'rendererConfiguration: ' + _rendererConfiguration + ' | ' +
				'capabilities: ' + StringUtil.objectToString(_capabilities) + ' | ' +
				'keyValues: ' + StringUtil.objectToString(_keyValues) + ' | ' +
				'overrideParameters: ' + StringUtil.objectToString(_overrideParameters) + ' | ' +
				'extensions: ' + StringUtil.objectToString(_extensions) + ' | ' +
				//'cuePointMetadataFieldName: ' + _cuePointMetadataFieldName + ' | ' +
				'cuePoints: ' + StringUtil.objectToString(_cuePoints) + ' | ' +
				'replayTimePositionClasses: ' + _replayTimePositionClasses;
		}
		
		public function get adManagerUrl():String{
			return this._adManagerUrl;
		}
		public function get serverUrl():String{
			return this._serverUrl;
		}
		public function get networkId():Number{
			return this._networkId;
		}
		public function get playerProfile():String{
			return this._playerProfile;
		}
		public function get videoAssetId():String{
			return this._videoAssetId;
		}
		public function get videoAssetIdType():uint{
			return this._videoAssetIdType;
		}
		public function get videoAssetFallbackId():Number{
			return this._videoAssetFallbackId;
		}
		public function get videoAssetNetworkId():Number{
			return this._videoAssetNetworkId;
		}
		public function get siteSectionId():String{
			return this._siteSectionId;
		}
		public function get siteSectionIdType():uint{
			return this._siteSectionIdType;
		}
		public function get siteSectionFallbackId():Number{
			return this._siteSectionFallbackId;
		}
		public function get siteSectionNetworkId():Number{
			return this._siteSectionNetworkId;
		}
		public function get rendererConfiguration():String{
			return this._rendererConfiguration;
		}
		public function get capabilities():Object{
			return this._capabilities;
		}
		public function get keyValues():Array{
			return this._keyValues;
		}
		public function get overrideParameters():Object{
			return this._overrideParameters;
		}
		public function get extensions():Object{
			return this._extensions;
		}
		/*public function get cuePointMetadataFieldName():String{
			return this._cuePointMetadataFieldName;
		}*/
		public function get cuePoints():Object{
			return this._cuePoints;
		}
		public function get replayTimePositionClasses():Array{
			return this._replayTimePositionClasses;
		}
		public function get userPauseNotificationName():String{
			return this._userPauseNotificationName;
		}
		public function get customVisitor():String{
			return this._customVisitor;
		}
	}
}
