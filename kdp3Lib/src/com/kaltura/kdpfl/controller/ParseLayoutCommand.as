 package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.plugin.PluginManager;
	import com.kaltura.kdpfl.view.MainViewMediator;
	import com.kaltura.kdpfl.view.RootMediator;
	import com.kaltura.kdpfl.view.containers.KCanvas;
	import com.kaltura.kdpfl.view.controls.ToolTipManager;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;

	/**
	 * This class is responsible for parsing layout xml and creating KDP layout. 
	 */	
	public class ParseLayoutCommand extends AsyncCommand
	{
		private var _layoutProxy:LayoutProxy;
		
		/**
		 * Start building Layout according to the layout xml 
		 * @param note
		 */		
		override public function execute(note:INotification):void
		{
			_layoutProxy = facade.retrieveProxy( LayoutProxy.NAME ) as LayoutProxy;
			//var flashvars : Object = (facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy).vo.flashvars;
			//TODO hook this with the KDP swf path 				
			//if(!flashvars.debugMode) //if this is debug mode load the modules localy
				//_pluginsPath = "http://" + _flashvars.host + "/";
				
			//build all components and layout them and wrap the top component with the MainViewMediator
			buildComponents(_layoutProxy.vo.layoutXML.children()[0]);
			getAllScreens();
			
			var mainView : MainViewMediator = facade.retrieveMediator( MainViewMediator.NAME ) as MainViewMediator;	
			var rm:RootMediator = facade.retrieveMediator(RootMediator.NAME) as RootMediator;
			//add the main view to the stage
			rm.root.addChild(mainView.view);
			//add the foreground layer and set it to the layoutProxy.vo
			var canvas:KCanvas = new KCanvas();
			//TODO: see if we can take this out of the skin file. 
			canvas.setSkin("clickThrough",true);
			canvas.width = 1;
			canvas.height = 1;
			_layoutProxy.vo.foreground = canvas;
			ToolTipManager.getInstance().foregroundLayer = _layoutProxy.vo.foreground;
			rm.root.addChild(canvas);
			rm.onResize(new Event(Event.RESIZE));
			
			var pm : PluginManager = PluginManager.getInstance();
			pm.updateAllLoaded(onAllPluginsLoaded);
/*			//if there are no plugins or all loaded
			if(pm.loadingQ <= 0)
				commandComplete();
			else //other listen to all plugins loaded and then continue
			{
				pm.addEventListener( PluginManager.ALL_PLUGINS_LOADED , onAllPluginsLoaded );
			}
*/		}
		
		/**
		 * Get the screens XML, create an instance of uiConf to each one, and push 
		 * it to the _screens array
		 */
		public function getAllScreens():void
		{
			var screens:Object = new Object();
			var screensXML:XML = _layoutProxy.vo.layoutXML.child('screens')[0];
			if(!screensXML)
				return;
			var allScreens:XMLList = screensXML.children();
			var uiComponent:Object;
			for each( var screen:XML in allScreens )
			{
				//build the screen assuming its 1st child is a container
				uiComponent = _layoutProxy.buildLayout(screen.children()[0]);
				//push it to _screens to retrieve it later on
				screens[screen.attribute('id')] = uiComponent;
			}
			_layoutProxy.vo.screens = screens;
		}
		
		/**
		 * Call the main build function and set the Layout Model components 
		 * @param layout xml
		 * @return main view uicomponent
		 * 
		 */		
		public function buildComponents(xml:XML):void
		{
			facade.registerMediator( new MainViewMediator( _layoutProxy.buildLayout(xml) ) );
			var mainView : MainViewMediator = facade.retrieveMediator( MainViewMediator.NAME ) as MainViewMediator;
		}
		
		private function onAllPluginsLoaded( event : Event ) : void
		{
			event.target.removeEventListener( PluginManager.ALL_PLUGINS_LOADED , onAllPluginsLoaded );
			commandComplete();
		}
	}
}