package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.commands.widget.WidgetAdd;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.controller.AbstractCommand;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.vo.AddThisEvent;
	import com.kaltura.kdpfl.model.vo.CopyVO;
	import com.kaltura.kdpfl.model.vo.EmailVO;
	import com.kaltura.kdpfl.model.vo.EmbedVO;
	import com.kaltura.kdpfl.model.vo.FormVO;
	import com.kaltura.kdpfl.model.vo.SocialSiteVO;
	import com.kaltura.kdpfl.model.vo.ViewVO;
	import com.kaltura.types.KalturaWidgetSecurityType;
	import com.kaltura.vo.KalturaWidget;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AddThisMediator extends Mediator
	{
		public static const EMBED_CODE_UPDATED:String="embedCodeUpdated";
		public static const NAME:String 			= "AddThisMediator";
		public static const ADD_THIS:String			= "addThis";
		public static const ADD_THIS_VIEW:String	= "addThisView";
		public static const ADD_THIS_FORM:String	= "addThisForm";
		public static const ADD_THIS_NETWORK:String	= "addThisNetwork";
		public static const ADD_THIS_CLOSE:String	= "addThisClose";
		public static const ADD_THIS_CHECKBOX:String= "addThisCheckBox";
		public static const INITIALIZE:String		= "initialize";
		public static const UPDATE_SHARE_PROPS:String="updateShareProperties";
		
		public var notificationData:Object			= {};
		public var eventDispatcher:EventDispatcher= new EventDispatcher();
		
		private var _isFirstLoad:Boolean			= true;
		private var _viewVO:ViewVO					= new ViewVO();
		private var _socialSiteVO:SocialSiteVO		= new SocialSiteVO();
		private var _embedVO:EmbedVO				= new EmbedVO();
		private var _copyVO:CopyVO					= new CopyVO();
		private var _emailVO:EmailVO				= new EmailVO();
		private var _formVO:FormVO					= new FormVO();
		
		private var _facade:IFacade;
		private var _uiconfId:String;
		private var _embedCode:String;
		private var _isInFullScreen:Boolean			= false;
		private var _isAddThisOpen:Boolean			= false;
		private var _loadWithNewConfig:Boolean;

		public function AddThisMediator(f:IFacade)
		{	
			_facade		= f;
			super(NAME);
		}
		
		
		
		private function getShareCode():void {
			var kc:Object = _facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var media:Object = _facade.retrieveProxy("mediaProxy");
			var config:Object = _facade.retrieveProxy("configProxy");
			var flashvars:Object = config.getData().flashvars;
			
			if (!_uiconfId)
				_uiconfId = config.vo.kuiConf.id;
			
			// build client instacr
			//if there are more places to use this - make this global 	
			//configuration 
			var kw:KalturaWidget = new KalturaWidget();
			kw.entryId = media["vo"]["entry"]["id"];
			// the uiconf that will be the new widget uiconf
			kw.uiConfId = int(_uiconfId); //kw.uiConfId = int(uiconfId);  
			kw.sourceWidgetId = config["vo"]["kw"]["id"]; //"_1";// 
			
			kw.partnerData = createWidgetPartnerData(flashvars);
			kw.securityType = KalturaWidgetSecurityType.NONE;
			
			//add widget			
			var addWidget:WidgetAdd = new WidgetAdd(kw);
			addWidget.addEventListener(KalturaEvent.COMPLETE, onWidgetComplete);
			addWidget.addEventListener(KalturaEvent.FAILED, onWidgetFailed);
			
			kc.post(addWidget);
		}
		
		
		private function onWidgetFailed(evt:Object):void {
			_loadWithNewConfig = false;
		}
		
		
		private function onWidgetComplete(evt:Object):void {
			var whtml:String = evt["data"]["widgetHTML"];
			
			//add flashvars directly to embed code
			/*
			if(_flashvars)
			whtml = whtml.replace('<param name="flashVars" value=""/>', '<param name="flashVars" value="'+_flashvars+'"/>');
			*/
			_embedCode = whtml;
			
			dispatchNewEmbed()
		}
		
		private function dispatchNewEmbed():void{
			var addThisEvent:AddThisEvent	= new AddThisEvent(EMBED_CODE_UPDATED);
			addThisEvent.data		= XML(_embedCode).toXMLString();
			addThisEvent.codeType	= AddThisEvent.EMBED_CODE_UPDATED;
			
			eventDispatcher.dispatchEvent(addThisEvent);
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
		
		override public function listNotificationInterests():Array{
			var notificationsArray:Array =  [
				NotificationType.MEDIA_READY,
				NotificationType.OPEN_FULL_SCREEN,
				NotificationType.CLOSE_FULL_SCREEN,
				ADD_THIS_FORM,
				ADD_THIS_VIEW,
				ADD_THIS_NETWORK,
				ADD_THIS_CLOSE,
				ADD_THIS_CHECKBOX,
				ADD_THIS
				];
			return notificationsArray;
		}
		
		
		override public function handleNotification(notification:INotification):void{
			this.notificationData	= notification.getBody(); 
			switch (notification.getName()){
				case NotificationType.OPEN_FULL_SCREEN:
					_isInFullScreen		= true;
					
					if(_isAddThisOpen)
						_facade.sendNotification(ADD_THIS_CLOSE);
					
					break;
				case NotificationType.CLOSE_FULL_SCREEN:
					_isInFullScreen		= false;
					break;
				case ADD_THIS_CHECKBOX:
					eventDispatcher.dispatchEvent(new Event(ADD_THIS_CHECKBOX));
					break;
				case ADD_THIS:
					_isAddThisOpen		= true;
					
					if(_isInFullScreen)
						_facade.sendNotification(NotificationType.CLOSE_FULL_SCREEN);
					_facade.sendNotification(NotificationType.ENABLE_GUI,{guiEnabled:false, enableType: "full"});
					eventDispatcher.dispatchEvent(new Event(ADD_THIS));
					break;
				case ADD_THIS_NETWORK:
					_socialSiteVO.shareName	= String(notification.getBody());
					if(_socialSiteVO.shareName == null || _socialSiteVO.shareName == ""){
						trace("AddThisPlugin ERROR:  No social network attached to "+ADD_THIS_NETWORK);
					}else{
						notificationData	= _socialSiteVO;
						eventDispatcher.dispatchEvent(new Event(ADD_THIS_NETWORK));
					}
					break;
				case ADD_THIS_CLOSE:
					_isAddThisOpen		= false;
					eventDispatcher.dispatchEvent(new Event(ADD_THIS_CLOSE));
					_facade.sendNotification(NotificationType.ENABLE_GUI,{guiEnabled:true, enableType: "full"});
					break;
				case ADD_THIS_VIEW:
					//display view
					_viewVO.view			= String(notification.getBody()) || null;
					
					if(_viewVO.view == null || _viewVO.view == ""){
						trace("AddThisPlugin ERROR:  No view ID attached to the notification "+ADD_THIS_VIEW);
					}else{
						notificationData	= _viewVO;
						eventDispatcher.dispatchEvent(new Event(ADD_THIS_VIEW));
					}
					break;
				case ADD_THIS_FORM:
					var data:Array			= String(notification.getBody()).split("?");
					trace("SUBMIT FORM???? 	"+data);
					//this should be the id
					_formVO.id				= data[0] || null;
					_formVO.params			= data[1] || null;
					
					if(_formVO.id 	== null || _formVO.id == ""){
						trace("AddThisPlugin ERROR:  No form ID found attached to the notification	"+ADD_THIS_FORM);
					}else{
						notificationData	= _formVO;
						eventDispatcher.dispatchEvent(new Event(ADD_THIS_FORM));
					}
					break;
				case NotificationType.MEDIA_READY:
					if(_isFirstLoad){//init plugin
						eventDispatcher.dispatchEvent(new Event(INITIALIZE));
						_isFirstLoad	= false;
					}
					getShareCode();
					//update sharing properties
					eventDispatcher.dispatchEvent(new Event(NotificationType.MEDIA_READY));
					break;
				default:
					break;
			}
		}
	}
}