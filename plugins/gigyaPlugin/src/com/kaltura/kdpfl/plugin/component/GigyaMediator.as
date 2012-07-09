package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.commands.widget.WidgetAdd;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.types.KalturaWidgetSecurityType;
	import com.kaltura.vo.KalturaWidget;
	
	import flash.display.DisplayObject;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * Mediator for Gigya plugin 
	 */	
	public class GigyaMediator extends Mediator {
		
		/**
		 * Mediator name 
		 */		
		public static const NAME:String = "gigyaMediator";
		public var lang:String;
		
		// pass the module id to the Share menu 
		private static const MODULE_ID:String = 'cfg';
		
		private var _embedCode:String;
		private var _currentEntry:String = "";

		// initialize the configuration object 
		private var _cfg:Object = {};
		
		private var _shareEmailSubject:String = "";
		private var _shareEmailBody:String = "";
		private var _gigyaPartnerKey:String = "";
		private var _title:String = "";
		private var _uiconfId:String = "";
		private var _loadWithNewConfig:Boolean = false;
		private var _height:Number;
		private var _width:Number;
		private var _defaultBookmarkURL:String;
		
		private var _flashvars : Object;
		
		/**
		 * The plugin is currently running inside appstudio 
		 */		
		private var _isInAps:Boolean;


		/**
		 * Constructor. 
		 * @param viewComponent	the view component for this mediator
		 */		
		public function GigyaMediator(viewComponent:Object = null) {
			super(NAME, viewComponent);
			var config:Object = facade.retrieveProxy("configProxy");
			var flashvars:Object = config.getData().flashvars;
			if (flashvars.isInAppstudio)
				_isInAps = true;
		}


		public function get defaultBookmarkURL():String
		{
			return _defaultBookmarkURL;
		}

		public function set defaultBookmarkURL(value:String):void
		{
			_defaultBookmarkURL = value;
		}

		/**
		 * @inheritDocs 
		 */		
		override public function listNotificationInterests():Array {
			return ["doGigya", "closeGigya", NotificationType.HAS_OPENED_FULL_SCREEN];
		}


		/**
		 * Create the widget partner data from flashvars
		 * The pd flashvars contains a comma separated list of variables names that should be
		 * stored using the widget partner data.
		 * each variable name can be using dot notation in which case we parse it by stepping into
		 * the flashvars object tree
		 * @param flashvars the config flashvars
		 * @return
		 *
		 */
		private function createWidgetPartnerData(flashvars:Object):String {
			var pd:String = flashvars['pd'];
			if (pd) {
				var xml:XML = new XML('<uiVars/>');

				var pdVars:Array = pd.split(',');
				for each (var pdVar:String in pdVars) {
					var subParams:Array = pdVar.split(".");
					var root:* = flashvars;
					for (var i:int = 0; root && i < subParams.length - 1; ++i) {
						root = root[subParams[i]];
					}
					if (root) {
						var pdValue:String = root[subParams[i]];
						var varXML:XML = new XML('<var/>');
						varXML.@key = pdVar;
						varXML.@value = pdValue;
						xml.appendChild(varXML);
					}
				}

				return new XML("<xml/>").appendChild(xml);
			}

			return null;
		}


		private function _getShareCode(kc:Object):void {
			var media:Object = facade.retrieveProxy("mediaProxy");
			var config:Object = facade.retrieveProxy("configProxy");
			_flashvars = config.getData().flashvars;
			if (!uiconfId)
				uiconfId = config.vo.flashvars.uiConfId;

			// build client instacr
			//if there are more places to use this - make this global 	
			//configuration 
			var kw:KalturaWidget = new KalturaWidget();
			kw.entryId = media["vo"]["entry"]["id"];
			// the uiconf that will be the new widget uiconf
			kw.uiConfId = int(uiconfId); //kw.uiConfId = int(uiconfId);  
			kw.sourceWidgetId = config["vo"]["kw"]["id"]; //"_1";// 
			kw.partnerData = createWidgetPartnerData(_flashvars);
			kw.securityType = KalturaWidgetSecurityType.NONE;

			//add widget			
			var addWidget:WidgetAdd = new WidgetAdd(kw);
			addWidget.addEventListener(KalturaEvent.COMPLETE, onWidgetComplete);
			addWidget.addEventListener(KalturaEvent.FAILED, onWidgetFailed);
			kc.post(addWidget);
		}


		private function onWidgetComplete(evt:Object):void {
			var whtml:String = evt["data"]["widgetHTML"];
			_embedCode = whtml;
			_createGigyaConfig();
			if (_loadWithNewConfig) {
				_loadWithNewConfig = false;
				(view as Gigya).loadGigya(_cfg, MODULE_ID);
			}
		}


		private function onWidgetFailed(evt:Object):void {
			_loadWithNewConfig = false;
			facade.sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
			
		}

		/**
		 * @inheritDocs 
		 */
		override public function handleNotification(note:INotification):void {
			var kc:Object = facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var media:Object = facade.retrieveProxy("mediaProxy");
			var entry:String = media["vo"]["entry"]["id"];
			switch (note.getName()) {
				
				
				case "closeGigya":
					closeGigya();
					break;
				case "doGigya":
					if (_isInAps)
						break;

					facade.sendNotification("doPause");
					facade.sendNotification("closeFullScreen");
					facade.sendNotification("enableGui", {guiEnabled: false, enableType: "full"});
					if (entry != _currentEntry) {
						_loadWithNewConfig = true;
						_currentEntry = entry;
						_getShareCode(kc);
					}
					else {
						(view as Gigya).showGigya();
					}
					break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					if ((view as Gigya).gigyaVisible)
					{
						closeGigya();
					}
					break;

			}
		}

		private function closeGigya():void
		{
			(view as Gigya).hideGigya();
			//re-enable the UI 
			facade.sendNotification( NotificationType.ENABLE_GUI ,{guiEnabled: true, enableType: EnableType.FULL} );
		}
		
		private function _createGigyaConfig():void {
			var layout:Object = facade.retrieveProxy("layoutProxy");
			var media:Object = facade.retrieveProxy("mediaProxy");
			// Step 2 - Set up security to allow your app to interact with the Share menu 
			Security.allowDomain("cdn.gigya.com");
			Security.allowInsecureDomain("cdn.gigya.com");

			// Step 4 - This code assigns the configurations you set in our site to the Share menu configuration object 
			_cfg['width'] = (viewComponent as DisplayObject).parent.parent.width;
			_cfg['height'] = (viewComponent as DisplayObject).parent.parent.height;
			if(lang)
				_cfg['lang'] = lang;
			
			_cfg['UIConfig'] = '<config><display showEmail="true" showBookmark="true" /></body></config>';
			// so the link would be in the front page of facebook 
			_cfg['useFacebookMystuff']='false';
			
			try{
				_cfg['facebookPreviewURL3'] = media["vo"]["entry"]["thumbnailUrl"];
			}catch (e:Error)
			{
				trace(e.message);
			}
			
			var gigyaUi:String;
			try {
				gigyaUi = layout["vo"]["layoutXML"]["extraData"]["GigyaUI"]["config"]["0"];
			}
			catch (e:Error) {
				trace("There was no GigyaUI on the extraData xml !!! Placing the default");
			}
			_cfg['UIConfig'] = gigyaUi;
			_cfg['emailSubject'] = _shareEmailSubject;
			
			//if(_title)
			_cfg['widgetTitle'] = media["vo"]["entry"]["name"] ? media["vo"]["entry"]["name"] : "";
			
			_cfg['emailBody'] = _shareEmailBody;
			_cfg['partner'] = _gigyaPartnerKey;
			// Step 5 - Set up the content to be posted 
			_cfg['defaultContent'] = _embedCode;
		//	_cfg['facebookContent'] = _embedCode.replace(/http/g,"https");
			if(_defaultBookmarkURL)
				_cfg['defaultBookmarkURL']=_defaultBookmarkURL;

			// Step 5 - Set up the event listeners
			_cfg['onLoad'] = function(eventObj:Object):void {
			}

			_cfg['onClose'] = function(eventObj:Object):void {
				closeGigya();
			}

		}


		/**
		 * plugin width 
		 */		
		public function set width(value:Number):void {
			_width = value;
			_cfg['width'] = _width;

		}

		/**
		 * plugin height 
		 */
		public function set height(value:Number):void {
			_height = value;
			_cfg['height'] = _height;
		}


		/**
		 * plugin view component 
		 */		
		public function get view():DisplayObject {
			return viewComponent as DisplayObject;
		}


		/**
		 * subject of sent email 
		 */		
		public function set shareEmailSubject(value:String):void {
			if (_shareEmailSubject == "")
				_shareEmailSubject = value;
		}


		/**
		 * content of sent email
		 */		
		public function set shareEmailBody(value:String):void {
			if (_shareEmailBody == "")
				_shareEmailBody = value;
		}

		/**
		 * Gigya partner id
		 */
		public function set gigyaPartnerKey(value:String):void {
			if (_gigyaPartnerKey == "")
				_gigyaPartnerKey = value;
		}
		
		/**
		 * movie name to title 
		 */
		public function set title(value:String):void {
			if (_title == "")
				_title = value;
		}


		/**
		 * @private
		 */			
		public function set uiconfId(value:String):void {
			if (_uiconfId == "")
				_uiconfId = value;
		}


		/**
		 * the uiconf that will be the new widget uiconf
		 */
		public function get uiconfId():String {
			return _uiconfId;
		}
	}
}