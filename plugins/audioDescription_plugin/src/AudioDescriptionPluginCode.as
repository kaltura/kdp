package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.AudioDescription;
	import com.kaltura.kdpfl.plugin.component.AudioDescriptionMediator;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class AudioDescriptionPluginCode extends UIComponent implements IPlugin
	{
		private var _attributeAudioDescription : String;
		private var _audioDescriptionMediator : AudioDescriptionMediator;
		private var _myWidth:Number = 0;
		private var _myHeight:Number = 0;
		private var _file:String = "";
		/**
		 * volume of audio description. should be between 0-1 
		 */		
		public var volume:Number = 1;
		/**
		 * state of audio description plugin 
		 */		
		public var state:Boolean = true;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function AudioDescriptionPluginCode()
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
			_audioDescriptionMediator = new AudioDescriptionMediator( new AudioDescription() );
			//_audioDescriptionMediator.file = _file;
			_audioDescriptionMediator.audioDescriptionPluginCode = this;
			facade.registerMediator( _audioDescriptionMediator);
			addChild( _audioDescriptionMediator.view );
		}
		
 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}
 		
		public function set attributeAudioDescription( value : String ) : void
		{
			trace("attributeAudioDescription: " + value);
			attributeAudioDescription = value;
			_audioDescriptionMediator.view.alpha = 0.8; //Example...
		}
		
		public function get attributeAudioDescription() : String
		{
			return attributeAudioDescription;
		}
		
		override public function set width(value:Number):void
		{
			_myWidth = value;
			trace(_myWidth + "," + _myHeight);
		}			
		
		override public function set height(value:Number):void
		{
			_myHeight = value;
			trace("Set: " + _myWidth + "," + _myHeight);
			_audioDescriptionMediator.setScreenSize(_myWidth, _myHeight);
		}			
 		
		public function set file( value : String ) : void
		{
			_file = value;
		}
		
		public function get file ():String{
			return _file;
		}
	}
}
