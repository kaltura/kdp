package
{
	import com.addthis.share.ShareAPI;
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.widget.WidgetAdd;
	import com.kaltura.delegates.widget.WidgetAddDelegate;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.controls.KButton;
	import com.kaltura.kdpfl.view.controls.KLabel;
	import com.kaltura.types.KalturaWidgetSecurityType;
	import com.kaltura.vo.KalturaWidget;
	import com.yahoo.astra.layout.modes.HorizontalAlignment;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class kalturaSharePlugin extends KVBox implements IPluginFactory, IPlugin 
	{
		
		
		public var servicePath:String = "/index.php/extwidget/openGraph/wid/";
		
		public var ar:AssetsRefferencer;
		public var pubid:String;
		
		public var linkLabel:String = "Email or IM this to your friends:";
		public var embedLabel:String = "Copy this code to your website or blog:";
		public var networksLabel:String = "Post this video to one of these sites:";
		public var error:String = "Error. please try again later";
		
		public var copyLabel:String = "Copy to Clipboard";
		private var _addThisAPI:ShareAPI;
		
		
		private var _refferencer:Object = new Object();
		[Bindable]
		public var via:String = "Kaltura";
		
		public var facebookLabel:String = "Facebook";
		public var diggLabel:String = "Digg";
		public var LinkedInLabel:String = "LinkedIn  ";
		public var WordpressLabel:String = "Wordpress";
		public var twitterLabel:String = "Twitter     ";
		public var deliciousLabel:String = "Delicious";
		
		public var landingPagePrefix:String = "" ;
		
		public var copyButtonWidth:Number = 110;
		public var copyButtonHeight:Number = 18;
		public var padding:Number = 10;
		public var showNetworks:Boolean = true;
		public var showEmbed:Boolean = true;
		public var showLink:Boolean = true;
		public var showTwitter:Boolean = true;
		public var showFacebook:Boolean = true;
		public var showLinkedIn:Boolean = true;
		public var showWordpress:Boolean = true;
		
		[Bindable]
		public var directLink:String;
		[Bindable]
		public var directEmbed:String;
		
		public var wasPlayerPlaying:Boolean;
		
		public var widthAttribute:String="";
		public var heightAttribute:String="";
		
		private var facade:IFacade;
		private var advancedShareMediator:AdvancedShareMediator;
		
		public var customSnippetBefore:String;
		public var entryId:String;
		public var widgetId:String;
		public var uiconfId:String;
		private var _hadError:Boolean;
		public var kc:KalturaClient;
		
		public var customSnippetAfter:String;
		
		/**
		 * Unique identifier field name if it is metadata 
		 */
		public var uuid:String ;
		
		
		
		public function kalturaSharePlugin()
		{
		}
		/**
		 * @inheritDoc	
		 **/
		public function create(pluginName:String = null):IPlugin 
		{
			return this;
		}
		public function generate():void
		{
			if(!uiconfId)
			{
				var config:Object = facade.retrieveProxy("configProxy");
				uiconfId = config.vo.flashvars.uiConfId;
			}
			
			
			
			
			//skip 2nd addWidget for the same entry
			if(entryId && entryId == advancedShareMediator.entry.id && !_hadError )
			{
				return;
			}
			entryId = advancedShareMediator.entry.id;
			getWidget(entryId , uiconfId);
			return;
		}
		
		
		private function getWidget(entry_id:String,player_id:String):void
		{
			var kw:KalturaWidget = new KalturaWidget();
			
			var media:Object = facade.retrieveProxy("mediaProxy");
			var config:Object = facade.retrieveProxy("configProxy");
			
			var fv:Object = config.getData().flashvars;
			
			var basePath:String =  config.vo.flashvars.httpProtocol + config.vo.flashvars.host
			basePath+=servicePath;
			
			landingPagePrefix = basePath;
			
			kw.entryId = entry_id;
			// the uiconf that will be the new widget uiconf
			kw.uiConfId = int(player_id); //kw.uiConfId = int(uiconfId); 
			try
			{
				kw.sourceWidgetId = config["vo"]["kw"]["id"]; //"_1";// 
			} 
			catch(error:Error) 
			{
			}
			try
			{
				kw.partnerData = createWidgetPartnerData(fv);
			} 
			catch(error:Error) 
			{
				
			}
			kw.securityType = KalturaWidgetSecurityType.NONE;
			
			//add widget			
			var addWidget:WidgetAdd = new WidgetAdd(kw);
			addWidget.addEventListener(KalturaEvent.COMPLETE, onWidgetComplete);
			addWidget.addEventListener(KalturaEvent.FAILED, onWidgetFailed);
			kc.post(addWidget);
		}
		
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
		
		private var widget:KalturaWidget
		
		private function onWidgetComplete(evt:Object):void {
			//retrive 
			_hadError = false;
			widget = evt.data as KalturaWidget;
			
			widgetId = widget.id; //evt.data.object.idvar widthHeightString:String = ""
			
			if(widthAttribute)
			{
				widthHeightString+="&width="+widthAttribute;
			}
			if(heightAttribute)
			{
				widthHeightString+="&height="+heightAttribute;
			}
			
			var widthHeightString:String = ""
			
			if(widthAttribute)
			{
				widthHeightString+="&width="+widthAttribute;
			}
			if(heightAttribute)
			{
				widthHeightString+="&height="+heightAttribute;
			}
			
			var whtml:String = evt["data"]["widgetHTML"];
			
			directEmbed =  whtml;
			if(_refferencer.hasOwnProperty("directEmbed"))
				(_refferencer["directEmbed"] as KLabel).text = directEmbed;
			
			
			
			
			
			
			
			if(landingPagePrefix)
				directLink = landingPagePrefix + widgetId ; 
			 else
				directLink = "Plugin is not configured correctly. Generator page prefix is not set"; 
			
			
			if(_refferencer.hasOwnProperty("directLink"))
				(_refferencer["directLink"] as KLabel).text = directLink;

		}
		
		
		private function onWidgetFailed(evt:Object):void {
			_hadError = true;
			if(_refferencer.hasOwnProperty("directEmbed"))
				(_refferencer["directEmbed"] as KLabel).text = error;
		
			if(_refferencer.hasOwnProperty("directLink"))
				(_refferencer["directLink"] as KLabel).text = error;
			
			
		}

		public function initializePlugin(facade:IFacade):void 
		{
			
			_addThisAPI		= new ShareAPI(pubid);
			visible = false;
			 advancedShareMediator = new AdvancedShareMediator(this);
			facade.registerMediator(advancedShareMediator);
			horizontalAlign = HorizontalAlignment.CENTER;
			verticalAlign = VerticalAlignment.TOP;
			this.facade =  facade;
			advancedShareMediator.init();
		}
		
		
		
		/**
		 * set the given style to all visual parts
		 **/
		override public function setSkin(styleName:String, setSkinSize:Boolean = false):void 
		{
			setStyle("skin", gray_bg);
		}

		
		private function buildUi():void
		{
			
			//build UI once 
			uiReady = true;
			//close button 
			var headerHbox:KHBox = new KHBox();
			headerHbox.horizontalAlign = HorizontalAlignment.RIGHT;
			headerHbox.name = "headerHbox";
			headerHbox.paddingLeft = paddingLeft;
			headerHbox.verticalAlign = "middle";
			headerHbox.height = 40;
			headerHbox.width = width - paddingLeft;
			addChild(headerHbox);
			
			var btn:KButton;
			btn = new KButton();
			btn.name = "closeBtn";
			btn.height = 15;
			btn.minHeight = 15;
			btn.width = 15;
			btn.minWidth = 15;
			btn.addEventListener(MouseEvent.CLICK, onClose);
			btn.setSkin('closeBtn');	
			headerHbox.addChild(btn);
			
			//link
			if (showLink)
			{
				var linkBox:KVBox = buildOneBox("directLink",linkLabel );
				addChild(linkBox);
			}
			
			if (showEmbed)
			{
				var embedBox:KVBox = buildOneBox("directEmbed",embedLabel );
				addChild(embedBox);
			}
			
			if(showNetworks)
			{
				var buttonsBox: KVBox = buildNetworksButtons();
				addChild(buttonsBox);
			}
		}
		
		private function buildNetworksButtons():KVBox
		{
			var vbox:KVBox = new KVBox(); 
			vbox.horizontalAlign = HorizontalAlignment.CENTER;
			vbox.verticalAlign = VerticalAlignment.TOP;
			vbox.horizontalGap = 10;
			vbox.verticalGap = 10;
			vbox.width = width   ;
			
			var label:KLabel = new KLabel();
			label.setSkin("bolded"); 
			label.width = vbox.width  - 20;
			label.text = networksLabel;
			vbox.addChild(label); 
			
			
			var hbox:KHBox = new KHBox(); 
			hbox.horizontalAlign = HorizontalAlignment.CENTER;
			hbox.verticalAlign = VerticalAlignment.MIDDLE;
			hbox.horizontalGap = 10;
			hbox.width = width  - 20  ;
			 
			var hbox2:KHBox = new KHBox(); 
			hbox2.horizontalAlign = HorizontalAlignment.CENTER;
			hbox2.verticalAlign = VerticalAlignment.MIDDLE;
			hbox2.horizontalGap = 10;
			hbox2.width = width  - 20  ;
			
			if (showFacebook)
				hbox.addChild(createButton(facebookLabel , "fb_ico" ,"facebook" ));
			if (showTwitter)
				hbox.addChild(createButton(twitterLabel,"tweeter_ico" , "twitter"));
			if (showLinkedIn)
				hbox2.addChild(createButton(LinkedInLabel,"linkedin_icon" , "linkedin"));
			if (showWordpress)
				hbox2.addChild(createButton(WordpressLabel,"wp_icon" , "wordpress"));
			
			//add hbox only if it has networks 
			if (hbox.numChildren)
				vbox.addChild(hbox)
					
			if (hbox2.numChildren)		
				vbox.addChild(hbox2)
			
			return vbox;
		}
		
		private function onNetworButtonClicked(event:MouseEvent):void
		{
			var options:Object = new Object();
/*			if(advancedShareMediator.entry && widget)
			{
				options.title = advancedShareMediator.entry.name; 
				options.description = advancedShareMediator.entry.description;
				options.screenshot_secure = advancedShareMediator.entry.thumbnailUrl
				options.screenshot = advancedShareMediator.entry.thumbnailUrl
			}*/
			//tweeter
			if(via)
				options.via = via;
			
			
			//actual share action with addThis
			_addThisAPI.share(directLink,(event.target as KButton)["id"],options);
			
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		private function createButton(label:String,icon:String , notification:String  ):KButton
		{
			
			var button:KButton = new KButton();
			button.label = label;
			button.minWidth = 100;
			//button.maxWidth = 50;
			button.upIcon = icon;
			button.width = 100;
			button.id = notification;
			button.setStyle("upIcon" , icon);
			button.setSkin("grayBtn" );
			button.maxHeight = 18;
			
			button.addEventListener(MouseEvent.CLICK , onNetworButtonClicked);
			
			return button;
		}
		
		
		private function buildOneBox(id:String , title:String):KVBox
		{
			
			var vbox:KVBox = new KVBox(); 
			vbox.horizontalAlign = HorizontalAlignment.LEFT;
			vbox.verticalAlign = VerticalAlignment.TOP;
			vbox.verticalGap = -2;
			vbox.paddingLeft = 10;
			vbox.height = 60;
			vbox.width = width;
			
			var label:KLabel = new KLabel();
			label.setSkin("bolded"); 
			label.width = vbox.width  - 20;
			label.text = title;
			vbox.addChild(label);
			
			var hbox:KHBox = new KHBox(); 
			hbox.horizontalAlign = HorizontalAlignment.LEFT;
			hbox.verticalAlign = VerticalAlignment.MIDDLE;
			hbox.horizontalGap = 5;
			hbox.width = vbox.width  - 20  ;
			vbox.addChild(hbox);
			
			//copy box
			var copyBg:KHBox = new KHBox();
			copyBg.width = hbox.width - copyButtonWidth - (paddingLeft*2) - 5;
			copyBg.setSkin("copyBg");
			hbox.addChild(copyBg)
			
			var copyText:KLabel = new KLabel();
			copyText.name = id;
				
			_refferencer[id] = copyText;
			
			copyText.setSkin("copyMe"); 
			copyText.truncateToFit = false; 
			copyText.width = copyBg.width - 10;//hbox.width - copyButtonWidth - (paddingLeft*2);
			copyText.text = "";
			copyText.selectable = true;

			copyText.addEventListener(MouseEvent.CLICK , stopPropagation);
			copyBg.addChild(copyText);
			
			
			var copyButton:KButton = new KButton();
			copyButton.maxWidth = copyButtonWidth;
			copyButton.setSkin("grayBtn" );
			copyButton.id = id;
			copyButton.maxHeight = copyButtonHeight;
			copyButton.label = copyLabel;
			hbox.addChild(copyButton);
			copyButton.addEventListener(MouseEvent.CLICK , onCopy);
			
			
			return vbox;
		} 
		
		private function stopPropagation(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
		}

		public function onCopy(event:MouseEvent):void
		{
			var klabel:KLabel = _refferencer[event.target.id] as KLabel;
			System.setClipboard(klabel.text);
			
			
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		private var resizeCounter:Number=0;
		private var uiReady:Boolean;
		public function resize():void
		{
			if(++ resizeCounter > 3 && !uiReady)
				buildUi();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			resize();
		}
		override public function set height(value:Number):void
		{
			super.height = value;
			resize();
		}
		
		public function onClose(event:MouseEvent):void {
			this.visible = false;
			//advancedShareMediator.duringShare = false;
			if(wasPlayerPlaying)
				advancedShareMediator.sendNotification(NotificationType.DO_PLAY);	
			advancedShareMediator.sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : true , enableType : EnableType.FULL});
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
	}
}