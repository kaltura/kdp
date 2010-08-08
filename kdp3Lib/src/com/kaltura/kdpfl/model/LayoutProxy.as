package com.kaltura.kdpfl.model
{

	import com.kaltura.kdpfl.component.ComponentData;
	import com.kaltura.kdpfl.component.ComponentFactory;
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.controller.LoadConfigCommand;
	import com.kaltura.kdpfl.model.vo.LayoutVO;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.Plugin;
	import com.kaltura.kdpfl.plugin.PluginManager;
	import com.kaltura.kdpfl.util.KTextParser;
	import com.kaltura.kdpfl.util.ObjectUtils;
	import com.kaltura.kdpfl.util.URLUtils;
	import com.kaltura.kdpfl.view.containers.KCanvas;
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	import com.yahoo.astra.fl.utils.XMLUtil;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * The class LayoutProxy is responsible for building the KDP visual layout.
	 * 
	 */	
	public class LayoutProxy extends Proxy
	{
		public static const NAME:String = "layoutProxy";
		
		/**
		 * Holds every component data that was build in this KDP in this array 
		 */		
		public var components:Array = new Array();
		
		public var sequenceProxy : SequenceProxy;
	
		public var hideInFullScreenList:Array = new Array();
		
		public var numPreInitPlugins : Number;
		
		public var componentFactory : ComponentFactory = new ComponentFactory();
		/**
		 * Constructor  
		 */		
		public function LayoutProxy() : void
		{
			super( NAME, new LayoutVO() ); 
		}
		
		/**
		 * Main KDP view builder, this function gets a uiconf xml
		 * and create KDP instances from it and return the root parent
		 * @param xml
		 * @return 
		 * 
		 */		
		public function buildLayout( xml:XML , itemRendererData : Object = null):Object
		{
			if(xml == null) return null;
			
			// fetch the bindOjbect from the facade in order to push all of the components into it.
			// all components (not item renederers) will try to bind their properties using bindObject as their root
			// object to start the binding from.
			// Item renderers will pass themselves as the root 
			var bindObject:Object = facade['bindObject'];
			
			var configProxy : ConfigProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
			var flashvars : Object = configProxy.vo.flashvars;
			
			var styleString:String = String(xml.@styleName);
			var type:String = String(xml.name());
			var isContainer:Boolean = false;
			var isPlugIn:Boolean = false;
			var uiComponent:Object;
			
			//if this is a plugin
			if(xml.name() == "Plugin")
			{
				isPlugIn = true;
				
				//see if we need to wait for this plugin to load (loadingPolicy == "wait")
				var loadingPolicy : String = xml.attribute('loadingPolicy');
				if(!loadingPolicy) loadingPolicy = "wait";
				
				//form the plugin url
							
				var pluginDomain : String = flashvars.pluginDomain ? flashvars.pluginDomain : (facade['appFolder'] + 'plugins/');
				var pluginUrl : String = xml.attribute('path');
				
		 		//	the default plugin path is "plugins/{plugin id}Plugin.swf
				if (!pluginUrl)
					pluginUrl = xml.@id + "Plugin.swf";
					
				if(!URLUtils.isHttpURL(pluginUrl))
					pluginUrl = pluginDomain + pluginUrl;
					
				var pluginName:String = xml.attribute("pluginName");
					
				uiComponent = PluginManager.getInstance().loadPlugin(pluginUrl, pluginName, loadingPolicy , flashvars.fileSystemMode == true);
				
				// we wait for ready for onDemand plugins as well in order to set their data and
				// initialize the plugin.
				// this event listener MUST HAVE a higher priority than the one set by the code
				// actually loading the plugin in order for the later to receive an initialized plugin 
				(uiComponent as Plugin).addEventListener( Event.COMPLETE , onPluginReady, false, int.MAX_VALUE);
						 
				//save the xml and the host to bind them when the plugin is loaded
				(uiComponent as Plugin).xml = xml;
				(uiComponent as Plugin).itemRendererData = itemRendererData;
					
				facade['bindObject']['Plugin_' + xml.@id] = uiComponent;
			}
			else//this is a kdp component
				uiComponent = componentFactory.getComponent(type);
				
			if(!uiComponent) return null; //exit if the component is not supported 
			
			uiComponent.name = xml.@id;
			
			//set the component Coordinates and Dimentions except percentage that set by (xml:XML)
			//TODO: SEE IF NEEDS TO MOVE TO COMPONENTS THAT DOESN'T HAVE PERCENTAGES
			handleCoordinatesAndDimentions(uiComponent,xml);
				
			// split cases - a known component or a module
			if( !isPlugIn ) //isComponent?
			{	
				//AdvancedLayoutPane for VBox & HBox and the canvas has an implementation out of Astra 
				//in the KDP (see Kcanvas class) 	
				if(uiComponent is AdvancedLayoutPane ||uiComponent is KCanvas ) isContainer = true;

				// split cases - a container or a simple uicomponent
				if(isContainer)
				{
					var list:XMLList = xml.children();
		
					//build all childrens
					for (var i:uint=0;i<list.length();i++)
					{
						var ui:Object = buildLayout(list[i] , itemRendererData);
						if(ui == null) continue;//if component is not supported skip this one 
						var config:Object = getConfiguration(list[i],ui);
					 	
					 	if( ui is DisplayObject )
					 	{
						 	config.target = ui;
						 	if(ObjectUtils.length(config) > 0)
						 	{
						 		if(uiComponent['configuration'])
						 		{
						 			var a:Array = uiComponent['configuration'].concat();
						 			a.push(config);
						 			uiComponent['configuration'] = a;
						 		}
						 		else
						 		{
							 		uiComponent['configuration'] = [config];
						 		}
						 	}
/* 						 	else //the configuration replace the need to add child
						 	{			 		
						 		uiComponent.addChild(ui);
						 	} */
					 	}
				 	}
				}	
				else //simple component (not container)
				{

				}
				
				//update the component with setting and binding
				uiComponent = updateComponent( uiComponent , xml , itemRendererData );
			}		
			return uiComponent;
		}
		
		/**
		 * This function displays or hides an element from the layout and affets its container to 
		 * redraw its layout   
		 * @param objectId
		 * @param value
		 * 
		 */
		public function includeInLayoutObject(objectId:String, value:Boolean):void
		{
			var bindObject:Object = facade['bindObject'];
			//search for the parent of the item in the XML ui
			var layoutXml:XML = (facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy).vo.layoutXML;
			//var items:XMLList = data.item.(attribute(filterBy) == filterValue); 
			var allUiElements:XMLList = layoutXml.descendants();
			//this takes 2 much time - I will cut this and iterate on the nodes ... TODO find the short version  
			//find the element
			for each (var xml:XML in allUiElements)
			{
				if (xml.attribute("id") == objectId)
				{
					var elementNodeParent:String = xml.parent().@id;
					break;					
				}
			}
			//In case we didn't find the element to include/exclude from the layout
			if(!elementNodeParent)
			{
				return;
			}
			var container:Object = bindObject[elementNodeParent];
			// get current configuration as a cloned array 
			var newConfigurationArray:Array = (container['configuration'] as Array).concat();
			//search for the current item configuration 
			for (var i:int = 0; i<newConfigurationArray.length;i++)
			{
				if (newConfigurationArray[i].target ==  bindObject[objectId])
				{
					//change the includeInLayout value
					newConfigurationArray[i].includeInLayout = value;
					break;
				}
			}
			//change the visibility 
			bindObject[objectId].visible = value;	
			//newConfigurationArray.push(currentConfigurationObj);
			container['configuration'] = newConfigurationArray;	
		}		

		
		private function updateComponent( uiComponent : Object, xml:XML , itemRendererData : Object ) : Object
		{
			
			//check if this item should be hidden in fullscreen (and back when fullscreen ends)
			if(xml.attribute("hideInFullScreen").toString().length >0)
				hideInFullScreenList.push(xml.attribute("id")[0].toString());
			//for the current attribute try to set it as style or build-in attribute and add it's binding
			if(itemRendererData)
				addAttributes(uiComponent, xml, itemRendererData);
			else
				addAttributes(uiComponent, xml, facade['bindObject']);
				
			var styleName:String = getstyleName(xml);
			var att : Object = XMLUtil.createObjectFromXMLAttributes(xml);
			
			//set the component Skin 
			var setSkinSize : Boolean = !att.hasOwnProperty('width') && !att.hasOwnProperty('height');
			if(uiComponent is IComponent || uiComponent is IPlugin)
				uiComponent['setSkin']( styleName , setSkinSize );
			
			components.push( new ComponentData(uiComponent, styleName, att ));
			
			// add component to bindObject in order to support binding for all components
			facade['bindObject'][xml.@id] = uiComponent;
			
			//the componet has all it's properties so it can be initalize now
			if(uiComponent is IComponent)			
					(uiComponent as IComponent).initialize();
					
			return uiComponent;
		}
		
		private function onPluginReady( event : Event ) : void
		{
			
			
			var plugin : Plugin = ( event.target as Plugin );
					
			//update the component with setting and binding the plugin attributes to its attributes
			updateComponent( plugin.content , plugin.xml , plugin.itemRendererData );
			
			//(( event.target as Plugin ).content as IPlugin).initializePlugin( facade );
			plugin.content.initializePlugin( facade );
			
			
			//TODO: This is not the proper way of synchronising the plugin initiation. We should try to see why setting event priorities has not worked.	
			//PluginManager.getInstance().onPluginReady(event);
			
		}
		
		private function getConfiguration(xml:XML, ui:Object):Object
		{
			var config:Object = {};
			
			if(String(xml.@width).split("%").length==2)
			{
				config.percentWidth = Number(String(xml.@width).split("%")[0]);
			}
			
			if(String(xml.@height).split("%").length==2)
			{
				config.percentHeight = Number(String(xml.@height).split("%")[0]);
			}
			
			config.includeInLayout = ui.includeInLayout; //default to true 
			
			return config;
		}
		
		
		private function handleCoordinatesAndDimentions(uiComponent:Object, xml:XML):void
		{ 
			uiComponent.x = Number(xml.@x); //if not exist it's zero as default
			uiComponent.y = Number(xml.@y); //if not exist it's zero as default
			
			if(Number(xml.@width))
			{
				uiComponent.width = Number(xml.@width);
			} 
			
			if(Number(xml.@height))
			{
				uiComponent.height = Number(xml.@height);
			}
			
			if(String(xml.@maxHeight).length>0){
				uiComponent['maxHeight'] = Number(xml.@maxHeight);
			}
			if(String(xml.@maxWidth).length>0) {
				uiComponent['maxWidth'] =Number(xml.@maxWidth);
			}
			if(String(xml.@minHeight).length>0){
				uiComponent['minHeight'] = Number(xml.@minHeight);
			}
			if(String(xml.@minWidth).length>0) {
				uiComponent['minWidth'] =Number(xml.@minWidth);
			}
		}
		
		private function addAttributes(comp:Object, xml:XML, host:Object):void
		{
			//remove known attributes			
			var tempXml:XML = xml.copy();
			delete (tempXml.@id);
			delete (tempXml.@path);
			delete (tempXml.@styleName);
			delete (tempXml.@command);
			delete (tempXml.@kclick);
			delete (tempXml.@width);
			delete (tempXml.@height);

			delete (tempXml.@hideInFullScreen);
			delete (tempXml.@loadingPolicy);

			
			var attributes:XMLList = tempXml.attributes();
			
			if(String(tempXml.@preSequence).length>0)
				(facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy).vo.preSequenceCount +=1;
			
			if(String(tempXml.@postSequence).length>0)
				(facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy).vo.postSequenceCount +=1;	

			for each(var o:Object in attributes)
			{
				var attrName:String = o.name().toString();
				var attrValue:String = o.toString();
				
				if(comp is UIComponent)
					comp.setStyle(attrName, attrValue);// try to set the property as a style

				// if the style value is null the propery is not a style
				// and we should try binding to its value
				try
				{
					KTextParser.bind(comp, attrName , host, attrValue);
				}
				catch(e:Error){
					trace("could not push",attrName,"=",attrValue,"to",comp);
				}
			}
		}
		
		private function getstyleName(xml:XML):String
		{
			var ret:String;
			
			if(String(xml.@styleName).length > 0)
			{
				ret = (xml.@styleName).toString(); 
			}
			
			return ret;
		}
		
		/**
		 * Getter for the layout data. 
		 * @return 
		 * 
		 */		
        public function get vo():LayoutVO  
        {  
        	return data as LayoutVO;  
        }  
        
        
         /**
          * The function searches for a component of a certain name in the components array
          * @param compName - the name of the component to search for in the components array
          * @return  - Returns the object with the compName
          * 
          */        
         public function FindCompByName (compName : String) : Object
        {
        	for each (var comp:* in components)
        	{
        		if (comp.attr.id == compName){
        			return comp;
        		}
        	}
        	return "not found";
        } 
		 /**
		  *  The function loads the plugins that need to be loaded before the rest of the layout.
		  * @param plugin
		  * 
		  */		 
		 public function loadPreInitPlugin ( plugin : XML ) : void
		 {
			 buildLayout(plugin);
		 }
	}
}

