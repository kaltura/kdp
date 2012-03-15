package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.ErrorNotificationMediator;
	import com.kaltura.vo.KalturaBaseEntry;
	
	import flash.display.Sprite;
	
	import org.osmf.media.MediaResourceBase;
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 *  
	 * @author Michal
	 * 
	 */	
	public class errorNotificationPluginCode extends Sprite implements IPlugin
	{
		/**
		 * plugin's mediator
		 * */
		private var _errorNotificationMediator:ErrorNotificationMediator;
		private var _entryId:String;
		private var _resourceUrl:String;
		
		
		/**
		 * Constructor 
		 * 
		 */		
		public function errorNotificationPluginCode()
		{
		}
		
			
		public function get resourceUrl():String
		{
			return _resourceUrl;
		}

		[Bindable]
		/**
		 * that contain the media path to be loaded from 
		 * @param value
		 * 
		 */		
		public function set resourceUrl(value:String):void
		{
			_resourceUrl = value;
			if (_errorNotificationMediator)
				_errorNotificationMediator.resourceUrl = value;
		}

		public function get entryId():String
		{
			return _entryId;
		}

		[Bindable]
		/**
		 * The current entry  
		 * 
		 */
		public function set entryId(value:String):void
		{
			_entryId = value;
			if (_errorNotificationMediator)
				_errorNotificationMediator.entryId = value;
		}

		/**
		 * Initialize plugin mediator and data 
		 * @param facade KDP application facade.
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void {
			_errorNotificationMediator = new ErrorNotificationMediator(this);
			_errorNotificationMediator.entryId = _entryId;
			_errorNotificationMediator.resourceUrl = _resourceUrl;
			facade.registerMediator(_errorNotificationMediator);
		}
		
		/**
		 * Does nothing,
		 * This plugin is not visual and has no skin.
		 * @param styleName
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
			// not visual
		}
	}
}