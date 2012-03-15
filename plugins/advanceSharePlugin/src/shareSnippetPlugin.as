package
{
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.controls.KButton;
	import com.kaltura.kdpfl.view.controls.KLabel;
	import com.yahoo.astra.layout.modes.HorizontalAlignment;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class shareSnippetPlugin extends KVBox implements IPluginFactory, IPlugin 
	{
		
		public var ar:AssetsRefferencer;
		
		public var linkLabel:String = "Email or IM this to your friends:";
		public var embedLabel:String = "Copy this code to your website or blog:";
		public var networksLabel:String = "Post this video to one of these sites:";
		
		public var copyLabel:String = "Copy to Clipboard";
		
		private var _refferencer:Object = new Object();
		
		public var facebookLabel:String = "Facebook";
		public var diggLabel:String = "Digg";
		public var LinkedInLabel:String = "LinkedIn  ";
		public var WordpressLabel:String = "Wordpress";
		public var twitterLabel:String = "Twitter     ";
		public var deliciousLabel:String = "Delicious";
		public var landingPagePrefix:String ;
		
		public var copyButtonWidth:Number = 110;
		public var copyButtonHeight:Number = 18;
		public var padding:Number = 10;
		public var showNetworks:Boolean = true;
		
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
		
		public var customSnippetAfter:String;
		
		/**
		 * Unique identifier field name if it is metadata 
		 */
		public var uuid:String ;
		
		
		
		public function shareSnippetPlugin()
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
			//retrieve uuid
			
			var widthHeightString:String = ""
			
			if(widthAttribute)
			{
				widthHeightString+="&width="+widthAttribute;
			}
			if(heightAttribute)
			{
				widthHeightString+="&height="+heightAttribute;
			}
			
			
			var uuidStr:String;
			
			if (!uuid)
				// fallback is entryId  
				uuidStr = advancedShareMediator.entry.id;
			 else 
				uuidStr = uuid;

			if(customSnippetBefore && customSnippetAfter )
			{
				directEmbed =  unescape(customSnippetBefore)+ uuidStr+widthHeightString+ unescape(customSnippetAfter);
			} else 
			{
				//Error 
				directEmbed = "Plugin is not configured correctly.";
			}
			
			if(_refferencer.hasOwnProperty("directEmbed"))
				(_refferencer["directEmbed"] as KLabel).text = directEmbed;
			
			if(landingPagePrefix)
			{
				directLink = landingPagePrefix + uuidStr ; //todo add start and end parameters once they will be developed
				
			} else
			{
				directLink = "Plugin is not configured correctly. Generator page prefix is not set"; 
			}
			
			
			if(_refferencer.hasOwnProperty("directLink"))
				(_refferencer["directLink"] as KLabel).text = directLink;
			
		}

		public function initializePlugin(facade:IFacade):void 
		{
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
			var linkBox:KVBox = buildOneBox("directLink",linkLabel );
			addChild(linkBox);
			
			var embedBox:KVBox = buildOneBox("directEmbed",embedLabel );
			addChild(embedBox);
			
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
			
			hbox.addChild(createButton(facebookLabel , "fb_ico" ,"facebook" ));
			hbox.addChild(createButton(twitterLabel,"tweeter_ico" , "twitter"));
			hbox2.addChild(createButton(LinkedInLabel,"linkedin_icon" , "linkedin"));
			hbox2.addChild(createButton(WordpressLabel,"wp_icon" , "wordpress"));
			
			vbox.addChild(hbox)
			vbox.addChild(hbox2)
			
			return vbox;
		}
		
		private function onNetworButtonClicked(event:MouseEvent):void
		{
			facade.sendNotification("addThisNetwork" ,(event.target as KButton).id); 
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
		
		public function onCopy(event:MouseEvent):void
		{
			var klabel:KLabel = _refferencer[event.target.id] as KLabel;
			System.setClipboard(klabel.text);
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
			visible = false;
			advancedShareMediator.duringShare = false;
			if(wasPlayerPlaying)
				advancedShareMediator.sendNotification(NotificationType.DO_PLAY);	
			advancedShareMediator.sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : true , enableType : EnableType.FULL});
		}
		
	}
}