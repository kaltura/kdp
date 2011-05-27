package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Shortcuts508Mediator;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;

	public dynamic class Shortcuts508PluginCode extends UIComponent implements IPlugin
	{
		private var _disableShortcuts : Boolean = false;
		
		private var _shortcuts508Mediator : Shortcuts508Mediator;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function Shortcuts508PluginCode()
		{
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			
			_shortcuts508Mediator = new Shortcuts508Mediator( this );
			facade.registerMediator( _shortcuts508Mediator);
			//addChild( _shortcuts508Mediator.view );
			//_shortcuts508Mediator.added ();
		}
		
 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}

		
		
		[Bindable]
		public function get disableShortcuts():Boolean
		{
			return _disableShortcuts;
		}

		public function set disableShortcuts(value:Boolean):void
		{
			_disableShortcuts = value;
			/*if (_shortcuts508Mediator.view)
			{
				(_shortcuts508Mediator.view as Shortcuts508).disableShortcuts = value;
			}*/
		}

	}
}
