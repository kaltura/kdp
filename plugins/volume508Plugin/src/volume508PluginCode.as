package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Volume508;
	import com.kaltura.kdpfl.plugin.component.Volume508Mediator;
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class volume508PluginCode extends UIComponent implements IPlugin
	{
		private var _volume508Mediator : Volume508Mediator;
		private var _backbtn:KButton;
		private var _backbtnName:String;
		private var _fwdbtn:KButton;
		private var _fwdbtnName:String;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function volume508PluginCode()
		{
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			// Register Proxy
			//facade.retrieveProxy(
			
			// Register Mideator
			_volume508Mediator = new Volume508Mediator( new Volume508() );
			facade.registerMediator( _volume508Mediator);
			addChild( _volume508Mediator.view );
		}
		
 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}
		
		public function get attributeVolume508() : String
		{
			return attributeVolume508;
		}
	}
}
