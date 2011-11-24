/*  
	Very Simple Video Player 
	
	Takes an flv, loads it, and plays or pauses. When 
	instantiated a reference to an available GA tracker
	can be used by the video player
	
	Tracking: play, pause, replay, and total video loaded. 
*/
package com.addthis.demo.player {
    import com.addthis.demo.controls.*;
    import com.addthis.demo.tracking.Tracking;
    
    import flash.display.Sprite;
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import flash.external.ExternalInterface;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.utils.Timer;
    
    public class DemoVideoPlayer extends Sprite {
		private var _video:Video;
		private var _stream:NetStream;
		private var _netConnection:NetConnection;
		private var _infoClient:Object;
		private var _isPlaying:Boolean;
		private var _isPaused:Boolean;
		private var _isComplete:Boolean;
		private var _videoMeta:Object;
		
		private var video_bg:RichShape = new RichShape();
		private var play_button:RichShape = new RichShape(true);
		private var play_button_bg:RichShape = new RichShape();
		private var play_button_tri:RichShape = new RichShape();
		private var pause_button:RichShape = new RichShape();
		private var done_flag:Boolean = false;
		private var sharing_enabled:Boolean;   
        private var bgColor:uint = 0xFA673F;
        private var sharing_bar_height:Number = 35;   
        public var 	flv:String;         
		
		private var ga_tracker:Tracking;
		private var _load_timer:Timer = new Timer(250);
		private var load_time:Number = 0; 
		
		private var _stageWidth:Number = 0;
		private var _stageHeight:Number = 0;
		
		private var _dbg:Boolean = false;
		private var params:Object;
        
        public function DemoVideoPlayer(flv:String, gaTracker:Tracking = null, sharing:Boolean = true) {
            super();
            
        	if (gaTracker != null) {
        		ga_tracker = gaTracker;
        	}    
            this.flv = flv;
            this.sharing_enabled = sharing;
            flog(this, 'SHARING:', sharing_enabled);
            
            addEventListener(Event.ADDED_TO_STAGE, addedToStage);
        }
        
        private function addedToStage(evt:Event):void {
			
			flog('stage:', 'w:', stage.stageWidth, 'h:', stage.stageHeight);
			flog('get/sets: ', 'w:', width, 'h:', height);
			
        	if (!sharing_enabled) {
        		sharing_bar_height = 0;
        	}
            _infoClient = new Object();
            _netConnection = new NetConnection();
            _netConnection.connect(null);
            _stream = new NetStream(_netConnection);
            
            _infoClient.onMetaData = function(meta:Object):void {
                for (var prop:String in meta) {
                   flog('onMetaData', prop, ':', meta[prop]);
                }
                _videoMeta = new Object();
                _videoMeta = meta;
            }
            _infoClient.onCuePoint = function(meta:Object):void {
                //flog("onCue", meta.duration);
            }
            
            _stream.client = _infoClient;
            _video = new Video(width, height);
            _video.attachNetStream(_stream);
            _video.smoothing = true;
            
            _netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            _netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
            _stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            _stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
            
            play_button.addEventListener(MouseEvent.CLICK, onPlay);
            pause_button.addEventListener(MouseEvent.CLICK, onPause);
            _video.addEventListener(Event.ENTER_FRAME, videoLoaded);
            _load_timer.start();
            
            addChild(video_bg)
            addChild(_video);
            
            pause_button.visible = false;
            _isPlaying = _isPaused = false;
            if (flv) loadVideo(flv);
            render();

        }
        
        private function loadVideo(flv:String):void {
        	this.flv = flv;
            _stream.play(flv);
            _stream.pause();
        }
        
        public function play():void {
        	_isPlaying = true;
        	_isPaused = false;
            _stream.resume();
            render();
        }
        
        public function onPlay(evt:Event):void {
            if (_isComplete) {
                flog('seek');
                _stream.seek(0);
                _isComplete = false;
                if (ga_tracker != null)
                	ga_tracker.trackEvent('replay')
            } else {
                flog('resume');
                _stream.resume();
                if (ga_tracker != null)
                	ga_tracker.trackEvent('play')
                _isPlaying = true;
            	_isPaused = false;
            } 
            render();
        }
        
        public function onPause(evt:MouseEvent):void {
        	flog('pause');
            if (_isPlaying) {
                _stream.pause();
                if (ga_tracker != null)
					ga_tracker.trackEvent('pause')
				_isPaused = true;
				_isPlaying = false;
            }
            render();
        }
        
        public function onComplete(evt:Event=null):void {
        	flog('complete');
            _isComplete = true;
            _isPaused = false;
            _isPlaying = false;
            render();
        }
        
        private function onNetStatus(evt:NetStatusEvent):void {
            switch(evt.info.code) {
                case 'NetStream.Play.Start':
                    //flog('netstatus:', evt.info.code);
                    break;
                case 'NetStream.Play.Stop':
                    //flog('netstatus:', evt.info.code);
                    onComplete();
                    break;
                case 'NetStream.Pause.Notify':
                    //flog('netstatus:', evt.info.code);
                    play_button.visible = true;
                    _isPlaying = false;
                    break;
                case 'NetStream.Unpause.Notify':
                    //flog('netstatus:', evt.info.code);   
                    _isPlaying = true;
                    break;
                case 'NetStream.Buffer.Empty':
                    //flog('netstatus:', evt.info.code);
                    break;
            }
        }
        
        private function onAsyncError(evt:Event):void {
            flog('error:', evt);
        }
        
        public function render( evt:Event=null ):void {
            renderVideo();
            renderVideoButtons();
        }
        
        private function renderVideo():void {
            var video_width:Number = width;
			var video_height:Number = height;
            _video.width = video_width; 
            _video.height = video_height;
            flog('video exist: ', _video, _video.visible, _stream);
            flog('video width: ', _video.width, 'video height:', _video.height);
        }
        
        private function renderVideoButtons():void {
			// do only once
            if (!done_flag) {
	            // create buttons
	            play_button_tri.drawTriangle(55, 55, 0xFFFFFF, 0xFFFFFF, 0);
	            play_button_bg.drawRoundedRectangle(100, 100, 4, 0x202020, 0x202020, 0x202020);
	            play_button.addChild(play_button_bg);
	            play_button.addChild(play_button_tri);
	           	play_button_tri.x = (play_button_bg.width/2) - play_button_tri.width/2;
	            play_button_tri.y += 17;
	            play_button_tri.setLabel({color:0xFFFFFF, profile:'PLAY', alpha:1, size:14});
	            play_button_tri.setLabelPosition(10, 60);
	            play_button.alpha = .90;
	            addChild(play_button);
	            
	            pause_button.drawPause(width, height, 0x000000, 0x000000,0);
	            
	            addChild(pause_button);
	            // done only once
	            done_flag = true;
            }
            with (video_bg.graphics) {
            	clear();
            }
            video_bg.drawRoundedRectangle(width, height, 0, 0x555555, 0xFFFFFF, 0xCDCDCD,0,0);
            // Center relative to video player
            play_button.x = (width/2) - play_button.width/2;
            play_button.y = (height/2) - play_button.height/2; 
            play_button.visible = pause_button.visible = false;
            pause_button.x = pause_button.y = 0;
            pause_button.alpha = 0;
            if (_isPlaying) {
                play_button.visible = false;
                pause_button.visible = true;
            } else {
                play_button.visible = true;
                pause_button.visible = false;
            }
        }
        
        private function videoLoaded(evt:Event):void {
			var percent_loaded:Number = Math.round((_stream.bytesLoaded / _stream.bytesTotal) * 100);    
			flog('VIDEO PERCENT LOADED:', percent_loaded, ' | ', percent_loaded/100);
			load_time += 250;
			flog('Load Time:', load_time)
			
			if (percent_loaded == 100) {
			 flog('Total load time:', load_time);
			 _load_timer.stop();
			 _load_timer = null;
			 if (ga_tracker != null) 
			 	ga_tracker.trackEvent('loaded', load_time);
			 _video.removeEventListener(Event.ENTER_FRAME, videoLoaded);
			 flog('event: ENTERFRAME remove');
			}
		}
		private function replace(str:String, oldSubStr:String, newSubStr:String):String {
       		return str.split(oldSubStr).join(newSubStr);
        }
        
		public function flog(...rest:*):void {
        	var _rest:String = replace(rest.toString(), ',', ' ');
        	trace(_rest);
        	if (dbg)
        		ExternalInterface.call('console.log', _rest);
        }

		override public function get width():Number {
			return _stageWidth;
		}
		
		override public function set width(value:Number):void {
			_stageWidth = value;	
		}
		
		override public function get height():Number {
			return _stageHeight;
		}
		
		override public function set height(value:Number):void {
			_stageHeight = value;
		}
		
		/**
		* GETTER: dbg:Boolean
		* @default _dbg value
		* @return _dbg value
		*/
		public function get dbg():Boolean { return _dbg; }
	}
}