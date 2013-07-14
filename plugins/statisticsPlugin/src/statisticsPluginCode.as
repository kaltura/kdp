package {
	//import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.StatisticsMediator;
	
	import fl.managers.*;
	
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class statisticsPluginCode extends Sprite implements IPlugin
	{
		
		[Embed(source="patch_domain.bin", mimeType="application/octet-stream")]
		private const EmbeddedDomainData:Class;
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
		 * set true to disable Buffer_start and Buffer_end stats 
		 */		
		public var bufferStatsDis:Boolean;
		
		/**
		 * name of externalInterface function to call when stats event is sent
		 * */
		public var trackEventMonitor:String;
		
		
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
			var embeddedData:ByteArray = new EmbeddedDomainData() as ByteArray;
			var embeddedString:String = embeddedData.toString();
			if (!statsDomain && embeddedString != "\x00\x00\x00\x00KALTURA_STATSDOMAIN_DATA")
				statsDomain = embeddedString;
			_statisticsMediator = new StatisticsMediator(statsDis);
			_statisticsMediator.statsDomain = statsDomain;
			_statisticsMediator.bufferStatsDis = bufferStatsDis;
			_statisticsMediator.trackEventMonitor = trackEventMonitor;
			facade.registerMediator( _statisticsMediator);
		}
		
		public function setSkin( styleName:String, setSkinSize:Boolean=false ):void {}
	}
}
