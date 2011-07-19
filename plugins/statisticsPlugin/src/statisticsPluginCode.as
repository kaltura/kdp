package {
	//import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.StatisticsMediator;
	
	import fl.managers.*;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class statisticsPluginCode extends Sprite implements IPlugin
	{
		
		/**
		 * set to true to disable the plugin 
		 */		
		public var statsDis  :Boolean;
		
		/**
		 * reference to this plugin's mediator 
		 */		
		private var _statisticsMediator : StatisticsMediator;
		
		public var statsDomain : String;
		
		
		/**
		 * Constructor 
		 * 
		 */		
		public function statisticsPluginCode(disStats : Boolean)
		{
			Security.allowDomain("*");
			statsDis = disStats;
		}

		
		public function initializePlugin( facade : IFacade ) : void
		{
			_statisticsMediator = new StatisticsMediator(statsDis);
			_statisticsMediator.statsDomain = statsDomain;
			facade.registerMediator( _statisticsMediator);
		}
		
		public function setSkin( styleName:String, setSkinSize:Boolean=false ):void {}
	}
}
