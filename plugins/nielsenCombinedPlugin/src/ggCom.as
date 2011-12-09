/** 
* ggCom class (Actionscript 3)
* Used to pass data to Nielsen 
*
* Copyright (c) 2008-2010 The Nielsen Company.  All rights reserved. 
* .  Decompiling, reverse engineering, copying or unauthorized redistribution is prohibited.    
**/

package 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	public class ggCom extends Sprite 
 {

   // ********************** Start Customer Editable variables and functions. DO NOT EDIT ABOVE THIS LINE ************************************** 
   public var _nolggGlobalParams:Object = {
      clientid:"",                  // Required; Nielsen assigned client ID
      vcid:    "",                  // Required  only for Video Census; id assigned by Nielsen to lowest level of Marketview hierarchy 
      msgint: "",                    // Optional. to specify additional messages per stream. by default, start and end streams get a msg each
      sfcode: "us",
      cisuffix: "",
      prod: "vc",
      pd: "",
      sid: "",
      tfid: ""      
   }; 
   
   public var _ldrParams:String;
   		

		// set to true is Javascript interface is needed for calls to gg; if enableJSInterface is set to true and you use <embed> tag for your player, 
		// make sure that "allowScriptAccess" parameter is set to "always". Runtime error will happen otherwise. 
		private var enableJSinterface: Boolean = false;
		public function getUserID( ):String 
		{
			return null;// optionally set userid here (max 32 chars) 
		}
		// Additional custom video information can be sent to Glance Guide by using this method.  Call it each time before a load video event occurs.
		// NOTE: Use the following xml syntax: <p1>value</p1> .... <pn>value</pn>
		public function setVideoInfo( videoInfo:String ):void 
		{
			PM( "videoInfo", videoInfo );
		};	
   
//*
// ********************** End Customer Editable variables and functions. DO NOT EDIT BELOW THIS LINE ************************************** 
//*
   //additional config parameters (default values if there are no Flashvars)
   // called from ggBC3Plugin.as
   public function setNOLconfigparams(lip:Object) : void
   {
	 if (lip['clientid'] != null)
     	_nolggGlobalParams.clientid = lip['clientid'];
     if (lip["vcid"] != null)
       _nolggGlobalParams.vcid = lip['vcid'];         
     if (lip['msgint'] != null)
        _nolggGlobalParams.msgint = lip['msgint'];         
     if (lip['sfcode'] != null)
        _nolggGlobalParams.sfcode = lip['sfcode'];     
     if (lip['cisuffix'] != null)
        _nolggGlobalParams.cisuffix = lip["cisuffix"];     
     if (lip["prod"] != null)
        _nolggGlobalParams.prod = lip['prod'];     
     if (lip["sid"] != null)
        _nolggGlobalParams.sid = lip['sid'];     
     if (lip["tfid"] != null)
        _nolggGlobalParams.tfid = lip['tfid'];
	 if (lip["nolTags"] != null)
		 _ldrParams = lip['nolTags'];   
   }
   
		private static var ggComInstance:ggCom = null;
		private static var ggComCreate:Boolean = false;
		private var GGSWFCONNECTIONRETRY:Number = 5;
		private var GGSWFLOADRETRY:Number = 2;		
		private var GGMAXQUEUESIZE:Number = 10000;  
   		private var GGSWFADDRESS:String;  
		private var GGSWFLOADERRORADDRESS:String = "http://dz.glanceguide.com/errl.php";			
		private var ggPlayerType:String = "gen3flvplayer";
		private var ggConnection:LocalConnection = new LocalConnection( );
		private var ggConnectionName:String;
		private var ggConnectionRetry:Number = 0;
		private var ggLoadRetry:Number = 0;		
		private var ggLoader:Loader = new Loader( ); 
		private var ggEventQueue:Array = new Array( );
		private var ggLoaded:Boolean = false;
		private var ggHasStage:Boolean = false;

		//--------------------------------------------------------------------------
		// public methods
		//--------------------------------------------------------------------------

		/**
		 *  Method used by JavaScript
		 */
		public function PCM( functionType:String, ...param ):void 
		{
			PM( functionType, param[0], param[1], param[2], param[3] );
		}
		/**
		 *  variable param length
		 */
		public function PM( functionTypeIn:Object, ...param ):void 
		{
			var functionType:String = functionTypeIn.toString();
			if ( ggLoaded ) 
				ggConnection.send( ggConnectionName, "ggProcessMetricAC3", functionType, new Date( ).getTime( ), param[0], param[1], param[2], param[3] );
			else if ( ggEventQueue.length < GGMAXQUEUESIZE ) 
			{
				ggEventQueue.push( functionType );
				ggEventQueue.push( new Date( ).getTime( ));
				ggEventQueue.push( param[0] );
				ggEventQueue.push( param[1] );
				ggEventQueue.push( param[2] );
				ggEventQueue.push( param[3] );
			}
		}
		/**
		 *  Static method to retrieve single ggCom object
		 */
		public static function getInstance( param:Object = null ):ggCom 
		{				
			if ( ggComInstance == null ) 
			{
				var baseCode:String;
				if(param && param['sfcode'])
					baseCode = param['sfcode'];
				ggComCreate = true;
				ggComInstance = new ggCom( baseCode );
				ggComCreate = false;
			}
			return ggComInstance;
		}
		/**
		 *  Public method to push FlashVar changes into ggCom
		 */
		public function setStage( stageConnector:Object ):void 
		{
			stageConnector.stage.addChild( this );
			ggHasStage = true;
		}
		/**
		 *  Instantiate ggCom
		 */
		public function ggCom( baseCode:String = null ) 
		{ 
			trace('ggCom Built');
			if ( !ggComCreate )   
        		return;
			if(baseCode)
				_nolggGlobalParams.sfcode = baseCode;
			GGSWFADDRESS = "http://secure-" + _nolggGlobalParams.sfcode + ".imrworldwide.com/novms/gn/3/ggce380.swf"; 
	     	//GGSWFADDRESS = "http://gg-dev.glanceguide.com/beacons/as/3/ggce380.swf"; 
	     	//GGSWFADDRESS = "http://localhost/ggce360.swf";      
			Security.allowDomain( "*" );
			//Security.allowInsecureDomain( GGSWFADDRESS );
	     	if (enableJSinterface && ExternalInterface.available)			
			    ExternalInterface.addCallback( "ggPCM", PCM );
			ggConnection.addEventListener( StatusEvent.STATUS, onGGSwfConnectionStatus );
			loadGGSWF( );
		}		
		

		//--------------------------------------------------------------------------
		// private methods
		//--------------------------------------------------------------------------

		private function loadGGSWF( ):void 
		{
			ggLoader = new Loader( );
			ggLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadGGSwfHandler );
			ggLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onLoadGGSwfIoErrorHandler );
			ggLoader.load( new URLRequest( GGSWFADDRESS ));
		}
		private function emptyEventQueue( ):void 
		{
			var queueLength:Number = ggEventQueue.length;
			for (var i:Number = 0; i < queueLength; i += 6) 
				ggConnection.send( ggConnectionName, "ggProcessMetricAC3", ggEventQueue[ i ], ggEventQueue[ i + 1 ], ggEventQueue[ i + 2 ], ggEventQueue[ i + 3 ], ggEventQueue[ i + 4 ], ggEventQueue[ i + 5 ] );
			ggEventQueue.length = 0;
		}
		private function makeGGSwfConnection( ):void 
		{
			if ( ggConnectionRetry < GGSWFCONNECTIONRETRY ) 
			{
			   	var paramStr:String= ""; 
			   	var name:String;
			   	for (name in _nolggGlobalParams)
				  	paramStr += "<" + name + ">" + _nolggGlobalParams[name] + "</" + name + ">";  
				//ggConnectionName = ggLoader.content.name;	
				trace('paramStr == '+paramStr);
				ggConnection.send( ggConnectionName, "ggInitializeAC3", ggPlayerType, getUserID( ), paramStr);
	      		//PM(51,root.loaderInfo.url);				
			}
		}		
		private function ggSwfConnectionSuccess( ):void 
		{
			ggLoaded = true;
			trace('beacon loaded');
			emptyEventQueue( );
		}
		private function onGGSwfConnectionStatus( event:StatusEvent ):void 
		{
			if ( ggLoaded ) 
				return;
				
			switch ( event.level ) 
			{
				case "status" :
					ggSwfConnectionSuccess( );
					break;
				case "error" :
					ggConnectionRetry++;
					makeGGSwfConnection( );
					break;
			}
		}
		private function onLoadGGSwfHandler( event:Event ):void 
		{
			ggConnectionName = event.target.content.pId;
			this.addChild( ggLoader );
			setTimeout( makeGGSwfConnection, 500 );
		}
		private function onLoadGGSwfIoErrorHandler( event:IOErrorEvent ):void 
		{
			if ( ggLoadRetry < GGSWFLOADRETRY ) 
			{
				ggLoadRetry++;
				loadGGSWF( );
			} 
			else 
				sendLoadGGSWFFail( );
		}

		private function sendLoadGGSWFFail( ):void 
		{
			ggLoader = new Loader( );
			ggLoader.load( new URLRequest( GGSWFLOADERRORADDRESS + "?clientid=" + _nolggGlobalParams.clientid + "&code=ggLoadFailed&cts=" + new Date( ).getTimezoneOffset( ) / -60 + "," + new Date( ).getTime( )));
		}
	}
}