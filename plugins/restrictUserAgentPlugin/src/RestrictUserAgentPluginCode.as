package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.RestrictUserAgentMediator;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class RestrictUserAgentPluginCode extends UIComponent implements IPlugin
	{
		private var _restrictUserAgentMediator : RestrictUserAgentMediator;
		[Bindable]
		public var restrictedUserAgents : String;
		[Bindable]
		public var restrictedUserAgentTitle : String = "User Agent Restricted";
		[Bindable]
		public var restrictedUserAgentMessage : String = "We're sorry, this content is not available for certain user agents."
		
		public function RestrictUserAgentPluginCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_restrictUserAgentMediator = new RestrictUserAgentMediator (null, this );
			
			facade.registerMediator( _restrictUserAgentMediator );
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
	}
}