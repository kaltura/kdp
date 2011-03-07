package
{
	import com.kaltura.kdpfl.model.ExternalInterfaceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.AnnotationsDataMediator;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.strings.NotificationStrings;
	
	import fl.core.UIComponent;
	
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class AnnotationsDataPluginCode extends UIComponent implements IPlugin
	{
		// Class constants
		
		public static const GET_CHAPTER_DATA : String = "getChapterData";
		
		// Input parameters
		protected var _rootAnnotationId : String;
		
		protected var _sortOrder : String;
		
		// Standard pluginCode variables
		private var _annotationsDataMediator : AnnotationsDataMediator;
		
		private var _isInit : Boolean = false;
		
		// Externalised params
		protected var _annotationsGroup : Array;
		protected var _activeChapterId : String;
		
		public function AnnotationsDataPluginCode()
		{
			super();
			Security.allowDomain("*");
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_annotationsDataMediator = new AnnotationsDataMediator(this);
			facade.registerMediator(_annotationsDataMediator);
			registerCallback(facade);
			_isInit = true;
			
			if (rootAnnotationId)
				_annotationsDataMediator.sendNotification( NotificationStrings.RETRIEVE_ANNOTATIONS );
			
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		[Bindable]
		public function get rootAnnotationId():String
		{
			return _rootAnnotationId;
		}

		public function set rootAnnotationId(value:String):void
		{
			_rootAnnotationId = value;
			if (_isInit)
				_annotationsDataMediator.sendNotification( NotificationStrings.RETRIEVE_ANNOTATIONS);
		}
		[Bindable]
		public function get sortOrder():String
		{
			return _sortOrder;
		}

		public function set sortOrder(value:String):void
		{
			_sortOrder = value;
		}
		[Bindable]
		public function get annotationsGroup():Array
		{
			return _annotationsGroup;
		}

		public function set annotationsGroup(value:Array):void
		{
			_annotationsGroup = value;
		}

		public function get activeChapterId():String
		{
			return _activeChapterId;
		}

		public function set activeChapterId(value:String):void
		{
			var prevChapter : String = _activeChapterId;
			_activeChapterId = value;
			_annotationsDataMediator.sendNotification(NotificationStrings.ACTIVE_CHAPTER_CHANGED, {previousChapter: prevChapter, activeChapter: activeChapterId} );
		}
		
		//Private methods
		
		private function registerCallback (facade : IFacade) : void
		{
			var externalInterfaceProxy : ExternalInterfaceProxy = facade.retrieveProxy(ExternalInterfaceProxy.NAME) as ExternalInterfaceProxy;
			
			externalInterfaceProxy.addCallback(GET_CHAPTER_DATA,  getChapterData);
		}
		
		private function getChapterData (id : String=null) : Array
		{
			if (annotationsGroup && annotationsGroup.length) {
				var dataArray : Array = new Array();
				
				for (var index : int; index < annotationsGroup.length; index++) {
					if (id) 
					{
						if(annotationsGroup[index].id == id) {
							dataArray.push(annotationsGroup[index].text);
						}
					}
					else
					{
						dataArray.push(annotationsGroup[index].text);
					}
	
				}
				
				return dataArray;
			}
			
			return null;
		}


	}
}