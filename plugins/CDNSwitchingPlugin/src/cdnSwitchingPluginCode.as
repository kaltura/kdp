package
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.CDNSwitchingMediator;
	
	import fl.core.UIComponent;
	
	import mx.core.mx_internal;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class cdnSwitchingPluginCode extends UIComponent implements IPlugin
	{
		protected var _cdnSwitchingMediator : CDNSwitchingMediator;
		
		protected var _secondaryStorageId : String;
		
		protected var _minimalAcceptableBR : Number;
		
		protected var _minimalBRTimecap : Number;
		
		public function cdnSwitchingPluginCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_cdnSwitchingMediator = new CDNSwitchingMediator(null, this );
			
			facade.registerMediator( _cdnSwitchingMediator );
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
		[Bindable]
		public function get secondaryStorageId():String
		{
			return _secondaryStorageId;
		}

		public function set secondaryStorageId(value:String):void
		{
			_secondaryStorageId = value;
		}
		[Bindable]
		public function get minimalAcceptableBR():Number
		{
			return _minimalAcceptableBR;
		}

		public function set minimalAcceptableBR(value:Number):void
		{
			_minimalAcceptableBR = value;
		}
		[Bindable]
		public function get minimalBRTimecap():Number
		{
			return _minimalBRTimecap;
		}

		public function set minimalBRTimecap(value:Number):void
		{
			_minimalBRTimecap = value;
		}


	}
}