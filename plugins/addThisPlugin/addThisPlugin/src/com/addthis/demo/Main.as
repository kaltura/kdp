/*  
	Main Document Class
	
	Instanstiates a new simple video player then adds 
	appropriate ui for play, pause, and sharing.
	
	To learn more about the flash sharing from AddThis.
	Go to:  http://www.addthis.com/help/flash-overview
*/
package com.addthis.demo {
    // Import Share Api
    import com.addthis.demo.controls.RichShape;
    import com.addthis.demo.controls.SharingButtons;
    import com.addthis.demo.player.DemoVideoPlayer;
    import com.addthis.demo.tracking.Tracking;
    import com.addthis.share.ShareAPI;
    
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.net.URLRequest;
    import flash.system.Security;
        
    public class Main extends Sprite {
        
        /**
         * Your AddThis Publisher username. Hint: it's not "addthis"!
         */
        static private const ADDTHIS_USERNAME:String = 'addthis';
        
        /**
         * URL to your SWF.
         */
        static private const SWF_URL:String = 'http://cache.addthis.com/downloads/demo/flash/latest/AddThisDemoPlayer.swf';
       
        /**
         * URL to the page with your Flash content's metadata tags. For more information, see: 
         * 
         *      http://www.addthis.com/help/embedded-content
         * 
         */
        static private const VIDEO_PAGE:String = 'http://www.addthis.com/pages/embedded-example';
        
        /**
         * URL to a screenshot of your content. Some destinations use this as a preview.
         */
        static private const SCREENSHOT:String = 'http://cache.addthis.com/downloads/demo/flash/latest/addthisdemoplayer.png';
        
        /**
         * URL to video flv
         */        
        private const FLV_URL:String = 'http://cache.addthis.com/downloads/demo/embedded-example/at_overview_400x226_hi.flv';
        
        /**
         * URL to MENU LIB
         * private
         * 
         */
        private var ADDTHIS_MENU_LIB:String;
        private var AddThis_BASE:String;
        private var AddThis_SWF:String = 'AddThisMenuAPI.swf';
        //
        // local
        //
        // 
        // Instance Variables
        // 
        // AddThis api library
        private var api:ShareAPI;
        // Simple Video Player
        private var player:DemoVideoPlayer;
        // Reference variables for flashvar parameters
        private var playOnLoad:Boolean;
        private var showButtonsOnLoad:Boolean;
        private var params:Object;
        // Menu button
        private var sharing_bg_height:Number = 28;
        private var sharing_bg:RichShape;
        private var menuButton:RichShape;
        private var maskShape:RichShape; 
        private var maskOutline:RichShape;
        private var sharingUI:String;
        private var ui:SharingButtons;
        private var menu:Object;
        private var menu_loader:Loader;
        private var menu_icon:Bitmap;
        private var _defaultWidth:Number = 400;
        private var _defaultHeight:Number = 250;
        private var _defaultVideoWidth:Number = 400;
        private var _defaultVideoHeight:Number = 226;
        private var background:RichShape;
        /**
		* Variable: _dbg:Boolean -- private
		* @default null
		* @return nothing
		*/
		private var _dbg:Boolean = false;
        
        /*
          	User configurable options passed to the ENDPOINT via ShareAPI 
          	as an Object comprised of with these properties:
	        	url :'', 				// String URL of your page you are sharing
	        	swfurl : '', 			// String URL of your wiget SWF with any additional K/V flashvar query string
				screenshot : '',		// String URL to your widget screenshot image 	
				title : '',				// Give a title to what your are sharing
				description : '',		// Give a short description
				width : -1,				// If no value is specified it defaults to -1. Assign your widget width 
				height : -1 			// If no value is specified it defaults to -1. Assign your widget height
				
				SO WHY ONLY VIDEO_PAGE or url ?
				Best case scenario would be to utilize the meta tags specified from your sharing page. To find our more
				check  http://www.addthis.com/help/embedded-content#tagging
         */         
        private var sharingOptions:Object =	{	url: VIDEO_PAGE };
        //
        // Google Analytics Tracking
        //
        public var ga_tracker:Tracking;
        // Main
        public function Main() {
            super();
			// Setup Stage properties
            Security.allowDomain('*');
            Security.allowInsecureDomain('*');
            // NO_SCALE, and align TL.  
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
           	api = new ShareAPI(ADDTHIS_USERNAME);
           	background = new RichShape();
           	sharing_bg = new RichShape();
            addChild(api);
            addChild(background);
            addChild(sharing_bg);
            
            maskShape = new RichShape();
            background.drawRoundedRectangle(100, 100, 6, 0xFFFFFF, 0x000000, 0x0000000, 1);
            maskShape.drawRoundedRectangle(100, 100, 6, 0x333333, 0xFFFFFF, 0xFFFFFF, 1);
            maskOutline =  new RichShape();
            maskOutline.drawOutline(100,100,6,0x000000,1);
            mask = maskShape;
            this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
        }
        
        private function shareFacebook( evt:Event ):void {
            api.share(VIDEO_PAGE,'facebook', sharingOptions);
            outputObjects({url:VIDEO_PAGE, service:'facebook'}, sharingOptions, 'facebook');
        }
        
        private function shareTwitter( evt:Event ):void {
            api.share(VIDEO_PAGE, 'twitter', sharingOptions);
            outputObjects({url:VIDEO_PAGE, service:'twitter'}, sharingOptions, 'twitter');
        }
        
        private function shareIGoogle( evt:Event ):void {
            api.share(VIDEO_PAGE,'igoogle', sharingOptions);
            outputObjects({url:VIDEO_PAGE, service:'igoogle'}, sharingOptions, 'igoogle');
        }

        private function shareEmail( evt:Event ):void {
            api.share(VIDEO_PAGE,'email', sharingOptions);
            outputObjects({url:VIDEO_PAGE, service:'email'}, sharingOptions, 'email');
        }
        
        private function shareMore( evt:Event=null ):void {
            api.share(VIDEO_PAGE,'menu', sharingOptions);
            outputObjects({url:VIDEO_PAGE, service:'menu'}, sharingOptions, 'menu');
        }
        
        private function showMenu(evt:Event):void{
        	flog(ADDTHIS_MENU_LIB);
        	menu_loader = new Loader();
            menu_loader.load(new URLRequest(ADDTHIS_MENU_LIB));
            menu_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadmenu);
            addChild(menu_loader);
        }
        
        private function loadmenu(e:Event):void{
        	menu = e.currentTarget.content;
        	menu.configure(VIDEO_PAGE);
        	menu.show("AddThis", 1, 3);
        	
        	// align above menu window
           	menu_loader.y = (_stageHeight()-sharing_bg_height) - (menu.height + 5);
	        menu_loader.x = (_stageWidth() - (menu.width + 5));
        }
        
        private function addedToStage( evt:Event=null ):void {
         	// Get flash vars if present       	
            params = stage.loaderInfo.parameters;
     
        	flog(this+'.onAddedToStage()');
        	// Setup Tracking
            ga_tracker = new Tracking(this);
            ga_tracker.trackPageView();
            //
            flog('root url:', root.loaderInfo.url);
            AddThis_BASE = (AddThis_BASE != null)? AddThis_BASE : findAbsolutePath(root.loaderInfo.url);
            ADDTHIS_MENU_LIB = AddThis_BASE + AddThis_SWF;
           
            // instantiate a new player
            // then add to stage
            var widthToHeightRatio:Number = _defaultVideoWidth/_defaultVideoHeight;
            player = new DemoVideoPlayer(FLV_URL, ga_tracker, showButtonsOnLoad);
            player.width = (_stageHeight()-sharing_bg_height)*widthToHeightRatio;		//_stageWidth();
            player.height = (_stageHeight()-sharing_bg_height);
            player.x = _stageWidth()/2 - player.width/2;
            
          	addChildAt(player, 2);
        
            if (params.auto_play == 'true' && params.auto_play != null) {
            	playOnLoad = true;	
            } else {
            	playOnLoad = false;
            }
            
            if (params.show_buttons == 'false' && params.show_buttons != null) {
            	showButtonsOnLoad = false;
            } else {
            	showButtonsOnLoad = true;
            }
            
            
            if (params.menu == 'false' || params.menu == '0') {
            	sharingUI = 'buttons';
	            ui = new SharingButtons();
				ui.facebookButton.addEventListener(MouseEvent.CLICK, shareFacebook);
				ui.twitterButton.addEventListener(MouseEvent.CLICK, shareTwitter);
				ui.igoogleButton.addEventListener(MouseEvent.CLICK, shareIGoogle);
				ui.emailButton.addEventListener(MouseEvent.CLICK, shareEmail);
				ui.moreButton.addEventListener(MouseEvent.CLICK, shareMore);
				
	            addChild(ui);
	            
            } else {
            	// Create Menu Button
            	sharing_bg.drawRoundedRectangle(_stageWidth(), sharing_bg_height, 0, 0x999999, 0x666666, 0x000000);
            	sharingUI = 'menu';
            	
            	menuButton = new RichShape(true);
            	menuButton.addEventListener(MouseEvent.CLICK, showMenu);
	            menuButton.drawRoundedRectangle(62, 20, 4, 0x5d5d5d, 0x999999, 0x303030);
	        	menuButton.setLabel({color:0xFFFFFF, profile:'Share', alpha:1, size:12});
	        	menuButton.label.x = 18;
	        	menu_icon = SharingButtons.moreIcon;
	        	menuButton.addChild(menu_icon);
            	menu_icon.x += 5;
            	menu_icon.y = (menuButton.height/2 - menu_icon.height/2);
            	menuButton.label.x = menu_icon.x + menu_icon.width + 2;
            	menuButton.label.y -= .5;
            	
	        	addChild(menuButton);
            }
            
            
            if (playOnLoad) {
                /*
                	HOW TO PASS PARAMETERS TO THE ENDPOINT:
                	
                	In order to pass flashvars to your widget, you must create a swfurl
                	with the k/v pairs appended as a query string. For example,
                	
                	http://foo.bar.com/foos.swf?key=value&key=value&key=value etc..
                	
                	then assign this as the value to swfurl property of sharingOptions.
                	The sharingOptions object will be passed to the ShareAPI lib   
                	
                	uncomment below:
                */
                // sharingOptions['swfurl'] = SWF_URL + '?auto_play=' + params.auto_play;
                // trace('sharing string appended:', sharingOptions['swfurl']);
                
                player.play();
            }
            
            if (!showButtonsOnLoad) {
            	// By default the buttons
            	// appear as a sharing bar
            	// footer
            	ui.visible = false;
            	ui.buttonMode = false;
            }
           
			background.drawRoundedRectangle(_stageWidth(), _stageHeight(), 6, 0xFFFFFF, 0x000000, 0x000000, 1);           
            maskShape.drawRoundedRectangle(_stageWidth(), _stageHeight(), 6, 0x999999, 0xFFFFFF, 0xFFFFFF, 1);
           	maskOutline.drawOutline(_stageWidth()-1, _stageHeight()-1,6,0x000000,1);
           	addChild(maskOutline);
            stage.addEventListener(Event.RESIZE, render);
           	flog('Added To Stage Specifics:');
           	renderInfo();	
           	render();
        }
        
        public function render( evt:Event=null ):void {
            flog(this+'.render()');   
            var widthToHeightRatio:Number = _defaultVideoWidth/_defaultVideoHeight;
            
            player.width = (_stageHeight()-sharing_bg_height)*widthToHeightRatio;
            player.height = (_stageHeight()-sharing_bg_height);
            player.x = _stageWidth()/2 - player.width/2;
            //player.visible = false;
            
            player.render();
            
            if (sharingUI=='buttons') {
            	ui.render();
            	// Center Buttons
            	// center on x axis
            	ui.x = _stageWidth()/2 - ui.width/2;
            	// center of bar
            	ui.y = _stageHeight() - (ui.height + 4);
            } else {
            	menuButton.x = _stageWidth() - (menuButton.width + 5);
	           	menuButton.y = _stageHeight() - (menuButton.height + 5);
            }
            
			sharing_bg.drawRoundedRectangle(_stageWidth(), sharing_bg_height, 0, 0x999999, 0x666666, 0x000000);
			sharing_bg.x = 0;
			sharing_bg.y = _stageHeight()-sharing_bg_height;   
			background.drawRoundedRectangle(_stageWidth(), _stageHeight(), 6, 0xFFFFFF, 0x000000, 0x000000, 1); 
            maskShape.drawRoundedRectangle(_stageWidth(), _stageHeight(), 6, 0x999999, 0xFFFFFF, 0xFFFFFF, 1);
           	maskOutline.drawOutline(_stageWidth()-1, _stageHeight()-1,6,0x000000,1);
   			flog('On Render Specifics:');
   			renderInfo();	
        }
        
        public function flog(...rest:*):void {
        	var _rest:String = replace(rest.toString(), ',', ' ');
        	trace(_rest);
        	if (dbg)
        		ExternalInterface.call('console.log', _rest);
        }
        
        private function outputObjects(params:Object, share:Object, caller:String=''):void {
        	flog(this+'.outputObjects()');
        	var objects:Object = { p:params, s:share }
        	for (var prop:String in objects) {
        		if(objects[prop] is Object) {
        			flog(prop, ':', objects[prop],':', objects[prop] is Object);
        			objectMeta(objects[prop], caller)
        		}
        	}	
        }

        private function objectMeta(value:Object, caller:String=''):void {
        	for (var prop:String in value) {
        		flog((caller !='')? caller : '', value, 'has property:[', prop, '] with value: [', value[prop],']');
        	}
        }
        private function findAbsolutePath(url:String):String {
        	var match:int = url.lastIndexOf('/');
        	var baseDir:String = url.substring(0, match) + '/';
        	return baseDir;
        }
        
        private function replace(str:String, oldSubStr:String, newSubStr:String):String {
       		return str.split(oldSubStr).join(newSubStr);
        }
        
        private function renderInfo():void {
        	flog('Player Width:', player.width);
            flog('Player Height:', player.height);
            flog('Sharing BG: ', sharing_bg.width, ':', sharing_bg.height);
            flog('Mask Info: ', maskShape.width, ':', maskShape.height);
            flog('Mask Outline: ', maskOutline.width, ':', maskOutline.height);
        }
        
        private function _stageWidth(value:Number=0):Number {
        	return (stage.stageWidth == 0)? _defaultWidth-value : stage.stageWidth;
        }
        
        private function _stageHeight(value:Number=0):Number {
        	return (stage.stageHeight == 0)? _defaultHeight-value : stage.stageHeight;
        }
        
        override public function toString():String {
            return '[AddThisDemoPlayer]';
        }
        
		/**
		* GETTER: dbg:Boolean
		* @default _dbg value
		* @return _dbg value
		*/
		public function get dbg():Boolean { return _dbg; }
    }
}
