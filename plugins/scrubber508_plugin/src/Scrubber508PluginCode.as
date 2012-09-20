package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Scrubber508;
	import com.kaltura.kdpfl.plugin.component.Scrubber508Mediator;
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class Scrubber508PluginCode extends UIComponent implements IPlugin
	{
		private var _scrubber508Mediator : Scrubber508Mediator;
		private var _backbtn:KButton;
		private var _backbtnName:String;
		private var _fwdbtn:KButton;
		private var _fwdbtnName:String;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function Scrubber508PluginCode()
		{
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			_backbtn = facade ["bindObject"][_backbtnName] as KButton;
			_fwdbtn = facade ["bindObject"][_fwdbtnName] as KButton;
			// Register Proxy
			//facade.retrieveProxy(
			
			// Register Mideator
			_scrubber508Mediator = new Scrubber508Mediator( new Scrubber508() );
			_scrubber508Mediator.backbtn = _backbtn;
			_scrubber508Mediator.fwdbtn = _fwdbtn;
			facade.registerMediator( _scrubber508Mediator);
			addChild( _scrubber508Mediator.view );
		}
		
 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}
		
		public function get attributeScrubber508() : String
		{
			return attributeScrubber508;
		}
		
		[Bindable]
		public function set backbtn(value:String):void
		{
			_backbtnName = value;
		}

		public function get backbtn():String
		{
			return _backbtnName;
		}
		
		[Bindable]
		public function set fwdbtn(value:String):void
		{
			_fwdbtnName = value;
		}

		public function get fwdbtn():String
		{
			return _fwdbtnName;
		}
	}
}
