package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public dynamic class FacadeCode extends Sprite implements IPlugin
	{
		public function FacadeCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			facade.registerMediator(new FacadeMediator("facadeStubMediator", this));
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
	}
}