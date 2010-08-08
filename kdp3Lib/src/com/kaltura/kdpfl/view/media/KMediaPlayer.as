package com.kaltura.kdpfl.view.media
{
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.view.controls.PreLoader;
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
		private var _bufferAnim : PreLoader;
		
		
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
		
		private var _contentWidth:Number;
		private var _contentHeight:Number;
		
		public var bytesLoadedUpdateInterval : Number = 1000;
		public var currentTimeUpdateInterval : Number = 500;
		
		public function get player():MediaPlayer{ return _player; } //read only
		
		public function set player( p : MediaPlayer ) : void { _player = p; }

		public function set bufferSprite( bufferAnim : PreLoader ) : void
		{
			_bufferAnim = bufferAnim;
			if( ! this.parent.contains( _bufferAnim ) )
				this.parent.addChild( _bufferAnim );
			setBufferContinerSize();
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
		
		public function loadThumbnail( url : String ,contentWidth:Number, contentHeight:Number) : void
		{
			if(!url) return; //if someone send null we won't load it
			
			_contentWidth=contentWidth
			_contentHeight=contentHeight
			
			_thumbnail.isFileSystemMode = isFileSystemMode;
			
			var dimension:Object=getAspectratio(_contentWidth,_contentHeight);
			//_thumbnail.load(url+"/width/"+this.width+"/height/"+dimension.newHeight);
			_thumbnail.load(url+"/width/"+this.width+"/height/"+this.height);
		}
		
		public function unloadThumbnail() : void
		{
			_thumbnail.unload();
		}
		
		public function hideThumbnail() : void
		{
			//didn't used the vidible because there is a bug that in Flex application
			//the FocusManager dispatch Flex event to astra UIComponent
			_thumbnail.alpha = 0;
		}
		
		public function showThumbnail() : void
		{
			//didn't used the vidible because there is a bug that in Flex application
			//the FocusManager dispatch Flex event to astra UIComponent
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
		private function setBufferContinerSize() : void
		{
			_bufferAnim.width = this.width;
			_bufferAnim.height = this.height;
			updateChildren();
		}
		
		private function addAllListeners() : void
		{
			_player.addEventListener( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE,  onDisplayObjectChange );
		}
		
		private function removeAllListeners() : void
		{
			_player.addEventListener( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE,  onDisplayObjectChange );
		}
		/**
		 * Dispatched when a MediaPlayer's ability to expose its media as a DisplayObject has changed. 
		 * @param event
		 * 
		 */		
		private function onDisplayObjectChange( event : DisplayObjectEvent ) : void
		{
			//if view is enabled and the player is not in the display list already
			if( _player && _player.displayObject && !this.contains(_player.displayObject) )
			{
				addChild(_player.displayObject);
				addChild(_thumbnail);
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
			if(_player && _player.displayObject)
			{   
	    		if(_keepAspectRatio)
	    		{
	    			if (isNaN(_contentWidth) || isNaN(_contentHeight))
	    			{
						_contentWidth = width;	    					
						_contentHeight = height;	    					
	    			}
	    			
					var resultDimension:Object=getAspectratio(_contentWidth,_contentHeight);
		      		if (resultDimension.newHeight>this.height)
		      		{
		      			_player.displayObject.height= this.height;
		      			_player.displayObject.width= resultDimension.newHeight;
		      			_thumbnail.width = resultDimension.newHeight;
		      		    _thumbnail.height = this.height;
		      		}
		      		else
		      		{
			      		_player.displayObject.width = this.width;
			      		_player.displayObject.height=resultDimension.newHeight;
			      		_thumbnail.width =this.width;
			      		_thumbnail.height = resultDimension.newHeight;
		      		}
		      		
		      		
		      		
		      		if(_contentWidth<_contentHeight)//videos i.e, from Iphone
				    {
						_player.displayObject.height= this.height;
						var newAspectRatio:Number=_contentWidth/_contentHeight;
			      		_player.displayObject.width= _player.displayObject.height*newAspectRatio;
			      		_thumbnail.height =  this.height;
			      		_thumbnail.width = _player.displayObject.height*newAspectRatio;
				    }
				    
				    centerImages(); 
		    	}
			    else
				{
				    _player.displayObject.height= this.height;
		      		_player.displayObject.width= this.width;
		      		_thumbnail.width = this.width;
		      		_thumbnail.height = this.height;
				}
				
			 }
			 
	      	//if we flashvars passed to draw backgrond
	      	if( _bgColor != -1 ) drawBg( _bgColor , _bgAlpha);
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			if(_bufferAnim) _bufferAnim.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			if(_bufferAnim)  _bufferAnim.height = value;
		}
		
		private function centerImages():void
		{
			_player.displayObject.x=(this.width-_player.displayObject.width)/2;
		    _player.displayObject.y=(this.height-_player.displayObject.height)/2;
		    _thumbnail.x=(this.width-_player.displayObject.width)/2;
		    _thumbnail.y=(this.height-_player.displayObject.height)/2;
		}
		
		private function getAspectratio(W:Number,H:Number):Object
		{
			var dimensions:Object=new Object;
			var newHeight:Number=(this.width*H)/W
			dimensions.newHeight=newHeight;
      		if (newHeight>this.height)
      		{
      			var fixedHeight:Number=(this.height*W)/H
      			dimensions.newHeight=fixedHeight;
      			dimensions.fixHeight=this.height
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

				// if a stream was found set it as the new prefered height 				
				(ApplicationFacade.getInstance().retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.preferedFlavorBR = preferedBitrate;
			}
			
			return foundStreamIndex;
		}
	}
}