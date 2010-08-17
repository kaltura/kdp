package {
	//import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.TmMediator;
	
	import fl.managers.*;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class TmStatsPluginCode extends Sprite implements IPlugin
	{
		
		/**
		 * set to true to disable the plugin 
		 */		
		public var statsDis  :Boolean;
		
		/**
		 * reference to this plugin's mediator 
		 */		
		private var _statisticsMediator : TmMediator
		
		
		/**
		 * The Marker hit page path  
		 */
		public var hitPath : String;
		
		
		
		/**
		 * Constructor 
		 * 
		 */		
		public function TmStatsPluginCode(disStats : Boolean)
		{
			Security.allowDomain("*");
			statsDis = disStats;
		}

		
		public function initializePlugin( facade : IFacade ) : void
		{
			_statisticsMediator = new TmMediator(statsDis);
			_statisticsMediator.path = hitPath;
			facade.registerMediator( _statisticsMediator);
		}
		
		public function setSkin( styleName:String, setSkinSize:Boolean=false ):void {}
	}
}
