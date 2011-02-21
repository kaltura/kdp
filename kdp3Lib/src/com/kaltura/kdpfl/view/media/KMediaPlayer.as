package com.kaltura.kdpfl.view.media
{
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.view.controls.BufferAnimation;
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	
	import flash.display.Sprite;
	
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.media.MediaPlayer;
	
	public dynamic class KMediaPlayer extends AdvancedLayoutPane implements IComponent
	{
		private var _player:MediaPlayer;
		private var _thumbnail : KThumbnail = new KThumbnail(); 
		private var _bgSprite : Sprite = new Sprite();		
		private var _bgColor : uint;
		private var _bgAlpha : Number;
		private var _volume : Number = 1;
		private var _bufferAnim : BufferAnimation;
		
		
		public var isFileSystemMode : Boolean;
		public function get volume() : Number{ return _volume; }
		[Bindable]
		public function set volume( value : Number ) : void 
		{ 
			_volume = value; 
			
			if(player) 
				player.volume = _volume;
		}
		
		private var _keepAspectRatio:Boolean= true;
		public function get keepAspectRatio() : String { return _keepAspectRatio.toString(); }
		public function set keepAspectRatio(value:String):void
		{
			if(value=="true")
				_keepAspectRatio=true;			
			else
				_keepAspectRatio=false;
		}
		
		private var _mediaWidth:Number;
		private var _mediaHeight:Number;
		
		private var _contentWidth:Number;
		private var _contentHeight : Number;
		
		public var bytesLoadedUpdateInterval : Number = 1000;
		public var currentTimeUpdateInterval : Number = 500;
		
		public function get player():MediaPlayer{ return _player; } //read only
		
		public function set player( p : MediaPlayer ) : void { _player = p; }
		
		public function set bufferSprite( bufferAnim : BufferAnimation ) : void
		{
			_bufferAnim = bufferAnim;
			if( ! this.parent.contains( _bufferAnim ) )
				this.parent.addChild( _bufferAnim );
			setBufferContainerSize();
		}
		
		/**
		 * Constructor 
		 * 
		 */
		public function KMediaPlayer(fileSystemMode : Boolean = false)
		{
			super();
			addChild(_bgSprite);
			
			isFileSystemMode = fileSystemMode;
			//TODO: listen and dispatch thumbnail Ready
		}
		
		//pullic
		////////////////////////////
		
		//initilize the component and set default behaviors
		public function initialize() : void 
		{
			if(_player)
			{
				removeAllListeners();
				_player = null;
			}
			
			_player = new MediaPlayer();
			_player.volume = _volume;
			_player.autoPlay = false;
			_player.loop = false;
			_player.autoRewind = false;
			
			// lower the default 250msec interval as we dont really care about rapid updates
			_player.bytesLoadedUpdateInterval = bytesLoadedUpdateInterval;
			_player.currentTimeUpdateInterval = currentTimeUpdateInterval;
			
			addAllListeners();
		}
		
		
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void
		{
			
		}
		
		public function loadThumbnail( url : String ,thumbWidth:Number, thumbHeight:Number) : void
		{
			if(!url) return; //if someone send null we won't load it
			
			_mediaWidth = thumbWidth > 0 ? thumbWidth : this.width;
			_mediaHeight = thumbHeight > 0 ? thumbHeight : this.height;
			
			_thumbnail.isFileSystemMode = isFileSystemMode;
			
			if (_keepAspectRatio)
			{
				var newDimensions : Object = getAspectratio(_mediaWidth, _mediaHeight );
				thumbWidth = newDimensions.newWidth;
				thumbHeight = newDimensions.newHeight;
			}
			else
			{
				thumbWidth = this.width;
				thumbHeight = this.height;
			}
			
			_thumbnail.width= thumbWidth;
			_thumbnail.height = thumbHeight;
			centerImages();
			
			addChild(_thumbnail);
			
			_thumbnail.load(url+"/width/"+thumbWidth+"/height/"+thumbHeight);
			
		}
		
		public function unloadThumbnail() : void
		{
			_thumbnail.unload();
		}
		
		public function hideThumbnail() : void
		{
			//didn't used the vidible because there is a bug that in Flex application
			//the FocusManager dispatch Flex event to astra UIComponent
			if (_thumbnail)
				_thumbnail.alpha = 0;
		}
		
		public function showThumbnail() : void
		{
			//didn't used the vidible because there is a bug that in Flex application
			//the FocusManager dispatch Flex event to astra UIComponent
			if (_thumbnail)
				_thumbnail.alpha = 1;
		}
		
		public function drawBg( color : uint = 0x000000, alpha : Number = 1) : void
		{	
			_bgColor = color;
			_bgAlpha = alpha;
			_bgSprite.graphics.clear();
			_bgSprite.graphics.beginFill(_bgColor,_bgAlpha);
			_bgSprite.graphics.drawRect(0,0,this.width,this.height);
			_bgSprite.graphics.endFill(); 
		}
		
		//private
		////////////////////////////
		private function setBufferContainerSize() : void
		{
			_bufferAnim.width = this.width;
			_bufferAnim.height = this.height;
		}
		
		private function addAllListeners() : void
		{
			_player.addEventListener( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE,  onDisplayObjectChange );
			
		}
		
		private function removeAllListeners() : void
		{
			_player.removeEventListener( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE,  onDisplayObjectChange );
			_player.removeEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange );
		}
		/**
		 * Dispatched when a MediaPlayer's ability to expose its media as a DisplayObject has changed. 
		 * @param event
		 * 
		 */		
		private function onDisplayObjectChange( event : DisplayObjectEvent ) : void
		{
			for (var i:int = 0; i < this.numChildren; i++ )
			{
				if (this.getChildAt(i) != this._bufferAnim && this.getChildAt(i) != this._thumbnail && this.getChildAt(i) != this._bgSprite)
				{
					this.removeChildAt(i);
				}
			}
			//if view is enabled and the player is not in the display list already
			if( _player && event.newDisplayObject)
			{
				addChild(event.newDisplayObject);
				
			}
			_player.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange );
		}
		
		private function onMediaSizeChange (e : DisplayObjectEvent) : void
		{
			_player.removeEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange );
			_mediaHeight = e.newHeight;
			_mediaWidth = e.newWidth;
			
			if(_mediaHeight && _mediaWidth && !isNaN(_mediaHeight) && !isNaN(_mediaWidth) )
			{
				if (_keepAspectRatio)
				{
					var newDimensions : Object = getAspectratio(_mediaWidth, _mediaHeight);
					
					_player.displayObject.width = newDimensions["newWidth"];
					_player.displayObject.height = newDimensions["newHeight"];
				}
				else
				{
					_player.displayObject.width = this.width;
					_player.displayObject.height = this.height;
				}
				centerImages();
			}
		}
		
		public function setContentDimension(w:Number, h:Number):void
		{
			_contentWidth = w;
			_contentHeight = h;	
		}
		
		
		/**
		 * this override gives the media player view to dynamiclly set
		 * it's size to the container size of his wrapper
		 */		
		override protected function updateChildren():void
		{	 
			//if we flashvars passed to draw backgrond
			if( _bgColor != -1 ) drawBg( _bgColor , _bgAlpha);
		}
		
		override public function set width(value:Number):void
		{
			if (value && value != this.width)
			{
				//var changeRatio : Number  = value/this.width;
				
				super.width = value;
				if(_bufferAnim)
				{
					_bufferAnim.width = value;
				}
				if(_thumbnail)
				{
					if (_keepAspectRatio)
					{
						var newThumbnailDimensions : Object = getAspectratio(_mediaWidth, _mediaHeight);
						_thumbnail.width = newThumbnailDimensions["newWidth"];
						_thumbnail.height = newThumbnailDimensions["newHeight"];
					}
					else
					{
						_thumbnail.width = this.width;
						_thumbnail.height = this.height;
					}
				}
				if (_player.displayObject)
				{
					
					if (_keepAspectRatio)
					{
						var newPlayerDimensions : Object = getAspectratio(_mediaWidth, _mediaHeight);
						_player.displayObject.width = newPlayerDimensions["newWidth"];
						_player.displayObject.height = newPlayerDimensions["newHeight"];
					}
					else
					{
						_player.displayObject.width = this.width;
						_player.displayObject.height = this.height;
					}
				}
				if (_bgSprite) _bgSprite.width = this.width;
				centerImages();
			}
		}
		
		override public function set height(value:Number):void
		{
			if (value && value != this.height)
			{
				super.height = value;
				if(_bufferAnim)
				{
					_bufferAnim.height  = value;
				}
				if(_thumbnail)
				{
					if (_keepAspectRatio)
					{
						var newThumbnailDimensions : Object = getAspectratio(_mediaWidth, _mediaHeight);
						_thumbnail.width = newThumbnailDimensions["newWidth"];
						_thumbnail.height = newThumbnailDimensions["newHeight"];
					}
					else
					{
						_thumbnail.width = this.width;
						_thumbnail.height = this.height;
					}
				}
				if (_player.displayObject)
				{
					if (_keepAspectRatio)
					{
						var newPlayerDimensions : Object = getAspectratio(_mediaWidth, _mediaHeight);
						_player.displayObject.width = newPlayerDimensions["newWidth"];
						_player.displayObject.height = newPlayerDimensions["newHeight"];
					}
					else
					{
						_player.displayObject.width = this.width;
						_player.displayObject.height = this.height;
					}
				}
				if (_bgSprite) _bgSprite.width = this.width;
				centerImages();
			}
		}
		
		private function centerImages():void
		{
			if(_player.displayObject)
			{
				_player.displayObject.x=(this.width-_player.displayObject.width)/2;
				_player.displayObject.y=(this.height-_player.displayObject.height)/2;
			}
			if(_thumbnail)
			{
				_thumbnail.x=(this.width-_thumbnail.width)/2;
				_thumbnail.y=(this.height-_thumbnail.height)/2;
			}
		}
		
		private function getAspectratio(mediaWidth:Number,mediaHeight:Number):Object
		{
			var dimensions:Object=new Object;
			if (mediaWidth > mediaHeight)
			{
				dimensions.newWidth = this.width;
				dimensions.newHeight = this.width * mediaHeight/mediaWidth;
				
				if ( dimensions.newHeight > this.height)
				{
					dimensions.newHeight = this.height;
					dimensions.newWidth = this.height *mediaWidth/mediaHeight;
				}
			}
			else
			{
				dimensions.newHeight = this.height;
				dimensions.newWidth = this.height * mediaWidth/mediaHeight;
				
				if ( dimensions.newWidth > this.width)
				{
					dimensions.newWidth = this.width;
					dimensions.height = this.width *mediaHeight/mediaWidth;
				}
			}
			
			return dimensions;  		
		}
		
		
		/**
		 * This function searches for the flavor with the preferedBitrate value bitrate among the flavors belonging to the media.
		 * @param preferedBitrate The value of the prefered bitrate to search for among the stream items of the media.
		 * @return The function returns the index of the streamItem with the prefered bitrate
		 * 
		 */		
		public function findStreamByBitrate (preferedBitrate : int) : int
		{
			var foundStreamIndex:int = -1;
			var foundStreamPropValue:int = -1;
			
			if (_player.numDynamicStreams > 0)
			{
				for(var i:int = 0; i < _player.numDynamicStreams; i++)
				{
					var b:Number = _player.getBitrateForDynamicStreamIndex(i);
					b = Math.round(b/100) * 100;
					if (b == preferedBitrate)
					{
						foundStreamPropValue = b;
						foundStreamIndex = i;
					}
				}
				
				// if a stream was found set it as the new prefered bitrate 				
				(ApplicationFacade.getInstance().retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.preferedFlavorBR = preferedBitrate;
			}
			
			return foundStreamIndex;
		}
	}
}