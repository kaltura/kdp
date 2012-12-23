package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.CaptureThumbnailMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class captureThumbnailPluginCode extends Sprite implements IPlugin
	{
		
		private var _shouldSetAsDefault : String = "true";
		
		// These strings are configurable through the uiconf xml
		public var error_capture_thumbnail : String = "An error occurred while trying to capture thumbnail.";
		public var error_capture_thumbnail_title : String = "Error Capture Thumbnail";		
		public var capture_thumbnail_success : String = "New thumbnail has been saved.";
		public var set_as_default_success : String = "New thumbnail has been set."
		public var capture_thumbnail_not_supported : String = "Capture Thumbnail is not supported for this media";
		public var capture_thumbnail_success_title : String = "Capture Thumbnail";
		public var capture_thumbnail_service_forbidden_title : String = "Service Forbidden";
		public var capture_thumbnail_service_forbidden : String = "You do not have the permission level required to set a new default thumbnail.\n Your thumbnail has been added to the list of entry thumbnails.";
		public var capture_thumbnail_process : String = "Please wait..."
		public var capture_thumbnail_process_title : String = "Processing";
		
		public function captureThumbnailPluginCode()
		{
		}
		
		public function initializePlugin( facade : IFacade ) : void
		{
			var captureTumbnailMediator : CaptureThumbnailMediator = new CaptureThumbnailMediator( null, this ); 
			facade.registerMediator( captureTumbnailMediator );
		}
		
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void{}

		public function get shouldSetAsDefault():String
		{
			return _shouldSetAsDefault;
		}

		public function set shouldSetAsDefault(value:String):void
		{
			_shouldSetAsDefault = value;
		}



	}
}
