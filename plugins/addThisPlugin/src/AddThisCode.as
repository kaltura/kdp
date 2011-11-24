package
{
	import com.addthis.share.ShareAPI;
	import com.adobe.fileformats.vcard.Email;
	import com.adobe.serialization.json.JSON;
	import com.kaltura.kdpfl.controller.AbstractCommand;
	import com.kaltura.kdpfl.controller.EmailCommand;
	import com.kaltura.kdpfl.controller.EmailError;
	import com.kaltura.kdpfl.controller.EmbedCommand;
	import com.kaltura.kdpfl.controller.ICommand;
	import com.kaltura.kdpfl.controller.SimpleFactory;
	import com.kaltura.kdpfl.manager.BindingManager;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.vo.AddThisEvent;
	import com.kaltura.kdpfl.model.vo.FormVO;
	import com.kaltura.kdpfl.model.vo.SocialSiteVO;
	import com.kaltura.kdpfl.model.vo.ViewVO;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.AddThisMediator;
	import com.kaltura.kdpfl.plugin.component.Form;
	import com.kaltura.kdpfl.plugin.component.IForm;
	import com.kaltura.kdpfl.plugin.component.RadioGroup;
	import com.kaltura.kdpfl.plugin.component.RadioItem;
	import com.kaltura.kdpfl.plugin.component.TextFieldWrapper;
	import com.kaltura.kdpfl.plugin.component.ViewWrapper;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.controls.KButton;
	import com.kaltura.kdpfl.view.controls.KTextField;
	import com.yahoo.astra.fl.containers.BoxPane;
	
	import fl.controls.CheckBox;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.describeType;
	
	import mx.binding.utils.BindingUtils;
	
	import org.osmf.net.StreamType;
	import org.puremvc.as3.interfaces.IFacade;

	public dynamic class AddThisCode extends UIComponent implements IPlugin
	{
		public var defaultView:String;
		public var networksToShow:String;
		public var showFacebook:String;
		public var showTwitter:String;
		public var showEmail:String;
		public var showLink:String;
		public var url:String;
		public var title:String;
		public var description:String;
		public var pubid:String;
		public var email_template:String;
		public var videoComponentId:String;
		public var ct:String;
		public var _screenshot:String;
		public var text:String; //	Text to show in the tweet, instead of the link's title.	Check out this link
		public var via:String; //	A Twitter account which is appended to your tweet like:
		public var related:String; //	Comma separated list of related twitter accounts, suggested to the user after they tweet.
		
		
		public var socialButtonTemplate:String;
		public var socialSiteContainer:String;
		public var socialSitesContainer:String;
		public var emailCopySender:Boolean;
		public var emailSuccessModuleId:String;
		//captcha module
		public var emailSuccessMessage:String		= "Your email was successfully sent!";
		public var emailAlertTitle:String			= "Email Response";
		public var emailFailureMessage:String;
		public var captchaModuleId:String;
		public var captchaSwfContainerId:String;
		public var captchaFormId:String;
		private var _defaultEmbedCode:String			= "NO DEFAULT EMBED CODE AVAILABLE";
		private var _swfurl:String;
		private var _swfWidth:String;
		private var _swfHeight:String;
		//textfield wrappers
		private var _textFieldWrappers:Array			= new Array();
		private var _mediator:AddThisMediator;
		private var _facade:IFacade;
		private var _views:Array			= new Array();
		private var _addThisAPI:ShareAPI;
		private var _xml:XML;
		private var _forms:Array		= [];
		private var _layoutProxy:LayoutProxy;
		private var _commandFactory:SimpleFactory;
		private var _radioGroups:Array	= new Array();
		private var _bindingManager:BindingManager	= new BindingManager();
		public function AddThisCode()
		{
			super();
		}
		
		public function initializePlugin( facade : IFacade ) : void{
			_facade				= facade;
			_addThisAPI		= new ShareAPI(pubid);
			_commandFactory	= new SimpleFactory();
			
			_mediator			= new AddThisMediator(_facade);
			_mediator.eventDispatcher.addEventListener(AddThisMediator.EMBED_CODE_UPDATED, onEmbedUpdated);
			_mediator.eventDispatcher.addEventListener(AddThisMediator.INITIALIZE, onInit);
			_mediator.eventDispatcher.addEventListener(NotificationType.MEDIA_READY, onRefreshPlugin);
			_mediator.eventDispatcher.addEventListener(AddThisMediator.ADD_THIS_FORM, onAddThisForm);
			_mediator.eventDispatcher.addEventListener(AddThisMediator.ADD_THIS_NETWORK, onAddThisShare);
			_mediator.eventDispatcher.addEventListener(AddThisMediator.ADD_THIS_VIEW, onAddThisView);
			_mediator.eventDispatcher.addEventListener(AddThisMediator.ADD_THIS_CLOSE, onAddThisClose);
			_mediator.eventDispatcher.addEventListener(AddThisMediator.ADD_THIS_CHECKBOX, onCheckBox);
			_mediator.eventDispatcher.addEventListener(AddThisMediator.ADD_THIS, onAddThis);
			
			_facade.registerMediator(_mediator);
			
			onInit();
			//layout must be built during this phase in order to tie notification events to kButtons for some reason. 
			_layoutProxy	= (_facade.retrieveProxy("layoutProxy") as LayoutProxy);
			
			buildLayout(XML(_layoutProxy["vo"]["layoutXML"]..extraData.AddThisUI));
			mapTextFieldsToForms();
		}
		
		private function onCheckBox(e:Event):void{
			(emailCopySender)?emailCopySender=false:emailCopySender=true;
		}
		
		public function set defaultEmbedCode(s:String):void{
			//not sure why i had to replace the html characters even though i assign the values to text rather than htmlText.
			//seems to render it as html in both properties
			_defaultEmbedCode	= s.replace(/\</g,"&#60;");
			_defaultEmbedCode	= _defaultEmbedCode.replace(/\>/g,"&#62;");
			//"&#60;a href='http://www.google.com'&#62;here&#60;/a&#62;"
			for each(var form:Form in _forms){
				if(form.action is EmbedCommand){
					form.data	= {embedCode:_defaultEmbedCode};
				}
			}
		}
		public function get defaultEmbedCode():String{
			return _defaultEmbedCode;
		}
		
		private function onEmbedUpdated(e:AddThisEvent):void{

			_swfurl						= XML(e.data).@data.toXMLString();
			_swfWidth					= XML(e.data).@width.toXMLString();
			_swfHeight					= XML(e.data).@height.toXMLString();
			_screenshot					= _facade.retrieveProxy("mediaProxy")["vo"]["entry"]["thumbnailUrl"];
			
			defaultEmbedCode		= String(e.data);
		}

		private function mapTextFieldsToForms():void{
			//ASSIGN TEXTFIELDS TO FORM
			var viewFormMatches:Array	 = new Array();
			//this loop ensures view matches form
			for each(var view:Object in _views){
					for(var i:int =0; i < _forms.length;i++){//loop through list of forms
						var matchFound:Boolean	= true;
						for each(var txtDefinition:String in _forms[i].textFields){//loop through list of textfields in given form
							if(String(view.definition).indexOf(txtDefinition) == -1){
								matchFound		= false;
								//continue;
							}
							if(!matchFound)break;//go to next form if no match is found
						}
						//form found matching view. 
						//map form to view
						if(matchFound){
							viewFormMatches.push({form:_forms[i], view:view});
						}
					}
			}
			
			//get view textfields and add to form
			for each(var match:Object in viewFormMatches){
				getComponentsFromView(match.form, Sprite(match.view.view));
			}
			
			
		}
		
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void{
			
		}
		
		//init plugin
		private function onInit(e:Event	= null):void{setVisibility(false);}
		private function onAddThis(e:Event):void{
			//reset textfields
			resetTextToDefault();
			resetRadioButtons();
			for each(var form:Form in _forms){
				(form.action as AbstractCommand).addEventListener(AbstractCommand.COMMAND_RESPONSE,onComResponse);
			}
			setVisibility(true);
		
		}
		
		private function resetRadioButtons():void{
			for each(var form:Form in _forms){
				form.resetFormToDefault();
			}
		}
		
		private function resetTextToDefault():void{
			for each(var item:TextFieldWrapper in _textFieldWrappers){
				item.resetText();
			}
		}
		
		private function setVisibility(val:Boolean):void{this.visible	= val;}
		
		private function onRefreshPlugin(e:Event):void{
			//any values that need to be refresh or reset after each media load should be done here
		}
		
		
		private function onAddThisForm(e:Event):void{
			var responseCode:String;
			
			for each(var form:Form in _forms){
				if(form.id		== (_mediator.notificationData as FormVO).id){
					form.params	= _mediator.notificationData.params;
					break;
				}
			}
	
			
			try{
				form.submit();
			}catch(e:Error){
				if(e is EmailError){
					trace("AddThis: EMAIL ERROR	",e.message);
					this._facade.sendNotification(NotificationType.ALERT, {message:emailFailureMessage||"There was an error sending the email.  Please check to make sure email address fields are populated.", title:emailAlertTitle});
				}else
					trace("AddThis: ERROR "+e);
			}
		} 
		
		
		//determines the components of interest. 
		private function getComponentsFromView(form:Form,view:DisplayObjectContainer):void{
			var idx:int		= 0;
			for(var i:int = 0; i< view.numChildren;i++){
				//store components 
/*				if(view.getChildAt(i).name != "" && String(view.getChildAt(i).name).indexOf("instance") < 0){
					_bindingManager.component	= view.getChildAt(i);
				}
	*/			
				if(view.getChildAt(i) is KTextField){//handle KTEXTFIELDS
					var textFieldWrapper:TextFieldWrapper	= new TextFieldWrapper();
						textFieldWrapper.kTextField			= KTextField(view.getChildAt(i));
						_textFieldWrappers.push(textFieldWrapper);
					form.components.push(view.getChildAt(i));
				}else if(view.getChildAt(i) is KButton){ //only check for KButtons for dynamic values & lack of better method.  other dynamic components such as Shape will throw errors
					if((view.getChildAt(i) as Object).type == RadioItem.RADIO){// handle RADIO COMPONENTS

					var radioItem:RadioItem	= new RadioItem();//create new radio button
						radioItem.item		= view.getChildAt(i);//wrap the comp as a new radio button
					var groupExist:Boolean	= false;
						
						for each(var group:RadioGroup in form.radioGroup){//look thru the current form's list of radio groups
							if(group.name == (view.getChildAt(i) as Object).group){//if group name matches component name, insert
								group.addItem(radioItem);
								groupExist	= true;
							}
						}
						
						if(!groupExist){//if no group, create a new one and insert into form
							var radioGroup:RadioGroup	= new RadioGroup();
								radioGroup.name			= (view.getChildAt(i) as Object).group;
								radioGroup.addItem(radioItem);

							//add to form
							form.radioGroup.push(radioGroup);
						}
					}
				}else if(view.getChildAt(i) is CheckBox){
					form.components.push(view.getChildAt(i));
				}else if(view.getChildAt(i) is DisplayObjectContainer){
					getComponentsFromView(form,DisplayObjectContainer(view.getChildAt(i)));
				}
				
			}
		}
		
		
		private function onAddThisShare(e:Event):void{
			var options:Object			= new Object();
			if(title)
				options.title			= title;
			
			if(description)
				options.description		= description;
			
			if(_swfurl)
				options.swfurl			= _swfurl;
			
			if(_width)
				options.width			= _swfWidth;
			
			if(_height)
				options.height			= _swfHeight;

			if(_screenshot)
				options.screenshot		= _screenshot;
			
			if(text)
				options.text			= text;
			
			if(via)
				options.via				= via;
			
			if(related)
				options.related			= related;
			
			trace("title.title:			"+options.title);
			trace("title.desc:			"+options.description);
			trace("title.swfurl:		"+options.swfurl);
			trace("title.width:			"+options.width);
			trace("title.height:		"+options.height);
			trace("title.screenshot:	"+options.screenshot);
			trace("title.text:			"+options.text);
			trace("title.via:			"+options.via);
			trace("title.related:		"+options.related);
			
			_addThisAPI.share(url,(this._mediator.notificationData as SocialSiteVO).shareName,options);
		}
		
		private function onAddThisClose(e:Event):void{
			for (var i:int = 0;i< _views.length;i++)
				if(_views[i].definition.@stickie != true && _views[i].view.visible == true)
					_views[i].view.visible		  = false;
				
			for each(var form:Form in _forms){
				(form.action as AbstractCommand).removeEventListener(AbstractCommand.COMMAND_RESPONSE,onComResponse);
			}
			
			setVisibility(false);
		}
		
		private function onAddThisView(e:Event):void{
			for (var i:int = 0;i< _views.length;i++){
				if(_views[i].definition.@id		== (this._mediator.notificationData as ViewVO).view){
					//update binded properties for text fields
					updateCompProperties(_views[i]);
					_views[i].view.visible		  = true;
					//addChild(view);
				}else if(_views[i].definition.@stickie != true && _views[i].view.visible == true)
					_views[i].view.visible		  = false;
				
			}
		}
		
		//have to loop and rebuild textfields in order to update binded values 
		//ugly but cleanest way to honor the binded values of a textfield
		private function updateCompProperties(obj:Object):void{
			for(var i:int = 0; i<obj.definition..Text.length();i++){
				if(String(obj.definition..Text[i].@text).indexOf("{") > -1 && 
					String(obj.definition..Text[i].@text).indexOf("}") > -1 || 
					String(obj.definition..Text[i].@htmlText).indexOf("{") > -1 && 
					String(obj.definition..Text[i].@htmlText).indexOf("}") > -1){
					//we have a bindable property
					
					//rebuild the layout
					var comp:*  = _layoutProxy.buildLayout(XML(obj.definition..Text[i]));
					//now find it in the view and replace
					updateText(obj.view, comp);
				}
			}
		}
		
		//loops through the displaylist, finds a name match and replaces the textfield value
		private function updateText(target:*, component:*):void{
			for (var i:int =0; i < target.numChildren;i++){
				
				if(target.getChildAt(i).name == component.name){
					try{
						target.getChildAt(i).htmlText	= component.htmlText;
						//destroy component. no longer needed. 
						component						= null;
					}catch(e:Error){
						trace("AddThis ERROR: unable to push value into Text component: "+component.name);
						trace("AddThis ERROR: please check uniqueness of Text component name: "+component.name);
						trace("AddThis ERROR: if "+component.name+" has no width or hidden, please set truncateToFit='false'");
					}finally{
						return;
					}
				}else if(target.getChildAt(i) is BoxPane){
					updateText(target.getChildAt(i),component);
				}
			}
		}
		
		
		private function buildSocialIcons(xmlSrc:XML):void{
			//var xml:XMLList				= //xml..(@id == socialSiteIconsTemplate)
			var xmlButton:XMLList			= xmlSrc.descendants().(attribute("id") == socialButtonTemplate);
			var xmlSiteContainer:XMLList	= xmlSrc.descendants().(attribute("id") == socialSiteContainer);
			var xmlSitesContainer:XMLList	= xmlSrc.descendants().(attribute("id") == socialSitesContainer);
			
			//remove children templates
			while(xmlSiteContainer.children().length() > 0){
				delete xmlSiteContainer.children()[0];
			}
			
			//remove children templates
			while(xmlSitesContainer.children().length() > 0){
				delete xmlSitesContainer.children()[0];
			}
			
			var idPrefix:String				= "atShare";
			
			if(xmlButton.toXMLString() != ""){
				var socialSites:Array		= networksToShow.split(",");
				for each(var site:String in socialSites){
					var xmlSiteClone:XMLList;
					if(xmlSiteContainer.toXMLString() != "")
						xmlSiteClone					= xmlSiteContainer.copy();
					
					var xmlBtnClone:XMLList				= xmlButton.copy();
						xmlBtnClone.@id					= idPrefix+"-"+site;
						xmlBtnClone.@label				= site;
						xmlBtnClone.@icon				= idPrefix+"-"+site.toLowerCase();
						xmlBtnClone.@kClick				= "sendNotification('"+AddThisMediator.ADD_THIS_NETWORK+"','"+site+"')";
						
					//if there's an embedded container
					if(xmlSiteContainer.toXMLString() != ""){
						xmlSiteClone.appendChild(xmlBtnClone);
						xmlSitesContainer.appendChild(xmlSiteClone);
					}else //else place in main container
						xmlSitesContainer.appendChild(xmlBtnClone);

				}
			}
		}
		
		
		//generate the layout
		private function buildLayout(xml:XML):void{
			_views				= new Array();
			_xml				= xml;
			
			buildSocialIcons(_xml);
			
			//just need to generate an xml node to represent the top level container.  
			//all we really care for is the width and height. 
			var parentXML:String= "<Size id='topLevelNode' width='"+_facade["bindObject"][videoComponentId].width+"' height='"+_facade["bindObject"][videoComponentId].height+"' />";
			//var parentXML:String= "<Size id='daddy' width='"+this.width+"' height='"+this.height+"' />";
			
			//since width and height aren't required on form tags. we need to insert width/height
			//to those nodes so their children elements can receive relative sizing. part of the work around
			//for not being able to bind those attributes. 
			for each(var form:XML in xml..Form){
				form.@width			= "100%";
				form.@height		= "100%";
			}
			
			//update each component with the with/height pixel values
			for each(var module:XML in xml..module){
				//exclude module tag, 1st child should be VBox or HBox
				updateDimensions(XML(parentXML), XML(module.children()));
			}
			
			createForms(xml);
			
			//remove form tags
			while(xml..Form.length() > 0){
				removeFormTag(xml);
			}
			
			for each(var module:XML	in xml..module){
				var view:*		= _layoutProxy.buildLayout(XML(module.children()));	
				var viewWrapper:ViewWrapper	= new ViewWrapper();
				viewWrapper.view		= view;
				viewWrapper.definition	= module;
				_views.push(viewWrapper);
			}
			
			//reverse the display list
			_views.reverse();

			for (var i:int = 0;i< _views.length;i++){
				addChild(_views[i].view);
				if(_views[i].definition.@stickie != "true")
					_views[i].view.visible		  = false;
				
				if(_views[i].definition.@id == defaultView)
					_views[i].view.visible		  = true;
				
				
				trace("AddThisPlugin - Loaded view:::: "+_views[i].view.name);
			}
			
			//prepare component binding
			for (var idx:String in _views){
				storeComponents(_views[Number(idx)].view as Sprite);
			}
			
			_bindingManager.definition		= _xml;
			
			_bindingManager.init();
			trace("COMPONENT ITEMS::::"+_bindingManager._components.length);
		}
		

		private function storeComponents(view:DisplayObjectContainer):void{
			for(var i:int = 0; i< view.numChildren;i++){
				//only execute routine against items with names
				if(String(view.getChildAt(i).name).indexOf("instance") < 0 && view.getChildAt(i).name != ""){
					_bindingManager.component	= view.getChildAt(i);
					if(view.getChildAt(i) is DisplayObjectContainer){//handle KTEXTFIELDS
						storeComponents(DisplayObjectContainer(view.getChildAt(i)));
					}
				}
			}
		}
		
		private function updateDimensions(pXML:XML, cXML:XML):void{
			//TODO::need to add support for proxies			
			//convert child node
			if(String(cXML.@width).indexOf("%") > -1 || String(cXML.@width).indexOf("}") > -1  ||
				String(cXML.@height).indexOf("%") > -1 || String(cXML.@height).indexOf("}") > -1)
				convertValue(pXML,cXML);
			
			for each(var node:XML in cXML.children()){
				updateDimensions(cXML, node);
			}
		}
		
		//since we can't rely on the buildLayouts binding properties, 
		//we'll need to manually bind and replace percentage values.
		private function convertValue(pXML:XML, cXML:XML):void{
			if(String(cXML.@width).indexOf("{") > -1){
				var wStr:String 	= String(cXML.@width);
				wStr 				= wStr.replace("{","");
				wStr				= wStr.replace("}","");
				var wProperties:Array	= wStr.split(".");
				cXML.@width			= _facade['bindObject'][wProperties[0]][wProperties[1]];
			}
			
			if(String(cXML.@height).indexOf("{") > -1){
				var hStr:String 	= String(cXML.@height);
				hStr 				= hStr.replace("{","");
				hStr				= hStr.replace("}","");
				var hProperties:Array	= hStr.split(".");
				cXML.@height		= _facade['bindObject'][hProperties[0]][hProperties[1]];
			}

			if(String(cXML.@width).indexOf("%") > -1){
				var wVal:String		= String(cXML.@width).replace("%", "");
				cXML.@width			= (Number(pXML.@width) * Number(wVal)/100);
				
			}
			
			if(String(cXML.@height).indexOf("%") > -1){
				var hVal:String		= String(cXML.@height).replace("%", "");
				cXML.@height		= (Number(pXML.@height) * Number(hVal)/100);
			}
		}
		
		//remove form tag
		private function removeFormTag(xml:XML):XML{
			for each(var child:XML in xml.children()){
				if(child.name() == "Form"){
					xml.replace(child.childIndex(),child.children());
				}
				removeFormTag(child);
			}
			return xml;
		}
		
		//extract form data
		private function createForms(xml:XML):void{
			for each(var child:XML in xml.children()){
				if(child.name() == "Form"){
					var form:Form		= new Form();
					form.id			= child.@id;
					form.action		= getCommand(String(child.@action));
					form.url		= url;
					for(var x:int=0;x< child..Text.length();x++){
						form.textFields.push(child..Text[x].toXMLString());
					}
					form.definition	= child; 
					
					_forms.push(form);
				}
				createForms(child);
			}
		}
		
		//inserts captcha data in form
		private function set captchaData(data:Object){
			for each(var form:Form in _forms)
				if(form.id		== captchaFormId){
					form.data	= data;
					break;
				}
		}
		
		
		
		//handle command responses
		private function onComResponse(e:AddThisEvent):void{
			if(e.currentTarget is EmailCommand){
				for each(var view:ViewWrapper in _views){//clear container
					if (view.definition.@id == captchaModuleId){
						view.clearContainer(captchaSwfContainerId);
						break;
					}
				}
				
				if(e.codeType	== AddThisEvent.CAPTCHA_RESPONSE){
					captchaData	= e.data;
					for each(var view:ViewWrapper in _views){
						if (view.definition.@id == captchaModuleId){
							view.loadAndAddChildAt(e.data.error.attachment.url,captchaSwfContainerId);
							break;
						}
					}
					_facade.sendNotification(AddThisMediator.ADD_THIS_VIEW,captchaModuleId);
				}else if(e.codeType	== AddThisEvent.EMAIL_SENT){
					if(emailSuccessModuleId)
						this._facade.sendNotification(AddThisMediator.ADD_THIS_VIEW,emailSuccessModuleId);
					else{
						this._facade.sendNotification(NotificationType.ALERT, {message:emailSuccessMessage, title:emailAlertTitle});
						_facade.sendNotification(AddThisMediator.ADD_THIS_VIEW,defaultView);
					}
				}else{//(e.codeType	== AddThisEvent.EMAIL_SEND_FAIL)
					this._facade.sendNotification(NotificationType.ALERT, {message:emailFailureMessage, title:emailAlertTitle});
					_facade.sendNotification(AddThisMediator.ADD_THIS_VIEW,defaultView);
				}
			}
			
		}
		
		private function getCommand(cmd:String):ICommand{
			//factory of commands
			return _commandFactory.getCommand(cmd,_facade);
		}
		
	}
}