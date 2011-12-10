package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.NielsenMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public dynamic class nielsenCombinedPluginCode extends Sprite implements IPlugin
	{
		public var clientid:String = "12345";        // Required; Nielsen assigned client ID
		public var vcid:String =     "";             // Required  only for Video Census; id assigned by Nielsen to lowest level of Marketview hierarchy 
		
		// Required parameters only if using IAG
		public var sid:String =  "";                                  
		public var tfid:String =  "";
		
		// GGend - no comma after this var
		public var msgint:String =  "";             // Optional. to specify additional messages per stream. by default, start and end streams get a msg each
		public var sfcode:String =  "us";
		public var cisuffix:String =  "";
		public var prod:String =  "vc";
		public var nolTags:String = "";
		public var updateInterval:Number = 3;
		public var allowedAdTypes:String = "preroll, midroll,  postroll, brandedslate, interactive";
		
		public var _nolggGlobalParams:Object;
		
		private var _nielsenMediator:NielsenMediator;

		public function nielsenCombinedPluginCode()
		{
			//TODO: implement function
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			this._nolggGlobalParams = {
				clientid:this.clientid,                     // Required; Nielsen assigned client ID
					vcid:this.vcid,                           // Required  only for Video Census; id assigned by Nielsen to lowest level of Marketview hierarchy 
					
					// Required parameters only if using IAG
					sid: this.sid,                                  
					tfid: this.tfid,
					
					// GGend - no comma after this var
					msgint: this.msgint,                    // Optional. to specify additional messages per stream. by default, start and end streams get a msg each
					sfcode: this.sfcode,
					cisuffix: this.cisuffix,
					prod: this.prod,
					nolTags: this.nolTags
			};
			trace("Nielsen/Kaltura Plugin Loaded");
			
			ggCom.getInstance( _nolggGlobalParams ).setNOLconfigparams(_nolggGlobalParams);
			_nielsenMediator = new NielsenMediator();
			_nielsenMediator._dynamicClass = this;
			facade.registerMediator(_nielsenMediator);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			//TODO: implement function
		}
	}
}