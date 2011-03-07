package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.Plugin;
	import com.kaltura.kdpfl.util.KTextParser;
	import com.kaltura.kdpfl.view.containers.KCanvas;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		public static const NAME:String = "mainViewMediator";
		private var _lp:LayoutProxy;
		private var _origEnableMap : Object = {};
		private var _flashvars : Object;
		// saving the view components in array to manpulate later
		//public var components : Array;
		

		public function MainViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_lp = (facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy);
			view.addEventListener(ComponentEvent.SHOW, onFlashCompEvent);
			view.addEventListener(ComponentEvent.HIDE, onFlashCompEvent);
			view.addEventListener(ComponentEvent.RESIZE, onFlashCompEvent);
			view.addEventListener(ComponentEvent.MOVE, onFlashCompEvent);
			//This section is necessary to stop propagation of "common" events, so they are not received outside of the kdp,
			// like the drilldown pop-up in kmc Content.
			view.addEventListener("change", onIndexChange);
			view.addEventListener("childIndexChange", onIndexChange);
			view.addEventListener("headerShift", onIndexChange); 
			
			
			//Initially save the enable configuration of the uicomponents in the kdp
			var corrComp : Object;
			var allObjects : Object = facade["bindObject"];
			for each(var uicomp:* in allObjects)
			{
				if( uicomp is UIComponent ) 
				{
					corrComp = _lp.FindCompByName(uicomp.name);
					if(corrComp != "not found" && corrComp.attr.enabled)
					{
						_origEnableMap[uicomp.name] = corrComp.attr.enabled;
					}
					else
					{
						_origEnableMap[uicomp.name] = uicomp.enabled;
					}
				}
			}
			
			
			// add a service layer over the main layout	
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						NotificationType.ROOT_RESIZE,
						NotificationType.ENABLE_GUI,
						NotificationType.HAS_OPENED_FULL_SCREEN,
						NotificationType.HAS_CLOSED_FULL_SCREEN,
						NotificationType.SHOW_UI_ELEMENT,
						NotificationType.LAYOUT_READY
					];
		}
		
		private function onIndexChange ( e: Event) : void
		{
			e.stopPropagation();
		}
		
		private function onFlashCompEvent (e : ComponentEvent) : void	
		{
			
			e.stopPropagation();
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case NotificationType.LAYOUT_READY:
					
					_flashvars = (facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy).vo.flashvars;
					
				break;
				// this means that the main container will be 100% X 100% always
				case NotificationType.ROOT_RESIZE:
					view.width = note.getBody().width;
					view.height = note.getBody().height;
					
					var foreground:KCanvas = _lp.vo.foreground;
					
					//resize the foreground layer 
 					if(foreground)
					{
						foreground.width = note.getBody().width;	
						foreground.height = note.getBody().height;	
					}
					
				break;
				case NotificationType.ENABLE_GUI:
					var kMediaPlayerMediator : KMediaPlayerMediator = facade.retrieveMediator( KMediaPlayerMediator.NAME ) as KMediaPlayerMediator;
					var enableType : String = note.getBody().enableType;
					if( note.getBody().guiEnabled )
					{
						if (_disGuiArr.length > 0)
						{
							if(_disGuiArr[_disGuiArr.length - 1] == enableType)
							{
								_disGuiArr.pop();
								if(_disGuiArr.length == 0)
								{
									setEnableGuiToAllComponents(true , EnableType.FULL);
									if(kMediaPlayerMediator && !_flashvars.disableOnScreenClick)
										kMediaPlayerMediator.enableOnScreenClick();
								}
								else
								{
									setEnableGuiToAllComponents(false , _disGuiArr[_disGuiArr.length - 1]);
									if(kMediaPlayerMediator && !_flashvars.disableOnScreenClick)
										kMediaPlayerMediator.disableOnScreenClick();
								}
							}
							else
							{
								for (var i : Number = _disGuiArr.length - 1; i >= 0; i--)
								{
									if(_disGuiArr[i] == enableType)
									{
										_disGuiArr.splice(i, 1);
									}
								}
							}
							
						}	
					}
					else
					{
						_disGuiArr.push(enableType);
						setEnableGuiToAllComponents(false , enableType);
						if(kMediaPlayerMediator && !_flashvars.disableOnScreenClick)
							kMediaPlayerMediator.disableOnScreenClick();
					}
				break;
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					hideInFullScreen(true);
				break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					hideInFullScreen(false);
				break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					hideInFullScreen(false);
				break;
				case NotificationType.SHOW_UI_ELEMENT:
					_lp.includeInLayoutObject(note.getBody().id,note.getBody().show);
				break;
			}
		}
		
		private function hideInFullScreen(value:Boolean):void
		{
			var items:Array = _lp.hideInFullScreenList;
			for each(var item:String in items)
			{
				_lp.includeInLayoutObject(item,value);
			}
		}
		
		/**
		 * A counter that indecates if the scrubber should be enabled or not 
		 */	
		private var _disGuiArr : Array = new Array(); 
		
		/**
		 * Get all general buttons instances and set their enable status.    
		 * @param enable
		 * 
		 */
		private function setEnableGuiToAllComponents(isEnabled:Boolean, enableType : String):void
		{
			var allObjects:Object = facade["bindObject"];
			var corrComp :Object;
			for each(var item:* in allObjects)
			{
				if( item is UIComponent && 
				(!item.hasOwnProperty('supportEnableGui') || 
					(item.hasOwnProperty('supportEnableGui') && item["supportEnableGui"] == "true" ) ) )
					{
						
						if(!isEnabled)
						{
							if(enableType == EnableType.FULL)
							{
								item.enabled = false;
							}
							else
							{
								if (!item.hasOwnProperty("excludeFromDisableGUI") && !(item is Plugin)) 
								{
									item.enabled = false;
								}
								
								if(item.hasOwnProperty("excludeFromDisableGUI") || item.hasOwnProperty("configuration"))
								{
									item.enabled=true;
								}
							}
						}
						else
						{
							parsePreviousState(item);
						}
						
					}
					
			}
		}
		
		public function get view():UIComponent
		{
			return viewComponent as UIComponent;
		}
		
		/**
		 * Parses the _origEnabledMap object to return the gui to its state before disabling, including binding.     
		 * @param item The item from the bindObject whose enabled property the player is trying to restore.
		 * 
		 */
		private function parsePreviousState (item : Object) : void
		{
			var bindObj : Object = facade["bindObject"];
			if(item is UIComponent )
			{
				if ( _origEnableMap[item.name] is Boolean)
				{
					item.enabled = _origEnableMap[item.name];
				}
				else if (_origEnableMap[item.name] is String )
				{
					parseFromComp(item);
				}
				else
				{
					item.enabled = true;
				}
			}
		}
		
		
		/**
		 * The function calls a text parser to parse the value of the enabled prop of the item 
		 * @param item The UIComponent the enabled prop of which must return to its previous state
		 * 
		 */		
		private function parseFromComp ( item : Object ) : void
		{
			var allObjs : Object = facade["bindObject"];		
			KTextParser.bind(item, "enabled", allObjs, _origEnableMap[item.name] as String);
		} 
		
		/**
		 * This function creates the context menu (menu which opens on right-clicking the kdp).
		 * @param flashvars the flashvars Object containing the parsed flashvars
		 * 
		 */		
		public function createContextMenu () : void
		{
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			var customContextMenu : ContextMenu = new ContextMenu();
			
			customContextMenu.hideBuiltInItems();
			var menuItem:ContextMenuItem = new ContextMenuItem( "kdp version: " + ApplicationFacade.getInstance().kdpVersion );
			
			var credits:ContextMenuItem = new ContextMenuItem(_flashvars.aboutPlayer);
			
			credits.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onCreditClick);
			
			customContextMenu.customItems.push(credits);
			customContextMenu.customItems.push(menuItem);
				
			ApplicationFacade.getInstance().app["contextMenu"] = customContextMenu;
		}
		
		
		private function onCreditClick ( e : ContextMenuEvent) : void
		{
			var contextLink : String = _flashvars.aboutPlayerLink;
			
			var urlRequest:URLRequest = new URLRequest(contextLink);
			navigateToURL(urlRequest, "_blank");
		}
		
	}
}