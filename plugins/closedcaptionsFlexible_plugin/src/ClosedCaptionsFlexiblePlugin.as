package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptions;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class ClosedCaptionsFlexiblePlugin extends Sprite implements IPluginFactory
	{
		public function ClosedCaptionsFlexiblePlugin():void
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new ClosedCaptionsFlexiblePluginCode();
		}
	}
}