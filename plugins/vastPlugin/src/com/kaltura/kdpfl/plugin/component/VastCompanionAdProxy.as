package com.kaltura.kdpfl.plugin.component
{
	
	import com.kaltura.kdpfl.plugin.model.UniformCompanionAd;
	import com.kaltura.kdpfl.plugin.util.CompanionAdParser;
	import com.kaltura.kdpfl.plugin.view.CompanionContainer;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.osmf.vast.model.VASTCompanionAd;
	import org.osmf.vast.model.VASTDataObject;
	import org.osmf.vast.parser.base.VAST2CompanionElement;
	import org.puremvc.as3.interfaces.IFacade;

	public class VastCompanionAdProxy
	{
		public var NAME : String = "vastCompanionAdProxy";
		
		public static const BEFORE : String = "before";
		public static const AFTER : String = "after";
		public static const FIRST_CHILD : String = "firstChild";
		public static const LAST_CHILD : String = "lastChild";
		
		public var flashCompsConfig : Array; //Array containing the configuration of the flash companion ads in the KDP
		public var htmlCompsConfig : Array; //Array containing the configuration of the html companion ads in the page surrounding the kdp
		
		private var flashCompanionMap : Object = {}; //Map Object connecting the flash uicomponents on the stage to their designated companion ads.
		private var htmlCompanionMap : Object = {}; //Map Object connecting the html components on the stage to their designated companion ads.
		private var companionAdsArr : Object;
		/**
		 * Constructor 
		 * @param flashCompanionAdsConfig - encrypted string of the companion ads configuration - which
		 * flash display object is associated to which size of ad.
		 * @param htmlCompanionAdsConfig - encrypted string of the companion ads configuration - which
		 * html display object (div) is associated to which size of ad.
		 * @param proxyName
		 * @param data
		 * 
		 */		
		public function VastCompanionAdProxy(flashCompanionAdsConfig : String, htmlCompanionAdsConfig : String)
		{
			var companionParser : CompanionAdParser = new CompanionAdParser();
			
			flashCompsConfig = companionParser.parseCompanionAds(flashCompanionAdsConfig);
			htmlCompsConfig = companionParser.parseCompanionAds(htmlCompanionAdsConfig);
		}
		
		/**
		 * Create a map of the flash companion ads. The output is a map connecting between the id of
		 * the flash UIComponent and the uniform companion ad it is supposed to display 
		 * @param vastDocument
		 * 
		 */		
		public function createFlashCompanionsMap (vastDocument : VASTDataObject) : void
		{
			var companionConfig : Object;
			
			if (vastDocument.vastVersion == 2)
			{
				companionAdsArr = vastDocument["companionArray"];
				for each (companionConfig in flashCompsConfig)
				{
					for each (var companion : VAST2CompanionElement in companionAdsArr)
					{
						if (companionConfig.compWidth == companion.width && companionConfig.compHeight == companion.height)
						{
							
							var compElement : UniformCompanionAd = new UniformCompanionAd(companion, vastDocument.vastVersion);
							if (compElement.resourceType == "static" || compElement.staticResource)
								flashCompanionMap[companionConfig.compId] = {companionAd:compElement, relativeTo:companionConfig.compRelativity};
							
							//Remove this item from the array so it will not come up again for html companion ad map creation
							companionAdsArr.splice(companionAdsArr.indexOf(companion),1);
						}
					}
				}
			}	
			else if (vastDocument.vastVersion == 1)
			{
				if( vastDocument["ads"].length > 0)
					companionAdsArr = vastDocument["ads"][0]["inlineAd"]["companionAds"];
				
				for each (companionConfig in flashCompsConfig)
				{
					for each (var comp : VASTCompanionAd in companionAdsArr)
					{
						if (companionConfig.compWidth == comp.width && companionConfig.compHeight == comp.height)
						{
							var companionElement : UniformCompanionAd = new UniformCompanionAd(comp, vastDocument.vastVersion);
							
							if(companionElement.resourceType == "static")
							{
								flashCompanionMap[companionConfig.compId] = {companionAd:companionElement, relativeTo:companionConfig.compRelativity};
								//Remove this item from the array so it will not come up again for html companion ad map creation
								companionAdsArr.splice(companionAdsArr.indexOf(comp),1);
							}
						}
					}
				}
			}
		}
		
		/**
		 * Create a map of the html companion ads. The output is a map connecting between the id of
		 * the html component and the uniform companion ad it is supposed to display 
		 * @param vastDocument
		 * 
		 */
		public function createHtmlCompanionMap (vastDocument : VASTDataObject) : void
		{
			var companionConfig : Object;
			
			if (vastDocument.vastVersion == 2)
			{
				for each (companionConfig in htmlCompsConfig)
				{
					for each (var companion : VAST2CompanionElement in companionAdsArr)
					{
						if (companionConfig.compWidth == companion.width && companionConfig.compHeight == companion.height)
						{
							htmlCompanionMap[companionConfig.compId] = new UniformCompanionAd(companion, vastDocument.vastVersion);
							
							//Remove this item from the array so it will not come up again for html companion ad map creation
							
						}
					}
				}
			}
			else if (vastDocument.vastVersion == 1)
			{
				for each (companionConfig in htmlCompsConfig)
				{
					for each (var comp : VASTCompanionAd in companionAdsArr)
					{
						if (companionConfig.compWidth == comp.width && companionConfig.compHeight == comp.height)
						{
							htmlCompanionMap[companionConfig.compId] = new UniformCompanionAd(comp , vastDocument.vastVersion);
							
							//Remove this item from the array so it will not come up again for html companion ad map creation
							companionAdsArr.splice(companionAdsArr.indexOf(companion),1);
						}
						
						
					}
				}
			}
		}
		
		/**
		 * Function displays the companion ads in the flash uicomponents in the player.
		 * The function centers companion ads that do not necessarily fit exactly within their designated uicomponents 
		 * 
		 */		
		public function displayFlashCompanions (facade : IFacade) : void
		{
			var allObjects : Object = facade["bindObject"];
			
			for each (var container : Object in allObjects)
			{
				if ( container is UIComponent)
				{
					if (flashCompanionMap[container.name])
					{
						var loader : Loader = new Loader();
						var urlReq : URLRequest = new URLRequest();
						if(flashCompanionMap[container.name].companionAd.companionResource)
						{
							urlReq = new URLRequest(flashCompanionMap[container.name].companionAd.companionResource);
							var loaderContext : LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
							loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
							var companionSprite : CompanionContainer = new CompanionContainer(flashCompanionMap[container.name].companionAd);
							companionSprite.addChild(loader);
							var companionConfig :Object = new Object();
							companionConfig.percentWidth = 100;
							companionConfig.percentHeight = 100;
							companionConfig.includeInLayout = true;
							companionConfig.target = companionSprite;
							var containerConfig : Array = new Array();
							var targetIndex : int;
							switch (flashCompanionMap[container.name].relativeTo)
							{
								case LAST_CHILD:
									containerConfig = container["configuration"] ? container["configuration"].concat() : containerConfig;
									containerConfig.push(companionConfig);
									container["configuration"] = containerConfig;
									//(container as UIComponent).addChild (companionSprite);
								break;
								case FIRST_CHILD:
									containerConfig = container["configuration"] ? container["configuration"].concat() : containerConfig;
									containerConfig.splice(0,0, companionConfig);
									container["configuration"] = containerConfig;
								break;
								case AFTER:
									targetIndex = container.parent.getChildIndex(container as UIComponent) + 1;
									containerConfig = container.parent.parent["configuration"].concat();
									containerConfig.splice(targetIndex,0, companionConfig);
									container.parent.parent["configuration"] = containerConfig;
								break;
								case BEFORE:
									targetIndex = container.parent.getChildIndex(container);
									containerConfig = container.parent.parent["configuration"].concat();
									containerConfig.splice(targetIndex,0, companionConfig);
									container.parent.parent["configuration"] = containerConfig;
							
								break;
							}
							
							companionSprite.resizeContainer();
							companionSprite.addClickListener();
							loader.load(urlReq, loaderContext);
						}
					}
				}
			}
		}
		
		
		private function onLoadComplete (e : Event) : void
		{
			trace("companion loaded!");
			((e.target as LoaderInfo).loader.parent as CompanionContainer).fireCreativeView ();
			((e.target as LoaderInfo).loader.parent as CompanionContainer).positionCompanionAd();
			
		}
		
		/**
		 * The function calls an external js function that displays the html companion ads within their designated divs. 
		 * 
		 */		
		public function displayHtmlCompanions (facade:IFacade) : void
		{
			var externalInterfaceProxy : Object = facade.retrieveProxy("externalInterfaceProxy");
			externalInterfaceProxy["call"]("showCompanions",htmlCompanionMap);
		}
		
		/**
		 *Function removes the flash companion ads from the stage leaving behind only the uicomponents as they were before. 
		 * 
		 */		
		public function hideFlashCompanionAds (facade : IFacade) : void
		{
			var allObjects : Object = facade["bindObject"];
			
			for each (var container : Object in allObjects)
			{
				if ( container is UIComponent )
				{
					if (flashCompanionMap[container.name] )
					{
						if (flashCompanionMap[container.name].relativeTo)
						{
							var containerConfig : Array = new Array();
							var targetIndex : int;
							switch (flashCompanionMap[container.name].relativeTo)
							{
								case FIRST_CHILD:
									containerConfig = container["configuration"].concat();
									if (containerConfig[0].target is CompanionContainer)
									{
										containerConfig.shift();
									}
									container["configuration"] = containerConfig;
								break;
								case LAST_CHILD:
									containerConfig = container["configuration"].concat();
									if (containerConfig[containerConfig.length - 1].target is CompanionContainer)
									{
										containerConfig.pop();
									}
									container["configuration"] = containerConfig;
								break;
								case AFTER:
									containerConfig = container.parent.parent["configuration"].concat();
									targetIndex = container.parent.getChildIndex(container)+ 1;
									if (containerConfig[targetIndex].target is CompanionContainer)
									{
										containerConfig.splice(targetIndex, 1);
									}
									container.parent.parent["configuration"] = containerConfig;
								break;
								case BEFORE:
									containerConfig = container.parent.parent["configuration"].concat();
									targetIndex = container.parent.getChildIndex(container)-1;
									if (containerConfig[targetIndex].target is CompanionContainer)
									{
										containerConfig.splice(targetIndex, 1);
									}
									container.parent.parent["configuration"] = containerConfig;
								break;
							}
						}
					}
				}
			}
		}
		
		/**
		 *Function removes all content from both the flash companion and html companion maps. 
		 * 
		 */		
		public function cleanMaps () : void
		{
			flashCompanionMap = new Object();
			htmlCompanionMap = new Object();
		}
		
	}
}