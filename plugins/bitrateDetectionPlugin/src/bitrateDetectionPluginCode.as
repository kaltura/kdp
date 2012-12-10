package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.BitrateDetectionMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class bitrateDetectionPluginCode extends Sprite implements IPlugin
	{
		
		public static const NAME:String = "bitrateDetectionPluginCode";
		

		private var _facade:IFacade;
		private var _mediator:BitrateDetectionMediator;
		private var _downloadTimeoutMS:int = 2000;
		private var _forceBitrate:int = 0;
		private var _downloadUrl:String;
		private var _useFlavorCookie:Boolean = false;
		
		/**
		 * when true, BW won't be triggered automatically. Only if the highest available bitrate is higher than the previous preferred bitrate. 
		 */		
		public var runPreCheck:Boolean = false;

		
		public function bitrateDetectionPluginCode()
		{
		}
		
		//////// Implement IPlugin methods


		public function get forceBitrate():int
		{
			return _forceBitrate;
		}

		public function set forceBitrate(value:int):void
		{
			_forceBitrate = value;
		}

		[Bindable]
		/**
		 * Whether to use the saved flavor cookie 
		 * DEPRECATED
		 * @return 
		 * 
		 */		
		public function get useFlavorCookie():Boolean
		{
			return _useFlavorCookie;
		}

		public function set useFlavorCookie(value:Boolean):void
		{
			_useFlavorCookie = value;
		}

		[Bindable]
		/**
		 * donwload url for the bitrate detection 
		 * @return 
		 * 
		 */		
		public function get downloadUrl():String
		{
			return _downloadUrl;
		}

		public function set downloadUrl(value:String):void
		{
			_downloadUrl = value;
		}

		public function initializePlugin(facade:IFacade):void
		{
			_facade = facade;
			_mediator = new BitrateDetectionMediator(this , _forceBitrate);
			_facade.registerMediator(_mediator);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			// Do nothing here
		}
		
		[Bindable]
		/**
		 * download timeout in milliseconds 
		 * @return 
		 * 
		 */		
		public function get downloadTimeoutMS():int
		{
			return _downloadTimeoutMS;
		}
		
		public function set downloadTimeoutMS(value:int):void
		{
			_downloadTimeoutMS = value;
		}
	}
}